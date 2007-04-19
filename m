From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-report.c
Date: 19 Apr 2007 20:24:01 -0000
Message-ID: <20070419202401.29622.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-04-19 21:24:00

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-report.c 

Log message:
	Introduce _add_field() and _is_same_field() to libdm-report.c.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.174&r2=1.175
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.12&r2=1.13

--- device-mapper/WHATS_NEW	2007/04/19 19:10:19	1.174
+++ device-mapper/WHATS_NEW	2007/04/19 20:24:00	1.175
@@ -1,6 +1,7 @@
 Version 1.02.19 -
 ====================================
-  Fix libdevmapper-event memory leaks
+  Introduce _add_field() and _is_same_field() to libdm-report.c.
+  Fix some libdevmapper-event memory leaks.
   Remove unnecessary memset() return value checks.
   Fix a few leaks in reporting error paths. [1.02.15+]
 
--- device-mapper/lib/libdm-report.c	2007/02/14 15:12:16	1.12
+++ device-mapper/lib/libdm-report.c	2007/04/19 20:24:00	1.13
@@ -296,36 +296,67 @@
 	return 1;
 }
 
-static int _field_match(struct dm_report *rh, const char *field, size_t flen)
+static struct field_properties * _add_field(struct dm_report *rh,
+					    uint32_t field_num, uint32_t flags)
 {
-	uint32_t f, l;
 	struct field_properties *fp;
 
-	if (!flen)
-		return 0;
+	rh->report_types |= rh->fields[field_num].type;
 
-	for (f = 0; rh->fields[f].report_fn; f++) {
-		if ((!strncasecmp(rh->fields[f].id, field, flen) &&
-		     strlen(rh->fields[f].id) == flen) ||
-		    (l = strlen(rh->field_prefix),
-		     !strncasecmp(rh->field_prefix, rh->fields[f].id, l) &&
-		     !strncasecmp(rh->fields[f].id + l, field, flen) &&
-		     strlen(rh->fields[f].id) == l + flen)) {
-			rh->report_types |= rh->fields[f].type;
-			if (!(fp = dm_pool_zalloc(rh->mem, sizeof(*fp)))) {
-				log_error("dm_report: "
-					  "struct field_properties allocation "
-					  "failed");
-				return 0;
-			}
-			if (!_copy_field(rh, fp, f))
-				return 0;
+	if (!(fp = dm_pool_zalloc(rh->mem, sizeof(struct field_properties)))) {
+		log_error("dm_report: struct field_properties allocation "
+			  "failed");
+		return NULL;
+	}
 
-			list_add(&rh->field_props, &fp->list);
-			return 1;
-		}
+	if (!_copy_field(rh, fp, field_num)) {
+		stack;
+		dm_pool_free(rh->mem, fp);
+		return NULL;
 	}
 
+	fp->flags |= flags;
+	list_add(&rh->field_props, &fp->list);
+
+	return fp;
+}
+
+/*
+ * Compare name1 against name2 or prefix plus name2
+ * name2 is not necessarily null-terminated.
+ * len2 is the length of name2.
+ */
+static int _is_same_field(const char *name1, const char *name2,
+			  size_t len2, const char *prefix)
+{
+	size_t prefix_len;
+
+	/* Exact match? */
+	if (!strncasecmp(name1, name2, len2) && strlen(name1) == len2)
+		return 1;
+
+	/* Match including prefix? */
+	prefix_len = strlen(prefix);
+	if (!strncasecmp(prefix, name1, prefix_len) &&
+	    !strncasecmp(name1 + prefix_len, name2, len2) &&
+	    strlen(name1) == prefix_len + len2)
+		return 1;
+
+	return 0;
+}
+
+static int _field_match(struct dm_report *rh, const char *field, size_t flen)
+{
+	uint32_t f;
+
+	if (!flen)
+		return 0;
+
+	for (f = 0; rh->fields[f].report_fn; f++)
+		if (_is_same_field(rh->fields[f].id, field, flen,
+				   rh->field_prefix))
+			return _add_field(rh, f, 0) ? 1 : 0;
+
 	return 0;
 }
 
@@ -341,21 +372,8 @@
 		}
 	}
 
-	if (!found) {
-		rh->report_types |= rh->fields[field_num].type;
-		if (!(found = dm_pool_zalloc(rh->mem, sizeof(*found)))) {
-			log_error("dm_report: "
-				  "struct field_properties allocation failed");
-			return 0;
-		}
-		if (!_copy_field(rh, found, field_num))
-			return 0;
-
-		/* Add as a non-display field */
-		found->flags |= FLD_HIDDEN;
-
-		list_add(&rh->field_props, &found->list);
-	}
+	if (!found && !(found = _add_field(rh, field_num, FLD_HIDDEN)))
+		return_0;
 
 	if (found->flags & FLD_SORT_KEY) {
 		log_error("dm_report: Ignoring duplicate sort field: %s",
@@ -372,7 +390,7 @@
 
 static int _key_match(struct dm_report *rh, const char *key, size_t len)
 {
-	uint32_t f, l;
+	uint32_t f;
 	uint32_t flags;
 
 	if (!len)
@@ -394,16 +412,10 @@
 		return 0;
 	}
 
-	for (f = 0; rh->fields[f].report_fn; f++) {
-		if ((!strncasecmp(rh->fields[f].id, key, len) &&
-		     strlen(rh->fields[f].id) == len) ||
-		    (l = strlen(rh->field_prefix),
-		     !strncasecmp(rh->field_prefix, rh->fields[f].id, l) &&
-		     !strncasecmp(rh->fields[f].id + l, key, len) &&
-		     strlen(rh->fields[f].id) == l + len)) {
+	for (f = 0; rh->fields[f].report_fn; f++)
+		if (_is_same_field(rh->fields[f].id, key, len,
+				   rh->field_prefix))
 			return _add_sort_key(rh, f, flags);
-		}
-	}
 
 	return 0;
 }
