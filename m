From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 21 Apr 2008 11:59:23 -0000
Message-ID: <20080421115923.14343.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-04-21 11:59:22

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Add --prefixes to dmsetup
	
	E.g. dmsetup info -c --prefixes
	
	Again, might change the name of this option.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.229&r2=1.230
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.104&r2=1.105

--- device-mapper/WHATS_NEW	2008/04/20 00:11:07	1.229
+++ device-mapper/WHATS_NEW	2008/04/21 11:59:22	1.230
@@ -1,5 +1,6 @@
 Version 1.02.26 - 
 =================================
+  Add --prefixes to dmsetup.
   Add field name prefix option to reporting functions.
   Calculate string size within dm_pool_grow_object.
 
--- device-mapper/dmsetup/dmsetup.c	2008/04/19 15:50:17	1.104
+++ device-mapper/dmsetup/dmsetup.c	2008/04/21 11:59:22	1.105
@@ -120,6 +120,7 @@
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	PREFIXES_ARG,
 	READAHEAD_ARG,
 	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
@@ -1914,7 +1915,7 @@
 	char *options = (char *) default_report_options;
 	const char *keys = "";
 	const char *separator = " ";
-	int aligned = 1, headings = 1, buffered = 1;
+	int aligned = 1, headings = 1, buffered = 1, field_prefixes = 0;
 	uint32_t flags = 0;
 	size_t len = 0;
 	int r = 0;
@@ -1929,6 +1930,11 @@
 	if (_switches[UNBUFFERED_ARG])
 		buffered = 0;
 
+	if (_switches[PREFIXES_ARG]) {
+		aligned = 0;
+		field_prefixes = 1;
+	}
+
 	if (_switches[OPTIONS_ARG] && _string_args[OPTIONS_ARG]) {
 		if (*_string_args[OPTIONS_ARG] != '+')
 			options = _string_args[OPTIONS_ARG];
@@ -1971,6 +1977,9 @@
 	if (headings)
 		flags |= DM_REPORT_OUTPUT_HEADINGS;
 
+	if (field_prefixes)
+		flags |= DM_REPORT_OUTPUT_FIELD_NAME_PREFIX;
+
 	if (!(_report = dm_report_init(&_report_type,
 				       _report_types, _report_fields,
 				       options, separator, flags, keys, NULL)))
@@ -1981,6 +1990,9 @@
 		goto out;
 	}
 
+	if (field_prefixes)
+		dm_report_set_output_field_name_prefix(_report, "dm_");
+
 	r = 1;
 
 out:
@@ -2047,7 +2059,7 @@
 		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
 		"        [--readahead [+]<sectors>|auto|none]\n"
 		"        [-c|-C|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
-		"        [--noheadings] [--separator <separator>]\n\n");
+		"        [--noheadings] [--prefixes] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
@@ -2409,6 +2421,7 @@
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"prefixes", 0, &ind, PREFIXES_ARG},
 		{"readahead", 1, &ind, READAHEAD_ARG},
 		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
@@ -2543,6 +2556,8 @@
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
+		if ((ind == PREFIXES_ARG))
+			_switches[PREFIXES_ARG]++;
 		if ((ind == READAHEAD_ARG)) {
 			_switches[READAHEAD_ARG]++;
 			if (!strcasecmp(optarg, "auto"))
