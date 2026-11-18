from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[1]
def signatures(text):
    text=re.sub(r'//[^\n]*','',text)
    pattern=r'^[A-Za-z_][\w<>,? ]* ([A-Za-z_]\w*)\s*\((.*?)\)\s*(?:async\s*)?\{'
    return {name:re.sub(r'\s+','',args) for name,args in re.findall(pattern,text,re.M|re.S)}
if __name__=='__main__':
    expected=json.loads((root/'tool/host_interfaces.json').read_text())
    for path,contracts in expected.items():
        actual=signatures((root/path).read_text())
        for name,args in contracts.items():
            if actual.get(name,'').rstrip(',')!=args.rstrip(','): raise SystemExit(f'Host interface changed: {path}: {name}')
    print(f'Host parameter interfaces match across {len(expected)} original files.')

