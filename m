From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] dm: open-code dm_kill_unmapped_request()
Date: Thu,  5 Jun 2014 15:11:04 +0200
Message-ID: <1401973867-121561-5-git-send-email-hare@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c               | 24 +++++-------------------
 include/linux/device-mapper.h |  1 -
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f55ca0c..5109c76 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1015,22 +1015,6 @@ static void dm_complete_request(struct request *clone, int error)
 }
 
 /*
- * Complete the not-mapped clone and the original request with the error status
- * through softirq context.
- * Target's rq_end_io() function isn't called.
- * This may be used when the target's map_rq() function fails.
- */
-void dm_kill_unmapped_request(struct request *clone, int error)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-
-	rq->cmd_flags |= REQ_FAILED;
-	dm_complete_request(clone, error);
-}
-EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
-
-/*
  * Called with the queue lock held
  */
 static void end_clone_request(struct request *clone, int error)
@@ -1631,7 +1615,8 @@ static int map_request(struct dm_target *ti, struct request *clone,
 		}
 
 		/* The target wants to complete the I/O */
-		dm_kill_unmapped_request(clone, r);
+		rq->cmd_flags |= REQ_FAILED;
+		dm_complete_request(clone, r);
 		break;
 	}
 
@@ -1691,11 +1676,12 @@ static void dm_request_fn(struct request_queue *q)
 		if (!dm_target_is_valid(ti)) {
 			/*
 			 * Must perform setup, that dm_done() requires,
-			 * before calling dm_kill_unmapped_request
+			 * before calling dm_complete_request
 			 */
 			DMERR_LIMIT("request attempted access beyond the end of device");
 			clone = dm_start_request(md, rq);
-			dm_kill_unmapped_request(clone, -EIO);
+			rq->cmd_flags |= REQ_FAILED;
+			dm_complete_request(clone, -EIO);
 			continue;
 		}
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 63da56e..3ad5db8 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -604,7 +604,6 @@ static inline unsigned long to_bytes(sector_t n)
  *---------------------------------------------------------------*/
 void dm_dispatch_request(struct request *rq);
 void dm_requeue_unmapped_request(struct request *rq);
-void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
 
 #endif	/* _LINUX_DEVICE_MAPPER_H */
-- 
1.7.12.4
