From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 18 Jan 2007 17:48:01 -0000
Message-ID: <20070118174801.31245.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-18 17:47:59

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-report.c 

Log message:
	Some internal renaming.
	Add --separator and --sort to dmsetup (unused as yet).
	Make alignment flag optional when specifying report fields.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.151&r2=1.152
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.76&r2=1.77
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.64&r2=1.65
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- device-mapper/WHATS_NEW	2007/01/17 17:50:54	1.151
+++ device-mapper/WHATS_NEW	2007/01/18 17:47:56	1.152
@@ -1,5 +1,8 @@
 Version 1.02.16 -
 ===================================
+  Add --separator and --sort to dmsetup (unused).
+  Make alignment flag optional when specifying report fields.
+
 Version 1.02.15 - 17th January 2007
 ===================================
   Add basic reporting functions to libdevmapper.
--- device-mapper/dmsetup/dmsetup.c	2007/01/16 21:13:07	1.76
+++ device-mapper/dmsetup/dmsetup.c	2007/01/18 17:47:57	1.77
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
- * Copyright (C) 2005 NEC Corperation
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 NEC Corperation
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -114,7 +114,9 @@
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
+	SORT_ARG,
 	TABLE_ARG,
 	TARGET_ARG,
 	TREE_ARG,
@@ -126,10 +128,10 @@
 };
 
 static int _switches[NUM_SWITCHES];
-static int _values[NUM_SWITCHES];
+static int _int_args[NUM_SWITCHES];
+static char *_string_args[NUM_SWITCHES];
 static int _num_devices;
 static char *_uuid;
-static char *_fields;
 static char *_table;
 static char *_target;
 static char *_command;
