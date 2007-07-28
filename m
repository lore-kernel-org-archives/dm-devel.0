From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-file.c
Date: 28 Jul 2007 10:27:35 -0000
Message-ID: <20070728102735.12507.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-07-28 10:27:34

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-file.c 

Log message:
	Make the libdevmapper version of create_dir equivalent to the LVM2 one.
	(_create_dir_recursive): Refrain from logging a mkdir failure due to EROFS.
	Patch by Jun'ichi Nomura.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.194&r2=1.195
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.c.diff?cvsroot=dm&r1=1.6&r2=1.7

--- device-mapper/WHATS_NEW	2007/07/28 10:23:01	1.194
+++ device-mapper/WHATS_NEW	2007/07/28 10:27:34	1.195
@@ -1,5 +1,6 @@
 Version 1.02.22 - 
 ================================
+  Don't log mkdir fail-with-EROFS, to make create_dir equiv to the one in LVM2
   Introduce and use log_sys_* macros from LVM2
   dm_fclose: new function
   libdevmapper, dmeventd: be paranoid about detecting write failure
--- device-mapper/lib/libdm-file.c	2007/07/28 10:23:01	1.6
+++ device-mapper/lib/libdm-file.c	2007/07/28 10:27:34	1.7
@@ -33,7 +33,8 @@
 		if (*orig) {
 			rc = mkdir(orig, 0777);
 			if (rc < 0 && errno != EEXIST) {
-				log_sys_error("mkdir", orig);
+				if (errno != EROFS)
+					log_sys_error("mkdir", orig);
 				goto out;
 			}
 		}
@@ -43,7 +44,8 @@
 	/* Create final directory */
 	rc = mkdir(dir, 0777);
 	if (rc < 0 && errno != EEXIST) {
-		log_sys_error("mkdir", orig);
+		if (errno != EROFS)
+			log_sys_error("mkdir", orig);
 		goto out;
 	}
 
