From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (1/6) Tidy up _field_match() and
	_key_match()
Date: Wed, 18 Apr 2007 12:47:28 -0400
Message-ID: <46264BA0.5090502@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040708070406010309050704"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040708070406010309050704
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch cleans up _field_match() and _key_match() by separating
common operations out.

No effect on functionality.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------040708070406010309050704
Content-Type: text/x-patch;
 name="libdm-report-tidy-add_field.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libdm-report-tidy-add_field.patch"

Tidy up _field_match() and _key_match()

* Add _add_field() function for flag setting, alloc, copy, and list_add of
   struct field_properties
* Add _is_same_field() for lengthy test to check field name
  abbreviation

---
 lib/libdm-report.c |  101 +++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 45 deletions(-)

Index: device-mapper.work/lib/libdm-report.c
===================================================================
--- device-mapper.work.orig/lib/libdm-report.c
+++ device-mapper.work/lib/libdm-report.c
@@ -296,35 +296,62 @@ static int _copy_field(struct dm_report 
 	return 1;
 }
 
-static int _field_match(struct dm_report *rh, const char *field, size_t flen)
+static struct field_properties * _add_field(struct dm_report *rh,
+					    uint32_t field_num, uint32_t flags)
 {
-	uint32_t f, l;
 	struct field_properties *fp;
 
+	rh->report_types |= rh->fields[field_num].type;
+	if (!(fp = dm_pool_zalloc(rh->mem, sizeof(struct field_properties)))) {
+		log_error("dm_report: "
+			  "struct field_properties allocation failed");
+		return NULL;
+	}
+	if (!_copy_field(rh, fp, field_num)) {
+		dm_pool_free(rh->mem, fp);
+		return NULL;
+	}
+
+	/* Add additional flags */
+	fp->flags |= flags;
+
+	list_add(&rh->field_props, &fp->list);
+	return fp;
+}
+
+/*
+ * compare name1 and name2 (or prefix+name2)
+ *   name2 is not \0 terminated. len is the length of name2.
+ */
+static int _is_same_field(const char *name1, const char *name2,
+                         size_t len, const char *prefix)
+{
+	size_t l;
+
+	/* name1 == name2 */
+	if (!strncasecmp(name1, name2, len) && strlen(name1) == len)
+		return 1;
+
+	/* name1 == name2 */
+	l = strlen(prefix);
+	if (!strncasecmp(prefix, name1, l) &&
+	    !strncasecmp(name1 + l, name2, len) && strlen(name1) == l + len)
+		return 1;
+
+	return 0;
+}
+
+static int _field_match(struct dm_report *rh, const char *field, size_t flen)
+{
+	uint32_t f;
+
 	if (!flen)
 		return 0;
 
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
-
-			list_add(&rh->field_props, &fp->list);
-			return 1;
-		}
-	}
+	for (f = 0; rh->fields[f].report_fn; f++)
+		if (_is_same_field(rh->fields[f].id,
+				   field, flen, rh->field_prefix))
+			return (_add_field(rh, f, 0) != NULL);
 
 	return 0;
 }
@@ -342,19 +369,9 @@ static int _add_sort_key(struct dm_repor
 	}
 
 	if (!found) {
-		rh->report_types |= rh->fields[field_num].type;
-		if (!(found = dm_pool_zalloc(rh->mem, sizeof(*found)))) {
-			log_error("dm_report: "
-				  "struct field_properties allocation failed");
-			return 0;
-		}
-		if (!_copy_field(rh, found, field_num))
-			return 0;
-
 		/* Add as a non-display field */
-		found->flags |= FLD_HIDDEN;
-
-		list_add(&rh->field_props, &found->list);
+		if (!(found = _add_field(rh, field_num, FLD_HIDDEN)))
+			return 0;
 	}
 
 	if (found->flags & FLD_SORT_KEY) {
@@ -372,7 +389,7 @@ static int _add_sort_key(struct dm_repor
 
 static int _key_match(struct dm_report *rh, const char *key, size_t len)
 {
-	uint32_t f, l;
+	uint32_t f;
 	uint32_t flags;
 
 	if (!len)
@@ -394,16 +411,10 @@ static int _key_match(struct dm_report *
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
+		if (_is_same_field(rh->fields[f].id,
+				   key, len, rh->field_prefix))
 			return _add_sort_key(rh, f, flags);
-		}
-	}
 
 	return 0;
 }

--------------040708070406010309050704
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040708070406010309050704--
