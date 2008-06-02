From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/2] Allow zero paths for multipath map
Date: Mon, 02 Jun 2008 10:52:30 +0200
Message-ID: <20080602085230.BF0E018C71D@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Christophe@suse.de, dm-devel@redhat.com, Varoqui@suse.de, christophe.varoqui@free.fr
List-Id: dm-devel.ids


There is no reason why multipath should handle the removal
of the last path from a multipath map different than any other
path removal. In fact, in doing so we'll shed the stale reference
to the dead device in the map and allow for a clean reconnection.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c   |    6 +-
 libmultipath/dmparser.c    |   15 +++-
 libmultipath/pgpolicies.c  |    5 ++
 libmultipath/structs.c     |   22 +++++--
 libmultipath/structs.h     |    1 +
 libmultipath/structs_vec.c |   16 +++--
 multipathd/main.c          |  158 ++++++++++++++++++++------------------------
 7 files changed, 119 insertions(+), 104 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ad76832..13897e2 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -189,14 +189,14 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
-	if (strncmp(cmpp->hwhandler, mpp->hwhandler,
+	if (!cmpp->selector || strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler))) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (hwhandler change)",
 			mpp->alias);
 		return;
 	}
-	if (strncmp(cmpp->selector, mpp->selector,
+	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (selector change)",
@@ -209,7 +209,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias, cmpp->minio, mpp->minio);
 		return;
 	}
-	if (VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
+	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (path group number change)",
 			mpp->alias);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index df7a0c3..bc3f231 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -145,6 +145,8 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 			FREE(word);
 			return 1;
 		}
+		setup_feature(mpp, word);
+
 		FREE(word);
 	}
 
@@ -182,11 +184,12 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 	num_pg = atoi(word);
 	FREE(word);
 
-	if (num_pg > 0 && !mpp->pg)
+	if (num_pg > 0 && !mpp->pg) {
 		mpp->pg = vector_alloc();
-	
-	if (!mpp->pg)
-		return 1;
+		if (!mpp->pg)
+			return 1;
+	}
+
 	/*
 	 * first pg to try
 	 */
@@ -327,6 +330,7 @@ out1:
 	FREE(word);
 out:
 	free_pgvec(mpp->pg, KEEP_PATHS);
+	mpp->pg = NULL;
 	return 1;
 }
 
@@ -396,6 +400,9 @@ disassemble_status (char * params, struct multipath * mpp)
 	num_pg = atoi(word);
 	FREE(word);
 
+	if (num_pg == 0)
+		return 0;
+
 	/*
 	 * next pg to try
 	 */
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 1a355af..2a9671a 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -126,6 +126,7 @@ out1:
 	FREE(bitmap);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -197,6 +198,7 @@ out1:
 	FREE(bitmap);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -231,6 +233,7 @@ one_path_per_group (struct multipath * mp)
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -263,6 +266,7 @@ one_group (struct multipath * mp)	/* aka multibus */
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 }
 
@@ -337,6 +341,7 @@ group_by_prio (struct multipath * mp)
 	return 0;
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
+	mp->pg = NULL;
 	return 1;
 
 }
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 082d53f..852e6b3 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -362,15 +362,27 @@ pathcount (struct multipath * mpp, int state)
 	int count = 0;
 	int i;
 
