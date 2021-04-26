#!/bin/bash

if [[ $# -lt 1 ]]; then
	VERSION="$(uname -r)"
else
    VERSION=$1
fi

if [[ $# -lt 2 ]]; then
    FW="20191202-97.gite8a0f4c9.el8"
else
    FW=$2
fi

BUILDER=podman
which $BUILDER || BUILDER=docker
which $BUILDER || BUILDER=""

if [ "$BUILDER" = "" ]; then
    echo "Need to install podman (preferred) or docker"
    exit 1
fi

$BUILDER build --build-arg VERSION=$VERSION --build-arg FW=$FW \
         -f Dockerfile -t rhcos-dbg:$VERSION || exit 1
$BUILDER push rhcos-dbg:$VERSION
