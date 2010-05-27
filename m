From: zkabelac@sourceware.org
Subject: dmraid configure configure.in make.tmpl.in
Date: 27 May 2010 20:59:45 -0000
Message-ID: <20100527205945.14123.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-05-27 20:59:45

Modified files:
	.              : configure configure.in make.tmpl.in 

Log message:
	Precompute dependencie in the same way as in lvm2
	Add  OBJECTS2/SOURCES2
	Move version detection from configure.in to make.tmpl.in
	Fix top_buildir problems

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.6&r2=1.7

--- dmraid/configure	2010/05/27 19:38:15	1.6
+++ dmraid/configure	2010/05/27 20:59:44	1.7
@@ -668,6 +668,7 @@
 KLIBC
 KLCC
 RANLIB
+MKDIR_P
 SET_MAKE
 LN_S
 INSTALL_DATA
@@ -2176,6 +2177,48 @@
   SET_MAKE="MAKE=${MAKE-make}"
 fi
 
+{ $as_echo "$as_me:$LINENO: checking for a thread-safe mkdir -p" >&5
+$as_echo_n "checking for a thread-safe mkdir -p... " >&6; }
+if test -z "$MKDIR_P"; then
+  if test "${ac_cv_path_mkdir+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH$PATH_SEPARATOR/opt/sfw/bin
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_prog in mkdir gmkdir; do
+	 for ac_exec_ext in '' $ac_executable_extensions; do
+	   { test -f "$as_dir/$ac_prog$ac_exec_ext" && $as_test_x "$as_dir/$ac_prog$ac_exec_ext"; } || continue
+	   case `"$as_dir/$ac_prog$ac_exec_ext" --version 2>&1` in #(
+	     'mkdir (GNU coreutils) '* | \
+	     'mkdir (coreutils) '* | \
+	     'mkdir (fileutils) '4.1*)
+	       ac_cv_path_mkdir=$as_dir/$ac_prog$ac_exec_ext
+	       break 3;;
+	   esac
+	 done
+       done
+done
+IFS=$as_save_IFS
+
+fi
+
+  if test "${ac_cv_path_mkdir+set}" = set; then
+    MKDIR_P="$ac_cv_path_mkdir -p"
+  else
+    # As a last resort, use the slow shell script.  Don't cache a
+    # value for MKDIR_P within a source directory, because that will
+    # break other packages using the cache if that directory is
+    # removed, or if the value is a relative name.
+    test -d ./--version && rmdir ./--version
+    MKDIR_P="$ac_install_sh -d"
+  fi
+fi
+{ $as_echo "$as_me:$LINENO: result: $MKDIR_P" >&5
+$as_echo "$MKDIR_P" >&6; }
+
 if test -n "$ac_tool_prefix"; then
   # Extract the first word of "${ac_tool_prefix}ranlib", so it can be a program name with args.
 set dummy ${ac_tool_prefix}ranlib; ac_word=$2
@@ -5902,18 +5945,6 @@
 
 fi
 
-if test "-f tools/VERSION"; then
-  DMRAID_VERSION="`cat tools/VERSION`"
-else
-  DMRAID_VERSION="Unknown"
-fi
-
-if test "-f lib/version.h"; then
-  DMRAID_LIB_VERSION="`sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' lib/version.h`"
-else
-  DMRAID_LIB_VERSION="Unknown"
-fi
-
 
 
 
@@ -6448,6 +6479,7 @@
 ac_pwd='$ac_pwd'
 srcdir='$srcdir'
 INSTALL='$INSTALL'
+MKDIR_P='$MKDIR_P'
 AWK='$AWK'
 test -n "\$AWK" || AWK=awk
 _ACEOF
@@ -6931,6 +6963,11 @@
   [\\/$]* | ?:[\\/]* ) ac_INSTALL=$INSTALL ;;
   *) ac_INSTALL=$ac_top_build_prefix$INSTALL ;;
   esac
