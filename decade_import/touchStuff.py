from pathlib import Path
from astropy.io import ascii
TABLE_FILE = "tableFile.csv"
table = ascii.read(TABLE_FILE)
for t in table['filename']:
    Path(str(t)).touch()