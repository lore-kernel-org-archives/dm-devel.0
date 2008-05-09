From: Jim Meyering <jim@meyering.net>
Subject: Re: [dm-devel] merging configure.in between dm and lvm
Date: Fri, 09 May 2008 23:06:30 +0200
Message-ID: <87bq3fxk4p.fsf@rho.meyering.net>
References: <878wymxf6h.fsf@rho.meyering.net>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <878wymxf6h.fsf@rho.meyering.net> (Jim Meyering's message of
	"Wed, 07 May 2008 18:16:38 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Jim Meyering <jim@meyering.net> wrote:
> I'm in the process of merging the configure.in files used by lvm and
> device-mapper.  The goal is to make them as similar as reasonable while
> the two packages are still separate, so that once dm and lvm coexist
> there will only be minimal changes.
...
> I've eliminated most of the differences between the two configure.in
> files, but haven't yet done the binary-comparison bit with lvm
> (that'll be harder because there are far more combinations of
> configure-time options to test).  I'll probably post both configure.in
> patches tomorrow or Friday.  So, for now, here's a preliminary
> version of the proposed device-mapper configure.in changes:
> [omitting changes in derived+VC'd files]

Those were the changes for device-mapper.
Here are the analogous ones for lvm.
Tested with the following script:
(examining diffs shows no significant binary differences)
-----------------------------------
#!/bin/bash

t=/t/lvm-test
mkdir -p $t

opts='
readline
selinux
realtime
devmapper
o_direct
cmdlib
fsadm
dmeventd
nls
'

# debug
# static_link
# with-cluster=shared
# with-snapshots=shared
# with-mirrors=shared

set -e

srcdir=$HOME/w/co/lvm+dm/lvm2
srcdir=/t/lvm2
dmdir=$HOME/w/co/lvm+dm/device-mapper

for enable in enable disable; do
  for opt in $opts; do
    for br in master a-conf-merge; do
      cd $srcdir && git checkout $br
      o=$enable-$opt
      echo "============= $br --$o"

      (./configure --$o --with-dmdir=$dmdir CFLAGS=-g &&
	make -j5) > log 2>&1 &&
      cp log $t/log-$br-$o
      rm -rf $t/$br
      cp -al $PWD $t/$br
      find $t/$br -type l -delete
      git clean -f -d > /dev/null 2>&1
    done

    diff -ur \
      -x config.status -x config.log -x .git -x autom4te.cache -x configure \
      -x configure.in -x configure.h -x configure.h.in -x log -x '*.a' \
      $t/master $t/a-conf-merge > $t/diff-$o 2>&1 || :
  done
done

================================
Of course, this just enables/disables each of those options one at a
time, and doesn't do the n-choose-2, n-choose-3, etc. combinations.
BTW, I noticed that when configured with --disable-devmapper,
the build failed.  Does that option even make sense anymore?

From 08db02fcdaae14e2bbda42b13577e25681b3c94f Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Fri, 9 May 2008 16:29:44 +0200
Subject: [PATCH] Begin configure.in merge/unifyication with device-mapper.

---
 configure               | 6863 ++++++++++++++++++++++++++---------------------
 configure.in            |  187 +-
 lib/misc/configure.h.in |   20 +-
 3 files changed, 3916 insertions(+), 3154 deletions(-)

diff --git a/configure.in b/configure.in
index f726b22..1bbbfe9 100644
--- a/configure.in
+++ b/configure.in
@@ -1,8 +1,6 @@
-##
+###############################################################################
 ## Copyright (C) 2000-2004 Sistina Software, Inc. All rights reserved.
-## Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
-##
-## This file is part of LVM2.
+## Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
 ##
 ## This copyrighted material is made available to anyone wishing to use,
 ## modify, copy, or redistribute it subject to the terms and conditions
@@ -32,41 +30,45 @@ AC_CANONICAL_TARGET([])

 case "$host_os" in
 	linux*)
-		CFLAGS="$CFLAGS"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS -Wl,--version-script,.export.sym"
 		CLDWHOLEARCHIVE="-Wl,-whole-archive"
 		CLDNOWHOLEARCHIVE="-Wl,-no-whole-archive"
 		LDDEPS="$LDDEPS .export.sym"
 		LDFLAGS="$LDFLAGS -Wl,--export-dynamic"
-		LIB_SUFFIX="so"
+		LIB_SUFFIX=so
 		DEVMAPPER=yes
 		ODIRECT=yes
+		DMIOCTLS=yes
 		SELINUX=yes
 		REALTIME=yes
 		CLUSTER=internal
-		FSADM=no ;;
+		FSADM=no
+		;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS"
 		CLDWHOLEARCHIVE="-all_load"
 		CLDNOWHOLEARCHIVE=
-		LDDEPS="$LDDEPS"
-		LDFLAGS="$LDFLAGS"
-		LIB_SUFFIX="dylib"
+		LIB_SUFFIX=dylib
 		DEVMAPPER=yes
 		ODIRECT=no
+		DMIOCTLS=no
 		SELINUX=no
 		REALTIME=no
 		CLUSTER=none
-		FSADM=no ;;
+		FSADM=no
+		;;
 esac

 ################################################################################
 dnl -- Checks for programs.
 AC_PROG_AWK
 AC_PROG_CC
+
+dnl probably no longer needed in 2008, but...
+AC_PROG_GCC_TRADITIONAL
 AC_PROG_INSTALL
 AC_PROG_LN_S
 AC_PROG_MAKE_SET
@@ -81,8 +83,9 @@ AC_HEADER_STDC
 AC_HEADER_SYS_WAIT
 AC_HEADER_TIME

-AC_CHECK_HEADERS(fcntl.h limits.h locale.h stddef.h syslog.h sys/file.h sys/ioctl.h sys/param.h sys/time.h,,AC_MSG_ERROR(bailing out))
-AC_CHECK_HEADERS(assert.h ctype.h libgen.h signal.h stdio.h sys/mman.h sys/resource.h sys/stat.h sys/types.h sys/utsname.h sys/wait.h time.h,,AC_MSG_ERROR(bailing out))
+AC_CHECK_HEADERS([locale.h stddef.h syslog.h sys/file.h sys/time.h assert.h \
+  libgen.h signal.h sys/mman.h sys/resource.h sys/utsname.h sys/wait.h time.h], ,
+  [AC_MSG_ERROR(bailing out)])

 case "$host_os" in
 	linux*)
