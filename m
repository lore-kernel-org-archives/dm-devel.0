From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 19 Jun 2007 18:12:16 -0000
Message-ID: <20070619181216.6671.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-06-19 18:12:15

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	                 multipath.conf.synthetic 
	multipath      : multipath.conf.redhat 

Log message:
	Pulled out cciss blacklist info from files.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.1&r2=1.18.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.3&r2=1.5.4.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.1&r2=1.11.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.3&r2=1.6.2.4

--- multipath-tools/multipath.conf.annotated	2007/01/10 20:08:07	1.18.2.1
+++ multipath-tools/multipath.conf.annotated	2007/06/19 18:12:15	1.18.2.2
@@ -130,13 +130,12 @@
 ## name    : blacklist
 ## scope   : multipath & multipathd
 ## desc    : list of device names to discard as not multipath candidates
-## default : cciss, fd, hd, md, dm, sr, scd, st, ram, raw, loop
+## default : fd, hd, md, dm, sr, scd, st, ram, raw, loop
 ##
 #blacklist {
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z][[0-9]*]"
-#	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
 #       device {
 #               vendor DEC.*
 #               product MSA[15]00
--- multipath-tools/multipath.conf.defaults	2007/05/17 19:47:24	1.5.4.3
+++ multipath-tools/multipath.conf.defaults	2007/06/19 18:12:15	1.5.4.4
@@ -19,7 +19,6 @@
 #blacklist {
 #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #       devnode "^hd[a-z]"
-#       devnode "^cciss!c[0-9]d[0-9]*"
 #}
 #
 #devices {
--- multipath-tools/multipath.conf.synthetic	2007/01/10 20:08:07	1.11.2.1
+++ multipath-tools/multipath.conf.synthetic	2007/06/19 18:12:15	1.11.2.2
@@ -20,7 +20,6 @@
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z][[0-9]*]"
-#	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
 #	device {
 #		vendor DEC.*
 #		product MSA[15]00
--- multipath-tools/multipath/multipath.conf.redhat	2007/05/08 20:15:59	1.6.2.3
+++ multipath-tools/multipath/multipath.conf.redhat	2007/06/19 18:12:15	1.6.2.4
@@ -57,7 +57,6 @@
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z]"
-#	devnode "^cciss!c[0-9]d[0-9]*"
 #}
 #multipaths {
 #	multipath {
