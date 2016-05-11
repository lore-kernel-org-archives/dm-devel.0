From: Hannes Reinecke <hare@suse.de>
Subject: multipathd: move 'filter_devnode' under vector lock
Date: Wed, 11 May 2016 12:35:41 +0200
Message-ID: <1462962941-9429-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Ben Marzinski pointed out that filter_devnode() is used
without any lock or configuration settings in uev_trigger(),
and hence might be invalid when processing events during
reconfiguration.
So move it into the individual functions and handle it
with the vector lock held.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 58e8854..2c7486d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -580,6 +580,11 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
 	pthread_testcancel();
+	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
+			   uev->kernel) > 0) {
+		ret = 0;
+		goto out_unlock;
+	}
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		int r;
@@ -637,6 +642,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		free_path(pp);
 		ret = 1;
 	}
+out_unlock:
 	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
@@ -780,22 +786,23 @@ fail:
 static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
-	struct path *pp;
-	int ret;
+	struct path *pp = NULL;
+	int ret = 0;
 
 	condlog(2, "%s: remove path (uevent)", uev->kernel);
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
 	pthread_testcancel();
-	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-	if (pp)
-		ret = ev_remove_path(pp, vecs);
-	lock_cleanup_pop(vecs->lock);
-	if (!pp) {
-		/* Not an error; path might have been purged earlier */
-		condlog(0, "%s: path already removed", uev->kernel);
-		return 0;
+	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
+			   uev->kernel) == 0) {
+		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+		if (pp)
+			ret = ev_remove_path(pp, vecs);
+		else
+			/* Not an error; path might have been purged earlier */
+			condlog(0, "%s: path already removed", uev->kernel);
 	}
+	lock_cleanup_pop(vecs->lock);
 	return ret;
 }
 
@@ -905,7 +912,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	ro = uevent_get_disk_ro(uev);
 
 	if (ro >= 0) {
-		struct path * pp;
+		struct path * pp = NULL;
 		struct multipath *mpp = NULL;
 
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
@@ -918,6 +925,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		 * need to be at the same indentation level, hence
 		 * this slightly convoluted codepath.
 		 */
+		if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
+				   uev->kernel) > 0) {
+			goto out_unlock;
+		}
 		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 		if (pp) {
 			if (pp->initialized == INIT_REQUESTED_UDEV) {
@@ -937,11 +948,13 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 					uev->kernel, mpp->alias, retval);
 			}
 		}
+	out_unlock:
 		lock_cleanup_pop(vecs->lock);
 		if (!pp) {
-			condlog(0, "%s: spurious uevent, path not found",
-				uev->kernel);
-			return 1;
+			if (retval)
+				condlog(0, "%s: spurious uevent, path not found",
+					uev->kernel);
+			return retval;
 		}
 		if (retval == 2)
 			return uev_add_path(uev, vecs);
@@ -1059,10 +1072,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	/*
 	 * path add/remove event
 	 */
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0)
-		goto out;
-
 	if (!strncmp(uev->action, "add", 3)) {
 		r = uev_add_path(uev, vecs);
 		goto out;
-- 
2.6.6
