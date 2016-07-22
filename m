From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipathd: Correctly invalidate configuration
	during shutdown
Date: Fri, 22 Jul 2016 13:04:25 +0200
Message-ID: <1469185465-12287-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

We still need to use rcu primitives when shutting down the system;
the original configuration might have become invalidated.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs_vec.c |  2 ++
 multipathd/main.c          | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index adb1911..a0c8869 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -409,10 +409,12 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 			mpp->alias);
 	}
 	if (reset) {
+		conf = get_multipath_config();
 		select_rr_weight(conf, mpp);
 		select_pgfailback(conf, mpp);
 		set_no_path_retry(conf, mpp);
 		select_flush_on_last_del(conf, mpp);
+		put_multipath_config(conf);
 		if (VECTOR_SIZE(mpp->paths) != 0)
 			dm_cancel_deferred_remove(mpp);
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 8784307..3eeb4c6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2245,7 +2245,7 @@ child (void * param)
 	if (ignore_new_devs)
 		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
-	multipath_conf = conf;
+	rcu_assign_pointer(multipath_conf, conf);
 	dm_init(conf->verbosity);
 	dm_drv_version(conf->version, TGT_MPATH);
 	if (init_checkers(conf->multipath_dir)) {
@@ -2313,6 +2313,11 @@ child (void * param)
 	}
 #endif
 	/*
+	 * Startup done, invalidate configuration
+	 */
+	conf = NULL;
+
+	/*
 	 * Signal start of configuration
 	 */
 	post_config_state(DAEMON_CONFIGURE);
@@ -2362,7 +2367,9 @@ child (void * param)
 			if (!need_to_delay_reconfig(vecs)) {
 				reconfigure(vecs);
 			} else {
+				conf = get_multipath_config();
 				conf->delayed_reconfig = 1;
+				put_multipath_config(conf);
 			}
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
@@ -2370,9 +2377,11 @@ child (void * param)
 	}
 
 	lock(vecs->lock);
+	conf = get_multipath_config();
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
+	put_multipath_config(conf);
 	remove_maps_and_stop_waiters(vecs);
 	unlock(vecs->lock);
 
@@ -2418,8 +2427,9 @@ child (void * param)
 	 * because logging functions like dlog() and dm_write_log()
 	 * reference the config.
 	 */
-	free_config(conf);
-	conf = NULL;
+	conf = rcu_dereference(multipath_conf);
+	rcu_assign_pointer(multipath_conf, NULL);
+	call_rcu(&conf->rcu, rcu_free_config);
 	udev_unref(udev);
 	udev = NULL;
 	pthread_attr_destroy(&waiter_attr);
-- 
2.6.6
