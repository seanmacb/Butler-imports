import os
import glob
import astropy.table

# output directory to save .ecsv files
outdir = "/home/smacbr"

# full paths to LSST sharded reference catalogues
# gaiadr3 = "/shares/soares-santos.physik.uzh/refcats/GAIA_DR3/gaia_dr3"
panstarrsps1 = "/shares/soares-santos.physik.uzh/refcats/ps1_pv3_3pi"

refcat_dirs = [
# gaiadr3, 
panstarrsps1,
]

# loop over each FITS file in all refcats
# note: this constructs a series of .ecsv files, each containing two columns:
# 1) the FITS filename, and 2) the htm7 pixel index
for refcat_dir in refcat_dirs:

    outfile = f"{outdir}/{os.path.basename(refcat_dir)}.ecsv"
    print(f"Saving to: {outfile}")

    table = astropy.table.Table(names=("filename", "htm7"), dtype=("str", "int"))
    files = glob.glob(f"{refcat_dir}/[0-9]*.fits")

    for ii, file in enumerate(files):
        print(f"{ii}/{len(files)} ({100*ii/len(files):0.1f}%)", end="\r")
        # try/except to catch extra .fits files which may be in this dir
        try:
            file_index = int(os.path.basename(os.path.splitext(file)[0]))
        except ValueError:
            continue
        else:
            table.add_row((file, file_index))

    table.write(outfile)
