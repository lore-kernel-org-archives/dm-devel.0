From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath devmapper.c
Date: 8 Nov 2006 21:16:58 -0000
Message-ID: <20061108211658.7548.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-11-08 21:16:58

Modified files:
	libmultipath   : devmapper.c 

Log message:
	Pulled in skip_lockfs patch. This is dependent on device-mapper and kernel
	code, but that code is already inplace

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&r1=1.20&r2=1.21

--- multipath-tools/libmultipath/devmapper.c	2006/07/13 19:49:23	1.20
+++ multipath-tools/libmultipath/devmapper.c	2006/11/08 21:16:58	1.21
@@ -105,6 +105,7 @@
 		goto out;
 
 	dm_task_no_open_count(dmt);
+	dm_task_skip_lockfs(dmt);       /* for DM_DEVICE_RESUME */
 
 	r = dm_task_run (dmt);
 
