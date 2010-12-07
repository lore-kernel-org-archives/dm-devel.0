From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 7 Dec 2010 06:02:24 -0000
Message-ID: <20101207060224.20389.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-12-07 06:02:24

Modified files:
	multipathd     : main.c 

Log message:
	Fix for bug 650801.  Multipathd wasn't checking checking all the paths to see
	if it needed to update the pathgroups after a new path came back online.
	This could lead to paths accidentally ending up in the wrong pathgroup.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.30&r2=1.69.2.31

--- multipath-tools/multipathd/main.c	2010/09/08 21:40:30	1.69.2.30
+++ multipath-tools/multipathd/main.c	2010/12/07 06:02:23	1.69.2.31
@@ -937,14 +937,41 @@
 	return 0;
 }
 
-int update_path_groups(struct multipath *mpp, struct vectors *vecs)
+int update_prio(struct path *pp, int refresh_all)
+{
+	int oldpriority;
+	struct pathgroup * pgp;
+	int i, j, changed = 0;
+
+	if (refresh_all) {
+		vector_foreach_slot (pp->mpp->pg, pgp, i) {
+			vector_foreach_slot (pgp->paths, pp, j) {
+				oldpriority = pp->priority;
+				pathinfo(pp, conf->hwtable, DI_PRIO);
+				if (pp->priority != oldpriority)
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
@@ -969,7 +996,6 @@
 	int newstate;
 	unsigned int i;
 	sigset_t old;
-	int oldpriority;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -989,6 +1015,7 @@
 		condlog(4, "tick");
 
 		vector_foreach_slot (vecs->pathvec, pp, i) {
+			int new_path_up = 0;
 			if (!pp->mpp)
 				continue;
 
@@ -1081,16 +1108,7 @@
 					reinstate_path(pp, 1);
 				else
 					reinstate_path(pp, 0);
-
-				/*
-				 * schedule [defered] failback
-				 */
-				if (pp->mpp->pgfailback > 0)
-					pp->mpp->failback_tick =
-						pp->mpp->pgfailback + 1;
-				else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE &&
-				    need_switch_pathgroup(pp->mpp, 1))
-					switch_pathgroup(pp->mpp);
+				new_path_up = 1;
 
 				/*
 				 * if at least one path is up in a group, and
@@ -1127,15 +1145,13 @@
 			 * path prio refreshing
 			 */
 			condlog(4, "path prio refresh");
-			oldpriority = pp->priority;
-			pathinfo(pp, conf->hwtable, DI_PRIO);
-
-			if (pp->priority != oldpriority &&
+			if (update_prio(pp, new_path_up) &&
 			    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio)
-				update_path_groups(pp->mpp, vecs);
+				update_path_groups(pp->mpp, vecs, !new_path_up);
 			else if (need_switch_pathgroup(pp->mpp, 0)) {
 				if (pp->mpp->pgfailback > 0 &&
-				    pp->mpp->failback_tick <= 0)
+				    (new_path_up ||
+				     pp->mpp->failback_tick <= 0))
 					pp->mpp->failback_tick =
 						pp->mpp->pgfailback + 1;
 				else if (pp->mpp->pgfailback ==
