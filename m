From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] block: blktrace framework cleanup
Date: Tue, 30 Jun 2020 07:10:01 +0200
Message-ID: <20200630051001.GA27033@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-2-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200629234314.10509-2-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de
List-Id: dm-devel.ids

On Mon, Jun 29, 2020 at 04:43:04PM -0700, Chaitanya Kulkarni wrote:
> This patch removes the extra variables from the trace events and
> overall kernel blktrace framework. The removed members can easily be
> extracted from the remaining argument which reduces the code
> significantly and allows us to optimize the several tracepoints like
> the next patch in the series.      

The subject sounds a litle strange, I'd rather say:

"block: remove superflous arguments from tracepoints"

The actual changes look good to me.

> +		trace_block_rq_insert(rq);
>  	}
>  
>  	spin_lock(&ctx->lock);
> @@ -2111,7 +2111,7 @@ blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  		goto queue_exit;
>  	}
>  
> -	trace_block_getrq(q, bio, bio->bi_opf);
> +	trace_block_getrq(bio, bio->bi_opf);

But now that you remove more than the q argument in some spots you
might remove the op one here as well.  Or limit the first patch to
just the queue argument..
