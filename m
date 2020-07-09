From: mwilck@suse.com
Subject: [PATCH 62/74] multipathd: ev_remove_path(): use
	INIT_REMOVED
Date: Thu,  9 Jul 2020 12:51:33 +0200
Message-ID: <20200709105145.9211-10-mwilck@suse.com>
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

Set paths belonging to a map to INIT_REMOVED state before attempting
to reload or flush the map. If the map association is successfully removed,
the path will be actually deleted, either via flush_map() -> orphan_paths(),
or in the update_multipath_strings()->sync_paths() code path.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 402e179..545eb6d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1102,6 +1102,18 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			goto fail;
 		}
 
+		/*
+		 * Mark the path as removed. In case of success, we
+		 * will delete it for good. Otherwise, it will be deleted
+		 * later, unless all attempts to reload this map fail.
+		 * Note: we have to explicitly remove pp from mpp->paths,
+		 * update_mpp_paths() doesn't do that.
+		 */
+		set_path_removed(pp);
+		i = find_slot(mpp->paths, pp);
+		if (i != -1)
+			vector_del_slot(mpp->paths, i);
+
 		/*
 		 * Make sure mpp->hwe doesn't point to freed memory
 		 * We call extract_hwe_from_path() below to restore mpp->hwe
@@ -1109,9 +1121,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		if (mpp->hwe == pp->hwe)
 			mpp->hwe = NULL;
 
-		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
-			vector_del_slot(mpp->paths, i);
-
 		/*
 		 * remove the map IF removing the last path
 		 */
@@ -1135,6 +1144,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 					" removing all paths",
 					alias);
 				retval = 0;
+				/* flush_map() has freed the path */
 				goto out;
 			}
 			/*
@@ -1171,21 +1181,27 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			/*
 			 * update our state from kernel
 			 */
+			char devt[BLK_DEV_SIZE];
+
+			strlcpy(devt, pp->dev_t, sizeof(devt));
 			if (setup_multipath(vecs, mpp))
 				return 1;
+			/*
+			 * Successful map reload without this path:
+			 * sync_map_state() will free it.
+			 */
 			sync_map_state(mpp);
 
-			condlog(2, "%s [%s]: path removed from map %s",
-				pp->dev, pp->dev_t, mpp->alias);
+			condlog(2, "%s: path removed from map %s",
+				devt, mpp->alias);
 		}
+	} else {
+		/* mpp == NULL */
+		if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
+			vector_del_slot(vecs->pathvec, i);
+		free_path(pp);
 	}
-
 out:
-	if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
-		vector_del_slot(vecs->pathvec, i);
-
-	free_path(pp);
-
 	return retval;
 
 fail:
-- 
2.26.2
