From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes
	idle
Date: Thu, 18 Jan 2018 12:03:53 -0500
Message-ID: <20180118170353.GB19734@redhat.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
	<b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at 11:50am -0500,
Bart Van Assche <bart.vanassche@wdc.com> wrote:

> On 01/17/18 18:41, Ming Lei wrote:
> >BLK_STS_RESOURCE can be returned from driver when any resource
> >is running out of. And the resource may not be related with tags,
> >such as kmalloc(GFP_ATOMIC), when queue is idle under this kind of
> >BLK_STS_RESOURCE, restart can't work any more, then IO hang may
> >be caused.
> >
> >Most of drivers may call kmalloc(GFP_ATOMIC) in IO path, and almost
> >all returns BLK_STS_RESOURCE under this situation. But for dm-mpath,
> >it may be triggered a bit easier since the request pool of underlying
> >queue may be consumed up much easier. But in reality, it is still not
> >easy to trigger it. I run all kinds of test on dm-mpath/scsi-debug
> >with all kinds of scsi_debug parameters, can't trigger this issue
> >at all. But finally it is triggered in Bart's SRP test, which seems
> >made by genius, :-)
> >
> >[ ... ]
> >
> >  static void blk_mq_timeout_work(struct work_struct *work)
> >  {
> >  	struct request_queue *q =
> >@@ -966,8 +1045,10 @@ static void blk_mq_timeout_work(struct work_struct *work)
> >  		 */
> >  		queue_for_each_hw_ctx(q, hctx, i) {
> >  			/* the hctx may be unmapped, so check it here */
> >-			if (blk_mq_hw_queue_mapped(hctx))
> >+			if (blk_mq_hw_queue_mapped(hctx)) {
> >  				blk_mq_tag_idle(hctx);
> >+				blk_mq_fixup_restart(hctx);
> >+			}
> >  		}
> >  	}
> >  	blk_queue_exit(q);
> 
> Hello Ming,
> 
> My comments about the above are as follows:
> - It can take up to q->rq_timeout jiffies after a .queue_rq()
>   implementation returned BLK_STS_RESOURCE before blk_mq_timeout_work()
>   gets called. However, it can happen that only a few milliseconds after
>   .queue_rq() returned BLK_STS_RESOURCE that the condition that caused
>   it to return BLK_STS_RESOURCE gets cleared. So the above approach can
>   result in long delays during which it will seem like the queue got
>   stuck. Additionally, I think that the block driver should decide how
>   long it takes before a queue is rerun and not the block layer core.

So configure q->rq_timeout to be shorter?  Which is configurable though
blk_mq_tag_set's 'timeout' member.  It apparently defaults to 30 * HZ.

That is the problem with timeouts, there is generally no one size fits
all.

> - The lockup that I reported only occurs with the dm driver but not any
>   other block driver. So why to modify the block layer core since this
>   can be fixed by modifying the dm driver?

Hard to know it is only DM's blk-mq that is impacted.  That is the only
blk-mq driver that you're testing like this (that is also able to handle
faults, etc).

> - A much simpler fix and a fix that is known to work exists, namely
>   inserting a blk_mq_delay_run_hw_queue() call in the dm driver.

Because your "much simpler" fix actively hurts performance, as is
detailed in this header:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=ec3eaf9a673106f66606896aed6ddd20180b02ec

I'm not going to take your bandaid fix given it very much seems to be
papering over a real blk-mq issue.

Mike
