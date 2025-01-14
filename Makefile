DESTDIR=../qt-everywhere-src-5.12.5

PKG_CONFIG_LIBDIR=/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig
export PKG_CONFIG_LIBDIR

QT_CONFIG_COMMON:=-v -optimized-tools \
	-opengl es2 -eglfs \
	-no-gtk \
	-opensource -confirm-license -release \
	-reduce-exports \
	-force-pkg-config \
	-nomake examples -no-compile-examples \
	-skip qtwayland \
	-skip qtwebengine \
	-skip qtscript \
	-no-feature-geoservices_mapboxgl \
	-qt-pcre \
	-no-pch \
	-no-xcb \
	-ssl \
	-evdev \
	-system-freetype \
	-fontconfig \
	-glib \
	-sctp \
	-prefix /opt/Qt5.12 \
	-recheck-all \
	-qpa eglfs

QT_CONFIG_ARMV6:=-platform linux-rpi-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7:=-platform linux-rpi2-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV8:=-platform linux-rpi3-g++ $(QT_CONFIG_COMMON)

QT_CONFIG_ARMV7_VC4:=-platform linux-rpi-vc4-g++ $(QT_CONFIG_COMMON)

all:
	@echo "Run: make install DESTDIR=qt-source-root"
	@echo "DESTDIR defaults to: [$(DESTDIR)]"

install: mkspecs

mkspecs:
	install -m 644 common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/
	cp -a linux-rpi2-g++ linux-rpi3-g++ linux-rpi-g++ linux-rpi-vc4-g++ $(DESTDIR)/qtbase/mkspecs/

diff: diff-common diff-linux-rpi-g++ diff-linux-rpi2-g++ diff-linux-rpi3-g++

diff-common:
	diff -u common/raspberrypi.conf $(DESTDIR)/qtbase/mkspecs/common/raspberrypi.conf

diff-%:
	diff -u -r $* $(DESTDIR)/qtbase/mkspecs/$*

configure-rpi: configure-armv6

configure-rpi1: configure-armv6

configure-rpi2: configure-armv7

configure-rpi3: configure-armv8

configure-rpi4: configure-armv8

configure-armv6: mkspecs
	mkdir -p ../build-qt-armv6 && cd ../build-qt-armv6 && $(DESTDIR)/configure $(QT_CONFIG_ARMV6)

configure-armv7: mkspecs
	mkdir -p ../build-qt-armv7 && cd ../build-qt-armv7 && $(DESTDIR)/configure $(QT_CONFIG_ARMV7)

configure-armv7-vc4: mkspecs
	mkdir -p ../build-qt-armv7-vc4 && cd ../build-qt-armv7-vc4 && $(DESTDIR)/configure $(QT_CONFIG_ARMV7_VC4)

configure-armv8: mkspecs
	mkdir -p ../build-qt-armv8 && cd ../build-qt-armv8 && $(DESTDIR)/configure $(QT_CONFIG_ARMV8)


