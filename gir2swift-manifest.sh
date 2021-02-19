#!/bin/bash

GIR_NAME="GObject-2.0"
GIR_PKG="gobject-2.0"

function generate_arg-path_arg-g2s-exec_arg-gir-file_arg-gir-pre-files {
    local PACKAGE_PATH=$1
    local G2S_EXEC=$2
    local GIR_PRE_FILES=$3
    local GIR_FILE=$4

    local CALLER=$PWD

    cd $PACKAGE_PATH
    
    local NAME=$(package_name)
    local GIR_PRE_ARGS=`for FILE in ${GIR_PRE_FILES}; do echo -n "-p ${FILE} "; done`
    bash -c "${G2S_EXEC} -o Sources/${NAME} -m ${GIR_NAME}.module ${GIR_PRE_ARGS} ${GIR_FILE}"

    for src in Sources/${NAME}/*-*.swift ; do
	    sed -f ${GIR_NAME}.sed < ${src} | awk -f ${GIR_NAME}.awk > ${src}.out
	    mv ${src}.out ${src}
    done
    touch Sources/${NAME}/${GIR_NAME}.swift

    cd $CALLER
}

case $1 in
gir-name) echo $GIR_NAME;;
gir-pkg) echo $GIR_PKG;;
generate) echo $(generate_arg-path_arg-g2s-exec_arg-gir-file_arg-gir-pre-files "$2" "$3" "$4" "$5");;
esac
