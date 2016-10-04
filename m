From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 13/15] libmultipath/checkers/tur: Fix races on
 tur_checker_context.thread
Date: Tue, 4 Oct 2016 10:41:28 -0700
Message-ID: <edd91d7e-17fa-545b-6e7f-bec617f86fc3@sandisk.com>
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

Avoid that pthread_cancel(ct->thread) can get called after the TUR
thread exited because this is not allowed for detached threads.
Avoid that data-race detection tools complain about reading ct->thread
without holding ct->hldr_lock.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 7605fb9..a7a70f6 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -224,6 +224,17 @@ static void cleanup_func(void *data)
 		cleanup_context(ct);
 }
 
+static int tur_running(struct tur_checker_context *ct)
+{
+	pthread_t thread;
+
+	pthread_spin_lock(&ct->hldr_lock);
+	thread = ct->thread;
+	pthread_spin_unlock(&ct->hldr_lock);
+
+	return thread != 0;
+}
+
 static void copy_msg_to_tcc(void *ct_p, const char *msg)
 {
 	struct tur_checker_context *ct = ct_p;
@@ -334,7 +345,13 @@ libcheck_check (struct checker * c)
 	}
 
 	if (ct->running) {
-		/* Check if TUR checker is still running */
+		/*
+		 * Check if TUR checker is still running. Hold hldr_lock
+		 * around the pthread_cancel() call to avoid that
+		 * pthread_cancel() gets called after the (detached) TUR
+		 * thread has exited.
+		 */
+		pthread_spin_lock(&ct->hldr_lock);
 		if (ct->thread) {
 			if (tur_check_async_timeout(c)) {
 				condlog(3, "%s: tur checker timeout",
@@ -355,9 +372,10 @@ libcheck_check (struct checker * c)
 			tur_status = ct->state;
 			strlcpy(c->message, ct->message, sizeof(c->message));
 		}
+		pthread_spin_unlock(&ct->hldr_lock);
 		pthread_mutex_unlock(&ct->lock);
 	} else {
-		if (ct->thread) {
+		if (tur_running(ct)) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%s: tur thread not responding",
@@ -391,7 +409,7 @@ libcheck_check (struct checker * c)
 		tur_status = ct->state;
 		strlcpy(c->message, ct->message, sizeof(c->message));
 		pthread_mutex_unlock(&ct->lock);
-		if (ct->thread &&
+		if (tur_running(ct) &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
 			condlog(3, "%s: tur checker still running",
 				tur_devt(devt, sizeof(devt), ct));
-- 
2.10.0
