From: Jim Meyering <jim@meyering.net>
Subject: merging configure.in between dm and lvm
Date: Wed, 07 May 2008 18:16:38 +0200
Message-ID: <878wymxf6h.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm in the process of merging the configure.in files used by lvm and
device-mapper.  The goal is to make them as similar as reasonable while
the two packages are still separate, so that once dm and lvm coexist
there will only be minimal changes.

Some of my goals:
  - no changes in binaries
  - minimize user-visible changes
      [ so far there's one: I removed the --enable-jobs=NUM option. ]

Several types of changes:

For example, I've added some functions and header checks in dm's
configure.in that are not technically required, because they are required
for lvm.  Similarly, I've added a few in lvm's because dm had them.

I've adjusted autoconf quoting and reordered stanzas so
common ones line up (minimizing diffs).

I've shortened some of the longer-than-80-byte lines so that
I can see what's going on in a side-by-side diff.
-------------------

To ensure that no binary changes are induced into device-mapper, I did
this with a git tree, with the proposed changes on the a-conf-merge
branch.  I.e., simply configure and build twice (once with the patch
and once without), and compare the resulting trees, ignoring the files
we expect to change.

shell aliases:
alias g=git
alias Rm='command rm'

part of my ~/.gitconfig file (so e.g., 'g co' works like 'git checkout')
[alias]
	st = status
	co = checkout
	ci = commit
	br = branch

================================================
t=/tmp
g co a-conf-merge
autoreconf && ./configure CFLAGS=-g && make &&
  Rm -rf $t/patched && cp -a "$PWD" $t/patched
make distclean
g reset --hard HEAD

g co master
autoreconf && ./configure CFLAGS=-g && make &&
  Rm -rf $t/orig && cp -a "$PWD" $t/orig
make distclean
g reset --hard HEAD

diff -ur \
  -x config.status -x config.log -x .git -x autom4te.cache -x configure \
  -x configure.in -x configure.h -x configure.h.in -x libdevmapper.a \
  $t/orig $t/patched
================================================

I've eliminated most of the differences between the two configure.in
files, but haven't yet done the binary-comparison bit with lvm
(that'll be harder because there are far more combinations of
configure-time options to test).  I'll probably post both configure.in
patches tomorrow or Friday.  So, for now, here's a preliminary
version of the proposed device-mapper configure.in changes:
[omitting changes in derived+VC'd files]

Note that there are some FIXME comments near the end.
They mark some symbols whose names should be changed in the unified tree.
I'm sure there are more.  I can change them now or in a subsequent patch.
I'd prefer "later", so I can keep changes that also affect C code
separate for now.

Suggestions/feedback welcome,

Jim

---
 configure              | 5700 ++++++++++++++++++++++++++++++++++++------------
 configure.in           |  229 ++-
 include/configure.h.in |   92 +-
 3 files changed, 4509 insertions(+), 1512 deletions(-)

diff --git a/configure.in b/configure.in
index cab496f..ff6cf75 100644
--- a/configure.in
+++ b/configure.in
@@ -1,8 +1,6 @@
 ###############################################################################
-## Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-## Copyright (C) 2004 Red Hat, Inc. All rights reserved.
-##
-## This file is part of the device-mapper userspace tools.
+## Copyright (C) 2000-2004 Sistina Software, Inc. All rights reserved.
+## Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
 ##
 ## This copyrighted material is made available to anyone wishing to use,
 ## modify, copy, or redistribute it subject to the terms and conditions
@@ -11,7 +9,6 @@
 ## You should have received a copy of the GNU General Public License
 ## along with this program; if not, write to the Free Software Foundation,
 ## Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-## MA 02111-1307, USA
 ################################################################################

 AC_PREREQ(2.57)
@@ -25,7 +22,7 @@ AC_CONFIG_HEADERS(include/configure.h)

 ################################################################################
 dnl -- Setup the directory where autoconf has auxilary files
-AC_CONFIG_AUX_DIR(autoconf) 
+AC_CONFIG_AUX_DIR(autoconf)

 ################################################################################
 dnl -- Get system type
@@ -33,21 +30,35 @@ AC_CANONICAL_TARGET([])

 case "$host_os" in
 	linux*)
-		CFLAGS="$CFLAGS"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS -Wl,--version-script,.export.sym"
+		CLDWHOLEARCHIVE="-Wl,-whole-archive"
+		CLDNOWHOLEARCHIVE="-Wl,-no-whole-archive"
 		LDDEPS="$LDDEPS .export.sym"
-		LIB_SUFFIX="so"
-		DMIOCTLS="yes"
-		SELINUX="yes" ;;
+		LIB_SUFFIX=so
+		DEVMAPPER=yes
+		ODIRECT=yes
+		DMIOCTLS=yes
+		SELINUX=yes
+		REALTIME=yes
+		CLUSTER=internal
+		FSADM=no
+		;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS"
-		LDDEPS="$LDDEPS"
-		LIB_SUFFIX="dylib"
-		DMIOCTLS="no"
-		SELINUX="no" ;;
+		CLDWHOLEARCHIVE="-all_load"
+		CLDNOWHOLEARCHIVE=
+		LIB_SUFFIX=dylib
+		DEVMAPPER=yes
+		ODIRECT=no
+		DMIOCTLS=no
+		SELINUX=no
+		REALTIME=no
+		CLUSTER=none
+		FSADM=no
+		;;
 esac

 ################################################################################
@@ -58,20 +69,26 @@ usrlibdir='${prefix}/lib'
 dnl -- Checks for programs.
 AC_PROG_AWK
 AC_PROG_CC
+
+dnl probably no longer needed in 2008, but...
 AC_PROG_GCC_TRADITIONAL
 AC_PROG_INSTALL
 AC_PROG_LN_S
 AC_PROG_MAKE_SET
 AC_PROG_RANLIB
+AC_PATH_PROG(CFLOW_CMD, cflow)
+AC_PATH_PROG(CSCOPE_CMD, cscope)

 ################################################################################
 dnl -- Checks for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
+AC_HEADER_SYS_WAIT
 AC_HEADER_TIME

-AC_CHECK_HEADERS(ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h sys/types.h unistd.h,,AC_MSG_ERROR(bailing out))
-
+AC_CHECK_HEADERS([ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h \
+  stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h \
+  sys/types.h unistd.h], , [AC_MSG_ERROR(bailing out)])
 AC_CHECK_HEADERS(termios.h sys/statvfs.h)
 ################################################################################
 dnl -- Checks for typedefs, structures, and compiler characteristics.
@@ -82,13 +99,24 @@ AC_TYPE_OFF_T
 AC_TYPE_PID_T
 AC_TYPE_SIGNAL
 AC_TYPE_SIZE_T
+AC_TYPE_MODE_T
+AC_CHECK_MEMBERS([struct stat.st_rdev])
+AC_STRUCT_TM

 ################################################################################
-dnl -- Checks for functions
-AC_CHECK_FUNCS(memset mkdir rmdir strchr strdup strerror strrchr uname,,AC_MSG_ERROR(bailing out))
+dnl -- Check for functions
+AC_CHECK_FUNCS([gethostname getpagesize memset mkdir rmdir munmap setlocale \
+  strcasecmp strchr strdup strncasecmp strerror strrchr strstr strtol strtoul \
+  uname], , [AC_MSG_ERROR(bailing out)])
+AC_FUNC_ALLOCA
 AC_FUNC_CLOSEDIR_VOID
+AC_FUNC_FORK
+AC_FUNC_LSTAT
 AC_FUNC_MALLOC
+AC_FUNC_MEMCMP
+AC_FUNC_MMAP
 AC_FUNC_STAT
+AC_FUNC_STRTOD
 AC_FUNC_VPRINTF

 ################################################################################
@@ -96,10 +124,6 @@ dnl -- Prefix is /usr by default, the exec_prefix default is setup later
 AC_PREFIX_DEFAULT(/usr)

 ################################################################################
-dnl -- Parallel make jobs?
-AC_ARG_ENABLE(jobs, [  --enable-jobs=NUM       Number of jobs to run simultaneously], JOBS=-j$enableval)
-
-################################################################################
 dnl -- Setup the ownership of the files
 AC_MSG_CHECKING(file owner)
 OWNER="root"
@@ -154,7 +178,7 @@ AC_ARG_WITH(device-mode,
 AC_MSG_RESULT($DEVICE_MODE)

 ################################################################################
-dnl -- Enable Debugging
+dnl -- Enable debugging
 AC_MSG_CHECKING(whether to enable debugging)
 AC_ARG_ENABLE(debug,    [  --enable-debug          Enable debugging],
 DEBUG=$enableval, DEBUG=no)
@@ -163,6 +187,8 @@ AC_MSG_RESULT($DEBUG)
 dnl -- Normally turn off optimisation for debug builds
 if test x$DEBUG = xyes; then
 	COPTIMISE_FLAG=
+else
+	CSCOPE_CMD=
 fi

 ################################################################################
@@ -174,7 +200,7 @@ AC_ARG_WITH(optimisation,
 AC_MSG_RESULT($COPTIMISE_FLAG)

 ################################################################################
-dnl -- Disable Compatibility mode
+dnl -- Compatibility mode
 AC_ARG_ENABLE(compat,   [  --enable-compat         Enable support for old device-mapper versions],
 COMPAT=$enableval, COMPAT=no)

@@ -193,27 +219,32 @@ dnl -- Enable pkg-config
 AC_ARG_ENABLE(pkgconfig,   [  --enable-pkgconfig      Install pkgconfig support],
 PKGCONFIG=$enableval, PKGCONFIG=no)

-################################################################################
-dnl -- Enables staticly-linked tools
-AC_ARG_ENABLE(static_link, [  --enable-static_link    Use this to link the tools to their libraries
-                          statically.  Default is dynamic linking],  STATIC_LINK=$enableval, STATIC_LINK=no)
-
-################################################################################
 dnl -- Clear default exec_prefix - install into /sbin rather than /usr/sbin
 if [[ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ]];
  then  exec_prefix="";
 fi;

-
 ################################################################################
 dnl -- getline included in recent libc

-AC_CHECK_LIB(c, getline, AC_DEFINE([HAVE_GETLINE], 1, [Define to 1 if getline is available.]))
+AC_CHECK_LIB(c, getline, AC_DEFINE([HAVE_GETLINE], 1,
+  [Define to 1 if getline is available.]))

 ################################################################################
 dnl -- canonicalize_file_name included in recent libc

-AC_CHECK_LIB(c, canonicalize_file_name, AC_DEFINE([HAVE_CANONICALIZE_FILE_NAME], 1, [Define to 1 if canonicalize_file_name is available.]))
+AC_CHECK_LIB(c, canonicalize_file_name,
+  AC_DEFINE([HAVE_CANONICALIZE_FILE_NAME], 1,
+    [Define to 1 if canonicalize_file_name is available.]))
+
+################################################################################
+dnl -- Enables statically-linked tools
+AC_MSG_CHECKING(whether to use static linking)
+AC_ARG_ENABLE(static_link,
+  [  --enable-static_link    Use this to link the tools to their libraries
+                          statically.  Default is dynamic linking],
+  STATIC_LINK=$enableval, STATIC_LINK=no)
+AC_MSG_RESULT($STATIC_LINK)

 ################################################################################
 dnl -- Disable selinux
@@ -221,36 +252,37 @@ AC_MSG_CHECKING(whether to enable selinux support)
 AC_ARG_ENABLE(selinux, [  --disable-selinux       Disable selinux support],
 SELINUX=$enableval)
 AC_MSG_RESULT($SELINUX)
- 
+
 ################################################################################
 dnl -- Check for selinux
 if test x$SELINUX = xyes; then
 	AC_CHECK_LIB(sepol, sepol_check_context, HAVE_SEPOL=yes, HAVE_SEPOL=no)

 	if test x$HAVE_SEPOL = xyes; then
-		AC_DEFINE([HAVE_SEPOL], 1, [Define to 1 if sepol_check_context is available.])
+		AC_DEFINE([HAVE_SEPOL], 1,
+		  [Define to 1 if sepol_check_context is available.])
 		LIBS="-lsepol $LIBS"
 	fi

 	AC_CHECK_LIB(selinux, is_selinux_enabled, HAVE_SELINUX=yes, HAVE_SELINUX=no)

 	if test x$HAVE_SELINUX = xyes; then
-		AC_DEFINE([HAVE_SELINUX], 1, [Define to 1 if selinux is available.])
+		AC_DEFINE([HAVE_SELINUX], 1, [Define to 1 to include support for selinux.])
 		LIBS="-lselinux $LIBS"
 	else
 		AC_MSG_WARN(Disabling selinux)
 	fi

-	# With --enable-static_link and selinux enabled, linking dmsetup
+	# With --enable-static_link and selinux enabled, linking
 	# fails on at least Debian unstable due to unsatisfied references
 	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
 	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
-		dm_saved_libs=$LIBS
+		lvm_saved_libs=$LIBS
 		LIBS="$LIBS -static"
 		AC_SEARCH_LIBS([pthread_mutex_lock], [pthread],
 		  [test "$ac_cv_search_pthread_mutex_lock" = "none required" ||
 				LIB_PTHREAD=-lpthread])
-		LIBS=$dm_saved_libs
+		LIBS=$lvm_saved_libs
 	fi
 fi

@@ -259,6 +291,22 @@ dnl -- Check for getopt
 AC_CHECK_HEADERS(getopt.h, AC_DEFINE([HAVE_GETOPTLONG], 1, [Define to 1 if getopt_long is available.]))

 ################################################################################
+dnl -- Check for readline (Shamelessly copied from parted 1.4.17)
+if test x$READLINE = xyes; then
+	AC_CHECK_LIB(readline, readline, ,
+		AC_MSG_ERROR(
+GNU Readline could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install readline from:
+	ftp.gnu.org/gnu/readline
+Note: if you are using precompiled packages you will also need the development
+package as well (which may be called readline-devel or something similar).
+)
+	)
+	AC_CHECK_FUNC(rl_completion_matches, AC_DEFINE([HAVE_RL_COMPLETION_MATCHES], 1, [Define to 1 if rl_completion_matches() is available.]))
+fi
+
+################################################################################
 dnl -- Internationalisation stuff
 AC_MSG_CHECKING(whether to enable internationalisation)
 AC_ARG_ENABLE(nls, [  --enable-nls            Enable Native Language Support],
@@ -275,9 +323,9 @@ if test x$INTL = xyes; then
 	fi;

 	AC_ARG_WITH(localedir,
-  		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
-  		    [ LOCALEDIR="$withval" ],
-  		    [ LOCALEDIR='${prefix}/share/locale' ])
+		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
+		    [ LOCALEDIR="$withval" ],
+		    [ LOCALEDIR='${prefix}/share/locale' ])
 fi


@@ -330,7 +378,7 @@ if test "${with_kernelversion+set}" = set; then
 fi

 if test "x${kernelvsn}" = x; then
-  if test "x${missingkernel}" = "x"; then 
+  if test "x${missingkernel}" = "x"; then
     kernelvsn=`awk -F ' = ' '/^VERSION/ {v=$2} /^PATCH/ {p=$2} /^SUBLEVEL/ {s=$2} /^EXTRAVERSION/ {e=$2} END {printf "%d.%d.%d%s",v,p,s,e}' $kerneldir/Makefile`
   else
     kernelvsn="UNKNOWN"
@@ -364,11 +412,7 @@ then
 fi
 AC_MSG_RESULT($interface)

-if test "-f VERSION" ; then
-  DM_LIB_VERSION="\"`cat VERSION|sed -e \"s/([[0-9.]]*)/\0-$interface/\"`\""
-else
-  DM_LIB_VERSION="Unknown version ($interface)"
-fi
+DM_LIB_VERSION="\"`cat VERSION 2>/dev/null || echo Unknown`\""

 AC_DEFINE_UNQUOTED(DM_LIB_VERSION, $DM_LIB_VERSION, [Library version])

@@ -377,9 +421,9 @@ dnl -- dmeventd pidfile and executable path
 AH_TEMPLATE(DMEVENTD_PIDFILE, [Path to dmeventd pidfile.])
 if test "$DMEVENTD" = yes; then
 	AC_ARG_WITH(dmeventd-pidfile,
-  		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
+		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
 fi

 AH_TEMPLATE(DMEVENTD_PATH, [Path to dmeventd binary.])
@@ -392,53 +436,80 @@ if test "$DMEVENTD" = yes; then
                 dmeventd_prefix=""
         fi
 	AC_ARG_WITH(dmeventd-path,
-  		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
+		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
 fi
 ################################################################################
-AC_SUBST(usrlibdir)
-AC_SUBST(JOBS)
-AC_SUBST(STATIC_LINK)
-AC_SUBST(OWNER)
-AC_SUBST(GROUP)
-AC_SUBST(LIBS)
-AC_SUBST(interface)
-AC_SUBST(kerneldir)
-AC_SUBST(missingkernel)
-AC_SUBST(kernelvsn)
-AC_SUBST(tmpdir)
 AC_SUBST(CFLAGS)
-AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CFLOW_CMD)
 AC_SUBST(CLDFLAGS)
-AC_SUBST(LDDEPS)
-AC_SUBST(LIB_SUFFIX)
-AC_SUBST(DEBUG)
-AC_SUBST(DM_LIB_VERSION)
+AC_SUBST(CLDNOWHOLEARCHIVE)
+AC_SUBST(CLDWHOLEARCHIVE)
+AC_SUBST(CLUSTER)
+AC_SUBST(CLVMD)
+AC_SUBST(CMDLIB)
+# FIXME: rename to DEVICE_MAPPER_COMPAT
 AC_SUBST(COMPAT)
-AC_SUBST(DMIOCTLS)
-AC_SUBST(MSGFMT)
-AC_SUBST(LOCALEDIR)
-AC_SUBST(INTL_PACKAGE)
-AC_SUBST(INTL)
-AC_SUBST(DEVICE_UID)
+# FIXME: rename to LVM_ETC_DIR
+AC_SUBST(CONFDIR)
+AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CSCOPE_CMD)
+AC_SUBST(DEBUG)
+# FIXME: rename to start with DM_
 AC_SUBST(DEVICE_GID)
+# FIXME: rename to start with DM_
 AC_SUBST(DEVICE_MODE)
+# FIXME: rename to start with DM_
+AC_SUBST(DEVICE_UID)
+AC_SUBST(DEVMAPPER)
+AC_SUBST(DMDIR)
+# Rename to BUILD_DMEVENTD
 AC_SUBST(DMEVENTD)
+AC_SUBST(DMIOCTLS)
+AC_SUBST(DM_LIB_VERSION)
+AC_SUBST(FSADM)
+AC_SUBST(GROUP)
+AC_SUBST(HAVE_LIBDL)
+AC_SUBST(HAVE_REALTIME)
+AC_SUBST(HAVE_SELINUX)
+AC_SUBST(INTL)
+AC_SUBST(INTL_PACKAGE)
+AC_SUBST(JOBS)
+AC_SUBST(LDDEPS)
+AC_SUBST(LIBS)
+AC_SUBST(LIB_SUFFIX)
+AC_SUBST(LOCALEDIR)
+AC_SUBST(LVM1)
+AC_SUBST(LVM1_FALLBACK)
+AC_SUBST(LVM_VERSION)
+AC_SUBST(MIRRORS)
+AC_SUBST(MSGFMT)
+AC_SUBST(OWNER)
 AC_SUBST(PKGCONFIG)
+AC_SUBST(POOL)
+AC_SUBST(SNAPSHOTS)
+AC_SUBST(STATICDIR)
+AC_SUBST(STATIC_LINK)
 AC_SUBST([LIB_PTHREAD])
+AC_SUBST(interface)
+AC_SUBST(kerneldir)
+AC_SUBST(kernelvsn)
+AC_SUBST(missingkernel)
+AC_SUBST(tmpdir)
+AC_SUBST(usrlibdir)

 ################################################################################
-dnl -- First and last lines should not contain files to generate in order to 
+dnl -- First and last lines should not contain files to generate in order to
 dnl -- keep utility scripts running properly
 AC_CONFIG_FILES([\
 Makefile								\
 make.tmpl                                                               \
 include/Makefile                                                        \
 dmsetup/Makefile							\
-lib/Makefile							 	\
+lib/Makefile								\
 lib/libdevmapper.pc							\
-dmeventd/Makefile						 	\
+dmeventd/Makefile							\
 dmeventd/libdevmapper-event.pc						\
 kernel/Makefile								\
 man/Makefile								\
