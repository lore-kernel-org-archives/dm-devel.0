From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 4/5] blk-mq: introduce blk_get_request_notify
Date: Mon, 22 Jan 2018 18:19:03 +0800
Message-ID: <20180122101902.GD1570@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180122033550.27855-5-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, Jan 22, 2018 at 11:35:49AM +0800, Ming Lei wrote:
> DM-MPATH need to allocate request from underlying queue, but when the
> allocation fails, there is no way to make underlying queue's RESTART
> to restart DM's queue.
> 
> This patch introduces blk_get_request_notify() for this purpose, and
> caller need to pass 'wait_queue_entry_t' to this function, and make
> sure it is initialized well, so after the current allocation fails,
> DM will get notified when there is request available from underlying
> queue.
> 
> This approach is suggested by Jens, and has been used in blk-mq dispatch
> patch for a while, see blk_mq_mark_tag_wait().
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-tag.c     | 27 ++++++++++++++++++++++++++-
>  block/blk-mq.c         | 24 +++++++++++++++++++++---
>  block/blk-mq.h         |  1 +
>  include/linux/blk-mq.h |  5 +++++
>  4 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 336dde07b230..911fc9bd1bab 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -128,10 +128,35 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
>  	if (tag != -1)
>  		goto found_tag;
>  
> -	if (data->flags & BLK_MQ_REQ_NOWAIT)
> +	if ((data->flags & BLK_MQ_REQ_NOWAIT) && !(data->notifier &&
> +			(data->flags & BLK_MQ_REQ_ALLOC_NOTIFY)))
>  		return BLK_MQ_TAG_FAIL;
>  
>  	ws = bt_wait_ptr(bt, data->hctx);
> +
> +	/*
> +	 * If caller requires notification when tag is available, add
> +	 * wait entry of 'data->notifier' to the wait queue.
> +	 */
> +	if (data->flags & BLK_MQ_REQ_NOWAIT) {
> +		bool added = false;
> +
> +		spin_lock_irq(&ws->wait.lock);
> +		if (list_empty(&data->notifier->entry))
> +			__add_wait_queue(&ws->wait, data->notifier);
> +		else
> +			added = true;
> +		spin_unlock_irq(&ws->wait.lock);

The above need a per-notifier lock too, since the same notifier may
be added to different wait queues at the same time.

-- 
Ming
