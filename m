From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.defaults
Date: 6 Sep 2007 16:22:25 -0000
Message-ID: <20070906162225.21502.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-09-06 16:22:25

Modified files:
	.              : multipath.conf.defaults 

Log message:
	Whoops! Forgot to update the multipath.conf.defaults file.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.5&r2=1.5.4.6

--- multipath-tools/multipath.conf.defaults	2007/08/14 18:08:54	1.5.4.5
+++ multipath-tools/multipath.conf.defaults	2007/09/06 16:22:25	1.5.4.6
@@ -294,7 +294,7 @@
 #		failback		immediate
 #		rr_weight		uniform
 #		rr_min_io		128
-#		path_checker		readsector0
+#		path_checker		directio
 #	}
 #	device {
 #		vendor			"IBM"
