#!/usr/local/bin/bash

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/opt/bin:/opt/sbin
find * -maxdepth 0 -type f -iname "100_*.jpg" -o -iname "RSC*.jpg" -o -iname "DSC*.jpg" -o -iname "fotos*.jpg" -o -iname "Picture*.jpg" -o -iname "IMG*.jpg" -o -name "Photo*.jpg" | while read image; do
date=$(exif -m -t "DateTimeOriginal" "$image" 2>/dev/null | awk '{ gsub(":", "-", $1); print }')
if [ "$date" == "0000-00-00 00:00:00" ]; then 
	date=""
fi
if [ -z "$date" ]; then 
date=$(stat "$image" | grep Modify | sed -e 's/^[^:]*: //' -e 's/\..*$//')
fi
if [ -n "$date" ]; then
	echo "$image $date" 1>&2
	filename=$(date -j -f "%Y-%m-%d %H:%M:%S" "$date" +'%Y-%m-%d_%H.%M.%S').jpg
	if [ "$image" != "$filename" ]; then
		echo /bin/mv -n \""$image"\" \"$filename\"
	fi
# else
# echo "Could not find date $image"
fi
done
