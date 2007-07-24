From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/.exported_symbol ...
Date: 24 Jul 2007 14:15:46 -0000
Message-ID: <20070724141546.18751.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-07-24 14:15:45

Modified files:
	.              : WHATS_NEW 
	lib            : .exported_symbols libdevmapper.h libdm-file.c 

Log message:
	dm_fclose: new function
	* lib/libdevmapper.h: Declare it.
	* lib/libdm-file.c (dm_fclose): Define it.
	* lib/.exported_symbols: Add dm_fclose.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.191&r2=1.192
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.29&r2=1.30
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.70&r2=1.71
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- device-mapper/WHATS_NEW	2007/07/13 16:10:24	1.191
+++ device-mapper/WHATS_NEW	2007/07/24 14:15:45	1.192
@@ -1,5 +1,6 @@
 Version 1.02.22 - 
 ================================
+  dm_fclose: new function
 
 Version 1.02.21 - 13th July 2007
 ================================
--- device-mapper/lib/.exported_symbols	2007/04/27 18:40:23	1.29
+++ device-mapper/lib/.exported_symbols	2007/07/24 14:15:45	1.30
@@ -1,6 +1,7 @@
 dm_lib_release
 dm_lib_exit
 dm_driver_version
+dm_fclose
 dm_get_library_version
 dm_log
 dm_log_init
--- device-mapper/lib/libdevmapper.h	2007/04/27 18:40:23	1.70
+++ device-mapper/lib/libdevmapper.h	2007/07/24 14:15:45	1.71
@@ -27,6 +27,7 @@
 #include <limits.h>
 #include <string.h>
 #include <stdlib.h>
+#include <stdio.h>
 
 /*****************************************************************
  * The first section of this file provides direct access to the 
@@ -623,6 +624,21 @@
  */
 char *dm_basename(const char *path);
 
+/**************************
+ * file/stream manipulation
+ **************************/
+
+/*
+ * Close a stream, with nicer error checking than fclose's.
+ * Derived from gnulib's close-stream.c.
+ *
+ * Close "stream".  Return 0 if successful, and EOF (setting errno)
+ * otherwise.  Upon failure, set errno to 0 if the error number
+ * cannot be determined.  Useful mainly for writable streams.
+ */
+int dm_fclose(FILE *stream);
+
+
 /*
  * Returns size of a buffer which is allocated with dm_malloc.
  * Pointer to the buffer is stored in *buf.
--- device-mapper/lib/libdm-file.c	2006/05/10 16:23:41	1.4
+++ device-mapper/lib/libdm-file.c	2007/07/24 14:15:45	1.5
@@ -72,3 +72,16 @@
 	return 0;
 }
 
+int dm_fclose(FILE *stream)
+{
+	int prev_fail = ferror(stream);
+	int fclose_fail = fclose(stream);
+
+	/* If there was a previous failure, but fclose succeeded,
+	   clear errno, since ferror does not set it, and its value
+	   may be unrelated to the ferror-reported failure.  */
+	if (prev_fail && !fclose_fail)
+		errno = 0;
+
+	return prev_fail || fclose_fail ? EOF : 0;
+}
