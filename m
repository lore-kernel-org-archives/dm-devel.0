From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Thu,  8 Feb 2018 17:56:01 -0600
Message-ID: <1518134167-15938-2-git-send-email-bmarzins@redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit 6e2423fd fixed a bug where the tur checker could cancel a
detached thread after it had exitted. However in fixing this, the new
code grabbed a mutex (to call condlog) while holding a spin_lock.  To
deal with this, I've done away with the holder spin_lock completely, and
replaced it with two atomic variables, based on a suggestion by Martin
Wilck.

The holder variable works exactly like before.  When the checker is
initialized, it is set to 1. When a thread is created it is incremented.
When either the thread or the checker are done with the context, they
atomically decrement the holder variable and check its value. If it
is 0, they free the context. If it is 1, they never touch the context
again.

The other variable has changed. First, ct->running and ct->thread have
switched uses. ct->thread is now only ever accessed by the checker,
never the thread.  If it is non-NULL, a thread has started up, but
hasn't been dealt with by the checker yet. It is also obviously used
by the checker to cancel the thread.

ct->running is now an atomic variable.  When the thread is started
it is set to 1. When the checker wants to kill a thread, it atomically
sets the value to 0 and reads the previous value.  If it was 1,
the checker cancels the thread. If it was 0, the nothing needs to be
done.  After the checker has dealt with the thread, it sets ct->thread
to NULL.

When the thread is done, it atomicalllys sets the value of ct->running
to 0 and reads the previous value. If it was 1, the thread just exits.
If it was 0, then the checker is trying to cancel the thread, and so
the thread calls pause(), which is a cancellation point.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 98 ++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index b4a5cb2..894ad41 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
+#include <urcu/uatomic.h>
 
 #include "checkers.h"
 
@@ -44,7 +45,6 @@ struct tur_checker_context {
 	pthread_t thread;
 	pthread_mutex_t lock;
 	pthread_cond_t active;
-	pthread_spinlock_t hldr_lock;
 	int holders;
 	char message[CHECKER_MSG_LEN];
 };
@@ -74,13 +74,12 @@ int libcheck_init (struct checker * c)
 
 	ct->state = PATH_UNCHECKED;
 	ct->fd = -1;
-	ct->holders = 1;
+	uatomic_set(&ct->holders, 1);
 	pthread_cond_init_mono(&ct->active);
 	pthread_mutexattr_init(&attr);
 	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutex_init(&ct->lock, &attr);
 	pthread_mutexattr_destroy(&attr);
-	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
 	c->context = ct;
 
 	return 0;
@@ -90,7 +89,6 @@ static void cleanup_context(struct tur_checker_context *ct)
 {
 	pthread_mutex_destroy(&ct->lock);
 	pthread_cond_destroy(&ct->active);
-	pthread_spin_destroy(&ct->hldr_lock);
 	free(ct);
 }
 
@@ -99,16 +97,14 @@ void libcheck_free (struct checker * c)
 	if (c->context) {
 		struct tur_checker_context *ct = c->context;
 		int holders;
-		pthread_t thread;
-
-		pthread_spin_lock(&ct->hldr_lock);
-		ct->holders--;
-		holders = ct->holders;
-		thread = ct->thread;
-		pthread_spin_unlock(&ct->hldr_lock);
-		if (holders)
-			pthread_cancel(thread);
-		else
+		int running;
+
+		running = uatomic_xchg(&ct->running, 0);
+		if (running)
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+		holders = uatomic_sub_return(&ct->holders, 1);
+		if (!holders)
 			cleanup_context(ct);
 		c->context = NULL;
 	}
@@ -218,26 +214,20 @@ retry:
 
 static void cleanup_func(void *data)
 {
-	int holders;
+	int running, holders;
 	struct tur_checker_context *ct = data;
-	pthread_spin_lock(&ct->hldr_lock);
-	ct->holders--;
-	holders = ct->holders;
-	ct->thread = 0;
-	pthread_spin_unlock(&ct->hldr_lock);
+
+	running = uatomic_xchg(&ct->running, 0);
+	holders = uatomic_sub_return(&ct->holders, 1);
 	if (!holders)
 		cleanup_context(ct);
+	if (!running)
+		pause();
 }
 
 static int tur_running(struct tur_checker_context *ct)
 {
-	pthread_t thread;
-
-	pthread_spin_lock(&ct->hldr_lock);
-	thread = ct->thread;
-	pthread_spin_unlock(&ct->hldr_lock);
-
-	return thread != 0;
+	return (uatomic_read(&ct->running) != 0);
 }
 
 static void copy_msg_to_tcc(void *ct_p, const char *msg)
