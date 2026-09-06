from pathlib import Path
from PIL import Image, ImageChops
import hashlib, json

root = Path(__file__).resolve().parents[1]
previous = root.parent / '2026-09-06-knowledge-upgrade/artifacts/06-word-image.png'
old = Image.open(previous).convert('RGBA')
evidence = {'renderer': 'AppKit, native font rendering', 'claimsExcluded': ['human reading performance', 'old/new Skill causal effect', 'universal aesthetic ranking']}
baseline = []
for name, region in [('plate-k', (742, 225, 1388, 885)), ('plate-r', (52, 225, 698, 885))]:
    image = Image.open(root / 'artifacts' / (name + '.png')).convert('RGBA')
    assert image.size == (646, 660)
    difference = ImageChops.difference(image, old.crop(region)).convert('RGB')
    assert difference.getbbox() is None, name
    baseline.append({'file': name + '.png', 'baselineRegion': region, 'pixelEquality': True})
evidence['actualHistoricalBaseline'] = baseline
k = Image.open(root / 'artifacts/plate-k.png').convert('RGBA')
m = Image.open(root / 'artifacts/plate-m.png').convert('RGBA')
difference = ImageChops.difference(k, m).convert('RGB')
assert difference.crop((0, 0, 646, 255)).getbbox() is None
assert difference.crop((0, 360, 646, 660)).getbbox() is None
evidence['revisionDifferenceBounds'] = difference.getbbox()
evidence['unchangedOutsideMiddleBand'] = True
runs = json.loads((root / 'artifacts/text-runs.json').read_text())
for name in ['plate-k', 'plate-m', 'plate-r']:
    text = ''.join(r['text'].replace('\n', '') for r in runs if r['plate'] == name)
    assert text == '连接需要跨过间隔', (name, text)
    for r in runs:
        if r['plate'] == name:
            assert r['y'] + r['height'] <= 660
evidence['exactCopyInAllThree'] = True
evidence['files'] = {p.name: {'size': Image.open(p).size, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted((root / 'artifacts').glob('*.png'))}
(root / 'validation/file-checks.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(evidence, ensure_ascii=False))
