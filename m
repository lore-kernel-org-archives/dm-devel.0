From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 09/18] Replicator: vg validation
Date: Mon,  2 Nov 2009 15:20:13 +0100
Message-ID: <1257171622-8380-10-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-9-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-9-git-send-email-zkabelac@redhat.com>
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

Validate replicator segments

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/metadata/metadata.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/lib/metadata/metadata.c b/lib/metadata/metadata.c
index 67ba551..ebb2f16 100644
--- a/lib/metadata/metadata.c
+++ b/lib/metadata/metadata.c
@@ -2088,6 +2088,67 @@ void lv_calculate_readahead(const struct logical_volume *lv, uint32_t *read_ahea
 	}
 }
 
+/*
+ * Check for duplicate
+ *  site name
+ *  site index
+ *  device name
+ *  device index
+ */
+static int _replicator_validate(const struct logical_volume *lv)
+{
+	struct replicator_site *rsite, *rsiteb;
+	struct replicator_device *rdev, *rdevb;
+        int r = 1;
+
+	dm_list_iterate_items(rsite, &lv->rsites) {
+		dm_list_iterate_items(rsiteb, &lv->rsites) {
+			if (rsite == rsiteb)
+				break;
+			if (strcasecmp(rsite->name, rsiteb->name) == 0) {
+				log_error("Internal error: Duplicate site name "
+					  "%s detected for replicator %s",
+					  rsite->name, lv->name);
+                                r = 0;
+			}
+			if (rsite->site_index == rsiteb->site_index) {
+				log_error("Internal error: Duplicate site index "
+					  "%d detected for replicator %s/%s",
+					  rsite->site_index, lv->name, rsite->name);
+				r = 0;
+			}
+		}
+
+		dm_list_iterate_items(rdev, &rsite->rdevices) {
+			dm_list_iterate_items(rdevb, &rsite->rdevices) {
+				if (rdev == rdevb)
+					break;
+				log_error("devs: lv:%s  %s", rdev->name, rdevb->name);
+				if (rdev->slog && (rdev->slog == rdevb->slog)) {
+					log_error("Internal error: Duplicate sync log "
+						  "%s detected for replicator %s",
+						  rdev->slog->name, lv->name);
+					r = 0;
+				}
+				if (strcasecmp(rdev->name, rdevb->name) == 0) {
+					log_error("Internal error: Duplicate device name "
+						  "%s detected for replicator %s",
+						  rdev->name, lv->name);
+					r = 0;
+				}
+				if (rdev->device_index == rdevb->device_index) {
+					log_error("Internal error: Duplicate device index %"
+						  PRId64 " detected for replicator %s/%s",
+						  rdev->device_index, lv->name, rsite->name);
+					r = 0;
+				}
+			}
+		}
+	}
+
+	return r;
+}
+
 int vg_validate(struct volume_group *vg)
 {
 	struct pv_list *pvl, *pvl2;
@@ -2188,6 +2249,9 @@ int vg_validate(struct volume_group *vg)
 				r = 0;
 			}
 		}
+
+		if (lv_is_replicator(lvl->lv) && !_replicator_validate(lvl->lv))
+			r = 0;
 	}
 
 	dm_list_iterate_items(lvl, &vg->lvs) {
-- 
1.6.5.1
