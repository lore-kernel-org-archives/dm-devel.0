From: mwilck@suse.com
Subject: [PATCH v2 66/74] libmultipath: update_pathvec_from_dm:
	handle pp->mpp mismatch
Date: Wed, 12 Aug 2020 13:35:10 +0200
Message-ID: <20200812113511.26469-8-mwilck@suse.com>
References: <20200812113511.26469-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113511.26469-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Treat this like a WWID mismatch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index bd2d13b..e7a8d53 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -123,6 +123,23 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 			goto delete_pg;
 
 		vector_foreach_slot(pgp->paths, pp, j) {
+
+			if (pp->mpp && pp->mpp != mpp) {
+				condlog(0, "BUG: %s: found path %s which is already in %s",
+					mpp->alias, pp->dev, pp->mpp->alias);
+
+				/*
+				 * Either we added this path to the other mpp
+				 * explicitly, or we came by here earlier and
+				 * decided it belonged there. In both cases,
+				 * the path should remain in the other map,
+				 * and be deleted here.
+				 */
+				must_reload = true;
+				dm_fail_path(mpp->alias, pp->dev_t);
+				vector_del_slot(pgp->paths, j--);
+				continue;
+			}
 			pp->mpp = mpp;
 
 			/*
@@ -170,6 +187,22 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 					vector_del_slot(pgp->paths, j--);
 					free_path(pp);
 					must_reload = true;
+				} else if (mpp_has_wwid && pp->wwid[0] != '\0'
+					   && strcmp(mpp->wwid, pp->wwid)) {
+					condlog(0, "%s: path %s WWID %s doesn't match, removing from map",
+						mpp->wwid, pp->dev_t, pp->wwid);
+					/*
+					 * This path exists, but in the wrong map.
+					 * We can't reload the map from here.
+					 * Make sure it isn't used in this map
+					 * any more, and let the checker re-add
+					 * it as it sees fit.
+					 */
+					dm_fail_path(mpp->alias, pp->dev_t);
+					vector_del_slot(pgp->paths, j--);
+					orphan_path(pp, "WWID mismatch");
+					pp->tick = 1;
+					must_reload = true;
 				} else {
 					if (mpp_has_wwid && !strlen(pp->wwid)) {
 						condlog(3, "%s: setting wwid from map: %s",
-- 
2.28.0
