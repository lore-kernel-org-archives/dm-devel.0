From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 5/8] dm: remove exports for request-based
	interfaces without external callers
Date: Tue, 16 Dec 2014 23:00:01 -0500
Message-ID: <1418788804-1982-6-git-send-email-snitzer@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

Remove exports for dm_dispatch_request, dm_requeue_unmapped_request,
and dm_kill_unmapped_request.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c               | 9 +++------
 include/linux/device-mapper.h | 3 ---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bef5070..1c69fcb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1062,7 +1062,7 @@ static void dm_unprep_request(struct request *rq)
 /*
  * Requeue the original request of a clone.
  */
-void dm_requeue_unmapped_request(struct request *clone)
+static void dm_requeue_unmapped_request(struct request *clone)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
@@ -1079,7 +1079,6 @@ void dm_requeue_unmapped_request(struct request *clone)
 
 	rq_completed(md, rw, 0);
 }
-EXPORT_SYMBOL_GPL(dm_requeue_unmapped_request);
 
 static void __stop_queue(struct request_queue *q)
 {
@@ -1177,7 +1176,7 @@ static void dm_complete_request(struct request *clone, int error)
  * Target's rq_end_io() function isn't called.
  * This may be used when the target's map_rq() function fails.
  */
-void dm_kill_unmapped_request(struct request *clone, int error)
+static void dm_kill_unmapped_request(struct request *clone, int error)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
@@ -1185,7 +1184,6 @@ void dm_kill_unmapped_request(struct request *clone, int error)
 	rq->cmd_flags |= REQ_FAILED;
 	dm_complete_request(clone, error);
 }
-EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
 
 /*
  * Called with the queue lock held
@@ -1686,7 +1684,7 @@ static void dm_request(struct request_queue *q, struct bio *bio)
 		_dm_request(q, bio);
 }
 
-void dm_dispatch_request(struct request *rq)
+static void dm_dispatch_request(struct request *rq)
 {
 	int r;
 
@@ -1698,7 +1696,6 @@ void dm_dispatch_request(struct request *rq)
 	if (r)
 		dm_complete_request(rq, r);
 }
-EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 				 void *data)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ca6d2ac..19296fb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -600,9 +600,6 @@ static inline unsigned long to_bytes(sector_t n)
 /*-----------------------------------------------------------------
  * Helper for block layer and dm core operations
  *---------------------------------------------------------------*/
-void dm_dispatch_request(struct request *rq);
-void dm_requeue_unmapped_request(struct request *rq);
-void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
 
 #endif	/* _LINUX_DEVICE_MAPPER_H */
-- 
1.9.3
