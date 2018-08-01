From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 17/32] libmultipath: fix tur checker double
	locking
Date: Wed,  1 Aug 2018 15:57:03 -0500
Message-ID: <1533157038-3924-18-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

tur_devt() locks ct->lock. However, it is ocassionally called while
ct->lock is already locked. In reality, there is no reason why we need
to lock all the accesses to ct->devt. The tur checker only needs to
write to this variable one time, when it first gets the file descripter
that it is checking.  It also never uses ct->devt directly. Instead, it
always graps the major and minor, and turns them into a string. This
patch changes ct->devt into that string, and only sets it if it hasn't
been set before, and no thread is holding the context. After that,
this value is only read, and so doesn't need locking.

I realize that this locking was added to make an analyzer happy,
presumably because sometimes ct->devt was being accessed while ct->devt
was held, and sometimes not.  The tur checker locking will be cleaned
up in a later patch to deal with this.

Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 52 ++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 275541f..bfb0907 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -37,32 +37,19 @@
 #define MSG_TUR_FAILED	"tur checker failed to initialize"
 
 struct tur_checker_context {
-	dev_t devt;
+	char devt[32];
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
@@ -232,14 +219,12 @@ static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state, running;
-	char devt[32];
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
 	rcu_register_thread();
 
-	condlog(3, "%s: tur checker starting up",
-		tur_devt(devt, sizeof(devt), ct));
+	condlog(3, "%s: tur checker starting up", ct->devt);
 
 	/* TUR checker start up */
 	pthread_mutex_lock(&ct->lock);
@@ -256,8 +241,8 @@ static void *tur_thread(void *ctx)
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
-	condlog(3, "%s: tur checker finished, state %s",
-		tur_devt(devt, sizeof(devt), ct), checker_state_name(state));
+	condlog(3, "%s: tur checker finished, state %s", ct->devt,
+		checker_state_name(state));
 
 	running = uatomic_xchg(&ct->running, 0);
 	if (!running)
@@ -308,15 +293,14 @@ int libcheck_check(struct checker * c)
 	struct stat sb;
 	pthread_attr_t attr;
 	int tur_status, r;
-	char devt[32];
 
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	if (fstat(c->fd, &sb) == 0) {
-		pthread_mutex_lock(&ct->lock);
-		ct->devt = sb.st_rdev;
-		pthread_mutex_unlock(&ct->lock);
+	if (uatomic_read(&ct->holders) == 1 && ct->devt[0] == 0 &&
+	    fstat(c->fd, &sb) == 0) {
+		snprintf(ct->devt, sizeof(ct->devt), "%d:%d", major(sb.st_rdev),
+			 minor(sb.st_rdev));
 	}
 
 	if (c->sync)
@@ -327,8 +311,7 @@ int libcheck_check(struct checker * c)
 	 */
 	r = pthread_mutex_lock(&ct->lock);
 	if (r != 0) {
-		condlog(2, "%s: tur mutex lock failed with %d",
-			tur_devt(devt, sizeof(devt), ct), r);
+		condlog(2, "%s: tur mutex lock failed with %d", ct->devt, r);
 		MSG(c, MSG_TUR_FAILED);
 		return PATH_WILD;
 	}
@@ -338,14 +321,12 @@ int libcheck_check(struct checker * c)
 			int running = uatomic_xchg(&ct->running, 0);
 			if (running)
 				pthread_cancel(ct->thread);
-			condlog(3, "%s: tur checker timeout",
-				tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%s: tur checker timeout", ct->devt);
 			ct->thread = 0;
 			MSG(c, MSG_TUR_TIMEOUT);
 			tur_status = PATH_TIMEOUT;
 		} else if (uatomic_read(&ct->running) != 0) {
-			condlog(3, "%s: tur checker not finished",
-					tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%s: tur checker not finished", ct->devt);
 			tur_status = PATH_PENDING;
 		} else {
 			/* TUR checker done */
@@ -361,7 +342,7 @@ int libcheck_check(struct checker * c)
 			if (ct->state == PATH_PENDING) {
 				pthread_mutex_unlock(&ct->lock);
 				condlog(3, "%s: tur thread not responding",
-					tur_devt(devt, sizeof(devt), ct));
+					ct->devt);
 				return PATH_TIMEOUT;
 			}
 		}
@@ -381,7 +362,7 @@ int libcheck_check(struct checker * c)
 			ct->thread = 0;
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%s: failed to start tur thread, using"
-				" sync mode", tur_devt(devt, sizeof(devt), ct));
+				" sync mode", ct->devt);
 			return tur_check(c->fd, c->timeout,
 					 copy_msg_to_checker, c);
 		}
@@ -392,8 +373,7 @@ int libcheck_check(struct checker * c)
 		pthread_mutex_unlock(&ct->lock);
 		if (uatomic_read(&ct->running) != 0 &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
-			condlog(3, "%s: tur checker still running",
-				tur_devt(devt, sizeof(devt), ct));
+			condlog(3, "%s: tur checker still running", ct->devt);
 			tur_status = PATH_PENDING;
 		} else {
 			int running = uatomic_xchg(&ct->running, 0);
-- 
2.7.4
