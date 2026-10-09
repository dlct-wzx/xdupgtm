\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xdupgtm}[2026/10/08 Xidian University Postgraduate Thesis Midterm Assessment class]

% 学术学位博士研究生 Doctor of Academic
\newif\ifda\datrue
\DeclareOption{da}{\datrue}

% 专业学位博士研究生 Doctor of Professional
\newif\ifdp\dpfalse
\DeclareOption{dp}{\dptrue\dafalse}

% 学术学位硕士研究生 Master of Academic
\newif\ifma\mafalse
\DeclareOption{ma}{\matrue\dafalse}

% 专业学位硕士研究生 Master of Professional
\newif\ifmp\mpfalse
\DeclareOption{mp}{\mptrue\dafalse}

% Overleaf/TeXPage 使用本地字体文件
\newif\ifoverleaf\overleaffalse
\DeclareOption{overleaf}{\overleaftrue}
\DeclareOption{texpage}{\overleaftrue}
\ProcessOptions\relax

% 当前正在处理工作计划表格
\newif\ifinworkplan\inworkplanfalse
% 选题来源与下一部分是否连接
\newif\ifsourcejoined\sourcejoinedfalse

% 博士学位标志位
\newif\ifddegree\ddegreefalse
\ifda\ddegreetrue\fi
\ifdp\ddegreetrue\fi

% 学术学位标志位
\newif\ifadegree\adegreefalse
\ifda\adegreetrue\fi
\ifma\adegreetrue\fi

% 加载 ctexart 文档类
\LoadClass[a4paper,zihao=-4,fontset=none]{ctexart}
% PDF 书签
\RequirePackage[bookmarksnumbered,hidelinks]{hyperref}
% URL 自动断行
\RequirePackage{xurl}
% 绘制表格边框
\RequirePackage[most]{tcolorbox}
% 增强表格
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
% 条件判断
\RequirePackage{xifthen}
% 页面样式
\RequirePackage{fancyhdr}
% 中文下划线
\RequirePackage{xeCJKfntef}
% 自定义环境
\RequirePackage{environ}
% 签名图片
\RequirePackage{graphicx}
% 自动空格
\RequirePackage{xspace}
% 数学符号
\RequirePackage{amssymb}
\RequirePackage{stmaryrd}
% 页面尺寸
\RequirePackage{geometry}
\graphicspath{{figures/}{figures/sign/}}
\geometry{
  left=3cm,
  right=3cm,
  top=2.5cm,
  bottom=2.4cm,
  footskip=0cm,
  headsep=0cm,
  headheight=0cm
}

