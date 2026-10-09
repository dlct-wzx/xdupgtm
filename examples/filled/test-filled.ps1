# 在任意目录执行本脚本，编译四类普通填充、长正文和空白回归示例。
# 超长测试：-StressMultiplier 24 -StressOnly，生成 1416 段实际正文输入。
# 依赖：XeLaTeX、Python 和 PyMuPDF；-Render 另需 Poppler 的 pdftoppm。
param(
    [string]$Xelatex = 'xelatex',
    [string]$Python = 'python',
    [ValidateRange(1, 100)][int]$StressMultiplier = 1,
    [switch]$StressOnly,
    [switch]$Render
)

$ErrorActionPreference = 'Stop'
$testRepoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))

function Build-Example([string]$Job, [string]$OutputDirectory, [string]$InputSource) {
    # 两次编译使 PDF 书签和交叉引用稳定；出错时保留日志供检查。
    for ($pass = 1; $pass -le 2; $pass++) {
        & $Xelatex -interaction=nonstopmode -halt-on-error "-jobname=$Job" "-output-directory=$OutputDirectory" $InputSource | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Compilation failed: $OutputDirectory/$Job.log"
        }
    }
    Write-Host "Built $OutputDirectory/$Job.pdf"
}

Push-Location $testRepoRoot
try {
    New-Item -ItemType Directory -Path 'output/pdf', '_qa_filled/build', '_qa_filled/blank' -Force | Out-Null
    $stressMode = 'stress'
    $stressDirectory = '_qa_filled/build'
    if ($StressMultiplier -gt 1) {
        $stressMode = 'ultralong'
        $stressDirectory = 'output/pdf'
        & $Python -X utf8 'examples/filled/generate_ultralong.py' --multiplier $StressMultiplier
        if ($LASTEXITCODE -ne 0) { throw 'Generation of ultralong TeX inputs failed.' }
    }
    foreach ($degree in @('da', 'dp', 'ma', 'mp')) {
        if (-not $StressOnly) {
            Build-Example "xdupgtm-$degree-filled" 'output/pdf' "examples/filled/xdupgtm-$degree.tex"
            Build-Example "xdupgtm-$degree-blank" '_qa_filled/blank' "examples/xdupgtm-$degree.tex"
        }
        if ($StressMultiplier -gt 1) {
            $stressInput = "_qa_filled/source/xdupgtm-$degree-ultralong.tex"
        } else {
            # 宏只对本次构建生效，无需改动正常示例源文件。
            $stressInput = "\def\xdupgtmStressTest{1}\input{examples/filled/xdupgtm-$degree.tex}"
        }
        Build-Example "xdupgtm-$degree-$stressMode" $stressDirectory $stressInput
    }
    if (-not $StressOnly) {
        Build-Example 'xdupgtm-main-blank' '_qa_filled/blank' 'xdupgtm.tex'
    }

    $verifyArguments = @('--multiplier', "$StressMultiplier")
    if ($StressOnly) { $verifyArguments += '--stress-only' }
    & $Python -X utf8 'examples/filled/verify-filled.py' @verifyArguments
    if ($LASTEXITCODE -ne 0) {
        throw 'PDF validation failed; see the report in _qa_filled/.'
    }

    if ($Render) {
        New-Item -ItemType Directory -Path '_qa_filled/render' -Force | Out-Null
        foreach ($degree in @('da', 'dp', 'ma', 'mp')) {
            if (-not $StressOnly) {
                & pdftoppm -scale-to 1200 -png "output/pdf/xdupgtm-$degree-filled.pdf" "_qa_filled/render/$degree-filled"
                if ($LASTEXITCODE -ne 0) { throw "Rendering failed: $degree-filled" }
            }
            & pdftoppm -scale-to 1200 -png "$stressDirectory/xdupgtm-$degree-$stressMode.pdf" "_qa_filled/render/$degree-$stressMode"
            if ($LASTEXITCODE -ne 0) { throw "Rendering failed: $degree-$stressMode" }
        }
    }
} finally {
    Pop-Location
}