+  ac_MKDIR_P=$MKDIR_P
+  case $MKDIR_P in
+  [\\/$]* | ?:[\\/]* ) ;;
+  */*) ac_MKDIR_P=$ac_top_build_prefix$MKDIR_P ;;
+  esac
 _ACEOF
 
 cat >>$CONFIG_STATUS <<\_ACEOF || ac_write_fail=1
@@ -6987,6 +7024,7 @@
 s&@abs_builddir@&$ac_abs_builddir&;t t
 s&@abs_top_builddir@&$ac_abs_top_builddir&;t t
 s&@INSTALL@&$ac_INSTALL&;t t
+s&@MKDIR_P@&$ac_MKDIR_P&;t t
 $ac_datarootdir_hack
 "
 eval sed \"\$ac_sed_extra\" "$ac_file_inputs" | $AWK -f "$tmp/subs.awk" >$tmp/out \
--- dmraid/configure.in	2010/05/27 19:38:15	1.6
+++ dmraid/configure.in	2010/05/27 20:59:45	1.7
@@ -20,6 +20,7 @@
 AC_PROG_INSTALL
 AC_PROG_LN_S
 AC_PROG_MAKE_SET
+AC_PROG_MKDIR_P
 AC_PROG_RANLIB
 
 dnl Enables linking to klibc
@@ -196,18 +197,6 @@
 	AC_CHECK_HEADERS(getopt.h, CFLAGS="$CFLAGS -DHAVE_GETOPTLONG")
 fi
 
-if test "-f tools/VERSION"; then
-  DMRAID_VERSION="`cat tools/VERSION`"
-else
-  DMRAID_VERSION="Unknown"
-fi
-
-if test "-f lib/version.h"; then
-  DMRAID_LIB_VERSION="`sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[[^_]].*"\(.*\)"/\2/p' lib/version.h`"
-else
-  DMRAID_LIB_VERSION="Unknown"
-fi
-
 AC_SUBST(CC)
 AC_SUBST(CFLAGS)
 AC_SUBST(CLDFLAGS)
--- dmraid/make.tmpl.in	2010/05/27 19:38:15	1.6
+++ dmraid/make.tmpl.in	2010/05/27 20:59:45	1.7
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
@@ -12,6 +12,7 @@
 RANLIB = @RANLIB@
 SHELL = /bin/sh
 INSTALL = @INSTALL@
+MKDIR_P = @MKDIR_P@
 LN_S = @LN_S@
 LIBS = @LIBS@
 CFLAGS += @CFLAGS@
@@ -39,7 +40,8 @@
 endif
 
 # setup misc variables
-DMRAID_LIB_VERSION = @DMRAID_LIB_VERSION@
+DMRAID_VERSION := $(shell cat $(top_srcdir)/tools/VERSION)
+DMRAID_LIB_VERSION := $(shell sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[[^_]].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
 INSTALL_PROGRAM = $(INSTALL) $(STRIP)
 INSTALL_DIR = $(INSTALL) -d
 INSTALL_DATA = $(INSTALL) -m 644 -p
@@ -49,7 +51,7 @@
 MAKEFLAGS = @JOBS@
 endif
 
-SUFFIXES=.c .o .so .a
+SUFFIXES=.c .d .o .so .a
 
 CFLAGS+=-fPIC -Wall -Wundef -Wcast-align -Wwrite-strings -Winline
 
@@ -90,6 +92,7 @@
 DEPS=$(top_srcdir)/make.tmpl $(top_srcdir)/tools/VERSION Makefile
 
 OBJECTS=$(SOURCES:%.c=%.o)
+OBJECTS2=$(SOURCES2:%.c=%.o)
 
 SUBDIRS.install := $(SUBDIRS:=.install)
 SUBDIRS.remove := $(SUBDIRS:=.remove)
@@ -124,14 +127,22 @@
 $(TARGETS): $(OBJECTS)
 
 %.o: %.c
-	$(CC) -MM -MF ${@:%.o=%.d} $(INCLUDES) $(CFLAGS) $<; \
 	$(CC) -c $(INCLUDES) $(CFLAGS) $< -o $@
 
-%.so: $(OBJECTS) .export.sym
+%.d: %.c
+	$(MKDIR_P) $(dir $@); \
+	set -e; \
+	FILE=`echo $@ | sed 's/\\//\\\\\\//g;s/\\.d//g'`; \
+	DEPS=`echo $(DEPS) | sed -e 's/\\//\\\\\\//g'`; \
+	$(CC) -MM $(INCLUDES) $(DEFS) $(CFLAGS) -o $@ $<; \
+	sed -i "s/\(.*\)\.o[ :]*/$$FILE.o $$FILE.d $$FILE.pot: $$DEPS /g" $@; \
+	[ -s $@ ] || $(RM) $@
+
+%.so: $(OBJECTS) $(top_srcdir)/lib/.export.sym
 
 %.so: $(OBJECTS)
 	$(CC) -shared -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
-	-Wl,--version-script,.export.sym $(OBJECTS) -o $@ -ldevmapper-event
+	-Wl,--version-script,$(top_srcdir)/lib/.export.sym $(OBJECTS) -o $@ -ldevmapper-event
 
 $(LIB_STATIC): $(OBJECTS)
 	$(RM) $@
@@ -147,10 +158,11 @@
 	      config.cache config.log config.status \
 	      Makefile make.tmpl core tools/version.h
 
-ifneq ($(MAKECMDGOALS),clean)
-  ifneq ($(MAKECMDGOALS),distclean)
+ifeq (,$(findstring $(MAKECMDGOALS), clean distclean))
     ifdef SOURCES
        -include $(SOURCES:.c=.d)
     endif
-  endif
+    ifdef SOURCES2
+       -include $(SOURCES2:.c=.d)
+    endif
 endif
