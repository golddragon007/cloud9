#!/bin/bash

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=`dirname $SCRIPT_PATH`

PYTHON_SCRIPT="$SCRIPT_DIR/lambda_function.py"
ZIP_FILE="$SCRIPT_DIR/my_app.zip"
BUILD_DIR="$SCRIPT_DIR/build"

rm -Rf $ZIP_FILE
rm -Rf $BUILD_DIR
mkdir $BUILD_DIR

pip2.7 install -r requirements.txt -t $BUILD_DIR
cp $PYTHON_SCRIPT "$BUILD_DIR/"

cd "$BUILD_DIR"
ls -la
zip -r $ZIP_FILE .

echo "zip generated at $ZIP_FILE"

exit 0
