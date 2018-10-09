From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 02/19] libmultipath: fix tur checker double
	locking
Date: Tue,  9 Oct 2018 18:02:59 -0500
Message-ID: <1539126196-28926-3-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

tur_devt() locks ct->lock. However, it is ocassionally called while
ct->lock is already locked. In reality, there is no reason why we need
to lock all the accesses to ct->devt. The tur checker only needs to
write to this variable one time, when it first gets the file descripter
that it is checking. This patch sets ct->devt in libcheck_init() when it
is first initializing the checker context. After that, ct->devt is only
ever read.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 60 +++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 3c5e236..5844639 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -39,34 +39,22 @@
 struct tur_checker_context {
 	dev_t devt;
 	int state;
-	int running;
+	int running; /* uatomic access only */
 	int fd;
 	unsigned int timeout;
 	time_t time;
 	pthread_t thread;
 	pthread_mutex_t lock;
 	pthread_cond_t active;
-	int holders;
+	int holders; /* uatomic access only */
 	char message[CHECKER_MSG_LEN];
 };
 
-static const char *tur_devt(char *devt_buf, int size,
-			    struct tur_checker_context *ct)
-{
-	dev_t devt;
-
-	pthread_mutex_lock(&ct->lock);
-	devt = ct->devt;
-	pthread_mutex_unlock(&ct->lock);
-
-	snprintf(devt_buf, size, "%d:%d", major(devt), minor(devt));
-	return devt_buf;
-}
-
 int libcheck_init (struct checker * c)
 {
 	struct tur_checker_context *ct;
 	pthread_mutexattr_t attr;
+	struct stat sb;
 
 	ct = malloc(sizeof(struct tur_checker_context));
 	if (!ct)
@@ -81,6 +69,8 @@ int libcheck_init (struct checker * c)
 	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutex_init(&ct->lock, &attr);
 	pthread_mutexattr_destroy(&attr);
+	if (fstat(c->fd, &sb) == 0)
+		ct->devt = sb.st_rdev;
 	c->context = ct;
 
 	return 0;
@@ -232,14 +222,13 @@ static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state, running;
-	char devt[32];
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
 	rcu_register_thread();
 
-	condlog(3, "%s: tur checker starting up",
-		tur_devt(devt, sizeof(devt), ct));
+	condlog(3, "%d:%d : tur checker starting up", major(ct->devt),
+		minor(ct->devt));
 
 	/* TUR checker start up */
 	pthread_mutex_lock(&ct->lock);
@@ -256,8 +245,8 @@ static void *tur_thread(void *ctx)
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
-	condlog(3, "%s: tur checker finished, state %s",
-		tur_devt(devt, sizeof(devt), ct), checker_state_name(state));
+	condlog(3, "%d:%d : tur checker finished, state %s", major(ct->devt),
+		minor(ct->devt), checker_state_name(state));
 
 	running = uatomic_xchg(&ct->running, 0);
 	if (!running)
@@ -305,20 +294,12 @@ int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
 	struct timespec tsp;
-	struct stat sb;
 	pthread_attr_t attr;
 	int tur_status, r;
-	char devt[32];
 
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	if (fstat(c->fd, &sb) == 0) {
-		pthread_mutex_lock(&ct->lock);
-		ct->devt = sb.st_rdev;
-		pthread_mutex_unlock(&ct->lock);
-	}
-
 	if (c->sync)
 		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
 
@@ -327,8 +308,7 @@ int libcheck_check(struct checker * c)
 	 */
 	r = pthread_mutex_lock(&ct->lock);
 	if (r != 0) {
-		condlog(2, "%s: tur mutex lock failed with %d",
-			tur_devt(devt, sizeof(devt), ct), r);
+		condlog(2, "%s: tur mutex lock failed with %d", ct->devt, r);
 		MSG(c, MSG_TUR_FAILED);
 		return PATH_WILD;
 	}
@@ -338,14 +318,14 @@ int libcheck_check(struct checker * c)
 			int running = uatomic_xchg(&ct->running, 0);
 			if (running)
 				pthread_cancel(ct->thread);
-			condlog(3, "%s: tur checker timeout",
-				tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%d:%d : tur checker timeout",
+				major(ct->devt), minor(ct->devt));
 			ct->thread = 0;
 			MSG(c, MSG_TUR_TIMEOUT);
 			tur_status = PATH_TIMEOUT;
 		} else if (uatomic_read(&ct->running) != 0) {
-			condlog(3, "%s: tur checker not finished",
-					tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%d:%d : tur checker not finished",
+				major(ct->devt), minor(ct->devt));
 			tur_status = PATH_PENDING;
 		} else {
 			/* TUR checker done */
@@ -359,8 +339,8 @@ int libcheck_check(struct checker * c)
 			/* The thread has been cancelled but hasn't
 			 * quilt. Fail back to synchronous mode */
 			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%s: tur checker failing back to sync",
-				tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%d:%d : tur checker failing back to sync",
+				major(ct->devt), minor(ct->devt));
 			return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
 		}
 		/* Start new TUR checker */
@@ -378,8 +358,8 @@ int libcheck_check(struct checker * c)
 			uatomic_set(&ct->running, 0);
 			ct->thread = 0;
 			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%s: failed to start tur thread, using"
-				" sync mode", tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%d:%d : failed to start tur thread, using"
+				" sync mode", major(ct->devt), minor(ct->devt));
 			return tur_check(c->fd, c->timeout,
 					 copy_msg_to_checker, c);
 		}
@@ -390,8 +370,8 @@ int libcheck_check(struct checker * c)
 		pthread_mutex_unlock(&ct->lock);
 		if (uatomic_read(&ct->running) != 0 &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
-			condlog(3, "%s: tur checker still running",
-				tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%d:%d : tur checker still running",
+				major(ct->devt), minor(ct->devt));
 			tur_status = PATH_PENDING;
 		} else {
 			int running = uatomic_xchg(&ct->running, 0);
-- 
2.7.4
