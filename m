From: mwilck@suse.com
Subject: [PATCH 58/74] libmultipath: verify_paths(): don't delete
	paths from pathvec
Date: Thu,  9 Jul 2020 12:51:29 +0200
Message-ID: <20200709105145.9211-6-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  2 +-
 libmultipath/structs_vec.c | 16 +++++++++-------
 libmultipath/structs_vec.h |  2 +-
 multipathd/main.c          |  4 ++--
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 48426cd..2509053 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1196,7 +1196,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				set_bit_in_bitfield(i, size_mismatch_seen);
 			}
 		}
-		verify_paths(mpp, vecs);
+		verify_paths(mpp);
 
 		if (does_alias_exist(newmp, mpp)) {
 			remove_map(mpp, vecs, PURGE_VEC);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8999552..5634101 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -502,11 +502,11 @@ out:
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
@@ -521,7 +521,7 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
 				condlog(1, "%s: removing valid path %s in state %d",
 					mpp->alias, pp->dev, pp->state);
 			} else {
-				condlog(3, "%s: failed to access path %s",
+				condlog(2, "%s: failed to access path %s",
 					mpp->alias, pp->dev);
 			}
 			count++;
@@ -534,10 +534,12 @@ int verify_paths(struct multipath *mpp, struct vectors *vecs)
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
index cf7d569..cd3ef76 100644
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
index 4a5aa17..402e179 100644
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
@@ -959,7 +959,7 @@ rescan:
 		if (adopt_paths(vecs->pathvec, mpp))
 			goto fail; /* leave path added to pathvec */
 
-		verify_paths(mpp, vecs);
+		verify_paths(mpp);
 		mpp->action = ACT_RELOAD;
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
-- 
2.26.2
