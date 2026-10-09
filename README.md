# xdupgtm

西安电子科技大学研究生学位论文中期考核报告表 XeLaTeX 模板。模板仿照学校研究生院发布的博士、专业学位博士、学术学位硕士和专业学位硕士中期考核报告表制作，适合需要电子填写、版本管理或在线编译的场景。

## 内容

- `xdupgtm.cls`：模板文档类，提供封面、考核要求页、报告内容框、导师评价和中期总结评语页。
- `xdupgtm.tex`：可直接编辑的主示例。
- `examples/xdupgtm-*.tex`：学术博士（`da`）、专业博士（`dp`）、学术硕士（`ma`）和专业硕士（`mp`）示例。
- `examples/filled/`：四类带完整正文、表格、导师意见和签名的填充示例，以及可重复运行的测试脚本。
- `reference/`：本模板使用的学校官方 Word 参考表、由 Microsoft Word 原生导出的同名 PDF，以及链接、MD5 记录。PDF 用于逐页核对字体、表格和分页。

## 使用

使用 TeX Live 2021 或更新版本的 XeLaTeX 编译：

```shell
xelatex xdupgtm
```

也可以使用 `latexmk`：

```shell
latexmk
```

本地编译需要宋体、黑体、楷体、华文中宋和 Times New Roman；Windows 上华文中宋通常随 Microsoft Office 提供。GNU/Linux、macOS、Overleaf 或 TeXPage 请自行准备这些字体；在线平台可在项目中建立 `fonts/` 目录，上传 `simsun.ttc`、`simkai.ttf`、`simhei.ttf`、`STZHONGS.TTF` 以及 Times New Roman 的常规、粗体、斜体和粗斜体文件，并使用：

```latex
\documentclass[ma,overleaf]{xdupgtm}
```

本仓库不分发字体文件。

在 `xdupgtm.tex` 中填写学号、论文题目、姓名、学科或领域、导师、学院、报告日期和选题来源。默认是学术学位博士，切换其他类型时在文档类后增加选项，例如：

```latex
\documentclass[ma]{xdupgtm}
```

专业学位模板的评价页包含校内导师和校外导师两栏，并分别生成评价意见和签名位置。需要插入电子签名时，将签名图片放入 `figures/sign/`，然后取消示例文件中的对应注释。

成员签名可用 `\sign{图片路径}\emptysign\sign{图片路径}` 依次填写。签名栏根据内容自动扩宽；多张签名超过单元格可用宽度时自动换行。签名图片默认高 `1.5em`，保持原始宽高比，宜使用裁去多余空白的图片。

正文各部分使用以下环境。第三至第五部分放在 `workplan` 环境中，合用一个表格；填写内容超出一页时，正文表格会自动续页：

```latex
\begin{xzlyj}\end{xzlyj}
\begin{yjmbnr}内容\end{yjmbnr}
\begin{ywcgz}内容\end{ywcgz}
\begin{workplan}
\begin{bxfsm}内容\end{bxfsm}
\begin{gzhjh}内容\end{gzhjh}
\begin{kycg}内容\end{kycg}
\end{workplan}
```

`jsyj`（学术学位）或 `xnjsyj`、`xyjsyj`（专业学位）填写导师意见，随后使用 `pyjl` 填写总结评语及结论。评价表保留官方的固定高度，意见过长时应精简文字，避免超出单元格。

## 官方 PDF 核对

`reference/` 中的四份 `.doc` 均已由 Microsoft Word 导出为同名 PDF。空白模板与参考文件的页数一致：

| 类型 | 页数 | 评价页结构 |
| --- | --- | --- |
| 学术博士（`da`） | 6 | 导师意见与总结结论合用第 6 页 |
| 专业博士（`dp`） | 7 | 校内、校外导师意见在第 6 页，总结结论在第 7 页 |
| 学术硕士（`ma`） | 6 | 导师意见与总结结论合用第 6 页 |
| 专业硕士（`mp`） | 6 | 校内、校外导师意见及总结结论合用第 6 页 |

已按 PDF 核对要求页的首行缩进、选题来源与第一部分的连续边框、第三至第五部分的位置，以及评价表的左右分栏、合并标签和签名区。报告表标题使用黑体，考核要求页标题使用华文中宋，其余中文使用宋体，西文使用 Times New Roman。

