From: agk@sourceware.org
Subject: device-mapper/lib libdm-report.c
Date: 6 Jun 2008 19:07:48 -0000
Message-ID: <20080606190748.10280.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2008-06-06 19:07:47

Modified files:
	lib            : libdm-report.c 

Log message:
	switch to single quotes rather than double for nameprefixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.18&r2=1.19

--- device-mapper/lib/libdm-report.c	2008/04/20 00:11:08	1.18
+++ device-mapper/lib/libdm-report.c	2008/06/06 19:07:47	1.19
@@ -845,7 +845,7 @@
 
 				free(field_id);
 
-				if (!dm_pool_grow_object(rh->mem, "=\"", 2)) {
+				if (!dm_pool_grow_object(rh->mem, "=\'", 2)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
@@ -886,7 +886,7 @@
 			}
 
 			if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX)
-				if (!dm_pool_grow_object(rh->mem, "\"", 1)) {
+				if (!dm_pool_grow_object(rh->mem, "\'", 1)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
