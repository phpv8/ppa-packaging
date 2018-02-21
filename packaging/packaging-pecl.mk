# List of target distributions
DISTROS=xenial artful

PECL_FULL_NAME=${PECL_NAME}-${VERSION}

work/${NAME}_${VERSION}:
	\
	mkdir work || true ; \
	cd work	; \
	mkdir ${NAME}_${VERSION} || true ; \
	cd ${NAME}_${VERSION} ; \
	if test -z "${GIT_FAST}"; then \
		git clone "${GIT_URL}" "${PECL_FULL_NAME}" ; \
		cd "${PECL_FULL_NAME}" ; \
		git fetch origin "${GIT_VERSION}"; \
		git checkout "${GIT_VERSION}" ; \
	else \
		git clone --depth=1 --branch="${GIT_VERSION}" "${GIT_URL}" "${PECL_FULL_NAME}" ; \
		cd "${PECL_FULL_NAME}" ; \
	fi; \
	\
	git submodule init ; git submodule update; \
	\
	if test -n "${GIT_POST_HOOK}"; then \
	  ../../../${GIT_POST_HOOK} ${GIT_VERSION}; \
	fi; \
	\
	cd .. ; \
	cp ../../../package.xml package.xml ;\
	sed -i -e "s/NAME/${PECL_NAME}/g" package.xml ; \
	sed -i -e "s/VERSION/${VERSION}/g" package.xml ; \
	cd .. ; \
	tar --exclude .git --exclude '*.pyc' -cf - ${NAME}_${VERSION} | gzip -n9c > ${NAME}_${VERSION}.orig.tar.gz
