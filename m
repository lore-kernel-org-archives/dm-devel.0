From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 5/7] multipathd: set DAEMON_CONFIGURE from
	uxlsnr thread
Date: Tue, 30 Oct 2018 22:22:47 +0100
Message-ID: <20181030212249.31127-6-mwilck@suse.com>
References: <20181030212249.31127-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030212249.31127-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Commit ee01e841 had the intention to make multipathd quit if
the client socket couldn't be set up, because the unix socket
listener is vital for signal handling in multipathd.
But during startup, this condition might be lost if the main
thread doesn't wait for the unix listener to initialize.

Fixes: ee01e841 "multipathd: handle errors in uxlsnr as fatal"

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e45e45dc..1b9b6e18 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -204,9 +204,8 @@ static void config_cleanup(void *arg)
 	pthread_mutex_unlock(&config_lock);
 }
 
-void post_config_state(enum daemon_status state)
+static void __post_config_state(enum daemon_status state)
 {
-	pthread_mutex_lock(&config_lock);
 	if (state != running_state) {
 		enum daemon_status old_state = running_state;
 
@@ -216,7 +215,14 @@ void post_config_state(enum daemon_status state)
 		do_sd_notify(old_state);
 #endif
 	}
-	pthread_mutex_unlock(&config_lock);
+}
+
+void post_config_state(enum daemon_status state)
+{
+	pthread_mutex_lock(&config_lock);
+	pthread_cleanup_push(config_cleanup, NULL);
+	__post_config_state(state);
+	pthread_cleanup_pop(1);
 }
 
 int set_config_state(enum daemon_status state)
@@ -1511,6 +1517,10 @@ uxlsnrloop (void * ap)
 		exit_daemon();
 		goto out;
 	}
+
+	/* Tell main thread that thread has started */
+	post_config_state(DAEMON_CONFIGURE);
+
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
 	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
@@ -2728,11 +2738,26 @@ child (void * param)
 	 */
 	conf = NULL;
 
-	/*
-	 * Signal start of configuration
-	 */
-	post_config_state(DAEMON_CONFIGURE);
+	pthread_cleanup_push(config_cleanup, NULL);
+	pthread_mutex_lock(&config_lock);
 
+	__post_config_state(DAEMON_IDLE);
+	rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs);
+	if (!rc) {
+		/* Wait for uxlsnr startup */
+		while (running_state == DAEMON_IDLE)
+			pthread_cond_wait(&config_cond, &config_lock);
+	}
+	pthread_cleanup_pop(1);
+
+	if (rc) {
+		condlog(0, "failed to create cli listener: %d", rc);
+		goto failed;
+	}
+	else if (running_state != DAEMON_CONFIGURE) {
+		condlog(0, "cli listener failed to start");
+		goto failed;
+	}
 
 	if (poll_dmevents) {
 		if (init_dmevent_waiter(vecs)) {
@@ -2755,10 +2780,6 @@ child (void * param)
 		goto failed;
 	}
 	pthread_attr_destroy(&uevent_attr);
-	if ((rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs))) {
-		condlog(0, "failed to create cli listener: %d", rc);
-		goto failed;
-	}
 
 	/*
 	 * start threads
-- 
2.19.1
