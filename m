From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 15 Jan 2007 19:19:31 -0000
Message-ID: <20070115191931.17375.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 19:19:31

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	fail registration if timeout thread cannot be started

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.30&r2=1.31

--- device-mapper/dmeventd/dmeventd.c	2007/01/15 18:58:40	1.30
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 19:19:31	1.31
@@ -849,6 +849,20 @@
 
 	_lock_mutex();
 
+	/* If creation of timeout thread fails (as it may), we fail
+	   here completely. The client is responsible for either
+	   retrying later or trying to register without timeout
+	   events. However, if timeout thread cannot be started, it
+	   usually means we are so starved on resources that we are
+	   almost as good as dead already... */
+	if (thread->events & DM_EVENT_TIMEOUT) {
+		ret = -_register_for_timeout(thread);
+                if (ret) {
+                    _unlock_mutex();
+                    goto out;
+                }
+        }
+
 	if (!(thread = _lookup_thread_status(message_data))) {
 		_unlock_mutex();
 
@@ -874,15 +888,6 @@
 
 	_unlock_mutex();
 
-	/* FIXME - If you fail to register for timeout events, you
-	   still monitor all the other events. Is this the right
-	   action for newly created devices?  Also, you are still
-	   on the timeout registry, so if a timeout thread is
-	   successfully started up later, you will start receiving
-	   DM_EVENT_TIMEOUT events */
-	if (thread->events & DM_EVENT_TIMEOUT)
-		ret = -_register_for_timeout(thread);
-
       out:
 	/*
 	 * Deallocate thread status after releasing
