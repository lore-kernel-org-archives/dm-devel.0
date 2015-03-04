From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/8] dm: don't start current request if it
 would've merged with the previous
Date: Wed, 4 Mar 2015 12:26:44 -0500
Message-ID: <20150304172644.GA14594@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
	<1425430031-78140-7-git-send-email-snitzer@redhat.com>
	<54F6A7D4.8040806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54F6A7D4.8040806@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 04 2015 at  1:36am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 03/04/2015 01:47 AM, Mike Snitzer wrote:
> > Request-based DM's dm_request_fn() is so fast to pull requests off the
> > queue that steps need to be taken to promote merging by avoiding request
> > processing if it makes sense.
> > 
> > If the current request would've merged with previous request let the
> > current request stay on the queue longer.
> > 
> > Suggested-by: Jens Axboe <axboe@fb.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index c13477a..3242f4c 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1927,6 +1932,9 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
> >  	blk_start_request(orig);
> >  	atomic_inc(&md->pending[rq_data_dir(orig)]);
> >  
> > +	md->last_rq_pos = rq_end_sector(orig);
> > +	md->last_rq_rw = rq_data_dir(orig);
> > +
> >  	/*
> >  	 * Hold the md reference here for the in-flight I/O.
> >  	 * We can't rely on the reference count by device opener,
> > @@ -1979,6 +1987,10 @@ static void dm_request_fn(struct request_queue *q)
> >  			continue;
> >  		}
> >  
> > +		if (md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
> > +		    md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq))
> > +			goto delay_and_out;
> > +
> >  		if (ti->type->busy && ti->type->busy(ti))
> >  			goto delay_and_out;
> >  
> > 
> That's one of the things I'm slightly uneasy with.
> 
> It essentially means we're out-guessing the I/O scheduler here, and
> assume that _any_ scheduler will be merging requests which are aligned.
> While this is apparently true for the existing schedulers, is this a
> requirement for any I/O scheduler?

I'm not too interested in predicting the future of IO schedulers.  ALl
existing IO schedulers at least provide merging (noop included); and
Jens said that even blk-mq provides merging (I've yet to explore that
though).

But yes, needing to second-guess whether the block layer is hurting
throughput by dispatching requests is unfortunate.  Ultimately the
heuristic used here _could_ (should?) be elevated into the block core.
Jens already said that blk-mq will suffer from this same problem (the
queue will be kicked so fast that the window of opportunity to merge
becomes non-existent).

> I"ll probably show my ignorance here, but why can we even pull these
> requests off the request queue?
> _Especially_ as they'll be merged with another bio/request just a few us
> later?

dm_request_fn() hasn't pulled the request off the queue at the time the
above heuristic is used.  It is actually determing whether it best to
leave the request in question on the queue (where it is currently).  It
isn't until blk_start_request() that the request is taken off the queue
(via blk_dequeue_request).

> Nevertheless, thank you Mike for these patches. They helped a lot.

No problem, I'm still exploring how we might _efficiently_ autotune this
parameter.  Certainly not an easy problem.  But given this is to be
paired with multipath the performance profile can change as paths come
and go (Netapp found with 4 paths using ~10us is best, with 2 paths
using ~25us is ideal).  So it would seem a fixed deadline only gets us
so far.

That said, this is a bit of a unique problem in that the Netapp backend
is IOPS bound.  Other hardware could easily have a similar constraint;
it is this constraint that makes this problem somewhat illusive (at
least in terms of a "simple" yet complete solution).
