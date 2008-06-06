From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 6 Jun 2008 18:53:08 -0000
Message-ID: <20080606185308.23515.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-06 18:53:08

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	change --prefixes to --nameprefixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.233&r2=1.234
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.107&r2=1.108

--- device-mapper/WHATS_NEW	2008/06/05 19:10:35	1.233
+++ device-mapper/WHATS_NEW	2008/06/06 18:53:08	1.234
@@ -5,7 +5,7 @@
   Make dm_hash_iter safe against deletion.
   Accept a NULL pointer to dm_free silently.
   Add tables_loaded, readonly and suspended columns to reports.
-  Add --prefixes to dmsetup.
+  Add --fieldprefixes to dmsetup.
   Add field name prefix option to reporting functions.
   Calculate string size within dm_pool_grow_object.
 
--- device-mapper/dmsetup/dmsetup.c	2008/04/21 16:57:11	1.107
+++ device-mapper/dmsetup/dmsetup.c	2008/06/06 18:53:08	1.108
@@ -114,13 +114,13 @@
 	MAJOR_ARG,
 	MINOR_ARG,
 	MODE_ARG,
+	NAMEPREFIXES_ARG,
 	NOFLUSH_ARG,
 	NOHEADINGS_ARG,
 	NOLOCKFS_ARG,
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
-	PREFIXES_ARG,
 	READAHEAD_ARG,
 	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
@@ -1990,7 +1990,7 @@
 	if (_switches[UNBUFFERED_ARG])
 		buffered = 0;
 
-	if (_switches[PREFIXES_ARG]) {
+	if (_switches[NAMEPREFIXES_ARG]) {
 		aligned = 0;
 		field_prefixes = 1;
 	}
@@ -2119,7 +2119,7 @@
 		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
 		"        [--readahead [+]<sectors>|auto|none]\n"
 		"        [-c|-C|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
-		"        [--noheadings] [--prefixes] [--separator <separator>]\n\n");
+		"        [--nameprefixes] [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
@@ -2475,13 +2475,13 @@
 		{"major", 1, &ind, MAJOR_ARG},
 		{"minor", 1, &ind, MINOR_ARG},
 		{"mode", 1, &ind, MODE_ARG},
+		{"nameprefixes", 0, &ind, NAMEPREFIXES_ARG},
 		{"noflush", 0, &ind, NOFLUSH_ARG},
 		{"noheadings", 0, &ind, NOHEADINGS_ARG},
 		{"nolockfs", 0, &ind, NOLOCKFS_ARG},
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
-		{"prefixes", 0, &ind, PREFIXES_ARG},
 		{"readahead", 1, &ind, READAHEAD_ARG},
 		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
@@ -2608,6 +2608,8 @@
 			_switches[TARGET_ARG]++;
 			_target = optarg;
 		}
+		if ((ind == NAMEPREFIXES_ARG))
+			_switches[NAMEPREFIXES_ARG]++;
 		if ((ind == NOFLUSH_ARG))
 			_switches[NOFLUSH_ARG]++;
 		if ((ind == NOHEADINGS_ARG))
@@ -2616,8 +2618,6 @@
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
-		if ((ind == PREFIXES_ARG))
-			_switches[PREFIXES_ARG]++;
 		if ((ind == READAHEAD_ARG)) {
 			_switches[READAHEAD_ARG]++;
 			if (!strcasecmp(optarg, "auto"))