@@ -91,12 +94,18 @@ case "$host_os" in
 		AC_CHECK_HEADERS(machine/endian.h sys/disk.h,,AC_MSG_ERROR(bailing out)) ;;
 esac

+AC_CHECK_HEADERS([ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h \
+  stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h \
+  sys/types.h unistd.h], , [AC_MSG_ERROR(bailing out)])
+AC_CHECK_HEADERS(termios.h sys/statvfs.h)
 ################################################################################
 dnl -- Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 AC_C_INLINE
+AC_CHECK_MEMBERS([struct stat.st_rdev])
 AC_TYPE_OFF_T
 AC_TYPE_PID_T
+AC_TYPE_SIGNAL
 AC_TYPE_SIZE_T
 AC_TYPE_MODE_T
 AC_CHECK_MEMBERS([struct stat.st_rdev])
@@ -104,7 +113,9 @@ AC_STRUCT_TM

 ################################################################################
 dnl -- Check for functions
-AC_CHECK_FUNCS(gethostname getpagesize memset munmap setlocale strcasecmp strchr strdup strncasecmp strerror strrchr strstr strtol strtoul,,AC_MSG_ERROR(bailing out))
+AC_CHECK_FUNCS([gethostname getpagesize memset mkdir rmdir munmap setlocale \
+  strcasecmp strchr strdup strncasecmp strerror strrchr strstr strtol strtoul \
+  uname], , [AC_MSG_ERROR(bailing out)])
 AC_FUNC_ALLOCA
 AC_FUNC_CLOSEDIR_VOID
 AC_FUNC_FORK
