From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 6/8] block: introduce .last_merge and .hash to
 blk_mq_ctx
Date: Tue, 3 Oct 2017 02:19:22 -0700
Message-ID: <20171003091922.GD2771@infradead.org>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930112655.31451-7-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

> +enum elv_merge elv_merge_ctx(struct request_queue *q, struct request **req,
> +		struct bio *bio, struct blk_mq_ctx *ctx)
> +{
> +	WARN_ON_ONCE(!q->mq_ops);
> +	return __elv_merge(q, req, bio, ctx->hash, ctx->last_merge);
> +}

This function only has a single caller, just open code it.
