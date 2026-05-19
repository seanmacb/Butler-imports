from astropy.utils.exceptions import AstropyWarning
import warnings
from astropy.io import ascii
from astropy.table import Table
from astropy.io import fits
from astropy.wcs import WCS

def check_fits_file(path):
    try:
        with warnings.catch_warnings(record=True) as w:
            warnings.simplefilter("always", category=AstropyWarning)

            with fits.open(path, memmap=True) as hdul:
                hdul.verify('silentfix')

            # If any warnings were triggered, print them
            if w:
                print(f"⚠️  Warnings in '{path}':")
                for warn in w:
                    print(f"  - {warn.message}")
                return path
        return None

    except Exception as e:
        print(f"❌ Error opening '{path}': {e}")
        return None

path2="tableFile.csv"

table2=ascii.read(path2)

paths = []
for f in table2["filename"]:
    p = check_fits_file(f)
    if p!=None:
        paths.append(p)
print(paths)