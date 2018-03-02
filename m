From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: fix inverted signal blocking logic
Date: Fri,  2 Mar 2018 22:18:07 +0100
Message-ID: <20180302211807.11434-1-mwilck@suse.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180302200048.GJ14513@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2018-03-02 at 14:00 -0600, Benjamin Marzinski wrote:

> But
> in any case, after commit 534ec4c, we are only blocking SIGUSR2 on
> all
> threads, which is the only signal we don't need to block.  This means

I can see what you mean. Better like this, maybe?

multipathd is supposed to block all signals in all threads, except
the uxlsnr thread which handles termination and reconfiguration
signals (SIGUSR1) in its ppoll() call, SIGUSR2 in the waiter thread, and
occasional SIGALRM. The current logic does exactly the opposite, it blocks
termination signals in SIGPOLL and allows multipathd to be killed e.g.
by SIGALRM.

Fix that bin inverting the logic. The argument to pthread_sigmask and
ppoll is the set of *blocked* signals, not vice versa.

Fixes: 534ec4c "multipathd: Ensure that SIGINT, SIGTERM, SIGHUP and SIGUSR1
are delivered to the uxsock thread"

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   |  7 +++++--
 multipathd/uxlsnr.c | 10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 61739ac6ea59..85ee9b713d75 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2270,10 +2270,13 @@ signal_init(void)
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
