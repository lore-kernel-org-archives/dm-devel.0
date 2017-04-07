From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] dm-mpath: Requeue after a small delay if
 blk_get_request() fails
Date: Fri, 7 Apr 2017 16:50:44 -0700
Message-ID: <dbf70983-7e32-0a65-589b-8cfb15c12792@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

If blk_get_request() returns ENODEV then multipath_clone_and_map()
causes a request to be requeued immediately. This can cause a
kworker thread to spend 100% of the CPU time of a single core in
__blk_mq_run_hw_queue() and also can cause device removal to
never finish.

Avoid this by only requeuing after a delay if blk_get_request()
fails. Additionally, reduce the requeue delay.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 2 +-
 drivers/md/dm-rq.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 39f9549b3300..e70f0e5bfcaf 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -517,7 +517,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 			GFP_ATOMIC);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
-		return r;
+		return DM_MAPIO_DELAY_REQUEUE;
 	}
 	clone->bio = clone->biotail = NULL;
 	clone->rq_disk = bdev->bd_disk;
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5f4e0c47516d..f3f986b08b6a 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -280,7 +280,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	if (!rq->q->mq_ops)
 		dm_old_requeue_request(rq);
 	else
-		dm_mq_delay_requeue_request(rq, delay_requeue ? 5000 : 0);
+		dm_mq_delay_requeue_request(rq, delay_requeue ? 100/*ms*/ : 0);
 
 	rq_completed(md, rw, false);
 }
-- 
2.12.0
