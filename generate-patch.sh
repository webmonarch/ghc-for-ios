#!/bin/bash

SCRIPT_DIR=$(dirname $0)
PATCH=${SCRIPT_DIR}/ios.patch

true > ${PATCH}

find . -type f -name '*.og' | while IFS= read -r f; do
  diff -u "$f" "${f%.og}" >> ${PATCH}
done
