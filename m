From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 03/12] dm: remove the
	DM_TARGET_SUPPORTS_DISCARDS feature flag
Date: Sat, 24 Jul 2010 12:09:19 -0400
Message-ID: <1279987768-13275-4-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Eliminate the DM_TARGET_SUPPORTS_DISCARDS feature flag now that
dm_target's 'num_discard_requests' provides the mechanism to enable
discards on a per target basis.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c        |    1 -
 drivers/md/dm-table.c         |    2 +-
 drivers/md/dm.c               |    2 +-
 include/linux/device-mapper.h |    1 -
 4 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-block/drivers/md/dm-linear.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-linear.c
+++ linux-2.6-block/drivers/md/dm-linear.c
@@ -153,7 +153,6 @@ static struct target_type linear_target 
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
-	.features = DM_TARGET_SUPPORTS_DISCARDS,
 };
 
 int __init dm_linear_init(void)
Index: linux-2.6-block/drivers/md/dm-table.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-table.c
+++ linux-2.6-block/drivers/md/dm-table.c
@@ -773,7 +773,7 @@ int dm_table_add_target(struct dm_table 
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
-	if (!(tgt->type->features & DM_TARGET_SUPPORTS_DISCARDS))
+	if (!tgt->num_discard_requests)
 		t->discards_supported = 0;
 
 	return 0;
Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -1242,7 +1242,7 @@ static int __clone_and_map_discard(struc
 	 * check was performed.
 	 */
 
-	if (!(ti->type->features & DM_TARGET_SUPPORTS_DISCARDS))
+	if (!ti->num_discard_requests)
 		return -EOPNOTSUPP;
 
 	max = max_io_len(ci->md, ci->sector, ti);
Index: linux-2.6-block/include/linux/device-mapper.h
===================================================================
--- linux-2.6-block.orig/include/linux/device-mapper.h
+++ linux-2.6-block/include/linux/device-mapper.h
@@ -130,7 +130,6 @@ void dm_put_device(struct dm_target *ti,
 /*
  * Target features
  */
-#define DM_TARGET_SUPPORTS_DISCARDS 0x00000001
 
 struct target_type {
 	uint64_t features;
