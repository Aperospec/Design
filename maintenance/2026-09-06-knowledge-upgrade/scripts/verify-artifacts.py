"""Read final pixels independently of the drawing program. Maintenance only."""
import json
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
art = root / "artifacts"
im = Image.open(art / "02-quantity.png").convert("RGB")
marks = []
for column, (left, right) in enumerate([(125, 370), (580, 825), (1035, 1270)]):
    for row, (top, bottom) in enumerate([(330, 455), (465, 615), (615, 768)]):
        pixels = []
        for y in range(top, bottom):
            for x in range(left, right):
                r, g, b = im.getpixel((x, y))
                if r > 130 and r > 1.45 * g and r > 1.8 * b:
                    pixels.append((x, y))
        assert pixels, (column, row)
        xs, ys = zip(*pixels)
        marks.append({"column": column, "row": row, "pixels": len(pixels),
                      "width": max(xs)-min(xs)+1, "height": max(ys)-min(ys)+1,
                      "bounds": [min(xs), min(ys), max(xs), max(ys)]})
ratios = [marks[2]["pixels"] / marks[0]["pixels"],
          marks[5]["pixels"] / marks[3]["pixels"],
          marks[8]["width"] / marks[6]["width"]]
assert abs(ratios[0]-4) < 0.06 and abs(ratios[1]-2) < 0.04 and abs(ratios[2]-2) < 0.04
m = json.loads((art / "metrics.json").read_text())
assert not any(x["canvasOverflow"] for x in m["textBounds"])
assert all(m["linebreak"][x] for x in ["beforePreservesCharacters", "afterPreservesCharacters"])
dot_positions = {layout: [x["decimalX"] for x in m["numerals"] if x["layout"] == layout]
                 for layout in ["right", "decimal"]}
dot_spread = {k: max(v)-min(v) for k, v in dot_positions.items()}
assert dot_spread["right"] > 0 and dot_spread["decimal"] < 0.001
runs = json.loads((art / "font-runs.json").read_text())
ga = [x for x in runs if x["requested"] == "Georgia"]
assert "".join(x["text"] for x in ga) == ga[0]["sample"]
assert any(x["actual"] != "Georgia" for x in ga)
files = {}
for p in sorted(list(art.glob("*.png")) + list((root / "forward").glob("*.png"))):
    with Image.open(p) as img:
        img.verify()
    with Image.open(p) as img:
        files[str(p.relative_to(root))] = {"format": img.format, "size": img.size}
result = {"method": "threshold actual PNG pixels in each mark's separate region; ratios approximate due to antialiasing",
          "marks": marks, "rasterRatios": ratios, "numeralDecimalSpreadPx": dot_spread,
          "fontRunsMatchDisplayedSample": True, "linebreakCharactersPreserved": True,
          "files": files, "limitation": "file/geometry/rendered-text checks, not human perception or effectiveness"}
(art / "pixel-measurements.json").write_text(json.dumps(result, ensure_ascii=False, indent=2)+"\n")
print(json.dumps({"rasterRatios": ratios, "decimalSpread": dot_spread, "openedPngFiles":len(files)}, indent=2))
