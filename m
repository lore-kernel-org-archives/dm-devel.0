From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH][RESEND] multipath: fix scsi async tur checker
	corruption
Date: Wed, 23 May 2012 16:05:20 -0500
Message-ID: <20120523210520.GG9924@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Since the tur checker runs asynchronously in its own thread, there is nothing
that keeps a path from being orphaned or deleted before the tur thread has
finished. When this happenes the checker struct gets deleted.  However, the tur
thread might still we writing to that memory.  This can lead to memory
corruption.  This patch adds all of the necessary data to the checker context,
and makes the tur thread only use that. This way, if the checker is deleted
while the thread is still using the context, the thread will clean up the
context itself.

Since the context can only be freed when both the thread and the paths checker
structure have stopped needing it, and these can get get finished with the
context asychronously with respect to each other, the context has a holders
counter, protected by a spinlock, to keep track of the users.  When the
counter drops to zero, the context gets freed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c |   85 +++++++++++++++++++++++++++++++++-----------
 libmultipath/discovery.c    |    1 
 2 files changed, 65 insertions(+), 21 deletions(-)

Index: multipath-tools-120518/libmultipath/checkers/tur.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/checkers/tur.c
+++ multipath-tools-120518/libmultipath/checkers/tur.c
@@ -35,10 +35,15 @@ struct tur_checker_context {
 	dev_t devt;
 	int state;
 	int running;
-	time_t timeout;
+	int fd;
+	unsigned int timeout;
+	time_t time;
 	pthread_t thread;
 	pthread_mutex_t lock;
 	pthread_cond_t active;
+	pthread_spinlock_t hldr_lock;
+	int holders;
+	char message[CHECKER_MSG_LEN];
 };
 
 #define TUR_DEVT(c) major((c)->devt), minor((c)->devt)
@@ -53,28 +58,49 @@ int libcheck_init (struct checker * c)
 	memset(ct, 0, sizeof(struct tur_checker_context));
 
 	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+	ct->holders = 1;
 	pthread_cond_init(&ct->active, NULL);
 	pthread_mutex_init(&ct->lock, NULL);
+	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
 	c->context = ct;
 
 	return 0;
 }
 
+void cleanup_context(struct tur_checker_context *ct)
+{
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	pthread_spin_destroy(&ct->hldr_lock);
+	free(ct);
+}
+
 void libcheck_free (struct checker * c)
 {
 	if (c->context) {
 		struct tur_checker_context *ct = c->context;
+		int holders;
+		pthread_t thread;
 
-		pthread_mutex_destroy(&ct->lock);
-		pthread_cond_destroy(&ct->active);
-		free(c->context);
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders--;
+		holders = ct->holders;
+		thread = ct->thread;
+		pthread_spin_unlock(&ct->hldr_lock);
+		if (holders)
+			pthread_cancel(thread);
+		else
+			cleanup_context(ct);
 		c->context = NULL;
 	}
 	return;
 }
 
+#define TUR_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
+
 int
-tur_check (struct checker * c)
+tur_check(int fd, unsigned int timeout, char *msg)
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
@@ -90,10 +116,10 @@ tur_check (struct checker * c)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = c->timeout;
+	io_hdr.timeout = timeout;
 	io_hdr.pack_id = 0;
-	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
-		MSG(c, MSG_TUR_DOWN);
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		TUR_MSG(msg, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
 	if ((io_hdr.status & 0x7e) == 0x18) {
@@ -101,7 +127,7 @@ tur_check (struct checker * c)
 		 * SCSI-3 arrays might return
 		 * reservation conflict on TUR
 		 */
-		MSG(c, MSG_TUR_UP);
+		TUR_MSG(msg, MSG_TUR_UP);
 		return PATH_UP;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -146,14 +172,14 @@ tur_check (struct checker * c)
 				 * LOGICAL UNIT NOT ACCESSIBLE,
 				 * TARGET PORT IN STANDBY STATE
 				 */
-				MSG(c, MSG_TUR_GHOST);
+				TUR_MSG(msg, MSG_TUR_GHOST);
 				return PATH_GHOST;
 			}
 		}
