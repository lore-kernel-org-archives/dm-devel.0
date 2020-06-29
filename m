From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 02/11] block: rename block_bio_merge class to block_bio
Date: Mon, 29 Jun 2020 16:43:05 -0700
Message-ID: <20200629234314.10509-3-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

There are identical TRACE_EVENTS presents which can now take an
advantage of the block_bio_merge trace event class.

This is a prep patch which renames block_bio_merge to block_bio so
that the next patches in this series will be able to resue it.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/trace/events/block.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 237d40a48429..b5be387c4115 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -295,7 +295,7 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
-DECLARE_EVENT_CLASS(block_bio_merge,
+DECLARE_EVENT_CLASS(block_bio,
 
 	TP_PROTO(struct bio *bio),
 
@@ -330,7 +330,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
  * Merging block request @bio to the end of an existing block request
  * in queue.
  */
-DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
+DEFINE_EVENT(block_bio, block_bio_backmerge,
 
 	TP_PROTO(struct bio *bio),
 
@@ -344,7 +344,7 @@ DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
  * Merging block IO operation @bio to the beginning of an existing block
  * operation in queue.
  */
-DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
+DEFINE_EVENT(block_bio, block_bio_frontmerge,
 
 	TP_PROTO(struct bio *bio),
 
-- 
2.26.0
