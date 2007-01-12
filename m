From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] (1/4) dm_report support in libdevmapper
Date: Fri, 12 Jan 2007 18:13:28 -0500
Message-ID: <45A81618.2080608@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030400030806090203080609"
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
To: device-mapper development <dm-devel@redhat.com>, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030400030806090203080609
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

Attached patch adds dm_report API to libdevmapper.
The code is based on LVM2 lib/report with a enhancement
to option format (e.g. "name=a" to report objects whose
"name" field is "a") and generalizations.

I would like to use this from dmsetup to make "dmsetup info -c"
more flexible like LVM2 lvs/pvs/vgs commands.

Also, LVM2 can use this API instead of its own lib/report.

(Patches for dmsetup and LVM2 will follow.)

Comments are welcome.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------030400030806090203080609
Content-Type: text/x-patch;
 name="01-libdm-report.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-libdm-report.patch"

New dm_report API.
The code is based on LVM2 reporter function and act much like
lvs/pvs/vgs commands.

Main APIs are:
  - dm_report_init
      Register definition of reported object types and fields
      and set options.
      Returns a handle for following calls.
  - dm_report_object
      Generate report for one object.
      The result will be sorted and bufferred until dm_report_output is called
      if requested.
  - dm_report_output
      Output bufferred report.
  - dm_report_free
      Abandon the report handle.

There are some other functions for types and fields definition.

Details can be found in the patch.

And each field name passed by format parameter of dm_report_init can be
followed by the following comparison operator and the value or string:
    =   : equal to the value or string
    !=  : not equal to the value or string
    >=  : greater than or equal to the value
    <=  : lesser than or equal to the value
    <   : lesser than the value
    >   : greater than the value
    =~  : contains the string
    !~  : not contain the string
    =~^ : contains the string as prefix
    !~^ : not contain the string as prefix
    
If the field name is prefixed by "-" in "-o" option string,
the field is used only to check the condition and not displayed.



