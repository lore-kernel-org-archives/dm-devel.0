From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Date: Tue, 2 Oct 2012 17:58:45 -0400
Message-ID: <20121002215845.GB14471@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-2-git-send-email-koverstreet@google.com>
 <20121001212336.GA17165@redhat.com>
 <20121001214241.GE26488@google.com>
 <20121002140847.GD758@redhat.com>
 <20121002202643.GQ26488@google.com>
 <20121002203253.GA14471@redhat.com>
 <20121002210143.GT26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002210143.GT26488-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 02:01:43PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 04:32:53PM -0400, Vivek Goyal wrote:
> > On Tue, Oct 02, 2012 at 01:26:43PM -0700, Kent Overstreet wrote:
> > > On Tue, Oct 02, 2012 at 10:08:47AM -0400, Vivek Goyal wrote:
> > > > On Mon, Oct 01, 2012 at 02:42:41PM -0700, Kent Overstreet wrote:
> > > > 
> > > > [..]
> > > > > Here's the new patch:
> > > > > 
> > > > > 
> > > > > commit e270c9ca843b5c86d59431b0d7a676b7846946d6
> > > > > Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > Date:   Mon Oct 1 14:41:08 2012 -0700
> > > > > 
> > > > >     block: Fix a buffer overrun in bio_integrity_split()
> > > > >     
> > > > >     bio_integrity_split() seemed to be confusing pointers and arrays -
> > > > >     bip_vec in bio_integrity_payload is an array appended to the end of the
> > > > >     payload, so the bio_vecs in struct bio_pair need to come immediately
> > > > >     after the bio_integrity_payload they're for, and there was an assignment
> > > > >     in bio_integrity_split() that didn't make any sense.
> > > > >     
> > > > >     Also, changed bio_integrity_split() to not refer to the bvecs embedded
> > > > >     in struct bio_pair, in case there's padding between them and
> > > > >     bip->bip_vec.
> > > > >     
> > > > >     Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > >     CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > > > >     CC: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > 
> > > > > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > > > > index a3f28f3..4ae22a8 100644
> > > > > --- a/fs/bio-integrity.c
> > > > > +++ b/fs/bio-integrity.c
> > > > > @@ -694,15 +694,12 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> > > > >  	bp->bio1.bi_integrity = &bp->bip1;
> > > > >  	bp->bio2.bi_integrity = &bp->bip2;
> > > > >  
> > > > > -	bp->iv1 = bip->bip_vec[0];
> > > > > -	bp->iv2 = bip->bip_vec[0];
> > > > > +	*bp->bip1.bip_vec = bip->bip_vec[0];
> > > > > +	*bp->bip2.bip_vec = bip->bip_vec[0];
> > > > 
> > > > I think this is horrible. Why not introduce bvec pointer in bip (like bio),
> > > > to cover the case when bvec are not inline.
> > > 
> > > That's... exactly what the next patch in the series does.
> > 
> > Yes, but if you want to push some of the these bug fixes in stable (as martin
> > had said), we need to introduce that bip->bio_vec pointer early. Also that
> > next patch is doing lot other other things like getting rid of bip_slabs
> > and we don't require all that to fix this particular bug.
> > 
> > In fact I would say that it is beter to fix this blk integrity bug in a
> > separate patchset so that it can be pushed out earlier.
> 
> I'm honestly not sure what your complaint about my bugfix patch was -
> it's small and complete, it does fix the bug. I don't follow why you
> think we need to introduce the bip->bio_vec pointer early...

I think having iv1 and iv2 and then not even accessing these using 
bp->iv1 and bp->iv2 is a bad idea even for bugfix.

I have never seen a code which says, hey I have defined two fields in a
struct but, don't access those fields directly(as there might be padding
issues). These fields are just there for blocking a chunk of memory but are
never meant to be accessed directly. I think, that's what my issue is. It
is bad programming (does not matter whether it is bug fix or not).

For your series it probably is still fine as you will overide it pretty
soon but what about stable. Anybody looking at that code might want
to say, hey why not directly initialize bp->iv1 instead of trying to
do *bp->bip1.bip_vec. And everybody will say, yes looks fine and boom
a bug is introduced because we did bad programming.

Thanks
Vivek
