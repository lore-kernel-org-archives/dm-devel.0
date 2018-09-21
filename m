From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 04/19] libmultipath: cleanup tur locking
Date: Fri, 21 Sep 2018 18:05:12 -0500
Message-ID: <1537571127-10143-5-git-send-email-bmarzins@redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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

There are only three variables whose access needs to be synchronized
between the tur thread and the path checker itself: state, message, and
active.  The rest of the variables are either only written when the tur
thread isn't running, or they aren't accessed by the tur thread, or they
are atomics that are themselves used to synchronize things.

This patch limits the amount of code that is covered by ct->lock to
only what needs to be locked. It also makes ct->lock no longer a
recursive lock. To make this simpler, tur_thread now only sets the
state and message one time, instead of twice, since PATH_UNCHECKED
was never able to be returned anyway.

One benefit of this is that the tur checker thread gets more time to
call tur_check() and return before libcheck_check() gives up and
return PATH_PENDING.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 49 ++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index abda162..9f6ef51 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -53,7 +53,6 @@ struct tur_checker_context {
 int libcheck_init (struct checker * c)
 {
 	struct tur_checker_context *ct;
-	pthread_mutexattr_t attr;
 	struct stat sb;
 
 	ct = malloc(sizeof(struct tur_checker_context));
@@ -65,10 +64,7 @@ int libcheck_init (struct checker * c)
 	ct->fd = -1;
 	uatomic_set(&ct->holders, 1);
 	pthread_cond_init_mono(&ct->active);
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
-	pthread_mutex_init(&ct->lock, &attr);
-	pthread_mutexattr_destroy(&attr);
+	pthread_mutex_init(&ct->lock, NULL);
 	if (fstat(c->fd, &sb) == 0)
 		snprintf(ct->devt, sizeof(ct->devt), "%d:%d", major(sb.st_rdev),
 			 minor(sb.st_rdev));
@@ -213,12 +209,6 @@ static void *tur_thread(void *ctx)
 
 	condlog(3, "%s: tur checker starting up", ct->devt);
 
-	/* TUR checker start up */
-	pthread_mutex_lock(&ct->lock);
-	ct->state = PATH_PENDING;
-	ct->message[0] = '\0';
-	pthread_mutex_unlock(&ct->lock);
-
 	state = tur_check(ct->fd, ct->timeout, msg);
 	pthread_testcancel();
 
@@ -283,13 +273,6 @@ int libcheck_check(struct checker * c)
 	/*
 	 * Async mode
 	 */
-	r = pthread_mutex_lock(&ct->lock);
-	if (r != 0) {
-		condlog(2, "%s: tur mutex lock failed with %d", ct->devt, r);
-		MSG(c, MSG_TUR_FAILED);
-		return PATH_WILD;
-	}
-
 	if (ct->thread) {
 		if (tur_check_async_timeout(c)) {
 			int running = uatomic_xchg(&ct->running, 0);
@@ -305,23 +288,29 @@ int libcheck_check(struct checker * c)
 		} else {
 			/* TUR checker done */
 			ct->thread = 0;
+			pthread_mutex_lock(&ct->lock);
 			tur_status = ct->state;
 			strlcpy(c->message, ct->message, sizeof(c->message));
+			pthread_mutex_unlock(&ct->lock);
 		}
-		pthread_mutex_unlock(&ct->lock);
 	} else {
 		if (uatomic_read(&ct->holders) > 1) {
 			/* pthread cancel failed. If it didn't get the path
 			   state already, timeout */
-			if (ct->state == PATH_PENDING) {
-				pthread_mutex_unlock(&ct->lock);
+			pthread_mutex_lock(&ct->lock);
+			tur_status = ct->state;
+			pthread_mutex_unlock(&ct->lock);
+			if (tur_status == PATH_PENDING) {
 				condlog(3, "%s: tur thread not responding",
 					ct->devt);
 				return PATH_TIMEOUT;
 			}
 		}
 		/* Start new TUR checker */
-		ct->state = PATH_UNCHECKED;
+		pthread_mutex_lock(&ct->lock);
+		tur_status = ct->state = PATH_PENDING;
+		ct->message[0] = '\0';
+		pthread_mutex_unlock(&ct->lock);
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
 		uatomic_add(&ct->holders, 1);
@@ -334,20 +323,22 @@ int libcheck_check(struct checker * c)
 			uatomic_sub(&ct->holders, 1);
 			uatomic_set(&ct->running, 0);
 			ct->thread = 0;
-			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%s: failed to start tur thread, using"
 				" sync mode", ct->devt);
 			return tur_check(c->fd, c->timeout, c->message);
 		}
 		tur_timeout(&tsp);
-		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
-		tur_status = ct->state;
-		strlcpy(c->message, ct->message, sizeof(c->message));
+		pthread_mutex_lock(&ct->lock);
+		if (ct->state == PATH_PENDING)
+			r = pthread_cond_timedwait(&ct->active, &ct->lock, 
+						   &tsp);
+		if (!r) {
+			tur_status = ct->state;
+			strlcpy(c->message, ct->message, sizeof(c->message));
+		}
 		pthread_mutex_unlock(&ct->lock);
-		if (uatomic_read(&ct->running) != 0 &&
-		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
+		if (tur_status == PATH_PENDING) {
 			condlog(3, "%s: tur checker still running", ct->devt);
-			tur_status = PATH_PENDING;
 		} else {
 			int running = uatomic_xchg(&ct->running, 0);
 			if (running)
-- 
2.7.4
