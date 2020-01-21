From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v3 5/7] block: Add blk_queue_max_allocate_sectors()
Date: Tue, 21 Jan 2020 13:19:06 +0300
Message-ID: <157960194662.97730.18163991586346980476.stgit@localhost.localdomain>
References: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

This is a new helper to assign max_allocate_sectors
limit of block device queue.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 block/blk-settings.c   |   13 +++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 81468cd454a6..8d2fcbd693f9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -259,6 +259,19 @@ void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
 
+/**
+ * blk_queue_max_allocate_sectors - set max sectors for a single
+ *                                  allocate request
+ * @q:  the request queue for the device
+ * @max_allocate_sectors: maximum number of sectors to write per command
+ **/
+void blk_queue_max_allocate_sectors(struct request_queue *q,
+		unsigned int max_allocate_sectors)
+{
+	q->limits.max_allocate_sectors = max_allocate_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_allocate_sectors);
+
 /**
  * blk_queue_max_segments - set max hw segments for a request for this queue
  * @q:  the request queue for the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 20c94a7f9411..249dce6dd436 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1089,6 +1089,8 @@ extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
+extern void blk_queue_max_allocate_sectors(struct request_queue *q,
+		unsigned int max_allocate_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
