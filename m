From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH RESEND 3/3] multipathd: protect all access to
	running_state
Date: Thu, 11 Apr 2019 12:27:14 +0200
Message-ID: <20190411102714.12026-4-mwilck@suse.com>
References: <20190411102714.12026-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190411102714.12026-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Chonyun Wu's latest patch has shown that the handling of the daemon
state variable running_state is racy and difficult to get right. It's
not a good candidate for a "benign race" annotation. So, as a first
step to sanitizing it, make sure all accesses to the state variable
are protected by config_lock.

The patch also replaces "if" with "while" in several places where the
code was supposed to wait until a certain state was reached. It's
important that DAEMON_SHUTDOWN terminates all loops of this kind.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 58 +++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 47aff2d8..c8a8529c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -127,11 +127,22 @@ int poll_dmevents = 0;
 #else
 int poll_dmevents = 1;
 #endif
+/* Don't access this variable without holding config_lock */
 enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t config_cond;
 
+static inline enum daemon_status get_running_state(void)
+{
+	enum daemon_status st;
+
+	pthread_mutex_lock(&config_lock);
+	st = running_state;
+	pthread_mutex_unlock(&config_lock);
+	return st;
+}
+
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -149,7 +160,7 @@ static volatile sig_atomic_t log_reset_sig;
 const char *
 daemon_status(void)
 {
-	switch (running_state) {
+	switch (get_running_state()) {
 	case DAEMON_INIT:
 		return "init";
 	case DAEMON_START:
@@ -169,10 +180,10 @@ daemon_status(void)
 /*
  * I love you too, systemd ...
  */
-const char *
-sd_notify_status(void)
+static const char *
+sd_notify_status(enum daemon_status state)
 {
-	switch (running_state) {
+	switch (state) {
 	case DAEMON_INIT:
 		return "STATUS=init";
 	case DAEMON_START:
@@ -189,17 +200,18 @@ sd_notify_status(void)
 }
 
 #ifdef USE_SYSTEMD
-static void do_sd_notify(enum daemon_status old_state)
+static void do_sd_notify(enum daemon_status old_state,
+			 enum daemon_status new_state)
 {
 	/*
 	 * Checkerloop switches back and forth between idle and running state.
 	 * No need to tell systemd each time.
 	 * These notifications cause a lot of overhead on dbus.
 	 */
-	if ((running_state == DAEMON_IDLE || running_state == DAEMON_RUNNING) &&
+	if ((new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING) &&
 	    (old_state == DAEMON_IDLE || old_state == DAEMON_RUNNING))
 		return;
-	sd_notify(0, sd_notify_status());
+	sd_notify(0, sd_notify_status(new_state));
 }
 #endif
 
@@ -208,6 +220,7 @@ static void config_cleanup(void *arg)
 	pthread_mutex_unlock(&config_lock);
 }
 
+/* must be called with config_lock held */
 static void __post_config_state(enum daemon_status state)
 {
 	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
@@ -216,7 +229,7 @@ static void __post_config_state(enum daemon_status state)
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
 #ifdef USE_SYSTEMD
-		do_sd_notify(old_state);
+		do_sd_notify(old_state, state);
 #endif
 	}
 }
@@ -253,7 +266,7 @@ int set_config_state(enum daemon_status state)
 			running_state = state;
 			pthread_cond_broadcast(&config_cond);
 #ifdef USE_SYSTEMD
-			do_sd_notify(old_state);
+			do_sd_notify(old_state, state);
 #endif
 		}
 	}
@@ -1397,17 +1410,20 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	int r = 0;
 	struct vectors * vecs;
 	struct uevent *merge_uev, *tmp;
+	enum daemon_status state;
 
 	vecs = (struct vectors *)trigger_data;
 
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
-	if (running_state != DAEMON_IDLE &&
-	    running_state != DAEMON_RUNNING)
+	while (running_state != DAEMON_IDLE &&
+	       running_state != DAEMON_RUNNING &&
+	       running_state != DAEMON_SHUTDOWN)
 		pthread_cond_wait(&config_cond, &config_lock);
+	state = running_state;
 	pthread_cleanup_pop(1);
 
-	if (running_state == DAEMON_SHUTDOWN)
+	if (state == DAEMON_SHUTDOWN)
 		return 0;
 
 	/*
@@ -2755,6 +2771,7 @@ child (void * param)
 	struct config *conf;
 	char *envp;
 	int queue_without_daemon;
+	enum daemon_status state;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
@@ -2852,6 +2869,7 @@ child (void * param)
 		/* Wait for uxlsnr startup */
 		while (running_state == DAEMON_IDLE)
 			pthread_cond_wait(&config_cond, &config_lock);
+		state = running_state;
 	}
 	pthread_cleanup_pop(1);
 
@@ -2859,7 +2877,7 @@ child (void * param)
 		condlog(0, "failed to create cli listener: %d", rc);
 		goto failed;
 	}
-	else if (running_state != DAEMON_CONFIGURE) {
+	else if (state != DAEMON_CONFIGURE) {
 		condlog(0, "cli listener failed to start");
 		goto failed;
 	}
@@ -2899,15 +2917,17 @@ child (void * param)
 	}
 	pthread_attr_destroy(&misc_attr);
 
-	while (running_state != DAEMON_SHUTDOWN) {
+	while (1) {
 		pthread_cleanup_push(config_cleanup, NULL);
 		pthread_mutex_lock(&config_lock);
-		if (running_state != DAEMON_CONFIGURE &&
-		    running_state != DAEMON_SHUTDOWN) {
+		while (running_state != DAEMON_CONFIGURE &&
+		       running_state != DAEMON_SHUTDOWN)
 			pthread_cond_wait(&config_cond, &config_lock);
-		}
+		state = running_state;
 		pthread_cleanup_pop(1);
-		if (running_state == DAEMON_CONFIGURE) {
+		if (state == DAEMON_SHUTDOWN)
+			break;
+		if (state == DAEMON_CONFIGURE) {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
@@ -3077,8 +3097,6 @@ main (int argc, char *argv[])
 
 	ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf, sizeof(multipath_conf),
 				   "Manipulated through RCU");
-	ANNOTATE_BENIGN_RACE_SIZED(&running_state, sizeof(running_state),
-		"Suppress complaints about unprotected running_state reads");
 	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
 		"Suppress complaints about this scalar variable");
 
-- 
2.21.0
