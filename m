From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h l ...
Date: 2 Sep 2008 12:16:07 -0000
Message-ID: <20080902121607.13194.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-09-02 12:16:07

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h libdm-deptree.c 

Log message:
	Extend deptree buffers so the largest possible device numbers fit.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.249&r2=1.250
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.83&r2=1.84
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.40&r2=1.41

--- device-mapper/WHATS_NEW	2008/06/27 15:36:51	1.249
+++ device-mapper/WHATS_NEW	2008/09/02 12:16:06	1.250
@@ -1,5 +1,6 @@
 Version 1.02.28 - 
 ================================
+  Extend deptree buffers so the largest possible device numbers fit.
   Added generation of the versioned libdevmapper-event.so for LVM's test
   Underline longer report help text headings.
 
--- device-mapper/lib/libdevmapper.h	2008/06/24 22:53:48	1.83
+++ device-mapper/lib/libdevmapper.h	2008/09/02 12:16:07	1.84
@@ -181,8 +181,9 @@
 		       uint64_t size, const char *ttype, const char *params);
 
 /*
- * Format major/minor numbers correctly for input to driver
+ * Format major/minor numbers correctly for input to driver.
  */
+#define DM_FORMAT_DEV_BUFSIZE	13	/* Minimum bufsize to handle worst case. */
 int dm_format_dev(char *buf, int bufsize, uint32_t dev_major, uint32_t dev_minor);
 
 /* Use this to retrive target information returned from a STATUS call */
--- device-mapper/lib/libdm-deptree.c	2008/06/25 14:24:17	1.40
+++ device-mapper/lib/libdm-deptree.c	2008/09/02 12:16:07	1.41
@@ -1243,7 +1243,7 @@
 			    size_t paramsize, int *pos)
 {
 	struct seg_area *area;
-	char devbuf[10];
+	char devbuf[DM_FORMAT_DEV_BUFSIZE];
 	int tw;
 	const char *prefix = "";
 
@@ -1270,7 +1270,8 @@
         int pos = 0;
 	int tw;
         int r;
-	char originbuf[10], cowbuf[10], logbuf[10];
+	char originbuf[DM_FORMAT_DEV_BUFSIZE], cowbuf[DM_FORMAT_DEV_BUFSIZE];
+	char logbuf[DM_FORMAT_DEV_BUFSIZE];
 	const char *logtype;
 
 	switch(seg->type) {
