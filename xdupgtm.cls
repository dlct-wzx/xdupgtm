\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xdupgtm}[2026/10/08 Xidian University Postgraduate Thesis Midterm Assessment class]

% 学位类型：学术博士、专业博士、学术硕士、专业硕士
\newif\ifda\datrue
\DeclareOption{da}{\datrue}
\newif\ifdp\dpfalse
\DeclareOption{dp}{\dptrue\dafalse}
\newif\ifma\mafalse
\DeclareOption{ma}{\matrue\dafalse}
\newif\ifmp\mpfalse
\DeclareOption{mp}{\mptrue\dafalse}
% Overleaf/TeXPage 使用本地字体文件
\newif\ifoverleaf\overleaffalse
\DeclareOption{overleaf}{\overleaftrue}
\DeclareOption{texpage}{\overleaftrue}
\ProcessOptions\relax

\newif\ifddegree\ddegreefalse
\ifda\ddegreetrue\fi
\ifdp\ddegreetrue\fi
\newif\ifadegree\adegreefalse
\ifda\adegreetrue\fi
\ifma\adegreetrue\fi

\LoadClass[a4paper,zihao=-4,fontset=none]{ctexart}
\RequirePackage[bookmarksnumbered,hidelinks]{hyperref}
\RequirePackage{xurl}
\RequirePackage[most]{tcolorbox}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{xifthen}
\RequirePackage{fancyhdr}
\RequirePackage{xeCJKfntef}
\RequirePackage{environ}
\RequirePackage{graphicx}
\RequirePackage{xspace}
\RequirePackage{amssymb}
\RequirePackage{stmaryrd}
\RequirePackage{geometry}
\RequirePackage{geometry}
\graphicspath{{figures/}{figures/sign/}}
\geometry{left=3cm,right=3cm,top=2.5cm,bottom=2.5cm,footskip=0cm,headsep=0cm,headheight=0cm}

