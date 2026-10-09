"""生成包含实际重复正文的超长 TeX 输入，保留普通示例不变。"""

import argparse
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SECTION_COUNTS = (14, 16, 3, 16, 10)


def paragraph_template():
    source = (ROOT / "examples/filled/common.tex").read_text(encoding="utf-8")
    match = re.search(r"\\par 扩展验证段落（第\\the\\exampleParagraphCount 段）：(.*?)\\par", source)
    if not match:
        raise ValueError("The stress paragraph fixture was not found")
    return "扩展验证段落（第{number}段）：" + match.group(1)


def generate(multiplier):
    source = (ROOT / "examples/filled/common.tex").read_text(encoding="utf-8")
    counts = tuple(int(value) for value in re.findall(r"\\exampleExtraParagraphs\{(\d+)\}", source))
    if counts != SECTION_COUNTS:
        raise ValueError("The stress section counts changed; update the test expectations")
    paragraph = paragraph_template()

    def expand(match):
        count = int(match.group(1)) * multiplier
        return "\n\n".join("\\par " + paragraph.format(number=number) + "\\par" for number in range(1, count + 1))

    expanded = re.sub(r"\\exampleExtraParagraphs\{(\d+)\}", expand, source)
    directory = ROOT / "_qa_filled/source"
    directory.mkdir(parents=True, exist_ok=True)
    for degree in ("da", "dp", "ma", "mp"):
        wrapper = (ROOT / f"examples/filled/xdupgtm-{degree}.tex").read_text(encoding="utf-8")
        content = wrapper.replace("\\input{examples/filled/common.tex}",
                                  f"\\def\\xdupgtmStressTest{{1}}\n\\def\\xdupgtmStressMultiplier{{{multiplier}}}\n" + expanded)
        header = f"% 自动生成的超长测试输入，包含 {sum(counts) * multiplier} 段实际正文和五名成员签名。\n"
        path = directory / f"xdupgtm-{degree}-ultralong.tex"
        path.write_text(header + content, encoding="utf-8")
        print(f"Generated {path.name}: {path.stat().st_size} bytes")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--multiplier", type=int, default=24)
    args = parser.parse_args()
    if not 2 <= args.multiplier <= 100:
        parser.error("multiplier must be between 2 and 100")
    generate(args.multiplier)
