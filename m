From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] (3/4) Remove old codes for "info -c" from dmsetup
Date: Fri, 12 Jan 2007 18:31:58 -0500
Message-ID: <45A81A6E.9070309@ce.jp.nec.com>
References: <45A81618.2080608@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070100030007090400020209"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45A81618.2080608@ce.jp.nec.com>
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
--------------070100030007090400020209
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch removes _display_info_cols*() functions used
for "dmsetup info -c" implementation.
These can be replaced by the new code using dm_report.

Thanks,
--
Jun'ichi Nomura, NEC Corporation of America

--------------070100030007090400020209
Content-Type: text/x-patch;
 name="03-dmsetup-remove-old-info-cols.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-dmsetup-remove-old-info-cols.patch"

Replace old _display_info_cols{_noheadings} by _report()

Slight incompatibility is introduced:
  Output of verbose + column is changed.
  e.g. dmsetup table -v -c

    # dmsetup.old table -c -v
    Name             Maj Min Stat Open Targ Event  UUID
    d4               254   6 L--w    0    1      0 
    0 409600 linear 7:0 1638400

    d3               254   5 L--w    0    1      0 
    0 409600 linear 7:0 1228800
    ...

    # dmsetup.new table -c -v
    Name             Maj Min Stat Open Targ Event  UUID
    d4               254   6 L--w    0    1      0
    0 409600 linear 7:0 1638400

    Name             Maj Min Stat Open Targ Event  UUID
    d3               254   5 L--w    0    1      0
    0 409600 linear 7:0 1228800
    ...

  Field head used to be displayed only once but now it's displayed
  for every tables.
Index: device-mapper/dmsetup/dmsetup.c
===================================================================
--- device-mapper.orig/dmsetup/dmsetup.c	2007-01-12 16:54:45.000000000 -0500
+++ device-mapper/dmsetup/dmsetup.c	2007-01-12 16:55:14.000000000 -0500
@@ -225,68 +225,6 @@ static int _parse_file(struct dm_task *d
 	return r;
 }
 
-static void _display_info_cols_noheadings(struct dm_task *dmt,
-					  struct dm_info *info)
-{
-	const char *uuid;
-
-	if (!info->exists)
-		return;
-
-	uuid = dm_task_get_uuid(dmt);
-
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else
-		printf("%s:%d:%d:%s%s%s%s:%d:%d:%" PRIu32 ":%s\n",
-		       dm_task_get_name(dmt),
-		       info->major, info->minor,
-		       info->live_table ? "L" : "-",
-		       info->inactive_table ? "I" : "-",
-		       info->suspended ? "s" : "-",
-		       info->read_only ? "r" : "w",
-		       info->open_count, info->target_count, info->event_nr,
-		       uuid && *uuid ? uuid : "");
-}
-
-static void _display_info_cols(struct dm_task *dmt, struct dm_info *info)
-{
-	static int _headings = 0;
-	const char *uuid;
-
-	if (!info->exists) {
-		printf("Device does not exist.\n");
-		return;
-	}
-
-	if (!_headings) {
-		if (_switches[OPTIONS_ARG])
-			printf("Name\n");
-		else
-			printf("Name             Maj Min Stat Open Targ "
-			       "Event  UUID\n");
-		_headings = 1;
-	}
-
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else {
-		printf("%-16s %3d %3d %s%s%s%s %4d %4d %6" PRIu32 " ",
-		       dm_task_get_name(dmt),
-		       info->major, info->minor,
-		       info->live_table ? "L" : "-",
-		       info->inactive_table ? "I" : "-",
-		       info->suspended ? "s" : "-",
-		       info->read_only ? "r" : "w",
-		       info->open_count, info->target_count, info->event_nr);
-
-		if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
-			printf("%s", uuid);
-
-		printf("\n");
-	}
-}
-
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
 {
 	const char *uuid;
@@ -336,10 +274,8 @@ static int _display_info(struct dm_task 
 
 	if (!_switches[COLS_ARG])
 		_display_info_long(dmt, &info);
-	else if (_switches[NOHEADINGS_ARG])
-		_display_info_cols_noheadings(dmt, &info);
 	else
-		_display_info_cols(dmt, &info);
+		_report(0, NULL, dmt);
 
 	return info.exists ? 1 : 0;
 }

--------------070100030007090400020209
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070100030007090400020209--
