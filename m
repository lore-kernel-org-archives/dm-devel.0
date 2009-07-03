From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Use Average path priority value for path
	switching
Date: Thu, 02 Jul 2009 18:11:14 -0700
Message-ID: <1246583474.30568.2.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

Few weeks back I posted some issues w.r.t the way path priorities are
used during path switching.

Here is Hannes's latest response
(http://marc.info/?l=dm-devel&m=124573807907764&w=2) and this patch is
based on his suggestion.

regards,

chandra
----------------------------------------------------------------------- 
Failback happens only when the sum of priorities of all paths
(on the higher priority path group) is greater than the sum
of priorities of all paths on the lower priority path group.

This leads into problems when there are more than one paths
in each of the path groups, and the sum of all paths in the
lower priority path group is greater than that of path priority
of a single high priority path.

This patch fixes the problem by using average priority of a
path group in deciding path group switch over.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 libmultipath/structs.h     |    1 +
 libmultipath/switchgroup.c |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

Index: multipath-tools-mainline/libmultipath/structs.h
===================================================================
--- multipath-tools-mainline.orig/libmultipath/structs.h
+++ multipath-tools-mainline/libmultipath/structs.h
@@ -202,6 +202,7 @@ struct pathgroup {
 	long id;
 	int status;
 	int priority;
+	int up_paths;
 	vector paths;
 	char * selector;
 };
Index: multipath-tools-mainline/libmultipath/switchgroup.c
===================================================================
--- multipath-tools-mainline.orig/libmultipath/switchgroup.c
+++ multipath-tools-mainline/libmultipath/switchgroup.c
@@ -14,13 +14,16 @@ path_group_prio_update (struct pathgroup
 	int priority = 0;
 	struct path * pp;
 
+	pgp->up_paths = 0;
 	if (!pgp->paths) {
 		pgp->priority = 0;
 		return;
 	}
 	vector_foreach_slot (pgp->paths, pp, i) {
-		if (pp->state != PATH_DOWN)
+		if (pp->state != PATH_DOWN) {
 			priority += pp->priority;
+			pgp->up_paths++;
+		}
 	}
 	pgp->priority = priority;
 }
@@ -29,8 +32,9 @@ extern int
 select_path_group (struct multipath * mpp)
 {
 	int i;
-	int highest = 0;
+	int highest_avg = 0;
 	int bestpg = 1;
+	int avg_priority, highest_up_paths = 1;
 	struct pathgroup * pgp;
 
 	if (!mpp->pg)
@@ -41,9 +45,18 @@ select_path_group (struct multipath * mp
 			continue;
 
 		path_group_prio_update(pgp);
-		if (pgp->priority > highest) {
-			highest = pgp->priority;
-			bestpg = i + 1;
+		if (pgp->up_paths) {
+			avg_priority = pgp->priority / pgp->up_paths;
+			if (avg_priority > highest_avg) {
+				highest_avg = avg_priority;
+				highest_up_paths = pgp->up_paths;
+				bestpg = i + 1;
+			} else if (avg_priority == highest_avg) {
+				if (pgp->up_paths > highest_up_paths) {
+					highest_up_paths = pgp->up_paths;
+					bestpg = i + 1;
+				}
+			}
 		}
 	}
 	return bestpg;