\newcommand\FakeBoldValue{3}
\newcommand\FakeSlantValue{0.2}
\ifoverleaf
  % 默认英文字体
  \setmainfont{times.ttf}[
    Path=fonts/,
    BoldFont=timesbd.ttf,
    ItalicFont=timesi.ttf,
    BoldItalicFont=timesbi.ttf]
  % 默认中文字体
  \setCJKmainfont{simsun.ttc}[
    Path=fonts/,
    BoldFont={simsun.ttc},BoldFeatures={FakeBold=\FakeBoldValue},
    SlantedFont={simsun.ttc},SlantedFeatures={FakeSlant=\FakeSlantValue},
    ItalicFont={simkai.ttf},
    BoldItalicFont={simkai.ttf},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  % 正文中文字体
  \newCJKfontfamily\xdupgtmsongti{simsun.ttc}[
    Path=fonts/,
    BoldFont={simsun.ttc},BoldFeatures={FakeBold=\FakeBoldValue},
    SlantedFont={simsun.ttc},SlantedFeatures={FakeSlant=\FakeSlantValue},
    ItalicFont={simkai.ttf},
    BoldItalicFont={simkai.ttf},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  % 黑体和华文中宋
  \newCJKfontfamily\heiti{simhei.ttf}[
    Path=fonts/,BoldFont={simhei.ttf},BoldFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\stzhongsong{STZHONGS.TTF}[
    Path=fonts/,BoldFont={STZHONGS.TTF},BoldFeatures={FakeBold=\FakeBoldValue}]
\else
  % 默认英文字体
  \setmainfont{Times New Roman}
  % 默认中文字体
  \setCJKmainfont{SimSun}[
    BoldFont={SimSun},BoldFeatures={FakeBold=\FakeBoldValue},
    SlantedFont={SimSun},SlantedFeatures={FakeSlant=\FakeSlantValue},
    ItalicFont={KaiTi},
    BoldItalicFont={KaiTi},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  % 正文中文字体
  \newCJKfontfamily\xdupgtmsongti{SimSun}[
    BoldFont={SimSun},BoldFeatures={FakeBold=\FakeBoldValue},
    SlantedFont={SimSun},SlantedFeatures={FakeSlant=\FakeSlantValue},
    ItalicFont={KaiTi},
    BoldItalicFont={KaiTi},BoldItalicFeatures={FakeBold=\FakeBoldValue}]
  % 黑体和华文中宋
  \newCJKfontfamily\heiti{SimHei}[
    BoldFont={SimHei},BoldFeatures={FakeBold=\FakeBoldValue}]
  \newCJKfontfamily\stzhongsong{STZhongsong}[
    BoldFont={STZhongsong},BoldFeatures={FakeBold=\FakeBoldValue}]
\fi

% 默认正文明确使用宋体和 Times New Roman；标题在使用处显式切换字体。
\newcommand\xdupgtmtextfont{\rmfamily\xdupgtmsongti}

% 自定义固定长度下划线
\newcommand\ulthickness{1pt}
\newsavebox\covervaluebox
\newcommand\valueWithUL[2]{%
  \sbox\covervaluebox{#2}%
  \CJKunderline[thickness=\ulthickness]{%
    \makebox[#1]{%
      \ifdim\wd\covervaluebox>#1
        \resizebox{#1}{!}{#2}%
      \else
        #2%
      \fi
    }%
  }%
}

% 插入签名图片
\newcommand\sign[1]{\includegraphics[height=1.5em,keepaspectratio]{#1}\quad}
\newcommand\emptysign{\hspace{6em}}

% 签名栏按内容扩宽，超过单元格剩余宽度时换行；空白栏保留官方宽度。
\newsavebox\signaturecontentbox
\newlength\signaturewidth
\newlength\signatureavailablewidth
\newcommand\signatureline[3]{%
  \begingroup
  \sbox\signaturecontentbox{#3}%
  \settowidth{\signatureavailablewidth}{#1}%
  \setlength{\signatureavailablewidth}{\dimexpr\linewidth-\signatureavailablewidth\relax}%
  \setlength{\signaturewidth}{\maxof{#2}{\wd\signaturecontentbox}}%
  #1%
  \ifdim\signaturewidth>\signatureavailablewidth
    \parbox[t]{\signatureavailablewidth}{\raggedright #3}%
  \else
    \makebox[\signaturewidth][l]{\usebox\signaturecontentbox}%
  \fi
  \endgroup}
% 定义签名命令
\newcommand\zdjsqm{}
\newcommand\xnjsqm{}
\newcommand\xyjsqm{}
\newcommand\zzqm{}
\newcommand\cyqm{}
% 定义手写日期命令
\newcommand\zdjsqmrq{年\qquad 月\qquad 日}
\newcommand\xnjsqmrq{年\qquad 月\qquad 日}
\newcommand\xyjsqmrq{年\qquad 月\qquad 日}
\newcommand\cyqmrq{年\qquad 月\qquad 日}

% 设置 PDF 标题
\ifda
  \newcommand\xdupgtmtitle{博士学位论文中期考核报告表}
\else
  \ifdp
    \newcommand\xdupgtmtitle{专业学位博士学位论文中期考核报告表}
  \else
    \ifma
      \newcommand\xdupgtmtitle{硕士学位论文中期考核报告表}
    \else
      \newcommand\xdupgtmtitle{专业学位硕士学位论文中期考核报告表}
    \fi
  \fi
\fi

% 设置 PDF 元数据
\BeforeBeginEnvironment{document}{
  \hypersetup{
    pdftitle={\thesisTitleOne\thesisTitleTwo},
    pdfauthor={\authorName},
    pdfsubject={西安电子科技大学\xdupgtmtitle}
  }
}

\pagestyle{empty}
\setlength{\parindent}{2em}
\setlength{\parskip}{0pt}
\setlength{\baselineskip}{20pt}
\newlength\boxmargin\setlength{\boxmargin}{5bp}
\newlength\boxrule\setlength{\boxrule}{0.5bp}
\tcbset{standard jigsaw,sharp corners=all,colframe=black,opacityback=0,boxsep=0pt,boxrule=\boxrule,top=\boxmargin,bottom=\boxmargin,left=\boxmargin,right=\boxmargin,beforeafter skip=0pt}
\newtcolorbox{mybox1}{before upper={\xdupgtmtextfont\noindent\linespread{1}\fontsize{12}{20}\selectfont}}
\newtcolorbox{mybox2}[1][]{before upper={\xdupgtmtextfont\setlength{\parindent}{2em}\linespread{1}\fontsize{12bp}{20bp}\selectfont},breakable=unlimited,height fixed for=all,height fill=maximum,space to upper,lower separated=false,halign lower=flush right,#1}
\newtcolorbox{mybox4}{before upper={\xdupgtmtextfont\setlength{\parindent}{2em}\linespread{1}\fontsize{12}{20}\selectfont},height=.5\textheight-.3\baselineskip+0.6pt,space to upper,lower separated=false,halign lower=flush right}
\newtcolorbox{mybox3}{before upper={\xdupgtmtextfont\setlength{\parindent}{2em}\linespread{1}\fontsize{12bp}{20bp}\selectfont},top=1.7bp,breakable=unlimited,height fixed for=all,height fill=maximum,space to upper}
\newlength\sideboxheight
\newlength\reviewrowheight
\newlength\reviewrowtwoheight
\newlength\reviewrowthreeheight
\newbox\worksectionbox
\newbox\worksectionmeasurebox
\newbox\worksectionheadbox
\newlength\worksectiongap
\newtcolorbox{myboxside}{frame hidden,boxrule=0pt,top=0pt,bottom=0pt,left=0pt,right=0pt,boxsep=0pt,beforeafter skip=0pt}

% 封面与中期考核要求页，字段与官方 Word 表一致。
\AtBeginDocument{
  \xdupgtmtextfont
  \begin{titlepage}
  % 学号
  \vspace*{-25pt}
  \begin{flushright}\zihao{3}\textbf{学号\enskip}\valueWithUL{5.5em}{\studentNo}\end{flushright}
  % 标题
  \vspace{39.5pt}
  \begin{center}\zihao{3}{\bfseries\makebox[11.75em][s]{西安电子科技大学}}\\[5.7pt]{\zihao{-2}\heiti\xdupgtmtitle}\end{center}
  % 论文题目
  \vspace{111.9pt}
  {\zihao{3}
  \newlength\titleValueWidth\newlength\titleWidthOne\newlength\titleWidthTwo
  \settowidth{\titleWidthOne}{\thesisTitleOne}\settowidth{\titleWidthTwo}{\thesisTitleTwo}
  \setlength{\titleValueWidth}{\maxof{\titleWidthOne}{\titleWidthTwo}}\addtolength{\titleValueWidth}{1em}
  \ifdim\titleValueWidth<17em\setlength{\titleValueWidth}{17em}\fi
  \ifdim\titleValueWidth>\dimexpr\linewidth-5em\relax\setlength{\titleValueWidth}{\dimexpr\linewidth-5em\relax}\fi
  \noindent\textbf{论文题目：}\valueWithUL{\titleValueWidth}{\thesisTitleOne}
  \ifthenelse{\equal{\thesisTitleTwo}{}}{}{\\\phantom{\textbf{论文题目：}}\valueWithUL{\titleValueWidth}{\thesisTitleTwo}}\par}
  \ifmp\vspace{50.2pt}\else\vspace{80.2pt}\fi
  % 基本信息
  \begin{center}\zihao{3}
  \renewcommand{\arraystretch}{1.385}
  \ifadegree
    \begin{tabular}{>{\bfseries}cc}
      姓\qquad{}名 & \valueWithUL{9em}{\authorName}\\
      一级学科 & \valueWithUL{9em}{\major}\\
      二级学科 & \valueWithUL{9em}{\submajor}\\
      指导教师 & \valueWithUL{9em}{\advisorName}\\
      学\qquad{}院 & \valueWithUL{9em}{\school}\\
      报告日期 & \valueWithUL{9em}{\submitDate}
    \end{tabular}
  \else\ifdp
    \begin{tabular}{>{\bfseries}lc}
      姓\qquad{}名 & \valueWithUL{9em}{\authorName}\\
      学位类别 & \valueWithUL{9em}{\major}\\
      领域（方向） & \valueWithUL{9em}{\submajor}\\
      指导教师 & \valueWithUL{9em}{\advisorName}\\
      学\qquad{}院 & \valueWithUL{9em}{\school}\\
      报告日期 & \valueWithUL{9em}{\submitDate}
    \end{tabular}
  \else
    \begin{tabular}{>{\bfseries}lc}
      姓\qquad{}名 & \valueWithUL{9em}{\authorName}\\
      学位类别 & \valueWithUL{9em}{\major}\\
      领\qquad{}域 & \valueWithUL{9em}{\submajor}\\
      校内导师 & \valueWithUL{9em}{\advisorName}\\
      校外导师 & \valueWithUL{9em}{\entadvisorName}\\
      学\qquad{}院 & \valueWithUL{9em}{\school}\\
      报告日期 & \valueWithUL{9em}{\submitDate}
    \end{tabular}
  \fi\fi
  \end{center}
  % 制表单位
  \vfill\begin{center}\zihao{3}西安电子科技大学研究生院制\end{center}
  \end{titlepage}\newpage
  % 中期考核要求
  \vspace*{-56pt}\begin{center}{\stzhongsong\zihao{3}\ifddegree 西安电子科技大学博士学位论文中期考核报告要求\else 西安电子科技大学硕士学位论文中期考核报告要求\fi}\end{center}
  \vspace{15pt}\xdupgtmtextfont\zihao{-4}\setlength{\baselineskip}{28pt}\setlength{\parindent}{2em}\par
  \ifddegree
    \indent 一、博士生在完成学位论文开题报告后一年内，必须进行学位论文中期考核，\ifda 会议由各学院统一组织，\fi{}具体要求参照开题报告会要求执行。\par
    \ifda
      二、中期考核每年举行2次（6月和12月），每位博士生根据自身实际情况选择考核时间。\par
    \else
      二、每位博士生根据自身实际情况选择考核时间。\par
    \fi
    三、中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。中期考核结果与博士生奖助金挂钩。\par
    四、在学位论文中期考核规定的时间期限内休学的博士生，中期考核的时间期限相应顺延。\par
    五、中期考核必须在规定时间内通过研究生学位管理系统申请，本表由系统自动生成，用A3纸张正反套印，在提交送审学位论文时交至所在学院。\par
    六、表格填写要求：正文字体宋体，字号小四，行间距固定值20磅。
  \else
    \indent 一、硕士生在完成学位论文开题报告后半年内，必须进行学位论文中期考核，会议由各学院自行组织，具体要求参照开题报告会要求执行。\par
    二、中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。\par
    三、在学位论文中期考核规定的时间期限内休学的硕士生，中期考核的时间期限相应顺延。\par
    四、中期考核必须在规定时间内通过研究生学位管理系统申请，本表由系统自动生成，用A3纸张正反套印。\par
    五、表格填写要求：正文字体宋体，字号小四，行间距固定值20磅。
  \fi
  \setlength{\parindent}{2em}
  \ifddegree
    \newgeometry{left=83bp,right=83bp,top=43bp,bottom=138.5bp}
  \else
    \newgeometry{left=83bp,right=83bp,top=63bp,bottom=118.5bp}
  \fi
}

\newcommand\midtermsection[2]{%
  \ifsourcejoined
    \tcbset{toprule=0pt}%
  \fi
  \noindent\begin{mybox2}
  \noindent\textbf{#1}\par
  \ifthenelse{\equal{#2}{}}{}{\indent（#2）\par}%
}
\newcommand\midtermend{\end{mybox2}}
% 选题来源
\newenvironment{xzlyj}{%
  \noindent\begin{mybox1}
  \textbf{选题来源：}\subjectSource
  \end{mybox1}%
}{\global\sourcejoinedtrue}
% 研究目标与研究内容
\newenvironment{yjmbnr}{%
  \midtermsection{一、学位论文研究目标及研究内容}{与开题报告中的研究目标和研究内容一致。}%
}{%
  \midtermend
  \global\sourcejoinedfalse
}
% 已完成工作及结论
\newenvironment{ywcgz}{%
  \midtermsection{二、目前已完成学位论文工作的内容}{主要包括所完成的理论和实验研究以及所获得的结论。}%
}{\midtermend}
% 页面尺寸在环境外切换，避免环境结束后恢复旧尺寸影响输出。
\BeforeBeginEnvironment{ywcgz}{\newgeometry{left=83bp,right=83bp,top=63bp,bottom=133.5bp}}
\BeforeBeginEnvironment{workplan}{\newgeometry{left=83bp,right=83bp,top=63bp,bottom=58.5bp}}
% 第三至第五部分共用一个可自动续页的表格。
\NewEnviron{workplan}{
  \noindent
  \begin{mybox3}
  \inworkplantrue
  \BODY
  \inworkplanfalse
  \end{mybox3}
}
% 空白表中前两部分各占 180 磅；填入正文后只补足不足的高度。
\newcommand\worksectionstart[1]{\setbox\worksectionbox=\vbox\bgroup\hsize=\linewidth\noindent\strut\textbf{#1}\par}
% 仅测量前 180 磅；整块超长内容的高度可能超出 TeX 的长度或整数上限。
\newcommand\worksectionend{%
  \par\egroup
  \begingroup
  \setlength{\worksectiongap}{0pt}%
  \vbadness=10000\vfuzz=\maxdimen
  \setbox\worksectionmeasurebox=\copy\worksectionbox
  \setbox\worksectionheadbox=\vsplit\worksectionmeasurebox to180bp
  \ifvoid\worksectionmeasurebox
    \setbox\worksectionheadbox=\vbox{\unvbox\worksectionheadbox}%
    \setlength{\worksectiongap}{\maxof{0pt}{180bp-\ht\worksectionheadbox-\dp\worksectionheadbox}}%
  \fi
  \unvbox\worksectionbox\vspace*{\worksectiongap}%
  \endgroup}
% 三、与开题报告不相符的情况说明
\newenvironment{bxfsm}{
  \ifinworkplan
    \worksectionstart{三、现阶段完成的工作与开题报告内容不相符的情况说明}
  \else
    \vspace*{8pt}
    \begin{mybox3}
    \noindent\textbf{三、现阶段完成的工作与开题报告内容不相符的情况说明}\par
  \fi
}{%
  \ifinworkplan
    \worksectionend
  \else
    \end{mybox3}
    \newpage
  \fi
}
% 四、下一步工作计划及需要完成的研究内容和需要解决的关键技术
\newenvironment{gzhjh}{
  \ifinworkplan
    \worksectionstart{四、下一步工作计划及需要完成的研究内容和需要解决的关键技术}
  \else
    \vspace*{8pt}
    \begin{mybox3}
    \noindent\textbf{四、下一步工作计划及需要完成的研究内容和需要解决的关键技术}\par
  \fi
}{%
  \ifinworkplan
    \worksectionend
  \else
    \end{mybox3}
    \newpage
  \fi
}
% 五、论文及其他研究成果
\newenvironment{kycg}{
  \ifinworkplan
    \noindent\strut\textbf{五、已发表的与学位论文相关的学术论文、其他研究成果以及拟发表的研究成果}\par
  \else
    \vspace*{8pt}
    \begin{mybox3}
    \noindent\textbf{五、已发表的与学位论文相关的学术论文、其他研究成果以及拟发表的研究成果}\par
  \fi
}{%
  \ifinworkplan
  \else
    \end{mybox3}
    \newpage
  \fi
}

% 评价页按官方表格采用左侧竖排标签，具体表格在 pyjl 环境中统一输出。
\newcommand\advisorBody{}
\newcommand\schoolAdvisorBody{}
\newcommand\externalAdvisorBody{}
\newcommand\advisorLabel{\parbox[c]{12bp}{\centering 指\\导\\教\\师\\评\\价\\意\\见}}
\newcommand\conclusionLabel{\parbox[c]{12bp}{\centering 中\\期\\总\\结\\报\\告\\评\\语\\及\\结\\论}}
% 固定高度行的基线在中部；合并标签向下移动第二行高度的一半。
\newcommand\combinedAdvisorLabel{\raisebox{-0.5\reviewrowtwoheight}[0pt][0pt]{\advisorLabel}}
\NewEnviron{jsyj}{\global\let\advisorBody\BODY}
\NewEnviron{xnjsyj}{\global\let\schoolAdvisorBody\BODY}
\NewEnviron{xyjsyj}{\global\let\externalAdvisorBody\BODY}

\newcommand\reviewPrompt{（重点写出该生的表现、计划完成情况、对后续工作情况的估计等。）}
\newcommand\reviewConclusionPrompt{（中期考核结论分为两种：1.通过，按专家意见修改后继续学位论文撰写工作；2.不通过，重新考核。评语重点指出中期报告存在的问题并提出具体修改意见和建议。）}
\newcommand\reviewcell[2]{\parbox[c][#1][s]{\linewidth}{\vskip5bp\noindent #2\par\vskip5bp}}
\newcommand\academicReview{
  \ifda
    \setlength{\reviewrowheight}{320bp}\setlength{\reviewrowtwoheight}{380bp}
  \else
    \setlength{\reviewrowheight}{270.5bp}\setlength{\reviewrowtwoheight}{420.5bp}
  \fi
  \noindent\begin{tabularx}{\linewidth}{|>{\centering\arraybackslash}p{12bp}|X|}
  \hline
  \advisorLabel & \reviewcell{\reviewrowheight}{\reviewPrompt\par\advisorBody\par\vfill\raggedleft \signatureline{指导教师签名：}{7em}{\zdjsqm}\\\zdjsqmrq}\\
  \hline
  \conclusionLabel & \reviewcell{\reviewrowtwoheight}{\reviewConclusionPrompt\par\BODY\par\vfill\raggedleft \signatureline{组长签名：}{7em}{\zzqm}\\\signatureline{成员签名：}{7em}{\cyqm}\\\cyqmrq}\\
  \hline
  \end{tabularx}
}
\newcommand\professionalDoctorReview{
  \setlength{\reviewrowheight}{320bp}\setlength{\reviewrowtwoheight}{380bp}
  \noindent\begin{tabularx}{\linewidth}{|>{\centering\arraybackslash}p{12bp}|X|}
  \hline
  \combinedAdvisorLabel & \reviewcell{\reviewrowheight}{\reviewPrompt\par\schoolAdvisorBody\par\vfill\raggedleft \signatureline{校内指导教师签名：}{5em}{\xnjsqm}\\\xnjsqmrq}\\
  \cline{2-2}
  & \reviewcell{\reviewrowtwoheight}{\externalAdvisorBody\par\vfill\raggedleft \signatureline{校外指导教师签名：}{5em}{\xyjsqm}\\\xyjsqmrq}\\
  \hline
  \end{tabularx}
}
\newcommand\professionalMasterReview{
  \setlength{\reviewrowheight}{160bp}\setlength{\reviewrowtwoheight}{137.5bp}\setlength{\reviewrowthreeheight}{400bp}
  \noindent\begin{tabularx}{\linewidth}{|>{\centering\arraybackslash}p{12bp}|X|}
  \hline
  \combinedAdvisorLabel & \reviewcell{\reviewrowheight}{\reviewPrompt\par\schoolAdvisorBody\par\vfill\raggedleft \signatureline{校内指导教师签名：}{6em}{\xnjsqm}\\\xnjsqmrq}\\
  \cline{2-2}
  & \reviewcell{\reviewrowtwoheight}{\externalAdvisorBody\par\vfill\raggedleft \signatureline{校外指导教师签名：}{6em}{\xyjsqm}\\\xyjsqmrq}\\
  \hline
  \conclusionLabel & \reviewcell{\reviewrowthreeheight}{\reviewConclusionPrompt\par\BODY\par\vfill\raggedleft \signatureline{组长签名：}{10em}{\zzqm}\\[20bp]\signatureline{成员签名：}{10em}{\cyqm}\\[20bp]\cyqmrq}\\
  \hline
  \end{tabularx}
}
\newcommand\standaloneConclusion{
  \newgeometry{left=75.5bp,right=75.5bp,top=43bp,bottom=77.5bp}
  \setlength{\reviewrowheight}{720bp}
  \noindent\begin{tabularx}{\linewidth}{|>{\centering\arraybackslash}p{12bp}|X|}
  \hline
  \conclusionLabel & \reviewcell{\reviewrowheight}{\reviewConclusionPrompt\par\BODY\par\vfill\raggedleft \signatureline{组长签名：}{7em}{\zzqm}\\\signatureline{成员签名：}{7em}{\cyqm}\\[20bp]\cyqmrq}\\
  \hline
  \end{tabularx}
}
\BeforeBeginEnvironment{pyjl}{\newgeometry{left=75.5bp,right=75.5bp,top=63bp,bottom=77.5bp}}
\NewEnviron{pyjl}{
  \xdupgtmtextfont\linespread{1}\fontsize{12bp}{20bp}\selectfont
  \renewcommand{\arraystretch}{1}\setlength{\arrayrulewidth}{0.5bp}
  \ifadegree
    \academicReview
  \else\ifdp
    \professionalDoctorReview\newpage\standaloneConclusion
  \else
    \professionalMasterReview
  \fi\fi
  \par\clearpage
}

% 设置编辑器大纲章节样式；模板源码中的章节命令位于条件分支中，不输出到表格。
\ctexset{
  section={
    name={,、},
    number={\chinese{section}},
    format={\raggedright\xdupgtmtextfont\bfseries\zihao{-4}},
    aftername={},
    afterskip={0pt plus 0pt minus 0pt}
  }
}
\endinput
