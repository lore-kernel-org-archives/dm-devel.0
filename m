From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/9] md/dm-table: Combine substrings for ten messages
Date: Sat, 1 Oct 2016 09:48:50 +0200
Message-ID: <cd308ed5-baf4-5f13-9d8c-1b1cf5b3fa74@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 08:39:58 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0f60417..9b7d8b7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -296,8 +296,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	 */
 	q = bdev_get_queue(bdev);
 	if (!q || !q->make_request_fn) {
-		DMWARN("%s: %s is not yet initialised: "
-		       "start=%llu, len=%llu, dev_size=%llu",
+		DMWARN("%s: %s is not yet initialised: start=%llu, len=%llu, dev_size=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       (unsigned long long)start,
 		       (unsigned long long)len,
@@ -309,8 +308,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %s too small for target: "
-		       "start=%llu, len=%llu, dev_size=%llu",
+		DMWARN("%s: %s too small for target: start=%llu, len=%llu, dev_size=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       (unsigned long long)start,
 		       (unsigned long long)len,
@@ -322,8 +320,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if (start & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		DMWARN("%s: start=%llu not aligned to h/w logical block size %u of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
 		       limits->logical_block_size, bdevname(bdev, b));
@@ -331,8 +328,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		DMWARN("%s: len=%llu not aligned to h/w logical block size %u of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
 		       limits->logical_block_size, bdevname(bdev, b));
@@ -446,9 +442,7 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	if (bdev_stack_limits(limits, bdev, start) < 0)
-		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
-		       "physical_block_size=%u, logical_block_size=%u, "
-		       "alignment_offset=%u, start=%llu",
+		DMWARN("%s: adding target device %s caused an alignment inconsistency: physical_block_size=%u, logical_block_size=%u, alignment_offset=%u, start=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
@@ -659,8 +653,7 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
 	}
 
 	if (remaining) {
-		DMWARN("%s: table line %u (start sect %llu len %llu) "
-		       "not aligned to h/w logical block size %u",
+		DMWARN("%s: table line %u (start sect %llu len %llu) not aligned to h/w logical block size %u",
 		       dm_device_name(table->md), i,
 		       (unsigned long long) ti->begin,
 		       (unsigned long long) ti->len,
@@ -902,8 +895,7 @@ static int dm_table_determine_type(struct dm_table *t)
 			bio_based = 1;
 
 		if (bio_based && request_based) {
-			DMWARN("Inconsistent table: different target types"
-			       " can't be mixed up");
+			DMWARN("Inconsistent table: different target types can't be mixed up");
 			return -EINVAL;
 		}
 	}
@@ -960,8 +952,7 @@ static int dm_table_determine_type(struct dm_table *t)
 		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
 
 		if (!blk_queue_stackable(q)) {
-			DMERR("table load rejected: including"
-			      " non-request-stackable devices");
+			DMERR("table load rejected: including non-request-stackable devices");
 			return -EINVAL;
 		}
 
@@ -973,8 +964,7 @@ static int dm_table_determine_type(struct dm_table *t)
 		/* verify _all_ devices in the table are blk-mq devices */
 		list_for_each_entry(dd, devices, list)
 			if (!bdev_get_queue(dd->dm_dev->bdev)->mq_ops) {
-				DMERR("table load rejected: not all devices"
-				      " are blk-mq request-stackable");
+				DMERR("table load rejected: not all devices are blk-mq request-stackable");
 				return -EINVAL;
 			}
 
@@ -1374,9 +1364,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		 * for the table.
 		 */
 		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-			DMWARN("%s: adding target device "
-			       "(start sect %llu len %llu) "
-			       "caused an alignment inconsistency",
+			DMWARN("%s: adding target device (start sect %llu len %llu) caused an alignment inconsistency",
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
-- 
2.10.0

