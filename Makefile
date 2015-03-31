LIBDIR=/usr/lib/

# Path to db_185.h include

SHARED_LIBS = y

DEFINES = -DRESOLVE_HOSTNAMES -DLIBDIR=\"$(LIBDIR)\"
ifneq ($(SHARED_LIBS),y)
DEFINES += -DNO_SHARED_LIBS
endif



ADDLIB=
#options for decnet
ADDLIB+=dnet_ntop.o dnet_pton.o

#options for ipx
ADDLIB+=ipx_ntop.o ipx_pton.o

CC = gcc
HOSTCC = gcc




YACCFLAGS = -d -t -v

SUBDIRS=lib ip tc misc netem genl


CCOPTS = -D_GNU_SOURCE -O2 -Wstrict-prototypes -Wall
CFLAGS = $(CCOPTS) -I../include $(DEFINES)

LIBNETLINK=../lib/libnetlink.a ../lib/libutil.a
LDLIBS += $(LIBNETLINK)
LDLIBS += -lresolv -lmicrocebus -lpthread

LDFLAGS = -L$(HOME)/.emacs.d/microcebus/lib

all: Config
	@set -e; \
	for i in $(SUBDIRS); \
	do $(MAKE) $(MFLAGS) -C $$i; done

Config:
	sh configure $(KERNEL_INCLUDE)

clean:
	rm -f cscope.*
	@for i in $(SUBDIRS) doc; \
	do $(MAKE) $(MFLAGS) -C $$i clean; done

cscope:
	cscope -b -q -R -Iinclude -sip -slib -smisc -snetem -stc

.EXPORT_ALL_VARIABLES:
