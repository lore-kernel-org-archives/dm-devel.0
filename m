From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] dm zoned: Fix random zone reclaim selection
Date: Fri, 19 Jun 2020 16:49:55 +0900
Message-ID: <20200619074956.352647-2-damien.lemoal@wdc.com>
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

Commit 2094045fe5b5 ("dm zoned: prefer full zones for reclaim")
modified dmz_get_rnd_zone_for_reclaim() to add a search for the buffer
zone with the heaviest weight as an optimal candidate for reclaim. This
modification uses the zone pointer variabl "last" which is set only once
and never modified as zones are scanned, resulting in the search being
inefective. Furthermore, if the selected buffer zone at the end of the
search loop is active or already locked for reclaim,
dmz_get_rnd_zone_for_reclaim() returns NULL even if other random zones
with a lesser weight can be reclaimed.

To fix the search and to guarantee that reclaim can make forward
progress, fix dmz_get_rnd_zone_for_reclaim() loop to correctly find
the buffer zone with the heaviest weight using the variable maxw_z.
Also make sure to fallback to finding the first random zone that can
be reclaimed if this best candidate zone cannot be reclaimed.

While at it, also fix the device index check to consider only random
zones, ignoring cache zones belonging to the cache device if one is
used as that device does not have a reclaim process.

Fixes: 2094045fe5b5 ("dm zoned: prefer full zones for reclaim")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 35 ++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 130b5a6d9f12..8bdf71dce7fb 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1949,7 +1949,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
 						    unsigned int idx, bool idle)
 {
 	struct dm_zone *dzone = NULL;
-	struct dm_zone *zone, *last = NULL;
+	struct dm_zone *zone, *maxw_z = NULL;
 	struct list_head *zone_list;
 
 	/* If we have cache zones select from the cache zone list */
@@ -1961,18 +1961,37 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
 	} else
 		zone_list = &zmd->dev[idx].map_rnd_list;
 
+	/*
+	 * Find the buffer zone with the heaviest weight or the first (oldest)
+	 * data zone that can be reclaimed.
+	 */
 	list_for_each_entry(zone, zone_list, link) {
 		if (dmz_is_buf(zone)) {
 			dzone = zone->bzone;
-			if (dzone->dev->dev_idx != idx)
+			if (dmz_is_rnd(dzone) && dzone->dev->dev_idx != idx)
 				continue;
-			if (!last) {
-				last = dzone;
-				continue;
-			}
-			if (last->weight < dzone->weight)
+			if (!maxw_z || maxw_z->weight < dzone->weight)
+				maxw_z = dzone;
+		} else {
+			dzone = zone;
+			if (dmz_lock_zone_reclaim(dzone))
+				return dzone;
+		}
+	}
+
+	if (maxw_z && dmz_lock_zone_reclaim(maxw_z))
+		return maxw_z;
+
+	/*
+	 * If we come here, none of the zones inspected could be locked for
+	 * reclaim. Try again, being more aggressive, that is, find the
+	 * first zone that can be reclaimed regardless of its weitght.
+	 */
+	list_for_each_entry(zone, zone_list, link) {
+		if (dmz_is_buf(zone)) {
+			dzone = zone->bzone;
+			if (dmz_is_rnd(dzone) && dzone->dev->dev_idx != idx)
 				continue;
-			dzone = last;
 		} else
 			dzone = zone;
 		if (dmz_lock_zone_reclaim(dzone))
-- 
2.26.2
