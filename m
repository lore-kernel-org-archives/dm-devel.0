From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-report.c
Date: 20 Jan 2008 01:14:38 -0000
Message-ID: <20080120011438.3568.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-01-20 01:14:38

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-report.c 

Log message:
	Use log_warn for reporting field help text instead of log_print.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.223&r2=1.224
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.15&r2=1.16

--- device-mapper/WHATS_NEW	2008/01/15 22:48:11	1.223
+++ device-mapper/WHATS_NEW	2008/01/20 01:14:38	1.224
@@ -1,5 +1,6 @@
 Version 1.02.25 - 
 ====================================
+  Use log_warn for reporting field help text instead of log_print.
   Change cluster mirror log type name (s/clustered_/clustered-/)
 
 Version 1.02.24 - 20th December 2007
--- device-mapper/lib/libdm-report.c	2007/08/21 16:26:06	1.15
+++ device-mapper/lib/libdm-report.c	2008/01/20 01:14:38	1.16
@@ -260,16 +260,16 @@
 			desc = " ";
 		if (desc != last_desc) {
 			if (*last_desc)
-				log_print(" ");
-			log_print("%s Fields", desc);
-			log_print("%*.*s", (int) strlen(desc) + 7,
-				  (int) strlen(desc) + 7,
-				  "------------------------------------------");
+				log_warn(" ");
+			log_warn("%s Fields", desc);
+			log_warn("%*.*s", (int) strlen(desc) + 7,
+				 (int) strlen(desc) + 7,
+				 "------------------------------------------");
 				  
 		}
 
 		/* FIXME Add line-wrapping at terminal width (or 80 cols) */
-		log_print("  %-*s - %s", (int) id_len, rh->fields[f].id, rh->fields[f].desc);
+		log_warn("  %-*s - %s", (int) id_len, rh->fields[f].id, rh->fields[f].desc);
 		last_desc = desc;
 	}
 }
@@ -444,7 +444,7 @@
 
 		if (!_field_match(rh, ws, (size_t) (we - ws))) {
 			_display_fields(rh);
-			log_print(" ");
+			log_warn(" ");
 			if (strcasecmp(ws, "help") && strcmp(ws, "?"))
 				log_error("Unrecognised field: %.*s",
 					  (int) (we - ws), ws);
