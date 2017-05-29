From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/4] dm: Fix mapping zone alignment check
Date: Mon, 29 May 2017 19:23:04 +0900
Message-ID: <20170529102307.19814-2-damien.lemoal@wdc.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170529102307.19814-1-damien.lemoal@wdc.com>
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

In device_area_is_invalid(), check a device mapping zone alignment
before checking the LBA size so that the check is also performed for
devices with a single sector (512B) LBA size.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b7b95d5..6545150 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -319,27 +319,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 1;
 	}
 
-	if (logical_block_size_sectors <= 1)
-		return 0;
-
-	if (start & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %u of %s",
-		       dm_device_name(ti->table->md),
-		       (unsigned long long)start,
-		       limits->logical_block_size, bdevname(bdev, b));
-		return 1;
-	}
-
-	if (len & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %u of %s",
-		       dm_device_name(ti->table->md),
-		       (unsigned long long)len,
-		       limits->logical_block_size, bdevname(bdev, b));
-		return 1;
-	}
-
 	/*
 	 * If the target is mapped to zoned block device(s), check
 	 * that the zones are not partially mapped.
@@ -355,6 +334,15 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 			return 1;
 		}
 
+		/*
+		 * Note: The last zone of a zoned block device may be smaller
+		 * than other zones. So for a target mapping the end of a
+		 * zoned block device with such a zone, len would not be zone
+		 * aligned. We do not allow such last smaller zone to be part
+		 * of the mapping here to ensure that mappings with multiple
+		 * devices do not end up with a smaller zone in the middle of
+		 * the sector range.
+		 */
 		if (len & (zone_sectors - 1)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %s",
 			       dm_device_name(ti->table->md),
@@ -364,6 +352,27 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		}
 	}
 
+	if (logical_block_size_sectors <= 1)
+		return 0;
+
+	if (start & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: start=%llu not aligned to h/w "
+		       "logical block size %u of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start,
+		       limits->logical_block_size, bdevname(bdev, b));
+		return 1;
+	}
+
+	if (len & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: len=%llu not aligned to h/w "
+		       "logical block size %u of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
+		       limits->logical_block_size, bdevname(bdev, b));
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.9.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
