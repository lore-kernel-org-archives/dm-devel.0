From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/3] set pthread stack size to at least
	PTHREAD_STACK_MIN
Date: Thu, 12 Mar 2009 13:38:12 -0500
Message-ID: <1236883093-2989-3-git-send-email-bmarzins@redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Attempting to set the stacksize of a pthread to below
PTHREAD_STACK_MIN causes pthread_attr_setstacksize() to fail, which
means that the thread will use the default stack size.  This fix
makes sure that multipathd never requests a stack size less than
PTHREAD_STACK_MIN.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log_pthread.c |    6 +++++-
 libmultipath/waiter.c      |    5 ++++-
 multipathd/main.c          |    5 ++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index a1d4a10..5d2fe76 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <pthread.h>
 #include <sys/mman.h>
+#include <limits.h>
 
 #include <memory.h>
 
@@ -52,6 +53,7 @@ static void * log_thread (void * et)
 
 void log_thread_start (void)
 {
+	size_t stacksize = 64 * 1024;
 	pthread_attr_t attr;
 
 	logdbg(stderr,"enter log_thread_start\n");
@@ -65,7 +67,9 @@ void log_thread_start (void)
 	pthread_cond_init(logev_cond, NULL);
 
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 
 	if (log_init("multipathd", 0)) {
 		fprintf(stderr,"can't initialize log buffer\n");
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 54cd19f..4d449e1 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -194,6 +194,7 @@ void *waitevent (void *et)
 
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 {
+	size_t stacksize = 32 * 1024;
 	pthread_attr_t attr;
 	struct event_thread *wp;
 
@@ -203,7 +204,9 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	if (pthread_attr_init(&attr))
 		goto out;
 
-	pthread_attr_setstacksize(&attr, 32 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
 	wp = alloc_waiter();
diff --git a/multipathd/main.c b/multipathd/main.c
index 98153df..dae9152 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1267,6 +1267,7 @@ set_oom_adj (int val)
 static int
 child (void * param)
 {
+	size_t stacksize = 64 * 1024;
 	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t attr;
 	struct vectors * vecs;
@@ -1347,7 +1348,9 @@ child (void * param)
 	 * start threads
 	 */
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 64 * 1024);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	pthread_attr_setstacksize(&attr, stacksize);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
 	pthread_create(&check_thr, &attr, checkerloop, vecs);
-- 
1.5.3.3
