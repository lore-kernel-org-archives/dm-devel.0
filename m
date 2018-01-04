From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 1/5] block: establish request failover
 callback
Date: Thu, 4 Jan 2018 09:42:19 -0500
Message-ID: <20180104144219.GB13288@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20171227032257.8182-2-snitzer@redhat.com>
 <20171229101013.GA25333@lst.de>
 <20171229201904.GA8876@redhat.com>
 <20180104102844.GB4864@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104102844.GB4864@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Thu, Jan 04 2018 at  5:28am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Dec 29, 2017 at 03:19:04PM -0500, Mike Snitzer wrote:
> > On Fri, Dec 29 2017 at  5:10am -0500,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Tue, Dec 26, 2017 at 10:22:53PM -0500, Mike Snitzer wrote:
> > > > All requests allocated from a request_queue with this callback set can
> > > > failover their requests during completion.
> > > > 
> > > > This callback is expected to use the blk_steal_bios() interface to
> > > > transfer a request's bios back to an upper-layer bio-based
> > > > request_queue.
> > > > 
> > > > This will be used by both NVMe multipath and DM multipath.  Without it
> > > > DM multipath cannot get access to NVMe-specific error handling that NVMe
> > > > core provides in nvme_complete_rq().
> > > 
> > > And the whole point is that it should not get any such access.
> > 
> > No the whole point is you hijacked multipathing for little to no gain.
> 
> That is your idea.  In the end there have been a lot of complains about
> dm-multipath, and there was a lot of discussion how to do things better,
> with a broad agreement on this approach.  Up to the point where Hannes
> has started considering doing something similar for scsi.

All the "DM multipath" complaints I heard at LSF were fixable and pretty
superficial.  Some less so, but Hannes had a vision for addressing
various SCSI stuff (which really complicated DM multipath).

But I'd really rather not dwell on all the history of NVMe native
multipathing's evolution.  It isn't productive (other than to
acknowledge that there are far more efficient and productive ways to
coordinate such a change).

> And to be honest if this is the tone you'd like to set for technical
> discussions I'm not really interested.  Please calm down and stick
> to a technical discussion.

I think you'd probably agree that you've repeatedly derailed or avoided
technical discussion if it got into "DM multipath".  But again I'm not
looking to dwell on how dysfunctional this has been.  I really do
appreciate your technical expertise.  Sadly, cannot say I feel you think
similarly of me.

I will say that I'm human, as such I have limits on what I'm willing to
accept.  You leveraged your position to the point where it has started
to feel like you were lording over me.  Tough to accept that.   It makes
my job _really_ feel like "work".  All I've ever been trying to do
(since accepting the reality of "NVMe native multipathing") is bridge
the gap from the old solution to new solution.  I'm not opposed to the
new solution, it just needs to mature without being the _only_ way to
provide the feature (NVMe multipathing).  Hopefully we can be productive
exchanges moving forward.

There are certainly some challenges associated with trying to allow a
kernel to support both NVMe native multipathing and DM multipathing.
E.g. would an NVMe device scan multipath blacklist be doable/acceptable?

I'd also like to understand if your vision for NVMe's ANA support will
model something like scsi_dh?  Meaning ANA is a capability that, when
attached, augments the behavior of the NVMe device but that it is
otherwise internal to the device and upper layers will get the benefit
of ANA handler being attached.  Also, curious to know if you see that as
needing to be tightly coupled to multipathing?  If so that is the next
interface point hurdle.

In the end I really think that DM multipath can help make NVMe native
multipath very robust (and vice-versa).

Mike
