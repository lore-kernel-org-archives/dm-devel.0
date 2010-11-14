From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: clean up path orphaning and adoption
Date: Sun, 14 Nov 2010 15:02:14 -0600
Message-ID: <20101114210214.GR13763@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Make sure that multipathd orphans paths when they don't get included in maps,
to reset them to a consistent state, and make sure that multipath adopts paths
that get picked up during a table reload. However, multipathd shouldn't change
the state or priority of paths when it's updating due to a table reload,
since this can interfere with the checkerloop.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |    8 ++++++--
 libmultipath/structs_vec.c |   12 +++++++-----
 libmultipath/structs_vec.h |    2 +-
 multipathd/main.c          |   22 ++++++++++++----------
 4 files changed, 26 insertions(+), 18 deletions(-)

Index: multipath-tools-101104/libmultipath/configure.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/configure.c
+++ multipath-tools-101104/libmultipath/configure.c
@@ -472,16 +472,20 @@ coalesce_paths (struct vectors * vecs, v
 
 		/* 1. if path has no unique id or wwid blacklisted */
 		if (memcmp(empty_buff, pp1->wwid, WWID_SIZE) == 0 ||
-		    filter_path(conf, pp1) > 0)
+		    filter_path(conf, pp1) > 0) {
+			orphan_path(pp1);
 			continue;
+		}
 
 		/* 2. if path already coalesced */
 		if (pp1->mpp)
 			continue;
 
 		/* 3. if path has disappeared */
-		if (!pp1->size)
+		if (!pp1->size) {
+			orphan_path(pp1);
 			continue;
+		}
 
 		/* 4. path is out of scope */
 		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE))
Index: multipath-tools-101104/multipathd/main.c
===================================================================
--- multipath-tools-101104.orig/multipathd/main.c
+++ multipath-tools-101104/multipathd/main.c
@@ -387,7 +387,7 @@ ev_add_path (char * devname, struct vect
 	 */
 	if (memcmp(empty_buff, pp->wwid, WWID_SIZE) == 0) {
 		condlog(0, "%s: failed to get path uid", devname);
-		return 1; /* leave path added to pathvec */
+		goto fail; /* leave path added to pathvec */
 	}
 	if (filter_path(conf, pp) > 0){
 		int i = find_slot(vecs->pathvec, (void *)pp);
@@ -417,8 +417,8 @@ rescan:
 
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
-		if (adopt_paths(vecs->pathvec, mpp))
-			return 1; /* leave path added to pathvec */
+		if (adopt_paths(vecs->pathvec, mpp, 1))
+			goto fail; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs, NULL);
 		mpp->flush_on_last_del = FLUSH_UNDEF;
@@ -439,7 +439,7 @@ rescan:
 		if ((mpp = add_map_with_path(vecs, pp, 1)))
 			mpp->action = ACT_CREATE;
 		else
-			return 1; /* leave path added to pathvec */
+			goto fail; /* leave path added to pathvec */
 	}
 
 	/*
@@ -448,7 +448,7 @@ rescan:
 	if (setup_map(mpp)) {
 		condlog(0, "%s: failed to setup map for addition of new "
 			"path %s", mpp->alias, devname);
-		goto out;
+		goto fail_map;
 	}
 	/*
 	 * reload the map for the multipath mapped device
@@ -466,7 +466,7 @@ rescan:
 			goto rescan;
 		}
 		else
-			goto out;
+			goto fail_map;
 	}
 	dm_lib_release();
 
@@ -474,19 +474,21 @@ rescan:
 	 * update our state from kernel regardless of create or reload
 	 */
 	if (setup_multipath(vecs, mpp))
-		goto out;
+		goto fail_map;
 
 	sync_map_state(mpp);
 
 	if (mpp->action == ACT_CREATE &&
 	    start_waiter_thread(mpp, vecs))
-			goto out;
+			goto fail_map;
 
 	condlog(2, "%s path added to devmap %s", devname, mpp->alias);
 	return 0;
 
-out:
+fail_map:
 	remove_map(mpp, vecs, 1);
+fail:
+	orphan_path(pp);
 	return 1;
 }
 
@@ -1161,7 +1163,7 @@ configure (struct vectors * vecs, int st
 	/*
 	 * create new set of maps & push changed ones into dm
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 0))
+	if (coalesce_paths(vecs, mpvec, NULL, 1))
 		return 1;
 
 	/*
Index: multipath-tools-101104/libmultipath/structs_vec.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/structs_vec.c
+++ multipath-tools-101104/libmultipath/structs_vec.c
@@ -46,7 +46,7 @@ update_mpp_paths(struct multipath * mpp,
 }
 
 extern int
-adopt_paths (vector pathvec, struct multipath * mpp)
+adopt_paths (vector pathvec, struct multipath * mpp, int get_info)
 {
 	int i;
 	struct path * pp;
@@ -69,7 +69,9 @@ adopt_paths (vector pathvec, struct mult
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
-			pathinfo(pp, conf->hwtable, DI_PRIO | DI_CHECKER);
+			if (get_info)
+				pathinfo(pp, conf->hwtable,
+					 DI_PRIO | DI_CHECKER);
 		}
 	}
 	return 0;
@@ -357,7 +359,6 @@ retry:
 		goto out;
 	}
 
-	//adopt_paths(vecs->pathvec, mpp);
 	if (!mpp->hwe)
 		mpp->hwe = extract_hwe_from_path(mpp);
 	if (!mpp->hwe) {
@@ -392,7 +393,7 @@ add_map_without_path (struct vectors * v
 		return NULL; /* mpp freed in setup_multipath */
 	}
 
-	if (adopt_paths(vecs->pathvec, mpp))
+	if (adopt_paths(vecs->pathvec, mpp, 1))
 		goto out;
 
 	if (!vector_alloc_slot(vecs->mpvec))
@@ -425,7 +426,7 @@ add_map_with_path (struct vectors * vecs
 	select_alias(mpp);
 	mpp->size = pp->size;
 
-	if (adopt_paths(vecs->pathvec, mpp))
+	if (adopt_paths(vecs->pathvec, mpp, 1))
 		goto out;
 
 	if (add_vec) {
@@ -500,6 +501,7 @@ int update_multipath (struct vectors *ve
 	if (setup_multipath(vecs, mpp))
 		return 1; /* mpp freed in setup_multipath */
 
+	adopt_paths(vecs->pathvec, mpp, 0);
 	/*
 	 * compare checkers states with DM states
 	 */
Index: multipath-tools-101104/libmultipath/structs_vec.h
===================================================================
--- multipath-tools-101104.orig/libmultipath/structs_vec.h
+++ multipath-tools-101104/libmultipath/structs_vec.h
@@ -15,7 +15,7 @@ struct vectors {
 
 void set_no_path_retry(struct multipath *mpp);
 
-int adopt_paths (vector pathvec, struct multipath * mpp);
+int adopt_paths (vector pathvec, struct multipath * mpp, int get_info);
 void orphan_paths (vector pathvec, struct multipath * mpp);
 void orphan_path (struct path * pp);
 