Index: device-mapper/lib/libdevmapper.h
===================================================================
--- device-mapper.orig/lib/libdevmapper.h	2007-01-12 15:21:52.000000000 -0500
+++ device-mapper/lib/libdevmapper.h	2007-01-12 15:36:55.000000000 -0500
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007 NEC Corporation
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -623,4 +624,68 @@ int dm_snprintf(char *buf, size_t bufsiz
  */
 char *dm_basename(const char *path);
 
+/*********************
+ * report function
+ *********************/
+
+struct dm_report_field;
+struct dm_report;
+
+/* Definition of reported object */
+struct dm_report_object_type {
+	uint32_t id;		/* must be a power of 2 */
+	const char *desc;	/* description of the object type */
+	const char *prefix;	/* default prefix of id string (if any) */
+	void * (*get) (void *object); /* callback from report_object() */
+};
+
+/* Definition of field */
+#define DM_REPORT_FIELD_ALIGN_LEFT	0x00000001
+#define DM_REPORT_FIELD_ALIGN_RIGHT	0x00000002
+#define DM_REPORT_FIELD_STRING	0x00000004
+#define DM_REPORT_FIELD_NUMBER	0x00000008
+struct dm_report_field_type {
+	uint32_t type;		/* object type id */
+	const char id[32];	/* string used to specify the field */
+	unsigned int offset;	/* byte offset in the object */
+	const char heading[32];	/* string printed in header */
+	int width;		/* default width */
+	uint32_t flags;		/* string or number, alignment */
+	int (*report_fn) (struct dm_report * rh, struct dm_pool * mem,
+			  struct dm_report_field * field, const void *data);
+};
+
+/*
+ * Report API
+ */
+struct dm_report *dm_report_init(const char *format, const char *keys,
+				 uint32_t *report_types, const char *separator,
+				 int aligned, int buffered, int headings,
+				 const struct dm_report_field_type *fds,
+				 int num_fds,
+				 const struct dm_report_object_type *types,
+				 int num_types,
+				 void *private);
+void dm_report_free(struct dm_report *rh);
+int dm_report_object(struct dm_report *rh, void *object);
+int dm_report_output(struct dm_report *rh);
+void * dm_report_get_private(struct dm_report *rh);
+
+/* report functions for common types */
+int dm_report_field_string(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data);
+int dm_report_field_int32(struct dm_report *rh, struct dm_pool *mem,
+			  struct dm_report_field *field, const void *data);
+int dm_report_field_uint32(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data);
+int dm_report_field_int(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data);
+int dm_report_field_uint64(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data);
+
+/* helper functions for custom report functions */
+int dm_report_field_raw(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data);
+void dm_report_field_set_string(struct dm_report_field *field, const char *string);
+void dm_report_field_set_sort_value(struct dm_report_field *field, const void *value);
 #endif				/* LIB_DEVICE_MAPPER_H */
Index: device-mapper/lib/libdm-report.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ device-mapper/lib/libdm-report.c	2007-01-12 15:56:04.000000000 -0500
@@ -0,0 +1,1111 @@
+/*
+ * Copyright (C) 2002-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007 NEC Corporation
+ *
+ * This file is part of device-mapper userspace tools.
+ * The code is based on LVM2 report function.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "libdevmapper.h"
+#include "list.h"
+#include "log.h"
+
+/*
+ * Report handle flags
+ */
+#define RH_SORT_REQUIRED	0x00000001
+#define RH_HEADINGS_PRINTED	0x00000002
+#define RH_BUFFERED		0x00000004
+#define RH_ALIGNED		0x00000008
+#define RH_HEADINGS		0x00000010
+
+struct dm_report {
+	struct dm_pool *mem;
+
+	uint32_t report_types;
+	const char *field_prefix;
+	uint32_t flags;
+	const char *separator;
+
+	uint32_t keys_count;
+
+	/* Ordered list of fields needed for this report */
+	struct list field_props;
+
+	/* Rows of report data */
+	struct list rows;
+
+	/* Array of field definitions */
+	const struct dm_report_field_type *fields;
+	int num_fields;
+	const struct dm_report_object_type *types;
+	int num_types;
+
+	/* To store caller private data */
+	void *private;
+};
+
+void * dm_report_get_private(struct dm_report *rh)
+{
+	return rh->private;
+}
+
+/*
+ * Per-field flags
+ */
+#define FLD_ALIGN_LEFT	0x00000001
+#define FLD_ALIGN_RIGHT	0x00000002
+#define FLD_STRING	0x00000004
+#define FLD_NUMBER	0x00000008
+#define FLD_HIDDEN	0x00000010
+#define FLD_SORT_KEY	0x00000020
+#define FLD_ASCENDING	0x00000040
+#define FLD_DESCENDING	0x00000080
+
+#define FLD_CMP_EQUAL	0x00010000
+#define FLD_CMP_NOT	0x00020000
+#define FLD_CMP_GT	0x00040000
+#define FLD_CMP_LT	0x00080000
+#define FLD_CMP_SUBSTR	0x00100000
+#define FLD_CMP_PREFIX	0x00200000
+#define FLD_CMP_MASK	0x00ff0000
+
+struct field_properties {
+	struct list list;
+	uint32_t field_num;
+	uint32_t sort_posn;
+	int width;
+	const struct dm_report_object_type *type;
+	uint32_t flags;
+	char *cmp;
+};
+
+/*
+ * Report data field
+ */
+struct dm_report_field {
+	struct list list;
+	struct field_properties *props;
+
+	const char *report_string;	/* Formatted ready for display */
+	const void *sort_value;		/* Raw value for sorting */
+};
+
+struct row {
+	struct list list;
+	struct dm_report *rh;
+	struct list fields;			  /* Fields in display order */
+	struct dm_report_field *(*sort_fields)[]; /* Fields in sort order */
+};
+
+static const struct dm_report_object_type *_find_type(struct dm_report *rh,
+						      uint32_t report_type)
+{
+	const struct dm_report_object_type *t;
+
+	for (t = rh->types; t < rh->types + rh->num_types; t++)
+		if (t->id == report_type)
+			return t;
+
+	return NULL;
+}
+
+/*
+ * Data-munging functions to prepare each data type for display and sorting
+ */
+
+int dm_report_field_string(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data)
+{
+	char *repstr;
+
+	if (!(repstr = dm_pool_strdup(rh->mem, *(const char **) data))) {
+		log_error("dm_report_field_string: dm_pool_strdup failed");
+		return 0;
+	}
+
+	field->report_string = repstr;
+	field->sort_value = (const void *) field->report_string;
+
+	return 1;
+}
+
+int dm_report_field_uint32(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data)
+{
+	const uint32_t value = *(const uint32_t *) data;
+	uint64_t *sortval;
+	char *repstr;
+
+	if (!(repstr = dm_pool_zalloc(rh->mem, 12))) {
+		log_error("dm_report_field_uint32: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (!(sortval = dm_pool_alloc(rh->mem, sizeof(uint64_t)))) {
+		log_error("dm_report_field_uint32: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (dm_snprintf(repstr, 11, "%u", value) < 0) {
+		log_error("dm_report_field_uint32: uint32 too big: %u", value);
+		return 0;
+	}
+
+	*sortval = (const uint64_t) value;
+	field->sort_value = sortval;
+	field->report_string = repstr;
+
+	return 1;
+}
+
+int dm_report_field_int32(struct dm_report *rh, struct dm_pool *mem,
+			  struct dm_report_field *field, const void *data)
+{
+	const int32_t value = *(const int32_t *) data;
+	uint64_t *sortval;
+	char *repstr;
+
+	if (!(repstr = dm_pool_zalloc(rh->mem, 13))) {
+		log_error("dm_report_field_int32: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (!(sortval = dm_pool_alloc(rh->mem, sizeof(int64_t)))) {
+		log_error("dm_report_field_int32: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (dm_snprintf(repstr, 12, "%d", value) < 0) {
+		log_error("dm_report_field_int32: int32 too big: %d", value);
+		return 0;
+	}
+
+	*sortval = (const uint64_t) value;
+	field->sort_value = sortval;
+	field->report_string = repstr;
+
+	return 1;
+}
+
+int dm_report_field_int(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data)
+{
+	const int value = *(const int *) data;
+	uint64_t *sortval;
+	char *repstr;
+
+	if (!(repstr = dm_pool_zalloc(rh->mem, 23))) {
+		log_error("dm_report_field_int: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (!(sortval = dm_pool_alloc(rh->mem, sizeof(int64_t)))) {
+		log_error("dm_report_field_int: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (dm_snprintf(repstr, 22, "%d", value) < 0) {
+		log_error("dm_report_field_int: int too big: %d", value);
+		return 0;
+	}
+
+	*sortval = (const uint64_t) value;
+	field->sort_value = sortval;
+	field->report_string = repstr;
+
+	return 1;
+}
+
+int dm_report_field_uint64(struct dm_report *rh, struct dm_pool *mem,
+			   struct dm_report_field *field, const void *data)
+{
+	const int value = *(const uint64_t *) data;
+	uint64_t *sortval;
+	char *repstr;
+
+	if (!(repstr = dm_pool_zalloc(rh->mem, 22))) {
+		log_error("dm_report_field_uint64: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (!(sortval = dm_pool_alloc(rh->mem, sizeof(uint64_t)))) {
+		log_error("dm_report_field_uint64: dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (dm_snprintf(repstr, 21, "%d", value) < 0) {
+		log_error("dm_report_field_uint64: uint64 too big: %d", value);
+		return 0;
+	}
+
+	*sortval = (const uint64_t) value;
+	field->sort_value = sortval;
+	field->report_string = repstr;
+
+	return 1;
+}
+
+/*
+ * Helper functions for custom report functions
+ */
+void dm_report_field_set_string(struct dm_report_field *field,
+				const char *string)
+{
+	field->report_string = string;
+}
+
+void dm_report_field_set_sort_value(struct dm_report_field *field,
+				    const void *value)
+{
+	field->sort_value = value;
+}
+
+int dm_report_field_raw(struct dm_report *rh, struct dm_pool *mem,
+			struct dm_report_field *field, const void *data)
+{
+	field->report_string = (const char *) data;
+	field->sort_value = data;
+	return 1;
+}
+
+/*
+ * comparison operators to set a condition to display row
+ */
+static char _cmp_op_chars[] = "=!><~^";
+
+static struct {
+	const char *string;
+	uint32_t flags;
+} _cmp_op[] = {
+	{ "=", FLD_CMP_EQUAL },
+	{ "!=", FLD_CMP_NOT|FLD_CMP_EQUAL },
+	{ ">", FLD_CMP_GT|FLD_NUMBER },
+	{ ">=", FLD_CMP_GT|FLD_CMP_EQUAL|FLD_NUMBER },
+	{ "<", FLD_CMP_LT|FLD_NUMBER },
+	{ "<=", FLD_CMP_LT|FLD_CMP_EQUAL|FLD_NUMBER },
+	{ "=~", FLD_CMP_SUBSTR|FLD_STRING },
+	{ "!~", FLD_CMP_SUBSTR|FLD_CMP_NOT|FLD_STRING },
+	{ "=~^", FLD_CMP_PREFIX|FLD_STRING },
+	{ "!~^", FLD_CMP_PREFIX|FLD_CMP_NOT|FLD_STRING },
+	{ NULL, 0 }
+};
+
+static int _cmp_op_char(const char c)
+{
+	char *p = _cmp_op_chars;
+
+	while (*p) {
+		if (*p == c)
+			return 1;
+		p++;
+	}
+
+	return 0;
+}
+
+static uint32_t _cmp_op_flags(struct dm_report *rh, const char *s, int len)
+{
+	int i;
+	char *buf;
+
+	for (i = 0; _cmp_op[i].string; i++)
+		if (!strncmp(s, _cmp_op[i].string, len))
+			return _cmp_op[i].flags;
+
+	if (!(buf = dm_pool_zalloc(rh->mem, len + 1))) {
+		log_error("dm_report: log message allocation failed");
+		return 0;
+	}
+	memcpy(buf, s, len);
+	log_error("dm_report: wrong comparison operator %s", buf);
+	dm_pool_free(rh->mem, buf);
+	return 0;
+}
+
+/*
+ * show help message
+ */
+static void _display_operators(void)
+{
+	int i;
+
+	log_print(" ");
+	log_print("Comparison operators");
+
+	for (i = 0; _cmp_op[i].string; i++)
+		log_print("- %s %s%s", _cmp_op[i].string,
+			_cmp_op[i].flags & FLD_NUMBER ? "(number only)" : "",
+			_cmp_op[i].flags & FLD_STRING ? "(string only)" : "");
+}
+
+static void _display_fields(struct dm_report *rh)
+{
+	uint32_t f;
+	const struct dm_report_object_type *type;
+	const char *desc, *last_desc = "";
+
+	for (f = 0; f < rh->num_fields; f++) {
+		if ((type = _find_type(rh, rh->fields[f].type)) && type->desc)
+			desc = type->desc;
+		else
+			desc = " ";
+		if (desc != last_desc) {
+			if (*last_desc)
+				log_print(" ");
+			log_print("%s Fields", desc);
+		}
+
+		log_print("- %s", rh->fields[f].id);
+		last_desc = desc;
+	}
+
+	_display_operators();
+}
+
+/*
+ * Initialise report handle
+ */
+
+static uint32_t _translate_flags(uint32_t flags)
+{
+	/* translate public flags (DM_REPORT_) to internal flags (FLD_) */
+	static uint32_t _map[] = {
+		DM_REPORT_FIELD_ALIGN_LEFT, FLD_ALIGN_LEFT,
+		DM_REPORT_FIELD_ALIGN_RIGHT, FLD_ALIGN_RIGHT,
+		DM_REPORT_FIELD_STRING, FLD_STRING,
+		DM_REPORT_FIELD_NUMBER, FLD_NUMBER,
+		0, 0,
+	};
+	uint32_t f = 0, *m;
+
+	for (m = _map; *m; m += 2)
+		if (flags & *m)
+			f |= *(m + 1);
+
+	return f;
+}
+
+static int _copy_field(struct dm_report *rh, struct field_properties *dest,
+		       uint32_t field_num)
+{
+	dest->field_num = field_num;
+	dest->width = rh->fields[field_num].width;
+	dest->flags = _translate_flags(rh->fields[field_num].flags);
+
+	/* set object type method */
+	dest->type = _find_type(rh, rh->fields[field_num].type);
+	if (!dest->type) {
+		log_error("dm_report: field not match: %s",
+			  rh->fields[field_num].id);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int _field_match(struct dm_report *rh,
+			const char *field, size_t flen,
+			const char *cmp, size_t clen, uint32_t cflags)
+{
+	uint32_t f, l;
+	struct field_properties *fp;
+
+	if (!flen)
+		return 0;
+
+	for (f = 0; f < rh->num_fields; f++) {
+		if ((!strncasecmp(rh->fields[f].id, field, flen) &&
+		     strlen(rh->fields[f].id) == flen) ||
+		    (l = strlen(rh->field_prefix),
+		     !strncasecmp(rh->field_prefix, rh->fields[f].id, l) &&
+		     !strncasecmp(rh->fields[f].id + l, field, flen) &&
+		     strlen(rh->fields[f].id) == l + flen)) {
+			rh->report_types |= rh->fields[f].type;
+			if (!(fp = dm_pool_zalloc(rh->mem, sizeof(*fp)))) {
+				log_error("dm_report: "
+					  "struct field_properties allocation "
+					  "failed");
+				return 0;
+			}
+			if (!_copy_field(rh, fp, f))
+				return 0;
+
+			/* comparison operator */
+			fp->flags |= cflags;
+			if (fp->flags & FLD_NUMBER && fp->flags & FLD_STRING) {
+				log_error("dm_report: operator type conflict");
+				if (cflags & FLD_NUMBER)
+					log_error("for number only");
+				else /* FLD_STRING */
+					log_error("for string only");
+			}
+
+			if (!(fp->cmp = dm_pool_zalloc(rh->mem, clen + 1))) {
+				log_error("dm_report: "
+					  "condition string allocation "
+					  "failed");
+				return 0;
+			}
+			memcpy(fp->cmp, cmp, clen);
+
+			list_add(&rh->field_props, &fp->list);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int _add_sort_key(struct dm_report *rh, uint32_t field_num,
+			 uint32_t flags)
+{
+	struct field_properties *fp, *found = NULL;
+
+	list_iterate_items(fp, &rh->field_props) {
+		if (fp->field_num == field_num) {
+			found = fp;
+			break;
+		}
+	}
+
+	if (!found) {
+		rh->report_types |= rh->fields[field_num].type;
+		if (!(found = dm_pool_zalloc(rh->mem, sizeof(*found)))) {
+			log_error("dm_report: "
+				  "struct field_properties allocation failed");
+			return 0;
+		}
+		if (!_copy_field(rh, found, field_num))
+			return 0;
+
+		/* Add as a non-display field */
+		found->flags |= FLD_HIDDEN;
+
+		list_add(&rh->field_props, &found->list);
+	}
+
+	if (found->flags & FLD_SORT_KEY) {
+		log_error("dm_report: Ignoring duplicate sort field: %s",
+			  rh->fields[field_num].id);
+		return 1;
+	}
+
+	found->flags |= FLD_SORT_KEY;
+	found->sort_posn = rh->keys_count++;
+	found->flags |= flags;
+
+	return 1;
+}
+
+static int _key_match(struct dm_report *rh, const char *key, size_t len)
+{
+	uint32_t f, l;
+	uint32_t flags;
+
+	if (!len)
+		return 0;
+
+	if (*key == '+') {
+		key++;
+		len--;
+		flags = FLD_ASCENDING;
+	} else if (*key == '-') {
+		key++;
+		len--;
+		flags = FLD_DESCENDING;
+	} else
+		flags = FLD_ASCENDING;
+
+	if (!len) {
+		log_error("dm_report: Missing sort field name");
+		return 0;
+	}
+
+	for (f = 0; f < rh->num_fields; f++) {
+		if ((!strncasecmp(rh->fields[f].id, key, len) &&
+		     strlen(rh->fields[f].id) == len) ||
+		    (l = strlen(rh->field_prefix),
+		     !strncasecmp(rh->field_prefix, rh->fields[f].id, l) &&
+		     !strncasecmp(rh->fields[f].id + l, key, len) &&
+		     strlen(rh->fields[f].id) == l + len)) {
+			return _add_sort_key(rh, f, flags);
+		}
+	}
+
+	return 0;
+}
+
+static int _parse_options(struct dm_report *rh, const char *format)
+{
+	const char *ws;		/* Word start */
+	const char *we = format;	/* Word end */
+	const char *cs, *ce;	/* Comparison word start/end */
+	uint32_t flags;
+
+	while (*we) {
+		flags = 0;
+
+		/* Allow consecutive commas */
+		while (*we && *we == ',')
+			we++;
+
+		/* prefix of condition to mark the field hidden */
+		if (*we == '-') {
+			flags |= FLD_HIDDEN;
+			we++;
+		}
+
+		/* start of the field name */
+		ws = we;
+		while (*we && *we != ',' && !_cmp_op_char(*we))
+			we++;
+
+		/* comparison operator and string if any */
+		cs = ce = NULL;
+		if (_cmp_op_char(*we)) {
+			cs = ce = we;
+			while (*ce && *ce != ',' && _cmp_op_char(*ce))
+				ce++;
+			flags |= _cmp_op_flags(rh, cs, ce - cs);
+
+			cs = ce;
+			while (*ce && *ce != ',')
+				ce++;
+		}
+
+		if (!_field_match(rh, ws, (size_t) (we - ws),
+				  cs, (size_t) (ce - cs), flags)) {
+			_display_fields(rh);
+			log_print(" ");
+			log_error("dm_report: Unrecognised field: %.*s",
+				  (int) (we - ws), ws);
+			return 0;
+		}
+
+		if (ce)
+			we = ce;
+	}
+
+	return 1;
+}
+
+static int _parse_keys(struct dm_report *rh, const char *keys)
+{
+	const char *ws;		/* Word start */
+	const char *we = keys;	/* Word end */
+
+	while (*we) {
+		/* Allow consecutive commas */
+		while (*we && *we == ',')
+			we++;
+		ws = we;
+		while (*we && *we != ',')
+			we++;
+		if (!_key_match(rh, ws, (size_t) (we - ws))) {
+			log_error("dm_report: Unrecognised field: %.*s",
+				  (int) (we - ws), ws);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+#define ALIGN_MASK (DM_REPORT_FIELD_ALIGN_LEFT|DM_REPORT_FIELD_ALIGN_RIGHT)
+#define TYPE_MASK (DM_REPORT_FIELD_NUMBER|DM_REPORT_FIELD_STRING)
+
+/*
+ * Check the field/type definition as much as possible
+ * to omit checks in the later stage or avoid unexpected failures
+ */
+static int _check_definition(const struct dm_report_field_type *fds,
+			     int num_fds,
+			     const struct dm_report_object_type *types,
+			     int num_types)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < num_fds; i++) {
+		if (!fds[i].report_fn) {
+			log_error("dm_report: report_fn isn't defined for %s",
+				  fds[i].id);
+			ret = 1;
+		}
+
+		if (!(fds[i].flags & TYPE_MASK)) {
+			log_error("dm_report: field %s type unspecified",
+				  fds[i].id);
+			ret = 1;
+		}
+		if ((fds[i].flags & TYPE_MASK) == TYPE_MASK) {
+			log_error("dm_report: field %s type conflict",
+				  fds[i].id);
+			ret = 1;
+		}
+
+		if (!(fds[i].flags & ALIGN_MASK)) {
+			log_error("dm_report: field %s alignment unspecified",
+				  fds[i].id);
+			ret = 1;
+		}
+		if ((fds[i].flags & ALIGN_MASK) == ALIGN_MASK) {
+			log_error("dm_report: field %s alignment conflict",
+				  fds[i].id);
+			ret = 1;
+		}
+	}
+
+	for (i = 0; i < num_types; i++) {
+		if (hweight32(types[i].id) != 1) {
+			log_error("dm_report: object type %d isn't power of 2",
+				  types[i].id);
+			ret = 1;
+		}
+		if (!types[i].get) {
+			log_error("dm_report: get isn't defined for object "
+				  "type %d", types[i].id);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+struct dm_report *dm_report_init(
+		  const char *format, const char *keys,
+		  uint32_t *report_types,
+		  const char *separator,
+		  int aligned, int buffered, int headings,
+		  const struct dm_report_field_type *fds, int num_fds,
+		  const struct dm_report_object_type *types, int num_types,
+		  void *private)
+{
+	struct dm_report *rh;
+	const struct dm_report_object_type *type;
+
+	if (_check_definition(fds, num_fds, types, num_types))
+		return 0;
+
+	if (!(rh = dm_malloc(sizeof(*rh)))) {
+		log_error("dm_report_init: dm_malloc failed");
+		return 0;
+	}
+	memset(rh, 0, sizeof(*rh));
+
+	/*
+	 * rh->report_types is updated in _parse_options() and _parse_keys()
+	 * to contain all types corresponding to the fields specified by
+	 * options or keys.
+	 */
+	if (report_types)
+		rh->report_types = *report_types;
+
+	rh->separator = separator;
+	rh->fields = fds;
+	rh->num_fields = num_fds;
+	rh->types = types;
+	rh->num_types = num_types;
+	rh->private = private;
+
+	if (aligned)
+		rh->flags |= RH_ALIGNED;
+
+	if (buffered)
+		rh->flags |= RH_BUFFERED | RH_SORT_REQUIRED;
+
+	if (headings)
+		rh->flags |= RH_HEADINGS;
+
+	list_init(&rh->field_props);
+	list_init(&rh->rows);
+
+	if ((type = _find_type(rh, rh->report_types)) && type->prefix)
+		rh->field_prefix = type->prefix;
+	else
+		rh->field_prefix = "";
+
+	if (!(rh->mem = dm_pool_create("report", 10 * 1024))) {
+		log_error("dm_report_init: allocation of memory pool failed");
+		return NULL;
+	}
+
+	/* Generate list of fields for output based on format string & flags */
+	if (!_parse_options(rh, format))
+		return NULL;
+
+	if (!_parse_keys(rh, keys))
+		return NULL;
+
+	/* Return updated types value for further compatility check by caller */
+	if (report_types)
+		*report_types = rh->report_types;
+
+	return rh;
+}
+
+void dm_report_free(struct dm_report *rh)
+{
+	dm_pool_destroy(rh->mem);
+
+	return;
+}
+
+/*
+ * Create a row of data for an object
+ */
+static int _compare_field_number(uint64_t a, uint64_t b, uint32_t flags)
+{
+	switch (flags & FLD_CMP_MASK) {
+	case FLD_CMP_EQUAL:
+		return a == b;
+	case FLD_CMP_NOT|FLD_CMP_EQUAL:
+		return a != b;
+	case FLD_CMP_GT:
+		return a > b;
+	case FLD_CMP_GT|FLD_CMP_EQUAL:
+		return a >= b;
+	case FLD_CMP_LT:
+		return a < b;
+	case FLD_CMP_LT|FLD_CMP_EQUAL:
+		return a <= b;
+	}
+	return 0;
+}
+
+static int _compare_field_string(const char *a, const char *b, uint32_t flags)
+{
+	switch (flags & FLD_CMP_MASK) {
+	case FLD_CMP_EQUAL:
+		return !strcmp(a, b);
+	case FLD_CMP_NOT|FLD_CMP_EQUAL:
+		return strcmp(a, b);
+	case FLD_CMP_PREFIX:
+		return !strncmp(b, a, strlen(b));
+	case FLD_CMP_PREFIX|FLD_CMP_NOT:
+		return strncmp(b, a, strlen(b));
+	case FLD_CMP_SUBSTR:
+		return strstr(a, b) != NULL;
+	case FLD_CMP_SUBSTR|FLD_CMP_NOT:
+		return strstr(a, b) == NULL;
+	}
+	return 0;
+}
+
+static int _compare_field(struct dm_report_field *field,
+			  struct field_properties *fp)
+{
+	if (!field->sort_value) {
+		log_error("dm_report: field without value: %d",
+			  field->props->field_num);
+		return 0;
+	}
+
+	if (field->props->flags & FLD_NUMBER) {
+		const uint64_t numa = *(const uint64_t *)field->sort_value;
+		const uint64_t numb = strtoul(fp->cmp, NULL, 0);
+		return _compare_field_number(numa, numb, fp->flags);
+	} else {	/* FLD_STRING */
+		const char *stra = (const char *) field->sort_value;
+		const char *strb = fp->cmp;
+		return _compare_field_string(stra, strb, fp->flags);
+	}
+}
+
+static void * _report_get_field_data(struct dm_report *rh,
+			      struct field_properties *fp, void *object)
+{
+	void *ret = fp->type->get(object);
+
+	if (!ret)
+		return NULL;
+
+	return ret + rh->fields[fp->field_num].offset;
+}
+
+int dm_report_object(struct dm_report *rh, void *object)
+{
+	struct field_properties *fp;
+	struct row *row;
+	struct dm_report_field *field;
+	void *data = NULL;
+
+	if (!(row = dm_pool_zalloc(rh->mem, sizeof(*row)))) {
+		log_error("dm_report_object: struct row allocation failed");
+		return 0;
+	}
+
+	row->rh = rh;
+
+	if ((rh->flags & RH_SORT_REQUIRED) &&
+	    !(row->sort_fields =
+		dm_pool_zalloc(rh->mem, sizeof(struct dm_report_field *) *
+			       rh->keys_count))) {
+		log_error("dm_report_object: "
+			  "row sort value structure allocation failed");
+		return 0;
+	}
+
+	list_init(&row->fields);
+	list_add(&rh->rows, &row->list);
+
+	/* For each field to be displayed, call its report_fn */
+	list_iterate_items(fp, &rh->field_props) {
+		if (!(field = dm_pool_zalloc(rh->mem, sizeof(*field)))) {
+			log_error("dm_report_object: "
+				  "struct dm_report_field allocation failed");
+			return 0;
+		}
+		field->props = fp;
+
+		data = _report_get_field_data(rh, fp, object);
+		if (!data)
+			return 0;
+
+		if (!rh->fields[fp->field_num].report_fn(rh, rh->mem,
+							 field, data)) {
+			log_error("dm_report_object: "
+				  "report function failed for field %s",
+				  rh->fields[fp->field_num].id);
+			return 0;
+		}
+
+		if ((fp->flags & FLD_CMP_MASK) && !_compare_field(field, fp)) {
+			list_del(&row->list);
+			return 0;
+		}
+
+		if ((strlen(field->report_string) > field->props->width))
+			field->props->width = strlen(field->report_string);
+
+		if ((rh->flags & RH_SORT_REQUIRED) &&
+		    (field->props->flags & FLD_SORT_KEY)) {
+			(*row->sort_fields)[field->props->sort_posn] = field;
+		}
+		list_add(&row->fields, &field->list);
+	}
+
+	if (!(rh->flags & RH_BUFFERED))
+		return dm_report_output(rh);
+
+	return 1;
+}
+
+/*
+ * Print row of headings
+ */
+static int _report_headings(void *handle)
+{
+	struct dm_report *rh = handle;
+	struct field_properties *fp;
+	const char *heading;
+	char buf[1024];
+
+	if (rh->flags & RH_HEADINGS_PRINTED)
+		return 1;
+
+	rh->flags |= RH_HEADINGS_PRINTED;
+
+	if (!(rh->flags & RH_HEADINGS))
+		return 1;
+
+	if (!dm_pool_begin_object(rh->mem, 128)) {
+		log_error("dm_report: "
+			  "dm_pool_begin_object failed for headings");
+		return 0;
+	}
+
+	/* First heading line */
+	list_iterate_items(fp, &rh->field_props) {
+		if (fp->flags & FLD_HIDDEN)
+			continue;
+
+		heading = rh->fields[fp->field_num].heading;
+		if (rh->flags & RH_ALIGNED) {
+			if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
+					 fp->width, fp->width, heading) < 0)
+				goto bad_snprintf;
+			if (!dm_pool_grow_object(rh->mem, buf, fp->width))
+				goto bad_grow;
+		} else if (!dm_pool_grow_object(rh->mem, heading,
+						strlen(heading)))
+			goto bad_grow;
+
+		if (!list_end(&rh->field_props, &fp->list))
+			if (!dm_pool_grow_object(rh->mem, rh->separator,
+					      strlen(rh->separator)))
+				goto bad_grow;
+	}
+	if (!dm_pool_grow_object(rh->mem, "\0", 1))
+		goto bad_grow;
+	log_print("%s", (char *) dm_pool_end_object(rh->mem));
+
+	return 1;
+
+      bad_snprintf:
+	log_error("dm_report: snprintf heading failed");
+      bad_grow:
+	log_error("dm_report: Failed to generate report headings for printing");
+	dm_pool_abandon_object(rh->mem);
+	return 0;
+}
+
+/*
+ * Sort rows of data
+ */
+static int _row_compare(const void *a, const void *b)
+{
+	const struct row *rowa = *(const struct row **) a;
+	const struct row *rowb = *(const struct row **) b;
+	const struct dm_report_field *sfa, *sfb;
+	int32_t cnt = -1;
+
+	for (cnt = 0; cnt < rowa->rh->keys_count; cnt++) {
+		sfa = (*rowa->sort_fields)[cnt];
+		sfb = (*rowb->sort_fields)[cnt];
+		if (sfa->props->flags & FLD_NUMBER) {
+			const uint64_t numa =
+			    *(const uint64_t *) sfa->sort_value;
+			const uint64_t numb =
+			    *(const uint64_t *) sfb->sort_value;
+
+			if (numa == numb)
+				continue;
+
+			if (sfa->props->flags & FLD_ASCENDING) {
+				return (numa > numb) ? 1 : -1;
+			} else {	/* FLD_DESCENDING */
+				return (numa < numb) ? 1 : -1;
+			}
+		} else {	/* FLD_STRING */
+			const char *stra = (const char *) sfa->sort_value;
+			const char *strb = (const char *) sfb->sort_value;
+			int cmp = strcmp(stra, strb);
+
+			if (!cmp)
+				continue;
+
+			if (sfa->props->flags & FLD_ASCENDING) {
+				return (cmp > 0) ? 1 : -1;
+			} else {	/* FLD_DESCENDING */
+				return (cmp < 0) ? 1 : -1;
+			}
+		}
+	}
+
+	return 0;		/* Identical */
+}
+
+static int _sort_rows(struct dm_report *rh)
+{
+	struct row *(*rows)[];
+	uint32_t count = 0;
+	struct row *row;
+
+	if (!(rows = dm_pool_alloc(rh->mem, sizeof(**rows) *
+				list_size(&rh->rows)))) {
+		log_error("dm_report: sort array allocation failed");
+		return 0;
+	}
+
+	list_iterate_items(row, &rh->rows)
+		(*rows)[count++] = row;
+
+	qsort(rows, count, sizeof(**rows), _row_compare);
+
+	list_init(&rh->rows);
+	while (count--)
+		list_add_h(&rh->rows, &(*rows)[count]->list);
+
+	return 1;
+}
+
+/*
+ * Produce report output
+ */
+int dm_report_output(struct dm_report *rh)
+{
+	struct list *fh, *rowh, *ftmp, *rtmp;
+	struct row *row = NULL;
+	struct dm_report_field *field;
+	const char *repstr;
+	char buf[4096];
+	int width;
+
+	if (list_empty(&rh->rows))
+		return 1;
+
+	/* Sort rows */
+	if ((rh->flags & RH_SORT_REQUIRED))
+		_sort_rows(rh);
+
+	/* If headings not printed yet, calculate field widths and print them */
+	if (!(rh->flags & RH_HEADINGS_PRINTED))
+		_report_headings(rh);
+
+	/* Print and clear buffer */
+	list_iterate_safe(rowh, rtmp, &rh->rows) {
+		if (!dm_pool_begin_object(rh->mem, 512)) {
+			log_error("dm_report: "
+				  "dm_pool_begin_object failed for row");
+			return 0;
+		}
+		row = list_item(rowh, struct row);
+		list_iterate_safe(fh, ftmp, &row->fields) {
+			field = list_item(fh, struct dm_report_field);
+			if (field->props->flags & FLD_HIDDEN)
+				continue;
+
+			repstr = field->report_string;
+			width = field->props->width;
+			if (!(rh->flags & RH_ALIGNED)) {
+				if (!dm_pool_grow_object(rh->mem, repstr,
+						      strlen(repstr)))
+					goto bad_grow;
+			} else if (field->props->flags & FLD_ALIGN_LEFT) {
+				if (dm_snprintf(buf, sizeof(buf), "%-*.*s",
+						 width, width, repstr) < 0)
+					goto bad_snprintf;
+				if (!dm_pool_grow_object(rh->mem, buf, width))
+					goto bad_grow;
+			} else if (field->props->flags & FLD_ALIGN_RIGHT) {
+				if (dm_snprintf(buf, sizeof(buf), "%*.*s",
+						 width, width, repstr) < 0)
+					goto bad_snprintf;
+				if (!dm_pool_grow_object(rh->mem, buf, width))
+					goto bad_grow;
+			}
+
+			if (!list_end(&row->fields, fh))
+				if (!dm_pool_grow_object(rh->mem, rh->separator,
+						      strlen(rh->separator)))
+					goto bad_grow;
+			list_del(&field->list);
+		}
+		if (!dm_pool_grow_object(rh->mem, "\0", 1))
+			goto bad_grow;
+		log_print("%s", (char *) dm_pool_end_object(rh->mem));
+		list_del(&row->list);
+	}
+
+	if (row)
+		dm_pool_free(rh->mem, row);
+
+	return 1;
+
+      bad_snprintf:
+	log_error("dm_report: snprintf row failed");
+      bad_grow:
+	log_error("dm_report: Failed to generate row for printing");
+	dm_pool_abandon_object(rh->mem);
+	return 0;
+}
Index: device-mapper/lib/Makefile.in
===================================================================
--- device-mapper.orig/lib/Makefile.in	2007-01-12 15:21:52.000000000 -0500
+++ device-mapper/lib/Makefile.in	2007-01-12 15:36:55.000000000 -0500
@@ -24,6 +24,7 @@ SOURCES =\
 	libdm-file.c \
 	libdm-deptree.c \
 	libdm-string.c \
+	libdm-report.c \
 	mm/dbg_malloc.c \
 	mm/pool.c \
 	$(interface)/libdm-iface.c
Index: device-mapper/lib/.exported_symbols
===================================================================
--- device-mapper.orig/lib/.exported_symbols	2007-01-12 15:21:52.000000000 -0500
+++ device-mapper/lib/.exported_symbols	2007-01-12 15:36:55.000000000 -0500
@@ -115,3 +115,16 @@ dm_split_lvm_name
 dm_split_words
 dm_snprintf
 dm_basename
+dm_report_init
+dm_report_object
+dm_report_output
+dm_report_free
+dm_report_get_private
+dm_report_field_string
+dm_report_field_int32
+dm_report_field_uint32
+dm_report_field_int
+dm_report_field_uint64
+dm_report_field_raw
+dm_report_field_set_string
+dm_report_field_set_sort_value

--------------030400030806090203080609
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030400030806090203080609--