@@ -114,22 +125,19 @@ AC_FUNC_MEMCMP
 AC_FUNC_MMAP
 AC_FUNC_STAT
 AC_FUNC_STRTOD
+AC_FUNC_VPRINTF

 ################################################################################
 dnl -- Prefix is /usr by default, the exec_prefix default is setup later
 AC_PREFIX_DEFAULT(/usr)

 ################################################################################
-dnl -- Parallel make jobs?
-AC_ARG_ENABLE(jobs, [  --enable-jobs=NUM       Number of jobs to run simultaneously], JOBS=-j$enableval, JOBS=-j2)
-
-################################################################################
 dnl -- Setup the ownership of the files
 AC_MSG_CHECKING(file owner)
 OWNER="root"

 AC_ARG_WITH(user,
-  [  --with-user=USER        Set the owner of installed files ],
+  [  --with-user=USER        Set the owner of installed files [[USER=root]] ],
   [ OWNER="$withval" ])
 AC_MSG_RESULT($OWNER)

@@ -142,7 +150,7 @@ dnl -- Setup the group ownership of the files
 AC_MSG_CHECKING(group owner)
 GROUP="root"
 AC_ARG_WITH(group,
-  [  --with-group=GROUP      Set the group owner of installed files ],
+  [  --with-group=GROUP      Set the group owner of installed files [[GROUP=root]] ],
   [ GROUP="$withval" ])
 AC_MSG_RESULT($GROUP)

@@ -261,13 +269,6 @@ if test x$MIRRORS = xinternal; then
 fi

 ################################################################################
