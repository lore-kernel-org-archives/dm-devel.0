From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/12] libmultipath: move remove_map waiter code
	to multipathd
Date: Wed, 14 Mar 2018 12:46:40 -0500
Message-ID: <1521049605-22050-8-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Only multipathd needs to worry about the multipath waiter code. There is
no point in having remove_map_and_stop_waiter() or
remove_maps_and_stop_waiters() in libmultipath, since they should never
be use outside of multipathd.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 40 +++++-----------------------------------
 libmultipath/structs_vec.h |  2 --
 multipathd/main.c          | 23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 37 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f9dc8a8..41e5d88 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -117,25 +117,16 @@ set_multipath_wwid (struct multipath * mpp)
 	dm_get_uuid(mpp->alias, mpp->wwid);
 }
 
-#define KEEP_WAITER 0
-#define STOP_WAITER 1
 #define PURGE_VEC 1
 
-static void
-_remove_map (struct multipath * mpp, struct vectors * vecs,
-	    int stop_waiter, int purge_vec)
+void
+remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 {
 	int i;
 
 	condlog(4, "%s: remove multipath map", mpp->alias);
 
 	/*
-	 * stop the DM event waiter thread
-	 */
-	if (stop_waiter)
-		stop_waiter_thread(mpp, vecs);
-
-	/*
 	 * clear references to this map
 	 */
 	orphan_paths(vecs->pathvec, mpp);
@@ -150,19 +141,8 @@ _remove_map (struct multipath * mpp, struct vectors * vecs,
 	free_multipath(mpp, KEEP_PATHS);
 }
 
-void remove_map(struct multipath *mpp, struct vectors *vecs, int purge_vec)
-{
-	_remove_map(mpp, vecs, KEEP_WAITER, purge_vec);
-}
-
-void remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs,
-				int purge_vec)
-{
-	_remove_map(mpp, vecs, STOP_WAITER, purge_vec);
-}
-
-static void
-_remove_maps (struct vectors * vecs, int stop_waiter)
+void
+remove_maps(struct vectors * vecs)
 {
 	int i;
 	struct multipath * mpp;
@@ -171,7 +151,7 @@ _remove_maps (struct vectors * vecs, int stop_waiter)
 		return;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		_remove_map(mpp, vecs, stop_waiter, 1);
+		remove_map(mpp, vecs, 1);
 		i--;
 	}
 
@@ -179,16 +159,6 @@ _remove_maps (struct vectors * vecs, int stop_waiter)
 	vecs->mpvec = NULL;
 }
 
-void remove_maps(struct vectors *vecs)
-{
-	_remove_maps(vecs, KEEP_WAITER);
-}
-
-void remove_maps_and_stop_waiters(struct vectors *vecs)
-{
-	_remove_maps(vecs, STOP_WAITER);
-}
-
 void
 extract_hwe_from_path(struct multipath * mpp)
 {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 3749eb6..2a0be93 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -27,9 +27,7 @@ int update_multipath_strings (struct multipath *mpp, vector pathvec,
 void extract_hwe_from_path(struct multipath * mpp);
 
 void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
-void remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs, int purge_vec);
 void remove_maps (struct vectors * vecs);
-void remove_maps_and_stop_waiters (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
 int update_map (struct multipath *mpp, struct vectors *vecs);
diff --git a/multipathd/main.c b/multipathd/main.c
index ce914ab..32cd6fe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -293,6 +293,29 @@ switch_pathgroup (struct multipath * mpp)
 		 mpp->alias, mpp->bestpg);
 }
 
+static void
+remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs,
+			   int purge_vec)
+{
+	stop_waiter_thread(mpp, vecs);
+	remove_map(mpp, vecs, purge_vec);
+}
+
+static void
+remove_maps_and_stop_waiters(struct vectors *vecs)
+{
+	int i;
+	struct multipath * mpp;
+
+	if (!vecs)
+		return;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i)
+		stop_waiter_thread(mpp, vecs);
+
+	remove_maps(vecs);
+}
+
 static int
 coalesce_maps(struct vectors *vecs, vector nmpv)
 {
-- 
2.7.4
