From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/13] block: Add bio_clone_kmalloc()
Date: Fri, 18 May 2012 13:39:32 -0700
Message-ID: <20120518203932.GD9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
 <20120518160903.GD19388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120518160903.GD19388-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 09:09:03AM -0700, Tejun Heo wrote:
> On Thu, May 17, 2012 at 10:59:51PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
> > @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
> >  	}
> >  
> >  	while (old_chain && (total < len)) {
> > -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> > +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
> >  		if (!tmp)
> >  			goto err_out;
> >  
> > @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
> >  			if (!bp)
> >  				goto err_out;
> >  
> > -			__bio_clone(tmp, &bp->bio1);
> > -
> 
> This effectively swaps the order of bio_split() and __bio_clone().  Is
> that safe?  Also, please cc the maintainer.

Now that I look at that code some more, I'm not sure it was quite right
before - that or I don't follow how it's supposed to work.

That bio_split() effectively does its own clone, so it seems to me the
bio_kmalloc()/bio_clone_kmalloc() should only be happening in the non
split case.

Also, there's a bio_chain_clone in drivers/block/osdblk.c that looks
like it's doing something similar, probably we should have some generic
code for this.
