From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 10/11] block: use block_bio class for getrq and sleeprq
Date: Mon, 29 Jun 2020 16:43:13 -0700
Message-ID: <20200629234314.10509-11-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

The only difference in block_get_rq and block_bio was the last param
passed  __entry->nr_sector & bio->bi_iter.bi_size respectively. Since
that is not the case anymore replace block_get_rq class with block_bio
for block_getrq and block_sleeprq events, also adjust the code to handle
null bio case in block_bio.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/trace/events/block.h | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d191d2cd1070..21f1daaf012b 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -272,11 +272,19 @@ DECLARE_EVENT_CLASS(block_bio,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio_dev(bio);
-		__entry->sector		= bio->bi_iter.bi_sector;
-		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		if (bio) {
+			__entry->dev		= bio_dev(bio);
+			__entry->sector		= bio->bi_iter.bi_sector;
+			__entry->nr_sector	= bio_sectors(bio);
+			blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
+			memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		} else {
+			__entry->dev		= 0;
+			__entry->sector		= 0;
+			__entry->nr_sector	= 0;
+			blk_fill_rwbs(__entry->rwbs, 0);
+			memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		}
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
@@ -380,7 +388,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
  * A request struct for queue has been allocated to handle the
  * block IO operation @bio.
  */
-DEFINE_EVENT(block_get_rq, block_getrq,
+DEFINE_EVENT(block_bio, block_getrq,
 
 	TP_PROTO(struct bio *bio),
 
@@ -396,7 +404,7 @@ DEFINE_EVENT(block_get_rq, block_getrq,
  * available.  This tracepoint event is generated each time the
  * process goes to sleep waiting for request struct become available.
  */
-DEFINE_EVENT(block_get_rq, block_sleeprq,
+DEFINE_EVENT(block_bio, block_sleeprq,
 
 	TP_PROTO(struct bio *bio),
 
-- 
2.26.0
