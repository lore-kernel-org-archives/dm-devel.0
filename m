From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Tue, 16 Aug 2016 13:11:47 -0700
Message-ID: <7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------C3584BF42247C0EC442A1DFE"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--------------C3584BF42247C0EC442A1DFE
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 08/15/2016 11:31 PM, Hannes Reinecke wrote:
> Makes one wonder: what happens to the waitevent threads?
> We won't be waiting for them after applying this patch, right?
> So why did we ever had this busy loop here?
> Ben?
>
> (And while we're at the subject: can't we drop the waitevent threads
> altogether? We're listening to uevents nowadays, so we should be
> notified if something happened to the device-mapper tables. Which should
> make the waitevent threads unnecessary, right?)

Hello Hannes,

Maybe this is not what you had in mind, but would you agree with the 
attached two patches?

Thanks,

Bart.



--------------C3584BF42247C0EC442A1DFE
Content-Type: text/x-patch;
	name="0001-libmultipath-waiter.c-Call-pthread_join-upon-thread-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-libmultipath-waiter.c-Call-pthread_join-upon-thread-.pa";
	filename*1="tch"

From b9e2113b5793706b2d28f4096faad919a625dd9f Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Tue, 16 Aug 2016 08:56:44 -0700
Subject: [PATCH 1/2] libmultipath/waiter.c: Call pthread_join() upon thread
 exit

pthread_kill() delivers a signal asynchronously. Hence add a
pthread_join() call in stop_waiter_thread() to wait until the
waiter thread has stopped. The following section from the
pthread_join() manpage is relevant in this context:

  Failure to join with a thread that is joinable (i.e., one that is not
  detached), produces a "zombie thread". Avoid doing this, since each
  zombie thread consumes some system resources, and when enough zombie
  threads have accumulated, it will no longer be possible to create new
  threads (or processes).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/waiter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 995ea1a..6692753 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -61,6 +61,7 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	mpp->waiter = (pthread_t)0;
 	pthread_cancel(thread);
 	pthread_kill(thread, SIGUSR2);
+	pthread_join(thread, NULL);
 }
 
 /*
-- 
2.9.2


--------------C3584BF42247C0EC442A1DFE
Content-Type: text/x-patch;
	name="0002-libmultipath-checkers-tur-Call-pthread_join-upon-thr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-libmultipath-checkers-tur-Call-pthread_join-upon-thr.pa";
	filename*1="tch"

From 16764e4699efd57321b95f07b4a0553b9f33598a Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Tue, 16 Aug 2016 09:04:02 -0700
Subject: [PATCH 2/2] libmultipath/checkers/tur: Call pthread_join() upon
 thread exit

pthread_cancel() cancels a thread asynchronously. Hence add a
pthread_join() call to avoid that the tur_checker_context is freed
before the tur_thread() function has finished. Introduce a new
variable to indicate whether or not the TUR thread is running such
that the thread ID can be preserved if a TUR thread exits. Ensure
that this new variable is protected consistently by
tur_checker_context.hldr_lock.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ad66918..7b789e0 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -43,6 +43,7 @@ struct tur_checker_context {
 	pthread_cond_t active;
 	pthread_spinlock_t hldr_lock;
 	int holders;
+	unsigned char thread_running:1;
 	char message[CHECKER_MSG_LEN];
 };
 
@@ -68,11 +69,24 @@ int libcheck_init (struct checker * c)
 	return 0;
 }
 
+static unsigned checker_thread_running(struct tur_checker_context *ct)
+{
+	unsigned thread_running;
+
+	pthread_spin_lock(&ct->hldr_lock);
+	thread_running = ct->thread_running;
+	pthread_spin_unlock(&ct->hldr_lock);
+
+	return thread_running;
+}
+
 void cleanup_context(struct tur_checker_context *ct)
 {
 	pthread_mutex_destroy(&ct->lock);
 	pthread_cond_destroy(&ct->active);
 	pthread_spin_destroy(&ct->hldr_lock);
+	if (ct->thread)
+		pthread_join(ct->thread, NULL);
 	free(ct);
 }
 
@@ -198,7 +212,7 @@ void cleanup_func(void *data)
 	pthread_spin_lock(&ct->hldr_lock);
 	ct->holders--;
 	holders = ct->holders;
-	ct->thread = 0;
+	ct->thread_running = 0;
 	pthread_spin_unlock(&ct->hldr_lock);
 	if (!holders)
 		cleanup_context(ct);
@@ -295,7 +309,7 @@ libcheck_check (struct checker * c)
 
 	if (ct->running) {
 		/* Check if TUR checker is still running */
-		if (ct->thread) {
+		if (checker_thread_running(ct)) {
 			if (tur_check_async_timeout(c)) {
 				condlog(3, "%d:%d: tur checker timeout",
 					TUR_DEVT(ct));
@@ -318,7 +332,7 @@ libcheck_check (struct checker * c)
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
-		if (ct->thread) {
+		if (checker_thread_running(ct)) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d: tur thread not responding",
@@ -331,6 +345,7 @@ libcheck_check (struct checker * c)
 		ct->timeout = c->timeout;
 		pthread_spin_lock(&ct->hldr_lock);
 		ct->holders++;
+		ct->thread_running = 1;
 		pthread_spin_unlock(&ct->hldr_lock);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
@@ -338,9 +353,9 @@ libcheck_check (struct checker * c)
 		if (r) {
 			pthread_spin_lock(&ct->hldr_lock);
 			ct->holders--;
+			ct->thread_running = 0;
 			pthread_spin_unlock(&ct->hldr_lock);
 			pthread_mutex_unlock(&ct->lock);
-			ct->thread = 0;
 			condlog(3, "%d:%d: failed to start tur thread, using"
 				" sync mode", TUR_DEVT(ct));
 			return tur_check(c->fd, c->timeout, c->message);
@@ -352,7 +367,7 @@ libcheck_check (struct checker * c)
 		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
 		c->message[CHECKER_MSG_LEN - 1] = '\0';
 		pthread_mutex_unlock(&ct->lock);
-		if (ct->thread &&
+		if (checker_thread_running(ct) &&
 		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
 			condlog(3, "%d:%d: tur checker still running",
 				TUR_DEVT(ct));
-- 
2.9.2


--------------C3584BF42247C0EC442A1DFE
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------C3584BF42247C0EC442A1DFE--
