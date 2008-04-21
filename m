From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 21 Apr 2008 13:16:31 -0000
Message-ID: <20080421131631.5375.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-04-21 13:16:31

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Add 3 new reporting colums: tables_loaded, readonly, suspended.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.230&r2=1.231
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.105&r2=1.106

--- device-mapper/WHATS_NEW	2008/04/21 11:59:22	1.230
+++ device-mapper/WHATS_NEW	2008/04/21 13:16:30	1.231
@@ -1,5 +1,6 @@
 Version 1.02.26 - 
 =================================
+  Add tables_loaded, readonly and suspended columns to reports.
   Add --prefixes to dmsetup.
   Add field name prefix option to reporting functions.
   Calculate string size within dm_pool_grow_object.
--- device-mapper/dmsetup/dmsetup.c	2008/04/21 11:59:22	1.105
+++ device-mapper/dmsetup/dmsetup.c	2008/04/21 13:16:30	1.106
@@ -1643,6 +1643,63 @@
 	return dm_report_field_string(rh, field, &s);
 }
 
+static int _dm_info_table_loaded_disp(struct dm_report *rh,
+				      struct dm_pool *mem __attribute((unused)),
+				      struct dm_report_field *field,
+				      const void *data,
+				      void *private __attribute((unused)))
+{
+	const struct dm_info *info = data;
+
+	if (info->live_table) {
+		if (info->inactive_table)
+			dm_report_field_set_value(field, "Both", NULL);
+		else
+			dm_report_field_set_value(field, "Live", NULL);
+		return 1;
+	}
+
+	if (info->inactive_table)
+		dm_report_field_set_value(field, "Inactive", NULL);
+	else
+		dm_report_field_set_value(field, "None", NULL);
+
+	return 1;
+}
+
+static int _dm_info_suspended_disp(struct dm_report *rh,
+				   struct dm_pool *mem __attribute((unused)),
+				   struct dm_report_field *field,
+				   const void *data,
+				   void *private __attribute((unused)))
+{
+	const struct dm_info *info = data;
+
+	if (info->suspended)
+		dm_report_field_set_value(field, "Suspended", NULL);
+	else
+		dm_report_field_set_value(field, "", NULL);
+
+	return 1;
+}
+
+static int _dm_info_read_only_disp(struct dm_report *rh,
+				   struct dm_pool *mem __attribute((unused)),
+				   struct dm_report_field *field,
+				   const void *data,
+				   void *private __attribute((unused)))
+{
+	const struct dm_info *info = data;
+
+	if (info->read_only)
+		dm_report_field_set_value(field, "Read-only", NULL);
+	else
+		dm_report_field_set_value(field, "Writeable", NULL);
+
+	return 1;
+}
+
+
 static int _dm_info_devno_disp(struct dm_report *rh, struct dm_pool *mem,
 			       struct dm_report_field *field, const void *data,
 			       void *private)
@@ -1885,6 +1942,9 @@
 FIELD_F(TASK, NUM, "RAhead", 6, dm_read_ahead, "read_ahead", "Read ahead in sectors.")
 
 FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
+FIELD_F(INFO, STR, "Tables", 6, dm_info_table_loaded, "tables_loaded", "Which of the live and inactive table slots are filled.")
+FIELD_F(INFO, STR, "Suspended", 9, dm_info_suspended, "suspended", "Whether the device is suspended.")
+FIELD_F(INFO, STR, "Read-only", 9, dm_info_read_only, "readonly", "Whether the device is read-only or writeable.")
 FIELD_F(INFO, STR, "DevNo", 5, dm_info_devno, "devno", "Device major and minor numbers")
 FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
 FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Block device minor number.")
