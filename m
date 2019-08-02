From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 04/16] libmultipath: add wrapper function around
	pgpolicyfn
Date: Fri,  2 Aug 2019 11:33:30 -0500
Message-ID: <1564763622-31752-5-git-send-email-bmarzins@redhat.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Muneendra Kumar <mkumar@redhat.com>
List-Id: dm-devel.ids

group_paths() is a wrapper around the pgpolicy functions, that pulls out
the common code from the beginning and the end. However since
one_group() didn't free the mp->paths vector, it has to set it to NULL,
to avoid having the wrapper code do that. Also, the pathgroups in
group_by_prio are now needlessly sorted afterwards.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c  |  2 +-
 libmultipath/pgpolicies.c | 65 +++++++++++++--------------------------
 libmultipath/pgpolicies.h |  2 +-
 3 files changed, 23 insertions(+), 46 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b09ef529..3c309d64 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -387,7 +387,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 		vector_free(mpp->pg);
 		mpp->pg = NULL;
 	}
-	if (mpp->pgpolicyfn && mpp->pgpolicyfn(mpp))
+	if (group_paths(mpp))
 		return 1;
 
 	/*
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 660768a4..21d4f122 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -84,6 +84,26 @@ sort_pathgroups (struct multipath *mp) {
 }
 
 
+int group_paths(struct multipath *mp)
+{
+	if (!mp->pg)
+		mp->pg = vector_alloc();
+	if (!mp->pg)
+		return 1;
+
+	if (VECTOR_SIZE(mp->paths) > 0 &&
+	    (!mp->pgpolicyfn || mp->pgpolicyfn(mp))) {
+		vector_free(mp->pg);
+		mp->pg = NULL;
+		return 1;
+	}
+
+	sort_pathgroups(mp);
+	vector_free(mp->paths);
+	mp->paths = NULL;
+	return 0;
+}
+
 /*
  * One path group per unique tgt_node_name present in the path vector
  */
@@ -95,12 +115,6 @@ int group_by_node_name(struct multipath * mp)
 	struct pathgroup * pgp;
 	struct path * pp2;
 
-	if (!mp->pg)
-		mp->pg = vector_alloc();
-
-	if (!mp->pg)
-		return 1;
-
 	/* init the bitmap */
 	bitmap = (int *)MALLOC(VECTOR_SIZE(mp->paths) * sizeof (int));
 
@@ -146,9 +160,6 @@ int group_by_node_name(struct multipath * mp)
 		}
 	}
 	FREE(bitmap);
-	sort_pathgroups(mp);
-	free_pathvec(mp->paths, KEEP_PATHS);
-	mp->paths = NULL;
 	return 0;
 out2:
 	free_pathgroup(pgp, KEEP_PATHS);
@@ -171,12 +182,6 @@ int group_by_serial(struct multipath * mp)
 	struct pathgroup * pgp;
 	struct path * pp2;
 
-	if (!mp->pg)
-		mp->pg = vector_alloc();
-
-	if (!mp->pg)
-		return 1;
-
 	/* init the bitmap */
 	bitmap = (int *)MALLOC(VECTOR_SIZE(mp->paths) * sizeof (int));
 
@@ -221,9 +226,6 @@ int group_by_serial(struct multipath * mp)
 		}
 	}
 	FREE(bitmap);
-	sort_pathgroups(mp);
-	free_pathvec(mp->paths, KEEP_PATHS);
-	mp->paths = NULL;
 	return 0;
 out2:
 	free_pathgroup(pgp, KEEP_PATHS);
@@ -241,12 +243,6 @@ int one_path_per_group(struct multipath *mp)
 	struct path * pp;
 	struct pathgroup * pgp;
 
-	if (!mp->pg)
-		mp->pg = vector_alloc();
-
-	if (!mp->pg)
-		return 1;
-
 	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
 		pp = VECTOR_SLOT(mp->paths, i);
 		pgp = alloc_pathgroup();
@@ -260,9 +256,6 @@ int one_path_per_group(struct multipath *mp)
 		if (store_path(pgp->paths, pp))
 			goto out1;
 	}
-	sort_pathgroups(mp);
-	free_pathvec(mp->paths, KEEP_PATHS);
-	mp->paths = NULL;
 	return 0;
 out1:
 	free_pathgroup(pgp, KEEP_PATHS);
@@ -276,15 +269,6 @@ int one_group(struct multipath *mp)	/* aka multibus */
 {
 	struct pathgroup * pgp;
 
-	if (VECTOR_SIZE(mp->paths) < 0)
-		return 0;
-
-	if (!mp->pg)
-		mp->pg = vector_alloc();
-
-	if (!mp->pg)
-		return 1;
-
 	if (VECTOR_SIZE(mp->paths) > 0) {
 		pgp = alloc_pathgroup();
 
@@ -297,6 +281,7 @@ int one_group(struct multipath *mp)	/* aka multibus */
 			goto out1;
 
 		pgp->paths = mp->paths;
+		/* Do this to avoid freeing vector in group_paths */
 		mp->paths = NULL;
 	}
 
@@ -317,12 +302,6 @@ int group_by_prio(struct multipath *mp)
 	struct pathgroup * pgp;
 	vector pathvec = NULL;
 
-	if (!mp->pg)
-		mp->pg = vector_alloc();
-
-	if (!mp->pg)
-		return 1;
-
 	pathvec = vector_alloc();
 	if (!pathvec)
 		goto out;
@@ -387,8 +366,6 @@ int group_by_prio(struct multipath *mp)
 		}
 	}
 	free_pathvec(pathvec, KEEP_PATHS);
-	free_pathvec(mp->paths, KEEP_PATHS);
-	mp->paths = NULL;
 	return 0;
 out2:
 	free_pathgroup(pgp, KEEP_PATHS);
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index c0eaa7f4..11834011 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -21,7 +21,7 @@ enum iopolicies {
 
 int get_pgpolicy_id(char *);
 int get_pgpolicy_name (char *, int, int);
-
+int group_paths(struct multipath *);
 /*
  * policies
  */
-- 
2.17.2
