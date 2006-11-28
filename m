From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath devmapper.c
Date: 28 Nov 2006 15:46:22 -0000
Message-ID: <20061128154622.9041.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-11-28 15:46:21

Modified files:
	libmultipath   : devmapper.c 

Log message:
	Added Jun'ichi Nomura's noflush suspending patch

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&r1=1.21&r2=1.22

--- multipath-tools/libmultipath/devmapper.c	2006/11/08 21:16:58	1.21
+++ multipath-tools/libmultipath/devmapper.c	2006/11/28 15:46:21	1.22
@@ -106,6 +106,7 @@
 
 	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);       /* for DM_DEVICE_RESUME */
+	dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 
 	r = dm_task_run (dmt);
 
