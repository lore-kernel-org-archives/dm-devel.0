From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Thu, 16 Jul 2015 09:13:49 -0400
Message-ID: <x498uagtfci.fsf@segfault.boston.devel.redhat.com>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
	<1436764355.30675.10.camel@hasee> <20150713153537.GA30898@redhat.com>
	<1437030372.3618.5.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437030372.3618.5.camel@hasee> (Ming Lin's message of "Thu, 16
	Jul 2015 00:06:12 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, NeilBrown <neilb@suse.de>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Ming Lin <mlin@kernel.org> writes:

> On Mon, 2015-07-13 at 11:35 -0400, Mike Snitzer wrote:
>> I will do additional review to answer 1 and 2 above.  And Jeff Moyer
>> told me he'd test the patchset on one of his testbeds.
>
> Hi Jeff,
>
> FYI, here is a fix for patch 1.
> Or you can pull from my tree.
> https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-generic-req

Thanks, Ming.  I'll let you know as soon as I have results worth sharing.

Cheers,
Jeff

>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 40d08e3..181f343 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1287,12 +1287,12 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  		return;
>  	}
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (!is_flush_fua && !blk_queue_nomerges(q) &&
>  	    blk_attempt_plug_merge(q, bio, &request_count, &same_queue_rq))
>  		return;
>  
> -	blk_queue_split(q, &bio, q->bio_split);
> -
>  	rq = blk_mq_map_request(q, bio, &data);
>  	if (unlikely(!rq))
>  		return;
> @@ -1374,12 +1374,12 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  		return;
>  	}
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (!is_flush_fua && !blk_queue_nomerges(q) &&
>  	    blk_attempt_plug_merge(q, bio, &request_count, NULL))
>  		return;
>  
> -	blk_queue_split(q, &bio, q->bio_split);
> -
>  	rq = blk_mq_map_request(q, bio, &data);
>  	if (unlikely(!rq))
>  		return;
