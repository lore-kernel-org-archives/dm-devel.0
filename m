From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
Date: Wed, 8 Aug 2012 17:07:11 -0700
Message-ID: <20120809000711.GB7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-4-git-send-email-koverstreet@google.com>
 <20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120808221129.GB6983-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 03:11:29PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:32PM -0700, Kent Overstreet wrote:
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> > was open coding it, by doing a bio_init() and resetting bi_destructor.
> > 
> > v5: Add a define BIO_RESET_BITS, to be very explicit about what parts of
> > bio->bi_flags are saved.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Change-Id: I4eb2975bd678d3be811d5423d0620b08020be9ff
> 
> Please drop Change-Id.  Die gerrit die.

Bah, missed that one. 

> > +void bio_reset(struct bio *bio)
> > +{
> > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> 
> How many flags are we talking about?  If there aren't too many, I'd
> prefer explicit BIO_FLAGS_PRESERVED or whatever.

It mostly isn't actual flags that are preserved - the high bits of the
flags are used for indicating what slab the bvec was allocated from, and
that's the main thing that has to be preserved.

So that's why I went with defining the things that are reset instead of
the things that are preserved.

I would prefer if bitfields were used for at least BIO_POOL_IDX, but the
problem is flags is used as an atomic bit vector for BIO_UPTODATE.

But flags isn't treated as an atomic bit vector elsewhere -
bio_flagged() doesn't use test_bit(), and flags are set/cleared with
atomic bit operations in some places but not in others (probably _most_
of them are technically safe, but... ick).

> 
> Thanks.
> 
> -- 
> tejun
