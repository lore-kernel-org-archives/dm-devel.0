From: agk@sourceware.org
Subject: device-mapper/lib libdm-report.c
Date: 25 Jun 2008 00:10:36 -0000
Message-ID: <20080625001036.2219.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-25 00:10:36

Modified files:
	lib            : libdm-report.c 

Log message:
	Cope with missing field values.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.21&r2=1.22

--- device-mapper/lib/libdm-report.c	2008/06/24 22:53:48	1.21
+++ device-mapper/lib/libdm-report.c	2008/06/25 00:10:36	1.22
@@ -895,8 +895,13 @@
 	}
 
 	list_iterate_items(fp, &rh->field_props) {
-		if (fp->flags & FLD_HIDDEN)
+		if (fp->flags & FLD_HIDDEN) {
+			list_iterate_items(row, &rh->rows) {
+				field = list_item(list_first(&row->fields), struct dm_report_field);
+				list_del(&field->list);
+			}
 			continue;
+		}
 
 		if ((rh->flags & DM_REPORT_OUTPUT_HEADINGS)) {
 			if (!dm_pool_grow_object(rh->mem, rh->fields[fp->field_num].heading, 0)) {
@@ -910,10 +915,11 @@
 		}
 
 		list_iterate_items(row, &rh->rows) {
-			field = list_item(list_first(&row->fields), struct dm_report_field);
-			if (!_output_field(rh, field))
-				goto bad;
-			list_del(&field->list);
+			if ((field = list_item(list_first(&row->fields), struct dm_report_field))) {
+				if (!_output_field(rh, field))
+					goto bad;
+				list_del(&field->list);
+			}
 
 			if (!list_end(&rh->rows, &row->list))
 				if (!dm_pool_grow_object(rh->mem, rh->separator, 0)) {
