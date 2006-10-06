From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 6 Oct 2006 18:09:15 -0000
Message-ID: <20061006180915.19619.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-10-06 18:09:15

Modified files:
	libmultipath   : discovery.c 

Log message:
	Comitted patch for 207726

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.2&r2=1.28.2.3

--- multipath-tools/libmultipath/discovery.c	2006/09/19 21:06:40	1.28.2.2
+++ multipath-tools/libmultipath/discovery.c	2006/10/06 18:09:14	1.28.2.3
@@ -480,7 +480,7 @@
 
 	if (sysfs_get_rev(sysfs_path, curpath->dev,
 			  curpath->rev, SCSI_REV_SIZE))
-		return 1;
+		curpath->rev[0] = '\0';
 
 	condlog(3, "rev = %s", curpath->rev);
 
