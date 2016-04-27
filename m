From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 56/57] multipathd: push down lock in checkerloop()
Date: Wed, 27 Apr 2016 13:10:57 +0200
Message-ID: <1461755458-29225-57-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Instead of grabbing the lock at the start of the checkerloop
and releasing it at the end we should be holding it only
during the time when we actually need it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 136 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 87 insertions(+), 49 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 41b5a49..132101f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -416,7 +416,11 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 			return 1;
 		}
 	}
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
 	rc = ev_add_map(uev->kernel, alias, vecs);
+	lock_cleanup_pop(vecs->lock);
 	FREE(alias);
 	return rc;
 }
@@ -512,6 +516,10 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 		return 0;
 	}
 	minor = uevent_get_minor(uev);
+
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
 	mpp = find_mp_by_minor(vecs->mpvec, minor);
 
 	if (!mpp) {
@@ -528,10 +536,12 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	orphan_paths(vecs->pathvec, mpp);
 	remove_map_and_stop_waiter(mpp, vecs, 1);
 out:
+	lock_cleanup_pop(vecs->lock);
 	FREE(alias);
 	return 0;
 }
 
+/* Called from CLI handler */
 int
 ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 {
@@ -567,6 +577,9 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		return 1;
 	}
 
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		int r;
@@ -594,8 +607,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 				ret = 1;
 			}
 		}
-		return ret;
 	}
+	lock_cleanup_pop(vecs->lock);
+	if (pp)
+		return ret;
 
 	/*
 	 * get path vital state
@@ -608,6 +623,9 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		condlog(3, "%s: failed to get path info", uev->kernel);
 		return 1;
 	}
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
 		pp->checkint = conf->checkint;
@@ -619,7 +637,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		free_path(pp);
 		ret = 1;
 	}
-
+	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
 
@@ -687,12 +705,12 @@ rescan:
 			 */
 			start_waiter = 1;
 		}
-		else
+		if (!start_waiter)
 			goto fail; /* leave path added to pathvec */
 	}
 
-	/* persistent reseravtion check*/
-	mpath_pr_event_handle(pp);	
+	/* persistent reservation check*/
+	mpath_pr_event_handle(pp);
 
 	/*
 	 * push the map to the device-mapper
@@ -720,7 +738,7 @@ retry:
 		 * deal with asynchronous uevents :((
 		 */
 		if (mpp->action == ACT_RELOAD && retries-- > 0) {
-			condlog(0, "%s: uev_add_path sleep", mpp->alias);
+			condlog(0, "%s: ev_add_path sleep", mpp->alias);
 			sleep(1);
 			update_mpp_paths(mpp, vecs->pathvec);
 			goto rescan;
@@ -749,8 +767,7 @@ retry:
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
-	}
-	else
+	} else
 		goto fail;
 
 fail_map:
@@ -764,17 +781,22 @@ static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
+	int ret;
 
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(vecs->lock);
+	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-
+	if (pp)
+		ret = ev_remove_path(pp, vecs);
+	lock_cleanup_pop(vecs->lock);
 	if (!pp) {
 		/* Not an error; path might have been purged earlier */
 		condlog(0, "%s: path already removed", uev->kernel);
 		return 0;
 	}
-
-	return ev_remove_path(pp, vecs);
+	return ret;
 }
 
 int
@@ -877,35 +899,50 @@ static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int ro, retval = 0;
-	struct path * pp;
-
-	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-	if (!pp) {
-		condlog(0, "%s: spurious uevent, path not found",
-			uev->kernel);
-		return 1;
-	}
-
-	if (pp->initialized == INIT_REQUESTED_UDEV)
-		return uev_add_path(uev, vecs);
 
 	ro = uevent_get_disk_ro(uev);
 
 	if (ro >= 0) {
+		struct path * pp;
+		struct multipath *mpp = NULL;
+
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
 			uev->kernel, ro);
