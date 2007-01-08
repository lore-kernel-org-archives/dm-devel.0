From: agk@sourceware.org
Subject: device-mapper dmeventd/dmeventd.c lib/libdm-st ...
Date: 8 Jan 2007 15:35:08 -0000
Message-ID: <20070108153508.21205.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-08 15:35:08

Modified files:
	dmeventd       : dmeventd.c 
	lib            : libdm-string.c 

Log message:
	fix last checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.26&r2=1.27
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-string.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- device-mapper/dmeventd/dmeventd.c	2007/01/08 15:18:52	1.26
+++ device-mapper/dmeventd/dmeventd.c	2007/01/08 15:35:08	1.27
@@ -40,6 +40,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+
+#include <sys/resource.h>
 #include <unistd.h>
 #include <stdarg.h>
 #include <arpa/inet.h> /* for htonl, ntohl */
@@ -1453,7 +1455,7 @@
 
 	init_fifos(&fifos);
 
-	pthread_mutex_init(&mutex, NULL);
+	pthread_mutex_init(&_global_mutex, NULL);
 
 #ifdef MCL_CURRENT
 	if (mlockall(MCL_CURRENT | MCL_FUTURE) == -1)
@@ -1481,7 +1483,7 @@
 #ifdef MCL_CURRENT
 	munlockall();
 #endif
-	pthread_mutex_destroy(&_mutex);
+	pthread_mutex_destroy(&_global_mutex);
 
 	syslog(LOG_INFO, "dmeventd shutting down.");
 	closelog();
--- device-mapper/lib/libdm-string.c	2007/01/08 15:18:52	1.3
+++ device-mapper/lib/libdm-string.c	2007/01/08 15:35:08	1.4
@@ -126,6 +126,6 @@
 {
 	char *p = strrchr(path, '/');
 
-	return p ? p + 1 : path;
+	return p ? p + 1 : (char *) path;
 }
 
