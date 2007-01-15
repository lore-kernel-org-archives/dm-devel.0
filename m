From: agk@sourceware.org
Subject: device-mapper configure.in
Date: 15 Jan 2007 19:02:29 -0000
Message-ID: <20070115190229.577.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 19:02:29

Modified files:
	.              : configure.in 

Log message:
	configure-time dmeventd prefix

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.40&r2=1.41

--- device-mapper/configure.in	2007/01/11 21:54:51	1.40
+++ device-mapper/configure.in	2007/01/15 19:02:29	1.41
@@ -359,7 +359,7 @@
 
 
 ################################################################################
-dnl -- dmeventd pidfile path
+dnl -- dmeventd pidfile and executable path
 AH_TEMPLATE(DMEVENTD_PIDFILE, [Path to dmeventd pidfile.])
 if test "$DMEVENTD" = yes; then
 	AC_ARG_WITH(dmeventd-pidfile,
@@ -367,6 +367,21 @@
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
 fi
+
+AH_TEMPLATE(DMEVENTD_PATH, [Path to dmeventd binary.])
+if test "$DMEVENTD" = yes; then
+        dmeventd_prefix="$exec_prefix"
+        if test "x$dmeventd_prefix" = "xNONE"; then
+                dmeventd_prefix="$prefix"
+        fi
+        if test "x$dmeventd_prefix" = "xNONE"; then
+                dmeventd_prefix=""
+        fi
+	AC_ARG_WITH(dmeventd-path,
+  		    [  --with-dmeventd-path=PATH    dmeventd path [[\${exec_prefix}/sbin/dmeventd]] ],
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_pref/sbin/dmeventd") ])
+fi
 ################################################################################
 AC_SUBST(usrlibdir)
 AC_SUBST(JOBS)
