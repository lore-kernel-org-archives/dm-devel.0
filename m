From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 1/5] block: establish request failover
 callback
Date: Fri, 29 Dec 2017 15:19:04 -0500
Message-ID: <20171229201904.GA8876@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20171227032257.8182-2-snitzer@redhat.com>
 <20171229101013.GA25333@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171229101013.GA25333@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 29 2017 at  5:10am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Dec 26, 2017 at 10:22:53PM -0500, Mike Snitzer wrote:
> > All requests allocated from a request_queue with this callback set can
> > failover their requests during completion.
> > 
> > This callback is expected to use the blk_steal_bios() interface to
> > transfer a request's bios back to an upper-layer bio-based
> > request_queue.
> > 
> > This will be used by both NVMe multipath and DM multipath.  Without it
> > DM multipath cannot get access to NVMe-specific error handling that NVMe
> > core provides in nvme_complete_rq().
> 
> And the whole point is that it should not get any such access.

No the whole point is you hijacked multipathing for little to no gain.

> The reason why we did nvme multipathing differently is because the
> design of dm-multipath inflicts so much pain on users that we absolutely
> want to avoid it this time around.

Is that the royal "we"?

_You_ are the one subjecting users to pain.  There is no reason users
should need to have multiple management domains for multipathing unless
they opt-in.  Linux _is_ about choice, yet you're working overtime to
limit that choice.

You are blatantly ignoring/rejecting both Hannes [1] and I.  Your
attempt to impose _how_ NVMe multipathing must be done is unacceptable.

Hopefully Jens can see through your senseless position and will accept
patches 1 - 3 for 4.16.  They offer very minimal change that enables
users to decide which multipathing they'd prefer to use with NVMe.

Just wish you could stop with this petty bullshit and actually
collaborate with people.

I've shown how easy it is to enable NVMe multipathing in terms of DM
multipath (yet preserve your native NVMe multipathing).  Please stop
being so dogmatic.  Are you scared of being proven wrong about what the
market wants?

If you'd allow progress toward native NVMe and DM multipathing
coexisting we'd let the users decide what they prefer.  I don't need to
impose one way or the other, but I _do_ need to preserve DM multipath
compatibility given the extensive use of DM multipath in the enterprise
and increased tooling that builds upon it.

[1] http://lists.infradead.org/pipermail/linux-nvme/2017-October/013719.html
