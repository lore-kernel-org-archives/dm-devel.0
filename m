From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 11/12] block: blk_flush_integrity() for bio-based drivers
Date: Thu, 15 Oct 2015 16:00:40 -0400
Message-ID: <20151015200040.20721.83768.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, axboe@fb.com, dm-devel@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

Since they lack requests to pin the request_queue active, synchronous
bio-based drivers may have in-flight integrity work from
bio_integrity_endio() that is not flushed by blk_freeze_queue().  Flush
that work to prevent races to free the queue and the final usage of the
blk_integrity profile.

This is temporary unless/until bio-based drivers start to generically
take a q_usage_counter reference while a bio is in-flight.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
[martin: fix the CONFIG_BLK_DEV_INTEGRITY=n case]
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/bio-integrity.c |    5 +++++
 block/blk-core.c      |    3 +++
 block/blk.h           |    8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6a90eca9cea1..f6325d573c10 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -32,6 +32,11 @@
 static struct kmem_cache *bip_slab;
 static struct workqueue_struct *kintegrityd_wq;
 
+void blk_flush_integrity(void)
+{
+	flush_workqueue(kintegrityd_wq);
+}
+
 /**
  * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
diff --git a/block/blk-core.c b/block/blk-core.c
index 9b4d735cb5b8..6ebe33ed5154 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -561,6 +561,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
 
+	/* for synchronous bio-based driver finish in-flight integrity i/o */
+	blk_flush_integrity();
+
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	blk_sync_queue(q);
diff --git a/block/blk.h b/block/blk.h
index 5b2cd393afbe..157c93d54dc9 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -87,6 +87,14 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 	percpu_ref_get(&q->q_usage_counter);
 }
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+void blk_flush_integrity(void);
+#else
+static inline void blk_flush_integrity(void)
+{
+}
+#endif
+
 void blk_rq_timed_out_timer(unsigned long data);
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);

