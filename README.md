# xdupgtm

西安电子科技大学研究生学位论文中期考核报告表 XeLaTeX 模板。模板仿照学校研究生院发布的博士、专业学位博士、学术学位硕士和专业学位硕士中期考核报告表制作，适合需要电子填写、版本管理或在线编译的场景。

## 内容

- `xdupgtm.cls`：模板文档类，提供封面、考核要求页、报告内容框、导师评价和中期总结评语页。
- `xdupgtm.tex`：可直接编辑的主示例。
- `examples/xdupgtm-*.tex`：学术博士（`da`）、专业博士（`dp`）、学术硕士（`ma`）和专业硕士（`mp`）示例。
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

## 参考与致谢

官方 Word 参考表来自西安电子科技大学研究生院相关通知，原始文件保存在 `reference/`。本模板的字体、页面结构、签名处理和学位类型设计参考并感谢开题模板仓库：[https://github.com/note286/xdupgtp](https://github.com/note286/xdupgtp)。感谢该仓库作者 note286 的开源工作。

学校模板可能会更新，正式提交前请从研究生院网站下载最新文件，并对照 `reference/网址&md5值.txt` 检查版本。

## 许可

本项目沿用 LaTeX Project Public License 1.3c，详见 [LICENSE](LICENSE)。`reference/` 中的学校 Word 文件保留原始文件，仅用于版式核对。
