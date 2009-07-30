From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RESEND] [PATCH] Use Average path priority value for
	path switching
Date: Thu, 30 Jul 2009 13:13:55 -0700
Message-ID: <1248984835.18243.5.camel@chandra-ubuntu>
References: <1246583474.30568.2.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246583474.30568.2.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

I submitted this patch on Jul 2
(http://marc.info/?l=dm-devel&m=124658334721911&w=2). Resending it.

Only change is a field name from up_paths to enabled_paths.

Hi Hannes,

Need an ACK from you :-).

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

This patch fixes the problem by using average priority of 
the path group to decide on which path group to switch over.

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
+	int enabled_paths;
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
 
+ 	pgp->enabled_paths = 0;
 	if (!pgp->paths) {
 		pgp->priority = 0;
 		return;
 	}
 	vector_foreach_slot (pgp->paths, pp, i) {
-		if (pp->state != PATH_DOWN)
+		if (pp->state != PATH_DOWN) {
 			priority += pp->priority;
+ 			pgp->enabled_paths++;
+		}
 	}
 	pgp->priority = priority;
 }
@@ -29,8 +32,9 @@ extern int
 select_path_group (struct multipath * mpp)
 {
 	int i;
-	int highest = 0;
+	int max_priority = 0, avg_priority;
 	int bestpg = 1;
+	int max_enabled_paths = 1;
 	struct pathgroup * pgp;
 
 	if (!mpp->pg)
@@ -41,9 +45,18 @@ select_path_group (struct multipath * mp
 			continue;
 
 		path_group_prio_update(pgp);
-		if (pgp->priority > highest) {
-			highest = pgp->priority;
-			bestpg = i + 1;
+		if (pgp->enabled_paths) {
+			avg_priority = pgp->priority / pgp->enabled_paths;
+			if (avg_priority > max_priority) {
+				max_priority = avg_priority;
+				max_enabled_paths = pgp->enabled_paths;
+				bestpg = i + 1;
+			} else if (avg_priority == max_priority) {
+				if (pgp->enabled_paths > max_enabled_paths) {
+					max_enabled_paths = pgp->enabled_paths;
+					bestpg = i + 1;
+				}
+			}
 		}
 	}
 	return bestpg;
