From: Marius Bakke <marius@devup.no>
Subject: [PATCH v2] multipath: Fix compiler warnings when built
	without systemd.
Date: Wed, 17 Jun 2020 01:11:26 +0200
Message-ID: <20200616231126.18538-1-marius@devup.no>
References: <d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Add ifdef guards for code that is unused when systemd is not available.
---
 libmultipath/config.c |  6 ++++--
 multipathd/main.c     | 10 +++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b4d87689..658bec8b 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -696,9 +696,9 @@ process_config_dir(struct config *conf, char *dir)
 	pthread_cleanup_pop(1);
 }
 
+#ifdef USE_SYSTEMD
 static void set_max_checkint_from_watchdog(struct config *conf)
 {
-#ifdef USE_SYSTEMD
 	char *envp = getenv("WATCHDOG_USEC");
 	unsigned long checkint;
 
@@ -714,8 +714,8 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 		condlog(3, "enabling watchdog, interval %ld", checkint);
 		conf->use_watchdog = true;
 	}
-#endif
 }
+#endif
 
 struct config *
 load_config (char * file)
@@ -789,7 +789,9 @@ load_config (char * file)
 	/*
 	 * fill the voids left in the config file
 	 */
+#ifdef USE_SYSTEMD
 	set_max_checkint_from_watchdog(conf);
+#endif
 	if (conf->max_checkint == 0) {
 		if (conf->checkint == CHECKINT_UNDEF)
 			conf->checkint = DEFAULT_CHECKINT;
diff --git a/multipathd/main.c b/multipathd/main.c
index 8baf9abe..ac8ae4c2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -176,6 +176,7 @@ daemon_status(void)
 /*
  * I love you too, systemd ...
  */
+#ifdef USE_SYSTEMD
 static const char *
 sd_notify_status(enum daemon_status state)
 {
@@ -195,7 +196,6 @@ sd_notify_status(enum daemon_status state)
 	return NULL;
 }
 
-#ifdef USE_SYSTEMD
 static void do_sd_notify(enum daemon_status old_state,
 			 enum daemon_status new_state)
 {
@@ -247,7 +247,9 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 static void __post_config_state(enum daemon_status state)
 {
 	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
+#ifdef USE_SYSTEMD
 		enum daemon_status old_state = running_state;
+#endif
 
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
@@ -272,7 +274,9 @@ int set_config_state(enum daemon_status state)
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
 	if (running_state != state) {
+#ifdef USE_SYSTEMD
 		enum daemon_status old_state = running_state;
+#endif
 
 		if (running_state == DAEMON_SHUTDOWN)
 			rc = EINVAL;
@@ -2280,7 +2284,9 @@ checkerloop (void *ap)
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
+#ifdef USE_SYSTEMD
 	bool use_watchdog;
+#endif
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
@@ -2294,7 +2300,9 @@ checkerloop (void *ap)
 
 	/* use_watchdog is set from process environment and never changes */
 	conf = get_multipath_config();
+#ifdef USE_SYSTEMD
 	use_watchdog = conf->use_watchdog;
+#endif
 	put_multipath_config(conf);
 
 	while (1) {
-- 
2.26.2
