From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Date: Tue, 2 Oct 2012 18:02:16 -0400
Message-ID: <20121002220216.GC14471@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002153736.GA3283@redhat.com>
 <20121002210006.GS26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002210006.GS26488-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 02:00:06PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 11:37:37AM -0400, Vivek Goyal wrote:
> > On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > 
> > [..]
> > >  /**
> > >   * bio_integrity_alloc - Allocate integrity payload and attach it to bio
> > >   * @bio:	bio to attach integrity metadata to
> > > @@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
> > >  						  unsigned int nr_vecs)
> > >  {
> > >  	struct bio_integrity_payload *bip;
> > > -	unsigned int idx = vecs_to_idx(nr_vecs);
> > >  	struct bio_set *bs = bio->bi_pool;
> > > +	unsigned long idx = BIO_POOL_NONE;
> > > +	unsigned inline_vecs;
> > > +
> > > +	if (!bs) {
> > > +		bip = kmalloc(sizeof(struct bio_integrity_payload) +
> > > +			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
> > > +		inline_vecs = nr_vecs;
> > > +	} else {
> > > +		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> > > +		inline_vecs = BIP_INLINE_VECS;
> > > +	}
> > >  
> > > -	if (!bs)
> > > -		bs = fs_bio_set;
> > 
> > Ok, this is change of behavior. Previously we will fall back to fs_bio_set
> > and now you do kmalloc. This change looks to be independent of bip_vec
> > pointer. Can you please break it out in a separate patch and also explain
> > that how does this change help.
> 
> I'm not sure it's worth breaking out into a separate patch, but I
> definitely should've mentioned it in the patch description.

It helps a lot with reviewing the patches. 
> 
> It just didn't make sense to be using fs_bio_set if a bio_set wasn't
> specified before - if a bio set wasn't specified we're still using
> kmalloc for the bio_integrity_payload, so we're not protected from
> memory allocation failures and it doesn't buy us anything.
> 
> All it does is introduce the possibility of deadlock, if we weren't
> supposed to be using fs_bio_set for whatever reason.

I think more people will be willing to review patches if you break
them down in to small patches with proper explanation. This particular
change is orthogonal to allocating integrity vecs from bioset. So
really think it does make sense to keep this change in a separate
patch with proper changelog.

Thanks
Vivek
