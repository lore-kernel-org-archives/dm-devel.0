From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 5/6] multipathd: add code to handle blocked
	signals
Date: Fri,  4 Jan 2019 18:59:13 +0100
Message-ID: <20190104175914.22784-6-mwilck@suse.com>
References: <20190104175914.22784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190104175914.22784-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd blocks all signals except in the uxlsnr thread.
Add some code to handle signals even while they're blocked.

If a shutdown signal is received, deliver_pending_signals() returns
TRUE. This is not the same as should_exit(), it's just a friendly
warning to the caller that shutdown/thread cancellation is imminent.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 +++++++++++++++++++++++++
 multipathd/main.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 569a27ac..6276d34c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2614,6 +2614,31 @@ signal_init(void)
 	signal_set(SIGPIPE, sigend);
 }
 
+bool deliver_pending_signals(void)
+{
+	sigset_t set;
+	bool ret = exit_sig;
+
+	if (sigpending(&set) != 0)
+		return false;
+
+	if (sigismember(&set, SIGTERM) ||
+	    sigismember(&set, SIGPIPE) ||
+	    sigismember(&set, SIGINT)) {
+		sigend(SIGTERM);
+		ret = true;
+	}
+	if (sigismember(&set, SIGHUP))
+		sighup(SIGHUP);
+	if (sigismember(&set, SIGUSR1))
+		sigusr1(SIGUSR1);
+	if (sigismember(&set, SIGUSR2))
+		sigusr2(SIGUSR2);
+
+	handle_signals(false);
+	return ret;
+}
+
 static void
 setscheduler (void)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index 8fd426b0..2b77b44b 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -39,6 +39,7 @@ void * mpath_pr_event_handler_fn (void * );
 int update_map_pr(struct multipath *mpp);
 void * mpath_pr_event_handler_fn (void * pathp );
 void handle_signals(bool);
+bool deliver_pending_signals(void);
 int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
 #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
-- 
2.19.2
