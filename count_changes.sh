#!/bin/bash

REPO="$1"
if ! [[ "$REPO" = /* ]]; then
	REPO="$PWD"/$(echo `dirname "$REPO"`/`basename "$REPO"`)
else
	REPO=$(echo `dirname "$REPO"`/`basename "$REPO"`)
fi

DOTS="$REPO"_dots

cd "$DOTS/out_dots/coldot"

truncate --size 0 count_red
truncate --size 0 count_green

# cat "$REPO/tagnames" | xargs -n 1 -I {} rg --count "#ff5c33" "out_"{}"_col.dot" >> count_red
# cat "$REPO/tagnames" | xargs -n 1 -I {} rg --count "#85e085" "out_"{}"_col.dot" >> count_green

for tag in `cat "$REPO/tagnames"`; do
	rg --count "#ff5c33" "out_"$tag"_col.dot" >> count_red
	if [[ $? -eq 1 ]]; then
		echo "0" >> count_red
	fi
done

for tag in `cat "$REPO/tagnames"`; do
	rg --count "#85e085" "out_"$tag"_col.dot" >> count_green
	if [[ $? -eq 1 ]]; then
		echo "0" >> count_green
	fi
done

latestTag=$(tail -n 1 "$REPO/tagnames")
wc -l "$REPO/diffs/cls_"$latestTag | cut -d" " -f1 > "$REPO/diffs/ctotal"