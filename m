From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 6 Oct 2006 18:35:13 -0000
Message-ID: <20061006183513.29199.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-10-06 18:35:13

Modified files:
	libmultipath   : discovery.c 

Log message:
	fixing bz #207726, if sysfs_get_rev fails, don't completely abort all path
	checks.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&r1=1.30&r2=1.31

--- multipath-tools/libmultipath/discovery.c	2006/07/12 19:42:43	1.30
+++ multipath-tools/libmultipath/discovery.c	2006/10/06 18:35:13	1.31
@@ -470,7 +470,7 @@
 
 	if (sysfs_get_rev(sysfs_path, pp->dev,
 			  pp->rev, SCSI_REV_SIZE))
-		return 1;
+		pp->rev[0] = '\0';;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
