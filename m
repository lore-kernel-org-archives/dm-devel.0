From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 03/11] multipath-tools: Makefiles housekeeping
Date: Thu, 11 Aug 2016 20:32:19 +0200
Message-ID: <1470940345-4441-3-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Apart of this relevant change in libmpathpersist/Makefile
-       $(CC) -Wall -fPIC -c $(CFLAGS) *.c
+       $(CC) -c $(CFLAGS) *.c

Mainly indent and order code.

Compiled tested, also installed and uninstalled.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile                           | 32 ++++++++++++-------------
 Makefile.inc                       | 48 +++++++++++++++++++-------------------
 kpartx/Makefile                    |  5 ++--
 libmpathcmd/Makefile               |  6 ++---
 libmpathpersist/Makefile           | 18 +++++---------
 libmultipath/Makefile              | 29 +++++++++++------------
 libmultipath/checkers/Makefile     |  5 ++--
 libmultipath/prioritizers/Makefile |  5 ++--
 mpathpersist/Makefile              | 13 +++++------
 multipath/Makefile                 |  8 +++----
 multipathd/Makefile                | 32 ++++++++-----------------
 11 files changed, 89 insertions(+), 112 deletions(-)

diff --git a/Makefile b/Makefile
index cf1acd9..7786c83 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,3 @@
-# Makefile
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
@@ -6,16 +5,17 @@
 #
 # Try to supply the linux kernel headers.
 #
-ifeq    ($(KRNLSRC),)
-KRNLLIB = /lib/modules/$(shell uname -r)
-ifeq    ($(shell test -r $(KRNLLIB)/source && echo 1),1)
-KRNLSRC = $(KRNLLIB)/source
-KRNLOBJ = $(KRNLLIB)/build
-else
-KRNLSRC = $(KRNLLIB)/build
-KRNLOBJ = $(KRNLLIB)/build
-endif
+ifeq ($(KRNLSRC),)
+	KRNLLIB = /lib/modules/$(shell uname -r)
+	ifeq ($(shell test -r $(KRNLLIB)/source && echo 1),1)
+		KRNLSRC = $(KRNLLIB)/source
+		KRNLOBJ = $(KRNLLIB)/build
+	else
+		KRNLSRC = $(KRNLLIB)/build
+		KRNLOBJ = $(KRNLLIB)/build
+	endif
 endif
+
 export KRNLSRC
 export KRNLOBJ
 
@@ -30,10 +30,10 @@ BUILDDIRS = \
 	mpathpersist \
 	kpartx
 
-ifeq   ($(MULTIPATH_VERSION),)
-VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
+ifeq ($(MULTIPATH_VERSION),)
+	VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
 else
-VERSION = $(MULTIPATH_VERSION)
+	VERSION = $(MULTIPATH_VERSION)
 endif
 
 all: recurse
@@ -59,11 +59,11 @@ recurse_uninstall:
 	$(MAKE) -C $$dir uninstall || exit $?; \
 	done
 
-clean:	recurse_clean
+clean: recurse_clean
 
-install:	recurse_install
+install: recurse_install
 
-uninstall:	recurse_uninstall
+uninstall: recurse_uninstall
 
 .PHONY:	TAGS
 TAGS:
diff --git a/Makefile.inc b/Makefile.inc
index 3e8635f..0808e64 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -1,6 +1,6 @@
-# Makefile.inc
 #
 # Copyright (C) 2004 Christophe Varoqui, <christophe.varoqui@opensvc.com>
+#
 
 #
 # Allow to force some libraries to be used statically. (Uncomment one of the
@@ -39,32 +39,32 @@ ifndef SYSTEMDPATH
 	SYSTEMDPATH=usr/lib
 endif
 
