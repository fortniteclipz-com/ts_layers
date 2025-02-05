#!/bin/bash
# https://github.com/gwittchen/lambda-ocr
# https://github.com/gwittchen/lambda-ocr/commit/340aa4a7e89ab39abfd253b3d29acb13448e31d1

showHelp() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat << EOF
Usage: ./build -vnc [-hvnc]

-h,             Display help

-c,             clean rebuild docker container using no-cache

-l,             list of space-delimited tesseract languages (default: eng)

-m,             tesseract model: fast/best (default: best)

EOF
# EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
}



export DOCKER_ARG=""
TESSERACT_LANG="eng"
TESSERACT_MODE="best"
while getopts "m:l:hc" opt; do
  case ${opt} in
    h ) showHelp
    exit 0
      ;;
    c ) export DOCKER_ARG="--no-cache"
      ;;
    m ) TESSERACT_MODE=$OPTARG
      ;;
    l ) TESSERACT_LANG=$(echo $OPTARG | tr ',' ' ')
      ;;
    \? ) showHelp
      ;;
  esac
done
set -e

echo "$DOCKER_ARG"

# define required libs

libarray=(/usr/local/lib/libtesseract.so.4 \
/usr/local/lib/liblept.so.5 \
/usr/lib64/librt.so \
/usr/lib64/libz.so \
/usr/lib64/libm.so \
/usr/lib64/libpng12.so.0 \
/usr/lib64/libjpeg.so.62 \
/usr/lib64/libtiff.so.5 \
/usr/lib64/libpthread.so \
/usr/lib64/libstdc++.so.6 \
/usr/lib64/libjbig.so.2.0 \
/usr/lib64/libwebp.so.4)

LAMBDA_DIR=layer

rm -rf layer
mkdir -p layer/{bin,lib,tessdata}
docker build $DOCKER_ARG --build-arg TESSERACT_LANG="$TESSERACT_LANG" --build-arg TESSERACT_MODE="$TESSERACT_MODE" -t tesseract-builder -f Dockerfile .
CONTAINER=$(docker run -d tesseract-builder false)

# copy libs
for lib in "${libarray[@]}"
do
    docker cp -L \
    $CONTAINER:$lib $LAMBDA_DIR/lib
done

docker cp \
    $CONTAINER:/var/task/tessdata $LAMBDA_DIR

docker cp \
    $CONTAINER:/usr/local/bin/tesseract $LAMBDA_DIR/bin/

docker rm $CONTAINER
