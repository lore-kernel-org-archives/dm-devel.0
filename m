From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 02/10] dm-table: Check device area zone
	alignment
Date: Mon, 8 May 2017 16:40:44 -0700
Message-ID: <20170508234052.32375-3-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

If a target maps to a zoned block device, check that the device area is
aligned on zone boundaries to avoid problems with REQ_OP_ZONE_RESET
operations (resetting a partially mapped sequential zone would not be
possible). This also greatly facilitate the processing of zone report
with REQ_OP_ZONE_REPORT bios.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-table.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6a7e200..3949897 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -340,6 +340,33 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
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
