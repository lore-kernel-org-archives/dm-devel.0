From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] block: avoid unconditionally freeing previously allocated
 request_queue
Date: Wed, 26 May 2010 00:52:20 -0400
Message-ID: <20100526045219.GB24702@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
 <1274744795-9825-3-git-send-email-snitzer@redhat.com>
 <4BFBB21A.3030105@ct.jp.nec.com>
 <20100525124912.GA7447@redhat.com>
 <20100525163455.GA10155@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100525163455.GA10155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On blk_init_allocated_queue_node failure, only free request_queue if
it is wasn't previously allocated outside the block layer
(e.g. blk_init_queue_node was blk_init_allocated_queue_node caller).

This addresses an interface bug introduced by the following commit:
01effb0 block: allow initialization of previously allocated request_queue

Otherwise the request_queue may be free'd out from underneath a caller
that is managing the request_queue directly (e.g. caller uses
blk_alloc_queue + blk_init_allocated_queue_node).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3bc5579..c0cdafd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -528,6 +528,25 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 }
 EXPORT_SYMBOL(blk_alloc_queue_node);
 
+static void blk_free_partial_queue(struct request_queue *q)
+{
+	struct request_list *rl;
+
+	if (!q)
+		return;
+
+	/* Was blk_init_free_list the cause for failure? */
+	rl = &q->rq;
+	if (!rl->rq_pool) {
+		kmem_cache_free(blk_requestq_cachep, q);
+		return;
+	}
+
+	/* Or was elevator_init? */
+	if (!q->elevator)
+		blk_put_queue(q);
+}
+
 /**
  * blk_init_queue  - prepare a request queue for use with a block device
  * @rfn:  The function to be called to process requests that have been
@@ -570,9 +589,14 @@ EXPORT_SYMBOL(blk_init_queue);
 struct request_queue *
 blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
-	struct request_queue *q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	struct request_queue *uninit_q, *q;
+
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	q = blk_init_allocated_queue_node(uninit_q, rfn, lock, node_id);
+	if (!q)
+		blk_free_partial_queue(uninit_q);
 
-	return blk_init_allocated_queue_node(q, rfn, lock, node_id);
+	return q;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -592,10 +616,8 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	q->node = node_id;
-	if (blk_init_free_list(q)) {
-		kmem_cache_free(blk_requestq_cachep, q);
+	if (blk_init_free_list(q))
 		return NULL;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
@@ -618,7 +640,6 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 		return q;
 	}
 
-	blk_put_queue(q);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue_node);
