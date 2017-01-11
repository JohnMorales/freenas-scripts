#!/bin/bash
find * -mindepth 1 -type f -print0 | xargs -n1 -0 gmv --target-directory=. --backup=t
find * -type d -empty -delete
echo "Directories left: $(find * -type d)"
ls *~ | gawk '{ file = gensub(/\.([^\.]+)\.~(.+)~$/, "-\\2.\\1", "g", $0); printf("gmv --backup=t %s %s\n", $0, file); }' | bash
