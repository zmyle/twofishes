#!/bin/bash

set -e

if [ "$1" = 'twofishes' ]; then
    # install twofishes
    pushd /opt/twofishes/
    JARFILE="server-assembly-${TWOFISHES_VERSION}.jar"
    if [ ! -f "/opt/twofishes/${JARFILE}" ]; then
        curl -O http://twofishes.net/binaries/${JARFILE}
    fi
    set +e
    DATADIR=$(ls | egrep "^${TWOFISHES_DATAINDEX_VERSION}")
    set -e
    if [ -z "${DATADIR}" ]; then
        curl -O http://twofishes.net/indexes/revgeo/${TWOFISHES_DATAINDEX_VERSION}.zip
        unzip ${TWOFISHES_DATAINDEX_VERSION}.zip -d /opt/twofishes
        rm -f ${TWOFISHES_DATAINDEX_VERSION}.zip
        DATADIR=$(ls | egrep "^${TWOFISHES_DATAINDEX_VERSION}")
    fi
    popd
    if [ -z "${TWOFISHES_JAVA_OPTS}" ]; then
        TWOFISHES_JAVA_OPTS = "-Xmx2g -Xms2g"
    fi
    # run twofishes
    exec java \
         ${TWOFISHES_JAVA_OPTS} \
         -jar /opt/twofishes/${JARFILE} \
         --hfile_basepath /opt/twofishes/${DATADIR} \

fi

exec "$@"
