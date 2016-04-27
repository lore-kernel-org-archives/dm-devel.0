From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 45/57] libmultipath: remove 'get_info' argument
	for adopt_paths()
Date: Wed, 27 Apr 2016 13:10:46 +0200
Message-ID: <1461755458-29225-46-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The 'get_info' argument was always set to '1', so we can drop it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs_vec.c | 10 +++++-----
 libmultipath/structs_vec.h |  2 +-
 multipathd/main.c          |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index d9a731a..7d46d42 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -46,7 +46,7 @@ update_mpp_paths(struct multipath * mpp, vector pathvec)
 }
 
 extern int
-adopt_paths (vector pathvec, struct multipath * mpp, int get_info)
+adopt_paths (vector pathvec, struct multipath * mpp)
 {
 	int i;
 	struct path * pp;
@@ -69,8 +69,8 @@ adopt_paths (vector pathvec, struct multipath * mpp, int get_info)
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
-			if (get_info && pathinfo(pp, conf->hwtable,
-						 DI_PRIO | DI_CHECKER))
+			if (pathinfo(pp, conf->hwtable,
+				     DI_PRIO | DI_CHECKER))
 				return 1;
 		}
 	}
@@ -422,7 +422,7 @@ add_map_without_path (struct vectors * vecs, char * alias)
 	if (setup_multipath(vecs, mpp))
 		return NULL; /* mpp freed in setup_multipath */
 
-	if (adopt_paths(vecs->pathvec, mpp, 1))
+	if (adopt_paths(vecs->pathvec, mpp))
 		goto out;
 
 	if (!vector_alloc_slot(vecs->mpvec))
@@ -474,7 +474,7 @@ add_map_with_path (struct vectors * vecs,
 		goto out;
 	mpp->size = pp->size;
 
-	if (adopt_paths(vecs->pathvec, mpp, 1))
+	if (adopt_paths(vecs->pathvec, mpp))
 		goto out;
 
 	if (add_vec) {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index eb8e672..2e06beb 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -15,7 +15,7 @@ struct vectors {
 
 void set_no_path_retry(struct multipath *mpp);
 
-int adopt_paths (vector pathvec, struct multipath * mpp, int get_info);
+int adopt_paths (vector pathvec, struct multipath * mpp);
 void orphan_paths (vector pathvec, struct multipath * mpp);
 void orphan_path (struct path * pp, const char *reason);
 
diff --git a/multipathd/main.c b/multipathd/main.c
index a86530f..1141fb6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -275,7 +275,7 @@ update_map (struct multipath *mpp, struct vectors *vecs)
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
-	if (adopt_paths(vecs->pathvec, mpp, 1)) {
+	if (adopt_paths(vecs->pathvec, mpp)) {
 		condlog(0, "%s: failed to adopt paths for new map update",
 			mpp->alias);
 		retries = -1;
@@ -578,7 +578,7 @@ rescan:
 
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
-		if (adopt_paths(vecs->pathvec, mpp, 1))
+		if (adopt_paths(vecs->pathvec, mpp))
 			goto fail; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs);
-- 
2.6.6
