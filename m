From: zkabelac@sourceware.org
Subject: dmraid ./configure ./configure.in ./make.tmpl. ...
Date: 30 May 2010 17:44:56 -0000
Message-ID: <20100530174456.7723.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 17:44:56

Modified files:
	.              : configure configure.in make.tmpl.in 
	include        : config.h.in 
Added files:
	lib            : version.h.in 

Log message:
	Use LD_DEPS and CLDFLAGS in Makefiles
	Move DEBUG and DEBUG_MALLOC to config.h
	Add _LARGEFILE64_SOURCE to config.h
	Define DMRAID_LIB_MAJOR/MINOR/SUBMINOR/SUFFIX/DATE
	Generate lib/version.h
	Use $(SED) in Makefiles
	Move -include to $(INCLUDE)
	Add DISTCLEAN_TARGETS to removed files by distclean

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.9&r2=1.10
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/config.h.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.in.diff?cvsroot=dm&r1=NONE&r2=1.1

--- dmraid/configure	2010/05/29 21:31:35	1.9
+++ dmraid/configure	2010/05/30 17:44:55	1.10
@@ -642,9 +642,14 @@
 STATIC_LINK
 SOFLAG
 LIB_SO
-FLAVOUR
 LD_DEPS
 JOBS
+FLAVOUR
+DMRAID_LIB_SUFFIX
+DMRAID_LIB_SUBMINOR
+DMRAID_LIB_MINOR
+DMRAID_LIB_MAJOR
+DMRAID_LIB_DATE
 DIETLIBC
 DEBUG_MALLOC
 DEBUG
@@ -6334,8 +6339,8 @@
 	case "$host_os" in
 		linux*)
 			CFLAGS=-O2
-			CLDFLAGS="-Wl,--version-script,.export.sym"
-			LD_DEPS=".export.sym"
+			CLDFLAGS='-Wl,--version-script,$(top_srcdir)/lib/.export.sym'
+			LD_DEPS='$(top_srcdir)/lib/.export.sym'
 			SOFLAG="-shared" ;;
 	esac
 fi
@@ -6397,7 +6402,7 @@
 $as_echo "$as_me: error: You cannot enable both dietlibc and klibc!" >&2;}
    { (exit 1); exit 1; }; }
 	fi
-        CC="diet gcc"
+	CC="diet gcc"
 	FLAVOUR="dietlibc "
 fi
 
@@ -6509,7 +6514,7 @@
 #define DMRAID_INTEL_LED 1
 _ACEOF
 
-        DMRAID_LED=yes
+	DMRAID_LED=yes
 fi
 
 if test "$DMRAID_LED" = yes; then
@@ -6528,9 +6533,29 @@
 
 fi
 
+if test "$DEBUG" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DEBUG 1
+_ACEOF
+
+	FLAVOUR="${FLAVOUR}debug "
+fi
+
+if test "$DEBUG_MALLOC" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DEBUG_MALLOC 1
+_ACEOF
+
+	FLAVOUR="${FLAVOUR}debug_malloc "
+fi
+
+
+cat >>confdefs.h <<\_ACEOF
+#define _LARGEFILE64_SOURCE 1
+_ACEOF
 
-test "$DEBUG" = yes && FLAVOUR="${FLAVOUR}debug "
-test "$DEBUG_MALLOC" = yes && FLAVOUR="${FLAVOUR}debug_malloc "
 
 test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
 
@@ -8124,6 +8149,18 @@
 
 fi
 
+VERSION=$srcdir/tools/VERSION
+DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
+DMRAID_LIB_MINOR=$(cut -d. -f2 $VERSION)
+DMRAID_LIB_SUBMINOR=$(cut -d. -f3 $VERSION)
+DMRAID_LIB_SUFFIX=$(cut -d. -f4 $VERSION | cut -d' ' -f1)
+DMRAID_LIB_DATE=$(cut -d' ' -f2 $VERSION)
+
+
+
+
+
+
 
 
 
@@ -8140,7 +8177,7 @@
 
 
 
-ac_config_files="$ac_config_files include/Makefile lib/Makefile man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
+ac_config_files="$ac_config_files include/Makefile lib/Makefile lib/version.h man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
 # This file is a shell script that caches the results of configure
