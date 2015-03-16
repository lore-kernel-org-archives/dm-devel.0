From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 77/78] multipathd: asynchronous configuration
Date: Mon, 16 Mar 2015 13:37:04 +0100
Message-ID: <1426509425-15978-78-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

For initial configuration multipathd waits it has synchronized
with the existing setup. On larger systems this takes up quite
some time (I've measured 80 seconds on a system with 1024 paths)
causing systemd to stall and the system to fail booting.
This patch makes the initial configuration asynchronous, and
using the same codepath as the existing 'reconfigure' CLI
command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli_handlers.c |  5 ++-
 multipathd/main.c         | 79 ++++++++++++++++++++++++++++-------------------
 multipathd/main.h         |  1 +
 3 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index dc96c45..e51537e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -830,11 +830,10 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 int
 cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
-	struct vectors * vecs = (struct vectors *)data;
-
 	condlog(2, "reconfigure (operator)");
 
-	return reconfigure(vecs);
+	post_config_state(DAEMON_CONFIGURE);
+	return 0;
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index 6c98686..d9f2435 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -93,10 +93,11 @@ struct mpath_event_param
 unsigned int mpath_mx_alloc_len;
 
 int logsink;
-enum daemon_status running_state;
+enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
+pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
+pthread_cond_t config_cond = PTHREAD_COND_INITIALIZER;
 
-static sem_t exit_sem;
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -104,6 +105,21 @@ struct vectors * gvecs;
 
 struct udev * udev;
 
+static void config_cleanup(void *arg)
+{
+	pthread_mutex_unlock(&config_lock);
+}
+
+void post_config_state(enum daemon_status state)
+{
+	pthread_mutex_lock(&config_lock);
+	if (state != running_state) {
+		running_state = state;
+		pthread_cond_broadcast(&config_cond);
+	}
+	pthread_mutex_unlock(&config_lock);
+}
+
 static int
 need_switch_pathgroup (struct multipath * mpp, int refresh)
 {
@@ -860,6 +876,15 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	if (uev_discard(uev->devpath))
 		return 0;
 
+	pthread_cleanup_push(config_cleanup, NULL);
+	pthread_mutex_lock(&config_lock);
+	if (running_state != DAEMON_RUNNING)
+		pthread_cond_wait(&config_cond, &config_lock);
+	pthread_cleanup_pop(1);
+
+	if (running_state == DAEMON_SHUTDOWN)
+		return 0;
+
 	/*
 	 * device map event
 	 * Add events are ignored here as the tables
@@ -948,7 +973,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(ADD+MAP, cli_add_map);
 	set_handler_callback(DEL+MAP, cli_del_map);
 	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
-	set_handler_callback(RECONFIGURE, cli_reconfigure);
+	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
 	set_handler_callback(SUSPEND+MAP, cli_suspend);
 	set_handler_callback(RESUME+MAP, cli_resume);
 	set_handler_callback(RESIZE+MAP, cli_resize);
@@ -977,7 +1002,7 @@ uxlsnrloop (void * ap)
 void
 exit_daemon (void)
 {
-	sem_post(&exit_sem);
+	post_config_state(DAEMON_SHUTDOWN);
 }
 
 const char *
@@ -1561,8 +1586,6 @@ reconfigure (struct vectors * vecs)
 	struct config * old = conf;
 	int retval = 1;
 
-	running_state = DAEMON_CONFIGURE;
-
 	/*
 	 * free old map and path vectors ... they use old conf state
 	 */
@@ -1587,7 +1610,7 @@ reconfigure (struct vectors * vecs)
 		retval = 0;
 	}
 
-	running_state = DAEMON_RUNNING;
+	post_config_state(DAEMON_RUNNING);
 
 	return retval;
 }
@@ -1643,12 +1666,7 @@ handle_signals(void)
 {
 	if (reconfig_sig && running_state == DAEMON_RUNNING) {
 		condlog(2, "reconfigure (signal)");
-		pthread_cleanup_push(cleanup_lock,
-				&gvecs->lock);
-		lock(gvecs->lock);
-		pthread_testcancel();
-		reconfigure(gvecs);
-		lock_cleanup_pop(gvecs->lock);
+		post_config_state(DAEMON_CONFIGURE);
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
@@ -1781,7 +1799,6 @@ child (void * param)
 	char *envp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
-	sem_init(&exit_sem, 0, 0);
 	signal_init();
 
 	udev = udev_new();
@@ -1796,7 +1813,7 @@ child (void * param)
 		pthread_attr_destroy(&log_attr);
 	}
 
-	running_state = DAEMON_START;
+	post_config_state(DAEMON_START);
 
 #ifdef USE_SYSTEMD
 	sd_notify(0, "STATUS=startup");
@@ -1891,15 +1908,7 @@ child (void * param)
 #ifdef USE_SYSTEMD
 	sd_notify(0, "STATUS=configure");
 #endif
-	running_state = DAEMON_CONFIGURE;
-
-	lock(vecs->lock);
-	if (configure(vecs, 1)) {
-		unlock(vecs->lock);
-		condlog(0, "failure during configuration");
-		goto failed;
-	}
-	unlock(vecs->lock);
+	post_config_state(DAEMON_CONFIGURE);
 
 	/*
 	 * start threads
@@ -1918,20 +1927,29 @@ child (void * param)
 	pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
 	/* Ignore errors, we can live without */
 
-	running_state = DAEMON_RUNNING;
 #ifdef USE_SYSTEMD
 	sd_notify(0, "READY=1\nSTATUS=running");
 #endif
 
-	/*
-	 * exit path
-	 */
-	while(sem_wait(&exit_sem) != 0); /* Do nothing */
+	while (running_state != DAEMON_SHUTDOWN) {
+		pthread_cleanup_push(config_cleanup, NULL);
+		pthread_mutex_lock(&config_lock);
+		if (running_state == DAEMON_RUNNING) {
+			pthread_cond_wait(&config_cond, &config_lock);
+		}
+		pthread_cleanup_pop(1);
+		if (running_state == DAEMON_CONFIGURE) {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
+			reconfigure(vecs);
+			lock_cleanup_pop(vecs->lock);
+		}
+	}
 
 #ifdef USE_SYSTEMD
 	sd_notify(0, "STATUS=shutdown");
 #endif
-	running_state = DAEMON_SHUTDOWN;
 	lock(vecs->lock);
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
@@ -2066,7 +2084,6 @@ main (int argc, char *argv[])
 	int foreground = 0;
 
 	logsink = 1;
-	running_state = DAEMON_INIT;
 	dm_init();
 
 	if (getuid() != 0) {
diff --git a/multipathd/main.h b/multipathd/main.h
index 1813633..6edf4ab 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -25,6 +25,7 @@ int ev_remove_path (struct path *, struct vectors *);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
+void post_config_state(enum daemon_status);
 void * mpath_alloc_prin_response(int prin_sa);
 int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
        int noisy);
-- 
1.8.4.5
