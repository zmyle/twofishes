#!/bin/bash

set -e

if [ "$1" = 'twofishes' ]; then
    ROOTDIR="/opt/twofishes"
    if [ -z "${TWOFISHES_BINARY_URL}" ]; then
        echo "Missing required ENV 'TWOFISHES_BINARY_URL'."
        exit 1
    fi
    if [[ "${TWOFISHES_BINARY_URL}" != *jar ]]; then
        echo "ENV 'TWOFISHES_BINARY_URL' must be a jar file."
        exit 1
    fi
    if [ -z "${TWOFISHES_DATAINDEX_URL}" ]; then
        echo "Missing required ENV 'TWOFISHES_DATAINDEX_URL'"
        exit 1
    fi
    if [[ "${TWOFISHES_DATAINDEX_URL}" != *tar.gz ]]; then
        echo "ENV 'TWOFISHES_DATAINDEX_URL' must be a tar.gz file."
        exit 1
    fi

    mkdir -p ${ROOTDIR}/revgeo
    pushd ${ROOTDIR}

    # install twofishes binary
    PRV_BINARY_URL=""
    if [ -f "${ROOTDIR}/twofishes-binary.bak" ]; then
        PRV_BINARY_URL=$(cat ${ROOTDIR}/twofishes-binary.bak)
    fi
    if [ "${TWOFISHES_BINARY_URL}" != "${PRV_BINARY_URL}" ]; then
        rm -f *.jar
        echo "Downloading binary file from ${TWOFISHES_BINARY_URL}"
        curl -O "${TWOFISHES_BINARY_URL}"
        echo -en "${TWOFISHES_BINARY_URL}" > ${ROOTDIR}/twofishes-binary.bak
    fi
    set +e
    JARFILE=$(ls *.jar | egrep "\.jar$")
    set -e

    # install twofishes revgeo index
    PRV_DATAINDEX_URL=""
    if [ -f "${ROOTDIR}/twofishes-dataindex.bak" ]; then
        PRV_DATAINDEX_URL=$(cat ${ROOTDIR}/twofishes-dataindex.bak)
    fi
    if [ "${TWOFISHES_DATAINDEX_URL}" != "${PRV_DATAINDEX_URL}" ]; then
        echo "Downloading revgeo index file from ${TWOFISHES_DATAINDEX_URL}."
        curl -O "${TWOFISHES_DATAINDEX_URL}"
        TARFILE=$(ls *.tar.gz | egrep "\.tar.gz$")
        echo "Removing old revgeo index files."
        rm -rf ${ROOTDIR}/revgeo/*
        echo "Installing new revgeo index file (${TARFILE}). This might take a while ..."
        tar -xzf ${TARFILE} -C ${ROOTDIR}/revgeo
        rm -f ${TARFILE}
        echo -en "${TWOFISHES_DATAINDEX_URL}" > ${ROOTDIR}/twofishes-dataindex.bak
    fi
    set +e
    DATADIR=$(ls -F ${ROOTDIR}/revgeo/ | egrep "/$" | sed 's/\///g')
    set -e

    popd

    # run twofishes
    if [ -z "${TWOFISHES_JAVA_OPTS}" ]; then
        TWOFISHES_JAVA_OPTS = "-Xmx2g -Xms2g"
    fi
    exec java \
         ${TWOFISHES_JAVA_OPTS} \
         -jar ${ROOTDIR}/${JARFILE} \
         --hfile_basepath ${ROOTDIR}/revgeo/${DATADIR} \

fi

exec "$@"