-		if (pp->mpp) {
-			if (pp->mpp->wait_for_udev) {
-				pp->mpp->wait_for_udev = 2;
-				return 0;
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(vecs->lock);
+		pthread_testcancel();
+		/*
+		 * pthread_mutex_lock() and pthread_mutex_unlock()
+		 * need to be at the same indentation level, hence
+		 * this slightly convoluted codepath.
+		 */
+		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+		if (pp) {
+			if (pp->initialized == INIT_REQUESTED_UDEV) {
+				retval = 2;
+			} else {
+				mpp = pp->mpp;
+				if (mpp && mpp->wait_for_udev) {
+					mpp->wait_for_udev = 2;
+					mpp = NULL;
+					retval = 0;
+				}
 			}
+			if (mpp) {
+				retval = reload_map(vecs, mpp, 0);
 
-			retval = reload_map(vecs, pp->mpp, 0);
-
-			condlog(2, "%s: map %s reloaded (retval %d)",
-				uev->kernel, pp->mpp->alias, retval);
+				condlog(2, "%s: map %s reloaded (retval %d)",
+					uev->kernel, mpp->alias, retval);
+			}
 		}
-
+		lock_cleanup_pop(vecs->lock);
+		if (!pp) {
+			condlog(0, "%s: spurious uevent, path not found",
+				uev->kernel);
+			return 1;
+		}
+		if (retval == 2)
+			return uev_add_path(uev, vecs);
 	}
 
 	return retval;
@@ -1002,10 +1039,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	if (running_state == DAEMON_SHUTDOWN)
 		return 0;
 
-	pthread_cleanup_push(cleanup_lock, &vecs->lock);
-	lock(vecs->lock);
-	pthread_testcancel();
-
 	/*
 	 * device map event
 	 * Add events are ignored here as the tables
@@ -1044,7 +1077,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	}
 
 out:
-	lock_cleanup_pop(vecs->lock);
 	return r;
 }
 
@@ -1627,17 +1659,6 @@ checkerloop (void *ap)
 
 		if (gettimeofday(&start_time, NULL) != 0)
 			start_time.tv_sec = 0;
-
-		rc = set_config_state(DAEMON_RUNNING);
-		if (rc == ETIMEDOUT) {
-			condlog(4, "timeout waiting for DAEMON_IDLE");
-			continue;
-		}
-
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(vecs->lock);
-		pthread_testcancel();
-		strict_timing = conf->strict_timing;
 		if (start_time.tv_sec && last_time.tv_sec) {
 			timersub(&start_time, &last_time, &diff_time);
 			condlog(4, "tick (%lu.%06lu secs)",
@@ -1653,28 +1674,45 @@ checkerloop (void *ap)
 		if (use_watchdog)
 			sd_notify(0, "WATCHDOG=1");
 #endif
+		rc = set_config_state(DAEMON_RUNNING);
+		if (rc == ETIMEDOUT) {
+			condlog(4, "timeout waiting for DAEMON_IDLE");
+			continue;
+		}
+		strict_timing = conf->strict_timing;
 		if (vecs->pathvec) {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			vector_foreach_slot (vecs->pathvec, pp, i) {
 				num_paths += check_path(vecs, pp, ticks);
 			}
+			lock_cleanup_pop(vecs->lock);
 		}
 		if (vecs->mpvec) {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			defered_failback_tick(vecs->mpvec);
 			retry_count_tick(vecs->mpvec);
 			missing_uev_wait_tick(vecs);
+			lock_cleanup_pop(vecs->lock);
 		}
 		if (count)
 			count--;
 		else {
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(vecs->lock);
+			pthread_testcancel();
 			condlog(4, "map garbage collection");
 			mpvec_garbage_collector(vecs);
 			count = MAPGCINT;
+			lock_cleanup_pop(vecs->lock);
 		}
 
-		lock_cleanup_pop(vecs->lock);
 		diff_time.tv_usec = 0;
 		if (start_time.tv_sec &&
-		    gettimeofday(&end_time, NULL)) {
+		    gettimeofday(&end_time, NULL) == 0) {
 			timersub(&end_time, &start_time, &diff_time);
 			if (num_paths) {
 				condlog(3, "checked %d path%s in %lu.%06lu secs",
-- 
2.6.6