@@ -325,7 +315,6 @@ int libcheck_check(struct checker * c)
 	int tur_status, r;
 	char devt[32];
 
-
 	if (!ct)
 		return PATH_UNCHECKED;
 
@@ -349,35 +338,26 @@ int libcheck_check(struct checker * c)
 		return PATH_WILD;
 	}
 
-	if (ct->running) {
-		/*
-		 * Check if TUR checker is still running. Hold hldr_lock
-		 * around the pthread_cancel() call to avoid that
-		 * pthread_cancel() gets called after the (detached) TUR
-		 * thread has exited.
-		 */
-		pthread_spin_lock(&ct->hldr_lock);
-		if (ct->thread) {
-			if (tur_check_async_timeout(c)) {
-				condlog(3, "%s: tur checker timeout",
-					tur_devt(devt, sizeof(devt), ct));
+	if (ct->thread) {
+		if (tur_check_async_timeout(c)) {
+			int running = uatomic_xchg(&ct->running, 0);
+			if (running)
 				pthread_cancel(ct->thread);
-				ct->running = 0;
-				MSG(c, MSG_TUR_TIMEOUT);
-				tur_status = PATH_TIMEOUT;
-			} else {
-				condlog(3, "%s: tur checker not finished",
+			condlog(3, "%s: tur checker timeout",
+				tur_devt(devt, sizeof(devt), ct));
+			ct->thread = 0;
+			MSG(c, MSG_TUR_TIMEOUT);
+			tur_status = PATH_TIMEOUT;
+		} else if (tur_running(ct)) {
+			condlog(3, "%s: tur checker not finished",
 					tur_devt(devt, sizeof(devt), ct));
-				ct->running++;
-				tur_status = PATH_PENDING;
-			}
+			tur_status = PATH_PENDING;
 		} else {
 			/* TUR checker done */
-			ct->running = 0;
+			ct->thread = 0;
 			tur_status = ct->state;
 			strlcpy(c->message, ct->message, sizeof(c->message));
 		}
-		pthread_spin_unlock(&ct->hldr_lock);
 		pthread_mutex_unlock(&ct->lock);
 	} else {
 		if (tur_running(ct)) {
@@ -391,19 +371,17 @@ int libcheck_check(struct checker * c)
 		ct->state = PATH_UNCHECKED;
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
-		pthread_spin_lock(&ct->hldr_lock);
-		ct->holders++;
-		pthread_spin_unlock(&ct->hldr_lock);
+		uatomic_add(&ct->holders, 1);
+		uatomic_set(&ct->running, 1);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
 		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
 		pthread_attr_destroy(&attr);
 		if (r) {
-			pthread_spin_lock(&ct->hldr_lock);
-			ct->holders--;
-			pthread_spin_unlock(&ct->hldr_lock);
-			pthread_mutex_unlock(&ct->lock);
+			uatomic_sub(&ct->holders, 1);
+			uatomic_set(&ct->running, 0);
 			ct->thread = 0;
+			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%s: failed to start tur thread, using"
 				" sync mode", tur_devt(devt, sizeof(devt), ct));
 			return tur_check(c->fd, c->timeout,
@@ -418,8 +396,12 @@ int libcheck_check(struct checker * c)
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
 			condlog(3, "%s: tur checker still running",
 				tur_devt(devt, sizeof(devt), ct));
-			ct->running = 1;
 			tur_status = PATH_PENDING;
+		} else {
+			int running = uatomic_xchg(&ct->running, 0);
+			if (running)
+				pthread_cancel(ct->thread);
+			ct->thread = 0;
 		}
 	}
 
-- 
2.7.4
