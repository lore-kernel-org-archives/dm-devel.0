From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/hwtable.c multipa ...
Date: 8 May 2007 20:16:00 -0000
Message-ID: <20070508201600.25940.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-05-08 20:15:59

Modified files:
	libmultipath   : hwtable.c 
	multipath      : multipath.conf.redhat 

Log message:
	Fixed bz #223150: changed config defaults for HP Arrays to requested defaults.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.3&r2=1.20.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.2&r2=1.6.2.3

--- multipath-tools/libmultipath/hwtable.c	2007/01/10 20:08:08	1.20.2.3
+++ multipath-tools/libmultipath/hwtable.c	2007/05/08 20:15:58	1.20.2.4
@@ -93,7 +93,7 @@
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV(1|2).*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.getprio       = "/sbin/mpath_prio_alua %n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
--- multipath-tools/multipath/multipath.conf.redhat	2007/01/10 20:08:08	1.6.2.2
+++ multipath-tools/multipath/multipath.conf.redhat	2007/05/08 20:15:59	1.6.2.3
@@ -53,7 +53,7 @@
 ## not change names on reboot (from /dev/sda to /dev/sdb for example)
 ## devnode lines are not recommended for blacklisting specific devices.
 ##
-#devnode_blacklist {
+#blacklist {
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z]"
