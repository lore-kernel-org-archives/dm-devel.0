From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 7/8] blk-mq-sched: refactor blk_mq_sched_try_merge()
Date: Tue, 3 Oct 2017 02:20:10 -0700
Message-ID: <20171003092010.GE2771@infradead.org>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-8-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930112655.31451-8-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

> +bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
> +		struct request **merged_request)
> +{
> +	struct request *rq;
> +	enum elv_merge type = elv_merge(q, &rq, bio);
> +
> +	return __blk_mq_try_merge(q, bio, merged_request, rq, type);
> +}
>  EXPORT_SYMBOL_GPL(blk_mq_sched_try_merge);

This only has two callers, just open code it and rename __blk_mq_try_merge
to blk_mq_try_merge.
