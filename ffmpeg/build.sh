#!/bin/bash
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# https://gist.github.com/gyk/49dc80c58691a21a1c5f5e16926beaa6
# https://github.com/schlarpc/ffmpeg-lambda-build

showHelp() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat << EOF
Usage: ./build -vnc [-hvnc]

-h,             Display help

-c,             clean rebuild docker container using no-cache

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

pythondeps=(cv2 \
Levenshtein \
numpy \
PIL \
pytesseract)

LAMBDA_DIR=layer

rm -rf layer
mkdir -p layer/{bin,lib,python,tessdata,python}
docker build $DOCKER_ARG --build-arg TESSERACT_LANG="$TESSERACT_LANG" --build-arg TESSERACT_MODE="$TESSERACT_MODE" -t tesseract-builder -f Dockerfile .
CONTAINER=$(docker run -d tesseract-builder false)

# copy libs
for lib in "${libarray[@]}"
do
    docker cp -L \
    $CONTAINER:$lib $LAMBDA_DIR/lib
done

# copy python dependencies
for dep in "${pythondeps[@]}"
do
    docker cp \
    $CONTAINER:/var/task/python/$dep $LAMBDA_DIR/python/.
done

docker cp \
    $CONTAINER:/var/task/tessdata $LAMBDA_DIR

docker cp \
    $CONTAINER:/usr/local/bin/tesseract $LAMBDA_DIR/bin/

docker rm $CONTAINER
