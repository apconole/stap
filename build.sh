#!/bin/bash

if [[ $# != 2 ]]; then
    VERSION=`uname -r`
else
    VERSION=$2
fi

BUILDER=podman
which $BUILDER || BUILDER=docker
which $BUILDER || BUILDER=""

if [ "$BUILDER" = "" ]; then
    echo "Need to install podman (preferred) or docker"
    exit 1
fi

$BUILDER build --build-arg VERSION=$VERSION \
         -f Dockerfile -t rhcos-dbg:$VERSION || exit 1
$BUILDER push rhcos-dbg:$VERSION
