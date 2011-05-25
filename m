From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Race condition when calling stop_waiter_thread()
Date: Wed, 25 May 2011 14:40:19 +0200
Message-ID: <201105251240.p4PCeJlS017703@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We cannot access the waiter structure from other threads as
the lifetime is totally different and it might be deleted
at any time.
So we better store the pthread id in the calling thread and
just send a signal to the thread.

References: bnc#642846

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8380c32..ea0fbf3 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -200,7 +200,7 @@ struct multipath {
 	struct hwentry * hwe;
 
 	/* threads */
-	void * waiter;
+	pthread_t waiter;
 
 	/* stats */
 	unsigned int stat_switchgroup;
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 0be5d21..1a54d93 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -51,24 +51,15 @@ void free_waiter (struct event_thread *wp)
 
 void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
-	struct event_thread *wp = (struct event_thread *)mpp->waiter;
-	pthread_t thread;
-
-	if (!wp) {
-		condlog(3, "%s: no waiter thread", mpp->alias);
-		return;
-	}
-	if (wp->thread == (pthread_t)0) {
+	if (mpp->waiter == (pthread_t)0) {
 		condlog(3, "%s: event checker thread already stopped",
 			mpp->alias);
 		return;
 	}
-	thread = wp->thread;
-	wp->thread = (pthread_t)0;
-	mpp->waiter = NULL;
-
-	condlog(2, "%s: stop event checker thread (%lu)", wp->mapname, thread);
-	pthread_kill(thread, SIGUSR1);
+	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
+		mpp->waiter);
+	pthread_kill(mpp->waiter, SIGUSR1);
+	mpp->waiter = (pthread_t)0;
 }
 
 static sigset_t unblock_signals(void)
@@ -228,7 +219,6 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 		goto out;
 
 	pthread_mutex_lock(&wp->lock);
-	mpp->waiter = (void *)wp;
 	strncpy(wp->mapname, mpp->alias, WWID_SIZE);
 	wp->vecs = vecs;
 	pthread_mutex_unlock(&wp->lock);
@@ -237,12 +227,13 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 		condlog(0, "%s: cannot create event checker", wp->mapname);
 		goto out1;
 	}
+	mpp->waiter = wp->thread;
 	condlog(2, "%s: event checker started", wp->mapname);
 
 	return 0;
 out1:
 	free_waiter(wp);
-	mpp->waiter = NULL;
+	mpp->waiter = (pthread_t)0;
 out:
 	condlog(0, "failed to start waiter thread");
 	return 1;
