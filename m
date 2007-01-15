From: agk@sourceware.org
Subject: device-mapper ./configure ./configure.in inclu ...
Date: 15 Jan 2007 19:07:00 -0000
Message-ID: <20070115190700.2449.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 19:06:59

Modified files:
	.              : configure configure.in 
	include        : configure.h.in 

Log message:
	regen conf files

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.39&r2=1.40
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.41&r2=1.42
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/configure.h.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- device-mapper/configure	2007/01/11 21:54:51	1.39
+++ device-mapper/configure	2007/01/15 19:06:59	1.40
@@ -872,6 +872,7 @@
   --with-tmp-dir=DIR      temp dir to make kernel patches [/tmp/kerndiff]
   --with-interface=IFACE  Choose kernel interface (ioctl or fs) [ioctl]
   --with-dmeventd-pidfile=PATH    dmeventd pidfile [/var/run/dmeventd.pid]
+  --with-dmeventd-path=PATH       dmeventd path [${exec_prefix}/sbin/dmeventd]
 
 Some influential environment variables:
   CC          C compiler command
@@ -6056,6 +6057,32 @@
 
 fi;
 fi
+
+
+
+if test "$DMEVENTD" = yes; then
+        dmeventd_prefix="$exec_prefix"
+        if test "x$dmeventd_prefix" = "xNONE"; then
+                dmeventd_prefix="$prefix"
+        fi
+        if test "x$dmeventd_prefix" = "xNONE"; then
+                dmeventd_prefix=""
+        fi
+
+# Check whether --with-dmeventd-path or --without-dmeventd-path was given.
+if test "${with_dmeventd_path+set}" = set; then
+  withval="$with_dmeventd_path"
+   cat >>confdefs.h <<_ACEOF
+#define DMEVENTD_PATH "$withval"
+_ACEOF
+
+else
+   cat >>confdefs.h <<_ACEOF
+#define DMEVENTD_PATH "$dmeventd_pref/sbin/dmeventd"
+_ACEOF
+
+fi;
+fi
 ################################################################################
 
 
--- device-mapper/configure.in	2007/01/15 19:02:29	1.41
+++ device-mapper/configure.in	2007/01/15 19:06:59	1.42
@@ -378,7 +378,7 @@
                 dmeventd_prefix=""
         fi
 	AC_ARG_WITH(dmeventd-path,
-  		    [  --with-dmeventd-path=PATH    dmeventd path [[\${exec_prefix}/sbin/dmeventd]] ],
+  		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_pref/sbin/dmeventd") ])
 fi
--- device-mapper/include/configure.h.in	2007/01/11 21:54:52	1.3
+++ device-mapper/include/configure.h.in	2007/01/15 19:06:59	1.4
@@ -3,6 +3,9 @@
 /* Define to 1 if the `closedir' function returns void instead of `int'. */
 #undef CLOSEDIR_VOID
 
+/* Path to dmeventd binary. */
+#undef DMEVENTD_PATH
+
 /* Path to dmeventd pidfile. */
 #undef DMEVENTD_PIDFILE
 
@@ -171,9 +174,11 @@
 /* Define to empty if `const' does not conform to ANSI C. */
 #undef const
 
-/* Define as `__inline' if that's what the C compiler calls it, or to nothing
-   if it is not supported. */
+/* Define to `__inline__' or `__inline' if that's what the C compiler
+   calls it, or to nothing if 'inline' is not supported under any name.  */
+#ifndef __cplusplus
 #undef inline
+#endif
 
 /* Define to rpl_malloc if the replacement function should be used. */
 #undef malloc
