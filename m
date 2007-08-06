From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h
Date: 6 Aug 2007 13:09:47 -0000
Message-ID: <20070806130947.11057.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-08-06 13:09:46

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h 

Log message:
	improve changelog

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.197&r2=1.198
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.72&r2=1.73

--- device-mapper/WHATS_NEW	2007/08/02 22:31:59	1.197
+++ device-mapper/WHATS_NEW	2007/08/06 13:09:45	1.198
@@ -1,11 +1,10 @@
 Version 1.02.22 - 
 ================================
-  Fix a possible segfault in libdevmapper-event
-  Export dm_create_dir (was create_dir) to help fix LVM2 link error
-  Don't log mkdir fail-with-EROFS, to make create_dir equiv to the one in LVM2
-  Introduce and use log_sys_* macros from LVM2
-  dm_fclose: new function
-  libdevmapper, dmeventd: be paranoid about detecting write failure
+  Avoid repeated dm_task free on some dm_event_get_registered_device errors.
+  Introduce log_sys_* macros from LVM2.
+  Export dm_fclose and dm_create_dir.
+  Don't log EROFS mkdir failures in _create_dir_recursive (for LVM2).
+  Add fclose wrapper dm_fclose that catches write failures (using ferror).
 
 Version 1.02.21 - 13th July 2007
 ================================
--- device-mapper/lib/libdevmapper.h	2007/07/28 10:48:36	1.72
+++ device-mapper/lib/libdevmapper.h	2007/08/06 13:09:46	1.73
@@ -644,7 +644,6 @@
  */
 int dm_fclose(FILE *stream);
 
-
 /*
  * Returns size of a buffer which is allocated with dm_malloc.
  * Pointer to the buffer is stored in *buf.
