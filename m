From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath configure.c
Date: 28 Sep 2009 16:30:28 -0000
Message-ID: <20090928163028.24860.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-09-28 16:30:27

Modified files:
	libmultipath   : configure.c 

Log message:
	Fix bz#501019. Fix incorrect multipath output in dry-run.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.4&r2=1.2.2.5

--- multipath-tools/libmultipath/configure.c	2008/09/19 03:27:08	1.2.2.4
+++ multipath-tools/libmultipath/configure.c	2009/09/28 16:30:27	1.2.2.5
@@ -139,7 +139,7 @@
 	if (!cmpp) {
 		cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 
-		if (cmpp && !conf->dry_run) {
+		if (cmpp) {
 			condlog(2, "%s: rename %s to %s", mpp->wwid,
 				cmpp->alias, mpp->alias);
 			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
