#!/bin/sh
#
# Copyright (c) 2015 Christian Couder
# MIT Licensed; see the LICENSE file in this repository.
#
# Script to add sharness infrastructure to a project

SHARNESS_URL="https://github.com/mlafeldt/sharness.git"
LIB_DIR="lib"

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

CUR_DIR=$(cd "$(dirname "$0")" && pwd)

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

# Setup PROJ_DIR properly
test -n "$PROJ_DIR" || PROJ_DIR="."

# Create a sharness directories
SHARNESS_DIR="$PROJ_DIR/sharness"
SHARNESS_LIB_DIR="$SHARNESS_DIR/$LIB_DIR"
mkdir -p "$SHARNESS_LIB_DIR" ||
die "could not create '$SHARNESS_LIB_DIR' directory"

# Copy sharness install script
cp "$CUR_DIR/install-sharness.sh" "$SHARNESS_LIB_DIR/" ||
die "could not copy '$CUR_DIR/install-sharness.sh' into '$SHARNESS_LIB_DIR/'"
INSTALL_SCRIPT="$SHARNESS_LIB_DIR/install-sharness.sh"

# Create temp directory
DATE=$(date +"%Y-%m-%dT%H:%M:%SZ")
TMPDIR=$(mktemp -d "/tmp/sharnessify.$DATE.XXXXXX") ||
die "could not 'mktemp -d /tmp/sharnessify.$DATE.XXXXXX'"

# Clone Sharness
(
    cd "$TMPDIR" || die "could not cd into '$TMPDIR'"
    git clone "$SHARNESS_URL" ||
    die "could not clone from '$SHARNESS_URL'"
) || exit

# Get Sharness version
SHARNESS_VERSION=$(cd "$TMPDIR/sharness" && git rev-parse HEAD)
test -n "$SHARNESS_VERSION" ||
die "could not get Sharness version from repo in '$TMPDIR/sharness'"

ESCAPED_URL=$(echo "$SHARNESS_URL" | sed -e 's/[\/&]/\\&/g')

# Substitute variables in install script
sed -i "s/XXX_SHARNESSIFY_VERSION_XXX/$SHARNESS_VERSION/" "$INSTALL_SCRIPT" ||
die "could not modify '$INSTALL_SCRIPT'"
sed -i "s/XXX_SHARNESSIFY_URL_XXX/$ESCAPED_URL/" "$INSTALL_SCRIPT" ||
die "could not modify '$INSTALL_SCRIPT'"
sed -i "s/XXX_SHARNESSIFY_LIB_XXX/$LIB_DIR/" "$INSTALL_SCRIPT" ||
die "could not modify '$INSTALL_SCRIPT'"
sed -i "s/XXX_SHARNESSIFY_SHARNESS_XXX/sharness/" "$INSTALL_SCRIPT" ||
die "could not modify '$INSTALL_SCRIPT'"

# Cleanup temp directory
rm -rf "$TMPDIR"

# Add .gitignore
echo "$LIB_DIR/sharness/" >"$SHARNESS_DIR/.gitignore"
echo "test-results/" >>"$SHARNESS_DIR/.gitignore"
echo "trash directory.*.sh/" >>"$SHARNESS_DIR/.gitignore"

