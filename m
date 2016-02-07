From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 13/15] dm mpath: use
	blk_mq_alloc_request() and blk_mq_free_request() directly
Date: Sun,  7 Feb 2016 10:53:35 -0500
Message-ID: <1454860417-3203-14-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

There isn't any need to support both old .request_fn and blk-mq paths
in the blk-mq specific portion of __multipath_map().  Call
blk_mq_alloc_request() directly rather than use blk_get_request().

Similarly, call blk_mq_free_request(), rather than blk_put_request(), in
multipath_release_clone().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 612ec57..7986446 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_dh.h>
 #include <linux/atomic.h>
+#include <linux/blk-mq.h>
 
 #define DM_MSG_PREFIX "multipath"
 #define DM_PG_INIT_DELAY_MSECS 2000
@@ -439,14 +440,22 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	spin_unlock_irq(&m->lock);
 
 	if (clone) {
-		/* Old request-based interface: allocated clone is passed in */
+		/*
+		 * Old request-based interface: allocated clone is passed in.
+		 * Used by both: .request_fn stacked on .request_fn path(s) and
+		 * blk-mq stacked on .request_fn path(s).
+		 */
 		clone->q = bdev_get_queue(bdev);
 		clone->rq_disk = bdev->bd_disk;
 		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	} else {
-		/* blk-mq request-based interface */
-		*__clone = blk_get_request(bdev_get_queue(bdev),
-					   rq_data_dir(rq), GFP_ATOMIC);
+		/*
+		 * blk-mq request-based interface; used by both:
+		 * .request_fn stacked on blk-mq path(s) and
+		 * blk-mq stacked on blk-mq path(s).
+		 */
+		*__clone = blk_mq_alloc_request(bdev_get_queue(bdev),
+						rq_data_dir(rq), BLK_MQ_REQ_NOWAIT);
 		if (IS_ERR(*__clone)) {
 			/* ENOMEM, requeue */
 			return r;
@@ -483,7 +492,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 
 static void multipath_release_clone(struct request *clone)
 {
-	blk_put_request(clone);
+	blk_mq_free_request(clone);
 }
 
 /*
-- 
2.5.4 (Apple Git-61)
