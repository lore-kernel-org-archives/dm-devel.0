From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 08:50:43 -0800
Message-ID: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180118024124.8079-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

On 01/17/18 18:41, Ming Lei wrote:
> BLK_STS_RESOURCE can be returned from driver when any resource
> is running out of. And the resource may not be related with tags,
> such as kmalloc(GFP_ATOMIC), when queue is idle under this kind of
> BLK_STS_RESOURCE, restart can't work any more, then IO hang may
> be caused.
> 
> Most of drivers may call kmalloc(GFP_ATOMIC) in IO path, and almost
> all returns BLK_STS_RESOURCE under this situation. But for dm-mpath,
> it may be triggered a bit easier since the request pool of underlying
> queue may be consumed up much easier. But in reality, it is still not
> easy to trigger it. I run all kinds of test on dm-mpath/scsi-debug
> with all kinds of scsi_debug parameters, can't trigger this issue
> at all. But finally it is triggered in Bart's SRP test, which seems
> made by genius, :-)
> 
> [ ... ]
 >
>   static void blk_mq_timeout_work(struct work_struct *work)
>   {
>   	struct request_queue *q =
> @@ -966,8 +1045,10 @@ static void blk_mq_timeout_work(struct work_struct *work)
>   		 */
>   		queue_for_each_hw_ctx(q, hctx, i) {
>   			/* the hctx may be unmapped, so check it here */
> -			if (blk_mq_hw_queue_mapped(hctx))
> +			if (blk_mq_hw_queue_mapped(hctx)) {
>   				blk_mq_tag_idle(hctx);
> +				blk_mq_fixup_restart(hctx);
> +			}
>   		}
>   	}
>   	blk_queue_exit(q);

Hello Ming,

My comments about the above are as follows:
- It can take up to q->rq_timeout jiffies after a .queue_rq()
   implementation returned BLK_STS_RESOURCE before blk_mq_timeout_work()
   gets called. However, it can happen that only a few milliseconds after
   .queue_rq() returned BLK_STS_RESOURCE that the condition that caused
   it to return BLK_STS_RESOURCE gets cleared. So the above approach can
   result in long delays during which it will seem like the queue got
   stuck. Additionally, I think that the block driver should decide how
   long it takes before a queue is rerun and not the block layer core.
- The lockup that I reported only occurs with the dm driver but not any
   other block driver. So why to modify the block layer core since this
   can be fixed by modifying the dm driver?
- A much simpler fix and a fix that is known to work exists, namely
   inserting a blk_mq_delay_run_hw_queue() call in the dm driver.

Bart.
