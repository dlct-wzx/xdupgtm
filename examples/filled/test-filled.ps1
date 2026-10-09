# 在任意目录执行本脚本，编译四类普通填充、长正文和空白回归示例。
# 依赖：XeLaTeX、Python 和 PyMuPDF；-Render 另需 Poppler 的 pdftoppm。
param(
    [string]$Xelatex = 'xelatex',
    [string]$Python = 'python',
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
    foreach ($degree in @('da', 'dp', 'ma', 'mp')) {
        Build-Example "xdupgtm-$degree-filled" 'output/pdf' "examples/filled/xdupgtm-$degree.tex"
        # 宏只对本次构建生效，无需改动正常示例源文件。
        Build-Example "xdupgtm-$degree-stress" '_qa_filled/build' "\def\xdupgtmStressTest{1}\input{examples/filled/xdupgtm-$degree.tex}"
        Build-Example "xdupgtm-$degree-blank" '_qa_filled/blank' "examples/xdupgtm-$degree.tex"
    }
    Build-Example 'xdupgtm-main-blank' '_qa_filled/blank' 'xdupgtm.tex'

    & $Python -X utf8 'examples/filled/verify-filled.py'
    if ($LASTEXITCODE -ne 0) {
        throw 'PDF validation failed; see _qa_filled/report.json.'
    }

    if ($Render) {
        New-Item -ItemType Directory -Path '_qa_filled/render' -Force | Out-Null
        foreach ($degree in @('da', 'dp', 'ma', 'mp')) {
            & pdftoppm -scale-to 1200 -png "output/pdf/xdupgtm-$degree-filled.pdf" "_qa_filled/render/$degree-filled"
            if ($LASTEXITCODE -ne 0) { throw "Rendering failed: $degree-filled" }
            & pdftoppm -scale-to 1200 -png "_qa_filled/build/xdupgtm-$degree-stress.pdf" "_qa_filled/render/$degree-stress"
            if ($LASTEXITCODE -ne 0) { throw "Rendering failed: $degree-stress" }
        }
    }
} finally {
    Pop-Location
}
