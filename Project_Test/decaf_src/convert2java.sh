#!/bin/bash
if [ "x$1" == "x" ]; then
    echo "Usage $0 <decaf file> <java file>"
    exit 1
fi

if [ "x$2" == "x" ]; then
    echo "Usage $0 <decaf file> <java file>"
    exit 1
fi

sed -e 's/void main()/public void main(String[] args)/' \
    -e 's/[a-zA-Z][a-zA-Z]*[ \t][ \t]*[a-zA-Z][a-zA-Z]*[ \t]*[(]/static &/' \
    -e 's/Random/(new Random())/g' \
    -e $'s/class/import java.util.*;\\\nclass/' \
    $1 > $2
