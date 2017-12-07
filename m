From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 06/12] multipathd: fix device creation issues
Date: Thu,  7 Dec 2017 12:49:00 -0600
Message-ID: <1512672546-12785-7-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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

Right now, devices created by multipath and added to multipthd via
ev_add_map() are setup up incorrectly until the first time they get
reloaded.  setup_map() is not run on these devices, which means that all
of the multipath variables set up there don't get initialized until a
later reload.  Also, adopt_paths is run to pull in any paths that the
device is missing, but the device is never reloaded afterwards, so these
paths aren't used.

Now, add_map_without_path() sets up the basic multipath device variables
and then calls update_map() to finish the setup and reload the device.
This patch also moves the code in __setup_multipath(), that only existed
to handle adding devices via ev_add_map(), to where it belongs.

However, it is possible to create a device with no paths, which means
the device cannot know which hwentry to use for its device
configuration.  __setup_multipath() used to help with this via
extract_hwe_from_path(), which grabbed the hwentry from a path if the
multipath device didn't already have it set. This is now done both when
paths are added or the map is updated, which means that
extract_hwe_from_path() runs before the device is configured in
setup_map() instead of after the table has already been loaded. This is
a good thing. But because of this, it can't check the dmstate or the
pathgroup state.  I don't believe it's necessary to care what state the
path is in, especially now that we use libudev. The vendor and product
information gets cached by libudev when the path device is first added,
and should remain the same regardless of whether or not the device is
currently up.  My version does try to take the hwe information from a
path in the PATH_UP state first, but this is mostly to satisfy the
paranoia of the old version.

Also, map_discovery(), which creates multipath devices during multipathd
startup and reconfiguration, that only exist to see if multipathd needs
to reload the device table, called __setup_multipath() as well. Even
after removing the unnecessary code from __setup_multpiath, that still
does pointless work for these devices, which will be removed before the
end of configure(). Now, map_discovery() just gets the necessary kernel
information to make the correct call in select_action().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 101 ++++++++++++++++-----------------------------
 libmultipath/structs_vec.h |   4 ++
 multipathd/main.c          |   6 ++-
 3 files changed, 45 insertions(+), 66 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index eddeeaf..32a4d9e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -188,66 +188,36 @@ void remove_maps_and_stop_waiters(struct vectors *vecs)
 	_remove_maps(vecs, STOP_WAITER);
 }
 
