From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 06/13] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Date: Fri, 24 Aug 2012 13:08:35 -0700
Message-ID: <20120824200835.GD21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-7-git-send-email-koverstreet@google.com>
 <20120822201730.GI19212@google.com>
 <20120824050400.GA11977@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120824050400.GA11977-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Thu, Aug 23, 2012 at 10:04:00PM -0700, Kent Overstreet wrote:
> > >  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> > >  {
> > > +	unsigned front_pad;
> > > +	unsigned inline_vecs;
> > >  	unsigned long idx = BIO_POOL_NONE;
> > >  	struct bio_vec *bvl = NULL;
> > >  	struct bio *bio;
> > >  	void *p;
> > >  
> > > -	p = mempool_alloc(bs->bio_pool, gfp_mask);
> > > +	if (nr_iovecs > UIO_MAXIOV)
> > > +		return NULL;
> > 
> > This test used to only happen for bio_kmalloc().  If I follow the code
> > I can see that UIO_MAXIOV is larger than BIOVEC_MAX_IDX, so this
> > doesn't really affect the capability of bioset allocs; however, given
> > that bioset allocation already checks against BIOVEC_MAX_IDX, I don't
> > see why this test is now also applied to them.
> 
> Having arbitrary limits that are different for kmalloced bios and bioset
> allocated bios seems _very_ sketchy to me. I tend to think that
> UIO_MAXIOV check shouldn't be there at all... but if it is IMO it makes
> slightly more sense for it to apply to all bio allocations.
> 
> As you mentioned it doesn't affect the behaviour of the code, but
> supposing UIO_MAXIOV was less than BIO_MAX_PAGES, whatever was depending
> on that check would then implicitly depend on the bios not being
> allocated from a bioset. Ugly.

Please keep UIO_MAXIOV test on kmalloc case only.  If you want to
change that, please do that in a separate patch with its own
justification.

> > And we lose /** comments on two exported functions and
> > bio_alloc_bioset() comment doesn't explain that it now also handles
> > NULL bioset case.  Now that they share common implementation, you can
> > update bio_alloc_bioset() and refer to it from its wrappers but please
> > don't drop them like this.
> 
> So if I follow you, you're fine with dropping the comments from the
> single line wrappers provided their information is rolled into
> bio_alloc_bioset()'s documentation? That's what I should have done,
> I'll do that now.

Not really, for example, if you had

	/* explain A in detail */
	a() {};

and if you introduce __a() which does __A and make a its wrapper.

	/* explain __A in detail */
	__a() {};

	/* explain A briefly and refer to __a() for details */
	a() {};

Thanks.

-- 
tejun