@@ -8741,6 +8778,7 @@
     "include/config.h") CONFIG_HEADERS="$CONFIG_HEADERS include/config.h:include/config.h.in" ;;
     "include/Makefile") CONFIG_FILES="$CONFIG_FILES include/Makefile" ;;
     "lib/Makefile") CONFIG_FILES="$CONFIG_FILES lib/Makefile" ;;
+    "lib/version.h") CONFIG_FILES="$CONFIG_FILES lib/version.h" ;;
     "man/Makefile") CONFIG_FILES="$CONFIG_FILES man/Makefile" ;;
     "tools/Makefile") CONFIG_FILES="$CONFIG_FILES tools/Makefile" ;;
     "tools/version.h") CONFIG_FILES="$CONFIG_FILES tools/version.h" ;;
--- dmraid/configure.in	2010/05/29 21:31:35	1.9
+++ dmraid/configure.in	2010/05/30 17:44:55	1.10
@@ -73,8 +73,8 @@
 	case "$host_os" in
 		linux*)
 			CFLAGS=-O2
-			CLDFLAGS="-Wl,--version-script,.export.sym"
-			LD_DEPS=".export.sym"
+			CLDFLAGS='-Wl,--version-script,$(top_srcdir)/lib/.export.sym'
+			LD_DEPS='$(top_srcdir)/lib/.export.sym'
 			SOFLAG="-shared" ;;
 	esac
 fi
@@ -113,7 +113,7 @@
 	if test x$KLIBC = xyes; then
 		AC_MSG_ERROR([You cannot enable both dietlibc and klibc!])
 	fi
-        CC="diet gcc"
+	CC="diet gcc"
 	FLAVOUR="dietlibc "
 fi
 
@@ -186,21 +186,29 @@
 fi
 
 if test "$DMRAID_INTEL_LED" = yes; then
-        AC_DEFINE(DMRAID_INTEL_LED, 1, [Define to 1 if you want Intel LED support.])
-        DMRAID_LED=yes
+	AC_DEFINE(DMRAID_INTEL_LED, 1, [Define to 1 if you want Intel LED support.])
+	DMRAID_LED=yes
 fi
 
 if test "$DMRAID_LED" = yes; then
-        AC_DEFINE(DMRAID_LED, 1, [Define to 1 if you want LED support.])
+	AC_DEFINE(DMRAID_LED, 1, [Define to 1 if you want LED support.])
 fi
 
 if test "$DMRAID_TEST" = yes; then
-        AC_DEFINE(DMRAID_TEST, 1, [Define to 1 if you want to test mapped devices.])
+	AC_DEFINE(DMRAID_TEST, 1, [Define to 1 if you want to test mapped devices.])
 fi
 
+if test "$DEBUG" = yes; then
+	AC_DEFINE(DEBUG, 1, [Define to 1 if you want debug.])
+	FLAVOUR="${FLAVOUR}debug "
+fi
+
+if test "$DEBUG_MALLOC" = yes; then
+	AC_DEFINE(DEBUG_MALLOC, 1, [Define to 1 if you want to debug malloc.])
+	FLAVOUR="${FLAVOUR}debug_malloc "
+fi
 
-test "$DEBUG" = yes && FLAVOUR="${FLAVOUR}debug "
-test "$DEBUG_MALLOC" = yes && FLAVOUR="${FLAVOUR}debug_malloc "
+AC_DEFINE(_LARGEFILE64_SOURCE, 1, [Define to 1 if you want compile with large file.])
 
 dnl Mess with default exec_prefix
 test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
@@ -224,15 +232,27 @@
 	AC_CHECK_HEADERS(getopt.h, AC_DEFINE(HAVE_GETOPTLONG, 1, [Define to 1 for longopt.]))
 fi
 
+VERSION=$srcdir/tools/VERSION
+DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
+DMRAID_LIB_MINOR=$(cut -d. -f2 $VERSION)
+DMRAID_LIB_SUBMINOR=$(cut -d. -f3 $VERSION)
+DMRAID_LIB_SUFFIX=$(cut -d. -f4 $VERSION | cut -d' ' -f1)
+DMRAID_LIB_DATE=$(cut -d' ' -f2 $VERSION)
+
 AC_SUBST(CC)
 AC_SUBST(CFLAGS)
 AC_SUBST(CLDFLAGS)
 AC_SUBST(DEBUG)
 AC_SUBST(DEBUG_MALLOC)
 AC_SUBST(DIETLIBC)
