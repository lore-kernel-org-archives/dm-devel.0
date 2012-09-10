From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Mon, 10 Sep 2012 11:25:08 -0400
Message-ID: <20120910152508.GD639@redhat.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120910002810.GA23241-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

On Sun, Sep 09, 2012 at 05:28:10PM -0700, Kent Overstreet wrote:

[..]
> > > +retry:
> > >  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> > >  		front_pad = bs->front_pad;
> > >  		inline_vecs = BIO_INLINE_VECS;
> > >  	}
> > 
> > Wouldn't the following be better?
> > 
> > 	p = mempool_alloc(bs->bi_pool, gfp_mask);
> > 	if (unlikely(!p) && gfp_mask != saved_gfp) {
> > 		punt_bios_to_rescuer(bs);
> > 		p = mempool_alloc(bs->bi_pool, saved_gfp);
> > 	}
> 
> That'd require duplicating the error handling in two different places -
> once for the initial allocation, once for the bvec allocation. And I
> really hate that writing code that does
> 
> alloc_something()
> if (fail) {
> 	alloc_something_again()
> }
> 
> it just screams ugly to me.

Personally I kind of like Tejun's suggestion. Yes, it means that you
will have to do it twice (once for bio and once for bvecs). But at
the same time, if bvec allocation fails, then you don't have to free
already allocated bio and retry bio allocation again.  Current code
is doing that and I am not sure why should we free allocated bio and
retry again in case of bvec allocation failure.

Secondly current code is doing following.

                if (unlikely(!bvl))
                        goto err_free;

err_free:
	mempool_free(p, bs->bio_pool);
err:
	retry_allocation.

Not sure but err_free kind of gives impression that free up whatever
is allocated path, and return NULL. Instead of we end up retrying
allocation.

Implementing Tejun's idea atleast keeps error and retry code separate.
I am not too particular about it. Just a thought. Though I do want to
know why to free up already allocated bio and retry in case of bvec
allocation failure.

Thanks
Vivek
