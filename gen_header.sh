#!/bin/sh

MAKEFILE="$1"
INPUT="$2"
OUTPUT="$3"

VERSION_MAJOR=$( grep "VERSION_MAJOR=" "$MAKEFILE" | sed -e 's/^VERSION_MAJOR=\([0-9]\+\)$/\1/' )
VERSION_MINOR=$( grep "VERSION_MINOR=" "$MAKEFILE" | sed -e 's/^VERSION_MINOR=\([0-9]\+\)$/\1/' )

sed -e 's/@@VERSION_MAJOR@@/'$VERSION_MAJOR'/g' \
    -e 's/@@VERSION_MINOR@@/'$VERSION_MINOR'/g' \
    "$INPUT" > "$OUTPUT"