-prefix      =
-exec_prefix = $(prefix)
-bindir      = $(exec_prefix)/sbin
-libudevdir  = $(prefix)/$(SYSTEMDPATH)/udev
-udevrulesdir = $(libudevdir)/rules.d
-multipathdir = $(TOPDIR)/libmultipath
-mandir      = $(prefix)/usr/share/man/man8
-man5dir     = $(prefix)/usr/share/man/man5
-man3dir      = $(prefix)/usr/share/man/man3
-syslibdir   = $(prefix)/$(LIB)
-incdir      = $(prefix)/usr/include
-libdir	    = $(prefix)/$(LIB)/multipath
-unitdir     = $(prefix)/$(SYSTEMDPATH)/systemd/system
-mpathpersistdir = $(TOPDIR)/libmpathpersist
-mpathcmddir = $(TOPDIR)/libmpathcmd
+prefix		=
+exec_prefix	= $(prefix)
+bindir		= $(exec_prefix)/sbin
+libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
+udevrulesdir	= $(libudevdir)/rules.d
+multipathdir	= $(TOPDIR)/libmultipath
+mandir		= $(prefix)/usr/share/man/man8
+man5dir		= $(prefix)/usr/share/man/man5
+man3dir		= $(prefix)/usr/share/man/man3
+syslibdir	= $(prefix)/$(LIB)
+incdir		= $(prefix)/usr/include
+libdir		= $(prefix)/$(LIB)/multipath
+unitdir		= $(prefix)/$(SYSTEMDPATH)/systemd/system
+mpathpersistdir	= $(TOPDIR)/libmpathpersist
+mpathcmddir	= $(TOPDIR)/libmpathcmd
 
-GZIP        = gzip -9 -c
-RM          = rm -f
-LN          = ln -sf
-INSTALL_PROGRAM = install
+GZIP		= gzip -9 -c
+RM		= rm -f
+LN		= ln -sf
+INSTALL_PROGRAM	= install
 
-OPTFLAGS     = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
-		-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
+OPTFLAGS	= -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
+		  -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
 
-CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
-SHARED_FLAGS = -shared
+CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+SHARED_FLAGS	= -shared
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 70f836e..75b7606 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -1,4 +1,3 @@
-# Makefile
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
@@ -6,15 +5,17 @@ include ../Makefile.inc
 
 CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
