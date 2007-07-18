From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] block: cosmetic changes
Date: Wed, 18 Jul 2007 19:56:55 +0900
Message-ID: <20070718105655.GB22374@htj.dyndns.org>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070530093503.GA15559@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070530093503.GA15559@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Phillip Susi <psusi@cfl.rr.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Cosmetic changes.  This is taken from Jens' zero-length barrier patch.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jes.axboe@oracle.com>
---
 block/ll_rw_blk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: work/block/ll_rw_blk.c
===================================================================
--- work.orig/block/ll_rw_blk.c
+++ work/block/ll_rw_blk.c
@@ -443,7 +443,8 @@ static inline struct request *start_orde
 	rq_init(q, rq);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
-	rq->cmd_flags |= q->ordered & QUEUE_ORDERED_FUA ? REQ_FUA : 0;
+	if (q->ordered & QUEUE_ORDERED_FUA)
+		rq->cmd_flags |= REQ_FUA;
 	rq->elevator_private = NULL;
 	rq->elevator_private2 = NULL;
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
@@ -3167,7 +3168,7 @@ end_io:
 			break;
 		}
 
-		if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
+		if (unlikely(nr_sectors > q->max_hw_sectors)) {
 			printk("bio too big device %s (%u > %u)\n", 
 				bdevname(bio->bi_bdev, b),
 				bio_sectors(bio),
