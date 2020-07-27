From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/6] libmultipath: remove code duplication in
	path counting
Date: Mon, 27 Jul 2020 14:24:25 -0500
Message-ID: <1595877868-5595-4-git-send-email-bmarzins@redhat.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

pathcountgr() is never used except by pathcount(), and neither is the
special case for PATH_WILD. Simplify this and make one function that is
used by both pathcount() and count_active_paths(). This will be used
again in a future patch.

Also use count_active_paths() in mpath_persist.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c |  4 +--
 libmultipath/structs.c          | 47 +++++++++++++--------------------
 libmultipath/structs.h          |  1 -
 3 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 3da7a6cf..a132f4e9 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -436,7 +436,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 
 	all_tg_pt = (mpp->all_tg_pt == ALL_TG_PT_ON ||
 		     paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK);
-	active_pathcount = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
+	active_pathcount = count_active_paths(mpp);
 
 	if (active_pathcount == 0) {
 		condlog (0, "%s: no path available", mpp->wwid);
@@ -648,7 +648,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
 
-	active_pathcount = pathcount (mpp, PATH_UP) + pathcount (mpp, PATH_GHOST);
+	active_pathcount = count_active_paths(mpp);
 
 	struct threadinfo thread[active_pathcount];
 	memset(thread, 0, sizeof(thread));
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 2dd378c4..3eac3d61 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -455,49 +455,40 @@ find_path_by_devt (const struct _vector *pathvec, const char * dev_t)
 	return NULL;
 }
 
-int pathcountgr(const struct pathgroup *pgp, int state)
+static int do_pathcount(const struct multipath *mpp, const int *states,
+			unsigned int nr_states)
 {
+	struct pathgroup *pgp;
 	struct path *pp;
 	int count = 0;
-	int i;
+	unsigned int i, j, k;
 
-	vector_foreach_slot (pgp->paths, pp, i)
-		if ((pp->state == state) || (state == PATH_WILD))
-			count++;
+	if (!mpp->pg || !nr_states)
+		return count;
 
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			for (k = 0; k < nr_states; k++) {
+				if (pp->state == states[k]) {
+					count++;
+					break;
+				}
+			}
+		}
+	}
 	return count;
 }
 
 int pathcount(const struct multipath *mpp, int state)
 {
-	struct pathgroup *pgp;
-	int count = 0;
-	int i;
-
-	if (mpp->pg) {
-		vector_foreach_slot (mpp->pg, pgp, i)
-			count += pathcountgr(pgp, state);
-	}
-	return count;
+	return do_pathcount(mpp, &state, 1);
 }
 
 int count_active_paths(const struct multipath *mpp)
 {
-	struct pathgroup *pgp;
-	struct path *pp;
-	int count = 0;
-	int i, j;
-
-	if (!mpp->pg)
-		return 0;
+	int states[] = {PATH_UP, PATH_GHOST};
 
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_UP || pp->state == PATH_GHOST)
-				count++;
-		}
-	}
-	return count;
+	return do_pathcount(mpp, states, 2);
 }
 
 int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d69bc2e9..0c03e711 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -446,7 +446,6 @@ struct path * find_path_by_devt (const struct _vector *pathvec, const char *devt
 struct path * find_path_by_dev (const struct _vector *pathvec, const char *dev);
 struct path * first_path (const struct multipath *mpp);
 
-int pathcountgr (const struct pathgroup *, int);
 int pathcount (const struct multipath *, int);
 int count_active_paths(const struct multipath *);
 int pathcmp (const struct pathgroup *, const struct pathgroup *);
-- 
2.17.2
