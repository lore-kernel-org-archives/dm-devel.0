From: damien.lemoal@wdc.com
Subject: [PATCH 02/10] dm-table: Check device area zone alignment
Date: Fri, 21 Apr 2017 12:55:50 +0900
Message-ID: <20170421035558.2657-3-damien.lemoal@wdc.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170421035558.2657-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

If a target maps to a zoned block device, check that the device area is
aligned on zone boundaries to avoid problems with REQ_OP_ZONE_RESET
operations (resetting a partially mapped sequential zone would not be
possible). This also greatly facilitate the processing of zone report
with REQ_OP_ZONE_REPORT bios.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 06d3b7b..6947f0f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -339,6 +339,33 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 1;
 	}
 
+	/*
+	 * If the target is mapped to a zoned block device, check
+	 * that the device zones are not partially mapped.
+	 */
+	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
+		unsigned int zone_sectors = bdev_zone_sectors(bdev);
+
+		if (start & (zone_sectors - 1)) {
+			DMWARN("%s: start=%llu not aligned to h/w "
+			       "zone size %u of %s",
+			       dm_device_name(ti->table->md),
+			       (unsigned long long)start,
+			       zone_sectors, bdevname(bdev, b));
+			return 1;
+		}
+
+		if (start + len < dev_size &&
+		    len & (zone_sectors - 1)) {
+			DMWARN("%s: len=%llu not aligned to h/w "
+			       "zone size %u of %s",
+			       dm_device_name(ti->table->md),
+			       (unsigned long long)start,
+			       zone_sectors, bdevname(bdev, b));
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.9.3
