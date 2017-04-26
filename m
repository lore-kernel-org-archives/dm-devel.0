From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] dm mpath: simplify multipath_clone_and_map a little bit
Date: Wed, 26 Apr 2017 09:40:38 +0200
Message-ID: <20170426074039.14602-4-hch@lst.de>
References: <20170426074039.14602-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426074039.14602-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Remove the r variable and just expand the value at the two places where
it is used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 9e971be254f4..33ecda737376 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -484,7 +484,6 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 				   struct request **__clone)
 {
 	struct multipath *m = ti->private;
-	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = blk_rq_bytes(rq);
 	struct pgpath *pgpath;
 	struct block_device *bdev;
@@ -503,7 +502,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		pg_init_all_paths(m);
-		return r;
+		return DM_MAPIO_REQUEUE;
 	}
 
 	memset(mpio, 0, sizeof(*mpio));
@@ -517,7 +516,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 			GFP_ATOMIC);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
-		return r;
+		return DM_MAPIO_REQUEUE;
 	}
 	clone->bio = clone->biotail = NULL;
 	clone->rq_disk = bdev->bd_disk;
-- 
2.11.0
