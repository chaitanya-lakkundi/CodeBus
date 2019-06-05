#!/bin/bash

REPO="$1"
if ! [[ "$REPO" = /* ]]; then
	REPO="$PWD"/$(echo `dirname "$REPO"`/`basename "$REPO"`)
else
	REPO=$(echo `dirname "$REPO"`/`basename "$REPO"`)
fi

DOTS="$REPO"\_dots

cd "$DOTS/out_dots/coldot"
echo "$PWD"

rg --count "#ff5c33" *.dot > count_red
rg --count "#85e085" *.dot > count_green
