# xdupgtm

西安电子科技大学研究生学位论文中期考核报告表 XeLaTeX 模板，依据学校官方 Word 表格制作，支持学术博士、专业博士、学术硕士和专业硕士。

## 文件介绍

- `xdupgtm.cls`：文档类，生成封面、考核要求、正文表格、导师评价和考核结论。
- `xdupgtm.tex`：空白主模板，保留字段说明和填写注释，默认使用学术博士版式。
- `examples/xdupgtm-*.tex`：四种学位类型的空白模板。
- `latexmkrc`：XeLaTeX 编译配置。

## 使用方法

填写主模板或对应学位模板中的基本信息和正文，在仓库根目录编译：

```shell
xelatex xdupgtm.tex
```

也可以执行 `latexmk`，或直接编译对应学位模板：

```shell
xelatex examples/xdupgtm-ma.tex
```

学位类型由文档类选项指定，例如 `\documentclass[ma]{xdupgtm}`。


所有模板的学号、题目、姓名、学科或领域、导师、学院、日期和选题来源均为空，只保留填写说明。

## 字体与环境

使用 TeX Live 2021 或更新版本的 XeLaTeX。本地需要宋体、黑体、楷体、华文中宋和 Times New Roman；华文中宋通常随 Microsoft Office 提供。本仓库不分发字体文件。

报告表标题使用黑体，考核要求页标题使用华文中宋，其余中文使用宋体，西文使用 Times New Roman。

Overleaf、TeXPage 或其他未安装这些字体的平台，可建立 `fonts/` 目录，放入 `simsun.ttc`、`simkai.ttf`、`simhei.ttf`、`STZHONGS.TTF`、`times.ttf`、`timesbd.ttf`、`timesi.ttf` 和 `timesbi.ttf`，然后使用：

```latex
\documentclass[ma,overleaf]{xdupgtm}
```

## 正文与签名

正文使用以下环境，第三至第五部分保留 `workplan` 外层环境，合用一个自动续页的表格：

| 环境 | 内容 |
| --- | --- |
| `xzlyj` | 选题来源，通过 `subjectSource` 字段填写 |
| `yjmbnr` | 研究目标与研究内容 |
| `ywcgz` | 已完成的工作及结论 |
| `bxfsm` | 与开题报告不相符的情况说明 |
| `gzhjh` | 下一步工作计划与关键技术 |
| `kycg` | 论文及其他研究成果 |
| `jsyj` | 学术学位指导教师评价 |
| `xnjsyj`、`xyjsyj` | 专业学位校内、校外导师评价 |
| `pyjl` | 中期考核评语与结论 |

导师评价及考核结论采用官方固定高度的单元格，填写意见时应控制篇幅。

电子签名图片放入 `figures/sign/`，修改模板中对应的注释代码后启用。`\sign{图片路径}` 插入签名，`\emptysign` 为相邻签名预留空白；多张签名超过可用宽度时自动换行。签名日期可填写文字，也可使用图片。

## 参考与致谢

官方参考表来自西安电子科技大学研究生院相关通知，

- [学术博士](https://gr.xidian.edu.cn/info/1047/7160.htm)
- [专业博士](https://gr.xidian.edu.cn/info/1047/7803.htm)
- [学术硕士](https://gr.xidian.edu.cn/info/1047/5087.htm)
- [专业硕士](https://gr.xidian.edu.cn/info/1047/5086.htm)

本模板的字体、页面结构、签名处理和学位类型设计参考并感谢开题模板仓库：[https://github.com/note286/xdupgtp](https://github.com/note286/xdupgtp)。感谢作者 note286 的开源工作。

正式提交前请核对研究生院发布的最新表格。

## 许可

本项目沿用 LaTeX Project Public License 1.3c，详见 [LICENSE](LICENSE)。学校参考文件仅用于版式核对。
