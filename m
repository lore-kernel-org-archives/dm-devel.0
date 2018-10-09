From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 03/19] libmultipath: fix tur memory misuse
Date: Tue,  9 Oct 2018 18:03:00 -0500
Message-ID: <1539126196-28926-4-git-send-email-bmarzins@redhat.com>
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

when tur_thread() was calling tur_check(), it was passing ct->message as
the copy argument, but copy_msg_to_tcc() was assuming that it was
getting a tur_checker_context pointer. This means it was treating
ct->message as ct. This is why the tur checker never printed checker
messages. Intead of simply changing the copy argument passed in, I just
removed all the copying code, since it is completely unnecessary. The
callers of tur_check() can just pass in a buffer that it is safe to
write to, and copy it later, if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 48 ++++++++++++---------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 5844639..0c7b5ca 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -102,17 +102,8 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
-#define TUR_MSG(fmt, args...)					\
-	do {							\
-		char msg[CHECKER_MSG_LEN];			\
-								\
-		snprintf(msg, sizeof(msg), fmt, ##args);	\
-		copy_message(cb_arg, msg);			\
-	} while (0)
-
 static int
-tur_check(int fd, unsigned int timeout,
-	  void (*copy_message)(void *, const char *), void *cb_arg)
+tur_check(int fd, unsigned int timeout, char *msg)
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
@@ -131,7 +122,7 @@ retry:
 	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		TUR_MSG(MSG_TUR_DOWN);
+		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -139,7 +130,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		TUR_MSG(MSG_TUR_UP);
+		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_UP);
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -184,14 +175,14 @@ retry:
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * TARGET PORT IN STANDBY STATE
 				 */
-				TUR_MSG(MSG_TUR_GHOST);
+				snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_GHOST);
 				return PATH_GHOST;
 			}
 		}
-		TUR_MSG(MSG_TUR_DOWN);
+		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
-	TUR_MSG(MSG_TUR_UP);
+	snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_UP);
 	return PATH_UP;
 }
 
@@ -209,19 +200,11 @@ static void cleanup_func(void *data)
 	rcu_unregister_thread();
 }
 
-static void copy_msg_to_tcc(void *ct_p, const char *msg)
-{
-	struct tur_checker_context *ct = ct_p;
-
-	pthread_mutex_lock(&ct->lock);
-	strlcpy(ct->message, msg, sizeof(ct->message));
-	pthread_mutex_unlock(&ct->lock);
-}
-
 static void *tur_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state, running;
+	char msg[CHECKER_MSG_LEN];
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
@@ -236,12 +219,13 @@ static void *tur_thread(void *ctx)
 	ct->message[0] = '\0';
 	pthread_mutex_unlock(&ct->lock);
 
-	state = tur_check(ct->fd, ct->timeout, copy_msg_to_tcc, ct->message);
+	state = tur_check(ct->fd, ct->timeout, msg);
 	pthread_testcancel();
 
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
 	ct->state = state;
+	strlcpy(ct->message, msg, sizeof(ct->message));
 	pthread_cond_signal(&ct->active);
 	pthread_mutex_unlock(&ct->lock);
 
@@ -283,13 +267,6 @@ static int tur_check_async_timeout(struct checker *c)
 	return (now.tv_sec > ct->time);
 }
 
-static void copy_msg_to_checker(void *c_p, const char *msg)
-{
-	struct checker *c = c_p;
-
-	strlcpy(c->message, msg, sizeof(c->message));
-}
-
 int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
@@ -301,7 +278,7 @@ int libcheck_check(struct checker * c)
 		return PATH_UNCHECKED;
 
 	if (c->sync)
-		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
+		return tur_check(c->fd, c->timeout, c->message);
 
 	/*
 	 * Async mode
@@ -341,7 +318,7 @@ int libcheck_check(struct checker * c)
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d : tur checker failing back to sync",
 				major(ct->devt), minor(ct->devt));
-			return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
+			return tur_check(c->fd, c->timeout, c->message);
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
@@ -360,8 +337,7 @@ int libcheck_check(struct checker * c)
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d : failed to start tur thread, using"
 				" sync mode", major(ct->devt), minor(ct->devt));
-			return tur_check(c->fd, c->timeout,
-					 copy_msg_to_checker, c);
+			return tur_check(c->fd, c->timeout, c->message);
 		}
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
-- 
2.7.4
