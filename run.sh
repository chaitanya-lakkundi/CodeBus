#!/bin/bash

if [[ ! $1 ]]; then
	echo "Usage: ./run.sh repository-folder-path"
	exit
fi

cd src
./pipeline.sh ../$1
