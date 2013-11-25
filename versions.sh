#!/bin/bash

BASE_DIR=""

function getVersion() {
  if [ $# -eq 1  ];
  then
    f=$1
    echo $f
    FILENAME=${f##*/}
    SUFIX="."${FILENAME##*.}
    WITHOUT_EXTENSION=${FILENAME%\.*}
    VERSION=${WITHOUT_EXTENSION##*-}
  fi
  return $VERSION
}

if [ $# -eq 1 -a -d "$1" ];
then
    BASE_DIR=$(cd $1; pwd)
else
  BASE_DIR=$( cd $(dirname $0); pwd )
fi

for f in `find $BASE_DIR -type f -name "*.jar"`
do
  
  echo $f
  echo "=================================================================="
  if [ "$VERSION" = "javadoc" -o "$VERSION" = "sources" ];
  then
    continue
  fi

  VERSION=`getVersion $f`
  echo "PACKAGE = $PACKAGE"
  echo "VERSION = $VERSION"

  if expr "$VERSION" : '\([0-9]\)' ;
  then
    echo match
  else
    echo nomatch
    path=${f%/*}
    libdir=${path##*/}
    echo libdir=$libdir;
  fi
  echo "===================================================================="
done
