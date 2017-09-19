From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Tue, 19 Sep 2017 23:56:57 +0800
Message-ID: <20170919155656.GB19830@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-3-ming.lei@redhat.com>
 <1505496592.3420.10.camel@wdc.com>
 <20170915200655.GA28136@redhat.com>
 <20170917132318.GD6289@ming.t460p>
 <20170919144130.GA22469@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919144130.GA22469@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

On Tue, Sep 19, 2017 at 10:41:30AM -0400, Mike Snitzer wrote:
> On Sun, Sep 17 2017 at  9:23am -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Fri, Sep 15, 2017 at 04:06:55PM -0400, Mike Snitzer wrote:
> > > On Fri, Sep 15 2017 at  1:29pm -0400,
> > > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > > 
> > > > On Sat, 2017-09-16 at 00:44 +0800, Ming Lei wrote:
> > > > > blk-mq will rerun queue via RESTART after one request is completion,
> > > > > so not necessary to wait random time for requeuing, it should trust
> > > > > blk-mq to do it.
> > > > > 
> > > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > > ---
> > > > >  drivers/md/dm-mpath.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > > index 96aedaac2c64..f5a1088a6e79 100644
> > > > > --- a/drivers/md/dm-mpath.c
> > > > > +++ b/drivers/md/dm-mpath.c
> > > > > @@ -505,7 +505,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
> > > > >  			atomic_inc(&m->pg_init_in_progress);
> > > > >  			activate_or_offline_path(pgpath);
> > > > >  		}
> > > > > -		return DM_MAPIO_DELAY_REQUEUE;
> > > > > +		return DM_MAPIO_REQUEUE;
> > > > >  	}
> > > > >  	clone->bio = clone->biotail = NULL;
> > > > >  	clone->rq_disk = bdev->bd_disk;
> > > > 
> > > > So you are reverting the patch below? Thank you very much.
> > > > 
> > > > commit 1c23484c355ec360ca2f37914f8a4802c6baeead
> > > > Author: Bart Van Assche <bart.vanassche@wdc.com>
> > > > Date:   Wed Aug 9 11:32:12 2017 -0700
> > > > 
> > > >     dm mpath: do not lock up a CPU with requeuing activity
> > > >     
> > > >     When using the block layer in single queue mode, get_request()
> > > >     returns ERR_PTR(-EAGAIN) if the queue is dying and the REQ_NOWAIT
> > > >     flag has been passed to get_request(). Avoid that the kernel
> > > >     reports soft lockup complaints in this case due to continuous
> > > >     requeuing activity.
> > > >     
> > > >     Fixes: 7083abbbf ("dm mpath: avoid that path removal can trigger an infinite loop")
> > > >     Cc: stable@vger.kernel.org
> > > >     Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> > > >     Tested-by: Laurence Oberman <loberman@redhat.com>
> > > >     Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > >     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > 
> > > The problem is that multipath_clone_and_map() is now treated as common
> > > code (thanks to both blk-mq and old .request_fn now enjoying the use of
> > > blk_get_request) BUT: Ming please understand that this code is used by
> > > old .request_fn too.  So it would seem that the use of
> > 
> > Hi Mike,
> > 
> > OK, thanks for pointing this out.
> > 
> > > DM_MAPIO_DELAY_REQUEUE vs DM_MAPIO_REQUEUE needs to be based on dm-sq vs
> > > dm-mq.
> > 
> > Yeah, just forget that dm-mq can't work on underlying queue which is
> > block legacy path, also forget the exact reason, :-(
> 
> Not sure how that detail is relevant to your patch?
> 
> But here are the 2 patches I posted as RFC to eliminate the restriction:
> https://patchwork.kernel.org/patch/9839565/
> https://patchwork.kernel.org/patch/9839567/

Thanks for the posting.

> 
> In the end I'm not too interested in supporting blk-mq multipath ontop
> of block legacy path.  But I'd revisit if hch or someone else posted the
> blk-mq patch that "removed the ->complete handler" (as hch mentions in
> the thread of the first patchwork patch I reference above).

If blk-mq mpath can be ontop of both block legacy and blk-mq,
the legacy .request_fn can be removed from dm mpath, that can
be a big simplification, especially the global parameter of
use_blk_mq may exist for a bit long.

-- 
Ming
