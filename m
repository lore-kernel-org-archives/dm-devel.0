From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: recheck all priorities when a path
	comes back up
Date: Sun, 24 Apr 2011 22:48:00 -0500
Message-ID: <20110425034800.GB23657@ether.msp.redhat.com>
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

For group_by_prio paths, when a path goes down, its possible that the
priorities of the paths will be readjusted, and the multipath device will be
reloaded with a different path layout. However, downed paths don't get their
priority checked, so when the path comes back up and the original priorities
are restored, multipathd may not notice that the path layout needs to be
recalculated. This patch makes multipathd recalculate the the priorities of all
the paths when a path is restored, and reloads the map if any of them have
changed.  Also, when a path is restored, multipathd checks twice in
check_path if the pathgroup needs switching.  This should only happen once.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |   62 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

Index: multipath-tools-110412/multipathd/main.c
===================================================================
--- multipath-tools-110412.orig/multipathd/main.c
+++ multipath-tools-110412/multipathd/main.c
@@ -920,19 +920,47 @@ retry_count_tick(vector mpvec)
 	}
 }
 
-int update_path_groups(struct multipath *mpp, struct vectors *vecs)
+int update_prio(struct path *pp, int refresh_all)
+{
+	int oldpriority;
+	struct path *pp1;
+	struct pathgroup * pgp;
+	int i, j, changed = 0;
+
+	if (refresh_all) {
+		vector_foreach_slot (pp->mpp->pg, pgp, i) {
+			vector_foreach_slot (pgp->paths, pp1, j) {
+				oldpriority = pp1->priority;
+				pathinfo(pp1, conf->hwtable, DI_PRIO);
+				if (pp1->priority != oldpriority)
+					changed = 1;
+			}
+		}
+		return changed;
+	}
+	oldpriority = pp->priority;
+	pathinfo(pp, conf->hwtable, DI_PRIO);
+
+	if (pp->priority == oldpriority)
+		return 0;
+	return 1;
+}
+
+int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 {
 	int i;
 	struct path * pp;
 
 	update_mpp_paths(mpp, vecs->pathvec);
-	vector_foreach_slot (mpp->paths, pp, i)
-		pathinfo(pp, conf->hwtable, DI_PRIO);
+	if (refresh) {
+		vector_foreach_slot (mpp->paths, pp, i)
+			pathinfo(pp, conf->hwtable, DI_PRIO);
+	}
 	setup_map(mpp);
 	mpp->action = ACT_RELOAD;
 	if (domap(mpp) <= 0) {
 		condlog(0, "%s: failed to update map : %s", mpp->alias,
-				strerror(errno));
+			strerror(errno));
 		return 1;
 	}
 	dm_lib_release();
@@ -946,7 +974,7 @@ void
 check_path (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
-	int oldpriority;
+	int new_path_up = 0;
 
 	if (!pp->mpp)
 		return;
@@ -1015,15 +1043,7 @@ check_path (struct vectors * vecs, struc
 		else
 			reinstate_path(pp, 0);
 
-		/*
-		 * schedule [defered] failback
-		 */
-		if (pp->mpp->pgfailback > 0)
-			pp->mpp->failback_tick =
-				pp->mpp->pgfailback + 1;
-		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE &&
-		    need_switch_pathgroup(pp->mpp, 1))
-			switch_pathgroup(pp->mpp);
+		new_path_up = 1;
 
 		/*
 		 * if at least one path is up in a group, and
@@ -1056,22 +1076,16 @@ check_path (struct vectors * vecs, struc
 	 * path prio refreshing
 	 */
 	condlog(4, "path prio refresh");
-	oldpriority = pp->priority;
-	pathinfo(pp, conf->hwtable, DI_PRIO);
 
-	/*
-	 * pathgroup failback policy
-	 */
-	if (pp->priority != oldpriority &&
+	if (update_prio(pp, new_path_up) &&
 	    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio)
-		update_path_groups(pp->mpp, vecs);
+		update_path_groups(pp->mpp, vecs, !new_path_up);
 	else if (need_switch_pathgroup(pp->mpp, 0)) {
 		if (pp->mpp->pgfailback > 0 &&
-		    pp->mpp->failback_tick <= 0)
+		    (new_path_up || pp->mpp->failback_tick <= 0))
 			pp->mpp->failback_tick =
 				pp->mpp->pgfailback + 1;
-		else if (pp->mpp->pgfailback ==
-				-FAILBACK_IMMEDIATE)
+		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
 			switch_pathgroup(pp->mpp);
 	}
 }
