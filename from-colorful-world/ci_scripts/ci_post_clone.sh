echo "show default path"

pwd
cd ${CI_PROJECT_FILE_PATH}

echo "show CI_PROJECT_FILE_PATH"
pwd

echo "make install"
make install
