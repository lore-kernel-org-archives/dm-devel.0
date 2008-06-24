From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 24 Jun 2008 22:53:48 -0000
Message-ID: <20080624225348.16387.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-24 22:53:48

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-report.c 

Log message:
	Add --rows to dmsetup.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.243&r2=1.244
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.110&r2=1.111
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.82&r2=1.83
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.20&r2=1.21

--- device-mapper/WHATS_NEW	2008/06/24 20:16:47	1.243
+++ device-mapper/WHATS_NEW	2008/06/24 22:53:47	1.244
@@ -1,6 +1,6 @@
 Version 1.02.27 -
 ===============================
-  Add --unquoted to dmsetup.
+  Add --unquoted and --rows to dmsetup.
   Avoid compiler warning about cast in dmsetup.c's OFFSET_OF macro.
   Fix inverted no_flush debug message.
   Remove --enable-jobs from configure. (Set at runtime instead.)
--- device-mapper/dmsetup/dmsetup.c	2008/06/24 20:16:47	1.110
+++ device-mapper/dmsetup/dmsetup.c	2008/06/24 22:53:47	1.111
@@ -122,6 +122,7 @@
 	NOTABLE_ARG,
 	OPTIONS_ARG,
 	READAHEAD_ARG,
+	ROWS_ARG,
 	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
 	SORT_ARG,
@@ -1976,7 +1977,8 @@
 	char *options = (char *) default_report_options;
 	const char *keys = "";
 	const char *separator = " ";
-	int aligned = 1, headings = 1, buffered = 1, field_prefixes = 0, quoted = 1;
+	int aligned = 1, headings = 1, buffered = 1, field_prefixes = 0;
+	int quoted = 1, columns_as_rows = 0;
 	uint32_t flags = 0;
 	size_t len = 0;
 	int r = 0;
@@ -1991,6 +1993,9 @@
 	if (_switches[UNBUFFERED_ARG])
 		buffered = 0;
 
+	if (_switches[ROWS_ARG])
+		columns_as_rows = 1;
+
 	if (_switches[UNQUOTED_ARG])
 		quoted = 0;
 
@@ -2047,6 +2052,9 @@
 	if (!quoted)
 		flags |= DM_REPORT_OUTPUT_FIELD_UNQUOTED;
 
+	if (columns_as_rows)
+		flags |= DM_REPORT_OUTPUT_COLUMNS_AS_ROWS;
+
 	if (!(_report = dm_report_init(&_report_type,
 				       _report_types, _report_fields,
 				       options, separator, flags, keys, NULL)))
@@ -2490,6 +2498,7 @@
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
 		{"readahead", 1, &ind, READAHEAD_ARG},
+		{"rows", 0, &ind, ROWS_ARG},
 		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
 		{"sort", 1, &ind, SORT_ARG},
@@ -2646,6 +2655,8 @@
 				}
 			}
 		}
