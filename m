From: agk@sourceware.org
Subject: device-mapper WHATS_NEW configure configure.in
Date: 10 Oct 2007 00:02:05 -0000
Message-ID: <20071010000205.9788.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-10-10 00:02:03

Modified files:
	.              : WHATS_NEW configure configure.in 

Log message:
	Fix configure --with-dmeventd-path substitution.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.206&r2=1.207
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.46&r2=1.47

--- device-mapper/WHATS_NEW	2007/10/09 12:14:48	1.206
+++ device-mapper/WHATS_NEW	2007/10/10 00:02:03	1.207
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Fix configure --with-dmeventd-path substitution.
   Allow $DM_DEV_DIR envvar to override default of "/dev".
   Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
   Avoid static link failure with some SELinux libraries.
--- device-mapper/configure	2007/08/21 20:32:29	1.44
+++ device-mapper/configure	2007/10/10 00:02:03	1.45
@@ -6646,7 +6646,7 @@
 
 else
    cat >>confdefs.h <<_ACEOF
-#define DMEVENTD_PATH "$dmeventd_pref/sbin/dmeventd"
+#define DMEVENTD_PATH "$dmeventd_prefix/sbin/dmeventd"
 _ACEOF
 
 fi
--- device-mapper/configure.in	2007/08/21 20:32:29	1.46
+++ device-mapper/configure.in	2007/10/10 00:02:03	1.47
@@ -394,7 +394,7 @@
 	AC_ARG_WITH(dmeventd-path,
   		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
   		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_pref/sbin/dmeventd") ])
+  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
 fi
 ################################################################################
 AC_SUBST(usrlibdir)
