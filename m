From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Fix zone report handling
Date: Thu, 18 Apr 2019 18:03:07 +0900
Message-ID: <20190418090307.1098-1-damien.lemoal@wdc.com>
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

The function blkdev_report_zones() returns success even if no zone
information is reported (empty report). Empty zone reports can only
happen if the report start sector passed exceeds the device capacity.
The conditions for this to happen are either a bug in the caller code,
or, a change in the device that forced the low level driver to change
the device capacity to a value that is lower than the report start
sector. This situation includes a failed disk revalidation resulting in
the disk capacity being changed to 0.

If this change happens while dm-zoned is in its initialization phase
executing dmz_init_zones(), this function may enter an infinite loop
and hang the system. To avoid this, add a check to disallow empty zone
reports and bail out early. Also fix the function dmz_update_zone() to
make sure that the report for the requested zone was correctly obtained.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index fa68336560c3..d8334cd45d7c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1169,6 +1169,9 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 			goto out;
 		}
 
+		if (!nr_blkz)
+			break;
+
 		/* Process report */
 		for (i = 0; i < nr_blkz; i++) {
 			ret = dmz_init_zone(zmd, zone, &blkz[i]);
@@ -1204,6 +1207,8 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	/* Get zone information from disk */
 	ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone),
 				  &blkz, &nr_blkz, GFP_NOIO);
+	if (!nr_blkz)
+		ret = -EIO;
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Get zone %u report failed",
 			    dmz_id(zmd, zone));
-- 
2.20.1
