from pathlib import Path
import os,subprocess,tempfile
root=Path(__file__).resolve().parents[1]
files=['activity_traveler_validation.dart','attraction_distance_text.dart','trippl_activites_rating_double.dart']
text='// Extracted from the preserved FlutterFlow helper files by the verification tool.\n'
for name in files:
    source=(root/'lib/custom_code/functions'/name).read_text()
    text+='\n'+'\n'.join(line for line in source.splitlines() if not line.startswith('import '))+'\n'
with tempfile.TemporaryDirectory(prefix='activities-helpers-') as folder:
    target=Path(folder)/'legacy_helpers.dart';target.write_text(text)
    subprocess.run([os.environ.get('DART_BIN','dart'),'format','--language-version=3.10',str(target)],check=True,stdout=subprocess.DEVNULL)
    if target.read_bytes()!=(root/'test/legacy_helpers.dart').read_bytes():raise SystemExit('Legacy helper test extraction differs from production source')
print('Legacy regression tests use the exact current helper implementations.')
