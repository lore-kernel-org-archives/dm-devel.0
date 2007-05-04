From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.defaults
Date: 4 May 2007 17:13:35 -0000
Message-ID: <20070504171335.29792.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-05-04 17:13:35

Modified files:
	.              : multipath.conf.defaults 

Log message:
	Change documentation for bl_product from "LUN_Z" to "LUNZ" to match the
	actual default.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.2&r2=1.5.2.3

--- multipath-tools/multipath.conf.defaults	2007/01/10 21:56:17	1.5.2.2
+++ multipath-tools/multipath.conf.defaults	2007/05/04 17:13:34	1.5.2.3
@@ -111,7 +111,7 @@
 #       device {
 #               vendor                  "DGC"
 #		product			"*"
-#		bl_product		"LUN_Z"
+#		bl_product		"LUNZ"
 #		path_grouping_policy	group_by_prio
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
