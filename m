From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Date: Tue, 2 Oct 2012 13:26:43 -0700
Message-ID: <20121002202643.GQ26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-2-git-send-email-koverstreet@google.com>
 <20121001212336.GA17165@redhat.com>
 <20121001214241.GE26488@google.com>
 <20121002140847.GD758@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002140847.GD758-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 10:08:47AM -0400, Vivek Goyal wrote:
> On Mon, Oct 01, 2012 at 02:42:41PM -0700, Kent Overstreet wrote:
> 
> [..]
> > Here's the new patch:
> > 
> > 
> > commit e270c9ca843b5c86d59431b0d7a676b7846946d6
> > Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Date:   Mon Oct 1 14:41:08 2012 -0700
> > 
> >     block: Fix a buffer overrun in bio_integrity_split()
> >     
> >     bio_integrity_split() seemed to be confusing pointers and arrays -
> >     bip_vec in bio_integrity_payload is an array appended to the end of the
> >     payload, so the bio_vecs in struct bio_pair need to come immediately
> >     after the bio_integrity_payload they're for, and there was an assignment
> >     in bio_integrity_split() that didn't make any sense.
> >     
> >     Also, changed bio_integrity_split() to not refer to the bvecs embedded
> >     in struct bio_pair, in case there's padding between them and
> >     bip->bip_vec.
> >     
> >     Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >     CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> >     CC: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > index a3f28f3..4ae22a8 100644
> > --- a/fs/bio-integrity.c
> > +++ b/fs/bio-integrity.c
> > @@ -694,15 +694,12 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> >  	bp->bio1.bi_integrity = &bp->bip1;
> >  	bp->bio2.bi_integrity = &bp->bip2;
> >  
> > -	bp->iv1 = bip->bip_vec[0];
> > -	bp->iv2 = bip->bip_vec[0];
> > +	*bp->bip1.bip_vec = bip->bip_vec[0];
> > +	*bp->bip2.bip_vec = bip->bip_vec[0];
> 
> I think this is horrible. Why not introduce bvec pointer in bip (like bio),
> to cover the case when bvec are not inline.

That's... exactly what the next patch in the series does.