-	vector_foreach_slot (mpp->pg, pgp, i)
-		count += pathcountgr(pgp, state);
-
+	if (mpp->pg) {
+		vector_foreach_slot (mpp->pg, pgp, i)
+			count += pathcountgr(pgp, state);
+	}
 	return count;
 }
 
 struct path *
 first_path (struct multipath * mpp)
 {
-	struct pathgroup * pgp = VECTOR_SLOT(mpp->pg, 0);
-	return VECTOR_SLOT(pgp->paths, 0);
+	struct pathgroup * pgp;
+	if (!mpp->pg)
+		return NULL;
+	pgp = VECTOR_SLOT(mpp->pg, 0);
+
+	return pgp?VECTOR_SLOT(pgp->paths, 0):NULL;
+}
+
+extern void
+setup_feature(struct multipath * mpp, char *feature)
+{
+	if (!strncmp(feature, "queue_if_no_path", 16))
+		mpp->no_path_retry = NO_PATH_RETRY_QUEUE;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 2517782..85d5109 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -211,6 +211,7 @@ struct path * first_path (struct multipath * mpp);
 
 int pathcountgr (struct pathgroup *, int);
 int pathcount (struct multipath *, int);
+void setup_feature(struct multipath *, char *);
 
 extern char sysfs_path[PATH_SIZE];
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6757eb9..3bb79cd 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -187,13 +187,16 @@ remove_maps_and_stop_waiters (struct vectors * vecs)
 static struct hwentry *
 extract_hwe_from_path(struct multipath * mpp)
 {
-	struct path * pp;
-	struct pathgroup * pgp;
+	struct path * pp = NULL;
+	struct pathgroup * pgp = NULL;
+
+	if (mpp && mpp->pg)
+		pgp = VECTOR_SLOT(mpp->pg, 0);
 
-	pgp = VECTOR_SLOT(mpp->pg, 0);
-	pp = VECTOR_SLOT(pgp->paths, 0);
+	if (pgp && pgp->paths)
+		pp = VECTOR_SLOT(pgp->paths, 0);
 
-	return pp->hwe;
+	return pp?pp->hwe:NULL;
 }
 
 static int
@@ -247,7 +250,8 @@ set_no_path_retry(struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	select_no_path_retry(mpp);
+	if (mpp->nr_active > 0)
+		select_no_path_retry(mpp);
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
diff --git a/multipathd/main.c b/multipathd/main.c
index 8c752d2..f68dc41 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -140,7 +140,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 			}
 			else {
 				dm_lib_release();
-				condlog(3, "%s devmap removed", ompp->alias);
+				condlog(2, "%s devmap removed", ompp->alias);
 			}
 		}
 	}
@@ -154,6 +154,9 @@ sync_map_state(struct multipath *mpp)
 	struct path *pp;
 	unsigned int i, j;
 
+	if (!mpp->pg)
+		return;
+
 	vector_foreach_slot (mpp->pg, pgp, i){
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (pp->state <= PATH_UNCHECKED)
@@ -198,7 +201,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs)
 	}
 	else {
 		dm_lib_release();
-		condlog(3, "%s: devmap removed", mpp->alias);
+		condlog(2, "%s: devmap removed", mpp->alias);
 	}
 
 	orphan_paths(vecs->pathvec, mpp);
@@ -260,7 +263,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 	 */
 	if (map_present && (mpp = add_map_without_path(vecs, minor, alias))) {
 		sync_map_state(mpp);
-		condlog(3, "%s: devmap %s added", alias, dev->kernel);
+		condlog(2, "%s: devmap %s added", alias, dev->kernel);
 		return 0;
 	}
 	refwwid = get_refwwid(dev->kernel, DEV_DEVMAP, vecs->pathvec);
@@ -271,7 +274,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 	}
 
 	if (!r)
-		condlog(3, "%s: devmap %s added", alias, dev->kernel);
+		condlog(2, "%s: devmap %s added", alias, dev->kernel);
 	else
 		condlog(0, "%s: uev_add_map %s failed", alias, dev->kernel);
 
@@ -294,7 +297,7 @@ ev_remove_map (char * devname, struct vectors * vecs)
 	mpp = find_mp_by_str(vecs->mpvec, devname);
 
 	if (!mpp) {
-		condlog(3, "%s: devmap not registered, can't remove",
+		condlog(2, "%s: devmap not registered, can't remove",
 			devname);
 		return 0;
 	}
@@ -435,7 +438,7 @@ rescan:
 	    start_waiter_thread(mpp, vecs))
 			goto out;
 
-	condlog(3, "%s path added to devmap %s", devname, mpp->alias);
+	condlog(2, "%s path added to devmap %s", devname, mpp->alias);
 	return 0;
 
 out:
