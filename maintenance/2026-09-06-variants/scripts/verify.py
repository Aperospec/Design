from pathlib import Path
from PIL import Image, ImageChops
import json, hashlib, subprocess

root=Path(__file__).resolve().parents[1]
prior=root.parent/'2026-09-06-word-image/artifacts'
def read(name): return Image.open(root/'artifacts'/f'{name}.png').convert('RGB')
def equal(a,b): return ImageChops.difference(a,b).getbbox() is None
checks={}
for name,old in [('s17','plate-m'),('s24','plate-r')]:
    a=read(name);b=Image.open(prior/f'{old}.png').convert('RGB')
    assert equal(a,b)
    checks[name]={'historicalFile':str((prior/f'{old}.png').relative_to(root.parent)),'allPixelsEqual':True}
for name,base in [('s41','s17'),('s05','s24')]:
    assert equal(read(name),read(base).crop((0,0,430,660)))
    checks[name]={'mechanicalCropOf':base,'pixelsEqualToCrop':True,'excludedFromMainAdaptationComparison':True}
assert equal(read('s32').crop((0,385,646,660)),read('s24').crop((0,385,646,660)))
checks['s32']={'lowerDiagramPixelsUnchanged':True}
diff=ImageChops.difference(read('s08'),read('s56'))
box=diff.getbbox();assert box is not None
assert 163<=box[0]<=box[2]<=575 and 255<=box[1]<=box[3]<=458
checks['s56']={'actualDifferenceBoundsFromS08':box,'allChangesWithinEnlargedBridge':True}
records=json.loads((root/'artifacts/text-records.json').read_text())
expected={name:('连接需要跨过两个区域之间的间隔' if name in ['s08','s32','s56','s83','s90'] else '连接需要跨过间隔') for name in ['s17','s24','s08','s32','s41','s05','s67','s72','s56','s83','s90']}
for name,copy in expected.items():
    rows=[r for r in records if r['file']==name]
    assert ''.join(r['text'].replace('\n','') for r in rows)==copy
    scale=430/646 if name in ['s67','s72'] else 1
    assert all(abs(r['localToPixelScale']-scale)<1e-12 for r in rows)
    checks.setdefault(name,{})['copyInRenderingSource']=copy
    checks[name]['sourceCopyMatches']=True
    checks[name]['outputScale']=scale
    checks[name]['approximateFontSizesInPixels']=[r['sourceFontSize']*scale for r in rows]
before=[{k:v for k,v in r.items() if k!='file'} for r in records if r['file']=='s08']
after=[{k:v for k,v in r.items() if k!='file'} for r in records if r['file']=='s56']
assert before==after
checks['s56']['textLayoutRecordsUnchanged']=True
assert equal(read('s90').crop((0,385,646,660)),read('s32').crop((0,385,646,660)))
checks['s90']['lowerDiagramPixelsUnchanged']=True
checks['s90']['sourceFontSizeUnchanged']=True
for r in records:
    if r['file']=='s90':assert r['sourceFontSize']==60
d=ImageChops.difference(read('s56'),read('s83')).getbbox();assert d is not None
assert 163<=d[0]<=d[2]<=575 and 255<=d[1]<=d[3]<=458
checks['s83']['actualDifferenceBoundsFromS56']=d
checks['s83']['allChangesWithinExistingBridge']=True
# Read actual pixels at the two landing areas and intervening span. These
# narrowly verify rendered marks, not reader understanding or general quality.
ratio=430/646;offset=(660-660*ratio)/2
def sample(name,x,y):return list(read(name).getpixel((round(x*ratio),round(y*ratio+offset))))
checks['s67']['actualBridgeSamples']={key:sample('s67',x,348) for key,x in [('leftLanding',210),('gap',326),('rightLanding',450)]}
assert len({tuple(v) for v in checks['s67']['actualBridgeSamples'].values()})==1
checks['s72']['actualLineSamples']={key:sample('s72',x,406) for key,x in [('leftEndpoint',180),('gap',326),('rightEndpoint',463)]}
assert checks['s72']['actualLineSamples']['leftEndpoint']==checks['s72']['actualLineSamples']['rightEndpoint']
assert checks['s72']['actualLineSamples']['gap']!=checks['s72']['actualLineSamples']['leftEndpoint']
files={}
for name in expected:
    p=root/'artifacts'/f'{name}.png'
    im=Image.open(p);assert im.size==((430,660) if name in ['s41','s05','s67','s72'] else (646,660))
    im.verify()
    files[p.name]={'pixels':read(name).size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
record={'checks':checks,'files':files,'scope':'Actual PNG pixels plus renderer records. Source text equality is not proof of visible readability. Independent viewing records provide the separate visual assessment. No human or device test.'}
(root/'validation/file-checks.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'historicalBaselinesEqual':2,'verifiedPNGs':len(files),'onlyBridgeChangedInLongRepair':True,'scope':record['scope']},ensure_ascii=False))
