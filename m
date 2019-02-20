From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 8/9] dm mpath: enable noclone support for
	bio-based
Date: Wed, 20 Feb 2019 16:44:35 -0500
Message-ID: <20190220214436.38476-9-snitzer@redhat.com>
References: <20190220214436.38476-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190220214436.38476-1-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Avoiding bio cloning (aka noclone) offers a slight advantage over bio
cloning for this read workload:
  fio --ioengine=psync --iodepth=1 --rw=read --bs=512 --direct=1 \
      --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/mapper/mpath

clone   3331MB/s 3337MB/s 3355MB/s
noclone 3418MB/s 3407MB/s 3420MB/s

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2ee5e357a0a7..579330cd7a6a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1178,9 +1178,10 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
-	if (m->queue_mode == DM_TYPE_BIO_BASED)
+	if (m->queue_mode == DM_TYPE_BIO_BASED) {
+		ti->no_clone = true;
 		ti->per_io_data_size = multipath_per_bio_data_size();
-	else
+	} else
 		ti->per_io_data_size = sizeof(struct dm_mpath_io);
 
 	return 0;
@@ -1584,11 +1585,11 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	return r;
 }
 
-static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
+static int multipath_end_io_bio(struct dm_target *ti, struct bio *bio,
 				blk_status_t *error)
 {
 	struct multipath *m = ti->private;
-	struct dm_mpath_io *mpio = get_mpio_from_bio(clone);
+	struct dm_mpath_io *mpio = get_mpio_from_bio(bio);
 	struct pgpath *pgpath = mpio->pgpath;
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
@@ -1611,7 +1612,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	}
 
 	spin_lock_irqsave(&m->lock, flags);
-	bio_list_add(&m->queued_bios, clone);
+	bio_list_add(&m->queued_bios, bio);
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!test_bit(MPATHF_QUEUE_IO, &m->flags))
 		queue_work(kmultipathd, &m->process_queued_bios);
@@ -2011,7 +2012,7 @@ static int multipath_busy(struct dm_target *ti)
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 13, 0},
+	.version = {1, 14, 0},
 	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
 		    DM_TARGET_PASSES_INTEGRITY,
 	.module = THIS_MODULE,
-- 
2.15.0
