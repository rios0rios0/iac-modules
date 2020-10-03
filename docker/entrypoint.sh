#!/usr/bin/env bash

command="$1"
shift
eval "$command $@"
