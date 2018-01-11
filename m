From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 14:20:27 -0500
Message-ID: <20180111192027.GA31104@redhat.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
 <804df5df-2598-df69-757d-85df18185d4c@suse.de>
 <20180111170430.GA30621@redhat.com>
 <1515691112.2752.21.camel@wdc.com>
 <20180111172943.GA30762@redhat.com>
 <1515692836.2752.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515692836.2752.42.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at 12:47pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 12:29 -0500, Mike Snitzer wrote:
> > On Thu, Jan 11 2018 at 12:18pm -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > 
> > > On Thu, 2018-01-11 at 12:04 -0500, Mike Snitzer wrote:
> > > > So my v4, that I'll send out shortly, won't be using test_and_clear_bit()
> > > 
> > > Please use queue_flag_set(), queue_flag_clear(), queue_flag_test_and_clear() and/or
> > > queue_flag_test_and_set() to manipulate queue flags.
> > 
> > Can you please expand on this?  My patch is only using test_bit().
> 
> Hello Mike,
> 
> I was referring to the following code, which apparenly is existing code:
> 
>         mutex_lock(&q->sysfs_lock);
>         queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
>         mutex_unlock(&q->sysfs_lock);
> 
> The above code is wrong. Other code that changes the queue flags protects
> these changes with the the queue lock. The above code should be changed into
> the following:
> 
> 	spin_lock_irq(q->queue_lock);
> 	queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
> 	spin_unlock_irq(q->queue_lock);
> 
> The only functions from which it is safe to call queue_flag_(set|clear)_unlocked()
> without holding the queue lock are blk_alloc_queue_node() and
> __blk_release_queue() because for these functions it is guaranteed that no queue
> flag changes can happen from another context, e.g. through a blk_set_queue_dying()
> call.

Yes, I noticed the use of sysfs_lock also.  I've fixed it up earlier in
my v4 patchset and build on it.  I'll add your Reported-by too.

Mike
