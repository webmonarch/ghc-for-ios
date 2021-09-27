SCRIPT_DIR=$(dirname $0)
PATCH=${SCRIPT_DIR}/ios.patch

patch -p0 -b -z .og < ${PATCH}
