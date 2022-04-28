
srcs := .

libs := .libs
libmpack := $(libs)/libmpack.a

release.tgz := mpack-wasm.tgz

RELEASE: $(release.tgz)

ALL: $(libmpack)

$(release.tgz): ALL
	rm -rf build/release
	mkdir -p build/release/include
	mkdir -p build/release/lib
	cp $(lib)/*.a build/release/lib
	cp mpack.h build/release/include
	(cd build/release && tar -czvf - *) > $(release.tgz)

$(libmpack):
	echo Work in Progress
