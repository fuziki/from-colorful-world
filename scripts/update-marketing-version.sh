#!/bin/sh

if [ $# != 2 ]; then
    echo "need config file path and new version"
    exit 1
fi

NEW_VERSION=$1
CONFIG_FILE_PATH=$2

echo "version -> ${NEW_VERSION}"
echo "path -> ${CONFIG_FILE_PATH}"

sed -i "" \
    "s/MARKETING_VERSION = [0-9|.]*/MARKETING_VERSION = ${NEW_VERSION}/g" \
    ${CONFIG_FILE_PATH}

NEW_BRANCH=update/version-${NEW_VERSION}

git checkout -b ${NEW_BRANCH}
git add ${CONFIG_FILE_PATH}
git commit -m "update marketing version ${NEW_VERSION}"

BASE_BRANCH=${GITHUB_REF#refs/heads/}
PR_TITLE="update marketing version ${NEW_VERSION}"

echo "base -> ${BASE_BRANCH}"
echo "pr-title -> ${PR_TITLE}"

gh pr create \
    --head ${NEW_BRANCH} \
    --base ${BASE_BRANCH} \
    --title "${PR_TITLE}" \
    --body ""