-dnl -- Enables staticly-linked tools
-AC_MSG_CHECKING(whether to use static linking)
-AC_ARG_ENABLE(static_link, [  --enable-static_link    Use this to link the tools to their libraries
-                          statically.  Default is dynamic linking],  STATIC_LINK=$enableval, STATIC_LINK=no)
-AC_MSG_RESULT($STATIC_LINK)
-
-################################################################################
 dnl -- Enable readline
 AC_MSG_CHECKING(whether to enable readline)
 AC_ARG_ENABLE(readline, [  --enable-readline       Enable readline support],
@@ -279,13 +280,6 @@ if test x$READLINE = xyes; then
 fi

 ################################################################################
-dnl -- Disable selinux
-AC_MSG_CHECKING(whether to enable selinux support)
-AC_ARG_ENABLE(selinux, [  --disable-selinux       Disable selinux support],
-SELINUX=$enableval)
-AC_MSG_RESULT($SELINUX)
-
-################################################################################
 dnl -- Disable realtime clock support
 AC_MSG_CHECKING(whether to enable realtime support)
 AC_ARG_ENABLE(realtime, [  --disable-realtime      Disable realtime clock support],
@@ -328,7 +322,7 @@ fi
 dnl -- Override optimisation
 AC_MSG_CHECKING(for C optimisation flag)
 AC_ARG_WITH(optimisation,
-  [  --with-optimisation=OPT C optimisation flag [OPT=-O2] ],
+  [  --with-optimisation=OPT C optimisation flag [[OPT=-O2]] ],
   [ COPTIMISE_FLAG="$withval" ])
 AC_MSG_RESULT($COPTIMISE_FLAG)

@@ -386,19 +380,12 @@ if test x$DMEVENTD = xyes; then
 	AC_DEFINE([DMEVENTD], 1, [Define to 1 to enable the device-mapper event daemon.])
 fi
 ################################################################################
-dnl -- Mess with default exec_prefix
+dnl -- Clear default exec_prefix - install into /sbin rather than /usr/sbin
 if [[ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ]];
  then  exec_prefix="";
 fi;

 ################################################################################
-dnl -- Checks for library functions.
-AC_PROG_GCC_TRADITIONAL
-AC_TYPE_SIGNAL
-AC_FUNC_VPRINTF
-AC_CHECK_FUNCS(mkdir rmdir uname,,AC_MSG_ERROR(bailing out))
-
-################################################################################
 dnl -- Check for termcap (Shamelessly copied from parted 1.4.17)
 if test x$READLINE = xyes; then
 	AC_SEARCH_LIBS(tgetent, ncurses curses termcap termlib, ,
@@ -437,11 +424,29 @@ Features cannot be 'shared' when building statically
 fi

 ################################################################################
+dnl -- Enables statically-linked tools
+AC_MSG_CHECKING(whether to use static linking)
+AC_ARG_ENABLE(static_link,
+  [  --enable-static_link    Use this to link the tools to their libraries
+                          statically.  Default is dynamic linking],
+  STATIC_LINK=$enableval, STATIC_LINK=no)
+AC_MSG_RESULT($STATIC_LINK)
+
+################################################################################
+dnl -- Disable selinux
+AC_MSG_CHECKING(whether to enable selinux support)
+AC_ARG_ENABLE(selinux, [  --disable-selinux       Disable selinux support],
+SELINUX=$enableval)
+AC_MSG_RESULT($SELINUX)
+
+################################################################################
 dnl -- Check for selinux
 if test x$SELINUX = xyes; then
 	AC_CHECK_LIB(sepol, sepol_check_context, HAVE_SEPOL=yes, HAVE_SEPOL=no)

 	if test x$HAVE_SEPOL = xyes; then
+		AC_DEFINE([HAVE_SEPOL], 1,
+		  [Define to 1 if sepol_check_context is available.])
 		LIBS="-lsepol $LIBS"
 	fi

@@ -454,7 +459,7 @@ if test x$SELINUX = xyes; then
 		AC_MSG_WARN(Disabling selinux)
 	fi

-	# With --enable-static_link and selinux enabled, linking lvm.static
+	# With --enable-static_link and selinux enabled, linking
 	# fails on at least Debian unstable due to unsatisfied references
 	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
 	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
@@ -482,7 +487,7 @@ fi

 ################################################################################
 dnl -- Check for getopt
-AC_CHECK_HEADERS(getopt.h, AC_DEFINE([HAVE_GETOPTLONG], 1, [Define to 1 to if getopt_long is available.]))
+AC_CHECK_HEADERS(getopt.h, AC_DEFINE([HAVE_GETOPTLONG], 1, [Define to 1 if getopt_long is available.]))

 ################################################################################
 dnl -- Check for readline (Shamelessly copied from parted 1.4.17)
@@ -517,25 +522,25 @@ if test x$INTL = xyes; then
 	fi;

 	AC_ARG_WITH(localedir,
-  		    [  --with-localedir=DIR    Translation files in DIR [PREFIX/share/locale]],
-  		    [ LOCALEDIR="$withval" ],
-  		    [ LOCALEDIR='${prefix}/share/locale' ])
+		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
+		    [ LOCALEDIR="$withval" ],
+		    [ LOCALEDIR='${prefix}/share/locale' ])
 fi

 ################################################################################
 AC_ARG_WITH(confdir,
 	    [  --with-confdir=DIR      Configuration files in DIR [/etc]],
-  	    [ CONFDIR="$withval" ],
- 	    [ CONFDIR='/etc' ])
+	    [ CONFDIR="$withval" ],
+	    [ CONFDIR='/etc' ])

 AC_ARG_WITH(staticdir,
 	    [  --with-staticdir=DIR    Static binary in DIR [EXEC_PREFIX/sbin]],
-  	    [ STATICDIR="$withval" ],
- 	    [ STATICDIR='${exec_prefix}/sbin' ])
+	    [ STATICDIR="$withval" ],
+	    [ STATICDIR='${exec_prefix}/sbin' ])

 AC_ARG_WITH(dmdir,
 	    [  --with-dmdir=DIR        Build against device-mapper source tree in DIR],
-  	    [ DMDIR="$withval" CPPFLAGS="$CPPFLAGS -I$DMDIR/include"],
+	    [ DMDIR="$withval" CPPFLAGS="$CPPFLAGS -I$DMDIR/include"],
 	    [ DMDIR= ])

 # Convert a relative dir name to absolute.
