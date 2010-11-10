From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: sort all pathgroups by priority
Date: Wed, 10 Nov 2010 12:52:20 -0600
Message-ID: <20101110185220.GN13763@ether.msp.redhat.com>
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

Right now, the only path grouping policy that sorts pathgroups by priority is
group_by_prio.  For the others, the pathgroups are setup in the order that
their paths are discovered.  This can cause a problem when the kernel needs to
switch pathgroups, such as when a path fails.  The kernel will simply pick the
first valid pathgroup.  If failback isn't set to manual, this can cause
needless pathgroup switching.  Even worse, with failback set to manual, which
is the default, the kernel will just continue to use the non-optimal pathgroup
until it fails.  This patch makes all path grouping policies except multibus
sort the pathgroups by priority.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/pgpolicies.c  |   32 ++++++++++++++++++++++++++++++++
 libmultipath/print.c       |    5 +----
 libmultipath/switchgroup.c |   14 ++++++++------
 libmultipath/vector.c      |   16 ++++++++++++++++
 4 files changed, 57 insertions(+), 10 deletions(-)

Index: multipath-tools-101104/libmultipath/pgpolicies.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/pgpolicies.c
+++ multipath-tools-101104/libmultipath/pgpolicies.c
@@ -11,6 +11,7 @@
 #include "vector.h"
 #include "structs.h"
 #include "pgpolicies.h"
+#include "switchgroup.h"
 
 extern int
 get_pgpolicy_id (char * str)
@@ -57,6 +58,34 @@ get_pgpolicy_name (char * buff, int len,
 	return snprintf(buff, POLICY_NAME_SIZE, "%s", s);
 }
 
+
+void
+sort_pathgroups (struct multipath *mp) {
+	int i, j;
+	struct pathgroup * pgp1, * pgp2;
+
+	if (!mp->pg)
+		return;
+
+	vector_foreach_slot(mp->pg, pgp1, i) {
+		path_group_prio_update(pgp1);
+		for (j = i - 1; j >= 0; j--) {
+			pgp2 = VECTOR_SLOT(mp->pg, j);
+			if (!pgp2)
+				continue;
+			if (pgp2->priority > pgp1->priority ||
+			    (pgp2->priority == pgp1->priority &&
+			     pgp2->enabled_paths >= pgp1->enabled_paths)) {
+				vector_move_up(mp->pg, i, j + 1);
+				break;
+			}
+		}
+		if (j < 0 && i != 0)
+		vector_move_up(mp->pg, i, 0);
+	}
+}
+
+
 /*
  * One path group per unique tgt_node_name present in the path vector
  */
@@ -119,6 +148,7 @@ group_by_node_name (struct multipath * m
 		}
 	}
 	FREE(bitmap);
+	sort_pathgroups(mp);
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
@@ -191,6 +221,7 @@ group_by_serial (struct multipath * mp) 
 		}
 	}
 	FREE(bitmap);
+	sort_pathgroups(mp);
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
@@ -228,6 +259,7 @@ one_path_per_group (struct multipath * m
 		if (store_path(pgp->paths, pp))
 			goto out;
 	}
+	sort_pathgroups(mp);
 	free_pathvec(mp->paths, KEEP_PATHS);
 	mp->paths = NULL;
 	return 0;
Index: multipath-tools-101104/libmultipath/print.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/print.c
+++ multipath-tools-101104/libmultipath/print.c
@@ -379,7 +379,6 @@ snprint_pg_selector (char * buff, size_t
 static int
 snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
 {
-	int avg_priority = 0;
 	/*
 	 * path group priority is not updated for every path prio change,
 	 * but only on switch group code path.
@@ -387,9 +386,7 @@ snprint_pg_pri (char * buff, size_t len,
 	 * Printing is another reason to update.
 	 */
 	path_group_prio_update(pgp);
-	if (pgp->enabled_paths)
-		avg_priority = pgp->priority / pgp->enabled_paths;
-	return snprint_int(buff, len, avg_priority);
+	return snprint_int(buff, len, pgp->priority);
 }
 
 static int
Index: multipath-tools-101104/libmultipath/switchgroup.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/switchgroup.c
+++ multipath-tools-101104/libmultipath/switchgroup.c
@@ -25,14 +25,17 @@ path_group_prio_update (struct pathgroup
 			pgp->enabled_paths++;
 		}
 	}
-	pgp->priority = priority;
+	if (pgp->enabled_paths)
+		pgp->priority = priority / pgp->enabled_paths;
+	else
+		pgp->priority = 0;
 }
 
 extern int
 select_path_group (struct multipath * mpp)
 {
 	int i;
-	int max_priority = 0, avg_priority;
+	int max_priority = 0;
 	int bestpg = 1;
 	int max_enabled_paths = 1;
 	struct pathgroup * pgp;
@@ -46,12 +49,11 @@ select_path_group (struct multipath * mp
 
 		path_group_prio_update(pgp);
 		if (pgp->enabled_paths) {
-			avg_priority = pgp->priority / pgp->enabled_paths;
-			if (avg_priority > max_priority) {
-				max_priority = avg_priority;
+			if (pgp->priority > max_priority) {
+				max_priority = pgp->priority;
 				max_enabled_paths = pgp->enabled_paths;
 				bestpg = i + 1;
-			} else if (avg_priority == max_priority) {
+			} else if (pgp->priority == max_priority) {
 				if (pgp->enabled_paths > max_enabled_paths) {
 					max_enabled_paths = pgp->enabled_paths;
 					bestpg = i + 1;
Index: multipath-tools-101104/libmultipath/vector.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/vector.c
+++ multipath-tools-101104/libmultipath/vector.c
@@ -50,6 +50,22 @@ vector_alloc_slot(vector v)
 	return v->slot;
 }
 
+int
+vector_move_up(vector v, int src, int dest)
+{
+	void *value;
+	int i;
+	if (dest == src)
+		return 0;
+	if (dest > src || src >= v->allocated)
+		return -1;
+	value = v->slot[src];
+	for (i = src - 1; i >= dest; i--)
+		v->slot[i + 1] = v->slot[i];
+	v->slot[dest] = value;
+	return 0;
+}
+
 void *
 vector_insert_slot(vector v, int slot, void *value)
 {
