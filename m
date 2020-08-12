From: mwilck@suse.com
Subject: [PATCH v2 58/74] libmultipath: verify_paths(): don't
	delete paths from pathvec
Date: Wed, 12 Aug 2020 13:35:05 +0200
Message-ID: <20200812113511.26469-3-mwilck@suse.com>
References: <20200812113511.26469-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113511.26469-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

If we encounter a non-existing device verify_paths(), just set
it to INIT_REMOVED state. Actual path deletion is postponed until
we don't see that path in the kernel map any more.

This allows us to get rid of the "pathvec" argument to this function.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  2 +-
 libmultipath/structs_vec.c | 16 +++++++++-------
 libmultipath/structs_vec.h |  2 +-
 multipathd/main.c          |  4 ++--
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5ecfae8..cc54818 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1196,7 +1196,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				set_bit_in_bitfield(i, size_mismatch_seen);
 			}
 		}
-		verify_paths(mpp, vecs);
+		verify_paths(mpp);
 
 		params[0] = '\0';
 		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index ee1004d..e0a84d4 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -499,11 +499,11 @@ out:
 	return NULL;
 }
 
-int verify_paths(struct multipath *mpp, struct vectors *vecs)
+int verify_paths(struct multipath *mpp)
 {
 	struct path * pp;
 	int count = 0;
-	int i, j;
+	int i;
 
 	if (!mpp)
 		return 0;
@@ -518,7 +518,7 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 				condlog(1, "%s: removing valid path %s in state %d",
 					mpp->alias, pp->dev, pp->state);
 			} else {
-				condlog(3, "%s: failed to access path %s",
+				condlog(2, "%s: failed to access path %s",
 					mpp->alias, pp->dev);
 			}
 			count++;
@@ -531,10 +531,12 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 			 */
 			if (mpp->hwe == pp->hwe)
 				mpp->hwe = NULL;
-			if ((j = find_slot(vecs->pathvec,
-					   (void *)pp)) != -1)
-				vector_del_slot(vecs->pathvec, j);
-			free_path(pp);
+			/*
+			 * Don't delete path from pathvec yet. We'll do this
+			 * after the path has been removed from the map, in
+			 * sync_paths().
+			 */
+			set_path_removed(pp);
 		} else {
 			condlog(4, "%s: verified path %s dev_t %s",
 				mpp->alias, pp->dev, pp->dev_t);
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 7f6dece..d7dfe32 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -20,7 +20,7 @@ void orphan_paths(vector pathvec, struct multipath *mpp,
 void orphan_path (struct path * pp, const char *reason);
 void set_path_removed(struct path *pp);
 
-int verify_paths(struct multipath * mpp, struct vectors * vecs);
+int verify_paths(struct multipath *mpp);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec,
 			      int is_daemon);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2c5b982..0209db4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -492,7 +492,7 @@ retry:
 		retries = -1;
 		goto fail;
 	}
-	verify_paths(mpp, vecs);
+	verify_paths(mpp);
 	mpp->action = ACT_RELOAD;
 
 	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
@@ -960,7 +960,7 @@ rescan:
 		    find_slot(vecs->pathvec, pp) == -1)
 			goto fail; /* leave path added to pathvec */
 
-		verify_paths(mpp, vecs);
+		verify_paths(mpp);
 		mpp->action = ACT_RELOAD;
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
-- 
2.28.0
