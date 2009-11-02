From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 12/18] Replicator: add replicator to dtree
Date: Mon,  2 Nov 2009 15:20:16 +0100
Message-ID: <1257171622-8380-13-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-9-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-10-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-11-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-12-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-12-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Adding all replicator related LVs to dtree.
Start of one replicator_dev initiate start of all other related.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/activate/dev_manager.c |   49 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/lib/activate/dev_manager.c b/lib/activate/dev_manager.c
index 1f1d645..00f3cf3 100644
--- a/lib/activate/dev_manager.c
+++ b/lib/activate/dev_manager.c
@@ -951,6 +951,47 @@ static int _add_target_to_dtree(struct dev_manager *dm,
 static int _add_new_lv_to_dtree(struct dev_manager *dm, struct dm_tree *dtree,
 				  struct logical_volume *lv, const char *layer);
 
+/* Add all replicators' LVs from active segment */
+static int _add_replicator_dev_target_to_dtree(struct dev_manager *dm,
+					       struct dm_tree *dtree,
+					       struct lv_segment *seg)
+{
+	struct replicator_device *rdev;
+	struct replicator_site *rsite;
+
+	/* only active replicator */
+	if (lv_is_active_replicator_dev(seg->lv)) {
+		/* activation of one replicator node activate all other nodes */
+		if (!seg->replicator ||
+		    !_add_new_lv_to_dtree(dm, dtree, seg->replicator, NULL))
+			return_0;
+
+		dm_list_iterate_items(rsite, &seg->replicator->rsites) {
+			dm_list_iterate_items(rdev, &rsite->rdevices) {
+				if (rdev->slog && !_add_new_lv_to_dtree(dm, dtree, rdev->slog, NULL))
+					return_0;
+				if ((rsite->state == REPLICATOR_STATE_ACTIVE) &&
+				    (!rdev->lv || !_add_new_lv_to_dtree(dm, dtree, rdev->lv, NULL)))
+					return_0;
+			}
+		}
+		dm_list_iterate_items(rsite, &seg->replicator->rsites) {
+			if (rsite->state != REPLICATOR_STATE_ACTIVE)
+				continue;
+			dm_list_iterate_items(rdev, &rsite->rdevices) {
+				if (rdev->replicator_dev->lv == seg->lv)
+					continue;
+				if (!rdev->replicator_dev->lv ||
+				    !_add_new_lv_to_dtree(dm, dtree, rdev->replicator_dev->lv, NULL))
+					return_0;
+			}
+		}
+	} else if (!_add_new_lv_to_dtree(dm, dtree, seg->lv->rdevice->lv, NULL))
+		return_0;
+
+	return 1;
+}
+
 static int _add_segment_to_dtree(struct dev_manager *dm,
 				   struct dm_tree *dtree,
 				   struct dm_tree_node *dnode,
@@ -981,8 +1022,14 @@ static int _add_segment_to_dtree(struct dev_manager *dm,
 	    !_add_new_lv_to_dtree(dm, dtree, seg->log_lv, NULL))
 		return_0;
 
+	if (seg_is_replicator_dev(seg)) {
+		if (!_add_replicator_dev_target_to_dtree(dm, dtree, seg))
+			return_0;
+	} else if (seg_is_replicator(seg) && seg->rlog_lv) {
+		if (!_add_new_lv_to_dtree(dm, dtree, seg->rlog_lv, NULL))
+			return_0;
 	/* If this is a snapshot origin, add real LV */
-	if (lv_is_origin(seg->lv) && !layer) {
+	} else if (lv_is_origin(seg->lv) && !layer) {
 		if (vg_is_clustered(seg->lv->vg)) {
 			log_error("Clustered snapshots are not yet supported");
 			return 0;
-- 
1.6.5.1
