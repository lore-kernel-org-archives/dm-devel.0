From: zkabelac@sourceware.org
Subject: dmraid configure configure.in make.tmpl.in
Date: 27 May 2010 19:38:16 -0000
Message-ID: <20100527193816.16216.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 19:38:16

Modified files:
	.              : configure configure.in make.tmpl.in 

Log message:
	Drop unused OWNER and GROUP vars - they are not needed by installer process
	Add INSTALL_DATA, INSTALL_DIR, INSTALL_PROGRAM

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.5&r2=1.6

--- dmraid/configure	2010/05/27 14:28:47	1.5
+++ dmraid/configure	2010/05/27 19:38:15	1.6
@@ -640,14 +640,10 @@
 LIBOBJS
 STATIC_LINK
 SOFLAG
-OWNER
 LIB_SO
-LIBSEPOL
-LIBSELINUX
 FLAVOUR
 LD_DEPS
 JOBS
-GROUP
 DIETLIBC
 DMRAID_LIB_VERSION
 DMRAID_VERSION
@@ -731,8 +727,6 @@
 ac_user_opts='
 enable_option_checking
 enable_klibc
-with_user
-with_group
 enable_debug
 enable_debug_malloc
 enable_dietlibc
@@ -1383,7 +1377,7 @@
   --enable-debug          Enable debugging
   --enable-debug_malloc   Enable malloc debugging
   --enable-dietlibc       Use this to link the tools to dietlibc
-  --enable-jobs=NUM       Number of jobs to run simultaneously
+  --enable-jobs=NUM       Number of make jobs to run simultaneously
   --enable-mini           Use this to create a minimal binary suitable for
                           early boot environments
   --enable-led            Use this to enable LED support
@@ -1396,12 +1390,6 @@
                           tools to it. Default is static libdmraid
   --disable-testing       Disable testing with mapped devices
 
-Optional Packages:
-  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
-  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
-  --with-user=USER        Set the owner of installed files
-  --with-group=GROUP      Set the group owner of installed files
-
 Some influential environment variables:
   CC          C compiler command
   CFLAGS      C compiler flags
@@ -5196,24 +5184,6 @@
 
 
 
-
-# Check whether --with-user was given.
-if test "${with_user+set}" = set; then
-  withval=$with_user;  OWNER="$withval"
-else
-   OWNER="root"
-fi
-
-
-
-# Check whether --with-group was given.
-if test "${with_group+set}" = set; then
-  withval=$with_group;  GROUP="$withval"
-else
-   GROUP="root"
-fi
-
-
 # Check whether --enable-debug was given.
 if test "${enable_debug+set}" = set; then
   enableval=$enable_debug; DEBUG=$enableval
@@ -5960,10 +5930,6 @@
 
 
 
-
-
-
-
 ac_config_files="$ac_config_files include/Makefile lib/Makefile man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
--- dmraid/configure.in	2010/05/27 14:28:47	1.5
+++ dmraid/configure.in	2010/05/27 19:38:15	1.6
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
@@ -62,18 +62,6 @@
 dnl -- prefix is /usr by default, the exec_prefix default is setup later
 AC_PREFIX_DEFAULT(/usr/share)
 
-dnl -- setup the ownership of the files
-AC_ARG_WITH(user,
-  [  --with-user=USER        Set the owner of installed files ],
-  [ OWNER="$withval" ],
-  [ OWNER="root" ])
-
-dnl -- setup the group ownership of the files
-AC_ARG_WITH(group,
-  [  --with-group=GROUP      Set the group owner of installed files ],
-  [ GROUP="$withval" ],
-  [ GROUP="root" ])
-
 dnl Enable Debugging
 AC_ARG_ENABLE(debug, 
   AC_HELP_STRING([--enable-debug], [Enable debugging]),
@@ -228,13 +216,11 @@
 AC_SUBST(DMRAID_VERSION)
 AC_SUBST(DMRAID_LIB_VERSION)
 AC_SUBST(DIETLIBC)
-AC_SUBST(GROUP)
 AC_SUBST(JOBS)
 AC_SUBST(LD_DEPS)
 AC_SUBST(FLAVOUR)
 AC_SUBST(LIBS)
 AC_SUBST(LIB_SO)
-AC_SUBST(OWNER)
 AC_SUBST(SOFLAG)
 AC_SUBST(STATIC_LINK)
 
--- dmraid/make.tmpl.in	2010/05/27 13:29:45	1.5
+++ dmraid/make.tmpl.in	2010/05/27 19:38:15	1.6
@@ -39,10 +39,10 @@
 endif
 
 # setup misc variables
-# define the ownership variables for the binaries and man pages
-OWNER = @OWNER@
-GROUP = @GROUP@
 DMRAID_LIB_VERSION = @DMRAID_LIB_VERSION@
+INSTALL_PROGRAM = $(INSTALL) $(STRIP)
+INSTALL_DIR = $(INSTALL) -d
+INSTALL_DATA = $(INSTALL) -m 644 -p
 
 # The number of jobs to run, if blank, defaults to the make standard
 ifndef MAKEFLAGS
