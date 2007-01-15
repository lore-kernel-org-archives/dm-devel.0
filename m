From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/mm/dbg_malloc.c
Date: 15 Jan 2007 14:40:21 -0000
Message-ID: <20070115144021.29132.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 14:39:12

Modified files:
	.              : WHATS_NEW 
	lib/mm         : dbg_malloc.c 

Log message:
	Report error if NULL pointer supplied to dm_strdup_aux().

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.145&r2=1.146
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.8&r2=1.9

--- device-mapper/WHATS_NEW	2007/01/12 20:22:11	1.145
+++ device-mapper/WHATS_NEW	2007/01/15 14:39:11	1.146
@@ -1,5 +1,6 @@
 Version 1.02.15 -
 ===================================
+  Report error if NULL pointer is supplied to dm_strdup_aux().
   Reinstate dm_event_get_registered_device.
 
 Version 1.02.14 - 11th January 2007
--- device-mapper/lib/mm/dbg_malloc.c	2006/09/19 17:30:04	1.8
+++ device-mapper/lib/mm/dbg_malloc.c	2007/01/15 14:39:12	1.9
@@ -20,9 +20,14 @@
 
 char *dm_strdup_aux(const char *str, const char *file, int line)
 {
-	char *ret = dm_malloc_aux_debug(strlen(str) + 1, file, line);
+	char *ret;
 
-	if (ret)
+	if (!str) {
+		log_error("Internal error: dm_strdup called with NULL pointer");
+		return NULL;
+	}
+
+	if ((ret = dm_malloc_aux_debug(strlen(str) + 1, file, line)))
 		strcpy(ret, str);
 
 	return ret;
