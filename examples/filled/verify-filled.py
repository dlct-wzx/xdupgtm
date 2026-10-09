"""检查填充示例的内容完整性、签名位置和空白模板页数。"""

import json
import re
from pathlib import Path

import pymupdf


ROOT = Path(__file__).resolve().parents[2]
PAGE_COUNTS = {"da": 6, "dp": 7, "ma": 6, "mp": 6}
END_MARKERS = (
    "本部分的目标和研究内容已完整列出。",
    "本部分的已完成工作及阶段结论已完整列出。",
    "本部分的研究计划调整情况已完整说明。",
    "本部分的后续计划和关键技术已完整列出。",
    "本部分的成果及发表状态已完整列出。",
)


def check_pdf(path, degree, stress=False, blank=False):
    errors = []
    with pymupdf.open(path) as document:
        page_texts = [page.get_text() for page in document]
        text = re.sub(r"\s+", "", "".join(page_texts))
        if (not stress and len(document) != PAGE_COUNTS[degree]) or (
            stress and len(document) <= PAGE_COUNTS[degree]
        ):
            errors.append(f"Unexpected page count: {len(document)}")
        for index, page in enumerate(document):
            if not page_texts[index].strip():
                errors.append(f"Blank page: {index + 1}")
            # 包括所有文字和边框，检测超出纸张的内容。
            for block in page.get_text("blocks"):
                rect = pymupdf.Rect(block[:4])
                if not (page.rect + (-0.5, -0.5, 0.5, 0.5)).contains(rect):
                    errors.append(f"Text outside page: {index + 1}, {rect}")
            for drawing in page.get_drawings():
                if not (page.rect + (-0.5, -0.5, 0.5, 0.5)).contains(drawing["rect"]):
                    errors.append(f"Drawing outside page: {index + 1}")

        if not blank:
            for marker in END_MARKERS:
                if text.count(marker) != 1:
                    errors.append(f"Missing or repeated section ending: {marker}")
            expected_paragraphs = 59 if stress else 0
            if text.count("扩展验证段落") != expected_paragraphs:
                errors.append("Long-content paragraph count mismatch")
            # 按段落编号核查 14、16、3、16、10 段，避免只数到标题而丢失正文。
            if stress:
                for number in range(1, 17):
                    expected = sum(number <= count for count in (14, 16, 3, 16, 10))
                    if text.count(f"扩展验证段落（第{number}段）") != expected:
                        errors.append(f"Long-content paragraph missing: {number}")
                if text.count("为后续论文中的误差分析和工程验证提供依据。") != 59:
                    errors.append("Long-content paragraph ending missing")
            for value in ("Full-wavesimulation", "1.8", "12.5", "中期考核结论：通过"):
                if value not in text:
                    errors.append(f"Expected filled content missing: {value}")

            members = 5 if stress else 3
            # 按实际图片放置次数统计，重复使用同一资源也必须全部出现。
            if degree in ("da", "ma"):
                review_pages = [(len(document) - 1, (1, members + 1))]
            elif degree == "dp":
                review_pages = [(len(document) - 2, (1, 2)), (len(document) - 1, (members + 1,))]
            else:
                review_pages = [(len(document) - 1, (1, 2, members + 1))]

            for page_index, row_counts in review_pages:
                page = document[page_index]
                drawings = [drawing["rect"] for drawing in page.get_drawings()]
                horizontal = sorted({round(rect.y0, 2) for rect in drawings if rect.height < 1 and rect.width > 200})
                vertical = sorted({round(rect.x0, 2) for rect in drawings if rect.width < 1 and rect.height > 100})
                images = page.get_image_info()
                if len(horizontal) != len(row_counts) + 1 or len(vertical) != 3:
                    errors.append(f"Review table borders not found: {page_index + 1}")
                    continue
                if len(images) != sum(row_counts):
                    errors.append(f"Signature/date image count mismatch: {page_index + 1}")
                for row_index, expected in enumerate(row_counts):
                    cell = pymupdf.Rect(vertical[1], horizontal[row_index], vertical[-1], horizontal[row_index + 1])
                    count = sum(cell.contains(pymupdf.Rect(item["bbox"])) for item in images)
                    if count != expected:
                        errors.append(f"Signature outside expected cell: page {page_index + 1}, row {row_index + 1}")
                for index, first in enumerate(images):
                    first_rect = pymupdf.Rect(first["bbox"])
                    for second in images[index + 1:]:
                        if not (first_rect & pymupdf.Rect(second["bbox"])).is_empty:
                            errors.append(f"Signature/date images overlap: {page_index + 1}")
                    for block in page.get_text("blocks"):
                        overlap = first_rect & pymupdf.Rect(block[:4])
                        if not overlap.is_empty and overlap.get_area() > 1:
                            errors.append(f"Signature overlaps text: {page_index + 1}")
                # 五名成员必须出现多行，防止简单缩放掩盖溢出。
                if stress and page_index == len(document) - 1:
                    member_images = images[-members:]
                    if len({round(item["bbox"][1], 1) for item in member_images}) < 2:
                        errors.append("Five-member signatures did not wrap")

            fonts = {span["font"] for page in document for block in page.get_text("dict")["blocks"]
                     if "lines" in block for line in block["lines"] for span in line["spans"]}
            for expected_font in ("SimSun", "SimHei", "STZhongsong", "TimesNewRomanPSMT"):
                if not any(expected_font in font for font in fonts):
                    errors.append(f"Expected font missing: {expected_font}")

        log = path.with_suffix(".log").read_text(encoding="utf-8", errors="replace")
        if re.search(r"Overfull|Missing character|^!", log, re.MULTILINE):
            errors.append("TeX log contains overflow, missing characters or errors")
        return {"file": str(path.relative_to(ROOT)), "pages": len(document), "errors": errors}


def main():
    results = []
    for degree in PAGE_COUNTS:
        results.append(check_pdf(ROOT / f"output/pdf/xdupgtm-{degree}-filled.pdf", degree))
        results.append(check_pdf(ROOT / f"_qa_filled/build/xdupgtm-{degree}-stress.pdf", degree, stress=True))
        results.append(check_pdf(ROOT / f"_qa_filled/blank/xdupgtm-{degree}-blank.pdf", degree, blank=True))
    results.append(check_pdf(ROOT / "_qa_filled/blank/xdupgtm-main-blank.pdf", "da", blank=True))
    report = ROOT / "_qa_filled/report.json"
    report.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(results, ensure_ascii=True, indent=2))
    raise SystemExit(any(result["errors"] for result in results))


if __name__ == "__main__":
    main()