-static struct hwentry *
+void
 extract_hwe_from_path(struct multipath * mpp)
 {
 	struct path * pp = NULL;
-	int pg_num = -1, p_num = -1, i;
-	struct pathgroup * pgp = NULL;
-
-	condlog(3, "%s: searching paths for valid hwe", mpp->alias);
+	int i;
 
-	if (mpp && mpp->pg) {
-		vector_foreach_slot(mpp->pg, pgp, i) {
-			if (pgp->status == PGSTATE_ACTIVE ||
-			    pgp->status == PGSTATE_ENABLED) {
-				pg_num = i;
-				break;
-			}
-		}
-		if (pg_num >= 0)
-			pgp = VECTOR_SLOT(mpp->pg, pg_num);
-	}
+	if (mpp->hwe || !mpp->paths)
+		return;
 
-	if (pgp && pgp->paths) {
-		vector_foreach_slot(pgp->paths, pp, i) {
-			if (pp->dmstate == PSTATE_FAILED)
-				continue;
-			if (strlen(pp->vendor_id) > 0 &&
-			    strlen(pp->product_id) > 0 &&
-			    strlen(pp->rev) > 0) {
-				p_num = i;
-				break;
-			}
+	condlog(3, "%s: searching paths for valid hwe", mpp->alias);
+	/* doing this in two passes seems like paranoia to me */
+	vector_foreach_slot(mpp->paths, pp, i) {
+		if (pp->state != PATH_UP)
+			continue;
+		if (pp->hwe) {
+			mpp->hwe = pp->hwe;
+			return;
 		}
-		if (p_num >= 0)
-			pp = VECTOR_SLOT(pgp->paths, i);
 	}
-
-	if (pp) {
-		if (!strlen(pp->vendor_id) ||
-		    !strlen(pp->product_id) ||
-		    !strlen(pp->rev)) {
-			condlog(3, "%s: no device details available", pp->dev);
-			return NULL;
-		}
-		condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
-		condlog(3, "%s: product = %s", pp->dev, pp->product_id);
-		condlog(3, "%s: rev = %s", pp->dev, pp->rev);
-		if (!pp->hwe) {
-			struct config *conf = get_multipath_config();
-
-			condlog(3, "searching hwtable");
-			pp->hwe = find_hwe(conf->hwtable, pp->vendor_id,
-					   pp->product_id, pp->rev);
-			put_multipath_config(conf);
+	vector_foreach_slot(mpp->paths, pp, i) {
+		if (pp->state == PATH_UP)
+			continue;
+		if (pp->hwe) {
+			mpp->hwe = pp->hwe;
+			return;
 		}
 	}
-
-	return pp?pp->hwe:NULL;
 }
 
-static int
+int
 update_multipath_table (struct multipath *mpp, vector pathvec, int is_daemon)
 {
 	char params[PARAMS_SIZE] = {0};
@@ -268,7 +238,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int is_daemon)
 	return 0;
 }
 
-static int
+int
 update_multipath_status (struct multipath *mpp)
 {
 	char status[PARAMS_SIZE] = {0};
@@ -388,18 +358,6 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		goto out;
 	}
 
-	set_multipath_wwid(mpp);
-	conf = get_multipath_config();
-	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
-	put_multipath_config(conf);
-	condlog(3, "%s: discover", mpp->alias);
-
-	if (!mpp->hwe)
-		mpp->hwe = extract_hwe_from_path(mpp);
-	if (!mpp->hwe) {
-		condlog(3, "%s: no hardware entry found, using defaults",
-			mpp->alias);
-	}
 	if (reset) {
 		conf = get_multipath_config();
 		select_rr_weight(conf, mpp);
@@ -466,6 +424,7 @@ retry:
 	mpp->flush_on_last_del = FLUSH_UNDEF;
 	mpp->action = ACT_RELOAD;
 
+	extract_hwe_from_path(mpp);
 	if (setup_map(mpp, params, PARAMS_SIZE)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
@@ -492,6 +451,7 @@ fail:
 struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
 {
 	struct multipath * mpp = alloc_multipath();
+	struct config *conf;
 
 	if (!mpp)
 		return NULL;
@@ -502,10 +462,18 @@ struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
 
 	mpp->alias = STRDUP(alias);
 
-	if (setup_multipath(vecs, mpp))
-		return NULL; /* mpp freed in setup_multipath */
+	if (dm_get_info(mpp->alias, &mpp->dmi)) {
+		condlog(3, "%s: cannot access table", mpp->alias);
+		goto out;
+	}
+	set_multipath_wwid(mpp);
+	conf = get_multipath_config();
+	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
+	put_multipath_config(conf);
 
-	if (adopt_paths(vecs->pathvec, mpp))
+	if (update_multipath_table(mpp, vecs->pathvec, 1))
+		goto out;
+	if (update_multipath_status(mpp))
 		goto out;
 
 	if (!vector_alloc_slot(vecs->mpvec))
@@ -513,6 +481,9 @@ struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
 
 	vector_set_slot(vecs->mpvec, mpp);
 
+	if (update_map(mpp, vecs) != 0) /* map removed */
+		return NULL;
+
 	if (start_waiter_thread(mpp, vecs))
 		goto out;
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 54444e0..54865d7 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -24,6 +24,7 @@ int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 #define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1, 1)
 int update_multipath_strings (struct multipath *mpp, vector pathvec,
 			      int is_daemon);
+void extract_hwe_from_path(struct multipath * mpp);
 
 void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
 void remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs, int purge_vec);
@@ -38,5 +39,8 @@ struct multipath * add_map_with_path (struct vectors * vecs,
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
+int update_multipath_table (struct multipath *mpp, vector pathvec,
+			    int is_daemon);
+int update_multipath_status (struct multipath *mpp);
 
 #endif /* _STRUCTS_VEC_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index 93506ea..39fedc4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -699,6 +699,7 @@ rescan:
 		verify_paths(mpp, vecs);
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
+		extract_hwe_from_path(mpp);
 	} else {
 		if (!should_multipath(pp, vecs->pathvec)) {
 			orphan_path(pp, "only one path");
@@ -1045,8 +1046,11 @@ map_discovery (struct vectors * vecs)
 		return 1;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
-		if (setup_multipath(vecs, mpp))
+		if (update_multipath_table(mpp, vecs->pathvec, 1) ||
+		    update_multipath_status(mpp)) {
+			remove_map(mpp, vecs, 1);
 			i--;
+		}
 
 	return 0;
 }
-- 
2.7.4
