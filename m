From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 07/12] Make multipathd orphan paths that were
	removed externally
Date: Mon, 30 Jun 2014 00:13:58 -0500
Message-ID: <1404105243-5071-8-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Multipathd was only orphaning paths that it removed, not ones that were
removed by the multipath command.  This could cause problems if a path
was failed but not removed, and "multipath -r" was run.  multipath would
remove the path, and when multipathd updated itself, it would remove
that path from the multipath device's path list, but not orphan it.
When the path became active again, multipathd crashed trying to adjust
the pathgroups of the multipath device it had previously belonged to.

This patch makes sure that whenever multipathd updates the multipath device
table, it first makes sure the mpp->paths is uptodate.  Once it has
finished updating the device table, it orphans any paths in mpp->paths
that are no longer part of the multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 31 +++++++++++++++++++++++++++----
 multipathd/main.c          |  4 ++++
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8cdbe3d..23f5bbb 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -281,12 +281,38 @@ update_multipath_status (struct multipath *mpp)
 	return 0;
 }
 
+void sync_paths(struct multipath *mpp, vector pathvec)
+{
+	struct path *pp;
+	struct pathgroup  *pgp;
+	int found, i, j;
+
+	vector_foreach_slot (mpp->paths, pp, i) {
+		found = 0;
+		vector_foreach_slot(mpp->pg, pgp, j) {
+			if (find_slot(pgp->paths, (void *)pp) != -1) {
+				found = 1;
+				break;
+			}
+		}
+		if (!found) {
+			condlog(3, "%s dropped path %s", mpp->alias, pp->dev);
+			vector_del_slot(mpp->paths, i--);
+			orphan_path(pp, "path removed externally");
+		}
+	}
+	update_mpp_paths(mpp, pathvec);
+	vector_foreach_slot (mpp->paths, pp, i)
+		pp->mpp = mpp;
+}
+
 extern int
 update_multipath_strings (struct multipath *mpp, vector pathvec)
 {
 	if (!mpp)
 		return 1;
 
+	update_mpp_paths(mpp, pathvec);
 	condlog(4, "%s: %s", mpp->alias, __FUNCTION__);
 
 	free_multipath_attributes(mpp);
@@ -295,6 +321,7 @@ update_multipath_strings (struct multipath *mpp, vector pathvec)
 
 	if (update_multipath_table(mpp, pathvec))
 		return 1;
+	sync_paths(mpp, pathvec);
 
 	if (update_multipath_status(mpp))
 		return 1;
@@ -508,13 +535,9 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 		return 2;
 	}
 
-	free_pgvec(mpp->pg, KEEP_PATHS);
-	mpp->pg = NULL;
-
 	if (__setup_multipath(vecs, mpp, reset))
 		return 1; /* mpp freed in setup_multipath */
 
-	adopt_paths(vecs->pathvec, mpp, 0);
 	/*
 	 * compare checkers states with DM states
 	 */
diff --git a/multipathd/main.c b/multipathd/main.c
index 56d00d3..337bfe9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1170,6 +1170,10 @@ check_path (struct vectors * vecs, struct path * pp)
 			pp->dev);
 		pp->dmstate = PSTATE_UNDEF;
 	}
+	/* if update_multipath_strings orphaned the path, quit early */
+	if (!pp->mpp)
+		return 0;
+
 	pp->chkrstate = newstate;
 	if (newstate != pp->state) {
 		int oldstate = pp->state;
-- 
1.8.3.1
