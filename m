From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 7/8] signal waiter thread to stop waiting on dm
	events
Date: Fri, 28 Jun 2013 18:26:20 -0500
Message-ID: <1372461981-6333-8-git-send-email-bmarzins@redhat.com>
References: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
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

The ioctl syscall is not a pthread cancellation point. So, when
device-mapper is waiting on events, pthread_cancel won't cancel
the waiter thread.  This patch makes the waiter threads handle
SIGUSR2, and has stop_waiter_thread() signal it to break out of
waiting on dm events. Unfortunately, there is still a possibility
of the signal arriving before the ioctl, and the waiter thread
still hanging until the devices are reloaded.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/waiter.c | 9 +++++++++
 multipathd/main.c     | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 5094290..7cedd4b 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -57,6 +57,7 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
 	pthread_cancel(thread);
+	pthread_kill(thread, SIGUSR2);
 }
 
 /*
@@ -65,6 +66,7 @@ void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
  */
 int waiteventloop (struct event_thread *waiter)
 {
+	sigset_t set, oldset;
 	int event_nr;
 	int r;
 
@@ -97,8 +99,15 @@ int waiteventloop (struct event_thread *waiter)
 	dm_task_no_open_count(waiter->dmt);
 
 	/* wait */
+	sigemptyset(&set);
+	sigaddset(&set, SIGUSR2);
+	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
+
+	pthread_testcancel();
 	r = dm_task_run(waiter->dmt);
+	pthread_testcancel();
 
+	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
 	dm_task_destroy(waiter->dmt);
 	waiter->dmt = NULL;
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 0fa1b17..82f8577 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1501,6 +1501,12 @@ sigusr1 (int sig)
 }
 
 static void
+sigusr2 (int sig)
+{
+	condlog(3, "SIGUSR2 received");
+}
+
+static void
 signal_init(void)
 {
 	sigset_t set;
@@ -1508,10 +1514,12 @@ signal_init(void)
 	sigemptyset(&set);
 	sigaddset(&set, SIGHUP);
 	sigaddset(&set, SIGUSR1);
+	sigaddset(&set, SIGUSR2);
 	pthread_sigmask(SIG_BLOCK, &set, NULL);
 
 	signal_set(SIGHUP, sighup);
 	signal_set(SIGUSR1, sigusr1);
+	signal_set(SIGUSR2, sigusr2);
 	signal_set(SIGINT, sigend);
 	signal_set(SIGTERM, sigend);
 	signal(SIGPIPE, SIG_IGN);
-- 
1.8.2
