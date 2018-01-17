From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 19:45:05 +0000
Message-ID: <1516218304.2820.51.camel@wdc.com>
References: <a096db4d-1c32-4682-844d-4a7fc02d47da@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a096db4d-1c32-4682-844d-4a7fc02d47da@email.android.com>
Content-Language: en-US
Content-ID: <41BC7437D25B564B9F9F00869FA4A6F6@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-01-17 at 14:36 -0500, Mike Snitzer wrote:
> That tree doesn't have the revert you think it does (because it doesn't have _any_ of the dm-4.16 changes).
> 
> So there is some other reason for your hang.

Hello Mike,

Please have another look, namely at the following commit:
https://github.com/bvanassche/linux/commit/cd0b6b9f8779a0b692b1ef1d1f5ba6cb2fd981c5

That contents of that commit is as follows:

Subject: [PATCH] Revert "dm rq: Avoid that request processing stalls sporadically"

This reverts commit 6077c2d706097c00d8f2fed57d3f3c45cd228ee8.
---
 drivers/md/dm-rq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 85d80b8ccc33..a9e0f6ec62b6 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -773,7 +773,6 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
-		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
 		return BLK_STS_RESOURCE;
 	}
 
Thanks,

Bart.