@@ -348,8 +350,8 @@
 		if (!dm_task_set_uuid(dmt, _uuid))
 			return 0;
 	} else if (_switches[MAJOR_ARG] && _switches[MINOR_ARG]) {
-		if (!dm_task_set_major(dmt, _values[MAJOR_ARG]) ||
-		    !dm_task_set_minor(dmt, _values[MINOR_ARG]))
+		if (!dm_task_set_major(dmt, _int_args[MAJOR_ARG]) ||
+		    !dm_task_set_minor(dmt, _int_args[MINOR_ARG]))
 			return 0;
 	} else if (!optional) {
 		fprintf(stderr, "No device specified.\n");
@@ -440,19 +442,19 @@
 	if (_switches[READ_ONLY] && !dm_task_set_ro(dmt))
 		goto out;
 
-	if (_switches[MAJOR_ARG] && !dm_task_set_major(dmt, _values[MAJOR_ARG]))
+	if (_switches[MAJOR_ARG] && !dm_task_set_major(dmt, _int_args[MAJOR_ARG]))
 		goto out;
 
-	if (_switches[MINOR_ARG] && !dm_task_set_minor(dmt, _values[MINOR_ARG]))
+	if (_switches[MINOR_ARG] && !dm_task_set_minor(dmt, _int_args[MINOR_ARG]))
 		goto out;
 
-	if (_switches[UID_ARG] && !dm_task_set_uid(dmt, _values[UID_ARG]))
+	if (_switches[UID_ARG] && !dm_task_set_uid(dmt, _int_args[UID_ARG]))
 		goto out;
 
-	if (_switches[GID_ARG] && !dm_task_set_gid(dmt, _values[GID_ARG]))
+	if (_switches[GID_ARG] && !dm_task_set_gid(dmt, _int_args[GID_ARG]))
 		goto out;
 
-	if (_switches[MODE_ARG] && !dm_task_set_mode(dmt, _values[MODE_ARG]))
+	if (_switches[MODE_ARG] && !dm_task_set_mode(dmt, _int_args[MODE_ARG]))
 		goto out;
 
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
@@ -1736,7 +1738,7 @@
 
 #ifdef HAVE_SYS_STATVFS_H
 	if (fstatvfs(fd, &fsbuf))
-		goto error;       
+		goto error;
 
 	/* FIXME Fragment size currently unused */
 	blksize = fsbuf.f_frsize;
@@ -1744,7 +1746,7 @@
 
 	close(fd);
 
-	if (dm_snprintf(table, tlen, "%llu %llu loop %s %llu\n", 0ULL, 
+	if (dm_snprintf(table, tlen, "%llu %llu loop %s %llu\n", 0ULL,
 			(long long unsigned)sectors, file, off) < 0)
 		return 0;
 
@@ -1888,7 +1890,9 @@
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
+		{"sort", 1, &ind, SORT_ARG},
 		{"table", 1, &ind, TABLE_ARG},
 		{"target", 1, &ind, TARGET_ARG},
 		{"tree", 0, &ind, TREE_ARG},
@@ -1906,7 +1910,7 @@
 	 * Zero all the index counts.
 	 */
 	memset(&_switches, 0, sizeof(_switches));
-	memset(&_values, 0, sizeof(_values));
+	memset(&_int_args, 0, sizeof(_int_args));
 
 	namebase = strdup((*argv)[0]);
 	base = basename(namebase);
@@ -1918,17 +1922,17 @@
 		_switches[OPTIONS_ARG]++;
 		_switches[MAJOR_ARG]++;
 		_switches[MINOR_ARG]++;
-		_fields = (char *) "name";
+		_string_args[OPTIONS_ARG] = (char *) "name";
 
 		if (*argc == 3) {
-			_values[MAJOR_ARG] = atoi((*argv)[1]);
-			_values[MINOR_ARG] = atoi((*argv)[2]);
+			_int_args[MAJOR_ARG] = atoi((*argv)[1]);
+			_int_args[MINOR_ARG] = atoi((*argv)[2]);
 			*argc -= 2;
 			*argv += 2;
 		} else if ((*argc == 2) &&
 			   (2 == sscanf((*argv)[1], "%i:%i",
-					&_values[MAJOR_ARG],
-					&_values[MINOR_ARG]))) {
+					&_int_args[MAJOR_ARG],
+					&_int_args[MINOR_ARG]))) {
 			*argc -= 1;
 			*argv += 1;
 		} else {
@@ -1950,7 +1954,7 @@
 
 	optarg = 0;
 	optind = OPTIND_INIT;
-	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfGj:m:Mno:ru:Uv",
+	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfGj:m:Mno:O:ru:Uv",
 					    long_options, NULL)) != -1) {
 		if (c == ':' || c == '?')
 			return 0;
@@ -1962,17 +1966,25 @@
 			_switches[READ_ONLY]++;
 		if (c == 'j' || ind == MAJOR_ARG) {
 			_switches[MAJOR_ARG]++;
-			_values[MAJOR_ARG] = atoi(optarg);
+			_int_args[MAJOR_ARG] = atoi(optarg);
 		}
 		if (c == 'm' || ind == MINOR_ARG) {
 			_switches[MINOR_ARG]++;
-			_values[MINOR_ARG] = atoi(optarg);
+			_int_args[MINOR_ARG] = atoi(optarg);
 		}
 		if (c == 'n' || ind == NOTABLE_ARG)
 			_switches[NOTABLE_ARG]++;
 		if (c == 'o' || ind == OPTIONS_ARG) {
 			_switches[OPTIONS_ARG]++;
-			_fields = optarg;
+			_string_args[OPTIONS_ARG] = optarg;
+		}
+		if (ind == SEPARATOR_ARG) {
+			_switches[SEPARATOR_ARG]++;
+			_string_args[SEPARATOR_ARG] = optarg;
+		}
+		if (c == 'O' || ind == SORT_ARG) {
+			_switches[SORT_ARG]++;
+			_string_args[SORT_ARG] = optarg;
 		}
 		if (c == 'v' || ind == VERBOSE_ARG)
 			_switches[VERBOSE_ARG]++;
@@ -1982,16 +1994,16 @@
 		}
 		if (c == 'G' || ind == GID_ARG) {
 			_switches[GID_ARG]++;
-			_values[GID_ARG] = atoi(optarg);
+			_int_args[GID_ARG] = atoi(optarg);
 		}
 		if (c == 'U' || ind == UID_ARG) {
 			_switches[UID_ARG]++;
-			_values[UID_ARG] = atoi(optarg);
+			_int_args[UID_ARG] = atoi(optarg);
 		}
 		if (c == 'M' || ind == MODE_ARG) {
 			_switches[MODE_ARG]++;
 			/* FIXME Accept modes as per chmod */
-			_values[MODE_ARG] = (int) strtol(optarg, NULL, 8);
+			_int_args[MODE_ARG] = (int) strtol(optarg, NULL, 8);
 		}
 		if ((ind == EXEC_ARG)) {
 			_switches[EXEC_ARG]++;
@@ -2032,12 +2044,12 @@
 	}
 
 	if (_switches[COLS_ARG] && _switches[OPTIONS_ARG] &&
-	    strcmp(_fields, "name")) {
+	    strcmp(_string_args[OPTIONS_ARG], "name")) {
 		fprintf(stderr, "Only -o name is supported so far.\n");
 		return 0;
 	}
 
