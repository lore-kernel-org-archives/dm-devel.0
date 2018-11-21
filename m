From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] multipathd: fix mpp->hwe handling when paths are
	freed
Date: Tue, 20 Nov 2018 22:24:44 -0600
Message-ID: <1542774284-20935-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit 1f962693 didn't deal with all of cases where a path that was part
of a multipath device could be removed. verify_paths() removes any path
that no longer exists in sysfs.  mpp->hwe needs to be updated here as
well, since verify_paths() could remove the path whose hwe vector is
pointed to by mpp->hwe.  Also, now that extract_hwe_from_path() is
called in verify_paths(), the extract_hwe_from_path() calls that
happened immediately after verify_paths() can be dropped.

The other part of this fix is mostly cosmetic. In ev_add_path(), if
domap() fails after the path is added to the multipath device and
verify_paths() is called, the code can loop back to the rescan label. If
the size of the path or the multipath device changed in the interim,
ev_add_path() would remove the path, without updating mpp->hwe; but
there is no way for the size to change. Just to make that clearer in the
code, I've moved the size check to before the rescan label so it only
happens once.

Fixes: 1f962693 "multipathd: fix mpp->hwe handling on path removal"
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c |  7 +++++++
 multipathd/main.c          | 21 ++++++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index c85823a..e28a88a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -407,6 +407,12 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 			vector_del_slot(mpp->paths, i);
 			i--;
 
+			/* Make sure mpp->hwe doesn't point to freed memory.
+			 * We call extract_hwe_from_path() below to restore
+			 * mpp->hwe
+			 */
+			if (mpp->hwe == pp->hwe)
+				mpp->hwe = NULL;
 			if ((j = find_slot(vecs->pathvec,
 					   (void *)pp)) != -1)
 				vector_del_slot(vecs->pathvec, j);
@@ -416,6 +422,7 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 				mpp->alias, pp->dev, pp->dev_t);
 		}
 	}
+	extract_hwe_from_path(mpp);
 	return count;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index cc555bb..2e5f9ed 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -491,7 +491,6 @@ retry:
 	verify_paths(mpp, vecs);
 	mpp->action = ACT_RELOAD;
 
-	extract_hwe_from_path(mpp);
 	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
@@ -925,6 +924,14 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		goto fail; /* leave path added to pathvec */
 	}
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
+	if (mpp && pp->size && mpp->size != pp->size) {
+		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
+		int i = find_slot(vecs->pathvec, (void *)pp);
+		if (i != -1)
+			vector_del_slot(vecs->pathvec, i);
+		free_path(pp);
+		return 1;
+	}
 	if (mpp && mpp->wait_for_udev &&
 	    (pathcount(mpp, PATH_UP) > 0 ||
 	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT &&
@@ -940,17 +947,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	pp->mpp = mpp;
 rescan:
 	if (mpp) {
-		if (pp->size && mpp->size != pp->size) {
-			condlog(0, "%s: failed to add new path %s, "
-				"device size mismatch",
-				mpp->alias, pp->dev);
-			int i = find_slot(vecs->pathvec, (void *)pp);
-			if (i != -1)
-				vector_del_slot(vecs->pathvec, i);
-			free_path(pp);
-			return 1;
-		}
-
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
 		if (adopt_paths(vecs->pathvec, mpp))
@@ -958,7 +954,6 @@ rescan:
 
 		verify_paths(mpp, vecs);
 		mpp->action = ACT_RELOAD;
-		extract_hwe_from_path(mpp);
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
-- 
2.7.4
