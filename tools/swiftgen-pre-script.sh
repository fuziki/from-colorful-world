#!/bin/bash

EXPORT_PATH="export"
PACKAGE_PATH="."
PRODUCT="swiftgen"
BUNDLE_SRC=".build/release/SwiftGen_SwiftGenCLI.bundle"
BUNDLE_DST="${EXPORT_PATH}/${PRODUCT}/SwiftGen_SwiftGenCLI.bundle"

echo "product: ${PRODUCT}"

if [ ! -d ${BUNDLE_DST} ]; then
    echo "not exist ${BUNDLE_DST}"
    rm -r "${EXPORT_PATH}/${PRODUCT}"
fi
