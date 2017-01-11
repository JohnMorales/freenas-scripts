#!/usr/local/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
find * -maxdepth 0 -type f \( -iname "100_*.jpg" -o -iname "RSC*.jpg" -o -iname "DSC*.jpg" -o -iname "fotos*.jpg" -o -iname "Picture*.jpg" -o -iname "IMG*.jpg" -o -iname "Photo*.jpg" -o -iname "imag*.jpg" \) | while read image; do
date=$(exif -m -t "DateTimeOriginal" "$image" 2>/dev/null | awk '{ gsub(":", "-", $1); print }')
if [ "$date" == "0000-00-00 00:00:00" ]; then
	date=""
fi
if [ -z "$date" ]; then
  date=$(stat -f %Sm -t '%Y-%m-%d %H:%M:%S' "$image")
fi
if [ -n "$date" ]; then
	filename=$(date -j -f "%Y-%m-%d %H:%M:%S" "$date" +'%Y-%m-%d_%H.%M.%S').jpg
	if [ "$image" != "$filename" ]; then
		echo gmv --backup=t \""$image"\" \"$filename\"
	fi
else
	echo "Could not find date $image" 1>&2
fi
done
find * -type f -iname "*.png" | while read image; do
  date=$(stat -f %Sm -t '%Y-%m-%d %H:%M:%S' "$image")
  if [ -n "$date" ]; then
    filename=$(date -j -f "%Y-%m-%d %H:%M:%S" "$date" +'%Y-%m-%d_%H.%M.%S').png
    if [ "$image" != "$filename" ]; then
      echo gmv --backup=t \""$image"\" \"$filename\";
    fi
  fi
done
find * -type f \( -iname "*.mov" -o -iname "*mp4" \) | while read movie; do
  mediainfo=$(mediainfo "$movie")
  ext=${movie##*.}
  ext=${ext,,}
  date_str=$(echo "$mediainfo" | awk '/com.apple.quicktime.creationdate/ { print $3 }')
  if [ -z "$date_str" ]; then
    date_str=$(echo "$mediainfo" | awk '/Encoded date/ { sub(/[^:]+: /, "", $0); print $0; exit; }')
    if [ -z "$date_str" ]; then
      date_str=$(stat -f %Sm -t '%Y-%m-%d %H:%M:%S' "$movie")
      date_fmt=$(date -j -f "%Y-%m-%d %H:%M:%S" "$date_str" +'%Y-%m-%d_%H.%M.%S')
    else
      date_fmt=$(date -j -f "%Z %Y-%m-%d %T" "$date_str" +'%Y-%m-%d_%H.%M.%S')
    fi
    if [ -n $"date_fmt" ]; then
      filename=$date_fmt.$ext
    fi
  else
    date_fmt=$(date -j -f %Y-%m-%dT%T%z "$date_str" +'%Y-%m-%d_%H.%M.%S')
    if [ -n $"date_fmt" ]; then
      filename=$date_fmt.$ext
    fi
  fi
	if [ -n "$filename" ] && [ "$movie" != "$filename" ]; then
    echo gmv --backup=t \""$movie"\" \"$filename\"
  fi
done

