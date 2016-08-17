From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 12:57:15 -0700
Message-ID: <c7ce9f1d-861e-a9a8-443f-8f921ce742df@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<CAAZtj81LAeoq8Duvu1hLzyOFNp0B_ZAfcqyQAMvmQd19jRLw8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------7EB562FD1EE72DD21796283E"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAZtj81LAeoq8Duvu1hLzyOFNp0B_ZAfcqyQAMvmQd19jRLw8A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dragan Stancevic <dragan.stancevic@canonical.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--------------7EB562FD1EE72DD21796283E
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 08/17/2016 12:36 PM, Dragan Stancevic wrote:
> Acked-by: dragan.stancevic@canonical.com
> <mailto:dragan.stancevic@canonical.com>
>
> I agree with your patch, I have been tracking an issue where multipathd
> dumps core on the exit path just past the treads being canceled. Your
> patch is very similar to mine (minus nuking the depth) that I was going
> to send out to a user to test with. The checker thread accesses a valid
> pointer with garbage values....

Hello Dragan,

When I prepared my patch I overlooked that multipathd creates most 
threads as detached threads. So I started testing the three attached 
patches on my setup. It would be appreciated if you could have a look at 
these patches.

Thanks,

Bart.

--------------7EB562FD1EE72DD21796283E
Content-Type: text/x-patch;
	name="0001-multipathd-Change-four-threads-from-detached-into-jo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-multipathd-Change-four-threads-from-detached-into-jo.pa";
	filename*1="tch"

From 7d8b5dc15d53f43ae16f7ebebc96052e6208f566 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Wed, 17 Aug 2016 09:52:54 -0700
Subject: [PATCH 1/3] multipathd: Change four threads from detached into
 joinable

Change the CLI listener, checker loop, uevent dispatcher and
uevent listener threads from detached into joinable threads.
This change is needed because calling pthread_join() is only
allowed for joinable threads.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2be6cb2..6b3c856 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2216,8 +2216,8 @@ child (void * param)
 	signal_init();
 	rcu_init();
 
-	setup_thread_attr(&misc_attr, 64 * 1024, 1);
-	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 1);
+	setup_thread_attr(&misc_attr, 64 * 1024, 0);
+	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
 	if (logsink == 1) {
-- 
2.9.2


--------------7EB562FD1EE72DD21796283E
Content-Type: text/x-patch;
	name="0002-libmultipath-checkers-tur-Introduce-checker_thread_r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-libmultipath-checkers-tur-Introduce-checker_thread_r.pa";
	filename*1="tch"

From 4d0c245641d80a5fd10833333dc288a5a9293ee9 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Wed, 17 Aug 2016 09:57:39 -0700
Subject: [PATCH 2/3] libmultipath/checkers/tur: Introduce
 checker_thread_running()

Additionally, protect tur_checker_context.thread reads via
hldr_lock. This avoids that data race detection tools complain
about reads of the member variable 'thread'.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index ad66918..c014b65 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -68,6 +68,17 @@ int libcheck_init (struct checker * c)
 	return 0;
 }
 
+static int checker_thread_running(struct tur_checker_context *ct)
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
 void cleanup_context(struct tur_checker_context *ct)
 {
 	pthread_mutex_destroy(&ct->lock);
@@ -295,7 +306,7 @@ libcheck_check (struct checker * c)
 
 	if (ct->running) {
 		/* Check if TUR checker is still running */
-		if (ct->thread) {
+		if (checker_thread_running(ct)) {
 			if (tur_check_async_timeout(c)) {
 				condlog(3, "%d:%d: tur checker timeout",
 					TUR_DEVT(ct));
@@ -318,7 +329,7 @@ libcheck_check (struct checker * c)
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
-		if (ct->thread) {
+		if (checker_thread_running(ct)) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d: tur thread not responding",
@@ -352,7 +363,7 @@ libcheck_check (struct checker * c)
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


--------------7EB562FD1EE72DD21796283E
Content-Type: text/x-patch;
	name="0003-libmultipath-checkers-tur-Fix-race-related-to-thread.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0003-libmultipath-checkers-tur-Fix-race-related-to-thread.pa";
	filename*1="tch"

From e1144d5321f87bc72e6fb29b40cf7728125aa926 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Wed, 17 Aug 2016 09:58:09 -0700
Subject: [PATCH 3/3] libmultipath/checkers/tur: Fix race related to thread
 termination

Since the tur thread is a detached thread, all data structures
associated with that thread are freed once the thread stops. Avoid
that pthread_cancel() triggers a use-after-free by protecting
pthread_cancel() calls with the same spinlock that protects ct->thread.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index c014b65..f724350 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2004 Christophe Varoqui
  */
+#include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -98,10 +99,11 @@ void libcheck_free (struct checker * c)
 		ct->holders--;
 		holders = ct->holders;
 		thread = ct->thread;
-		pthread_spin_unlock(&ct->hldr_lock);
 		if (holders)
 			pthread_cancel(thread);
-		else
+		pthread_spin_unlock(&ct->hldr_lock);
+
+		if (!holders)
 			cleanup_context(ct);
 		c->context = NULL;
 	}
@@ -207,6 +209,7 @@ void cleanup_func(void *data)
 	int holders;
 	struct tur_checker_context *ct = data;
 	pthread_spin_lock(&ct->hldr_lock);
+	assert(ct->holders > 0);
 	ct->holders--;
 	holders = ct->holders;
 	ct->thread = 0;
@@ -310,7 +313,12 @@ libcheck_check (struct checker * c)
 			if (tur_check_async_timeout(c)) {
 				condlog(3, "%d:%d: tur checker timeout",
 					TUR_DEVT(ct));
-				pthread_cancel(ct->thread);
+
+				pthread_spin_lock(&ct->hldr_lock);
+				if (ct->holders > 0)
+					pthread_cancel(ct->thread);
+				pthread_spin_unlock(&ct->hldr_lock);
+
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
 				tur_status = PATH_TIMEOUT;
@@ -349,9 +357,9 @@ libcheck_check (struct checker * c)
 		if (r) {
 			pthread_spin_lock(&ct->hldr_lock);
 			ct->holders--;
+			ct->thread = 0;
 			pthread_spin_unlock(&ct->hldr_lock);
 			pthread_mutex_unlock(&ct->lock);
-			ct->thread = 0;
 			condlog(3, "%d:%d: failed to start tur thread, using"
 				" sync mode", TUR_DEVT(ct));
 			return tur_check(c->fd, c->timeout, c->message);
-- 
2.9.2


--------------7EB562FD1EE72DD21796283E
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------7EB562FD1EE72DD21796283E--
