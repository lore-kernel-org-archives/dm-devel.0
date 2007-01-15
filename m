From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 15 Jan 2007 22:37:40 -0000
Message-ID: <20070115223740.6200.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-15 22:37:40

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	reduce some if/else complexity

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.33&r2=1.34

--- device-mapper/dmeventd/dmeventd.c	2007/01/15 22:05:50	1.33
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 22:37:40	1.34
@@ -1295,14 +1295,15 @@
 	_lock_mutex();
 	while ((l = list_first(&_thread_registry_unused))) {
 		thread = list_item(l, struct thread_status);
-		if (thread->processing) {
-			goto out;	/* cleanup on the next round */
-		}
+		if (thread->processing)
+			break;	/* cleanup on the next round */
 
 		if (thread->status == DM_THREAD_RUNNING) {
 			thread->status = DM_THREAD_SHUTDOWN;
-			goto out;
-		} else if (thread->status == DM_THREAD_SHUTDOWN) {
+			break;
+		} 
+
+		if (thread->status == DM_THREAD_SHUTDOWN) {
 			if (!thread->events) {
 				/* turn codes negative -- should we be returning this? */
 				ret = _terminate_thread(thread);
@@ -1315,22 +1316,26 @@
 					       strerror(-ret));
 					stack;
 				}
-				goto out;
-			} else {
-				list_del(l);
-				syslog(LOG_ERR,
-				       "thread can't be on unused list unless !thread->events");
-				thread->status = DM_THREAD_RUNNING;
-				LINK_THREAD(thread);
-			}
-		} else if (thread->status == DM_THREAD_DONE) {
+				break;
+			} 
+
+			list_del(l);
+			syslog(LOG_ERR,
+			       "thread can't be on unused list unless !thread->events");
+			thread->status = DM_THREAD_RUNNING;
+			LINK_THREAD(thread);
+
+			continue;
+		}
+
+		if (thread->status == DM_THREAD_DONE) {
 			list_del(l);
 			pthread_join(thread->thread, NULL);
 			_lib_put(thread->dso_data);
 			_free_thread_status(thread);
 		}
 	}
-      out:
+
 	_unlock_mutex();
 }
 
