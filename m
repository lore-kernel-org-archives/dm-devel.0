From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath request merging concerns [was: Re: It's
 time to put together the schedule]
Date: Tue, 24 Feb 2015 09:59:41 -0500
Message-ID: <20150224145941.GA10255@redhat.com>
References: <54EB60EC.6080706@cs.wisc.edu>
	<20150223183422.GU11463@ask-08.lab.msp.redhat.com>
	<20150223195603.GB4693@redhat.com>
	<20150223211918.GW11463@ask-08.lab.msp.redhat.com>
	<20150223224637.GB5503@redhat.com>
	<20150223221438.GX11463@ask-08.lab.msp.redhat.com>
	<20150224003900.GA6421@redhat.com>
	<20150224003816.GY11463@ask-08.lab.msp.redhat.com>
	<20150224020231.GA6761@redhat.com>
	<x49k2z7l6mg.fsf@segfault.boston.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <x49k2z7l6mg.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: lsf@lists.linux-foundation.org, axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 24 2015 at  9:35am -0500,
Jeff Moyer <jmoyer@redhat.com> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > Jens and/or Jeff Moyer, are there any knobs that you'd suggest to try to
> > promote request merging on a really fast block device?  Any scheduler
> > and knobs you'd suggest would be appreciated.
> 
> There's a small chance that CFQ does what you want.  It has logic to
> detect when multiple processes are submitting interleaved I/O, and it
> will try to wait until requests are merged before dispatching (see
> the comment in cfq_rq_enqueued).

That comment wasn't overly insightful on CFQ's ability to wait for
merging when IO is being submitted larger than a page size to begin
with.  Why will it "immediately let it rip" if the request is only just
larger than a single page?  Seems we'd like that threshold to be higher
depending on the workload (would it be wrong to make it tunable?).
Maybe it is a perfectly fine heuristic as is and I'm just missing it?

FYI, CFQ didn't work any better for NetApp when they tested it last
night; but they likely didn't set rotational.

> Aside from that, make sure /sys/block/<dev>/queue/rotational is set to 1.

Fair point (albeit unintuitive to the user who has an SSD backend).

I'll see if NetApp can re-test CFQ with rotational set.
