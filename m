From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v4 2/4] block: use queue_lock when clearing
 QUEUE_FLAG_REGISTERED in blk_unregister_queue
Date: Thu, 11 Jan 2018 21:53:43 -0500
Message-ID: <20180112025343.GD32298@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
 <20180111201417.2042-3-snitzer@redhat.com>
 <1515716920.2752.79.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515716920.2752.79.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  7:28pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 15:14 -0500, Mike Snitzer wrote:
> > blk_unregister_queue() must protect against any modifications of
> > q->queue_flags (not just those performed in blk-sysfs.c).  Therefore
> > q->queue_lock needs to be used rather than q->sysfs_lock.
> > 
> > Fixes: e9a823fb34a8b ("block: fix warning when I/O elevator is changed as request_queue is being removed")
> > Cc: stable@vger.kernel.org # 4.14+
> > Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  block/blk-sysfs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index 870484eaed1f..52f57539f1c7 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -929,9 +929,9 @@ void blk_unregister_queue(struct gendisk *disk)
> >  	if (WARN_ON(!q))
> >  		return;
> >  
> > -	mutex_lock(&q->sysfs_lock);
> > +	spin_lock_irq(q->queue_lock);
> >  	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
> > -	mutex_unlock(&q->sysfs_lock);
> > +	spin_unlock_irq(q->queue_lock);
> 
> Hello Mike,
> 
> The function name queue_flag_clear_unlocked() means "clear a queue flag
> without holding the queue lock". So at least to me the above code is confusing.
> Please consider to change queue_flag_clear_unlocked() into queue_flag_clear().

If Jens would like to change it when applying the patch to his tree
that is fine by me.

But as you know, it doesn't matter:
queue_flag_clear() just has extra queue_lockdep_assert_held(q);

So I see no reason to respin this patch for this.  Especially when you
consider patch 3 replaces it with queue_flag_test_and_clear() -- and no
it isn't a problem for stable@ to carry on using
queue_flag_clear_unlocked

Mike
