From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/7] dm: Simplify dm_table_determine_type()
Date: Tue, 15 Nov 2016 15:33:16 -0800
Message-ID: <4b4da27f-1540-db69-dce7-431b61b164ef@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Use a single loop instead of two loops to determine whether or not
all_blk_mq has to be set.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-table.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 49893fdc..fff4979 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -871,7 +871,7 @@ static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
-	bool verify_blk_mq = false;
+	unsigned sq_count = 0, mq_count = 0;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
@@ -959,20 +959,15 @@ static int dm_table_determine_type(struct dm_table *t)
 		}
 
 		if (q->mq_ops)
-			verify_blk_mq = true;
+			mq_count++;
+		else
+			sq_count++;
 	}
-
-	if (verify_blk_mq) {
-		/* verify _all_ devices in the table are blk-mq devices */
-		list_for_each_entry(dd, devices, list)
-			if (!bdev_get_queue(dd->dm_dev->bdev)->mq_ops) {
-				DMERR("table load rejected: not all devices"
-				      " are blk-mq request-stackable");
-				return -EINVAL;
-			}
-
-		t->all_blk_mq = true;
+	if (sq_count && mq_count) {
+		DMERR("table load rejected: not all devices are blk-mq request-stackable");
+		return -EINVAL;
 	}
+	t->all_blk_mq = mq_count > 0;
 
 	return 0;
 }
@@ -1021,6 +1016,10 @@ bool dm_table_request_based(struct dm_table *t)
 	return __table_type_request_based(dm_table_get_type(t));
 }
 
+/*
+ * Returns true if all paths are blk-mq devices. Returns false if all paths
+ * are single queue block devices or if there are no paths.
+ */
 bool dm_table_all_blk_mq_devices(struct dm_table *t)
 {
 	return t->all_blk_mq;
-- 
2.10.1
