#!/bin/bash

# 1 Generate doxygen documentation
	# 1 Get all tag names
	# 2 Generate documentation
	# 3 Copy only dot files outside the repository (may not be !keeping folder structure)
	# 4 Checkout to other tag/release and continue

REPO=$1
REPO=$PWD/$(echo `dirname $REPO`/`basename $REPO`)
cp Doxyfile "$REPO"

DOTS=$REPO\_dots
mkdir -p "$DOTS"

cd "$REPO"
git tag > tagnames
git checkout master

for vs in `cat "$REPO/tagnames"`; do
	git checkout tags/"$vs"
	doxygen > /dev/null 2>&1
	mkdir -p "$DOTS/$vs"
	find . -name "*.dot" | xargs -n 100 cp -t "$DOTS/$vs"
	rm -rf html
done

git checkout master
cd ..

# 2 Integrate Class Diagrams

cd "$REPO/.."
python3 integrate_nodes.py "$REPO"

# 3 Generate Class Labels

cd "$REPO"
mkdir -p "$REPO/diffs"

for vs in `cat "$REPO/tagnames"`;do 
	grep -P -o "label=\".*?\"" "$DOTS/out_dots"/"out_$vs.dot" | cut -d"=" -f2 | tr -d '"' | sort | uniq > "$REPO/diffs/cls_$vs"
done

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

cd "$REPO/.."
python3 colorize_dots.py "$REPO"

# 6 Generate PDF

cd "$DOTS/out_dots/coldot"
flatTagsPDF=$(for tn in `cat "$REPO/tagnames"`; do echo out\_$tn\_col.pdf; done | tr "\n" " ")

for vs in `cat "$REPO/tagnames"`; do 
	dot -Tpdf out\_"$vs"\_col.dot -o out\_"$vs"\_col.pdf
done

pdftk $flatTagsPDF cat output "$REPO/.."/$(basename "$REPO")\_Evolution.pdf
