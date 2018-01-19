From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 23:33:33 +0800
Message-ID: <20180119153333.GA14827@ming.t460p>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
 <20180119072623.GB25369@ming.t460p>
 <1516375212.3190.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516375212.3190.4.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 03:20:13PM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-19 at 15:26 +0800, Ming Lei wrote:
> > Please see queue_delayed_work_on(), hctx->run_work is shared by all
> > scheduling, once blk_mq_delay_run_hw_queue(100ms) returns, no new
> > scheduling can make progress during the 100ms.
> 
> How about addressing that as follows:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f7515dd95a36..57f8379a476d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1403,9 +1403,9 @@ static void __blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async,
>  		put_cpu();
>  	}
>  
> -	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> -					 &hctx->run_work,
> -					 msecs_to_jiffies(msecs));
> +	kblockd_mod_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> +				    &hctx->run_work,
> +				    msecs_to_jiffies(msecs));
>  }
>  
>  void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
> 
> Bart.

Yes, this one together with Jen's suggestion with returning
BLK_STS_NO_DEV_RESOURCE should fix this issue.

Could you cook a fix for this issue? Otherwise I am happy to do
that.

-- 
Ming
