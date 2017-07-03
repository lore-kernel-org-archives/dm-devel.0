From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Fix overflow when converting zone ID
	to sectors
Date: Mon,  3 Jul 2017 15:44:58 +0900
Message-ID: <20170703064458.8091-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

A zone ID is a 32 bits unsigned int which can overflow when doing the
bit shifts calculations in dmz_start_sect(). With a 256 MB zone size
drive, the overflow happens for a zone ID >= 8192.
Fix this by casting the zone ID to a sector_t before doing the bit
shift. While at it, similarly fix dmz_start_block().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 4618441c..884ff7c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -191,12 +191,12 @@ unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return dmz_id(zmd, zone) << zmd->dev->zone_nr_sectors_shift;
+	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_sectors_shift;
 }
 
 sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return dmz_id(zmd, zone) << zmd->dev->zone_nr_blocks_shift;
+	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_blocks_shift;
 }
 
 unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
-- 
2.9.4