## 填充与签名测试

`examples/filled/xdupgtm-*.tex` 是四类实际填充示例，共用带中文注释的 `common.tex`，包含两行题目、正文段落、编号列表、实验数据表、研究计划、导师意见和考核结论。普通填充示例使用三名成员签名；校外导师日期使用图片，其余日期使用文字。示例中的人员、项目、数据和成果均为虚构，签名与图片日期取自参考仓库的公开测试素材。

在仓库根目录编译，例如：

```shell
xelatex -jobname=xdupgtm-ma-filled -output-directory=output/pdf examples/filled/xdupgtm-ma.tex
xelatex -jobname=xdupgtm-ma-filled -output-directory=output/pdf examples/filled/xdupgtm-ma.tex
```

首次使用时请先建立 `output/pdf/` 目录。运行全部测试可使用 PowerShell 脚本，依赖 XeLaTeX、Python 和 PyMuPDF：

```powershell
./examples/filled/test-filled.ps1
```

可用 `-Xelatex` 和 `-Python` 指定程序路径。加上 `-Render` 会调用 Poppler 的 `pdftoppm` 渲染全部普通与长正文测试页，供人工核对。

脚本同时构建四份普通填充 PDF、四份长正文测试 PDF、四份空白示例及主示例。长正文模式每类增加 59 段文字和五名成员签名，测试正文续页及签名换行。自动检查包括各部分末尾文字、全部扩展段落、签名和图片日期的实际出现次数及单元格边界、图片与文字重叠、字体、空白页、纸张边界以及 TeX 溢出日志。

普通填充 PDF 位于 `output/pdf/`，页数依次为学术博士 6 页、专业博士 7 页、学术硕士 6 页和专业硕士 6 页。长正文 PDF、空白回归 PDF、渲染图片及检查报告位于 `_qa_filled/`。这些生成文件不纳入 Git，填充示例、测试脚本和公开示例图片纳入 Git。

### 超长正文测试

超长测试会生成包含实际正文的四份 `.tex` 文件，每份约 0.8 MB，包含 1,416 段扩展正文，编译后约 27 万字符。在仓库根目录执行：

```powershell
./examples/filled/test-filled.ps1 -StressMultiplier 24 -StressOnly
```

`-StressMultiplier` 控制原有 59 段压力正文的倍数，`-StressOnly` 只构建压力版本；不加此选项时同时回归普通填充和空白示例。加上 `-Render` 可渲染全部页面。生成的实际 TeX 输入位于 `_qa_filled/source/`，PDF 位于 `output/pdf/xdupgtm-*-ultralong.pdf`，检查报告位于 `_qa_filled/ultralong-report.json`。

| 类型 | 超长测试页数 | 扩展段落数 |
| --- | --- | --- |
| 学术博士（`da`） | 257 | 1,416 |
| 专业博士（`dp`） | 258 | 1,416 |
| 学术硕士（`ma`） | 257 | 1,416 |
| 专业硕士（`mp`） | 257 | 1,416 |

测试发现并修复了两类极长正文问题：第三、第四部分计算补白高度时触发 TeX 长度溢出，以及普通分页模式在极大内容量下成功编译却丢失后半段正文。模板现在只测量前 180 磅来判断补白，并使用 `tcolorbox` 提供的 `breakable=unlimited` 分页模式。

检查脚本逐部分核对每段编号、顺序和完整文字，逐页检查表格边框及正文范围，并验证末尾评价表中的五名成员签名和图片日期。导师意见与考核评语仍使用官方固定高度的评价单元格，本项超长测试扩展的是第一至第五部分正文。

## 参考与致谢

官方 Word 参考表来自西安电子科技大学研究生院相关通知，原始文件保存在 `reference/`。本模板的字体、页面结构、签名处理和学位类型设计参考并感谢开题模板仓库：[https://github.com/note286/xdupgtp](https://github.com/note286/xdupgtp)。感谢该仓库作者 note286 的开源工作。

学校模板可能会更新，正式提交前请从研究生院网站下载最新文件，并对照 `reference/网址&md5值.txt` 检查版本。

## 许可

本项目沿用 LaTeX Project Public License 1.3c，详见 [LICENSE](LICENSE)。`reference/` 中的学校 Word 文件保留原始文件，仅用于版式核对。
