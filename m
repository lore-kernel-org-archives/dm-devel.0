From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 08:25:43 -0700
Message-ID: <96ec5bc4-fe4c-4ac7-9bec-ee483a1c5b90@kernel.dk>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
 <20180119072623.GB25369@ming.t460p> <1516375212.3190.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1516375212.3190.4.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On 1/19/18 8:20 AM, Bart Van Assche wrote:
> On Fri, 2018-01-19 at 15:26 +0800, Ming Lei wrote:
>> Please see queue_delayed_work_on(), hctx->run_work is shared by all
>> scheduling, once blk_mq_delay_run_hw_queue(100ms) returns, no new
>> scheduling can make progress during the 100ms.
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

Exactly. That's why I said it was just a bug in my previous email, not
honoring a newer run is just stupid. Only other thing you have to be
careful with here is the STOPPED bit.

-- 
Jens Axboe