+		if ((ind == ROWS_ARG))
+			_switches[ROWS_ARG]++;
 		if ((ind == SHOWKEYS_ARG))
 			_switches[SHOWKEYS_ARG]++;
 		if ((ind == TABLE_ARG)) {
--- device-mapper/lib/libdevmapper.h	2008/06/24 20:16:47	1.82
+++ device-mapper/lib/libdevmapper.h	2008/06/24 22:53:48	1.83
@@ -741,6 +741,7 @@
 #define DM_REPORT_OUTPUT_HEADINGS		0x00000004
 #define DM_REPORT_OUTPUT_FIELD_NAME_PREFIX	0x00000008
 #define DM_REPORT_OUTPUT_FIELD_UNQUOTED		0x00000010
+#define DM_REPORT_OUTPUT_COLUMNS_AS_ROWS	0x00000020
 
 struct dm_report *dm_report_init(uint32_t *report_types,
 				 const struct dm_report_object_type *types,
--- device-mapper/lib/libdm-report.c	2008/06/24 20:16:47	1.20
+++ device-mapper/lib/libdm-report.c	2008/06/24 22:53:48	1.21
@@ -513,6 +513,14 @@
 
 	rh->flags |= output_flags & DM_REPORT_OUTPUT_MASK;
 
+	/* With columns_as_rows we must buffer and not align. */
+	if (output_flags & DM_REPORT_OUTPUT_COLUMNS_AS_ROWS) {
+		if (!(output_flags & DM_REPORT_OUTPUT_BUFFERED))
+			rh->flags |= DM_REPORT_OUTPUT_BUFFERED;
+		if (output_flags & DM_REPORT_OUTPUT_ALIGNED)
+			rh->flags &= ~DM_REPORT_OUTPUT_ALIGNED;
+	}
+
 	if (output_flags & DM_REPORT_OUTPUT_BUFFERED)
 		rh->flags |= RH_SORT_REQUIRED;
 
@@ -793,23 +801,146 @@
 /*
  * Produce report output
  */
-int dm_report_output(struct dm_report *rh)
+static int _output_field(struct dm_report *rh, struct dm_report_field *field)
 {
-	struct list *fh, *rowh, *ftmp, *rtmp;
-	struct row *row = NULL;
-	struct dm_report_field *field;
-	const char *repstr;
 	char *field_id;
-	char buf[4096];
 	int32_t width;
 	uint32_t align;
+	const char *repstr;
+	char buf[4096];
 
-	if (list_empty(&rh->rows))
-		return 1;
+	if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) {
+		if (!(field_id = strdup(rh->fields[field->props->field_num].id))) {
+			log_error("dm_report: Failed to copy field name");
+			return 0;
+		}
 
-	/* Sort rows */
-	if ((rh->flags & RH_SORT_REQUIRED))
-		_sort_rows(rh);
+		if (!dm_pool_grow_object(rh->mem, rh->output_field_name_prefix, 0)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+
+		if (!dm_pool_grow_object(rh->mem, _toupperstr(field_id), 0)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+
+		free(field_id);
+
+		if (!dm_pool_grow_object(rh->mem, "=", 1)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+
+		if (!(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED) &&
+		    !dm_pool_grow_object(rh->mem, "\'", 1)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+	}
+
+	repstr = field->report_string;
+	width = field->props->width;
+	if (!(rh->flags & DM_REPORT_OUTPUT_ALIGNED)) {
+		if (!dm_pool_grow_object(rh->mem, repstr, 0)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+	} else {
+		if (!(align = field->props->flags & DM_REPORT_FIELD_ALIGN_MASK))
+			align = (field->props->flags & DM_REPORT_FIELD_TYPE_NUMBER) ? 
+				DM_REPORT_FIELD_ALIGN_RIGHT : DM_REPORT_FIELD_ALIGN_LEFT;
+		if (align & DM_REPORT_FIELD_ALIGN_LEFT) {
+			if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
+					 width, width, repstr) < 0) {
+				log_error("dm_report: left-aligned snprintf() failed");
+				return 0;
+			}
+			if (!dm_pool_grow_object(rh->mem, buf, width)) {
+				log_error("dm_report: Unable to extend output line");
+				return 0;
+			}
+		} else if (align & DM_REPORT_FIELD_ALIGN_RIGHT) {
+			if (dm_snprintf(buf, sizeof(buf), "%*.*s",
+					 width, width, repstr) < 0) {
+				log_error("dm_report: right-aligned snprintf() failed");
+				return 0;
+			}
+			if (!dm_pool_grow_object(rh->mem, buf, width)) {
+				log_error("dm_report: Unable to extend output line");
+				return 0;
+			}
+		}
+	}
+
+	if ((rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) &&
+	    !(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED))
+		if (!dm_pool_grow_object(rh->mem, "\'", 1)) {
+			log_error("dm_report: Unable to extend output line");
+			return 0;
+		}
+
+	return 1;
+}
+
+static int _output_as_rows(struct dm_report *rh)
+{
+	struct field_properties *fp;
+	struct dm_report_field *field;
+	struct row *row;
+
+	if (!dm_pool_begin_object(rh->mem, 512)) {
+		log_error("dm_report: Unable to allocate output line");
+		return 0;
+	}
+
+	list_iterate_items(fp, &rh->field_props) {
+		if (fp->flags & FLD_HIDDEN)
+			continue;
+
+		if ((rh->flags & DM_REPORT_OUTPUT_HEADINGS)) {
+			if (!dm_pool_grow_object(rh->mem, rh->fields[fp->field_num].heading, 0)) {
+				log_error("dm_report: Failed to extend row for field name");
+				goto bad;
+			}
+			if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
+				log_error("dm_report: Failed to extend row with separator");
+				goto bad;
+			}
+		}
+
+		list_iterate_items(row, &rh->rows) {
+			field = list_item(list_first(&row->fields), struct dm_report_field);
+			if (!_output_field(rh, field))
+				goto bad;
+			list_del(&field->list);
+
+			if (!list_end(&rh->rows, &row->list))
+				if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
+					log_error("dm_report: Unable to extend output line");
+					goto bad;
+				}
+		}
+
+		if (!dm_pool_grow_object(rh->mem, "\0", 1)) {
+			log_error("dm_report: Failed to terminate row");
+			goto bad;
+		}
+		log_print("%s", (char *) dm_pool_end_object(rh->mem));
+	}
+
+	return 1;
+
+      bad:
+	dm_pool_abandon_object(rh->mem);
+	return 0;
+}
+
+static int _output_as_columns(struct dm_report *rh)
+{
+	struct list *fh, *rowh, *ftmp, *rtmp;
+	struct row *row = NULL;
+	struct dm_report_field *field;
 
 	/* If headings not printed yet, calculate field widths and print them */
 	if (!(rh->flags & RH_HEADINGS_PRINTED))
@@ -827,82 +958,15 @@
 			if (field->props->flags & FLD_HIDDEN)
 				continue;
 
-			if (rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) {
-				if (!(field_id = strdup(rh->fields[field->props->field_num].id))) {
-					log_error("dm_report: Failed to copy field name");
-					goto bad;
-				}
-
-				if (!dm_pool_grow_object(rh->mem, rh->output_field_name_prefix, 0)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-
-				if (!dm_pool_grow_object(rh->mem, _toupperstr(field_id), 0)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-
-				free(field_id);
-
-				if (!dm_pool_grow_object(rh->mem, "=", 1)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-
-				if (!(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED) &&
-				    !dm_pool_grow_object(rh->mem, "\'", 1)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-			}
-
-			repstr = field->report_string;
-			width = field->props->width;
-			if (!(rh->flags & DM_REPORT_OUTPUT_ALIGNED)) {
-				if (!dm_pool_grow_object(rh->mem, repstr, 0)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-			} else {
-				if (!(align = field->props->flags & DM_REPORT_FIELD_ALIGN_MASK))
-					align = (field->props->flags & DM_REPORT_FIELD_TYPE_NUMBER) ? 
-						DM_REPORT_FIELD_ALIGN_RIGHT : DM_REPORT_FIELD_ALIGN_LEFT;
-				if (align & DM_REPORT_FIELD_ALIGN_LEFT) {
-					if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
-							 width, width, repstr) < 0) {
-						log_error("dm_report: left-aligned snprintf() failed");
-						goto bad;
-					}
-					if (!dm_pool_grow_object(rh->mem, buf, width)) {
-						log_error("dm_report: Unable to extend output line");
-						goto bad;
-					}
-				} else if (align & DM_REPORT_FIELD_ALIGN_RIGHT) {
-					if (dm_snprintf(buf, sizeof(buf), "%*.*s",
-							 width, width, repstr) < 0) {
-						log_error("dm_report: right-aligned snprintf() failed");
-						goto bad;
-					}
-					if (!dm_pool_grow_object(rh->mem, buf, width)) {
-						log_error("dm_report: Unable to extend output line");
-						goto bad;
-					}
-				}
-			}
+			if (!_output_field(rh, field))
+				goto bad;
 
-			if ((rh->flags & DM_REPORT_OUTPUT_FIELD_NAME_PREFIX) &&
-			    !(rh->flags & DM_REPORT_OUTPUT_FIELD_UNQUOTED))
-				if (!dm_pool_grow_object(rh->mem, "\'", 1)) {
-					log_error("dm_report: Unable to extend output line");
-					goto bad;
-				}
-				
 			if (!list_end(&row->fields, fh))
 				if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
 					log_error("dm_report: Unable to extend output line");
 					goto bad;
 				}
+
 			list_del(&field->list);
 		}
 		if (!dm_pool_grow_object(rh->mem, "\0", 1)) {
@@ -922,3 +986,17 @@
 	dm_pool_abandon_object(rh->mem);
 	return 0;
 }
+
+int dm_report_output(struct dm_report *rh)
+{
+	if (list_empty(&rh->rows))
+		return 1;
+
+	if ((rh->flags & RH_SORT_REQUIRED))
+		_sort_rows(rh);
+
+	if ((rh->flags & DM_REPORT_OUTPUT_COLUMNS_AS_ROWS))
+		return _output_as_rows(rh);
+	else
+		return _output_as_columns(rh);
+}
