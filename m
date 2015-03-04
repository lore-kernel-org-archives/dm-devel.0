From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/8] dm: only run the queue on completion if
	congested or no requests pending
Date: Tue,  3 Mar 2015 19:47:07 -0500
Message-ID: <1425430031-78140-5-git-send-email-snitzer@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

On really fast storage it can be beneficial to delay running the
request_queue to allow the elevator more opportunity to merge requests.

Otherwise, it has been observed that requests are being sent to
q->request_fn much quicker than is ideal on IOPS-bound backends.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6a85bd4..8e58df5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1021,10 +1021,13 @@ static void end_clone_bio(struct bio *clone, int error)
  */
 static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 {
+	int nr_requests_pending;
+
 	atomic_dec(&md->pending[rw]);
 
 	/* nudge anyone waiting on suspend queue */
-	if (!md_in_flight(md))
+	nr_requests_pending = md_in_flight(md);
+	if (!nr_requests_pending)
 		wake_up(&md->wait);
 
 	/*
@@ -1033,8 +1036,11 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * back into ->request_fn() could deadlock attempting to grab the
 	 * queue lock again.
 	 */
-	if (run_queue)
-		blk_run_queue_async(md->queue);
+	if (run_queue) {
+		if (!nr_requests_pending ||
+		    (nr_requests_pending >= md->queue->nr_congestion_on))
+			blk_run_queue_async(md->queue);
+	}
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.9.3 (Apple Git-50)
