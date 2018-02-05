From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] wbt: fix incorrect throttling due to flush latency
Date: Mon, 5 Feb 2018 15:00:47 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802051456570.24305@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1802051406190.15867@file01.intranet.prod.int.rdu2.redhat.com> <33d2d1ab-d57e-8a3f-94df-e79704b5d863@kernel.dk> <6bf3dd42-eb4a-8408-eb09-3b6c4dd18354@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <6bf3dd42-eb4a-8408-eb09-3b6c4dd18354@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 5 Feb 2018, Jens Axboe wrote:

> On 2/5/18 12:22 PM, Jens Axboe wrote:
> > On 2/5/18 12:11 PM, Mikulas Patocka wrote:
> >> I have a workload where one process sends many asynchronous write bios
> >> (without waiting for them) and another process sends synchronous flush
> >> bios. During this workload, writeback throttling throttles down to one
> >> outstanding bio, and this incorrect throttling causes performance
> >> degradation (all write bios sleep in __wbt_wait and they couldn't be sent
> >> in parallel).
> >>
> >> The reason for this throttling is that wbt_data_dir counts flush requests
> >> in the read bucket. The flush requests (that take quite a long time)
> >> trigger this condition repeatedly:
> >> 	if (stat[READ].min > rwb->min_lat_nsec)
> >> and that condition causes scale down to one outstanding request, despite
> >> the fact that there are no read bios at all.
> >>
> >> A similar problem could also show up with REQ_OP_ZONE_REPORT and
> >> REQ_OP_ZONE_RESET - they are also counted in the read bucket.
> >>
> >> This patch fixes the function wbt_data_dir, so that only REQ_OP_READ 
> >> requests are counted in the read bucket. The patch improves SATA 
> >> write+flush throughput from 130MB/s to 350MB/s.
> > 
> > Good catch. But I do wonder if we should account them at all. It
> > might make sense to account flushes as writes, but we really
> > should not account anything that isn't regular read/write IO 
> > related.
> > 
> > Something like the below? Potentially including REQ_OP_FLUSH in the
> > write latencies as well.
> 
> Thinking about it, flush should just be counted as writes, and the
> rest disregarded. Ala below.
> 
> 
> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index ae8de9780085..f92fc84b5e2c 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -697,7 +697,15 @@ u64 wbt_default_latency_nsec(struct request_queue *q)
>  
>  static int wbt_data_dir(const struct request *rq)
>  {
> -	return rq_data_dir(rq);
> +	const int op = req_op(rq);
> +
> +	if (op == REQ_OP_READ)
> +		return READ;
> +	else if (op == REQ_OP_WRITE || op == REQ_OP_FLUSH)
> +		return WRITE;
> +
> +	/* don't account */
> +	return -1;
>  }
>  
>  int wbt_init(struct request_queue *q)
> 
> -- 
> Jens Axboe

Yes, this works.

BTW. write throttling still causes some performance degradation (350MB/s 
vs. 500MB/s without throttling) - should there be some logic that disables 
write throttling if no sync requests are received?

Something like - if there's sync read, enable write throttling - if there 
were no sync reads in the last 5 seconds, disable write throttling?

Mikulas
