From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h l ...
Date: 23 Jan 2007 19:18:53 -0000
Message-ID: <20070123191853.18979.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-23 19:18:52

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h libdm-report.c 

Log message:
	Add descriptions to reporting field definitions.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.157&r2=1.158
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.66&r2=1.67
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- device-mapper/WHATS_NEW	2007/01/23 17:38:38	1.157
+++ device-mapper/WHATS_NEW	2007/01/23 19:18:52	1.158
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Add descriptions to reporting field definitions.
   Add a dso-private variable to dmeventd dso interface.
   Add dm_event_handler_[gs]et_timeout functions.
   Streamline dm_report_field_* interface.
--- device-mapper/lib/libdevmapper.h	2007/01/22 15:03:57	1.66
+++ device-mapper/lib/libdevmapper.h	2007/01/23 19:18:52	1.67
@@ -665,6 +665,7 @@
 	int (*report_fn)(struct dm_report *rh, struct dm_pool *mem,
 			 struct dm_report_field *field, const void *data,
 			 void *private);
+	const char *desc;	/* description of the field */
 };
 
 /*
--- device-mapper/lib/libdm-report.c	2007/01/23 17:38:39	1.7
+++ device-mapper/lib/libdm-report.c	2007/01/23 19:18:52	1.8
@@ -248,6 +248,11 @@
 	uint32_t f;
 	const struct dm_report_object_type *type;
 	const char *desc, *last_desc = "";
+	size_t id_len = 0;
+
+	for (f = 0; rh->fields[f].report_fn; f++)
+		if (strlen(rh->fields[f].id) > id_len)
+			id_len = strlen(rh->fields[f].id);
 
 	for (f = 0; rh->fields[f].report_fn; f++) {
 		if ((type = _find_type(rh, rh->fields[f].type)) && type->desc)
@@ -260,7 +265,7 @@
 			log_print("%s Fields", desc);
 		}
 
-		log_print("- %s", rh->fields[f].id);
+		log_print("- %-*s: %s", (int) id_len, rh->fields[f].id, rh->fields[f].desc);
 		last_desc = desc;
 	}
 }
