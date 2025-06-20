# DES DR2 import

This folder contains scripts and code related to importing the DES DR2 coadds to USDF.

The import follows two general steps:
1. Importing the data to usdf from [NCSA](https://desdr-server.ncsa.illinois.edu/despublic/dr2_tiles/)
   - Importing the data to usdf was performed by creating a list of urls to the fits.fz files using [`curlScraper_DESDR2.sh`](https://github.com/seanmacb/Butler-imports/blob/main/des_dr2_import/oldFiles/curlScraper_DESDR2.sh) (steps 1-2 only)
   - Downloading from that list using [`download_fits_files.sh`](https://github.com/seanmacb/Butler-imports/blob/main/des_dr2_import/download_fits_files.sh).
2. Registering the data with the Butler
   - This required some tricks to do so, most of which are included in [`MakeButlerIngestFile.ipynb`](https://github.com/seanmacb/Butler-imports/blob/main/des_dr2_import/makeButlerIngestFile.ipynb)