\newcommand\FakeBoldValue{3}
\newcommand\FakeSlantValue{0.2}
\ifoverleaf
  \setmainfont{times.ttf}[Path=fonts/,BoldFont=timesbd.ttf,ItalicFont=timesi.ttf,BoldItalicFont=timesbi.ttf]
  \setCJKmainfont{simsun.ttc}[Path=fonts/,BoldFont={simsun.ttc},BoldFeatures={FakeBold=\FakeBoldValue},SlantedFont={simsun.ttc},SlantedFeatures={FakeSlant=\FakeSlantValue},ItalicFont={simkai.ttf},BoldItalicFont={simkai.ttf},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\heiti{simhei.ttf}[Path=fonts/,BoldFont={simhei.ttf},BoldFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\stzhongsong{STZHONGS.TTF}[Path=fonts/,BoldFont={STZHONGS.TTF},BoldFeatures={FakeBold=\FakeBoldValue}]
\else
  \setmainfont{Times New Roman}
  \setCJKmainfont{SimSun}[BoldFont={SimSun},BoldFeatures={FakeBold=\FakeBoldValue},SlantedFont={SimSun},SlantedFeatures={FakeSlant=\FakeSlantValue},ItalicFont={KaiTi},BoldItalicFont={KaiTi},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\heiti{SimHei}[BoldFont={SimHei},BoldFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\stzhongsong{STZhongsong}[BoldFont={STZhongsong},BoldFeatures={FakeBold=\FakeBoldValue}]
\fi

\newcommand\ulthickness{1pt}
\newcommand\valueWithUL[2]{\CJKunderline[thickness=\ulthickness]{\makebox[#1]{#2}}}
\newcommand\sign[1]{\includegraphics[height=1.5em,keepaspectratio]{#1}\quad}
\newcommand\emptysign{\makebox[6em]{}}
\newcommand\zdjsqm{}
\newcommand\zdjsqmrq{年\qquad 月\qquad 日}
\newcommand\xnjsqm{}
\newcommand\xnjsqmrq{年\qquad 月\qquad 日}
\newcommand\xyjsqm{}
\newcommand\xyjsqmrq{年\qquad 月\qquad 日}
\newcommand\zzqm{}
\newcommand\cyqm{}
\newcommand\cyqmrq{年\qquad 月\qquad 日}

\ifda
  \newcommand\xdupgtmtitle{博士学位论文中期考核报告表}
\else\ifdp
  \newcommand\xdupgtmtitle{专业学位博士学位论文中期考核报告表}
\else\ifma
  \newcommand\xdupgtmtitle{硕士学位论文中期考核报告表}
\else
  \newcommand\xdupgtmtitle{专业学位硕士学位论文中期考核报告表}
\fi\fi\fi
\BeforeBeginEnvironment{document}{\hypersetup{pdftitle={\thesisTitleOne\thesisTitleTwo},pdfauthor={\authorName},pdfsubject={西安电子科技大学\xdupgtmtitle}}}

\pagestyle{empty}
\setlength{\parindent}{2em}
\setlength{\parskip}{0pt}
\setlength{\baselineskip}{20pt}
\newlength\boxmargin\setlength{\boxmargin}{5pt}
\newlength\boxrule\setlength{\boxrule}{1pt}
\tcbset{standard jigsaw,sharp corners=all,colframe=black,opacityback=0,boxsep=0pt,boxrule=\boxrule,top=\boxmargin,bottom=\boxmargin,left=\boxmargin,right=\boxmargin,beforeafter skip=0pt}
\newtcolorbox{mybox1}{before upper={\noindent\linespread{1}\fontsize{12}{20}\selectfont}}
\newtcolorbox{mybox2}{before upper={\setlength{\parindent}{2em}\linespread{1}\fontsize{12}{20}\selectfont},breakable,height fixed for=all,height fill=maximum,space to upper,lower separated=false,halign lower=flush right}
\newtcolorbox{mybox4}{before upper={\setlength{\parindent}{2em}\linespread{1}\fontsize{12}{20}\selectfont},height=.5\textheight-.3\baselineskip+0.6pt,space to upper,lower separated=false,halign lower=flush right}

% 封面与中期考核要求页，字段与官方 Word 表一致。
\AtBeginDocument{
  \begin{titlepage}
  \vspace*{-4pt}
  \begin{flushright}\zihao{3}\textbf{学号\enskip}\CJKunderline[thickness=\ulthickness]{\enskip\studentNo\enskip}\end{flushright}
  \vspace{24pt}
  \begin{center}\zihao{3}\bfseries\makebox[11em][s]{西安电子科技大学}\\[8pt]{\zihao{-2}\heiti\xdupgtmtitle}\end{center}
  \vspace{65pt}
  \begin{center}\zihao{3}
  \newlength\titleValueWidth\newlength\titleWidthOne\newlength\titleWidthTwo
  \settowidth{\titleWidthOne}{\thesisTitleOne}\settowidth{\titleWidthTwo}{\thesisTitleTwo}
  \setlength{\titleValueWidth}{\maxof{\titleWidthOne}{\titleWidthTwo}}\addtolength{\titleValueWidth}{1em}
  \textbf{论文题目：}\valueWithUL{\titleValueWidth}{\thesisTitleOne}
  \ifthenelse{\equal{\thesisTitleTwo}{}}{}{\\\phantom{\textbf{论文题目：}}\valueWithUL{\titleValueWidth}{\thesisTitleTwo}}\end{center}
  \vspace{55pt}
  \begin{center}\zihao{3}
  \renewcommand{\arraystretch}{1.45}
  \ifadegree
    \begin{tabular}{>{\bfseries}cc}姓\qquad{}名&\valueWithUL{14em}{\authorName}\\一级学科&\valueWithUL{14em}{\major}\\二级学科&\valueWithUL{14em}{\submajor}\\指导教师&\valueWithUL{14em}{\advisorName}\\学\qquad{}院&\valueWithUL{14em}{\school}\\报告日期&\valueWithUL{14em}{\submitDate}\end{tabular}
  \else\ifdp
    \begin{tabular}{>{\bfseries}lc}姓\qquad{}名&\valueWithUL{14em}{\authorName}\\学位类别&\valueWithUL{14em}{\major}\\领域（方向）&\valueWithUL{14em}{\submajor}\\指导教师&\valueWithUL{14em}{\advisorName}\\学\qquad{}院&\valueWithUL{14em}{\school}\\报告日期&\valueWithUL{14em}{\submitDate}\end{tabular}
  \else
    \begin{tabular}{>{\bfseries}lc}姓\qquad{}名&\valueWithUL{14em}{\authorName}\\学位类别&\valueWithUL{14em}{\major}\\领\qquad{}域&\valueWithUL{14em}{\submajor}\\校内导师&\valueWithUL{14em}{\advisorName}\\校外导师&\valueWithUL{14em}{\entadvisorName}\\学\qquad{}院&\valueWithUL{14em}{\school}\\报告日期&\valueWithUL{14em}{\submitDate}\end{tabular}
  \fi\fi
  \end{center}
  \vfill\begin{center}\zihao{3}西安电子科技大学研究生院制\end{center}
  \end{titlepage}\newpage
  \vspace*{-28pt}\begin{center}\stzhongsong\zihao{3}\ifddegree 西安电子科技大学博士学位论文中期考核要求\else 西安电子科技大学硕士学位论文中期考核要求\fi\end{center}
  \vspace{15pt}\zihao{-4}\setlength{\baselineskip}{28pt}\setlength{\parindent}{0pt}
  \ifddegree
    一、博士生在完成学位论文开题报告后一年内，必须进行学位论文中期考核，具体要求参照开题报告会要求执行。\par
    二、中期考核每年举行2次（6月和12月），每位博士生根据自身实际情况选择考核时间。\par
    三、中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。中期考核结果与博士生奖助金挂钩。\par
    四、在学位论文中期考核规定的时间期限内休学的博士生，中期考核的时间期限相应顺延。\par
    五、中期考核必须在规定时间内通过研究生学位管理系统申请，本表由系统自动生成，用A3纸张正反套印，在提交送审学位论文时交至所在学院。\par
    六、表格填写要求：正文字体宋体，字号小四，行间距固定值20磅。
  \else
    一、硕士生在完成学位论文开题报告后半年内，必须进行学位论文中期考核，具体要求参照开题报告会要求执行。\par
    二、中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。\par
    三、在学位论文中期考核规定的时间期限内休学的硕士生，中期考核的时间期限相应顺延。\par
    四、中期考核必须在规定时间内通过研究生学位管理系统申请，本表由系统自动生成，用A3纸张正反套印。\par
    五、表格填写要求：正文字体宋体，字号小四，行间距固定值20磅。
  \fi
  \setlength{\parindent}{2em}
  \newpage
}

\newcommand\midtermsection[2]{\vspace*{8pt}\begin{mybox2}\noindent\textbf{#1}\par\ifthenelse{\equal{#2}{}}{}{\noindent（#2）\par}}
\newcommand\midtermend{\end{mybox2}}
\newenvironment{xzlyj}{\begin{mybox1}\textbf{选题来源：}\subjectSource\end{mybox1}}{\vspace{8pt}}
\newenvironment{yjmbnr}{\midtermsection{一、学位论文研究目标及研究内容}{与开题报告中的研究目标和研究内容一致。}}{\midtermend}
\newenvironment{ywcgz}{\midtermsection{二、目前已完成学位论文工作的内容}{主要包括所完成的理论和实验研究以及所获得的结论。}}{\midtermend}
\newenvironment{bxfsm}{\midtermsection{三、现阶段完成的工作与开题报告内容不相符的情况说明}{}}{\midtermend}
\newenvironment{gzhjh}{\midtermsection{四、下一步工作计划及需要完成的研究内容和需要解决的关键技术}{}}{\midtermend}
\newenvironment{kycg}{\midtermsection{五、已发表的与学位论文相关的学术论文、其他研究成果以及拟发表的研究成果}{}}{\midtermend}

\newenvironment{jsyj}{\vspace*{8pt}\begin{mybox2}\noindent\textbf{指导教师评价意见}\par\noindent（重点写出该生的表现、计划完成情况、对后续工作情况的估计等。）\par}{\tcblower\linespread{1}\fontsize{12}{30}\selectfont 指导教师签名：\makebox[6em][l]{\zdjsqm}\\\zdjsqmrq\end{mybox2}}
\newenvironment{xnjsyj}{\vspace*{8pt}\begin{mybox4}\noindent\textbf{指导教师评价意见}\par\noindent（重点写出该生的表现、计划完成情况、对后续工作情况的估计等。）\par}{\tcblower\linespread{1}\fontsize{12}{30}\selectfont 校内指导教师签名：\makebox[6em][l]{\xnjsqm}\\\xnjsqmrq\end{mybox4}}
\newenvironment{xyjsyj}{\vspace*{8pt}\begin{mybox4}\noindent\textbf{校外指导教师评价意见}\par\noindent（重点写出该生的表现、计划完成情况、对后续工作情况的估计等。）\par}{\tcblower\linespread{1}\fontsize{12}{30}\selectfont 校外指导教师签名：\makebox[6em][l]{\xyjsqm}\\\xyjsqmrq\end{mybox4}}

\newenvironment{pyjl}{\vspace*{8pt}\begin{mybox2}\noindent\textbf{中期总结报告评语及结论}\par\noindent（中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。评语重点指出中期报告存在的问题并提出具体修改意见和建议。）\par}{\tcblower\linespread{1}\fontsize{12}{30}\selectfont 组长签名：\makebox[10em][l]{\zzqm}\\成员签名：\makebox[10em][l]{\cyqm}\\\cyqmrq\end{mybox2}}

\ctexset{section={name={,、},number={\chinese{section}},format={\raggedright\bfseries\zihao{-4}},aftername={},afterskip={0pt plus 0pt minus 0pt}}}
\endinput
