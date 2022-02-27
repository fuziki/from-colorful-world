#!/bin/bash

if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "No product supplied"
    exit 1
fi

EXPORT_PATH="export"
PACKAGE_PATH="."
PRODUCT=$1
HASH_FILE_PATH="${EXPORT_PATH}/${PRODUCT}/hash.txt"
PRODUCT_FILE_PATH="${EXPORT_PATH}/${PRODUCT}/${PRODUCT}"
PACKAGE_RESOLEVED_HASH=`shasum -t ${PACKAGE_PATH}/Package.resolved`

mkdir -p "${EXPORT_PATH}/${PRODUCT}"

echo "product: ${PRODUCT}"
echo "current Package.resolved: ${PACKAGE_RESOLEVED_HASH}"

NEED_BUILD=true

if [ -e ${HASH_FILE_PATH} ] && [ -e ${PRODUCT_FILE_PATH} ]; then
    CURRENT_HASH=`cat ${HASH_FILE_PATH}`
    echo "current hash.text: ${CURRENT_HASH}"

    if [ "${PACKAGE_RESOLEVED_HASH}" = "${CURRENT_HASH}" ]; then
        echo "same hash not need build"
        NEED_BUILD=false
    fi
fi

if "${NEED_BUILD}"; then
    echo 'NEED_BUILD'

    xcrun --sdk macosx swift build --package-path "${PACKAGE_PATH}" -c release --product "${PRODUCT}"

    cp ".build/release/${PRODUCT}" "${PRODUCT_FILE_PATH}"

    echo "${PACKAGE_RESOLEVED_HASH} -> ${HASH_FILE_PATH}"
    echo "${PACKAGE_RESOLEVED_HASH}" > "${HASH_FILE_PATH}"
fi
