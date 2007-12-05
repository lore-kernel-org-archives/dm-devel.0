From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 5 Dec 2007 22:45:57 -0000
Message-ID: <20071205224557.15700.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 22:45:56

Modified files:
	.              : WHATS_NEW 

Log message:
	clarify

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.215&r2=1.216

--- device-mapper/WHATS_NEW	2007/12/05 18:57:33	1.215
+++ device-mapper/WHATS_NEW	2007/12/05 22:45:56	1.216
@@ -8,7 +8,7 @@
   Add readahead support to libdevmapper and dmsetup.
   Fix double free in a libdevmapper-event error path.
   Fix configure --with-dmeventd-path substitution.
-  Allow a DM_DEV_DIR environment variable to override /dev.
+  Allow a DM_DEV_DIR environment variable to override /dev in dmsetup.
   Create a libdevmapper.so.$LIB_VERSION symlink within the build tree.
   Avoid static link failure with some SELinux libraries that require libpthread.
   Remove obsolete dmfs code from tree and update INSTALL.
