From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/14] block: Add bio_clone_kmalloc()
Date: Thu, 24 May 2012 17:31:14 -0700
Message-ID: <20120525003114.GF22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-5-git-send-email-koverstreet@google.com>
 <20120524185919.GE27550@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120524185919.GE27550-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 02:59:19PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:41PM -0700, Kent Overstreet wrote:
> 
> [..]
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 013c7a5..5a953c6 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
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
> >  			*next = &bp->bio2;
> 
> Is this code correct. Now original code might clone bio after split and
> new code will clone the original bio itself and not the split one?

Argh, you're right, I screwed that up.

I'd like to get rid of all the open coded bio_clone()s out there (to
reduce the amount of code that "Only clone bio vecs that are in use" has
to change, but this code is too tricky - I'm just going to drop this
bit.
