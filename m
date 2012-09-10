From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Mon, 10 Sep 2012 10:22:10 -0700
Message-ID: <20120910172210.GC14103@google.com>
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
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Sun, Sep 09, 2012 at 05:28:10PM -0700, Kent Overstreet wrote:
> > > +	while ((bio = bio_list_pop(current->bio_list)))
> > > +		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> > > +
> > > +	*current->bio_list = nopunt;
> > 
> > Why this is necessary needs explanation and it's done in rather
> > unusual way.  I suppose the weirdness is from bio_list API
> > restriction?
> 
> It's because bio_lists are singly linked, so deleting an entry from the
> middle of the list would be a real pain - just much cleaner/simpler to
> do it this way.

Yeah, I wonder how benefical that singly linked list is.  Eh well...

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

I don't know.  That at least represents what's going on and goto'ing
back and forth is hardly pretty.  Sometimes the code gets much uglier
/ unwieldy and we have to live with gotos.  Here, that doesn't seem to
be the case.

> +static void punt_bios_to_rescuer(struct bio_set *bs)
> +{
> +	struct bio_list punt, nopunt;
> +	struct bio *bio;
> +
> +	/*
> +	 * Don't want to punt all bios on current->bio_list; if there was a bio
> +	 * on there for a stacking driver higher up in the stack, processing it
> +	 * could require allocating bios from this bio_set, and we don't want to
> +	 * do that from our own rescuer.

Hmmm... isn't it more like we "must" process only the bios which are
from this bio_set to have any kind of forward-progress guarantee?  The
above sounds like it's just something undesirable.

Thanks.

-- 
tejun
