#!/bin/bash

pipenv install
#pipenv shell

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=`dirname $SCRIPT_PATH`

ZIP_FILE="$SCRIPT_DIR/my_app.zip"

VIRTUAL_ENV=$(pipenv --venv)

rm -Rf $ZIP_FILE

zip $ZIP_FILE "./my_script.py" || exit 1

# Zip dependances
if [ ! -z $(ls -A "${VIRTUAL_ENV}/lib/python2.7/site-packages/") ]; then
    cd "${VIRTUAL_ENV}/lib/python2.7/site-packages/" || exit 1
    zip -r $ZIP_FILE . || exit 1
fi

if [ ! -z $(ls -A "${VIRTUAL_ENV}/lib64/python2.7/site-packages/") ]; then
    cd "${VIRTUAL_ENV}/lib64/python2.7/site-packages/" || exit 1
    zip -r $ZIP_FILE . || exit 1
fi

# On cloud9, site-package is empty... use dist-packages
if [ ! -z $(ls -A "${VIRTUAL_ENV}/lib/python2.7/dist-packages/") ]; then
    cd "${VIRTUAL_ENV}/lib/python2.7/dist-packages/" || exit 1
    zip -r $ZIP_FILE . || exit 1
fi

if [ ! -z $(ls -A "${VIRTUAL_ENV}/lib64/python2.7/dist-packages/") ]; then
    cd "${VIRTUAL_ENV}/lib64/python2.7/dist-packages/" || exit 1
    zip -r $ZIP_FILE . || exit 1
fi

cd "" || exit 1
zip -r $ZIP_FILE . || exit 1

echo "zip generated at $ZIP_FILE"

exit 0