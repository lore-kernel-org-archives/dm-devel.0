From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [for-4.16 PATCH v6 2/3] blk-mq: improve DM's blk-mq IO merging
 via blk_insert_cloned_request feedback
Date: Thu, 18 Jan 2018 11:25:10 +0800
Message-ID: <20180118032509.GB11167@ming.t460p>
References: <20180117162558.28553-1-snitzer@redhat.com>
 <20180117162558.28553-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180117162558.28553-3-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

On Wed, Jan 17, 2018 at 11:25:57AM -0500, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> blk_insert_cloned_request() is called in the fast path of a dm-rq driver
> (e.g. blk-mq request-based DM mpath).  blk_insert_cloned_request() uses
> blk_mq_request_bypass_insert() to directly append the request to the
> blk-mq hctx->dispatch_list of the underlying queue.
> 
> 1) This way isn't efficient enough because the hctx spinlock is always
> used.
> 
> 2) With blk_insert_cloned_request(), we completely bypass underlying
> queue's elevator and depend on the upper-level dm-rq driver's elevator
> to schedule IO.  But dm-rq currently can't get the underlying queue's
> dispatch feedback at all.  Without knowing whether a request was issued
> or not (e.g. due to underlying queue being busy) the dm-rq elevator will
> not be able to provide effective IO merging (as a side-effect of dm-rq
> currently blindly destaging a request from its elevator only to requeue
> it after a delay, which kills any opportunity for merging).  This
> obviously causes very bad sequential IO performance.
> 
> Fix this by updating blk_insert_cloned_request() to use
> blk_mq_request_direct_issue().  blk_mq_request_direct_issue() allows a
> request to be issued directly to the underlying queue and returns the
> dispatch feedback (blk_status_t).  If blk_mq_request_direct_issue()
> returns BLK_SYS_RESOURCE the dm-rq driver will now use DM_MAPIO_REQUEUE
> to _not_ destage the request.  Whereby preserving the opportunity to
> merge IO.
> 
> With this, request-based DM's blk-mq sequential IO performance is vastly
> improved (as much as 3X in mpath/virtio-scsi testing).
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> [blk-mq.c changes heavily influenced by Ming Lei's initial solution, but
> they were refactored to make them less fragile and easier to read/review]
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c   |  3 +--
>  block/blk-mq.c     | 37 +++++++++++++++++++++++++++++--------
>  block/blk-mq.h     |  3 +++
>  drivers/md/dm-rq.c | 19 ++++++++++++++++---
>  4 files changed, 49 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7ba607527487..55f338020254 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2500,8 +2500,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
>  		 * bypass a potential scheduler on the bottom device for
>  		 * insert.
>  		 */
> -		blk_mq_request_bypass_insert(rq, true);
> -		return BLK_STS_OK;
> +		return blk_mq_request_direct_issue(rq);
>  	}
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c117c2baf2c9..f5f0d8456713 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1731,15 +1731,19 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
>  
>  static void __blk_mq_fallback_to_insert(struct blk_mq_hw_ctx *hctx,
>  					struct request *rq,
> -					bool run_queue)
> +					bool run_queue, bool bypass_insert)
>  {
> -	blk_mq_sched_insert_request(rq, false, run_queue, false,
> -					hctx->flags & BLK_MQ_F_BLOCKING);
> +	if (!bypass_insert)
> +		blk_mq_sched_insert_request(rq, false, run_queue, false,
> +					    hctx->flags & BLK_MQ_F_BLOCKING);
> +	else
> +		blk_mq_request_bypass_insert(rq, run_queue);
>  }

If 'bypass_insert' is true, we don't need to insert the request into
hctx->dispatch_list for dm-rq, then it causes the issue(use after free)
reported by Bart and Laurence.

Also this way is the exact opposite of the idea of the improvement,
we do not want to dispatch request if underlying queue is busy.

Thanks,
Ming
