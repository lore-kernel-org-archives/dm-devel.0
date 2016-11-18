From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/14] dm: Simplify dm_table_determine_type()
Date: Fri, 18 Nov 2016 14:27:25 -0800
Message-ID: <80797aad-4910-e06c-cded-c0e5efc35e5c@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
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
 drivers/md/dm-table.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 49893fdc..991d514 100644
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
-- 
2.10.1
