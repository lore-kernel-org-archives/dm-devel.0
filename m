From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath request merging concerns [was: Re: It's
 time to put together the schedule]
Date: Mon, 23 Feb 2015 19:39:00 -0500
Message-ID: <20150224003900.GA6421@redhat.com>
References: <1424395745.2603.27.camel@HansenPartnership.com>
	<54EAD453.6040907@suse.de> <20150223135057.GA3362@redhat.com>
	<54EB60EC.6080706@cs.wisc.edu>
	<20150223183422.GU11463@ask-08.lab.msp.redhat.com>
	<20150223195603.GB4693@redhat.com>
	<20150223211918.GW11463@ask-08.lab.msp.redhat.com>
	<20150223224637.GB5503@redhat.com>
	<20150223221438.GX11463@ask-08.lab.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150223221438.GX11463@ask-08.lab.msp.redhat.com>
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

On Mon, Feb 23 2015 at  5:14pm -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Mon, Feb 23, 2015 at 05:46:37PM -0500, Mike Snitzer wrote:
> > 
> > It is blk_queue_bio(), via q->make_request_fn, that is intended to
> > actually do the merging.  What I'm hearing is that we're only getting
> > some small amount of merging if:
> > 1) the 2 path case is used and therefore ->busy hook within
> >    q->request_fn is not taking the request off the queue, so there is
> >    more potential for later merging
> > 2) the 4 path case IFF nr_requests is reduced to induce ->busy, which
> >    only promoted merging as a side-effect like 1) above
> > 
> > The reality is we aren't getting merging where it _should_ be happening
> > (in blk_queue_bio).  We need to understand why that is.
> 
> Huh? I'm confused.  If the merges that are happening (which are more
> likely if either of those two points you mentioned are true) aren't
> happening in blk_queue_bio, then where are they happening?

AFAICT, purely from this discussion and NetApp's BZ, the little merging
that is seen is happening by the ->lld_busy_fn hook.  See the comment
block above blk_lld_busy().
 
> I thought that the issue is that requests are getting pulled off the
> multipath device's request queue and placed on the underlying device's
> request queue too quickly, so that there are no requests on multipth's
> queue to merge with when blk_queue_bio() is called.  In this case, one
> solution would involve keeping multipath from removing these requests
> too quickly when we think that it is likely that another request which
> can get merged will be added soon. That's what all my ideas have been
> about.
> 
> Do you think something different is happening here? 

Requests are being pulled from the DM-multipath's queue if
->lld_busy_fn() is false.  Too quickly is all relative.  The case NetApp
reported is with SSD devices in the backend.  Any increased idling in
the interest of merging could hurt latency; but the merging may improve
IOPS.  So it is trade-off.

So what I said before and am still saying is: we need to understand why
the designed hook for merging, via q->make_request_fn's blk_queue_bio(),
isn't actually meaningful for DM multipath.

Merging should happen _before_ q->request_fn() is called.  Not as a
side-effect of q->request_fn() happening to have intelligence to not
start the request because the underlying device queues are busy.
