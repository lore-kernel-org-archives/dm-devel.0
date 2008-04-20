From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/.exported_symbol ...
Date: 20 Apr 2008 00:11:08 -0000
Message-ID: <20080420001108.22448.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-04-20 00:11:08

Modified files:
	.              : WHATS_NEW 
	lib            : .exported_symbols libdevmapper.h libdm-report.c 

Log message:
	Add field name prefix option to reporting functions.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.228&r2=1.229
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.32&r2=1.33
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.80&r2=1.81
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.17&r2=1.18

--- device-mapper/WHATS_NEW	2008/04/19 15:50:17	1.228
+++ device-mapper/WHATS_NEW	2008/04/20 00:11:07	1.229
@@ -1,5 +1,6 @@
 Version 1.02.26 - 
 =================================
+  Add field name prefix option to reporting functions.
   Calculate string size within dm_pool_grow_object.
 
 Version 1.02.25 - 10th April 2008
--- device-mapper/lib/.exported_symbols	2007/11/27 20:57:05	1.32
+++ device-mapper/lib/.exported_symbols	2008/04/20 00:11:08	1.33
@@ -132,5 +132,6 @@
 dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
+dm_report_set_output_field_name_prefix
 dm_regex_create
 dm_regex_match
--- device-mapper/lib/libdevmapper.h	2008/04/19 15:50:18	1.80
+++ device-mapper/lib/libdevmapper.h	2008/04/20 00:11:08	1.81
@@ -735,10 +735,11 @@
 /*
  * dm_report_init output_flags
  */
-#define DM_REPORT_OUTPUT_MASK		0x000000FF
-#define DM_REPORT_OUTPUT_ALIGNED	0x00000001
-#define DM_REPORT_OUTPUT_BUFFERED	0x00000002
-#define DM_REPORT_OUTPUT_HEADINGS	0x00000004
+#define DM_REPORT_OUTPUT_MASK			0x000000FF
+#define DM_REPORT_OUTPUT_ALIGNED		0x00000001
+#define DM_REPORT_OUTPUT_BUFFERED		0x00000002
+#define DM_REPORT_OUTPUT_HEADINGS		0x00000004
+#define DM_REPORT_OUTPUT_FIELD_NAME_PREFIX	0x00000008
 
 struct dm_report *dm_report_init(uint32_t *report_types,
 				 const struct dm_report_object_type *types,
@@ -753,6 +754,12 @@
 void dm_report_free(struct dm_report *rh);
 
 /*
+ * Prefix added to each field name with DM_REPORT_OUTPUT_FIELD_NAME_PREFIX
+ */
+int dm_report_set_output_field_name_prefix(struct dm_report *rh,
+					   const char *report_prefix);
+
+/*
  * Report functions are provided for simple data types.
  * They take care of allocating copies of the data.
  */
--- device-mapper/lib/libdm-report.c	2008/04/19 15:50:18	1.17
+++ device-mapper/lib/libdm-report.c	2008/04/20 00:11:08	1.18
@@ -17,6 +17,8 @@
 #include "list.h"
 #include "log.h"
 
+#include <ctype.h>
+
 /*
  * Internal flags
  */
@@ -27,6 +29,7 @@
 	struct dm_pool *mem;
 
 	uint32_t report_types;
+	const char *output_field_name_prefix;
 	const char *field_prefix;
 	uint32_t flags;
 	const char *separator;
@@ -551,6 +554,31 @@
 	dm_free(rh);
 }
 
+static char *_toupperstr(char *str)
+{
+	char *u = str;
+
+	do
+		*u = toupper(*u);
+	while (*u++);
+
+	return str;
+}
+
+int dm_report_set_output_field_name_prefix(struct dm_report *rh, const char *output_field_name_prefix)
+{
+	char *prefix;
+
+	if (!(prefix = dm_pool_strdup(rh->mem, output_field_name_prefix))) {
+		log_error("dm_report_set_output_field_name_prefix: dm_pool_strdup failed");
+		return 0;
+	}
+
+	rh->output_field_name_prefix = _toupperstr(prefix);
+	
+	return 1;
+}
+
 /*
  * Create a row of data for an object
  */
@@ -771,6 +799,7 @@
 	struct row *row = NULL;
 	struct dm_report_field *field;
 	const char *repstr;
+	char *field_id;
 	char buf[4096];
 	int32_t width;
 	uint32_t align;
@@ -798,6 +827,30 @@
 			if (field->props->flags & FLD_HIDDEN)
 				continue;
 
+			if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) {
+				if (!(field_id = strdup(rh->fields[field->props->field_num].id))) {
+					log_error("dm_report: Failed to copy field name");
+					goto bad;
+				}
+
+				if (!dm_pool_grow_object(rh->mem, rh->output_field_name_prefix, 0)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+
+				if (!dm_pool_grow_object(rh->mem, _toupperstr(field_id), 0)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+
+				free(field_id);
+
+				if (!dm_pool_grow_object(rh->mem, "=\"", 2)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+			}
+
 			repstr = field->report_string;
 			width = field->props->width;
 			if (!(rh->flags & DM_REPORT_OUTPUT_ALIGNED)) {
@@ -832,6 +885,12 @@
 				}
 			}
 
+			if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX)
+				if (!dm_pool_grow_object(rh->mem, "\"", 1)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+				
 			if (!list_end(&row->fields, fh))
 				if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
 					log_error("dm_report: Unable to extend output line");
