From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/23] multipathd: fix signal blocking logic
Date: Tue,  6 Mar 2018 00:15:07 +0100
Message-ID: <20180305231507.10386-24-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd is supposed to block all signals in all threads, except
the uxlsnr thread which handles termination and reconfiguration
signals (SIGUSR1) in its ppoll() call, SIGUSR2 in the waiter thread
and the marginal path checker thread, and occasional SIGALRM. The current
logic does exactly the oppsite, it blocks termination signals in SIGPOLL and
allows multipathd to be killed e.g. by SIGALRM.

Fix that by inverting the logic. The argument to pthread_sigmask and
ppoll is the set of *blocked* signals, not vice versa.

The marginal paths code needs to unblock SIGUSR2 now explicity, as
the dm-event waiter code already does. Doing this with pselect()
avoids asynchronous cancellation.

Fixes: 810082e "libmultipath, multipathd: Rework SIGPIPE handling"
Fixes: 534ec4c "multipathd: Ensure that SIGINT, SIGTERM, SIGHUP and SIGUSR1
are delivered to the uxsock thread"

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c | 17 ++++++++++++++++-
 multipathd/main.c          |  7 +++++--
 multipathd/uxlsnr.c        | 10 +++++-----
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 5b10f0372f9f..00bac9e0e755 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -21,6 +21,7 @@
 #include <libaio.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/select.h>
 
 #include "vector.h"
 #include "memory.h"
@@ -691,14 +692,28 @@ static void service_paths(void)
 
 static void *io_err_stat_loop(void *data)
 {
+	sigset_t set;
+
 	vecs = (struct vectors *)data;
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
+	sigfillset(&set);
+	sigdelset(&set, SIGUSR2);
+
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	while (1) {
+		struct timespec ts;
+
 		service_paths();
-		usleep(100000);
+
+		ts.tv_sec = 0;
+		ts.tv_nsec = 100 * 1000 * 1000;
+		/*
+		 * pselect() with no fds, a timeout, and a sigmask:
+		 * sleep for 100ms and react on SIGUSR2.
+		 */
+		pselect(1, NULL, NULL, NULL, &ts, &set);
 	}
 
 	pthread_cleanup_pop(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index 4abdd8f071c3..68595836d723 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2261,10 +2261,13 @@ signal_init(void)
 {
 	sigset_t set;
 
-	sigemptyset(&set);
-	sigaddset(&set, SIGUSR2);
+	/* block all signals */
+	sigfillset(&set);
+	/* SIGPIPE occurs if logging fails */
+	sigdelset(&set, SIGPIPE);
 	pthread_sigmask(SIG_SETMASK, &set, NULL);
 
+	/* Other signals will be unblocked in the uxlsnr thread */
 	signal_set(SIGHUP, sighup);
 	signal_set(SIGUSR1, sigusr1);
 	signal_set(SIGUSR2, sigusr2);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 98ac25a68c43..a2ca36ba1653 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -170,11 +170,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		condlog(0, "uxsock: failed to allocate poll fds");
 		return NULL;
 	}
-	sigemptyset(&mask);
-	sigaddset(&mask, SIGINT);
-	sigaddset(&mask, SIGTERM);
-	sigaddset(&mask, SIGHUP);
-	sigaddset(&mask, SIGUSR1);
+	sigfillset(&mask);
+	sigdelset(&mask, SIGINT);
+	sigdelset(&mask, SIGTERM);
+	sigdelset(&mask, SIGHUP);
+	sigdelset(&mask, SIGUSR1);
 	while (1) {
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
-- 
2.16.1
