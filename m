From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 10/21] libmultipath/checkers: tur: use message
	id
Date: Fri,  2 Nov 2018 13:21:14 +0100
Message-ID: <20181102122125.30906-11-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 54 ++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a6c88eb2..22734be2 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -29,12 +29,19 @@
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
 
-#define MSG_TUR_UP	"tur checker reports path is up"
-#define MSG_TUR_DOWN	"tur checker reports path is down"
-#define MSG_TUR_GHOST	"tur checker reports path is in standby state"
-#define MSG_TUR_RUNNING	"tur checker still running"
-#define MSG_TUR_TIMEOUT	"tur checker timed out"
-#define MSG_TUR_FAILED	"tur checker failed to initialize"
+enum {
+	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
+	MSG_TUR_TIMEOUT,
+	MSG_TUR_FAILED,
+};
+
+#define _IDX(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[_IDX(TUR_RUNNING)] = " still running",
+	[_IDX(TUR_TIMEOUT)] = " timed out",
+	[_IDX(TUR_FAILED)] = " failed to initialize",
+	NULL,
+};
 
 struct tur_checker_context {
 	dev_t devt;
@@ -47,7 +54,7 @@ struct tur_checker_context {
 	pthread_mutex_t lock;
 	pthread_cond_t active;
 	int holders; /* uatomic access only */
-	char message[CHECKER_MSG_LEN];
+	int msgid;
 };
 
 int libcheck_init (struct checker * c)
@@ -99,7 +106,7 @@ void libcheck_free (struct checker * c)
 }
 
 static int
-tur_check(int fd, unsigned int timeout, char *msg)
+tur_check(int fd, unsigned int timeout, short *msgid)
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
@@ -118,7 +125,7 @@ retry:
 	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_DOWN);
+		*msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -126,7 +133,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_UP);
+		*msgid = CHECKER_MSGID_UP;
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -171,14 +178,14 @@ retry:
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * TARGET PORT IN STANDBY STATE
 				 */
-				snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_GHOST);
+				*msgid = CHECKER_MSGID_GHOST;
 				return PATH_GHOST;
 			}
 		}
-		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_DOWN);
+		*msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
 	}
-	snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_UP);
+	*msgid = CHECKER_MSGID_UP;
 	return PATH_UP;
 }
 
@@ -244,7 +251,7 @@ static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state, running;
-	char msg[CHECKER_MSG_LEN];
+	short msgid;
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
@@ -254,13 +261,13 @@ static void *tur_thread(void *ctx)
 		minor(ct->devt));
 
 	tur_deep_sleep(ct);
-	state = tur_check(ct->fd, ct->timeout, msg);
+	state = tur_check(ct->fd, ct->timeout, &msgid);
 	pthread_testcancel();
 
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
 	ct->state = state;
-	strlcpy(ct->message, msg, sizeof(ct->message));
+	ct->msgid = msgid;
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
@@ -313,7 +320,7 @@ int libcheck_check(struct checker * c)
 		return PATH_UNCHECKED;
 
 	if (c->sync)
-		return tur_check(c->fd, c->timeout, c->message);
+		return tur_check(c->fd, c->timeout, &c->msgid);
 
 	/*
 	 * Async mode
@@ -325,13 +332,12 @@ int libcheck_check(struct checker * c)
 				pthread_cancel(ct->thread);
 				condlog(3, "%d:%d : tur checker timeout",
 					major(ct->devt), minor(ct->devt));
-				MSG(c, MSG_TUR_TIMEOUT);
+				c->msgid = MSG_TUR_TIMEOUT;
 				tur_status = PATH_TIMEOUT;
 			} else {
 				pthread_mutex_lock(&ct->lock);
 				tur_status = ct->state;
-				strlcpy(c->message, ct->message,
-					sizeof(c->message));
+				c->msgid = ct->msgid;
 				pthread_mutex_unlock(&ct->lock);
 			}
 			ct->thread = 0;
@@ -344,7 +350,7 @@ int libcheck_check(struct checker * c)
 			ct->thread = 0;
 			pthread_mutex_lock(&ct->lock);
 			tur_status = ct->state;
-			strlcpy(c->message, ct->message, sizeof(c->message));
+			c->msgid = ct->msgid;
 			pthread_mutex_unlock(&ct->lock);
 		}
 	} else {
@@ -376,7 +382,7 @@ int libcheck_check(struct checker * c)
 		/* Start new TUR checker */
 		pthread_mutex_lock(&ct->lock);
 		tur_status = ct->state = PATH_PENDING;
-		ct->message[0] = '\0';
+		ct->msgid = CHECKER_MSGID_NONE;
 		pthread_mutex_unlock(&ct->lock);
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
@@ -392,7 +398,7 @@ int libcheck_check(struct checker * c)
 			ct->thread = 0;
 			condlog(3, "%d:%d : failed to start tur thread, using"
 				" sync mode", major(ct->devt), minor(ct->devt));
-			return tur_check(c->fd, c->timeout, c->message);
+			return tur_check(c->fd, c->timeout, &c->msgid);
 		}
 		tur_timeout(&tsp);
 		pthread_mutex_lock(&ct->lock);
@@ -401,7 +407,7 @@ int libcheck_check(struct checker * c)
 						   &tsp);
 		if (!r) {
 			tur_status = ct->state;
-			strlcpy(c->message, ct->message, sizeof(c->message));
+			c->msgid = ct->msgid;
 		}
 		pthread_mutex_unlock(&ct->lock);
 		if (tur_status == PATH_PENDING) {
-- 
2.19.1
