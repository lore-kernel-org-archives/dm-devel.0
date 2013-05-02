From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 05/16] Fix a couple of signal issues
Date: Thu,  2 May 2013 16:46:26 -0500
Message-ID: <1367531197-8987-6-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The patch cleans up some signal issues.
First, when the vecs locking around reconfigure got shuffled
around earlier, it was removed from sighup. This patch restores
that.

Second, a new sigusr1 handler was created. However the existing
one was never removed.  Since signal handlers are per-process, and
not per-thread, the original handler will get overwritten by the
new one, so this patch deletes the original handler.

Third, sighup locks the vecs lock and sigusr1 locks logq_lock.
However, these signals weren't being blocked before threads locked
those locks.  This patch blocks those signals while those locks
are being taken to avoid locking deadlocks.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log_pthread.c |  3 +++
 multipathd/main.c          | 12 +++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index b8f9119..b3daf8f 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -55,14 +55,17 @@ void log_safe (int prio, const char * fmt, va_list ap)
 
 void log_thread_flush (void)
 {
+	sigset_t old;
 	int empty;
 
 	do {
+		block_signal(SIGUSR1, &old);
 		pthread_mutex_lock(&logq_lock);
 		empty = log_dequeue(la->buff);
 		pthread_mutex_unlock(&logq_lock);
 		if (!empty)
 			log_syslog(la->buff);
+		pthread_sigmask(SIG_SETMASK, &old, NULL);
 	} while (empty == 0);
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 95264fc..f6e68e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1467,7 +1467,9 @@ sighup (int sig)
 	if (running_state != DAEMON_RUNNING)
 		return;
 
+	lock(gvecs->lock);
 	reconfigure(gvecs);
+	unlock(gvecs->lock);
 
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
@@ -1481,16 +1483,9 @@ sigend (int sig)
 }
 
 static void
-sigusr1 (int sig)
-{
-	condlog(3, "SIGUSR1 received");
-}
-
-static void
 signal_init(void)
 {
 	signal_set(SIGHUP, sighup);
-	signal_set(SIGUSR1, sigusr1);
 	signal_set(SIGINT, sigend);
 	signal_set(SIGTERM, sigend);
 	signal(SIGPIPE, SIG_IGN);
@@ -1646,6 +1641,7 @@ child (void * param)
 	 */
 	running_state = DAEMON_CONFIGURE;
 
+	block_signal(SIGHUP, &set);
 	lock(vecs->lock);
 	if (configure(vecs, 1)) {
 		unlock(vecs->lock);
@@ -1653,6 +1649,7 @@ child (void * param)
 		exit(1);
 	}
 	unlock(vecs->lock);
+	pthread_sigmask(SIG_SETMASK, &set, NULL);
 
 	/*
 	 * start threads
@@ -1685,6 +1682,7 @@ child (void * param)
 	 */
 	running_state = DAEMON_SHUTDOWN;
 	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
+	block_signal(SIGUSR1, NULL);
 	block_signal(SIGHUP, NULL);
 	lock(vecs->lock);
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
-- 
1.8.2