@@ -585,51 +590,59 @@ if test x$MODPROBE_CMD != x; then
 fi

 ################################################################################
-if test "-f VERSION"; then
-  LVM_VERSION="\"`cat VERSION`\""
-else
-  LVM_VERSION="Unknown"
-fi
+LVM_VERSION="\"`cat VERSION 2>/dev/null || echo Unknown`\""

 ################################################################################
-AC_SUBST(JOBS)
-AC_SUBST(STATIC_LINK)
-AC_SUBST(LVM1)
-AC_SUBST(POOL)
-AC_SUBST(SNAPSHOTS)
-AC_SUBST(MIRRORS)
-AC_SUBST(OWNER)
-AC_SUBST(GROUP)
 AC_SUBST(CFLAGS)
-AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CFLOW_CMD)
 AC_SUBST(CLDFLAGS)
-AC_SUBST(CLDWHOLEARCHIVE)
 AC_SUBST(CLDNOWHOLEARCHIVE)
-AC_SUBST(LDDEPS)
-AC_SUBST(LDFLAGS)
-AC_SUBST(LIB_SUFFIX)
-AC_SUBST(LIBS)
-AC_SUBST(LVM_VERSION)
-AC_SUBST(LVM1_FALLBACK)
+AC_SUBST(CLDWHOLEARCHIVE)
+AC_SUBST(CLUSTER)
+AC_SUBST(CLVMD)
+AC_SUBST(CMDLIB)
+# FIXME: rename to DEVICE_MAPPER_COMPAT
+AC_SUBST(COMPAT)
+# FIXME: rename to LVM_ETC_DIR
+AC_SUBST(CONFDIR)
+AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CSCOPE_CMD)
 AC_SUBST(DEBUG)
+# FIXME: rename to start with DM_
+AC_SUBST(DEVICE_GID)
+# FIXME: rename to start with DM_
+AC_SUBST(DEVICE_MODE)
+# FIXME: rename to start with DM_
+AC_SUBST(DEVICE_UID)
 AC_SUBST(DEVMAPPER)
+AC_SUBST(DMDIR)
+# FIXME: rename to LVM_USE_DMEVENTD
+AC_SUBST(DMEVENTD)
+AC_SUBST(DMIOCTLS)
+AC_SUBST(DM_LIB_VERSION)
+AC_SUBST(FSADM)
+AC_SUBST(GROUP)
 AC_SUBST(HAVE_LIBDL)
-AC_SUBST(HAVE_SELINUX)
 AC_SUBST(HAVE_REALTIME)
-AC_SUBST(CMDLIB)
-AC_SUBST(MSGFMT)
+AC_SUBST(HAVE_SELINUX)
+AC_SUBST(INTL)
+AC_SUBST(INTL_PACKAGE)
+AC_SUBST(JOBS)
+AC_SUBST(LDDEPS)
+AC_SUBST(LIBS)
+AC_SUBST(LIB_SUFFIX)
 AC_SUBST(LOCALEDIR)
-AC_SUBST(CONFDIR)
+AC_SUBST(LVM1)
+AC_SUBST(LVM1_FALLBACK)
+AC_SUBST(LVM_VERSION)
+AC_SUBST(MIRRORS)
+AC_SUBST(MSGFMT)
+AC_SUBST(OWNER)
+AC_SUBST(PKGCONFIG)
+AC_SUBST(POOL)
+AC_SUBST(SNAPSHOTS)
 AC_SUBST(STATICDIR)
-AC_SUBST(DMDIR)
-AC_SUBST(INTL_PACKAGE)
-AC_SUBST(INTL)
-AC_SUBST(CLVMD)
-AC_SUBST(CLUSTER)
-AC_SUBST(FSADM)
-AC_SUBST(DMEVENTD)
-AC_SUBST(CFLOW_CMD)
-AC_SUBST(CSCOPE_CMD)
+AC_SUBST(STATIC_LINK)
 AC_SUBST([LIB_PTHREAD])

 ################################################################################

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
