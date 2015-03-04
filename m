From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/8] dm: don't schedule delayed run of the queue
	if nothing to do
Date: Tue,  3 Mar 2015 19:47:08 -0500
Message-ID: <1425430031-78140-6-git-send-email-snitzer@redhat.com>
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

In request-based DM's dm_request_fn(), if blk_peek_request() returns
NULL just return.  Avoids unnecessary blk_delay_queue().

Reported-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8e58df5..c13477a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1960,7 +1960,7 @@ static void dm_request_fn(struct request_queue *q)
 	while (!blk_queue_stopped(q)) {
 		rq = blk_peek_request(q);
 		if (!rq)
-			goto delay_and_out;
+			goto out;
 
 		/* always use block 0 to find the target for flushes for now */
 		pos = 0;
-- 
1.9.3 (Apple Git-50)
