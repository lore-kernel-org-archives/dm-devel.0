From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 13/26] raid5: use bio_reset()
Date: Tue, 11 Sep 2012 12:26:41 -0700
Message-ID: <20120911192641.GH19739@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-14-git-send-email-koverstreet@google.com>
 <20120911150326.79f066c0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120911150326.79f066c0-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Tue, Sep 11, 2012 at 03:03:26PM +1000, NeilBrown wrote:
> On Mon, 10 Sep 2012 17:22:24 -0700 Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> wrote:
> 
> > Had to shuffle the code around a bit (where bi_rw and bi_end_io were
> > set), but shouldn't really be anything tricky here
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > ---
> >  drivers/md/raid5.c | 28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 7c19dbe..ebe43f7 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -561,14 +561,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  		bi = &sh->dev[i].req;
> >  		rbi = &sh->dev[i].rreq; /* For writing to replacement */
> >  
> > -		bi->bi_rw = rw;
> > -		rbi->bi_rw = rw;
> > -		if (rw & WRITE) {
> > -			bi->bi_end_io = raid5_end_write_request;
> > -			rbi->bi_end_io = raid5_end_write_request;
> > -		} else
> > -			bi->bi_end_io = raid5_end_read_request;
> > -
> >  		rcu_read_lock();
> >  		rrdev = rcu_dereference(conf->disks[i].replacement);
> >  		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
> > @@ -643,7 +635,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  
> >  			set_bit(STRIPE_IO_STARTED, &sh->state);
> >  
> > +			bio_reset(bi);
> >  			bi->bi_bdev = rdev->bdev;
> > +			bi->bi_rw = rw;
> > +			bi->bi_end_io = (rw & WRITE)
> > +				? raid5_end_write_request
> > +				: raid5_end_read_request;
> > +			bi->bi_private = sh;
> > +
> >  			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
> >  				__func__, (unsigned long long)sh->sector,
> >  				bi->bi_rw, i);
> > @@ -657,12 +656,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> >  				bi->bi_rw |= REQ_FLUSH;
> >  
> > -			bi->bi_flags = 1 << BIO_UPTODATE;
> > -			bi->bi_idx = 0;
> >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> >  			bi->bi_io_vec[0].bv_offset = 0;
> >  			bi->bi_size = STRIPE_SIZE;
> > -			bi->bi_next = NULL;
> >  			if (rrdev)
> >  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
> >  			generic_make_request(bi);
> > @@ -674,7 +670,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  
> >  			set_bit(STRIPE_IO_STARTED, &sh->state);
> >  
> > +			bio_reset(rbi);
> >  			rbi->bi_bdev = rrdev->bdev;
> > +			rbi->bi_rw = rw;
> > +			rbi->bi_end_io = (rw & WRITE)
> > +				? raid5_end_write_request
> > +				: raid5_end_read_request;
> 
> 'rbi->bi_end_io' can only ever be raid5_end_write_request.  We only get here
> on a write.
> I'd be OK with 
>     BUG_ON(!(rw & WRITE));
> but I don't want the condition in the assignment.

I was thinking to myself that if I was doing a bit more with that code,
I'd factor out all the code in the if (rdev) {} into a separate function
that was called twice there. But, I didn't do that here so you're right
- I'll change it and stick a BUG_ON() there.

> The rest looks quite sane.

Thanks!
