From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c in ...
Date: 30 Oct 2008 17:24:05 -0000
Message-ID: <20081030172405.660.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-10-30 17:24:04

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	include        : lib.h log.h 
	lib            : libdm-report.c 
Added files:
	include        : dm-logging.h 

Log message:
	Split out dm-logging.h from log.h

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.254&r2=1.255
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.111&r2=1.112
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/dm-logging.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/lib.h.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.23&r2=1.24

--- device-mapper/WHATS_NEW	2008/10/30 15:11:16	1.254
+++ device-mapper/WHATS_NEW	2008/10/30 17:24:03	1.255
@@ -1,5 +1,6 @@
 Version 1.02.29 -
 =====================================
+  Split out dm-logging.h from log.h.
   Use lvm-types.h.
   Add usrsbindir to configure.
 
--- device-mapper/dmsetup/dmsetup.c	2008/06/24 22:53:47	1.111
+++ device-mapper/dmsetup/dmsetup.c	2008/10/30 17:24:03	1.112
@@ -22,7 +22,7 @@
 #include "configure.h"
 
 #include "libdevmapper.h"
-#include "log.h"
+#include "dm-logging.h"
 
 #include <stdio.h>
 #include <stdlib.h>
/cvs/dm/device-mapper/include/dm-logging.h,v  -->  standard output
revision 1.1
--- device-mapper/include/dm-logging.h
+++ -	2008-10-30 17:24:05.236805000 +0000
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU Lesser General Public License v.2.1.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _DM_LOGGING_H
+#define _DM_LOGGING_H
+
+#include "libdevmapper.h"
+
+extern dm_log_fn dm_log;
+
+#define plog(l, x...) dm_log(l, __FILE__, __LINE__, ## x)
+
+#include "log.h"
+
+#endif
--- device-mapper/include/lib.h	2008/10/30 15:11:17	1.7
+++ device-mapper/include/lib.h	2008/10/30 17:24:04	1.8
@@ -25,7 +25,7 @@
 
 #include <configure.h>
 
-#include "log.h"
+#include "dm-logging.h"
 #include "intl.h"
 #include "lvm-types.h"
 
--- device-mapper/include/log.h	2007/08/21 16:26:06	1.11
+++ device-mapper/include/log.h	2008/10/30 17:24:04	1.12
@@ -18,6 +18,10 @@
 
 #include "libdevmapper.h"
 
+#include <stdio.h>		/* FILE */
+#include <string.h>		/* strerror() */
+#include <errno.h>
+
 #define _LOG_STDERR 128 /* force things to go to stderr, even if loglevel
 			   would make them go to stdout */
 #define _LOG_DEBUG 7
@@ -27,27 +31,27 @@
 #define _LOG_ERR 3
 #define _LOG_FATAL 2
 
-extern dm_log_fn dm_log;
-
-#define plog(l, x...) dm_log(l, __FILE__, __LINE__, ## x)
-
-#define log_error(x...) plog(_LOG_ERR, x)
-#define log_print(x...) plog(_LOG_WARN, x)
-#define log_warn(x...) plog(_LOG_WARN | _LOG_STDERR, x)
-#define log_verbose(x...) plog(_LOG_NOTICE, x)
-#define log_very_verbose(x...) plog(_LOG_INFO, x)
 #define log_debug(x...) plog(_LOG_DEBUG, x)
+#define log_info(x...) plog(_LOG_INFO, x)
+#define log_notice(x...) plog(_LOG_NOTICE, x)
+#define log_warn(x...) plog(_LOG_WARN | _LOG_STDERR, x)
+#define log_err(x...) plog(_LOG_ERR, x)
+#define log_fatal(x...) plog(_LOG_FATAL, x)
+
+#define stack log_debug("<backtrace>")	/* Backtrace on error */
+#define log_very_verbose(args...) log_info(args)
+#define log_verbose(args...) log_notice(args)
+#define log_print(args...) plog(_LOG_WARN, args)
+#define log_error(args...) log_err(args)
 
 /* System call equivalents */
 #define log_sys_error(x, y) \
-		log_error("%s: %s failed: %s", y, x, strerror(errno))
+		log_err("%s: %s failed: %s", y, x, strerror(errno))
 #define log_sys_very_verbose(x, y) \
 		log_info("%s: %s failed: %s", y, x, strerror(errno))
 #define log_sys_debug(x, y) \
 		log_debug("%s: %s failed: %s", y, x, strerror(errno))
 
-#define stack log_debug("<backtrace>")  /* Backtrace on error */
-
 #define return_0	do { stack; return 0; } while (0)
 #define return_NULL	do { stack; return NULL; } while (0)
 #define goto_out	do { stack; goto out; } while (0)
--- device-mapper/lib/libdm-report.c	2008/06/25 19:52:52	1.23
+++ device-mapper/lib/libdm-report.c	2008/10/30 17:24:04	1.24
@@ -13,9 +13,7 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include "libdevmapper.h"
-#include "list.h"
-#include "log.h"
+#include "lib.h"
 
 #include <ctype.h>
 
