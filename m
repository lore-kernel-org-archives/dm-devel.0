From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 15 Jan 2007 22:05:51 -0000
Message-ID: <20070115220551.20713.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 22:05:51

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 
	dmsetup        : dmsetup.c 

Log message:
	Fix a malloc error path in dmsetup message.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.147&r2=1.148
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.32&r2=1.33
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.74&r2=1.75

--- device-mapper/WHATS_NEW	2007/01/15 18:21:01	1.147
+++ device-mapper/WHATS_NEW	2007/01/15 22:05:50	1.148
@@ -1,5 +1,6 @@
 Version 1.02.15 -
 ===================================
+  Fix a malloc error path in dmsetup message.
   More libdevmapper-event interface changes and fixes.
   Rename dm_saprintf() to dm_asprintf().
   Report error if NULL pointer is supplied to dm_strdup_aux().
--- device-mapper/dmeventd/dmeventd.c	2007/01/15 19:47:48	1.32
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 22:05:50	1.33
@@ -29,22 +29,11 @@
 
 #include <dlfcn.h>
 #include <errno.h>
-#include <fcntl.h>
-#include <libgen.h>
 #include <pthread.h>
-#include <signal.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <sys/file.h>
-#include <sys/mman.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/wait.h>
 
-#include <sys/resource.h>
 #include <unistd.h>
-#include <stdarg.h>
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
 #ifdef linux
--- device-mapper/dmsetup/dmsetup.c	2006/10/19 15:34:50	1.74
+++ device-mapper/dmsetup/dmsetup.c	2007/01/15 22:05:50	1.75
@@ -533,7 +533,11 @@
 	for (i = 0; i < argc; i++)
 		sz += strlen(argv[i]) + 1;
 
-	str = dm_malloc(sz);
+	if (!(str = dm_malloc(sz))) {
+		err("message string allocation failed");
+		goto out;
+	}
+
 	memset(str, 0, sz);
 
 	for (i = 0; i < argc; i++) {
