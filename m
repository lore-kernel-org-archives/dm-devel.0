From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: dm-mpath request merging concerns [was: Re: It's
 time to put together the schedule]
Date: Mon, 23 Feb 2015 15:19:18 -0600
Message-ID: <20150223211918.GW11463@ask-08.lab.msp.redhat.com>
References: <1424395745.2603.27.camel@HansenPartnership.com>
	<54EAD453.6040907@suse.de> <20150223135057.GA3362@redhat.com>
	<54EB60EC.6080706@cs.wisc.edu>
	<20150223183422.GU11463@ask-08.lab.msp.redhat.com>
	<20150223195603.GB4693@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150223195603.GB4693@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: lsf@lists.linux-foundation.org, axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 23, 2015 at 02:56:03PM -0500, Mike Snitzer wrote:
> On Mon, Feb 23 2015 at  1:34pm -0500,
> Benjamin Marzinski <bmarzins@redhat.com> wrote:
> 
> > On Mon, Feb 23, 2015 at 11:18:36AM -0600, Mike Christie wrote:
> > > 
> > > If the device/transport is fast or the workload is low, the multipath_busy
> > > never returns busy, then we can hit Hannes's issue. For 4 paths, we just
> > > might not be able to fill up the paths and hit the busy check. With only 2
> > > paths, we might be slow enough or the workload is heavy enough to keep the
> > > paths busy and so we hit the busy check and do more merging.
> > 
> > Netapp is seeing this same issue.  It seems like we might want to make
> > multipath_busy more aggressive about returning busy, which would
> > probably require multipath tracking the size and frequency of the
> > requests.  If it determines that it's getting a lot of requests that
> > could have been merged, it could start throttling how fast requests are
> > getting pulled off the queue, even there underlying paths aren't busy.
> 
> the ->busy() checks are just an extra check the shouldn't be the primary
> method for governing the effectiveness of the DM-mpath queue's elevator.
> 
> I need to get back to basics to appreciate how the existing block layer
> is able to have an effective elevator regardless of the device's speed.
> And why isn't request-based DM able to just take advantage of it?

I always thought that at least one of the schedulers always kept
incoming requests on an interal queue for at least a little bit to see
if any merging could happen, even if they could otherwise just be added
to the request queue. but I admit to being a little vague on how exactly
they all work.

Another place where we could break out of constantly pulling requests of
the queue before they're merged is in dm_prep_fn().  If we thought that
we should break and let merging happen, we could return BLKPREP_DEFER.

-Ben

> 
> (my money is on request-based DM being overly clever but we'll see)
