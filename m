From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 08/14] libmultipath: make pgpolicyfn take a
	paths vector
Date: Fri, 23 Aug 2019 12:48:52 -0500
Message-ID: <1566582538-5979-9-git-send-email-bmarzins@redhat.com>
References: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Muneendra Kumar <mkumar@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

To enable future changes, mp->pgpolicyfn() now takes a vector of
paths instead of always using mp->paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/pgpolicies.c | 38 +++++++++++++++++++-------------------
 libmultipath/pgpolicies.h | 10 +++++-----
 libmultipath/structs.h    |  2 +-
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 2e4db74c..2e7c0502 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -93,7 +93,7 @@ int group_paths(struct multipath *mp)
 		return 1;
 
 	if (VECTOR_SIZE(mp->paths) > 0 &&
-	    (!mp->pgpolicyfn || mp->pgpolicyfn(mp))) {
+	    (!mp->pgpolicyfn || mp->pgpolicyfn(mp, mp->paths))) {
 		vector_free(mp->pg);
 		mp->pg = NULL;
 		return 1;
@@ -126,7 +126,7 @@ prios_match(struct path *pp1, struct path *pp2)
 	return (pp1->priority == pp2->priority);
 }
 
-int group_by_match(struct multipath * mp,
+int group_by_match(struct multipath * mp, vector paths,
 		   bool (*path_match_fn)(struct path *, struct path *))
 {
 	int i, j;
@@ -136,17 +136,17 @@ int group_by_match(struct multipath * mp,
 	struct path * pp2;
 
 	/* init the bitmap */
-	bitmap = (int *)MALLOC(VECTOR_SIZE(mp->paths) * sizeof (int));
+	bitmap = (int *)MALLOC(VECTOR_SIZE(paths) * sizeof (int));
 
 	if (!bitmap)
 		goto out;
 
-	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
+	for (i = 0; i < VECTOR_SIZE(paths); i++) {
 
 		if (bitmap[i])
 			continue;
 
-		pp = VECTOR_SLOT(mp->paths, i);
+		pp = VECTOR_SLOT(paths, i);
 
 		/* here, we really got a new pg */
 		pgp = alloc_pathgroup();
@@ -163,12 +163,12 @@ int group_by_match(struct multipath * mp,
 
 		bitmap[i] = 1;
 
-		for (j = i + 1; j < VECTOR_SIZE(mp->paths); j++) {
+		for (j = i + 1; j < VECTOR_SIZE(paths); j++) {
 
 			if (bitmap[j])
 				continue;
 
-			pp2 = VECTOR_SLOT(mp->paths, j);
+			pp2 = VECTOR_SLOT(paths, j);
 
 			if (path_match_fn(pp, pp2)) {
 				if (store_path(pgp->paths, pp2))
@@ -193,35 +193,35 @@ out:
 /*
  * One path group per unique tgt_node_name present in the path vector
  */
-int group_by_node_name(struct multipath * mp)
+int group_by_node_name(struct multipath * mp, vector paths)
 {
-	return group_by_match(mp, node_names_match);
+	return group_by_match(mp, paths, node_names_match);
 }
 
 /*
  * One path group per unique serial number present in the path vector
  */
-int group_by_serial(struct multipath * mp)
+int group_by_serial(struct multipath * mp, vector paths)
 {
-	return group_by_match(mp, serials_match);
+	return group_by_match(mp, paths, serials_match);
 }
 
 /*
  * One path group per priority present in the path vector
  */
-int group_by_prio(struct multipath *mp)
+int group_by_prio(struct multipath *mp, vector paths)
 {
-	return group_by_match(mp, prios_match);
+	return group_by_match(mp, paths, prios_match);
 }
 
-int one_path_per_group(struct multipath *mp)
+int one_path_per_group(struct multipath *mp, vector paths)
 {
 	int i;
 	struct path * pp;
 	struct pathgroup * pgp;
 
-	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
-		pp = VECTOR_SLOT(mp->paths, i);
+	for (i = 0; i < VECTOR_SIZE(paths); i++) {
+		pp = VECTOR_SLOT(paths, i);
 		pgp = alloc_pathgroup();
 
 		if (!pgp)
@@ -242,7 +242,7 @@ out:
 	return 1;
 }
 
-int one_group(struct multipath *mp)	/* aka multibus */
+int one_group(struct multipath *mp, vector paths)	/* aka multibus */
 {
 	int i;
 	struct path * pp;
@@ -256,8 +256,8 @@ int one_group(struct multipath *mp)	/* aka multibus */
 	if (add_pathgroup(mp, pgp))
 		goto out1;
 
-	for (i = 0; i < VECTOR_SIZE(mp->paths); i++) {
-		pp = VECTOR_SLOT(mp->paths, i);
+	for (i = 0; i < VECTOR_SIZE(paths); i++) {
+		pp = VECTOR_SLOT(paths, i);
 
 		if (store_path(pgp->paths, pp))
 			goto out;
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index 11834011..7532d75f 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -25,10 +25,10 @@ int group_paths(struct multipath *);
 /*
  * policies
  */
-int one_path_per_group(struct multipath *);
-int one_group(struct multipath *);
-int group_by_serial(struct multipath *);
-int group_by_prio(struct multipath *);
-int group_by_node_name(struct multipath *);
+int one_path_per_group(struct multipath *, vector);
+int one_group(struct multipath *, vector);
+int group_by_serial(struct multipath *, vector);
+int group_by_prio(struct multipath *, vector);
+int group_by_node_name(struct multipath *, vector);
 
 #endif
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 893074eb..a8b9d325 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -295,7 +295,7 @@ struct path {
 	struct gen_path generic_path;
 };
 
-typedef int (pgpolicyfn) (struct multipath *);
+typedef int (pgpolicyfn) (struct multipath *, vector);
 
 struct multipath {
 	char wwid[WWID_SIZE];
-- 
2.17.2
