From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v4 2/4] block: use queue_lock when clearing
 QUEUE_FLAG_REGISTERED in blk_unregister_queue
Date: Fri, 12 Jan 2018 07:53:40 -0500
Message-ID: <20180112125340.GA1824@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
 <20180111201417.2042-3-snitzer@redhat.com>
 <20180112070936.GB31164@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112070936.GB31164@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org, David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at  2:09am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Jan 11, 2018 at 03:14:15PM -0500, Mike Snitzer wrote:
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
> >  
> >  	wbt_exit(q);
> 
> Hi Mike,
> 
> This change may not be correct, since at least e9a823fb34a8b depends
> on q->sysfs_lock to sync between testing the flag in __elevator_change()
> and clearing it here.

The header for commit e9a823fb34a8b says:
    To fix this warning, we can check the QUEUE_FLAG_REGISTERED flag when
    changing the elevator and use the request_queue's sysfs_lock to
    serialize between clearing the flag and the elevator testing the flag.

The reality is sysfs_lock isn't needed to serialize between
blk_unregister_queue() clearing the flag and __elevator_change() testing
the flag.

The original commit e9a823fb34a8b is pretty conflated.  "conflated" because
the resource being protected isn't the queue_flags (it is the 'queue'
kobj).

I'll respin v5 of this patchset to fix this up first, and then apply the
changes I _really_ need to land (DM queue initialization fix).

And then I'm going to slowly step away from block core and _not_ allow
myself to be tripped up, or baited, by historic block core issues for a
while... ;)

Thanks,
Mike
