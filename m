From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [RFC PATCH 3/5] call start_waiter_thread() before
	setup_multipath()
Date: Fri,  9 Feb 2018 23:07:29 -0600
Message-ID: <1518239251-29392-4-git-send-email-bmarzins@redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If setup_multipath() is called before the waiter thread has started,
there is a window where a dm event can occur between when
setup_multipath() updates the device state and when the waiter thread
starts waiting for new events, causing the new event to be missed and
the multipath device to not get updated.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 94b2406..efc39d7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -321,7 +321,7 @@ set_multipath_wwid (struct multipath * mpp)
 }
 
 static int
-update_map (struct multipath *mpp, struct vectors *vecs)
+update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
 	char params[PARAMS_SIZE] = {0};
@@ -351,6 +351,12 @@ retry:
 	dm_lib_release();
 
 fail:
+	if (new_map && (retries < 0 || start_waiter_thread(mpp, vecs))) {
+		condlog(0, "%s: failed to create new map", mpp->alias);
+		remove_map(mpp, vecs, 1);
+		return 1;
+	}
+
 	if (setup_multipath(vecs, mpp))
 		return 1;
 
@@ -395,12 +401,9 @@ add_map_without_path (struct vectors *vecs, char *alias)
 
 	vector_set_slot(vecs->mpvec, mpp);
 
-	if (update_map(mpp, vecs) != 0) /* map removed */
+	if (update_map(mpp, vecs, 1) != 0) /* map removed */
 		return NULL;
 
-	if (start_waiter_thread(mpp, vecs))
-		goto out;
-
 	return mpp;
 out:
 	remove_map(mpp, vecs, PURGE_VEC);
@@ -554,7 +557,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 		if (mpp->wait_for_udev > 1) {
 			condlog(2, "%s: performing delayed actions",
 				mpp->alias);
-			if (update_map(mpp, vecs))
+			if (update_map(mpp, vecs, 0))
 				/* setup multipathd removed the map */
 				return 1;
 		}
@@ -865,6 +868,11 @@ retry:
 	}
 	dm_lib_release();
 
+	if ((mpp->action == ACT_CREATE ||
+	     (mpp->action == ACT_NOTHING && start_waiter && !mpp->waiter)) &&
+	    start_waiter_thread(mpp, vecs))
+			goto fail_map;
+
 	/*
 	 * update our state from kernel regardless of create or reload
 	 */
@@ -873,11 +881,6 @@ retry:
 
 	sync_map_state(mpp);
 
-	if ((mpp->action == ACT_CREATE ||
-	     (mpp->action == ACT_NOTHING && start_waiter && !mpp->waiter)) &&
-	    start_waiter_thread(mpp, vecs))
-			goto fail_map;
-
 	if (retries >= 0) {
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
@@ -1479,7 +1482,8 @@ missing_uev_wait_tick(struct vectors *vecs)
 		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
 			timed_out = 1;
 			condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
-			if (mpp->wait_for_udev > 1 && update_map(mpp, vecs)) {
+			if (mpp->wait_for_udev > 1 &&
+			    update_map(mpp, vecs, 0)) {
 				/* update_map removed map */
 				i--;
 				continue;
@@ -1511,7 +1515,7 @@ ghost_delay_tick(struct vectors *vecs)
 			condlog(0, "%s: timed out waiting for active path",
 				mpp->alias);
 			mpp->force_udev_reload = 1;
-			if (update_map(mpp, vecs) != 0) {
+			if (update_map(mpp, vecs, 0) != 0) {
 				/* update_map removed map */
 				i--;
 				continue;
@@ -2169,14 +2173,13 @@ configure (struct vectors * vecs)
 	 * start dm event waiter threads for these new maps
 	 */
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (setup_multipath(vecs, mpp)) {
-			i--;
-			continue;
-		}
 		if (start_waiter_thread(mpp, vecs)) {
 			remove_map(mpp, vecs, 1);
 			i--;
+			continue;
 		}
+		if (setup_multipath(vecs, mpp))
+			i--;
 	}
 	return 0;
 }
-- 
2.7.4
