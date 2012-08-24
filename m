From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 13/13] block: Only clone bio vecs that are in use
Date: Fri, 24 Aug 2012 13:42:16 -0700
Message-ID: <20120824204216.GH21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-14-git-send-email-koverstreet@google.com>
 <20120822211045.GN19212@google.com>
 <20120824070508.GE11977@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120824070508.GE11977-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
List-Id: dm-devel.ids

Hello, Kent.

On Fri, Aug 24, 2012 at 12:05:08AM -0700, Kent Overstreet wrote:
> > I'm pretty sure I sound like a broken record by now, but
> > 
> > * How was this tested?
> > 
> > * What are the implications and possible dangers?
> 
> I've said all that on list, but I gather what you really wanted was to
> have it all in the patch description. Will do.

Yeap.

> > > @@ -463,10 +468,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
> > >  	bio->bi_sector = bio_src->bi_sector;
> > >  	bio->bi_bdev = bio_src->bi_bdev;
> > >  	bio->bi_flags |= 1 << BIO_CLONED;
> > > +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> > 
> > For the n'th time, explain please.
> 
> Argh, I could've sworn I dropped that part.

Can we drop it tho?  If we're changing bvecs, we probably should be
clearing SEG_VALID on both bios.

> commit 0edda563aef9432b45f0c6a50f52590b92594560
> Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Date:   Thu Aug 23 23:26:38 2012 -0700
> 
>     block: Only clone bio vecs that are in use
>     
>     bcache creates large bios internally, and then splits them according to
>     the device requirements before it sends them down. If a lower level
>     device tries to clone the bio, and the original bio had more than
>     BIO_MAX_PAGES, the clone will fail unecessarily.
>     
>     We can fix this by only cloning the bio vecs that are actually in use -
>     as for as the block layer is concerned the new bio is still equivalent
>     to the old bio.
>     
>     This code should in general be safe as long as all the block layer code
>     uses bi_idx, bi_vcnt consistently; since bios are cloned by code that
>     doesn't own the original bio there's little room for issues caused by
>     code playing games with the original bio's bi_io_vec. One perhaps
>     imagine code depending the clone and original bio's io vecs lining up a
>     certain way, but auditing and testing haven't turned up anything.
>     
>     Testing: This code has been in the bcache tree for quite awhile, and has
>     been tested with various md layers and dm targets (including strange
>     things like multipath).

Yeap, looks much better to me.

Thanks.

-- 
tejun
