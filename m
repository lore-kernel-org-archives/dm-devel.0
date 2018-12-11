From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix request-based dm's use of
	dm_wait_for_completion
Date: Tue, 11 Dec 2018 09:10:26 -0500
Message-ID: <20181211141026.30174-1-snitzer@redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

The md->wait waitqueue is used by both bio-based and request-based DM.
Commit dbd3bbd291 ("dm rq: leverage blk_mq_queue_busy() to check for
outstanding IO") lost sight of the requirement that
dm_wait_for_completion() must work with all types of DM devices.

Fix md_in_flight() to call the blk-mq or bio-based method accordingly.

Fixes: dbd3bbd291 ("dm rq: leverage blk_mq_queue_busy() to check for outstanding IO")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c |  6 ++----
 drivers/md/dm.c    | 10 +++++++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5af22e165fb7..202e9be5aea7 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -131,10 +131,8 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
 static void rq_completed(struct mapped_device *md)
 {
 	/* nudge anyone waiting on suspend queue */
-	if (unlikely(waitqueue_active(&md->wait))) {
-		if (!blk_mq_queue_busy(md->queue))
-			wake_up(&md->wait);
-	}
+	if (unlikely(waitqueue_active(&md->wait)))
+		wake_up(&md->wait);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d80c34a34a2d..3a50675cfc1a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -646,7 +646,7 @@ static void free_tio(struct dm_target_io *tio)
 	bio_put(&tio->clone);
 }
 
-static bool md_in_flight(struct mapped_device *md)
+static bool md_in_flight_bios(struct mapped_device *md)
 {
 	int cpu;
 	struct hd_struct *part = &dm_disk(md)->part0;
@@ -660,6 +660,14 @@ static bool md_in_flight(struct mapped_device *md)
 	return sum != 0;
 }
 
+static bool md_in_flight(struct mapped_device *md)
+{
+	if (queue_is_mq(md->queue))
+		return blk_mq_queue_busy(md->queue);
+	else
+		return md_in_flight_bios(md);
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
-- 
2.15.0
