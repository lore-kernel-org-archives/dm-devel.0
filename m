From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.16 PATCH v2 1/5] block: establish request failover
        callback
Date: Thu, 4 Jan 2018 11:28:44 +0100
Message-ID: <20180104102844.GB4864@lst.de>
References: <20171227032257.8182-1-snitzer@redhat.com> <20171227032257.8182-2-snitzer@redhat.com> <20171229101013.GA25333@lst.de> <20171229201904.GA8876@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171229201904.GA8876@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Fri, Dec 29, 2017 at 03:19:04PM -0500, Mike Snitzer wrote:
> On Fri, Dec 29 2017 at  5:10am -0500,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Tue, Dec 26, 2017 at 10:22:53PM -0500, Mike Snitzer wrote:
> > > All requests allocated from a request_queue with this callback set can
> > > failover their requests during completion.
> > > 
> > > This callback is expected to use the blk_steal_bios() interface to
> > > transfer a request's bios back to an upper-layer bio-based
> > > request_queue.
> > > 
> > > This will be used by both NVMe multipath and DM multipath.  Without it
> > > DM multipath cannot get access to NVMe-specific error handling that NVMe
> > > core provides in nvme_complete_rq().
> > 
> > And the whole point is that it should not get any such access.
> 
> No the whole point is you hijacked multipathing for little to no gain.

That is your idea.  In the end there have been a lot of complains about
dm-multipath, and there was a lot of discussion how to do things better,
with a broad agreement on this approach.  Up to the point where Hannes
has started considering doing something similar for scsi.

And to be honest if this is the tone you'd like to set for technical
discussions I'm not really interested.  Please calm down and stick
to a technical discussion.
