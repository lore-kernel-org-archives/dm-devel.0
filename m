From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 11/15] libmultipath/checkers/tur: Protect
 tur_checker_context.message changes
Date: Tue, 4 Oct 2016 10:40:54 -0700
Message-ID: <f5827297-e5b3-044e-a2f5-9fab6210f4cc@sandisk.com>
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

Avoid that tur_checker_context.message is modified without holding
the tur_checker_context.lock mutex. This patch avoids that data
race detection tools like DRD complain about writing into
tur_checker_context.message.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 46 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 11f3c60..be3d5ea 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -104,10 +104,17 @@ void libcheck_repair (struct checker * c)
 	return;
 }
 
-#define TUR_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
+#define TUR_MSG(fmt, args...)					\
+	do {							\
+		char msg[CHECKER_MSG_LEN];			\
+								\
+		snprintf(msg, sizeof(msg), fmt, ##args);	\
+		copy_message(cb_arg, msg);			\
+	} while (0)
 
 static int
-tur_check(int fd, unsigned int timeout, char *msg)
+tur_check(int fd, unsigned int timeout,
+	  void (*copy_message)(void *, const char *), void *cb_arg)
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
@@ -126,7 +133,7 @@ retry:
 	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		TUR_MSG(msg, MSG_TUR_DOWN);
+		TUR_MSG(MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -134,7 +141,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		TUR_MSG(msg, MSG_TUR_UP);
+		TUR_MSG(MSG_TUR_UP);
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -179,14 +186,14 @@ retry:
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * TARGET PORT IN STANDBY STATE
 				 */
-				TUR_MSG(msg, MSG_TUR_GHOST);
+				TUR_MSG(MSG_TUR_GHOST);
 				return PATH_GHOST;
 			}
 		}
-		TUR_MSG(msg, MSG_TUR_DOWN);
+		TUR_MSG(MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
-	TUR_MSG(msg, MSG_TUR_UP);
+	TUR_MSG(MSG_TUR_UP);
 	return PATH_UP;
 }
 
@@ -206,6 +213,15 @@ static void cleanup_func(void *data)
 		cleanup_context(ct);
 }
 
+static void copy_msg_to_tcc(void *ct_p, const char *msg)
+{
+	struct tur_checker_context *ct = ct_p;
+
+	pthread_mutex_lock(&ct->lock);
+	strlcpy(ct->message, msg, sizeof(ct->message));
+	pthread_mutex_unlock(&ct->lock);
+}
+
 static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
@@ -213,16 +229,16 @@ static void *tur_thread(void *ctx)
 
 	condlog(3, "%d:%d: tur checker starting up", TUR_DEVT(ct));
 
-	ct->message[0] = '\0';
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
 
 	/* TUR checker start up */
 	pthread_mutex_lock(&ct->lock);
 	ct->state = PATH_PENDING;
+	ct->message[0] = '\0';
 	pthread_mutex_unlock(&ct->lock);
 
-	state = tur_check(ct->fd, ct->timeout, ct->message);
+	state = tur_check(ct->fd, ct->timeout, copy_msg_to_tcc, ct->message);
 
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
@@ -262,6 +278,13 @@ static int tur_check_async_timeout(struct checker *c)
 	return (now.tv_sec > ct->time);
 }
 
+static void copy_msg_to_checker(void *c_p, const char *msg)
+{
+	struct checker *c = c_p;
+
+	strlcpy(c->message, msg, sizeof(c->message));
+}
+
 extern int
 libcheck_check (struct checker * c)
 {
@@ -279,7 +302,7 @@ libcheck_check (struct checker * c)
 		ct->devt = sb.st_rdev;
 
 	if (c->sync)
-		return tur_check(c->fd, c->timeout, c->message);
+		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
 
 	/*
 	 * Async mode
@@ -342,7 +365,8 @@ libcheck_check (struct checker * c)
 			ct->thread = 0;
 			condlog(3, "%d:%d: failed to start tur thread, using"
 				" sync mode", TUR_DEVT(ct));
-			return tur_check(c->fd, c->timeout, c->message);
+			return tur_check(c->fd, c->timeout,
+					 copy_msg_to_checker, c);
 		}
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
-- 
2.10.0
