From: agk@sourceware.org
Subject: device-mapper/lib libdm-report.c
Date: 24 Jan 2007 16:41:34 -0000
Message-ID: <20070124164134.18383.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-24 16:41:34

Modified files:
	lib            : libdm-report.c 

Log message:
	Adjust report field help description layout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.9&r2=1.10

--- device-mapper/lib/libdm-report.c	2007/01/23 23:58:55	1.9
+++ device-mapper/lib/libdm-report.c	2007/01/24 16:41:33	1.10
@@ -263,9 +263,14 @@
 			if (*last_desc)
 				log_print(" ");
 			log_print("%s Fields", desc);
+			log_print("%*.*s", (int) strlen(desc) + 7,
+				  (int) strlen(desc) + 7,
+				  "------------------------------------------");
+				  
 		}
 
-		log_print("- %-*s: %s", (int) id_len, rh->fields[f].id, rh->fields[f].desc);
+		/* FIXME Add line-wrapping at terminal width (or 80 cols) */
+		log_print("  %-*s - %s", (int) id_len, rh->fields[f].id, rh->fields[f].desc);
 		last_desc = desc;
 	}
 }
