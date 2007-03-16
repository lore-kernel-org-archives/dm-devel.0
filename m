From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 16 Mar 2007 14:36:18 -0000
Message-ID: <20070316143618.15927.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-03-16 14:36:16

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 
	multilog       : libmultilog.c 
	multilog/pthread_lock: pthread_lock.c 

Log message:
	Remove unnecessary memset() return value checks.  [Jim Meyering]

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.172&r2=1.173
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.46&r2=1.47
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/multilog/libmultilog.c.diff?cvsroot=dm&r1=1.17&r2=1.18
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/multilog/pthread_lock/pthread_lock.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- device-mapper/WHATS_NEW	2007/02/14 15:12:14	1.172
+++ device-mapper/WHATS_NEW	2007/03/16 14:36:14	1.173
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Remove unnecessary memset() return value checks.
   Fix a few leaks in reporting error paths. [1.02.15+]
 
 Version 1.02.18 - 13th February 2007
--- device-mapper/dmeventd/dmeventd.c	2007/02/02 17:08:51	1.46
+++ device-mapper/dmeventd/dmeventd.c	2007/03/16 14:36:14	1.47
@@ -226,8 +226,8 @@
 	if (!ret)
 		return NULL;
 
-	if (!memset(ret, 0, sizeof(*ret)) ||
-	    !(ret->device.uuid = dm_strdup(data->device_uuid))) {
+	memset(ret, 0, sizeof(*ret));
+	if (!(ret->device.uuid = dm_strdup(data->device_uuid))) {
 		dm_free(ret);
 		return NULL;
 	}
@@ -258,8 +258,8 @@
 	if (!ret)
 		return NULL;
 
-	if (!memset(ret, 0, sizeof(*ret)) ||
-	    !(ret->dso_name = dm_strdup(data->dso_name))) {
+	memset(ret, 0, sizeof(*ret));
+	if (!(ret->dso_name = dm_strdup(data->dso_name))) {
 		dm_free(ret);
 		return NULL;
 	}
--- device-mapper/multilog/libmultilog.c	2005/06/08 15:11:21	1.17
+++ device-mapper/multilog/libmultilog.c	2007/03/16 14:36:16	1.18
@@ -294,10 +294,11 @@
 	/*
 	 * Preallocate because we don't want to sleep holding a lock.
 	 */
-	if (!(logl = malloc(sizeof(*logl))) ||
-	    !(memset(logl, 0, sizeof(*logl))))
+	if (!(logl = malloc(sizeof(*logl))))
 		return 0;
 
+	memset(logl, 0, sizeof(*logl));
+
 	/*
 	 * If the type has already been registered, it doesn't need to
 	 * be registered again.  This means the caller will need to
@@ -315,11 +316,7 @@
 
 	logl->type = type;
 
-	if(!memset(&logl->data, 0, sizeof(logl->data))) {
-		/* Should never get here */
-		free(logl);
-		return 0;
-	}
+	memset(&logl->data, 0, sizeof(logl->data));
 
 	logl->data.verbose_level = DEFAULT_VERBOSITY;
 	logl->log = nop_log;
--- device-mapper/multilog/pthread_lock/pthread_lock.c	2005/05/04 17:55:12	1.1
+++ device-mapper/multilog/pthread_lock/pthread_lock.c	2007/03/16 14:36:16	1.2
@@ -28,8 +28,8 @@
 	pthread_mutex_t *mutex;
 	if(!(mutex = malloc(sizeof(*mutex))))
 		return NULL;
-	if(!memset(mutex, 0, sizeof(*mutex)))
-		return NULL;
+	memset(mutex, 0, sizeof(*mutex));
+
 	/*
 	 * Hack to ensure DSO loading fails if not linked with
 	 * libpthread
