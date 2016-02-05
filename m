From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Fri, 5 Feb 2016 14:19:10 -0500
Message-ID: <20160205191909.GA25982@redhat.com>
References: <20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160205180515.GA25808@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Fri, Feb 05 2016 at  1:05pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Feb 05 2016 at 10:13am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  
> > Following is RFC because it really speaks to dm-mq _needing_ a variant
> > of blk_mq_complete_request() that supports partial completions.  Not
> > supporting partial completions really isn't an option for DM multipath.
> > 
> > From: Mike Snitzer <snitzer@redhat.com>
> > Date: Fri, 5 Feb 2016 08:49:01 -0500
> > Subject: [RFC PATCH] dm: fix excessive dm-mq context switching
> > 
> > Request-based DM's blk-mq support (dm-mq) was reported to be 50% slower
> > than if an underlying null_blk device were used directly.  This biggest
> > reason for this drop in performance is that blk_insert_clone_request()
> > was calling blk_mq_insert_request() with @async=true.  This forced the
> > use of kblockd_schedule_delayed_work_on() to run the queues which
> > ushered in ping-ponging between process context (fio in this case) and
> > kblockd's kworker to submit the cloned request.  The ftrace
> > function_graph tracer showed:
> > 
> >   kworker-2013  =>   fio-12190
> >   fio-12190    =>  kworker-2013
> >   ...
> >   kworker-2013  =>   fio-12190
> >   fio-12190    =>  kworker-2013
> >   ...
> > 
> > Fixing blk_mq_insert_request() to _not_ use kblockd to submit the cloned
> > requests isn't enough to fix eliminated the oberved context switches.
> > 
> > In addition to this dm-mq specific blk-core fix, there were 2 DM core
> > fixes to dm-mq that (when paired with the blk-core fix) completely
> > eliminate the observed context switching:
> > 
> > 1)  don't blk_mq_run_hw_queues in blk-mq request completion
> > 
> >     Motivated by desire to reduce overhead of dm-mq, punting to kblockd
> >     just increases context switches.
> > 
> >     In my testing against a really fast null_blk device there was no benefit
> >     to running blk_mq_run_hw_queues() on completion (and no other blk-mq
> >     driver does this).  So hopefully this change doesn't induce the need for
> >     yet another revert like commit 621739b00e16ca2d !
> > 
> > 2)  use blk_mq_complete_request() in dm_complete_request()
> > 
> >     blk_complete_request() doesn't offer the traditional q->mq_ops vs
> >     .request_fn branching pattern that other historic block interfaces
> >     do (e.g. blk_get_request).  Using blk_mq_complete_request() for
> >     blk-mq requests is important for performance but it doesn't handle
> >     partial completions -- which is a pretty big problem given the
> >     potential for partial completions with DM multipath due to path
> >     failure(s).  As such this makes this entire patch only RFC-worthy.
> 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index c683f6d..a618477 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1344,7 +1340,10 @@ static void dm_complete_request(struct request *rq, int error)
> >  	struct dm_rq_target_io *tio = tio_from_request(rq);
> >  
> >  	tio->error = error;
> > -	blk_complete_request(rq);
> > +	if (!rq->q->mq_ops)
> > +		blk_complete_request(rq);
> > +	else
> > +		blk_mq_complete_request(rq, rq->errors);
> >  }
> >  
> >  /*
> 
> Looking closer, DM is very likely OK just using blk_mq_complete_request.
> 
> blk_complete_request() also doesn't provide native partial completion
> support (it relies on the driver to do it, which DM core does):
> 
> /**
>  * blk_complete_request - end I/O on a request
>  * @req:      the request being processed
>  *
>  * Description:
>  *     Ends all I/O on a request. It does not handle partial completions,
>  *     unless the driver actually implements this in its completion callback
>  *     through requeueing. The actual completion happens out-of-order,
>  *     through a softirq handler. The user must have registered a completion
>  *     callback through blk_queue_softirq_done().
>  **/
> 
> blk_mq_complete_request() is effectively implemented in a comparable
> fashion to blk_complete_request().  Given that DM core is providing
> partial completion support by dm.c:end_clone_bio() triggering requeueing
> of the request via dm-mpath.c:multipath_end_io()'s return of
> DM_ENDIO_REQUEUE.
> 
> So I'm thinking I can drop the "RFC" for this patch and run with
> it.. once I get Jens' feedback (hopefully) confirming my understanding.
> 
> Jens, please advise.  If you're comfortable providing your Acked-by I
> can get this fix in for 4.5-rc4 or so...

FYI, here is the latest revised patch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=a5b835282422ec41991c1dbdb88daa4af7d166d2

(revised patch header and fixed a thinko in the dm.c:rq_completed()
change from the RFC patch I posted earlier)
