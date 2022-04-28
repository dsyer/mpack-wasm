
srcs := .

libs := build
libmpack := $(libs)/libmpack.a

release.tgz := mpack-wasm.tgz

RELEASE: $(release.tgz)

ALL: $(libmpack) $(libs)

$(release.tgz): ALL
	rm -rf build/release
	mkdir -p build/release/include
	mkdir -p build/release/lib
	cp $(libs)/*.a build/release/lib
	cp mpack.h build/release/include
	(cd build/release && tar -czvf - *) > $(release.tgz)

$(libmpack): mpack.o $(libs)
	$(AR) $(ARFLAGS) $@ *.o

$(libs):
	mkdir -p $(libs)

clean:
	rm -rf build *.o