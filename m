From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm zoned: Fix uninitialized pointer dereference
Date: Mon,  8 Jun 2020 13:20:59 +0900
Message-ID: <20200608042059.1256086-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Make sure that the local variable rzone in dmz_do_reclaim() is always
initialized before being used for printing debug messages.

Fixes: f97809aec589 ("dm zoned: per-device reclaim")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-reclaim.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 2261b4dd60b7..dd1eebf6e50f 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -377,6 +377,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 			dmz_metadata_label(zmd), zrc->dev_idx);
 		return -EBUSY;
 	}
+	rzone = dzone;
 
 	start = jiffies;
 	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
@@ -391,8 +392,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 			 */
 			ret = dmz_reclaim_rnd_data(zrc, dzone);
 		}
-		rzone = dzone;
-
 	} else {
 		struct dm_zone *bzone = dzone->bzone;
 		sector_t chunk_block = 0;
@@ -415,7 +414,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 			 * be later reclaimed.
 			 */
 			ret = dmz_reclaim_seq_data(zrc, dzone);
-			rzone = dzone;
 		}
 	}
 out:
-- 
2.26.2
