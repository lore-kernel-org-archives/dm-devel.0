From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] dm zoned: Fix reclaim zone selection
Date: Fri, 19 Jun 2020 16:49:56 +0900
Message-ID: <20200619074956.352647-3-damien.lemoal@wdc.com>
References: <20200619074956.352647-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619074956.352647-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-Id: dm-devel.ids

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When dm zoned has multiple devices, random zones are never selected for
reclaim if all reserved sequential write zones are in use and no
sequential write required zones can be selected for reclaim. This can
lead to deadlocks as selecting a cache zone allows reclaiming a
sequential zone, ensuring forward progress.

Fix this by always defaulting to selecting a random zone when no
sequential write required zone can be selected.

[Damien: fix commit message]

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 8bdf71dce7fb..c332e2c121b8 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2025,7 +2025,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd,
 struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd,
 					 unsigned int dev_idx, bool idle)
 {
-	struct dm_zone *zone;
+	struct dm_zone *zone = NULL;
 
 	/*
 	 * Search for a zone candidate to reclaim: 2 cases are possible.
@@ -2038,7 +2038,7 @@ struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd,
 	dmz_lock_map(zmd);
 	if (list_empty(&zmd->reserved_seq_zones_list))
 		zone = dmz_get_seq_zone_for_reclaim(zmd, dev_idx);
-	else
+	if (!zone)
 		zone = dmz_get_rnd_zone_for_reclaim(zmd, dev_idx, idle);
 	dmz_unlock_map(zmd);
 
-- 
2.26.2