@@ -461,8 +464,7 @@ ev_remove_path (char * devname, struct vectors * vecs)
 {
 	struct multipath * mpp;
 	struct path * pp;
-	int i;
-	int rm_path = 1;
+	int i, retval = 0;
 
 	pp = find_path_by_dev(vecs->pathvec, devname);
 
@@ -472,97 +474,78 @@ ev_remove_path (char * devname, struct vectors * vecs)
 	}
 
 	/*
-	 * avoid referring to the map of an orphanned path
+	 * avoid referring to the map of an orphaned path
 	 */
 	if ((mpp = pp->mpp)) {
+		/*
+		 * transform the mp->pg vector of vectors of paths
+		 * into a mp->params string to feed the device-mapper
+		 */
+		if (update_mpp_paths(mpp, vecs->pathvec)) {
+			condlog(0, "%s: failed to update paths",
+				mpp->alias);
+			goto out;
+		}
+		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
+			vector_del_slot(mpp->paths, i);
 
 		/*
 		 * remove the map IFF removing the last path
 		 */
-		if (pathcount(mpp, PATH_WILD) > 1) {
-			vector rpvec = vector_alloc();
+		if (VECTOR_SIZE(mpp->paths) == 0) {
+			char alias[WWID_SIZE];
 
 			/*
-			 * transform the mp->pg vector of vectors of paths
-			 * into a mp->params string to feed the device-mapper
+			 * flush_map will fail if the device is open
 			 */
-			update_mpp_paths(mpp, vecs->pathvec);
-			if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
-				vector_del_slot(mpp->paths, i);
-
-			if (VECTOR_SIZE(mpp->paths) == 0) {
-				char alias[WWID_SIZE];
-
-				/*
-				 * flush_map will fail if the device is open
-				 */
-				strncpy(alias, mpp->alias, WWID_SIZE);
-				if (flush_map(mpp, vecs))
-					rm_path = 0;
-				else
-					condlog(3, "%s: removed map after removing"
-						" multiple paths", alias);
-			}
-			else {
-				if (setup_map(mpp)) {
-					condlog(0, "%s: failed to setup map for"
-						" removal of path %s", mpp->alias, devname);
-					free_pathvec(rpvec, KEEP_PATHS);
-					goto out;
-				}
-				/*
-				 * reload the map
-				 */
-				mpp->action = ACT_RELOAD;
-				if (domap(mpp) <= 0) {
-					condlog(0, "%s: failed in domap for "
-						"removal of path %s",
-						mpp->alias, devname);
-					/*
-					 * Delete path from pathvec so that
-					 * update_mpp_paths wont find it later
-					 * when/if another path is removed.
-					 */
-					if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
-						vector_del_slot(vecs->pathvec, i);
-					free_path(pp);
-					return 1;
-				}
-				/*
-				 * update our state from kernel
-				 */
-				if (setup_multipath(vecs, mpp)) {
-					free_pathvec(rpvec, KEEP_PATHS);
-					goto out;
-				}
-				sync_map_state(mpp);
-
-				condlog(3, "%s: path removed from map %s",
-					devname, mpp->alias);
+			strncpy(alias, mpp->alias, WWID_SIZE);
+			if (!flush_map(mpp, vecs)) {
+				condlog(2, "%s: removed map after"
+					" removing all paths",
+					alias);
+				free_path(pp);
+				return 0;
 			}
-			free_pathvec(rpvec, KEEP_PATHS);
+			/*
+			 * Not an error, continue
+			 */
 		}
-		else {
-			char alias[WWID_SIZE];
 
+		if (setup_map(mpp)) {
+			condlog(0, "%s: failed to setup map for"
+				" removal of path %s", mpp->alias,
+				devname);
+			goto out;
+		}
+		/*
+		 * reload the map
+		 */
+		mpp->action = ACT_RELOAD;
+		if (domap(mpp) <= 0) {
+			condlog(0, "%s: failed in domap for "
+				"removal of path %s",
+				mpp->alias, devname);
+			retval = 1;
+		} else {
 			/*
-			 * flush_map will fail if the device is open
+			 * update our state from kernel
 			 */
-			strncpy(alias, mpp->alias, WWID_SIZE);
-			if (flush_map(mpp, vecs))
-				rm_path = 0;
-			else
-				condlog(3, "%s: removed map", alias);
+			if (setup_multipath(vecs, mpp)) {
+				goto out;
+			}
+			sync_map_state(mpp);
+
+			condlog(2, "%s: path removed from map %s",
+				devname, mpp->alias);
 		}
 	}
 
-	if (rm_path) {
-		if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
-			vector_del_slot(vecs->pathvec, i);
-		free_path(pp);
-	}
+	if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
+		vector_del_slot(vecs->pathvec, i);
 
-	return 0;
+	free_path(pp);
+
+	return retval;
 
 out:
 	remove_map_and_stop_waiter(mpp, vecs, 1);
@@ -1023,12 +1006,15 @@ checkerloop (void *ap)
 		lock(vecs->lock);
 		condlog(4, "tick");
 
-		vector_foreach_slot (vecs->pathvec, pp, i) {
-			check_path(vecs, pp);
+		if (vecs->pathvec) {
+			vector_foreach_slot (vecs->pathvec, pp, i) {
+				check_path(vecs, pp);
+			}
+		}
+		if (vecs->mpvec) {
+			defered_failback_tick(vecs->mpvec);
+			retry_count_tick(vecs->mpvec);
 		}
-		defered_failback_tick(vecs->mpvec);
-		retry_count_tick(vecs->mpvec);
-
 		if (count)
 			count--;
 		else {
-- 
1.5.2.4
