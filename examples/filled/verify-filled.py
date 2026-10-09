"""检查填充示例的内容完整性、签名位置和空白模板页数。"""

import argparse
import json
import re
from pathlib import Path

import pymupdf

from generate_ultralong import SECTION_COUNTS, paragraph_template


ROOT = Path(__file__).resolve().parents[2]
PAGE_COUNTS = {"da": 6, "dp": 7, "ma": 6, "mp": 6}
END_MARKERS = (
    "本部分的目标和研究内容已完整列出。",
    "本部分的已完成工作及阶段结论已完整列出。",
    "本部分的研究计划调整情况已完整说明。",
    "本部分的后续计划和关键技术已完整列出。",
    "本部分的成果及发表状态已完整列出。",
)


def check_pdf(path, degree, stress=False, blank=False, multiplier=1):
    errors = []
    with pymupdf.open(path) as document:
        page_texts = [page.get_text() for page in document]
        text = re.sub(r"\s+", "", "".join(page_texts))
        if (not stress and len(document) != PAGE_COUNTS[degree]) or (
            stress and len(document) <= PAGE_COUNTS[degree]
        ):
            errors.append(f"Unexpected page count: {len(document)}")
        if multiplier >= 12 and len(document) < 100:
            errors.append("Ultralong test unexpectedly has fewer than 100 pages")
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
            # 每张正文页的全部文字均应落在该页表格边框内；容许中文标点的字形边界。
            review_page_count = 2 if degree == "dp" else 1
            for page_index in range(2, len(document) - review_page_count):
                page = document[page_index]
                frames = [item["rect"] for item in page.get_drawings()
                          if item["rect"].width > 400 and item["rect"].height > 100]
                if not frames:
                    errors.append(f"Body table frame missing: {page_index + 1}")
                    continue
                frame = pymupdf.Rect(frames[0])
                for rect in frames[1:]:
                    frame |= rect
                # 第一张正文页还包含与主框连在一起的选题来源行。
                for drawing in page.get_drawings():
                    if drawing["rect"].width > 400:
                        frame |= drawing["rect"]
                line_rects = []
                for block in page.get_text("dict")["blocks"]:
                    for line in block.get("lines", []):
                        rect = pymupdf.Rect(line["bbox"])
                        line_rects.append(rect)
                        if not (frame + (-4, -4, 4, 4)).contains(rect):
                            errors.append(f"Body text outside table: {page_index + 1}")
                for index, first in enumerate(line_rects):
                    if any((first & second).get_area() > 4 for second in line_rects[index + 1:]):
                        errors.append(f"Body text lines overlap: {page_index + 1}")
            for marker in END_MARKERS:
                if text.count(marker) != 1:
                    errors.append(f"Missing or repeated section ending: {marker}")
            expected_paragraphs = sum(SECTION_COUNTS) * multiplier if stress else 0
            if text.count("扩展验证段落") != expected_paragraphs:
                errors.append("Long-content paragraph count mismatch")
            # 逐部分检查段落顺序和完整文字，捕获成功编译却悄悄丢失正文的情况。
            if stress:
                paragraph = re.sub(r"\s+", "", paragraph_template())
                section_start = 0
                for section_index, (count, marker) in enumerate(zip(SECTION_COUNTS, END_MARKERS), 1):
                    section_end = text.find(marker, section_start)
                    if section_end < 0:
                        continue
                    section = text[section_start:section_end]
                    expected_numbers = list(range(1, count * multiplier + 1))
                    actual_numbers = [int(value) for value in re.findall(r"扩展验证段落（第(\d+)段）", section)]
                    if actual_numbers != expected_numbers:
                        errors.append(f"Paragraph sequence mismatch: section {section_index}")
                    for number in expected_numbers:
                        if section.count(paragraph.format(number=number)) != 1:
                            errors.append(f"Paragraph incomplete: section {section_index}, number {number}")
                    section_start = section_end + len(marker)
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
        return {"file": str(path.relative_to(ROOT)), "pages": len(document),
                "text_characters": len(text), "extra_paragraphs": expected_paragraphs if not blank else 0,
                "errors": errors}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--multiplier", type=int, default=1)
    parser.add_argument("--stress-only", action="store_true")
    args = parser.parse_args()
    if not 1 <= args.multiplier <= 100:
        parser.error("multiplier must be between 1 and 100")
    results = []
    for degree in PAGE_COUNTS:
        if not args.stress_only:
            results.append(check_pdf(ROOT / f"output/pdf/xdupgtm-{degree}-filled.pdf", degree))
            results.append(check_pdf(ROOT / f"_qa_filled/blank/xdupgtm-{degree}-blank.pdf", degree, blank=True))
        if args.multiplier > 1:
            stress_path = ROOT / f"output/pdf/xdupgtm-{degree}-ultralong.pdf"
        else:
            stress_path = ROOT / f"_qa_filled/build/xdupgtm-{degree}-stress.pdf"
        results.append(check_pdf(stress_path, degree, stress=True, multiplier=args.multiplier))
    if not args.stress_only:
        results.append(check_pdf(ROOT / "_qa_filled/blank/xdupgtm-main-blank.pdf", "da", blank=True))
    report_name = "ultralong-report.json" if args.multiplier > 1 else "report.json"
    report = ROOT / f"_qa_filled/{report_name}"
    report.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(results, ensure_ascii=True, indent=2))
    raise SystemExit(any(result["errors"] for result in results))


if __name__ == "__main__":
    main()
