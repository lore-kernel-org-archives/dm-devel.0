From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 026/330] dm table: do not allow
	request-based DM to stack on partitions
Date: Thu, 17 Sep 2020 21:56:06 -0400
Message-ID: <20200918020110.2063155-26-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 6ba01df72b4b63a26b4977790f58d8f775d2992c ]

Partitioned request-based devices cannot be used as underlying devices
for request-based DM because no partition offsets are added to each
incoming request.  As such, until now, stacking on partitioned devices
would _always_ result in data corruption (e.g. wiping the partition
table, writing to other partitions, etc).  Fix this by disallowing
request-based stacking on partitions.

While at it, since all .request_fn support has been removed from block
core, remove legacy dm-table code that differentiated between blk-mq and
.request_fn request-based.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 52e049554f5cd..2ae0c19137667 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -918,21 +918,15 @@ bool dm_table_supports_dax(struct dm_table *t,
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
 
-struct verify_rq_based_data {
-	unsigned sq_count;
-	unsigned mq_count;
-};
-
-static int device_is_rq_based(struct dm_target *ti, struct dm_dev *dev,
-			      sector_t start, sector_t len, void *data)
+static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-	struct verify_rq_based_data *v = data;
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (queue_is_mq(q))
-		v->mq_count++;
-	else
-		v->sq_count++;
+	/* request-based cannot stack on partitions! */
+	if (bdev != bdev->bd_contains)
+		return false;
 
 	return queue_is_mq(q);
 }
@@ -941,7 +935,6 @@ static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
-	struct verify_rq_based_data v = {.sq_count = 0, .mq_count = 0};
 	struct dm_target *tgt;
 	struct list_head *devices = dm_table_get_devices(t);
 	enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
@@ -1045,14 +1038,10 @@ verify_rq_based:
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!tgt->type->iterate_devices ||
-	    !tgt->type->iterate_devices(tgt, device_is_rq_based, &v)) {
+	    !tgt->type->iterate_devices(tgt, device_is_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-	if (v.sq_count > 0) {
-		DMERR("table load rejected: not all devices are blk-mq request-stackable");
-		return -EINVAL;
-	}
 
 	return 0;
 }
-- 
2.25.1
