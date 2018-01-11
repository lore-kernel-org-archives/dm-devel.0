From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 12:04:31 -0500
Message-ID: <20180111170430.GA30621@redhat.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
 <804df5df-2598-df69-757d-85df18185d4c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <804df5df-2598-df69-757d-85df18185d4c@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  2:46am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/11/2018 03:12 AM, Mike Snitzer wrote:
> > 
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index 870484eaed1f..2395122875b4 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -929,6 +930,9 @@ void blk_unregister_queue(struct gendisk *disk)
> >  	if (WARN_ON(!q))
> >  		return;
> >  
> > +	if (!test_bit(QUEUE_FLAG_REGISTERED, &disk->queue->queue_flags))
> > +		return;
> > +
> >  	mutex_lock(&q->sysfs_lock);
> >  	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
> >  	mutex_unlock(&q->sysfs_lock);
> Why can't we use test_and_clear_bit() here?
> Shouldn't that relieve the need for the mutex_lock() here, too?

FYI, I looked at this and then got concerned with it enough to chat with
Mikulas (cc'd) about it, here is what he said:

11:54 <mikulas> if (!test_and_clear_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
11:55 <mikulas> this is buggy - the operation test_and_clear_bit is atomic - but if it races with some non-atomic read-modify-write operation on q->queue_flags, then the atomic modification would be lost
11:56 <mikulas> you must use always atomic accesses on q->queue_flags or always non-atomic accesses inside a mutex
11:56 <mikulas> queue_flag_clear_unlocked uses non-atomic __clear_bit
11:57 <mikulas> other functions in include/linux/blkdev.h also use non-atomic operations - so you cannot mix them with atomic operations

So my v4, that I'll send out shortly, won't be using test_and_clear_bit()

Thanks,
Mike
