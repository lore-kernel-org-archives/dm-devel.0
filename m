From: mwilck@suse.com
Subject: [PATCH 57/74] libmultipath: update_mpp_paths(): handle
	INIT_REMOVED
Date: Thu,  9 Jul 2020 12:51:28 +0200
Message-ID: <20200709105145.9211-5-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

Since the ancient commit b96dead ("[multipathd] remove the retry login in
uev_remove_path()"), update_mpp_paths() was used to check whether devices
found in disassembled maps were still in the pathvec, and to skip them
while re-assembling the new params string on reload. The reason was to
deal with failed reloads. With the introduction of INIT_REMOVED, we
need to skip paths in that state, too. Moreover, past reloads may have
succeeded in removing REMOVED paths from the map, so check if any
INIT_REMOVED paths can now be deleted for good. This is the right
place to do this check, because update_mpp_paths() is called after
obtaining the current kernel state, and before reloading.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 27d6547..8999552 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -29,6 +29,7 @@ int update_mpp_paths(struct multipath *mpp, vector pathvec)
 	struct pathgroup * pgp;
 	struct path * pp;
 	int i,j;
+	bool store_failure = false;
 
 	if (!mpp || !mpp->pg)
 		return 0;
@@ -39,13 +40,23 @@ int update_mpp_paths(struct multipath *mpp, vector pathvec)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
-			    (find_path_by_devt(pathvec, pp->dev_t)) &&
-			    store_path(mpp->paths, pp))
-				return 1;
+			if (!find_path_by_devt(mpp->paths, pp->dev_t)) {
+				struct path *pp1;
+
+				/*
+				 * Avoid adding removed paths to the map again
+				 * when we reload it. Such paths may exist if
+				 * domap fails in ev_remove_path().
+				 */
+				pp1 = find_path_by_devt(pathvec, pp->dev_t);
+				if (pp1 && pp->initialized != INIT_REMOVED &&
+				    store_path(mpp->paths, pp))
+					store_failure = true;
+			}
 		}
 	}
-	return 0;
+
+	return store_failure;
 }
 
 int adopt_paths(vector pathvec, struct multipath *mpp)
-- 
2.26.2
