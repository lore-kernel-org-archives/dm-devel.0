From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/7] dm-mpath: Do not touch *__clone if request
 allocation fails
Date: Tue, 15 Nov 2016 15:34:32 -0800
Message-ID: <451fbed9-5b78-7b80-f894-88be842e238d@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
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

Do not modify *__clone if blk_mq_alloc_request() fails. This makes
it easier to figure out what is going on if the caller accidentally
dereferences *__clone if blk_mq_alloc_request() failed.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1c97f0e..5c73818 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -582,16 +582,17 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		 * .request_fn stacked on blk-mq path(s) and
 		 * blk-mq stacked on blk-mq path(s).
 		 */
-		*__clone = blk_mq_alloc_request(bdev_get_queue(bdev),
-						rq_data_dir(rq), BLK_MQ_REQ_NOWAIT);
-		if (IS_ERR(*__clone)) {
-			/* ENOMEM, requeue */
+		clone = blk_mq_alloc_request(bdev_get_queue(bdev),
+					rq_data_dir(rq), BLK_MQ_REQ_NOWAIT);
+		if (IS_ERR(clone)) {
+			/* EBUSY, ENODEV or EWOULDBLOCK; requeue */
 			clear_request_fn_mpio(m, map_context);
 			return r;
 		}
-		(*__clone)->bio = (*__clone)->biotail = NULL;
-		(*__clone)->rq_disk = bdev->bd_disk;
-		(*__clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+		*__clone = clone;
+		clone->bio = clone->biotail = NULL;
+		clone->rq_disk = bdev->bd_disk;
+		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	}
 
 	if (pgpath->pg->ps.type->start_io)
-- 
2.10.1
