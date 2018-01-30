From: Wuchongyun <wu.chongyun@h3c.com>
Subject: [PATCH]multipathd: threads cancellation can't work if
 new poll arrival just after restart multipath
Date: Tue, 30 Jan 2018 09:58:52 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

Hi Christophe, Hannes, Martin, Xose, Benjamin and other reviewers

Please help to review this patch, thanks.

Issue:
When restart multipath-tools service, if there is a connection request
or a command at this time, all multipathd related thread cancellation
will not work, all cleanup hook functions will not be called.

Because uxsock_listen will get this poll(poll_count = ppoll()) and the
poll_count will not be 0, in this loop handle_signals() will not be
called. After uxsock_listen finish this connection process, it will take
5 seconds in ppoll() to get a new session, after then it have the chance
to call handle_signals(). In this case uxsock_listen will wait more than
5 seconds to call handle_signals() to hand all multipathd related
process' thread cancellation.  Unfortunately there is only 5 seconds for
thread cancellation, after 5 seconds if the cancellation not finish
multipathd will killed by force. In this case thread cancellation will
have no chance to be processed.

So may be we should process exit signal as qickly as we can. After
finishing ppoll call handle_exit_sig() first, if there is a exit signal
ignore other signals and commands. If we insist on finishing all the new
coming commands and other signals, we will face the risk that all cleanup
functions will not be called and  also the new coming command can't
been fully implemented.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
 multipathd/main.c   |   18 +++++++++++++-----
 multipathd/main.h   |    1 +
 multipathd/uxlsnr.c |    8 ++++++++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index dedc7d2..2ee2538 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2237,10 +2237,6 @@ signal_set(int signo, void (*func) (int))
 void
 handle_signals(void)
 {
-	if (exit_sig) {
-		condlog(2, "exit (signal)");
-		exit_daemon();
-	}
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
 		set_config_state(DAEMON_CONFIGURE);
@@ -2251,11 +2247,23 @@ handle_signals(void)
 		log_reset("multipathd");
 		pthread_mutex_unlock(&logq_lock);
 	}
-	exit_sig = 0;
 	reconfig_sig = 0;
 	log_reset_sig = 0;
 }
 
+int
+handle_exit_sig(void)
+{
+	if (exit_sig) {
+		condlog(2, "exit (signal)");
+		exit_daemon();
+		exit_sig = 0;
+		return 1;
+	}
+
+	return 0;
+}
+
 static void
 sighup (int sig)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index ededdab..d769fcf 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -39,5 +39,6 @@ void * mpath_pr_event_handler_fn (void * );
 int update_map_pr(struct multipath *mpp);
 void * mpath_pr_event_handler_fn (void * pathp );
 void handle_signals(void);
+int handle_exit_sig(void);
 
 #endif /* MAIN_H */
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 8aa0f83..9b2f95a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -240,6 +240,14 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		/* most of our life is spent in this call */
 		poll_count = ppoll(polls, i, &sleep_time, &mask);
 
+		/*
+		* should process exit signal as qickly as we can
+		* otherwise multipathd will be killed by force
+		*/
+		if (handle_exit_sig()) {
+			continue;
+		}
+
 		if (poll_count == -1) {
 			if (errno == EINTR) {
 				handle_signals();
-- 
1.7.9.5
