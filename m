From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipathd.init
Date: Sun, 03 Apr 2005 22:02:30 +0200
Message-ID: <1112558550.8118.71.camel@zezette>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette> <1112521418.8118.49.camel@zezette>
	<1112558353.8118.67.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112558353.8118.67.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On dim, 2005-04-03 at 21:59 +0200, christophe varoqui wrote:
> > 
> > What needs to be done to have libdevmapper and libsysfs packages include
> > their respective klibc build version ? What about klibc shared objects
> > vs static ?
> > 
> 
> As a kick-off, here is a little clean up patch.
> I guess it's harmless anyway.
> 
> diff -ur devmapper-1.01.00/lib/libdm-file.c
> devmapper-1.01.00.klibcbuild/lib/libdm-file.c
> --- devmapper-1.01.00/lib/libdm-file.c  2005-01-06 19:22:44.000000000
> +0100
> +++ devmapper-1.01.00.klibcbuild/lib/libdm-file.c       2005-04-03
> 21:26:13.000000000 +0200
> @@ -16,7 +16,6 @@
>  #include "lib.h"
>  #include "libdm-file.h"
>  -#include <sys/file.h>
>  #include <fcntl.h>
>  #include <dirent.h>
>  #include <malloc.h>
> 

Nothing to be proud off, but has the merit to compile a klibc static
archive and installs it as /usr/lib/klibc/lib/libdevmapper.a :

--- devmapper-1.01.00/lib/Makefile.in   2005-04-03 20:48:28.000000000
+0200
+++ devmapper-1.01.00.klibcbuild/lib/Makefile.in        2005-04-03
21:13:43.000000000 +0200
@@ -23,6 +23,7 @@

 LIB_STATIC = $(interface)/libdevmapper.a
 LIB_SHARED = $(interface)/libdevmapper.so
+KLIB_STATIC = $(interface)/libdevmapper-klibc.a

 CFLAGS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
          -DDEVICE_MODE=@DEVICE_MODE@
@@ -30,7 +31,8 @@
 include ../make.tmpl

 .PHONY: install_dynamic install_static \
-       install_fs install_ioctl install_ioctl_static
+       install_fs install_ioctl install_ioctl_static \
+       install_ioctl_klibc_static

 INSTALL_TYPE = install_dynamic install_static

@@ -41,7 +43,7 @@
        $(INSTALL) -D $(OWNER) $(GROUP) -m 444 libdevmapper.h \
                $(includedir)/libdevmapper.h 
-install_static: install_@interface@_static +install_static:
install_@interface@_static install_@interface@_klibc_static
        $(INSTALL) -D $(OWNER) $(GROUP) -m 444 libdevmapper.h \
                $(includedir)/libdevmapper.h 
@@ -57,6 +59,10 @@         $(INSTALL) -D $(OWNER) $(GROUP) -m 755
$(STRIP) $< \
                $(libdir)/libdevmapper.a

+install_ioctl_klibc_static: ioctl/libdevmapper-klibc.a
+       $(INSTALL) -D $(OWNER) $(GROUP) -m 755 $(STRIP) $< \
+               $(klibdir)/libdevmapper.a
+
 .PHONY: distclean_lib distclean

 distclean_lib:
diff -ur devmapper-1.01.00/make.tmpl.in
devmapper-1.01.00.klibcbuild/make.tmpl.in---
devmapper-1.01.00/make.tmpl.in      2004-07-03 20:17:32.000000000 +0200
+++ devmapper-1.01.00.klibcbuild/make.tmpl.in   2005-04-03
21:24:38.000000000 +0200
@@ -18,13 +18,13 @@
 @SET_MAKE@

 CC = @CC@
+KLCC = klcc
 RANLIB = @RANLIB@
 SHELL = /bin/sh
 INSTALL = @INSTALL@
 MSGFMT = @MSGFMT@
 LN_S = @LN_S@
 LIBS = @LIBS@
-CFLAGS += @CFLAGS@
 CLDFLAGS += @CLDFLAGS@
 LDDEPS += @LDDEPS@
 LDFLAGS += @LDFLAGS@
