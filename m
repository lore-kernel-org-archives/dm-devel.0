From: mwilck@suse.com
Subject: [PATCH 2/3] libmultipath: remove_map(): separate pathvec
	and mpvec arguments
Date: Fri, 21 Aug 2020 15:54:17 +0200
Message-ID: <20200821135418.28138-3-mwilck@suse.com>
References: <20200821135418.28138-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821135418.28138-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng@huawei.com
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This will enable us to use remove_map() from multipath.
Also, pass symbolic arguments for remove_map() everywhere.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 11 ++++++-----
 libmultipath/structs_vec.c | 14 +++++++-------
 libmultipath/structs_vec.h |  8 ++++++--
 multipathd/dmevents.c      |  2 +-
 multipathd/main.c          | 12 ++++++------
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5fb5767..5bc65fd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1186,7 +1186,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 		if (!mpp->paths) {
 			condlog(0, "%s: skip coalesce (no paths)", mpp->alias);
-			remove_map(mpp, vecs, 0);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
 			continue;
 		}
 
@@ -1215,7 +1215,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 		params[0] = '\0';
 		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
-			remove_map(mpp, vecs, 0);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
 			continue;
 		}
 
@@ -1235,7 +1235,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				condlog(2, "%s: %s map",
 					mpp->alias, (mpp->action == ACT_CREATE)?
 					"ignoring" : "removing");
-				remove_map(mpp, vecs, 0);
+				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
 				continue;
 			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
 				ret = CP_RETRY;
@@ -1286,7 +1286,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				vector_set_slot(newmp, mpp);
 			}
 			else
-				remove_map(mpp, vecs, 0);
+				remove_map(mpp, vecs->pathvec, vecs->mpvec,
+					   KEEP_VEC);
 		}
 	}
 	/*
@@ -1304,7 +1305,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 			vector_del_slot(newmp, i);
 			i--;
-			remove_map(mpp, vecs, 0);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
 
 			if (dm_flush_map(alias))
 				condlog(2, "%s: remove failed (dead)",
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3d4f855..7fd860e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -329,18 +329,18 @@ void set_path_removed(struct path *pp)
 }
 
 void
-remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
+remove_map(struct multipath *mpp, vector pathvec, vector mpvec, int purge_vec)
 {
 	int i;
 
 	/*
 	 * clear references to this map
 	 */
-	orphan_paths(vecs->pathvec, mpp, "map removed internally");
+	orphan_paths(pathvec, mpp, "map removed internally");
 
 	if (purge_vec &&
-	    (i = find_slot(vecs->mpvec, (void *)mpp)) != -1)
-		vector_del_slot(vecs->mpvec, i);
+	    (i = find_slot(mpvec, (void *)mpp)) != -1)
+		vector_del_slot(mpvec, i);
 
 	/*
 	 * final free
@@ -354,7 +354,7 @@ remove_map_by_alias(const char *alias, struct vectors * vecs, int purge_vec)
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, alias);
 	if (mpp) {
 		condlog(2, "%s: removing map by alias", alias);
-		remove_map(mpp, vecs, purge_vec);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec, purge_vec);
 	}
 }
 
@@ -368,7 +368,7 @@ remove_maps(struct vectors * vecs)
 		return;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		remove_map(mpp, vecs, 1);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 		i--;
 	}
 
@@ -712,7 +712,7 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 	return mpp;
 
 out:
-	remove_map(mpp, vecs, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 	return NULL;
 }
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 478168f..ee2b723 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -27,9 +27,13 @@ int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
 void extract_hwe_from_path(struct multipath * mpp);
 
-#define PURGE_VEC 1
+enum {
+	KEEP_VEC,
+	PURGE_VEC,
+};
 
-void remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec);
+void remove_map (struct multipath *mpp, vector pathvec, vector mpvec,
+		 int purge_vec);
 void remove_map_by_alias(const char *alias, struct vectors * vecs,
 			 int purge_vec);
 void remove_maps (struct vectors * vecs);
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index b235dd4..5f2d210 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -357,7 +357,7 @@ static int dmevent_loop (void)
 		pthread_testcancel();
 		r = 0;
 		if (curr_dev.action == EVENT_REMOVE)
-			remove_map_by_alias(curr_dev.name, waiter->vecs, 1);
+			remove_map_by_alias(curr_dev.name, waiter->vecs, PURGE_VEC);
 		else
 			r = update_multipath(waiter->vecs, curr_dev.name, 1);
 		pthread_cleanup_pop(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index b8019ec..67e9af1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -379,7 +379,7 @@ remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 	condlog(3, "%s: removing map from internal tables", mpp->alias);
 	if (!poll_dmevents)
 		stop_waiter_thread(mpp);
-	remove_map(mpp, vecs, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 }
 
 static void
@@ -511,7 +511,7 @@ retry:
 fail:
 	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
 		condlog(0, "%s: failed to create new map", mpp->alias);
-		remove_map(mpp, vecs, 1);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 		return 1;
 	}
 
@@ -567,7 +567,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 
 	return mpp;
 out:
-	remove_map(mpp, vecs, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 	return NULL;
 }
 
@@ -1099,7 +1099,7 @@ rescan:
 		goto fail;
 
 fail_map:
-	remove_map(mpp, vecs, 1);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 fail:
 	orphan_path(pp, "failed to add path");
 	return 1;
@@ -1414,7 +1414,7 @@ map_discovery (struct vectors * vecs)
 	vector_foreach_slot (vecs->mpvec, mpp, i)
 		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK ||
 		    update_multipath_status(mpp) != DMP_OK) {
-			remove_map(mpp, vecs, 1);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 			i--;
 		}
 
@@ -2653,7 +2653,7 @@ configure (struct vectors * vecs)
 	 */
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (wait_for_events(mpp, vecs)) {
-			remove_map(mpp, vecs, 1);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 			i--;
 			continue;
 		}
-- 
2.28.0
