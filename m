From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 03/14] block: Add bio_clone_bioset()
Date: Thu, 24 May 2012 16:35:33 -0700
Message-ID: <20120524233532.GE22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-4-git-send-email-koverstreet@google.com>
 <20120524184507.GD27550@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120524184507.GD27550-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 02:45:07PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:40PM -0700, Kent Overstreet wrote:
> 
> [..]
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1062,26 +1062,19 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
> >   * Creates a bio that consists of range of complete bvecs.
> >   */
> >  static struct bio *clone_bio(struct bio *bio, sector_t sector,
> > -			     unsigned short idx, unsigned short bv_count,
> > +			     unsigned short bv_count,
> >  			     unsigned int len, struct bio_set *bs)
> >  {
> >  	struct bio *clone;
> >  
> > -	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> > -	__bio_clone(clone, bio);
> > +	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
> >  	clone->bi_sector = sector;
> > -	clone->bi_idx = idx;
> > -	clone->bi_vcnt = idx + bv_count;
> > +	clone->bi_vcnt = bv_count;
> 
> In last posting you said that you are going to backout this idx change
> because you were not sure if it is correct. 

Yeah, I distinctly remember doing that but clearly something got lost.
Sorry.

Anyways, that change shouldn't have been part of that patch, but
something has to change there for the "Only clone bio vecs that are in
use" patch.

Gonna take a stab at reworking that code, it really ought to be possible
to just replace it with my bio splitting code but the way dm is doing
the splitting is... confusing.
