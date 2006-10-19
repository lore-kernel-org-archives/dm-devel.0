From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 19 Oct 2006 15:34:50 -0000
Message-ID: <20061019153450.20033.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-19 15:34:50

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Suppress encryption key in 'dmsetup table' output unless --showkeys supplied.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.132&r2=1.133
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.73&r2=1.74

--- device-mapper/WHATS_NEW	2006/10/13 19:01:30	1.132
+++ device-mapper/WHATS_NEW	2006/10/19 15:34:49	1.133
@@ -1,5 +1,6 @@
 Version 1.02.13 - 
 =============================
+  Suppress encryption key in 'dmsetup table' output unless --showkeys supplied.
 
 Version 1.02.12 - 13 Oct 2006
 =============================
--- device-mapper/dmsetup/dmsetup.c	2006/10/12 17:09:09	1.73
+++ device-mapper/dmsetup/dmsetup.c	2006/10/19 15:34:50	1.74
@@ -114,6 +114,7 @@
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	SHOWKEYS_ARG,
 	TABLE_ARG,
 	TARGET_ARG,
 	TREE_ARG,
@@ -211,7 +212,11 @@
 	r = 1;
 
       out:
+#ifndef HAVE_GETLINE
 	dm_free(buffer);
+#else
+	free(buffer);
+#endif
 	if (file)
 		fclose(fp);
 	return r;
@@ -915,7 +920,7 @@
 	void *next = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
-	char *params;
+	char *params, *c;
 	int cmd;
 	struct dm_names *names = (struct dm_names *) data;
 	const char *name = NULL;
@@ -978,6 +983,17 @@
 			if (data && !_switches[VERBOSE_ARG])
 				printf("%s: ", name);
 			if (target_type) {
+
+			/* Suppress encryption key */
+			if (!_switches[SHOWKEYS_ARG] &&
+			    !strcmp(target_type, "crypt")) {
+				c = params;
+				while (*c && *c != ' ')
+					c++;
+				c++;
+				while (*c && *c != ' ')
+					*c++ = '0';
+			}
 				printf("%" PRIu64 " %" PRIu64 " %s %s",
 				       start, length, target_type, params);
 			}
@@ -1522,7 +1538,7 @@
 	{"info", "[<device>]", 0, 1, _info},
 	{"deps", "[<device>]", 0, 1, _deps},
 	{"status", "[<device>] [--target <target_type>]", 0, 1, _status},
-	{"table", "[<device>] [--target <target_type>]", 0, 1, _status},
+	{"table", "[<device>] [--target <target_type>] [--showkeys]", 0, 1, _status},
 	{"wait", "<device> [<event_nr>]", 0, 2, _wait},
 	{"mknodes", "[<device>]", 0, 1, _mknodes},
 	{"targets", "", 0, 0, _targets},
@@ -1868,6 +1884,7 @@
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"showkeys", 0, &ind, SHOWKEYS_ARG},
 		{"table", 1, &ind, TABLE_ARG},
 		{"target", 1, &ind, TARGET_ARG},
 		{"tree", 0, &ind, TREE_ARG},
@@ -1988,6 +2005,8 @@
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
+		if ((ind == SHOWKEYS_ARG))
+			_switches[SHOWKEYS_ARG]++;
 		if ((ind == TABLE_ARG)) {
 			_switches[TABLE_ARG]++;
 			_table = optarg;
