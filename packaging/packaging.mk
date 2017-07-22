# List of target distributions
#DISTROS=trusty xenial zesty

work/${NAME}_${VERSION}:
	\
    mkdir work || true ; \
    cd work	; \
    if test -z "${GIT_FAST}"; then \
        git clone "${GIT_URL}" "${NAME}_${VERSION}" ; \
        cd "${NAME}_${VERSION}" ; \
        git fetch origin "${GIT_VERSION}"; \
        git checkout "${GIT_VERSION}" ; \
    else \
        git clone --depth=1 --branch="${GIT_VERSION}" "${GIT_URL}" "${NAME}_${VERSION}" ; \
        cd "${NAME}_${VERSION}" ; \
    fi; \
    \
    git submodule init ; git submodule update; \
    \
    if test -n "${GIT_POST_HOOK}"; then \
      ../../${GIT_POST_HOOK} ${GIT_VERSION}; \
    fi; \
    \
    cd .. ; \
    tar --exclude .git --exclude '*.pyc' -cf - ${NAME}_${VERSION} | gzip -n9c > ${NAME}_${VERSION}.orig.tar.gz

include ./packaging-base.mk
