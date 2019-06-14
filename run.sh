#!/bin/bash

if [[ ! "$1" ]]; then
	echo "Usage: ./run.sh repository-folder-path"
	exit
fi

RP=$(realpath "$1")

cd src
./pipeline.sh "$RP"
