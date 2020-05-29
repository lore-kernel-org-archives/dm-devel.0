From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/14] dm-zoned: prefer full zones for reclaim
Date: Fri, 29 May 2020 19:39:07 +0200
Message-ID: <20200529173907.40529-15-hare@suse.de>
References: <20200529173907.40529-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200529173907.40529-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Prefer full zones when selecting the next zone for reclaim.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 6c8d4ddd8b27..e01ca1c57ff2 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1939,7 +1939,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
 						    unsigned int idx, bool idle)
 {
 	struct dm_zone *dzone = NULL;
-	struct dm_zone *zone;
+	struct dm_zone *zone, *last = NULL;
 	struct list_head *zone_list;
 
 	/* If we have cache zones select from the cache zone list */
@@ -1956,6 +1956,13 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
 			dzone = zone->bzone;
 			if (dzone->dev->dev_idx != idx)
 				continue;
+			if (!last) {
+				last = dzone;
+				continue;
+			}
+			if (last->weight < dzone->weight)
+				continue;
+			dzone = last;
 		} else
 			dzone = zone;
 		if (dmz_lock_zone_reclaim(dzone))
-- 
2.16.4
