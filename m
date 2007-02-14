From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 14 Feb 2007 15:12:18 -0000
Message-ID: <20070214151218.20225.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-02-14 15:12:16

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdm-report.c 

Log message:
	Fix a few leaks in reporting error paths.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.171&r2=1.172
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.86&r2=1.87
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.11&r2=1.12

--- device-mapper/WHATS_NEW	2007/02/13 16:16:15	1.171
+++ device-mapper/WHATS_NEW	2007/02/14 15:12:14	1.172
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Fix a few leaks in reporting error paths. [1.02.15+]
 
 Version 1.02.18 - 13th February 2007
 ====================================
--- device-mapper/dmsetup/dmsetup.c	2007/01/29 19:35:24	1.86
+++ device-mapper/dmsetup/dmsetup.c	2007/02/14 15:12:16	1.87
@@ -2019,6 +2019,7 @@
 	if (*argc != 2) {
 		fprintf(stderr, "%s: Too few arguments\n", base);
 		_losetup_usage(stderr);
+		dm_free(device_name);
 		return 0;
 	}
 
@@ -2027,6 +2028,7 @@
 		fprintf(stderr, "%s: Could not parse loop file name %s\n",
 			base, (*argv)[1]);
 		_losetup_usage(stderr);
+		dm_free(device_name);
 		return 0;
 	}
 
@@ -2034,6 +2036,7 @@
 	_table = dm_malloc(LOOP_TABLE_SIZE);
 	if (!_loop_table(_table, LOOP_TABLE_SIZE, loop_file, device_name, offset)) {
 		fprintf(stderr, "Could not build device-mapper table for %s\n", (*argv)[0]);
+		dm_free(device_name);
 		return 0;
 	}
 	_switches[TABLE_ARG]++;
--- device-mapper/lib/libdm-report.c	2007/01/29 17:23:54	1.11
+++ device-mapper/lib/libdm-report.c	2007/02/14 15:12:16	1.12
@@ -504,15 +504,20 @@
 
 	if (!(rh->mem = dm_pool_create("report", 10 * 1024))) {
 		log_error("dm_report_init: allocation of memory pool failed");
+		dm_free(rh);
 		return NULL;
 	}
 
 	/* Generate list of fields for output based on format string & flags */
-	if (!_parse_options(rh, output_fields))
+	if (!_parse_options(rh, output_fields)) {
+		dm_report_free(rh);
 		return NULL;
+	}
 
-	if (!_parse_keys(rh, sort_keys))
+	if (!_parse_keys(rh, sort_keys)) {
+		dm_report_free(rh);
 		return NULL;
+	}
 
 	/* Return updated types value for further compatility check by caller */
 	if (report_types)