+LDFLAGS = -ldevmapper
+
 LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie' /usr/include/libdevmapper.h)
 
 ifneq ($(strip $(LIBDM_API_COOKIE)),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
-LDFLAGS = -ldevmapper
 OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
 	gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
+
 EXEC = kpartx
 
 all: $(EXEC)
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 44c221d..457c4ca 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -1,8 +1,6 @@
-# Makefile
-#
 include ../Makefile.inc
 
-SONAME=0
+SONAME = 0
 DEVLIB = libmpathcmd.so
 LIBS = $(DEVLIB).$(SONAME)
 
@@ -27,4 +25,4 @@ uninstall:
 	$(RM) $(DESTDIR)$(incdir)/mpath_cmd.h
 
 clean:
-	$(RM) core *.a *.o *.gz *.so *.so.*
+	$(RM) core *.a *.o *.so *.so.* *.gz
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 07fcf70..1c4b2e1 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -1,23 +1,20 @@
-# Makefile
-#
 include ../Makefile.inc
 
-SONAME=0
+SONAME = 0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
 
-
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
-LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
-	-L$(mpathcmddir) -lmpathcmd
+
+LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
+	   -L$(mpathcmddir) -lmpathcmd
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(LIBS)
 
-
 $(LIBS):
-	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
+	$(CC) -c $(CFLAGS) *.c
 	$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
@@ -42,7 +39,4 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
-	$(RM) core *.a *.o
-	$(RM) libmpathpersist.so.0
-	$(RM) libmpathpersist.so
-	$(RM) mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
+	$(RM) core *.a *.o *.so *.so.* *.gz
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e44397b..3a20f8e 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -1,15 +1,18 @@
-# Makefile
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 include ../Makefile.inc
 
-SONAME=0
+SONAME = 0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
+
 CFLAGS += -I$(mpathcmddir)
+
 LIBDEPS = -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
+
 ifdef SYSTEMD
+	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
 		LIBDEPS += -lsystemd
 	else
@@ -17,14 +20,6 @@ ifdef SYSTEMD
 	endif
 endif
 
-OBJS = memory.o parser.o vector.o devmapper.o callout.o \
-	hwtable.o blacklist.o util.o dmparser.o config.o \
-	structs.o discovery.o propsel.o dict.o \
-	pgpolicies.o debug.o defaults.o uevent.o \
-	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
-
 LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
 
 ifneq ($(strip $(LIBDM_API_FLUSH)),0)
@@ -43,16 +38,20 @@ ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
 	CFLAGS += -DLIBUDEV_API_RECVBUF
 endif
 
-ifdef SYSTEMD
-	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
-endif
-
 LIBDM_API_DEFERRED = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_deferred_remove' /usr/include/libdevmapper.h)
 
 ifneq ($(strip $(LIBDM_API_DEFERRED)),0)
 	CFLAGS += -DLIBDM_API_DEFERRED
 endif
 
+OBJS = memory.o parser.o vector.o devmapper.o callout.o \
+	hwtable.o blacklist.o util.o dmparser.o config.o \
+	structs.o discovery.o propsel.o dict.o \
+	pgpolicies.o debug.o defaults.o uevent.o \
+	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
+	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
+	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
+
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
@@ -70,4 +69,4 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
-	$(RM) core *.a *.o *.gz *.so *.so.*
+	$(RM) core *.a *.o *.so *.so.* *.gz
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 5fd2099..e46192c 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -1,9 +1,10 @@
-# Makefile
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 include ../../Makefile.inc
 
+CFLAGS += -I..
+
 LIBS= \
 	libcheckcciss_tur.so \
 	libcheckreadsector0.so \
@@ -14,8 +15,6 @@ LIBS= \
 	libcheckrdac.so \
 	libcheckrbd.so
 
-CFLAGS += -I..
-
 all: $(LIBS)
 
 libcheckrbd.so: rbd.o
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index bb76700..eff5fc1 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -1,9 +1,10 @@
-# Makefile
 #
 # Copyright (C) 2007 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 include ../../Makefile.inc
 
+CFLAGS += -I..
+
 LIBS = \
 	libprioalua.so \
 	libprioconst.so \
@@ -18,8 +19,6 @@ LIBS = \
 	libprioweightedpath.so \
 	libpriosysfs.so
 
-CFLAGS += -I..
-
 all: $(LIBS)
 
 libprioalua.so: alua.o alua_rtpg.o
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index a458c4d..d545514 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -1,14 +1,14 @@
-# Makefile
-#
 include ../Makefile.inc
 
-OBJS = main.o
-
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
-LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
+
+LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
+	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
 
 EXEC = mpathpersist
 
+OBJS = main.o
+
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
@@ -22,8 +22,7 @@ install:
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
 clean:
-	$(RM) *.o $(EXEC)
-	$(RM) mpathpersist.8.gz
+	$(RM) core *.o $(EXEC) *.gz
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/multipath/Makefile b/multipath/Makefile
index 9c57d3b..b125ae3 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -1,17 +1,17 @@
-# Makefile
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 include ../Makefile.inc
 
-OBJS = main.o
-
 CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
+
 LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
-	-L$(mpathcmddir) -lmpathcmd
+	   -L$(mpathcmddir) -lmpathcmd
 
 EXEC = multipath
 
+OBJS = main.o
+
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 092b74b..03d7815 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -1,42 +1,30 @@
-EXEC = multipathd
-
 include ../Makefile.inc
 
 #
-# basic flags setting
+# debuging stuff
 #
+#CFLAGS += -DLCKDBG
+#CFLAGS += -D_DEBUG_
+#CFLAGS += -DLOGDBG
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
+
+LDFLAGS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
+	   -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
+	   -ldevmapper -lreadline
+
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
-endif
-LDFLAGS += -lurcu -lpthread -ldevmapper -lreadline
-ifdef SYSTEMD
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
 		LDFLAGS += -lsystemd
 	else
 		LDFLAGS += -lsystemd-daemon
 	endif
 endif
-LDFLAGS += -ludev -ldl \
-	-L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
-	-L$(mpathcmddir) -lmpathcmd
-
-#
-# debuging stuff
-#
-#CFLAGS += -DLCKDBG
-#CFLAGS += -D_DEBUG_
-#CFLAGS += -DLOGDBG
 
-#
-# object files
-#
 OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
 
+EXEC = multipathd
 
-#
-# directives
-#
 all : $(EXEC)
 
 $(EXEC): $(OBJS)
-- 
2.7.4