@@ -36,6 +36,7 @@
 bindir = $(DESTDIR)@bindir@
 includedir = $(DESTDIR)@includedir@
 libdir = $(DESTDIR)@libdir@
+klibdir = $(DESTDIR)/usr/lib/klibc/lib
 sbindir = $(DESTDIR)@sbindir@
 infodir = $(DESTDIR)@infodir@
 mandir = $(DESTDIR)@mandir@
@@ -54,14 +55,16 @@
 MAKEFLAGS = @JOBS@
 endif

-SUFFIXES = .c .d .o .so .a .po .pot .mo
+SUFFIXES = .c .d .o .so .a .po .pot .mo .ko

-CFLAGS += -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline
+CFLAGS2 = -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline

-#CFLAGS += -W -Wconversion -Wpointer-arith -Wredundant-decls
-Wbad-function-cast -Wcast-qual -Wmissing-noreturn
+#CFLAGS2 = -W -Wconversion -Wpointer-arith -Wredundant-decls
-Wbad-function-cast -Wcast-qual -Wmissing-noreturn

 CFLAGS += @COPTIMISE_FLAG@

+CFLAGS2 += @CFLAGS@
+
 ifeq ("@DEBUG@", "yes")
   CFLAGS += -g -fno-omit-frame-pointer -DDEBUG
 endif
@@ -100,6 +103,7 @@
 DEPS = $(top_srcdir)/make.tmpl $(top_srcdir)/VERSION Makefile
$(INC_LNS)

 OBJECTS = $(SOURCES:%.c=%.o)
+KOBJECTS = $(SOURCES:%.c=%.ko)
 POTFILES = $(SOURCES:%.c=%.pot)

 SUBDIRS.install := $(SUBDIRS:=.install)
@@ -111,7 +115,7 @@
 .PHONY: $(SUBDIRS) $(SUBDIRS.install) $(SUBDIRS.clean)
$(SUBDIRS.distclean)
 .PHONY: $(SUBDIRS.pofile)

-TARGETS += $(LIB_SHARED) $(LIB_STATIC)
+TARGETS += $(LIB_SHARED) $(LIB_STATIC) $(KLIB_STATIC)

 all: $(SUBDIRS) $(TARGETS)

@@ -136,17 +140,20 @@
        $(MAKE) -C $(@:.pofile=) pofile
 endif

-$(TARGETS): $(OBJECTS)
+$(TARGETS): $(OBJECTS) $(KOBJECTS)
+
+%.ko: %.c
+       $(KLCC) -c $(INCLUDES) $(CFLAGS) $< -o $@

 %.o: %.c
-       $(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
+       $(CC) -c $(INCLUDES) $(CFLAGS) $(CFLAGS2) $< -o $@

 %.pot: %.c Makefile
        $(CC) -E $(INCLUDES) -include $(top_srcdir)/include/pogen.h \
-               $(CFLAGS) $< > $@
+               $(CFLAGS) $(CFLAGS2) $< > $@

 %.so: %.o
-       $(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
+       $(CC) -c $(INCLUDES) $(CFLAGS) $(CFLAGS2) $< -o $@

 $(LIB_SHARED): $(OBJECTS) $(LDDEPS)
        $(CC) $(SOFLAG) -Wl,-soname,$(notdir $@).$(LIB_VERSION) \
@@ -156,11 +163,15 @@
        $(RM) $@
        $(AR) rs $@ $(OBJECTS)

+$(KLIB_STATIC): $(KOBJECTS)
+       $(RM) $@
+       $(AR) rs $@ $(KOBJECTS)
+
 %.d: %.c
        set -e; \
        FILE=`echo $@ | sed 's/\\//\\\\\\//g;s/\\.d//g'`; \
        DEPS=`echo $(DEPS) | sed -e 's/\\//\\\\\\//g'`; \
-       $(CC) -MM $(INCLUDES) $(CFLAGS) $< | \
+       $(CC) -MM $(INCLUDES) $(CFLAGS) $(CFLAGS2) $< | \
        sed "s/\(.*\)\.o[ :]*/$$FILE.o $$FILE.d $$FILE.pot: $$DEPS /g" >
$@; \
        [ -s $@ ] || $(RM) $@


-- 
christophe varoqui <christophe.varoqui@free.fr>
