From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/7] multipath: fix tur checker locking
Date: Wed,  7 Feb 2018 16:49:41 -0600
Message-ID: <1518043787-7066-2-git-send-email-bmarzins@redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit 6e2423fd fixed a bug where the tur checker could cancel a
detached thread after it had exitted. However in fixing this, the new
code grabbed a mutex (to call condlog) while holding a spin_lock. To
deal with that, and to try to keep with the maixim "lock data, not
code", I've changed how the tur checker synchronizes with its thread.

Now, the tur checker creates joinable threads, and detaches them when
the thread is finished or has timed out. To track the state of the
threads, I've added a new variable to the checker context, ct->attached.
When a thread starts, attached is set to 1. When the thread finishes, it
saves the value of attached, and then zeros it out, while locked. If
attached was set, it detaches itself.

When the tur checker gives up on a thread, it also saves and decrements
ct->attached, while locked. At the same time it saves the value of
ct->thread.  If attached was set, it cancels the thread, and then
detaches it.

So the values that are protected by the spin lock are now ct->holders,
ct->thread, and ct->attached. There are cases where the tur checker just
wants to know if the thread is running. If so, its safe to simply read
ct->thread without locking.  Also, if it knows that the thread isn't
running, it can freely access all of these variables. I've left the
locking in-place in these cases to make the static analyzers happy.
However I have added comments stating when the locking isn't actually
necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 66 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index b4a5cb2..6ae9700 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -46,6 +46,7 @@ struct tur_checker_context {
 	pthread_cond_t active;
 	pthread_spinlock_t hldr_lock;
 	int holders;
+	int attached;
 	char message[CHECKER_MSG_LEN];
 };
 
@@ -98,17 +99,21 @@ void libcheck_free (struct checker * c)
 {
 	if (c->context) {
 		struct tur_checker_context *ct = c->context;
-		int holders;
+		int attached, holders;
 		pthread_t thread;
 
 		pthread_spin_lock(&ct->hldr_lock);
 		ct->holders--;
 		holders = ct->holders;
+		attached = ct->attached;
+		ct->attached = 0;
 		thread = ct->thread;
 		pthread_spin_unlock(&ct->hldr_lock);
-		if (holders)
+		if (attached) {
 			pthread_cancel(thread);
-		else
+			pthread_detach(thread);
+		}
+		if (!holders)
 			cleanup_context(ct);
 		c->context = NULL;
 	}
@@ -218,15 +223,21 @@ retry:
 
 static void cleanup_func(void *data)
 {
-	int holders;
+	int attached, holders;
+	pthread_t thread;
 	struct tur_checker_context *ct = data;
 	pthread_spin_lock(&ct->hldr_lock);
 	ct->holders--;
 	holders = ct->holders;
+	attached = ct->attached;
+	ct->attached = 0;
+	thread = ct->thread;
 	ct->thread = 0;
 	pthread_spin_unlock(&ct->hldr_lock);
 	if (!holders)
 		cleanup_context(ct);
+	if (attached)
+		pthread_detach(thread);
 }
 
 static int tur_running(struct tur_checker_context *ct)
@@ -324,7 +335,8 @@ int libcheck_check(struct checker * c)
 	pthread_attr_t attr;
 	int tur_status, r;
 	char devt[32];
-
+	pthread_t thread;
+	int timed_out, attached;
 
 	if (!ct)
 		return PATH_UNCHECKED;
@@ -350,18 +362,27 @@ int libcheck_check(struct checker * c)
 	}
 
 	if (ct->running) {
-		/*
-		 * Check if TUR checker is still running. Hold hldr_lock
-		 * around the pthread_cancel() call to avoid that
-		 * pthread_cancel() gets called after the (detached) TUR
-		 * thread has exited.
-		 */
-		pthread_spin_lock(&ct->hldr_lock);
-		if (ct->thread) {
-			if (tur_check_async_timeout(c)) {
+		timed_out = tur_check_async_timeout(c);
+		if (timed_out) {
+			pthread_spin_lock(&ct->hldr_lock);
+			attached = ct->attached;
+			ct->attached = 0;
+			thread = ct->thread;
+			pthread_spin_unlock(&ct->hldr_lock);
+			if (attached) {
+				pthread_cancel(thread);
+				pthread_detach(thread);
+			}
+		} else {
+			/* locking here solely to make static analyzers happy */
+			pthread_spin_lock(&ct->hldr_lock);
+			thread = ct->thread;
+			pthread_spin_unlock(&ct->hldr_lock);
+		}
+		if (thread) {
+			if (timed_out) {
 				condlog(3, "%s: tur checker timeout",
 					tur_devt(devt, sizeof(devt), ct));
-				pthread_cancel(ct->thread);
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
 				tur_status = PATH_TIMEOUT;
@@ -377,9 +398,13 @@ int libcheck_check(struct checker * c)
 			tur_status = ct->state;
 			strlcpy(c->message, ct->message, sizeof(c->message));
 		}
-		pthread_spin_unlock(&ct->hldr_lock);
 		pthread_mutex_unlock(&ct->lock);
 	} else {
+		/*
+		 * locking is necessary here, so that we know that the
+		 * thread finished all access to the context before we
+		 * delare it not running
+		 */
 		if (tur_running(ct)) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
@@ -391,19 +416,23 @@ int libcheck_check(struct checker * c)
 		ct->state = PATH_UNCHECKED;
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
+		/* locking here solely to make static analyzers happy */
 		pthread_spin_lock(&ct->hldr_lock);
 		ct->holders++;
+		ct->attached = 1;
 		pthread_spin_unlock(&ct->hldr_lock);
 		tur_set_async_timeout(c);
-		setup_thread_attr(&attr, 32 * 1024, 1);
+		setup_thread_attr(&attr, 32 * 1024, 0);
 		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
 		pthread_attr_destroy(&attr);
 		if (r) {
+			/* locking here solely to make static analyzers happy */
 			pthread_spin_lock(&ct->hldr_lock);
 			ct->holders--;
+			ct->attached = 0;
+			ct->thread = 0;
 			pthread_spin_unlock(&ct->hldr_lock);
 			pthread_mutex_unlock(&ct->lock);
-			ct->thread = 0;
 			condlog(3, "%s: failed to start tur thread, using"
 				" sync mode", tur_devt(devt, sizeof(devt), ct));
 			return tur_check(c->fd, c->timeout,
@@ -414,6 +443,7 @@ int libcheck_check(struct checker * c)
 		tur_status = ct->state;
 		strlcpy(c->message, ct->message, sizeof(c->message));
 		pthread_mutex_unlock(&ct->lock);
+		/* locking here solely to make static analyzers happy */
 		if (tur_running(ct) &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
 			condlog(3, "%s: tur checker still running",
-- 
2.7.4
