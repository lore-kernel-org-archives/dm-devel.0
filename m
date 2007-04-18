From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (7/6) Add
	dm_report_get_report_types()
Date: Wed, 18 Apr 2007 15:23:00 -0400
Message-ID: <46267014.9050100@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080909040106000109040603"
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
--------------080909040106000109040603
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch was missing from the last post...

Since rh->report_types can be updated after dm_report_init(),
we need an interface to obtain it later.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------080909040106000109040603
Content-Type: text/x-patch;
 name="libdm-report-get-types.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libdm-report-get-types.patch"

Add dm_report_get_report_types() to obtain updated report_types field
after dm_report_set_filter() call.

---
 dmsetup/dmsetup.c     |    1 +
 lib/.exported_symbols |    1 +
 lib/libdevmapper.h    |    1 +
 lib/libdm-report.c    |    5 +++++
 4 files changed, 8 insertions(+)

Index: device-mapper.work/lib/.exported_symbols
===================================================================
--- device-mapper.work.orig/lib/.exported_symbols
+++ device-mapper.work/lib/.exported_symbols
@@ -128,5 +128,6 @@ dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
 dm_report_set_filter
+dm_report_get_report_types
 dm_regex_create
 dm_regex_match
Index: device-mapper.work/lib/libdm-report.c
===================================================================
--- device-mapper.work.orig/lib/libdm-report.c
+++ device-mapper.work/lib/libdm-report.c
@@ -88,6 +88,11 @@ struct row {
 	struct dm_report_field *(*sort_fields)[]; /* Fields in sort order */
 };
 
+uint32_t dm_report_get_report_types(struct dm_report *rh)
+{
+	return rh->report_types;
+}
+
 static const struct dm_report_object_type *_find_type(struct dm_report *rh,
 						      uint32_t report_type)
 {
Index: device-mapper.work/lib/libdevmapper.h
===================================================================
--- device-mapper.work.orig/lib/libdevmapper.h
+++ device-mapper.work/lib/libdevmapper.h
@@ -687,6 +687,7 @@ struct dm_report *dm_report_init(uint32_
 int dm_report_object(struct dm_report *rh, void *object);
 int dm_report_output(struct dm_report *rh);
 void dm_report_free(struct dm_report *rh);
+uint32_t dm_report_get_report_types(struct dm_report *rh);
 
 /* Set filter */
 int dm_report_set_filter(struct dm_report *rh,
Index: device-mapper.work/dmsetup/dmsetup.c
===================================================================
--- device-mapper.work.orig/dmsetup/dmsetup.c
+++ device-mapper.work/dmsetup/dmsetup.c
@@ -1924,6 +1924,7 @@ static int _report_init(struct command *
 		goto out;
 	}
 
+	report_type = dm_report_get_report_types(_report);
 	r = 1;
 
 out:

--------------080909040106000109040603
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080909040106000109040603--
