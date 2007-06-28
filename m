From: mornfall@sourceware.org
Subject: device-mapper ./WHATS_NEW include/log.h lib/li ...
Date: 28 Jun 2007 17:27:02 -0000
Message-ID: <20070628172702.24610.qmail@sourceware.org>
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
Changes by:	mornfall@sourceware.org	2007-06-28 17:27:02

Modified files:
	.              : WHATS_NEW 
	include        : log.h 
	lib            : libdm-common.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Make warnings go to stderr. Adds log_warn macro for that purpose,
	log_print continues to print to stdout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.188&r2=1.189
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.43&r2=1.44
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.42&r2=1.43

--- device-mapper/WHATS_NEW	2007/06/19 15:47:20	1.188
+++ device-mapper/WHATS_NEW	2007/06/28 17:27:01	1.189
@@ -1,6 +1,7 @@
 Version 1.02.21 -
 ================================
   Fix dmsetup -o devno string termination. (1.02.20) 
+  Print warnings to stderr instead of stdout.
 
 Version 1.02.20 - 15th June 2007
 ================================
--- device-mapper/include/log.h	2007/04/27 19:07:43	1.8
+++ device-mapper/include/log.h	2007/06/28 17:27:01	1.9
@@ -18,6 +18,8 @@
 
 #include "libdevmapper.h"
 
+#define _LOG_STDERR 128 /* force things to go to stderr, even if loglevel
+			   would make them go to stdout */
 #define _LOG_DEBUG 7
 #define _LOG_INFO 6
 #define _LOG_NOTICE 5
@@ -31,6 +33,7 @@
 
 #define log_error(x...) plog(_LOG_ERR, x)
 #define log_print(x...) plog(_LOG_WARN, x)
+#define log_warn(x...) plog(_LOG_WARN | _LOG_STDERR, x)
 #define log_verbose(x...) plog(_LOG_NOTICE, x)
 #define log_very_verbose(x...) plog(_LOG_INFO, x)
 #define log_debug(x...) plog(_LOG_DEBUG, x)
--- device-mapper/lib/libdm-common.c	2007/01/22 15:03:57	1.43
+++ device-mapper/lib/libdm-common.c	2007/06/28 17:27:02	1.44
@@ -42,6 +42,9 @@
 			 int line __attribute((unused)), const char *f, ...)
 {
 	va_list ap;
+	int use_stderr = level & _LOG_STDERR;
+
+	level &= ~_LOG_STDERR;
 
 	if (level > _LOG_WARN && !_verbose)
 		return;
@@ -51,14 +54,14 @@
 	if (level < _LOG_WARN)
 		vfprintf(stderr, f, ap);
 	else
-		vprintf(f, ap);
+		vfprintf(use_stderr ? stderr : stdout, f, ap);
 
 	va_end(ap);
 
 	if (level < _LOG_WARN)
 		fprintf(stderr, "\n");
 	else
-		fprintf(stdout, "\n");
+		fprintf(use_stderr ? stderr : stdout, "\n");
 }
 
 dm_log_fn dm_log = _default_log;
--- device-mapper/lib/ioctl/libdm-iface.c	2007/04/27 14:52:41	1.42
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/06/28 17:27:02	1.43
@@ -592,9 +592,9 @@
 	struct stat buf;
 	char path[PATH_MAX];
 
-	log_print("Warning: Device list may be incomplete with interface "
+	log_warn("WARNING: Device list may be incomplete with interface "
 		  "version 1.");
-	log_print("Please upgrade your kernel device-mapper driver.");
+	log_warn("Please upgrade your kernel device-mapper driver.");
 
 	if (!(d = opendir(dev_dir))) {
 		log_error("%s: opendir failed: %s", dev_dir, strerror(errno));
@@ -693,7 +693,7 @@
 
 	if (dmi->flags & DM_BUFFER_FULL_FLAG)
 		/* FIXME Increase buffer size and retry operation (if query) */
-		log_error("Warning: libdevmapper buffer too small for data");
+		log_error("WARNING: libdevmapper buffer too small for data");
 
 	switch (dmt->type) {
 	case DM_DEVICE_CREATE:
@@ -1650,7 +1650,7 @@
 			dm_free(dmi);
 			goto repeat_ioctl;
 		default:
-			log_error("Warning: libdevmapper buffer too small for data");
+			log_error("WARNING: libdevmapper buffer too small for data");
 		}
 	}
 