+AC_SUBST(DMRAID_LIB_DATE)
+AC_SUBST(DMRAID_LIB_MAJOR)
+AC_SUBST(DMRAID_LIB_MINOR)
+AC_SUBST(DMRAID_LIB_SUBMINOR)
+AC_SUBST(DMRAID_LIB_SUFFIX)
+AC_SUBST(FLAVOUR)
 AC_SUBST(JOBS)
 AC_SUBST(LD_DEPS)
-AC_SUBST(FLAVOUR)
 AC_SUBST(LIBS)
 AC_SUBST(LIB_SO)
 AC_SUBST(SOFLAG)
@@ -245,6 +265,7 @@
 AC_OUTPUT(
 include/Makefile
 lib/Makefile
+lib/version.h
 man/Makefile
 tools/Makefile
 tools/version.h
--- dmraid/make.tmpl.in	2010/05/29 21:34:41	1.10
+++ dmraid/make.tmpl.in	2010/05/30 17:44:55	1.11
@@ -17,6 +17,11 @@
 LIBS = @LIBS@
 AWK = @AWK@
 SED = @SED@
+DMRAID_LIB_MAJOR = @DMRAID_LIB_MAJOR@
+DMRAID_LIB_MINOR = @DMRAID_LIB_MINOR@
+DMRAID_LIB_SUBMINOR = @DMRAID_LIB_SUBMINOR@
+DMRAID_LIB_SUFFIX = @DMRAID_LIB_SUFFIX@
+DMRAID_LIB_DATE = @DMRAID_LIB_DATE@
 
 CFLAGS += @CFLAGS@
 CLDFLAGS += @CLDFLAGS@
@@ -44,11 +49,10 @@
 endif
 
 # setup misc variables
-DMRAID_VERSION := $(shell cat $(top_srcdir)/tools/VERSION)
-DMRAID_LIB_VERSION := $(shell $(SED) --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
 INSTALL_PROGRAM = $(INSTALL) $(STRIP)
 INSTALL_DIR = $(INSTALL) -d
 INSTALL_DATA = $(INSTALL) -m 644 -p
+DISTCLEAN_TARGETS += Makefile
 
 # The number of jobs to run, if blank, defaults to the make standard
 ifndef MAKEFLAGS
@@ -64,17 +68,13 @@
   CFLAGS+=-Wshadow -Wmissing-prototypes -Wmissing-declarations -Wnested-externs
 endif
 
-ifeq ("@DMRAID_TEST@", "yes")
-  CFLAGS+=-DDMRAID_TEST
-endif
-
 # Don't allow for linking against DSO with static binary.
 ifeq ("@STATIC_LINK@", "no")
 	CFLAGS+=-DDMRAID_AUTOREGISTER
 endif
 
 ifeq ("@DEBUG@", "yes")
-  CFLAGS+=-g -fno-omit-frame-pointer -DDEBUG
+  CFLAGS+=-g -fno-omit-frame-pointer
 else
   ifeq ("@KLIBC@", "no")
     CFLAGS+=-O2
@@ -83,17 +83,12 @@
   endif
 endif
 
-ifeq ("@DEBUG_MALLOC@", "yes")
-  CFLAGS+=-DDEBUG_MALLOC
-endif
-
-CFLAGS+=-D_LARGEFILE64_SOURCE
-
-INCLUDES+=-I. -I$(top_srcdir)/include -I$(top_srcdir)/lib
-
+INCLUDES += -I. -I$(top_srcdir)/include -I$(top_srcdir)/lib
+INCLUDES += -include $(top_builddir)/include/config.h
 STRIP=
 
-DEPS=$(top_srcdir)/make.tmpl $(top_srcdir)/tools/VERSION Makefile
+DEPS = Makefile $(top_srcdir)/make.tmpl \
+	$(top_srcdir)/tools/VERSION $(top_builddir)/include/config.h
 
 OBJECTS=$(SOURCES:%.c=%.o)
 OBJECTS2=$(SOURCES2:%.c=%.o)
@@ -130,16 +125,16 @@
 
 $(TARGETS): $(OBJECTS)
 
-%.o: %.c $(top_builddir)/include/config.h
-	$(CC) -o $@ -c $(INCLUDES) $(CFLAGS) -include $(top_builddir)/include/config.h $<
+%.o: %.c
+	$(CC) -o $@ -c $(INCLUDES) $(CFLAGS) $<
 
 %.d: %.c
 	$(MKDIR_P) $(dir $@); \
 	set -e; \
-	FILE=`echo $@ | sed 's/\\//\\\\\\//g;s/\\.d//g'`; \
-	DEPS=`echo $(DEPS) | sed -e 's/\\//\\\\\\//g'`; \
+	FILE=`echo $@ | $(SED) 's/\\//\\\\\\//g;s/\\.d//g'`; \
+	DEPS=`echo $(DEPS) | $(SED) -e 's/\\//\\\\\\//g'`; \
 	$(CC) -MM $(INCLUDES) $(DEFS) $(CFLAGS) -o $@ $<; \
-	sed -i "s/\(.*\)\.o[ :]*/$$FILE.o $$FILE.d $$FILE.pot: $$DEPS /g" $@; \
+	$(SED) -i "s/\(.*\)\.o[ :]*/$$FILE.o $$FILE.d $$FILE.pot: $$DEPS /g" $@; \
 	[ -s $@ ] || $(RM) $@
 
 $(LIB_STATIC): $(OBJECTS)
@@ -148,14 +143,12 @@
 	$(RANLIB) $@
 
 cleandir:
-	$(RM) $(OBJECTS) $(OBJECTS2) $(TARGETS) $(CLEAN_TARGETS) \
-		$(SOURCES:%.c=%.d) $(SOURCES2:%.c=%.d)
+	$(RM) $(OBJECTS) $(OBJECTS2) $(SOURCES:%.c=%.d) $(SOURCES2:%.c=%.d) $(TARGETS)
 
 clean: $(SUBDIRS.clean) cleandir
 
 distclean: $(SUBDIRS.distclean) cleandir
-	$(RM) cscope.out config.cache config.log config.status \
-		Makefile make.tmpl core tools/version.h
+	$(RM) $(DISTCLEAN_TARGETS)
 
 ifeq (,$(findstring $(MAKECMDGOALS), clean distclean))
     ifdef SOURCES
--- dmraid/include/config.h.in	2010/05/29 21:31:33	1.1
+++ dmraid/include/config.h.in	2010/05/30 17:44:55	1.2
@@ -1,5 +1,11 @@
 /* include/config.h.in.  Generated from configure.in by autoheader.  */
 
+/* Define to 1 if you want debug. */
+#undef DEBUG
+
+/* Define to 1 if you want to debug malloc. */
+#undef DEBUG_MALLOC
+
 /* Define to 1 if you want Intel LED support. */
 #undef DMRAID_INTEL_LED
 
@@ -172,6 +178,9 @@
 /* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
 #undef TIME_WITH_SYS_TIME
 
+/* Define to 1 if you want compile with large file. */
+#undef _LARGEFILE64_SOURCE
+
 /* Define for Solaris 2.5.1 so the uint32_t typedef from <sys/synch.h>,
    <pthread.h>, or <semaphore.h> is not used. If the typedef were allowed, the
    #define below would cause a syntax error. */
/cvs/dm/dmraid/lib/version.h.in,v  -->  standard output
revision 1.1
--- dmraid/lib/version.h.in
+++ -	2010-05-30 17:44:56.868513000 +0000
@@ -0,0 +1,9 @@
+#ifndef	DMRAID_LIB_DATE
+
+#define	DMRAID_LIB_DATE			"@DMRAID_LIB_DATE@"
+#define	DMRAID_LIB_MAJOR_VERSION	@DMRAID_LIB_MAJOR@
+#define	DMRAID_LIB_MINOR_VERSION	@DMRAID_LIB_MINOR@
+#define	DMRAID_LIB_SUBMINOR_VERSION	@DMRAID_LIB_SUBMINOR@
+#define	DMRAID_LIB_VERSION_SUFFIX	"@DMRAID_LIB_SUFFIX@"
+
+#endif
