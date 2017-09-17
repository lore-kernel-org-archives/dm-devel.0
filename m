From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Sun, 17 Sep 2017 20:51:53 +0800
Message-ID: <20170917125152.GC6289@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-3-ming.lei@redhat.com>
 <1505496592.3420.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505496592.3420.10.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 15, 2017 at 05:29:53PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-16 at 00:44 +0800, Ming Lei wrote:
> > blk-mq will rerun queue via RESTART after one request is completion,
> > so not necessary to wait random time for requeuing, it should trust
> > blk-mq to do it.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-mpath.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 96aedaac2c64..f5a1088a6e79 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -505,7 +505,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
> >  			atomic_inc(&m->pg_init_in_progress);
> >  			activate_or_offline_path(pgpath);
> >  		}
> > -		return DM_MAPIO_DELAY_REQUEUE;
> > +		return DM_MAPIO_REQUEUE;
> >  	}
> >  	clone->bio = clone->biotail = NULL;
> >  	clone->rq_disk = bdev->bd_disk;
> 
> So you are reverting the patch below? Thank you very much.
> 
> commit 1c23484c355ec360ca2f37914f8a4802c6baeead
> Author: Bart Van Assche <bart.vanassche@wdc.com>
> Date:   Wed Aug 9 11:32:12 2017 -0700
> 
>     dm mpath: do not lock up a CPU with requeuing activity
>     
>     When using the block layer in single queue mode, get_request()
>     returns ERR_PTR(-EAGAIN) if the queue is dying and the REQ_NOWAIT
>     flag has been passed to get_request(). Avoid that the kernel
>     reports soft lockup complaints in this case due to continuous
>     requeuing activity.

What is the continuous requeuing activity? In case of BLK_STS_RESOURCE,
blk-mq's SCHED_RESTART(see blk_mq_sched_dispatch_requests()) will be
triggered, then this rq will be dispatched again after one rq is completed.

-- 
Ming
