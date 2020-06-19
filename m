From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq: don't call blk_mq_queue_stopped in dm_stop_queue()
Date: Fri, 19 Jun 2020 05:42:50 -0400
Message-ID: <20200619094250.GA18410@redhat.com>
References: <20200619084214.337449-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200619084214.337449-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Ming,

Thanks for the patch!  But I'm having a hard time understanding what
you've written in the patch header,

On Fri, Jun 19 2020 at  4:42am -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> dm-rq won't stop queue, meantime blk-mq won't stop one queue too, so
> remove the check.

It'd be helpful if you could unpack this with more detail before going on
to explain why using blk_queue_quiesced, despite dm-rq using
blk_mq_queue_stopped, would also be ineffective.

SO:

> dm-rq won't stop queue

1) why won't dm-rq stop the queue?  Do you mean it won't reliably
   _always_ stop the queue because of the blk_mq_queue_stopped() check?

> meantime blk-mq won't stop one queue too, so remove the check.

2) Meaning?: blk_mq_queue_stopped() will return true even if only one hw
queue is stopped, given blk-mq must stop all hw queues a positive return
from this blk_mq_queue_stopped() check is incorrectly assuming it meanss
all hw queues are stopped.

> dm_stop_queue() actually tries to quiesce hw queues via blk_mq_quiesce_queue(),
> we can't check via blk_queue_quiesced for avoiding unnecessary queue
> quiesce because the flag is set before synchronize_rcu() and dm_stop_queue
> may be called when synchronize_rcu from another blk_mq_quiesce_queue is
> in-progress.

But I'm left with questions/confusion on this too:

1) you mention blk_queue_quiesced instead of blk_mq_queue_stopped, so I
   assume you mean that: not only is blk_mq_queue_stopped()
   ineffective, blk_queue_quiesced() would be too?

2) the race you detail (with competing blk_mq_quiesce_queue) relative to
   synchronize_rcu() and testing "the flag" is very detailed yet vague.

Anyway, once we get this heaader cleaned up a bit more I'll be happy to
get this staged as a stable@ fix for 5.8 inclusion ASAP.

Thanks!
Mike

> 
> Cc: linux-block@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-rq.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index f60c02512121..ed4d5ea66ccc 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -70,9 +70,6 @@ void dm_start_queue(struct request_queue *q)
>  
>  void dm_stop_queue(struct request_queue *q)
>  {
> -	if (blk_mq_queue_stopped(q))
> -		return;
> -
>  	blk_mq_quiesce_queue(q);
>  }
>  
> -- 
> 2.25.2
> 
