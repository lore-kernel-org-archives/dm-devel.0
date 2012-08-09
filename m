From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
Date: Wed, 8 Aug 2012 23:00:19 -0700
Message-ID: <20120809060019.GA2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-4-git-send-email-koverstreet@google.com>
 <20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809000711.GB7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809000711.GB7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Wed, Aug 08, 2012 at 05:07:11PM -0700, Kent Overstreet wrote:
> > > +void bio_reset(struct bio *bio)
> > > +{
> > > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > 
> > How many flags are we talking about?  If there aren't too many, I'd
> > prefer explicit BIO_FLAGS_PRESERVED or whatever.
> 
> It mostly isn't actual flags that are preserved - the high bits of the
> flags are used for indicating what slab the bvec was allocated from, and
> that's the main thing that has to be preserved.
> 
> So that's why I went with defining the things that are reset instead of
> the things that are preserved.
> 
> I would prefer if bitfields were used for at least BIO_POOL_IDX, but the
> problem is flags is used as an atomic bit vector for BIO_UPTODATE.
> 
> But flags isn't treated as an atomic bit vector elsewhere -
> bio_flagged() doesn't use test_bit(), and flags are set/cleared with

Not using test_bit() may not be necessarily wrong.

> atomic bit operations in some places but not in others (probably _most_
> of them are technically safe, but... ick).

Mixing atomic and non-atomic modifications is almost always wrong tho.

Anyways, understood.  Can you *please* put some comment what bits are
being preserved across reset then?  Things like this aren't obvious at
all and need ample explanation.

Thanks.

-- 
tejun