-	if (_switches[TREE_ARG] && !_process_tree_options(_fields))
+	if (_switches[TREE_ARG] && !_process_tree_options(_string_args[OPTIONS_ARG]))
 		return 0;
 
 	if (_switches[TABLE_ARG] && _switches[NOTABLE_ARG]) {
--- device-mapper/lib/libdevmapper.h	2007/01/16 18:03:40	1.64
+++ device-mapper/lib/libdevmapper.h	2007/01/18 17:47:58	1.65
@@ -646,11 +646,13 @@
 /*
  * dm_report_field_type flags
  */
-#define DM_REPORT_FIELD_MASK		0x0000000F
+#define DM_REPORT_FIELD_MASK		0x000000FF
+#define DM_REPORT_FIELD_ALIGN_MASK	0x0000000F
 #define DM_REPORT_FIELD_ALIGN_LEFT	0x00000001
 #define DM_REPORT_FIELD_ALIGN_RIGHT	0x00000002
-#define DM_REPORT_FIELD_STRING		0x00000004
-#define DM_REPORT_FIELD_NUMBER		0x00000008
+#define DM_REPORT_FIELD_TYPE_MASK	0x000000F0
+#define DM_REPORT_FIELD_TYPE_STRING	0x00000010
+#define DM_REPORT_FIELD_TYPE_NUMBER	0x00000020
 
 struct dm_report;
 struct dm_report_field_type {
@@ -668,7 +670,7 @@
 /*
  * dm_report_init output_flags
  */
-#define DM_REPORT_OUTPUT_MASK		0x00000007
+#define DM_REPORT_OUTPUT_MASK		0x000000FF
 #define DM_REPORT_OUTPUT_ALIGNED	0x00000001
 #define DM_REPORT_OUTPUT_BUFFERED	0x00000002
 #define DM_REPORT_OUTPUT_HEADINGS	0x00000004
--- device-mapper/lib/libdm-report.c	2007/01/16 21:13:07	1.2
+++ device-mapper/lib/libdm-report.c	2007/01/18 17:47:58	1.3
@@ -672,7 +672,7 @@
 	for (cnt = 0; cnt < rowa->rh->keys_count; cnt++) {
 		sfa = (*rowa->sort_fields)[cnt];
 		sfb = (*rowb->sort_fields)[cnt];
-		if (sfa->props->flags & DM_REPORT_FIELD_NUMBER) {
+		if (sfa->props->flags & DM_REPORT_FIELD_TYPE_NUMBER) {
 			const uint64_t numa =
 			    *(const uint64_t *) sfa->sort_value;
 			const uint64_t numb =
@@ -686,7 +686,7 @@
 			} else {	/* FLD_DESCENDING */
 				return (numa < numb) ? 1 : -1;
 			}
-		} else {	/* DM_REPORT_FIELD_STRING */
+		} else {	/* DM_REPORT_FIELD_TYPE_STRING */
 			const char *stra = (const char *) sfa->sort_value;
 			const char *strb = (const char *) sfb->sort_value;
 			int cmp = strcmp(stra, strb);
@@ -740,6 +740,7 @@
 	const char *repstr;
 	char buf[4096];
 	unsigned width;
+	uint32_t align;
 
 	if (list_empty(&rh->rows))
 		return 1;
@@ -771,18 +772,23 @@
 				if (!dm_pool_grow_object(rh->mem, repstr,
 						      strlen(repstr)))
 					goto bad_grow;
-			} else if (field->props->flags & DM_REPORT_FIELD_ALIGN_LEFT) {
-				if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
-						 width, width, repstr) < 0)
-					goto bad_snprintf;
-				if (!dm_pool_grow_object(rh->mem, buf, width))
-					goto bad_grow;
-			} else if (field->props->flags & DM_REPORT_FIELD_ALIGN_RIGHT) {
-				if (dm_snprintf(buf, sizeof(buf), "%*.*s",
-						 width, width, repstr) < 0)
-					goto bad_snprintf;
-				if (!dm_pool_grow_object(rh->mem, buf, width))
-					goto bad_grow;
+			} else {
+				if (!(align = field->props->flags & DM_REPORT_FIELD_ALIGN_MASK))
+					align = (field->props->flags & DM_REPORT_FIELD_TYPE_NUMBER) ? 
+						DM_REPORT_FIELD_ALIGN_RIGHT : DM_REPORT_FIELD_ALIGN_LEFT;
+				if (align & DM_REPORT_FIELD_ALIGN_LEFT) {
+					if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
+							 width, width, repstr) < 0)
+						goto bad_snprintf;
+					if (!dm_pool_grow_object(rh->mem, buf, width))
+						goto bad_grow;
+				} else if (field->props->flags & DM_REPORT_FIELD_ALIGN_RIGHT) {
+					if (dm_snprintf(buf, sizeof(buf), "%*.*s",
+							 width, width, repstr) < 0)
+						goto bad_snprintf;
+					if (!dm_pool_grow_object(rh->mem, buf, width))
+						goto bad_grow;
+				}
 			}
 
 			if (!list_end(&row->fields, fh))
