from pathlib import Path
import os,shutil,subprocess,tempfile
root=Path(__file__).resolve().parents[1]
dart=os.environ.get('DART_BIN','dart')
with tempfile.TemporaryDirectory(prefix='activity-models-') as folder:
    target=Path(folder)
    (target/'tool').mkdir()
    for name in ['generate_activity_models.py','activity_models.json','activity_rules.json']:
        shutil.copyfile(root/'tool'/name,target/'tool'/name)
    shutil.copyfile(root/'pubspec.yaml',target/'pubspec.yaml')
    subprocess.run(['python3',str(target/'tool/generate_activity_models.py')],check=True)
    subprocess.run([dart,'format','--language-version=3.10',str(target/'lib/activity_core/models')],check=True,stdout=subprocess.DEVNULL)
    generated=target/'lib/activity_core/models'
    expected=root/'lib/activity_core/models'
    if {p.name for p in generated.glob('*.dart')}!={p.name for p in expected.glob('*.dart')}:
        raise SystemExit('Generated model file inventory differs')
    changed=[p.name for p in generated.glob('*.dart') if p.read_bytes()!=(expected/p.name).read_bytes()]
    if changed: raise SystemExit('Regeneration differs: '+', '.join(changed))
print('Generated model sources match their definitions.')
