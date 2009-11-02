From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 11/18] Replicator: update _create_partial_dtree()
Date: Mon,  2 Nov 2009 15:20:15 +0100
Message-ID: <1257171622-8380-12-git-send-email-zkabelac@redhat.com>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-11-git-send-email-zkabelac@redhat.com>
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

Creating partial tree for Replicator target.
Using dm_tree_set_priority() to set higher priority for Replicator.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/activate/dev_manager.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/lib/activate/dev_manager.c b/lib/activate/dev_manager.c
index a4ae9e0..1f1d645 100644
--- a/lib/activate/dev_manager.c
+++ b/lib/activate/dev_manager.c
@@ -731,6 +731,9 @@ static struct dm_tree *_create_partial_dtree(struct dev_manager *dm, struct logi
 	struct dm_list *snh, *snht;
 	struct lv_segment *seg;
 	uint32_t s;
+	struct replicator_device *rdev;
+	struct replicator_site *rsite;
+	const char *replicator_dlid;
 
 	if (!(dtree = dm_tree_create())) {
 		log_error("Partial dtree creation failed for %s.", lv->name);
@@ -746,12 +749,34 @@ static struct dm_tree *_create_partial_dtree(struct dev_manager *dm, struct logi
 			goto_bad;
 
 	/* Add any LVs used by segments in this LV */
-	dm_list_iterate_items(seg, &lv->segments)
+	dm_list_iterate_items(seg, &lv->segments) {
 		for (s = 0; s < seg->area_count; s++)
 			if (seg_type(seg, s) == AREA_LV && seg_lv(seg, s)) {
 				if (!_add_lv_to_dtree(dm, dtree, seg_lv(seg, s)))
 					goto_bad;
 			}
+		if (seg->replicator) {
+                        /* Add all replicator-dev from same replicator */
+			dm_list_iterate_items(rsite, &seg->replicator->rsites) {
+				dm_list_iterate_items(rdev, &rsite->rdevices) {
+					if (rsite->state == REPLICATOR_STATE_ACTIVE) {
+						if (!rdev->replicator_dev->lv)
+							goto_bad;
+						if (lv == rdev->replicator_dev->lv)
+                                                        continue;
+						/* Add replicator-dev LV */
+						if (!_add_lv_to_dtree(dm, dtree, rdev->replicator_dev->lv))
+							goto_bad;
+					}
+				}
+			}
+
+			if (!(replicator_dlid = build_dlid(dm, seg->replicator->lvid.s, NULL)))
+				goto_bad;
+			if (!dm_tree_set_replicator_suspend(dtree, replicator_dlid))
+				goto_bad;
+		}
+	}
 
 	return dtree;
 
-- 
1.6.5.1
