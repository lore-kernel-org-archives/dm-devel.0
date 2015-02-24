From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath request merging concerns [was: Re: It's
 time to put together the schedule]
Date: Mon, 23 Feb 2015 21:02:31 -0500
Message-ID: <20150224020231.GA6761@redhat.com>
References: <54EAD453.6040907@suse.de> <20150223135057.GA3362@redhat.com>
	<54EB60EC.6080706@cs.wisc.edu>
	<20150223183422.GU11463@ask-08.lab.msp.redhat.com>
	<20150223195603.GB4693@redhat.com>
	<20150223211918.GW11463@ask-08.lab.msp.redhat.com>
	<20150223224637.GB5503@redhat.com>
	<20150223221438.GX11463@ask-08.lab.msp.redhat.com>
	<20150224003900.GA6421@redhat.com>
	<20150224003816.GY11463@ask-08.lab.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150224003816.GY11463@ask-08.lab.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: lsf@lists.linux-foundation.org, axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 23 2015 at  7:38pm -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Mon, Feb 23, 2015 at 07:39:00PM -0500, Mike Snitzer wrote:
> > On Mon, Feb 23 2015 at  5:14pm -0500,
> > Benjamin Marzinski <bmarzins@redhat.com> wrote:
> > 
> > > On Mon, Feb 23, 2015 at 05:46:37PM -0500, Mike Snitzer wrote:
> > > > 
> > > > It is blk_queue_bio(), via q->make_request_fn, that is intended to
> > > > actually do the merging.  What I'm hearing is that we're only getting
> > > > some small amount of merging if:
> > > > 1) the 2 path case is used and therefore ->busy hook within
> > > >    q->request_fn is not taking the request off the queue, so there is
> > > >    more potential for later merging
> > > > 2) the 4 path case IFF nr_requests is reduced to induce ->busy, which
> > > >    only promoted merging as a side-effect like 1) above
> > > > 
> > > > The reality is we aren't getting merging where it _should_ be happening
> > > > (in blk_queue_bio).  We need to understand why that is.
> > > 
> > > Huh? I'm confused.  If the merges that are happening (which are more
> > > likely if either of those two points you mentioned are true) aren't
> > > happening in blk_queue_bio, then where are they happening?
> > 
> > AFAICT, purely from this discussion and NetApp's BZ, the little merging
> > that is seen is happening by the ->lld_busy_fn hook.  See the comment
> > block above blk_lld_busy().
> 
> Well, that function is what's causing dm_request_fn to stop pulling
> requests of the queue, through
> 
>                 if (ti->type->busy && ti->type->busy(ti))
>                         goto delay_and_out;
> 
> But all scsi_lld_busy (which is the request that eventually gets called
> to that signals that the queue is busy) does is check some flags and
> other values. The actual merging code is in blk_queue_bio(). 
> 
> >  
> > > I thought that the issue is that requests are getting pulled off the
> > > multipath device's request queue and placed on the underlying device's
> > > request queue too quickly, so that there are no requests on multipth's
> > > queue to merge with when blk_queue_bio() is called.  In this case, one
> > > solution would involve keeping multipath from removing these requests
> > > too quickly when we think that it is likely that another request which
> > > can get merged will be added soon. That's what all my ideas have been
> > > about.
> > > 
> > > Do you think something different is happening here? 
> > 
> > Requests are being pulled from the DM-multipath's queue if
> > ->lld_busy_fn() is false.  Too quickly is all relative.  The case NetApp
> > reported is with SSD devices in the backend.  Any increased idling in
> > the interest of merging could hurt latency; but the merging may improve
> > IOPS.  So it is trade-off.
> 
> I'm not at all sure that there's going to be a one-size-fits-all
> solution, and it is possible that for really fast devices, load balancing
> may end up being not all that useful.
> 
> > So what I said before and am still saying is: we need to understand why
> > the designed hook for merging, via q->make_request_fn's blk_queue_bio(),
> > isn't actually meaningful for DM multipath.
> > 
> > Merging should happen _before_ q->request_fn() is called.  Not as a
> > side-effect of q->request_fn() happening to have intelligence to not
> > start the request because the underlying device queues are busy.
> 
> The merging is happening before dm_request_fn, if there are any requests
> to actually merge with. If blk_queue_bio runs, and there are no requests
> left in the queue for the multipath deivce, then there is no chance
> of any merging happening, since there are no requests to merge with. The
> issue is that when there are multiple really fast paths under multipath,
> their queue never fills up and they always report that they aren't busy,
> which means the only thing that device-mapper has to do to the requests
> on its queue, is put them on the appropriate queue of the underlying
> device.  This doesn't take much time, and once it does this, no merging
> is done on the underlying device queues. So if the requests spend more
> of their time on the scsi device queues (where no merging happens) and
> very little of their time on the multipath queue, then there simply
> isn't time for merging to happen.  Merging in the underlying device
> queues won't really help matters, since multipath will be spreading out
> the requests among the various queues, so that contiguous requests won't
> often be sent to the same underlying device (that's the whole point of
> request-based multipath: doing the merging first, and then sending down
> fully merged requests).
> 
> What Netapp was seeing was single requests getting added to the
> multipath device queue, and then getting pulled off and added to the
> underlying device queue before another request could get added to the
> multipath request queue.
> 
> While I'm pretty sure that this is what's happening, I agree that making
> dm_request_fn quit early may not be the best solution.  I'm not sure why
> the queue is getting unplugged so quickly in the first place.  Perhaps
> we should understand that first. If we're not calling dm_request_fn so
> quickly, then we don't need to worry so much about stopping early.

Yeah we are in complete agreement on all this.  (And yes I dont think
adding AI to multipath or request-based DM to conditionally 

My only point about dm_request_fn was that the only reason merging is
happening in blk_queue_bio at all is because ->lld_busy_fn is true.
Ideally the IO would be submitted in batchs with a plug in place (that'd
allow for blk_queue_bio to be more effective).

NetApp's test is using vdbench to submit 4K sequential IO using 64
threads directly (O_DIRECT) to the multipath device (all those threads
makes it look random or at least seeky).  There really isn't a layer
(that I'm aware of) that'd know to start and stop a plug for that test.
A filesystem ontop might do better but I'm not sure.

But plugging aside, requests being dispatched too fast to allow for
merging is something that sounds odd to want.  Better to just submit
larger IOs to begin with.  BUT in the case of databases small (4K) IO is
the norm.  And it was Hannes' report about SAP that got this thread
started so...

Jens and/or Jeff Moyer, are there any knobs that you'd suggest to try to
promote request merging on a really fast block device?  Any scheduler
and knobs you'd suggest would be appreciated.

Short of that, I'm left scratching my head as to the best was to solve
this particular workload.
