#!/bin/sh
VERSION=$(head -n 1 Changelog | sed 's/://')
REMOTE=$(git config remote.origin.url | sed 's/git@github.com:\(.*\).git/\1/')
URL=https://github.com/${REMOTE}/archive/${VERSION}.tar.gz
CHECKSUM=$(curl -s -L ${URL} | md5sum | cut -f1 -d' ')
BASE="/home/afu/git/opam-repository/packages"
BASENAME=$(basename $PWD)

for f in ${BASENAME}*.opam; do
    NAME=$(basename -s .opam $f)
    echo "Release package $NAME.${VERSION}"
    DIR=${BASE}/${NAME}/${NAME}.${VERSION}
    mkdir -p ${DIR}

    grep -Ev '^version:' ${NAME}.opam > ${DIR}/opam
    cp ${NAME}.descr ${DIR}/descr
    echo "http: \"$URL\"" > ${DIR}/url
    echo "checksum: \"${CHECKSUM}\"" >> ${DIR}/url
done
