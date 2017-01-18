# PPA archive
#PPA=ppa:username/ppa-name

DEBUILD=debuild -S

all: _phony

_phony:

work/${NAME}_${VERSION}:
	\
	mkdir work || true ; \
	cd work	; \
	mkdir "${NAME}_${VERSION}" ; \
	cd "${NAME}_${VERSION}"	; \
	cp ./../../stub-gclient-spec .gclient ; \
	cp ./../../Makefile.target Makefile ; \
	git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git ; \
	export PATH=`pwd`/depot_tools:"${PATH}" ; \
	gclient sync -vvv -j ${NPROCS} -r ${VERSION} ; \
	cd .. ; \
	tar --exclude='./debian' --exclude .git --exclude '*.pyc' -cf - ${NAME}_${VERSION} | gzip -n9c > ${NAME}_${VERSION}.orig.tar.gz ; \

include ../packaging-base.mk
