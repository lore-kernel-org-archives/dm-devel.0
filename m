From: zhang.kai16@zte.com.cn
Subject: [PATCH] libmultipath:fix memory leak in path group
	policies
Date: Tue, 26 Jul 2016 18:09:03 +0800
Message-ID: <1469527743-7548-1-git-send-email-zhang.kai16@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: "zhang.kai" <zhang.kai16@zte.com.cn>, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

From: "zhang.kai" <zhang.kai16@zte.com.cn>

In the path group functions, memory leak would happen if the exceptional situation were met.

Signed-off-by: zhang.kai <zhang.kai16@zte.com.cn>
---
 libmultipath/pgpolicies.c | 79 +++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 30 deletions(-)

diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index f440441..3064aab 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -123,11 +123,11 @@ group_by_node_name (struct multipath * mp) {
 			goto out1;
 
 		if (store_pathgroup(mp->pg, pgp))
-			goto out1;
+			goto out2;
 
 		/* feed the first path */
 		if (store_path(pgp->paths, pp))
-			goto out1;
+			goto out2;
 
 		bitmap[i] = 1;
 
@@ -141,7 +141,7 @@ group_by_node_name (struct multipath * mp) {
 			if (!strncmp(pp->tgt_node_name, pp2->tgt_node_name,
 					NODE_NAME_SIZE)) {
 				if (store_path(pgp->paths, pp2))
-					goto out1;
+					goto out2;
 
 				bitmap[j] = 1;
 			}
@@ -152,6 +152,8 @@ group_by_node_name (struct multipath * mp) {
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
+out2:
+	free_pathgroup(pgp, KEEP_PATHS);
 out1:
 	FREE(bitmap);
 out:
@@ -197,11 +199,11 @@ group_by_serial (struct multipath * mp) {
 			goto out1;
 
 		if (store_pathgroup(mp->pg, pgp))
-			goto out1;
+			goto out2;
 
 		/* feed the first path */
 		if (store_path(pgp->paths, pp))
-			goto out1;
+			goto out2;
 
 		bitmap[i] = 1;
 
@@ -214,7 +216,7 @@ group_by_serial (struct multipath * mp) {
 
 			if (0 == strcmp(pp->serial, pp2->serial)) {
 				if (store_path(pgp->paths, pp2))
-					goto out1;
+					goto out2;
 
 				bitmap[j] = 1;
 			}
@@ -225,6 +227,8 @@ group_by_serial (struct multipath * mp) {
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
+out2:
+	free_pathgroup(pgp, KEEP_PATHS);
 out1:
 	FREE(bitmap);
 out:
@@ -254,15 +258,17 @@ one_path_per_group (struct multipath * mp)
 			goto out;
 
 		if (store_pathgroup(mp->pg, pgp))
-			goto out;
+			goto out1;
 
 		if (store_path(pgp->paths, pp))
-			goto out;
+			goto out1;
 	}
 	sort_pathgroups(mp);
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
+out1:
+	free_pathgroup(pgp, KEEP_PATHS);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
@@ -290,14 +296,17 @@ one_group (struct multipath * mp)	/* aka multibus */
 			goto out;
 
 		vector_free(pgp->paths);
-		pgp->paths = mp->paths;
-		mp->paths = NULL;
 
 		if (store_pathgroup(mp->pg, pgp))
-			goto out;
+			goto out1;
+
+		pgp->paths = mp->paths;
+		mp->paths = NULL;
 	}
 
 	return 0;
+out1:
+	free_pathgroup(pgp, KEEP_PATHS);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
@@ -311,6 +320,7 @@ group_by_prio (struct multipath * mp)
 	unsigned int prio;
 	struct path * pp;
 	struct pathgroup * pgp;
+	vector pathvec = NULL;
 
 	if (!mp->pg)
 		mp->pg = vector_alloc();
@@ -318,8 +328,18 @@ group_by_prio (struct multipath * mp)
 	if (!mp->pg)
 		return 1;
 
-	while (VECTOR_SIZE(mp->paths) > 0) {
-		pp = VECTOR_SLOT(mp->paths, 0);
+	pathvec = vector_alloc();
+	if (!pathvec)
+		goto out;
+
+	vector_foreach_slot(mp->paths, pp, i) {
+		if (!vector_alloc_slot(pathvec))
+			goto out1;
+		vector_set_slot(pathvec, pp);
+	}
+
+	while (VECTOR_SIZE(pathvec) > 0) {
+		pp = VECTOR_SLOT(pathvec, 0);
 		prio = pp->priority;
 
 		/*
@@ -339,46 +359,45 @@ group_by_prio (struct multipath * mp)
 		pgp = alloc_pathgroup();
 
 		if (!pgp)
-			goto out;
+			goto out1;
 
-		if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, 0))) {
-			free_pathgroup(pgp, KEEP_PATHS);
-			goto out;
-		}
+		if (store_path(pgp->paths, VECTOR_SLOT(pathvec, 0)))
+			goto out2;
 
-		vector_del_slot(mp->paths, 0);
+		vector_del_slot(pathvec, 0);
 
 		/*
 		 * Store the new path group into the vector.
 		 */
 		if (i < VECTOR_SIZE(mp->pg)) {
-			if (!vector_insert_slot(mp->pg, i, pgp)) {
-				free_pathgroup(pgp, KEEP_PATHS);
-				goto out;
-			}
+			if (!vector_insert_slot(mp->pg, i, pgp))
+				goto out2;
 		} else {
-			if (store_pathgroup(mp->pg, pgp)) {
-				free_pathgroup(pgp, KEEP_PATHS);
-				goto out;
-			}
+			if (store_pathgroup(mp->pg, pgp))
+				goto out2;
 		}
 
 		/*
 		 * add the other paths with the same prio
 		 */
-		vector_foreach_slot(mp->paths, pp, i) {
+		vector_foreach_slot(pathvec, pp, i) {
 			if (pp->priority == prio) {
 				if (store_path(pgp->paths, pp))
-					goto out;
+					goto out2;
 
-				vector_del_slot(mp->paths, i);
+				vector_del_slot(pathvec, i);
 				i--;
 			}
 		}
 	}
+	free_pathvec(pathvec, KEEP_PATHS);
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
+out2:
+	free_pathgroup(pgp, KEEP_PATHS);
+out1:
+	free_pathvec(pathvec, KEEP_PATHS);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
-- 
2.8.1.windows.1
