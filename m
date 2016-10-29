From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/10] recover from errors in multipathd startup
Date: Fri, 28 Oct 2016 21:55:23 -0500
Message-ID: <1477709726-5442-8-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

When multipathd does it's initial configuration during startup, it fails
the daemon for many errors that it would simply recover from if they
occured when adding paths or maps later.  It should recover from these
errors during startup as well.  Also, if multipathd hits a
nonrecoverable error, it should log a message before quitting.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |  8 +++++---
 multipathd/main.c        | 45 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 48f100b..d428099 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -809,8 +809,10 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		 * at this point, we know we really got a new mp
 		 */
 		mpp = add_map_with_path(vecs, pp1, 0);
-		if (!mpp)
-			return 1;
+		if (!mpp) {
+			orphan_path(pp1, "failed to create multipath device");
+			continue;
+		}
 
 		if (pp1->priority == PRIO_UNDEF)
 			mpp->action = ACT_REJECT;
@@ -862,7 +864,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			condlog(3, "%s: domap (%u) failure "
 				   "for create/reload map",
 				mpp->alias, r);
-			if (r == DOMAP_FAIL) {
+			if (r == DOMAP_FAIL || is_daemon) {
 				condlog(2, "%s: %s map",
 					mpp->alias, (mpp->action == ACT_CREATE)?
 					"ignoring" : "removing");
diff --git a/multipathd/main.c b/multipathd/main.c
index 15c957a..f423e35 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1017,7 +1017,7 @@ map_discovery (struct vectors * vecs)
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
 		if (setup_multipath(vecs, mpp))
-			return 1;
+			i--;
 
 	return 0;
 }
@@ -1910,21 +1910,29 @@ configure (struct vectors * vecs, int start_waiters)
 	int i, ret;
 	struct config *conf;
 
-	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc()))
+	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc())) {
+		condlog(0, "couldn't allocate path vec in configure");
 		return 1;
+	}
 
-	if (!vecs->mpvec && !(vecs->mpvec = vector_alloc()))
+	if (!vecs->mpvec && !(vecs->mpvec = vector_alloc())) {
+		condlog(0, "couldn't allocate multipath vec in configure");
 		return 1;
+	}
 
-	if (!(mpvec = vector_alloc()))
+	if (!(mpvec = vector_alloc())) {
+		condlog(0, "couldn't allocate new maps vec in configure");
 		return 1;
+	}
 
 	/*
 	 * probe for current path (from sysfs) and map (from dm) sets
 	 */
 	ret = path_discovery(vecs->pathvec, DI_ALL);
-	if (ret < 0)
+	if (ret < 0) {
+		condlog(0, "configure failed at path discovery");
 		return 1;
+	}
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
 		conf = get_multipath_config();
@@ -1937,21 +1945,27 @@ configure (struct vectors * vecs, int start_waiters)
 			pp->checkint = conf->checkint;
 		put_multipath_config(conf);
 	}
-	if (map_discovery(vecs))
+	if (map_discovery(vecs)) {
+		condlog(0, "configure failed at map discovery");
 		return 1;
+	}
 
 	/*
 	 * create new set of maps & push changed ones into dm
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 1, CMD_NONE))
+	if (coalesce_paths(vecs, mpvec, NULL, 1, CMD_NONE)) {
+		condlog(0, "configure failed while coalescing paths");
 		return 1;
+	}
 
 	/*
 	 * may need to remove some maps which are no longer relevant
 	 * e.g., due to blacklist changes in conf file
 	 */
-	if (coalesce_maps(vecs, mpvec))
+	if (coalesce_maps(vecs, mpvec)) {
+		condlog(0, "configure failed while coalescing maps");
 		return 1;
+	}
 
 	dm_lib_release();
 
@@ -1976,11 +1990,16 @@ configure (struct vectors * vecs, int start_waiters)
 	 * start dm event waiter threads for these new maps
 	 */
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (setup_multipath(vecs, mpp))
-			return 1;
-		if (start_waiters)
-			if (start_waiter_thread(mpp, vecs))
-				return 1;
+		if (setup_multipath(vecs, mpp)) {
+			i--;
+			continue;
+		}
+		if (start_waiters) {
+			if (start_waiter_thread(mpp, vecs)) {
+				remove_map(mpp, vecs, 1);
+				i--;
+			}
+		}
 	}
 	return 0;
 }
-- 
1.8.3.1
