From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 2/3] dm-zoned: improve error handling in i/o
	map code
Date: Sat, 10 Aug 2019 14:43:10 -0700
Message-ID: <20190810214311.9503-3-dmitry.fomichev@wdc.com>
References: <20190810214311.9503-1-dmitry.fomichev@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190810214311.9503-1-dmitry.fomichev@wdc.com>
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Some errors are ignored in the I/O path during queueing chunks
for processing by chunk works. Since at least these errors are
transient in nature, it should be possible to retry the failed
incoming commands.

The fix -

Errors that can happen while queueing chunks are carried upwards
to the main mapping function and it now returns DM_MAPIO_REQUEUE
for any incoming requests that can not be properly queued.

Error logging/debug messages are added where needed.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 drivers/md/dm-zoned-target.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 1bf6e6eebee1..c1992034c099 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -514,22 +514,24 @@ static void dmz_flush_work(struct work_struct *work)
  * Get a chunk work and start it to process a new BIO.
  * If the BIO chunk has no work yet, create one.
  */
-static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
+static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
 {
 	unsigned int chunk = dmz_bio_chunk(dmz->dev, bio);
 	struct dm_chunk_work *cw;
+	int ret = 0;
 
 	mutex_lock(&dmz->chunk_lock);
 
 	/* Get the BIO chunk work. If one is not active yet, create one */
 	cw = radix_tree_lookup(&dmz->chunk_rxtree, chunk);
 	if (!cw) {
-		int ret;
 
 		/* Create a new chunk work */
 		cw = kmalloc(sizeof(struct dm_chunk_work), GFP_NOIO);
-		if (!cw)
+		if (unlikely(!cw)) {
+			ret = -ENOMEM;
 			goto out;
+		}
 
 		INIT_WORK(&cw->work, dmz_chunk_work);
 		refcount_set(&cw->refcount, 0);
@@ -540,7 +542,6 @@ static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
 		ret = radix_tree_insert(&dmz->chunk_rxtree, chunk, cw);
 		if (unlikely(ret)) {
 			kfree(cw);
-			cw = NULL;
 			goto out;
 		}
 	}
@@ -548,10 +549,12 @@ static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
 	bio_list_add(&cw->bio_list, bio);
 	dmz_get_chunk_work(cw);
 
+	dmz_reclaim_bio_acc(dmz->reclaim);
 	if (queue_work(dmz->chunk_wq, &cw->work))
 		dmz_get_chunk_work(cw);
 out:
 	mutex_unlock(&dmz->chunk_lock);
+	return ret;
 }
 
 /*
@@ -565,6 +568,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 	sector_t sector = bio->bi_iter.bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	sector_t chunk_sector;
+	int ret;
 
 	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
 		      bio_op(bio), (unsigned long long)sector, nr_sectors,
@@ -602,8 +606,14 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 		dm_accept_partial_bio(bio, dev->zone_nr_sectors - chunk_sector);
 
 	/* Now ready to handle this BIO */
-	dmz_reclaim_bio_acc(dmz->reclaim);
-	dmz_queue_chunk_work(dmz, bio);
+	ret = dmz_queue_chunk_work(dmz, bio);
+	if (ret) {
+		dmz_dev_debug(dmz->dev,
+			      "BIO op %d, can't process chunk %llu, err %i\n",
+			      bio_op(bio), (u64)dmz_bio_chunk(dmz->dev, bio),
+			      ret);
+		return DM_MAPIO_REQUEUE;
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
-- 
2.21.0
