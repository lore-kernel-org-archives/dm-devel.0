From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/old/dmevent ...
Date: 15 Feb 2008 14:14:59 -0000
Message-ID: <20080215141459.1832.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2008-02-15 14:14:58

Modified files:
	.              : WHATS_NEW 
	dmeventd/old   : dmevent.c 
	multilog/pthread_lock: pthread_lock.c 

Log message:
	Remove redundant if-before-free tests.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.224&r2=1.225
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/old/dmevent.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/multilog/pthread_lock/pthread_lock.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- device-mapper/WHATS_NEW	2008/01/20 01:14:38	1.224
+++ device-mapper/WHATS_NEW	2008/02/15 14:14:58	1.225
@@ -1,5 +1,6 @@
 Version 1.02.25 - 
 ====================================
+  Remove redundant if-before-free tests.
   Use log_warn for reporting field help text instead of log_print.
   Change cluster mirror log type name (s/clustered_/clustered-/)
 
@@ -35,7 +36,7 @@
 Version 1.02.21 - 13th July 2007
 ================================
   Introduce _LOG_STDERR to send log_warn() messages to stderr not stdout.
-  Fix dmsetup -o devno string termination. (1.02.20) 
+  Fix dmsetup -o devno string termination. (1.02.20)
 
 Version 1.02.20 - 15th June 2007
 ================================
@@ -323,4 +324,3 @@
   Fixed DESTDIR for make install/install_static_lib.
   Updated README/INSTALL to reflect move to sources.redhat.com.
   Updated autoconf files to 2003-06-17.
-
--- device-mapper/dmeventd/old/dmevent.c	2005/12/02 15:39:16	1.1
+++ device-mapper/dmeventd/old/dmevent.c	2008/02/15 14:14:58	1.2
@@ -220,10 +220,8 @@
    out:
 	multilog_del_type(standard);
 
-	if (device)
-		free(device);
-	if (dso_name)
-		free(dso_name);
+	free(device);
+	free(dso_name);
 
 	exit(ret);
 }
--- device-mapper/multilog/pthread_lock/pthread_lock.c	2007/08/21 16:26:07	1.3
+++ device-mapper/multilog/pthread_lock/pthread_lock.c	2008/02/15 14:14:58	1.4
@@ -62,7 +62,6 @@
 void destroy_locking(void *handle)
 {
         pthread_mutex_t *mutex = (pthread_mutex_t *)handle;
-	if(mutex)
-		free(mutex);
+	free(mutex);
 }
 
