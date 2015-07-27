#!/bin/sh

# Script to add sharness infrastructure to a project

USAGE="$0 [-v] [<directory>]"

usage() {
    echo "$USAGE"
    echo "Add sharness infrastructure to a project"
    exit 0
}

die() {
    echo >&2 "fatal: $@"
    exit 1
}

PROJ_DIR=""
VERBOSE=""

# get user options
while [ "$#" -gt "0" ]; do
    # get options
    arg="$1"
    shift

    case "$arg" in
	-h|--help)
	    usage ;;
	-v|--verbose)
	    VERBOSE=1 ;;
	--*)
	    die "unrecognised option: '$arg'\n$USAGE" ;;
	*)
	    test -z "$PROJ_DIR" || die "too many arguments\n$USAGE"
	    PROJ_DIR="$arg"
	    ;;
    esac
done
