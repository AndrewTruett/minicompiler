#!/bin/sh -e
cd `dirname "$0"`

if [ -z "$1" -o "$1" = "-h" -o "$1" = "--help" ]; then
    echo "Usage: $0 program.mini"
    exit 0
fi

for SRC in "$@"; do
    if [ ! -e "$SRC" ]; then
        echo "No such file: $SRC"
        exit 1
    fi

    BASENAME=`basename "$SRC" .mini`
    EXECUTABLE="executable-$BASENAME"

    echo "Compiling $SRC"
    java -jar ../target/minicompiler-dev.jar "$SRC" > "$BASENAME.s"
    echo "Assembling $BASENAME.s"
    as --32 -march=i686 -o "$BASENAME.o" "$BASENAME.s"
    echo "Linking $BASENAME.o"
    ld -melf_i386 -o "$EXECUTABLE" "$BASENAME.o" ../stdlib/stdlib.o ../stdlib/syscalls.o
    echo "Produced $EXECUTABLE"
done
