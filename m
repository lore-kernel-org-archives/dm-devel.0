From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v3 6/7] dm: Directly disable max_allocate_sectors for now
Date: Tue, 21 Jan 2020 13:19:12 +0300
Message-ID: <157960195201.97730.125791396853976710.stgit@localhost.localdomain>
References: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

Since dm inherits limits from underlining block devices,
this patch directly disables max_allocate_sectors for dm
till full allocation support is implemented.

This prevents high-level primitives (generic_make_request_checks(),
__blkdev_issue_write_zeroes(), ...) from sending REQ_ALLOCATE
requests.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 drivers/md/dm-table.c |    2 ++
 drivers/md/md.h       |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a2cc197f62b..e245c0d882aa 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -489,6 +489,7 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
 	limits->zoned = blk_queue_zoned_model(q);
+	blk_queue_max_allocate_sectors(q, 0);
 
 	return 0;
 }
@@ -1548,6 +1549,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
+		limits->max_allocate_sectors = 0;
 
 		/*
 		 * FIXME: this should likely be moved to blk_stack_limits(), would
diff --git a/drivers/md/md.h b/drivers/md/md.h
index acd681939112..b9b6d78035a2 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -798,5 +798,6 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 	    !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
+	blk_queue_max_allocate_sectors(mddev->queue);
 }
 #endif /* _MD_MD_H */
