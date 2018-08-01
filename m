From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 18/32] libmultipath: fix tur memory misuse
Date: Wed,  1 Aug 2018 15:57:04 -0500
Message-ID: <1533157038-3924-19-git-send-email-bmarzins@redhat.com>
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

when tur_thread() was calling tur_check(), it was passing ct->message as
the copy argument, but copy_msg_to_tcc() was assuming that it was
getting a tur_checker_context pointer. This means it was treating
ct->message as ct. This is why the tur checker never printed checker
messages. Intead of simply changing the copy argument passed in, I just
removed all the copying code, since it is completely unnecessary. The
callers of tur_check() can just pass in a buffer that it is safe to
write to, and copy it later, if necessary.

Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 46 +++++++++++----------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index bfb0907..a02c445 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -99,17 +99,8 @@ void libcheck_free (struct checker * c)
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
@@ -128,7 +119,7 @@ retry:
 	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		TUR_MSG(MSG_TUR_DOWN);
+		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -136,7 +127,7 @@ retry:
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		TUR_MSG(MSG_TUR_UP);
+		snprintf(msg, CHECKER_MSG_LEN, MSG_TUR_UP);
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -181,14 +172,14 @@ retry:
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
 
@@ -206,19 +197,11 @@ static void cleanup_func(void *data)
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
@@ -232,12 +215,13 @@ static void *tur_thread(void *ctx)
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
 
@@ -279,13 +263,6 @@ static int tur_check_async_timeout(struct checker *c)
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
@@ -304,7 +281,7 @@ int libcheck_check(struct checker * c)
 	}
 
 	if (c->sync)
-		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
+		return tur_check(c->fd, c->timeout, c->message);
 
 	/*
 	 * Async mode
@@ -363,8 +340,7 @@ int libcheck_check(struct checker * c)
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%s: failed to start tur thread, using"
 				" sync mode", ct->devt);
-			return tur_check(c->fd, c->timeout,
-					 copy_msg_to_checker, c);
+			return tur_check(c->fd, c->timeout, c->message);
 		}
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
-- 
2.7.4
