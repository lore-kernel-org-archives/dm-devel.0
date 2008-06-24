From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 24 Jun 2008 20:16:48 -0000
Message-ID: <20080624201648.16859.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-24 20:16:47

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-report.c 

Log message:
	dmsetup --unquoted

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.242&r2=1.243
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.109&r2=1.110
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.81&r2=1.82
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.19&r2=1.20

--- device-mapper/WHATS_NEW	2008/06/18 10:19:25	1.242
+++ device-mapper/WHATS_NEW	2008/06/24 20:16:47	1.243
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Add --unquoted to dmsetup.
   Avoid compiler warning about cast in dmsetup.c's OFFSET_OF macro.
   Fix inverted no_flush debug message.
   Remove --enable-jobs from configure. (Set at runtime instead.)
--- device-mapper/dmsetup/dmsetup.c	2008/06/18 10:19:25	1.109
+++ device-mapper/dmsetup/dmsetup.c	2008/06/24 20:16:47	1.110
@@ -130,6 +130,7 @@
 	TREE_ARG,
 	UID_ARG,
 	UNBUFFERED_ARG,
+	UNQUOTED_ARG,
 	UUID_ARG,
 	VERBOSE_ARG,
 	VERSION_ARG,
@@ -1975,7 +1976,7 @@
 	char *options = (char *) default_report_options;
 	const char *keys = "";
 	const char *separator = " ";
-	int aligned = 1, headings = 1, buffered = 1, field_prefixes = 0;
+	int aligned = 1, headings = 1, buffered = 1, field_prefixes = 0, quoted = 1;
 	uint32_t flags = 0;
 	size_t len = 0;
 	int r = 0;
@@ -1990,6 +1991,9 @@
 	if (_switches[UNBUFFERED_ARG])
 		buffered = 0;
 
+	if (_switches[UNQUOTED_ARG])
+		quoted = 0;
+
 	if (_switches[NAMEPREFIXES_ARG]) {
 		aligned = 0;
 		field_prefixes = 1;
@@ -2040,6 +2044,9 @@
 	if (field_prefixes)
 		flags |= DM_REPORT_OUTPUT_FIELD_NAME_PREFIX;
 
+	if (!quoted)
+		flags |= DM_REPORT_OUTPUT_FIELD_UNQUOTED;
+
 	if (!(_report = dm_report_init(&_report_type,
 				       _report_types, _report_fields,
 				       options, separator, flags, keys, NULL)))
@@ -2492,6 +2499,7 @@
 		{"uid", 1, &ind, UID_ARG},
 		{"uuid", 1, &ind, UUID_ARG},
 		{"unbuffered", 0, &ind, UNBUFFERED_ARG},
+		{"unquoted", 0, &ind, UNQUOTED_ARG},
 		{"verbose", 1, &ind, VERBOSE_ARG},
 		{"version", 0, &ind, VERSION_ARG},
 		{0, 0, 0, 0}
@@ -2646,8 +2654,8 @@
 		}
 		if ((ind == TREE_ARG))
 			_switches[TREE_ARG]++;
-		if ((ind == UNBUFFERED_ARG))
-			_switches[UNBUFFERED_ARG]++;
+		if ((ind == UNQUOTED_ARG))
+			_switches[UNQUOTED_ARG]++;
 		if ((ind == VERSION_ARG))
 			_switches[VERSION_ARG]++;
 	}
--- device-mapper/lib/libdevmapper.h	2008/04/20 00:11:08	1.81
+++ device-mapper/lib/libdevmapper.h	2008/06/24 20:16:47	1.82
@@ -740,6 +740,7 @@
 #define DM_REPORT_OUTPUT_BUFFERED		0x00000002
 #define DM_REPORT_OUTPUT_HEADINGS		0x00000004
 #define DM_REPORT_OUTPUT_FIELD_NAME_PREFIX	0x00000008
+#define DM_REPORT_OUTPUT_FIELD_UNQUOTED		0x00000010
 
 struct dm_report *dm_report_init(uint32_t *report_types,
 				 const struct dm_report_object_type *types,
--- device-mapper/lib/libdm-report.c	2008/06/06 19:07:47	1.19
+++ device-mapper/lib/libdm-report.c	2008/06/24 20:16:47	1.20
@@ -845,7 +845,13 @@
 
 				free(field_id);
 
-				if (!dm_pool_grow_object(rh->mem, "=\'", 2)) {
+				if (!dm_pool_grow_object(rh->mem, "=", 1)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+
+				if (!(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED) &&
+				    !dm_pool_grow_object(rh->mem, "\'", 1)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
@@ -885,7 +891,8 @@
 				}
 			}
 
-			if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX)
+			if ((rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) &&
+			    !(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED))
 				if (!dm_pool_grow_object(rh->mem, "\'", 1)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
