From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults mult ...
Date: 2 Aug 2007 23:00:52 -0000
Message-ID: <20070802230052.29184.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-08-02 23:00:52

Modified files:
	.              : multipath.conf.defaults 
	multipath      : multipath.conf.redhat 

Log message:
	Updating some comments

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.4&r2=1.5.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.3&r2=1.5.2.4

--- multipath-tools/multipath.conf.defaults	2007/05/07 17:59:46	1.5.2.4
+++ multipath-tools/multipath.conf.defaults	2007/08/02 23:00:52	1.5.2.5
@@ -19,7 +19,6 @@
 #blacklist {
 #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #       devnode "^hd[a-z]"
-#       devnode "^cciss!c[0-9]d[0-9]*"
 #}
 #
 #devices {
--- multipath-tools/multipath/multipath.conf.redhat	2007/05/07 17:59:46	1.5.2.3
+++ multipath-tools/multipath/multipath.conf.redhat	2007/08/02 23:00:52	1.5.2.4
@@ -63,7 +63,6 @@
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z]"
-#	devnode "^cciss!c[0-9]d[0-9]*"
 #}
 #multipaths {
 #	multipath {
