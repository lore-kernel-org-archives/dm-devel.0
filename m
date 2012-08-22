From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm table: clear add_random unless all devices
	have it set
Date: Wed, 22 Aug 2012 19:06:16 +0200
Message-ID: <1345655176-22950-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

The QUEUE_FLAG_ADD_RANDOM specifies if queue IO timings contribute
to random pool.

For bio based target is this flag always 0 because target
has no real queue.

For request-based device was this flag always set to 1 (default).

Set it according to flags on underlying devices (if there is at least
one device which should not contribute, set flag to zero).
If device is not suitable (fast SSD storage) for collecting entropy,
request base queue stacked over it will not be either.

Because checking logic is exactly same as for rotational flag,
create one common function which take iteration function
as parameter.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-table.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f900690..66f7880 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1354,17 +1354,25 @@ static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 	return q && blk_queue_nonrot(q);
 }
 
-static bool dm_table_is_nonrot(struct dm_table *t)
+static int device_no_random(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !blk_queue_add_random(q);
+}
+
+static bool dm_table_all_devices_attribute(struct dm_table *t,
+					   iterate_devices_callout_fn func)
 {
 	struct dm_target *ti;
 	unsigned i = 0;
 
-	/* Ensure that all underlying device are non-rotational. */
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_nonrot, NULL))
+		    !ti->type->iterate_devices(ti, func, NULL))
 			return 0;
 	}
 
@@ -1396,7 +1404,8 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_discard_zeroes_data(t))
 		q->limits.discard_zeroes_data = 0;
 
-	if (dm_table_is_nonrot(t))
+	/* Ensure that all underlying device are non-rotational. */
+	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
@@ -1404,6 +1413,13 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	dm_table_set_integrity(t);
 
 	/*
+	 * Ensure that all devices contributes to entropy pool.
+	 * It can be set only for request-based target.
+	 */
+	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_no_random))
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
+
+	/*
 	 * QUEUE_FLAG_STACKABLE must be set after all queue settings are
 	 * visible to other CPUs because, once the flag is set, incoming bios
 	 * are processed by request-based dm, which refers to the queue
-- 
1.7.10.4
