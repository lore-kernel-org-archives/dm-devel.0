From: agk@sourceware.org
Subject: device-mapper WHATS_NEW configure configure.in ...
Date: 7 Oct 2008 19:08:48 -0000
Message-ID: <20081007190848.10317.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2008-10-07 19:08:47

Modified files:
	.              : WHATS_NEW configure configure.in make.tmpl.in 

Log message:
	Add usrsbindir to configure.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.252&r2=1.253
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.47&r2=1.48
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.49&r2=1.50
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.37&r2=1.38

--- device-mapper/WHATS_NEW	2008/09/18 20:09:51	1.252
+++ device-mapper/WHATS_NEW	2008/10/07 19:08:46	1.253
@@ -1,5 +1,6 @@
 Version 1.02.29 -
 =====================================
+  Add usrsbindir to configure.
 
 Version 1.02.28 - 18th September 2008
 =====================================
--- device-mapper/configure	2008/06/06 20:44:35	1.47
+++ device-mapper/configure	2008/10/07 19:08:46	1.48
@@ -732,6 +732,7 @@
 kernelvsn
 tmpdir
 usrlibdir
+usrsbindir
 LTLIBOBJS'
 ac_subst_files=''
       ac_precious_vars='build_alias
@@ -1336,6 +1337,8 @@
   --with-device-mode=MODE Set the mode used for new device nodes [MODE=0600]
   --with-optimisation=OPT C optimisation flag [OPT=-O2]
   --with-localedir=DIR    Translation files in DIR [PREFIX/share/locale]
+  --with-usrlibdir=DIR
+  --with-usrsbindir=DIR
   --with-kernel-dir=DIR   linux kernel source in DIR
   --with-kernel-version=VERSION   linux kernel version
   --with-tmp-dir=DIR      temp dir to make kernel patches [/tmp/kerndiff]
@@ -1974,9 +1977,6 @@
 esac
 
 ################################################################################
-usrlibdir='${prefix}/lib'
-
-################################################################################
 for ac_prog in gawk mawk nawk awk
 do
   # Extract the first word of "$ac_prog", so it can be a program name with args.
@@ -8766,6 +8766,25 @@
 fi
 
 ################################################################################
+
+# Check whether --with-usrlibdir was given.
+if test "${with_usrlibdir+set}" = set; then
+  withval=$with_usrlibdir;  usrlibdir="$withval"
+else
+   usrlibdir='${prefix}/lib'
+fi
+
+
+
+# Check whether --with-usrsbindir was given.
+if test "${with_usrsbindir+set}" = set; then
+  withval=$with_usrsbindir;  usrsbindir="$withval"
+else
+   usrsbindir='${prefix}/sbin'
+fi
+
+
+################################################################################
 { echo "$as_me:$LINENO: checking for kernel directory" >&5
 echo $ECHO_N "checking for kernel directory... $ECHO_C" >&6; }
 
@@ -8975,6 +8994,7 @@
 
 
 
+
 ################################################################################
 ac_config_files="$ac_config_files Makefile make.tmpl include/Makefile dmsetup/Makefile lib/Makefile lib/libdevmapper.pc dmeventd/Makefile dmeventd/libdevmapper-event.pc kernel/Makefile man/Makefile po/Makefile"
 
@@ -9763,10 +9783,11 @@
 kernelvsn!$kernelvsn$ac_delim
 tmpdir!$tmpdir$ac_delim
 usrlibdir!$usrlibdir$ac_delim
+usrsbindir!$usrsbindir$ac_delim
 LTLIBOBJS!$LTLIBOBJS$ac_delim
 _ACEOF
 
-  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 22; then
+  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 23; then
     break
   elif $ac_last_try; then
     { { echo "$as_me:$LINENO: error: could not make $CONFIG_STATUS" >&5
--- device-mapper/configure.in	2008/06/06 20:44:35	1.49
+++ device-mapper/configure.in	2008/10/07 19:08:47	1.50
@@ -62,10 +62,6 @@
 esac
 
 ################################################################################
-dnl -- Additional library location
-usrlibdir='${prefix}/lib'
-
-################################################################################
 dnl -- Check for programs.
 AC_PROG_AWK
 AC_PROG_CC
@@ -332,6 +328,17 @@
 fi
 
 ################################################################################
+AC_ARG_WITH(usrlibdir,
+	    [  --with-usrlibdir=DIR],
+	    [ usrlibdir="$withval"],
+	    [ usrlibdir='${prefix}/lib' ])
+
+AC_ARG_WITH(usrsbindir,
+	    [  --with-usrsbindir=DIR],
+	    [ usrsbindir="$withval"],
+	    [ usrsbindir='${prefix}/sbin' ])
+
+################################################################################
 dnl -- Where the linux src tree is
 AC_MSG_CHECKING(for kernel directory)
 AC_ARG_WITH(kerneldir,
@@ -495,6 +502,7 @@
 AC_SUBST(kernelvsn)
 AC_SUBST(tmpdir)
 AC_SUBST(usrlibdir)
+AC_SUBST(usrsbindir)
 
 ################################################################################
 dnl -- First and last lines should not contain files to generate in order to
--- device-mapper/make.tmpl.in	2008/06/06 20:44:35	1.37
+++ device-mapper/make.tmpl.in	2008/10/07 19:08:47	1.38
@@ -39,6 +39,7 @@
 libdir = $(DESTDIR)@libdir@
 usrlibdir = $(DESTDIR)@usrlibdir@
 sbindir = $(DESTDIR)@sbindir@
+usrsbindir = $(DESTDIR)@usrsbindir@
 infodir = $(DESTDIR)@infodir@
 mandir = $(DESTDIR)@mandir@
 localedir = $(DESTDIR)@LOCALEDIR@
