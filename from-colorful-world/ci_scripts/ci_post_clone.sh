echo "show default path"
pwd

cd ${CI_PROJECT_FILE_PATH}
echo "show CI_PROJECT_FILE_PATH"
pwd

cd ${CI_WORKSPACE}
echo "show CI_WORKSPACE"
pwd

echo "make install"
make install
