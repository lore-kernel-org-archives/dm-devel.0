From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.defaults
Date: 17 May 2007 19:47:25 -0000
Message-ID: <20070517194725.30698.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-05-17 19:47:24

Modified files:
	.              : multipath.conf.defaults 

Log message:
	Fixing typo in multipath.conf.defaults

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.2&r2=1.5.4.3

--- multipath-tools/multipath.conf.defaults	2007/01/10 20:08:07	1.5.4.2
+++ multipath-tools/multipath.conf.defaults	2007/05/17 19:47:24	1.5.4.3
@@ -60,7 +60,7 @@
 #               vendor                  "(COMPAQ|HP)"
 #               product                 "HSV(1|2).*"
 #		getuid_callout		"/sbin/scsi_id -g -u -s"
-#               prio_callout            "/sbin/mpath_prio_alua %d"	
+#               prio_callout            "/sbin/mpath_prio_alua %n"	
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_prio