-		MSG(c, MSG_TUR_DOWN);
+		TUR_MSG(msg, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
-	MSG(c, MSG_TUR_UP);
+	TUR_MSG(msg, MSG_TUR_UP);
 	return PATH_UP;
 }
 
@@ -162,18 +188,25 @@ tur_check (struct checker * c)
 
 void cleanup_func(void *data)
 {
+	int holders;
 	struct tur_checker_context *ct = data;
+	pthread_spin_lock(&ct->hldr_lock);
+	ct->holders--;
+	holders = ct->holders;
 	ct->thread = 0;
+	pthread_spin_unlock(&ct->hldr_lock);
+	if (!holders)
+		cleanup_context(ct);
 }
 
 void *tur_thread(void *ctx)
 {
-	struct checker *c = ctx;
-	struct tur_checker_context *ct = c->context;
+	struct tur_checker_context *ct = ctx;
 	int state;
 
 	condlog(3, "%d:%d: tur checker starting up", TUR_DEVT(ct));
 
+	ct->message[0] = '\0';
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct)
 
@@ -182,7 +215,7 @@ void *tur_thread(void *ctx)
 	ct->state = PATH_PENDING;
 	pthread_mutex_unlock(&ct->lock);
 
-	state = tur_check(c);
+	state = tur_check(ct->fd, ct->timeout, ct->message);
 
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
@@ -213,7 +246,7 @@ void tur_set_async_timeout(struct checke
 	struct timeval now;
 
 	gettimeofday(&now, NULL);
-	ct->timeout = now.tv_sec + c->timeout;
+	ct->time = now.tv_sec + c->timeout;
 }
 
 int tur_check_async_timeout(struct checker *c)
@@ -222,7 +255,7 @@ int tur_check_async_timeout(struct check
 	struct timeval now;
 
 	gettimeofday(&now, NULL);
-	return (now.tv_sec > ct->timeout);
+	return (now.tv_sec > ct->time);
 }
 
 extern int
@@ -242,7 +275,7 @@ libcheck_check (struct checker * c)
 		ct->devt = sb.st_rdev;
 
 	if (c->sync)
-		return tur_check(c);
+		return tur_check(c->fd, c->timeout, c->message);
 
 	/*
 	 * Async mode
@@ -276,6 +309,8 @@ libcheck_check (struct checker * c)
 			/* TUR checker done */
 			ct->running = 0;
 			tur_status = ct->state;
+			strncpy(c->message, ct->message, CHECKER_MSG_LEN);
+			c->message[CHECKER_MSG_LEN - 1] = '\0';
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
@@ -284,24 +319,32 @@ libcheck_check (struct checker * c)
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d: tur thread not responding, "
 				"using sync mode", TUR_DEVT(ct));
-			return tur_check(c);
+			return tur_check(c->fd, c->timeout, c->message);
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
+		ct->fd = c->fd;
+		ct->timeout = c->timeout;
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders++;
+		pthread_spin_unlock(&ct->hldr_lock);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
-		r = pthread_create(&ct->thread, &attr, tur_thread, c);
+		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
 		if (r) {
 			pthread_mutex_unlock(&ct->lock);
 			ct->thread = 0;
+			ct->holders--;
 			condlog(3, "%d:%d: failed to start tur thread, using"
 				" sync mode", TUR_DEVT(ct));
-			return tur_check(c);
+			return tur_check(c->fd, c->timeout, c->message);
 		}
 		pthread_attr_destroy(&attr);
 		tur_timeout(&tsp);
 		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
 		tur_status = ct->state;
+		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
+		c->message[CHECKER_MSG_LEN -1] = '\0';
 		pthread_mutex_unlock(&ct->lock);
 		if (ct->thread &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
Index: multipath-tools-120518/libmultipath/discovery.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/discovery.c
+++ multipath-tools-120518/libmultipath/discovery.c
@@ -747,6 +747,7 @@ get_state (struct path * pp, int daemon)
 		}
 		checker_set_fd(c, pp->fd);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
+			memset(c, 0x0, sizeof(struct checker));
 			condlog(3, "%s: checker init failed", pp->dev);
 			return PATH_UNCHECKED;
 		}
