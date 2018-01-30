From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2] multipath-tools: handle exit signal
	immediately
Date: Tue, 30 Jan 2018 15:16:24 +0100
Message-ID: <20180130141624.27439-1-mwilck@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Guozhonghua <guozhonghua@h3c.com>, dm-devel@redhat.com, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

multipathd shouldn't try to service any more client connections
when it receives an exit signal. Moreover, ppoll() can return
success even if signals occured. So check for reconfigure or
log_reset signals after handling pending client requests.

Based on an analysis by Chongyun Wu.

Reported-by: Chongyun Wu <wu.chongyun@h3c.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   | 6 ++++--
 multipathd/main.h   | 2 +-
 multipathd/uxlsnr.c | 7 +++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27cf234623d0..8e96f5dd2d7f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2184,12 +2184,15 @@ signal_set(int signo, void (*func) (int))
 }
 
 void
-handle_signals(void)
+handle_signals(bool nonfatal)
 {
 	if (exit_sig) {
 		condlog(2, "exit (signal)");
+		exit_sig = 0;
 		exit_daemon();
 	}
+	if (!nonfatal)
+		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
 		set_config_state(DAEMON_CONFIGURE);
@@ -2200,7 +2203,6 @@ handle_signals(void)
 		log_reset("multipathd");
 		pthread_mutex_unlock(&logq_lock);
 	}
-	exit_sig = 0;
 	reconfig_sig = 0;
 	log_reset_sig = 0;
 }
diff --git a/multipathd/main.h b/multipathd/main.h
index ededdaba32fe..e8140feaf291 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -38,6 +38,6 @@ int mpath_pr_event_handle(struct path *pp);
 void * mpath_pr_event_handler_fn (void * );
 int update_map_pr(struct multipath *mpp);
 void * mpath_pr_event_handler_fn (void * pathp );
-void handle_signals(void);
+void handle_signals(bool);
 
 #endif /* MAIN_H */
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 98ac25a68c43..dc116cf2515b 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -221,9 +221,10 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		/* most of our life is spent in this call */
 		poll_count = ppoll(polls, i, &sleep_time, &mask);
 
+		handle_signals(false);
 		if (poll_count == -1) {
 			if (errno == EINTR) {
-				handle_signals();
+				handle_signals(true);
 				continue;
 			}
 
@@ -233,7 +234,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		}
 
 		if (poll_count == 0) {
-			handle_signals();
+			handle_signals(true);
 			continue;
 		}
 
@@ -292,6 +293,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				FREE(inbuf);
 			}
 		}
+		/* see if we got a non-fatal signal */
+		handle_signals(true);
 
 		/* see if we got a new client */
 		if (polls[0].revents & POLLIN) {
-- 
2.16.1
