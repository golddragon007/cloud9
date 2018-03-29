#!/bin/bash

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=`dirname $SCRIPT_PATH`

ZIP_FILE="$SCRIPT_DIR/my_app.zip"
SCRIPT_FILE="./lambda_function.py"


rm -Rf $ZIP_FILE

zip $ZIP_FILE "$SCRIPT_FILE" || exit 1

echo "zip generated at $ZIP_FILE"

exit 0
