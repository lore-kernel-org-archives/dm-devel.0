From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/10] block: don't set bounce limit in blk_init_allocated_queue
Date: Mon, 19 Jun 2017 09:26:25 +0200
Message-ID: <20170619072628.12894-8-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

And just move it into scsi_transport_sas which needs it due to low-level
drivers directly derferencing bio_data, and into blk_init_queue_node,
which will need a further push into the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                  | 10 +++++-----
 drivers/scsi/scsi_transport_sas.c |  5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 07b26853ce1e..ef82164c6d82 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -927,6 +927,11 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 		return NULL;
 	}
 
+	/*
+	 * by default assume old behaviour and bounce for any highmem page
+	 */
+	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
+
 	return q;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
@@ -954,11 +959,6 @@ int blk_init_allocated_queue(struct request_queue *q)
 	 */
 	blk_queue_make_request(q, blk_queue_bio);
 
-	/*
-	 * by default assume old behaviour and bounce for any highmem page
-	 */
-	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-
 	q->sg_reserved_size = INT_MAX;
 
 	/* Protect q->elevator from elevator_change */
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index cc970c811bcb..87ea904f0700 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -249,6 +249,11 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 	if (error)
 		goto out_cleanup_queue;
 
+	/*
+	 * by default assume old behaviour and bounce for any highmem page
+	 */
+	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
+
 	error = bsg_register_queue(q, dev, name, release);
 	if (error)
 		goto out_cleanup_queue;
-- 
2.11.0
