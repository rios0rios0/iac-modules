#!/usr/bin/env sh

first="$1"
shift
if [ -d "$first" ]
then
    cd $first && eval "$@"
else
    eval "$first $@"
fi
