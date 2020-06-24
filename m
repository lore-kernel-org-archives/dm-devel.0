From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC] block: blktrace framework cleanup
Date: Wed, 24 Jun 2020 08:48:20 +0200
Message-ID: <20200624064820.GA17964@lst.de>
References: <20200624032752.4177-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200624032752.4177-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, kbusch@kernel.org, hch@lst.de, rostedt@goodmis.org, mingo@redhat.com, rdunlap@infradead.org
List-Id: dm-devel.ids



On Tue, Jun 23, 2020 at 08:27:52PM -0700, Chaitanya Kulkarni wrote:
> There are many places where trace API accepts the struct request_queue*
> parameter which can be derived from other function parameters.
> 
> This patch removes the struct request queue parameter from the
> blktrace framework and adjusts the tracepoints definition and usage
> along with the tracing API itself.

Good idea, and I had a half-ready patch for this already as well.

One issue, and two extra requests below:


>  	if (bio->bi_disk && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
> -		trace_block_bio_complete(bio->bi_disk->queue, bio);
> +		trace_block_bio_complete(bio);

This one can also be called for a different queue than
bio->bi_disk->queue, so for this one particular tracepoint we'll need
to keep the request_queue argument.

> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index fdcc2c1dd178..a3cade16ef80 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -409,7 +409,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
>  
>  void blk_mq_sched_request_inserted(struct request *rq)
>  {
> -	trace_block_rq_insert(rq->q, rq);
> +	trace_block_rq_insert(rq);
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);

As a follow on patch we should also remove this function.

>  	}
>  
>  	spin_lock(&ctx->lock);
> @@ -2111,7 +2111,7 @@ blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  		goto queue_exit;
>  	}
>  
> -	trace_block_getrq(q, bio, bio->bi_opf);
> +	trace_block_getrq(bio, bio->bi_opf);

The second argument can be removed as well.  Maybe as another patch.
