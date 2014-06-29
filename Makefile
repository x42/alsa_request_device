PREFIX ?= /usr/local
bindir ?= $(PREFIX)/bin
mandir ?= $(PREFIX)/share/man

CFLAGS ?= -Wall -O3 -g
VERSION?=$(shell (git describe --tags HEAD 2>/dev/null || echo "v0.3") | sed 's/^v//')

ifeq ($(shell pkg-config --exists alsa || echo no), no)
  $(warning *** libasound from http://www.alsa-project.org/ is required)
  $(error   Please install libasound2-dev or similar package that provides it)
endif

ifeq ($(shell pkg-config --exists dbus-1 || echo no), no)
  $(warning *** libdbus from http://www.freedesktop.org/wiki/Software/dbus/ is required)
  $(error   Please install libdbus-1-dev or similar package that provides it)
endif

###############################################################################

override CFLAGS += -DVERSION="\"$(VERSION)\""
override CFLAGS += `pkg-config --cflags alsa dbus-1`

LOADLIBES=`pkg-config --libs alsa dbus-1`
man1dir   = $(mandir)/man1

###############################################################################

default: all

alsa_request_device: alsa_request_device.c reserve.c

install-bin: alsa_request_device
	install -d $(DESTDIR)$(bindir)
	install -m755 alsa_request_device $(DESTDIR)$(bindir)

install-man: alsa_request_device.1
	install -d $(DESTDIR)$(man1dir)
	install -m644 alsa_request_device.1 $(DESTDIR)$(man1dir)

uninstall-bin:
	rm -f $(DESTDIR)$(bindir)/alsa_request_device
	-rmdir $(DESTDIR)$(bindir)

uninstall-man:
	rm -f $(DESTDIR)$(man1dir)/alsa_request_device.1
	-rmdir $(DESTDIR)$(man1dir)
	-rmdir $(DESTDIR)$(mandir)

###############################################################################

clean:
	rm -f alsa_request_device

man: alsa_request_device
	help2man -N -n 'ALSA Dbus device request tool' -o alsa_request_device.1 ./alsa_request_device

all: alsa_request_device

install: install-bin install-man

uninstall: uninstall-bin uninstall-man

.PHONY: default all man clean install install-bin install-man uninstall uninstall-bin uninstall-man
