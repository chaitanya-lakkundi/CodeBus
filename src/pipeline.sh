#!/bin/bash

# 1 Generate doxygen documentation
	# 1 Get all tag names
	# 2 Generate documentation
	# 3 Copy only dot files outside the repository (may not be !keeping folder structure)
	# 4 Checkout to other tag/release and continue

MYDIR="$PWD"
REPO=$(realpath "$1")

if [ ! -d "$REPO" ]; then
	echo "$REPO does not exist"
	exit
fi

DOTS="$REPO"_dots

mkdir -p "$DOTS"

cd "$REPO"
git tag --sort=creatordate > tagnames

echo -e "\nThis repository contains $(wc -l tagnames) releases."
echo -e "\nPlease enter the index number of every release (in ascending order) that you wish to keep and analyze."
echo -e "\nYour can enter range by specifying such as 2-5 -> staring from 2, totally 5 elements -> includes 2,3,4,5,6"
echo -e "\nOne argument per line. Either range or single number. Then press enter.\n"
echo -e "     0  $(head -n 1 tagnames)"
/bin/cat -n <(tail -n +2 tagnames)

alltags=($(cat tagnames | tr "\n" " "))

truncate .tags --size 0

while read data; do
	if [[ $data =~ "-" ]]; then
		pos=($(echo $data | tr "-" "\n"))	
		echo ${alltags[@]:${pos[0]}:${pos[1]}} | tee -a .tags
	else
		echo ${alltags[$data]} | tee -a .tags
	fi
	echo -e "\n\nPress Ctrl+D to break and proceed. (OR) Enter another index number or range \n\n"
done

cat .tags | uniq | tr " " "\n" > tagnames

git checkout master # assuming master exists

echo -e "\n--start--\n" >> "$REPO/stats"
echo >> "doxygen"
cp "$MYDIR/Doxyfile" "$REPO/"

for vs in `cat "$REPO/tagnames"`; do
	git checkout tags/"$vs"

	echo "$vs" >> "$REPO/stats"
	date >> "$REPO/stats"
	
	doxygen > /dev/null 2>&1
	date >> "$REPO/stats"

	mkdir -p "$DOTS/$vs"
	find . -name "*.dot" | xargs -n 100 cp -t "$DOTS/$vs"

	rm -rf html
done

git checkout master
cd ..

# 2 Integrate Class Diagrams

echo -e "\n--pip2--\n" >> "$REPO/stats"

echo -e "\nIntegrate Nodes\n" >> "$REPO/stats"
date >> "$REPO/stats"

cd "$MYDIR"
python3 integrate_nodes.py "$REPO"

date >> "$REPO/stats"

# 3 Generate Class Labels

cd "$REPO"
mkdir -p "$REPO/diffs"

for vs in `cat "$REPO/tagnames"`;do 
	grep -P -o "\[label=\".*?\"" "$DOTS/out_dots"/"out_$vs.dot" | cut -d"=" -f2 | tr -d '"' | sort | uniq > "$REPO/diffs/cls_$vs"
done

# Correct Syntax

find "$DOTS/out_dots" -name "*.dot" -exec sed -i '/\]\"$/d' {} \;

# 4 Generate diffs

cd "$REPO/diffs"

pr=$(head -n 1 "$REPO/tagnames")
for cur in `cat "$REPO/tagnames"`;do 
	diff "cls_$pr" "cls_$cur" > "diff_$cur"
	pr=$cur
done
touch "$REPO/diffs/diff_dummyend"

cd "$REPO"

# 5 Colorize
echo -e "\nColorize Dots\n" >> "$REPO/stats"
date >> "$REPO/stats"

cd "$MYDIR"
python3 colorize_dots.py "$REPO"

date >> "$REPO/stats"

# 6 Generate PDF

cd "$DOTS/out_dots/coldot"
flatTagsPDF=$(for tn in `cat "$REPO/tagnames"`; do echo out_"$tn"_col.pdf; done | tr "\n" " ")

echo -e "\n--Dot to PDF--\n" >> "$REPO/stats"

for vs in `cat "$REPO/tagnames"`; do
	echo "$vs" >> "$REPO/stats"
	date >> "$REPO/stats"
	echo "generating dot for $vs"
	dot -Tpdf out\_"$vs"\_col.dot -o out\_"$vs"\_col.pdf &
	date >> "$REPO/stats"
done

wait

cd "$MYDIR"
bash count_changes.sh "$REPO"
python3 plot_graph.py "$REPO"

cd "$DOTS/out_dots/coldot"
qpdf --empty --pages $flatTagsPDF -- "$REPO/"$(basename "$REPO")-evolution.pdf
