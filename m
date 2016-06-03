From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipathd: rework patch 'move 'filter_devnode'
	under vector lock'
Date: Fri,  3 Jun 2016 09:24:32 +0200
Message-ID: <1464938672-3075-1-git-send-email-hare@suse.de>
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

The original patch was causing a segfault during booting when
calling 'lock_cleanup_pop()' in uev_add_path().
As the patch itself was quite intrusive (and the segfault was
promising really hard to debug; all pointers were valid when calling
lock_cleanup_pop()) I've reverted it and replaced it by
a simpler version which would just store the blacklists
in a local copy, and update the pointers upon reconfiguration.
As pointer updates can be assumed to be atomic the blacklists
will always be valid so we do not need any synchronisation here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2c7486d..774a74e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -108,6 +108,8 @@ pthread_cond_t config_cond = PTHREAD_COND_INITIALIZER;
 struct vectors * gvecs;
 
 struct udev * udev;
+vector blist_devnode;
+vector elist_devnode;
 
 const char *
 daemon_status(void)
@@ -580,11 +582,6 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
 	pthread_testcancel();
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0) {
-		ret = 0;
-		goto out_unlock;
-	}
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		int r;
@@ -642,7 +639,6 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		free_path(pp);
 		ret = 1;
 	}
-out_unlock:
 	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
@@ -786,23 +782,22 @@ fail:
 static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
-	struct path *pp = NULL;
-	int ret = 0;
+	struct path *pp;
+	int ret;
 
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
 	pthread_testcancel();
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) == 0) {
-		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-		if (pp)
-			ret = ev_remove_path(pp, vecs);
-		else
-			/* Not an error; path might have been purged earlier */
-			condlog(0, "%s: path already removed", uev->kernel);
-	}
+	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+	if (pp)
+		ret = ev_remove_path(pp, vecs);
 	lock_cleanup_pop(vecs->lock);
+	if (!pp) {
+		/* Not an error; path might have been purged earlier */
+		condlog(0, "%s: path already removed", uev->kernel);
+		return 0;
+	}
 	return ret;
 }
 
@@ -912,7 +907,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	ro = uevent_get_disk_ro(uev);
 
 	if (ro >= 0) {
-		struct path * pp = NULL;
+		struct path * pp;
 		struct multipath *mpp = NULL;
 
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
@@ -925,10 +920,6 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		 * need to be at the same indentation level, hence
 		 * this slightly convoluted codepath.
 		 */
-		if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-				   uev->kernel) > 0) {
-			goto out_unlock;
-		}
 		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 		if (pp) {
 			if (pp->initialized == INIT_REQUESTED_UDEV) {
@@ -948,13 +939,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 					uev->kernel, mpp->alias, retval);
 			}
 		}
-	out_unlock:
 		lock_cleanup_pop(vecs->lock);
 		if (!pp) {
-			if (retval)
-				condlog(0, "%s: spurious uevent, path not found",
-					uev->kernel);
-			return retval;
+			condlog(0, "%s: spurious uevent, path not found",
+				uev->kernel);
+			return 1;
 		}
 		if (retval == 2)
 			return uev_add_path(uev, vecs);
@@ -1072,6 +1061,10 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	/*
 	 * path add/remove event
 	 */
+	if (filter_devnode(blist_devnode, elist_devnode,
+			   uev->kernel) > 0)
+		goto out;
+
 	if (!strncmp(uev->action, "add", 3)) {
 		r = uev_add_path(uev, vecs);
 		goto out;
@@ -1897,6 +1890,8 @@ reconfigure (struct vectors * vecs)
 		conf = old;
 	}
 	uxsock_timeout = conf->uxsock_timeout;
+	blist_devnode = conf->blist_devnode;
+	elist_devnode = conf->elist_devnode;
 
 	return retval;
 }
-- 
2.6.6
