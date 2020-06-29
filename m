From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 03/11] block: use block_bio event class for bio_queue
Date: Mon, 29 Jun 2020 16:43:06 -0700
Message-ID: <20200629234314.10509-4-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

Remove block_bio_queue trace event which shares the code with block_bio.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/trace/events/block.h | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index b5be387c4115..5e9f46469f50 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -357,32 +357,12 @@ DEFINE_EVENT(block_bio, block_bio_frontmerge,
  *
  * About to place the block IO operation @bio into queue.
  */
-TRACE_EVENT(block_bio_queue,
 
-	TP_PROTO(struct bio *bio),
-
-	TP_ARGS(bio),
-
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	RWBS_LEN	)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
+DEFINE_EVENT(block_bio, block_bio_queue,
 
-	TP_fast_assign(
-		__entry->dev		= bio_dev(bio);
-		__entry->sector		= bio->bi_iter.bi_sector;
-		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
+	TP_PROTO(struct bio *bio),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_ARGS(bio)
 );
 
 DECLARE_EVENT_CLASS(block_get_rq,
-- 
2.26.0
