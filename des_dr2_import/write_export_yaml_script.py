#!/usr/bin/env python

import write_export_yaml as wey

butler = wey.daf_butler.Butler("/repo/main")
collections = ["DECam/defaults/ToOPreparedness"]
yaml_folder = "./yaml_file"
outfile = "./yamlOut.yaml"

wey.write_export_yaml(butler,collections,yaml_folder,outfile)