From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/15] libmultipath/checkers/tur: Serialize
 tur_checker_context.devt accesses
Date: Tue, 4 Oct 2016 10:41:11 -0700
Message-ID: <02a280ce-4b85-4721-1375-c1a681f333e1@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Avoid that tur_checker_context.devt is accessed without holding
the tur_checker_context.lock mutex. This avoids that data race
detection tools complain about tur_checker_context.devt accesses.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 52 ++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index be3d5ea..7605fb9 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -48,7 +48,18 @@ struct tur_checker_context {
 	char message[CHECKER_MSG_LEN];
 };
 
-#define TUR_DEVT(c) major((c)->devt), minor((c)->devt)
+static const char *tur_devt(char *devt_buf, int size,
+			    struct tur_checker_context *ct)
+{
+	dev_t devt;
+
+	pthread_mutex_lock(&ct->lock);
+	devt = ct->devt;
+	pthread_mutex_unlock(&ct->lock);
+
+	snprintf(devt_buf, size, "%d:%d", major(devt), minor(devt));
+	return devt_buf;
+}
 
 int libcheck_init (struct checker * c)
 {
@@ -226,8 +237,10 @@ static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state;
+	char devt[32];
 
-	condlog(3, "%d:%d: tur checker starting up", TUR_DEVT(ct));
+	condlog(3, "%s: tur checker starting up",
+		tur_devt(devt, sizeof(devt), ct));
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
@@ -246,9 +259,10 @@ static void *tur_thread(void *ctx)
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
-	condlog(3, "%d:%d: tur checker finished, state %s",
-		TUR_DEVT(ct), checker_state_name(state));
+	condlog(3, "%s: tur checker finished, state %s",
+		tur_devt(devt, sizeof(devt), ct), checker_state_name(state));
 	tur_thread_cleanup_pop(ct);
+
 	return ((void *)0);
 }
 
@@ -293,13 +307,17 @@ libcheck_check (struct checker * c)
 	struct stat sb;
 	pthread_attr_t attr;
 	int tur_status, r;
+	char devt[32];
 
 
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	if (fstat(c->fd, &sb) == 0)
+	if (fstat(c->fd, &sb) == 0) {
+		pthread_mutex_lock(&ct->lock);
 		ct->devt = sb.st_rdev;
+		pthread_mutex_unlock(&ct->lock);
+	}
 
 	if (c->sync)
 		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
@@ -309,8 +327,8 @@ libcheck_check (struct checker * c)
 	 */
 	r = pthread_mutex_lock(&ct->lock);
 	if (r != 0) {
-		condlog(2, "%d:%d: tur mutex lock failed with %d",
-			TUR_DEVT(ct), r);
+		condlog(2, "%s: tur mutex lock failed with %d",
+			tur_devt(devt, sizeof(devt), ct), r);
 		MSG(c, MSG_TUR_FAILED);
 		return PATH_WILD;
 	}
@@ -319,15 +337,15 @@ libcheck_check (struct checker * c)
 		/* Check if TUR checker is still running */
 		if (ct->thread) {
 			if (tur_check_async_timeout(c)) {
-				condlog(3, "%d:%d: tur checker timeout",
-					TUR_DEVT(ct));
+				condlog(3, "%s: tur checker timeout",
+					tur_devt(devt, sizeof(devt), ct));
 				pthread_cancel(ct->thread);
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
 				tur_status = PATH_TIMEOUT;
 			} else {
-				condlog(3, "%d:%d: tur checker not finished",
-					TUR_DEVT(ct));
+				condlog(3, "%s: tur checker not finished",
+					tur_devt(devt, sizeof(devt), ct));
 				ct->running++;
 				tur_status = PATH_PENDING;
 			}
@@ -342,8 +360,8 @@ libcheck_check (struct checker * c)
 		if (ct->thread) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%d:%d: tur thread not responding",
-				TUR_DEVT(ct));
+			condlog(3, "%s: tur thread not responding",
+				tur_devt(devt, sizeof(devt), ct));
 			return PATH_TIMEOUT;
 		}
 		/* Start new TUR checker */
@@ -363,8 +381,8 @@ libcheck_check (struct checker * c)
 			pthread_spin_unlock(&ct->hldr_lock);
 			pthread_mutex_unlock(&ct->lock);
 			ct->thread = 0;
-			condlog(3, "%d:%d: failed to start tur thread, using"
-				" sync mode", TUR_DEVT(ct));
+			condlog(3, "%s: failed to start tur thread, using"
+				" sync mode", tur_devt(devt, sizeof(devt), ct));
 			return tur_check(c->fd, c->timeout,
 					 copy_msg_to_checker, c);
 		}
@@ -375,8 +393,8 @@ libcheck_check (struct checker * c)
 		pthread_mutex_unlock(&ct->lock);
 		if (ct->thread &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
-			condlog(3, "%d:%d: tur checker still running",
-				TUR_DEVT(ct));
+			condlog(3, "%s: tur checker still running",
+				tur_devt(devt, sizeof(devt), ct));
 			ct->running = 1;
 			tur_status = PATH_PENDING;
 		}
-- 
2.10.0
