From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH 0/5] block, nvme, dm: allow DM multipath to use
 NVMe's error handler
Date: Tue, 26 Dec 2017 21:42:44 -0500
Message-ID: <20171227024244.GA24011@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
 <20171226205109.GB13188@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171226205109.GB13188@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 26 2017 at  3:51pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Tue, Dec 19, 2017 at 04:05:41PM -0500, Mike Snitzer wrote:
> > These patches enable DM multipath to work well on NVMe over Fabrics
> > devices.  Currently that implies CONFIG_NVME_MULTIPATH is _not_ set.
> > 
> > But follow-on work will be to make it so that native NVMe multipath
> > and DM multipath can be made to co-exist (e.g. blacklisting certain
> > NVMe devices from being consumed by native NVMe multipath?)
> 
> Hi Mike,
> 
> I've reviewed the series and I support with the goal. I'm not a big fan,
> though, of having yet-another-field to set in bio and req on each IO.

Yeah, I knew they'd be the primary sticking point for this patchset.
I'm not loving the need to carry the function pointer around either.

> Unless I'm missing something, I think we can make this simpler if you add
> the new 'failover_req_fn' as an attribute of the struct request_queue
> instead of threading it through bio and request. Native nvme multipath
> can set the field directly in the nvme driver, and dm-mpath can set it
> in each path when not using the nvme mpath. What do you think?

I initially didn't like the gotchas associated [1], but I worked through
them.

I'll post v2 after some testing.

Thanks,
Mike

[1]:
With DM multipath, it is easy to reliably establish the function
pointer.  But clearing it on teardown is awkward.. because another DM
multipath table may have already taken a reference on the device (as
could happen when reloading the multipath table associated with the DM
multipath device).  You are left with a scenario where a new table load 
would set it, but teardown wouldn't easily know if it should be cleared.
And not clearing it could easily lead to dereferencing stale memory
(if/when DM multipath driver were unloaded yet NVMe request_queue
outliving it).
