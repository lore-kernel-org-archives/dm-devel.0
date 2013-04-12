From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: NULL pointer due to malformed bcache bio
Date: Fri, 12 Apr 2013 11:53:01 -0700
Message-ID: <20130412185301.GA31442@localhost>
References: <20130410205439.GA18092@redhat.com>
 <20130410224914.GD30871@google.com>
 <20130411000342.GA19451@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130411000342.GA19451-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Wed, Apr 10, 2013 at 08:03:42PM -0400, Mike Snitzer wrote:
> On Wed, Apr 10 2013 at  6:49pm -0400,
> Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, Apr 10, 2013 at 04:54:40PM -0400, Mike Snitzer wrote:
> > > Hey,
> > > 
> > > So DM core clearly needs to be more defensive about the possibility for
> > > a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
> > > in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
> > > bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).
> > > 
> > > Seems bcache should be using bio_get_nr_vecs() or something else?
> > > 
> > > But by using a bcache bucket size of 2MB, with the bcache staged in
> > > Jens' for-next, I've caused bcache to issue bios with nr_iovecs=512:
> > 
> > Argh. Why is dm using bi_max_vecs instead of bi_vcnt? I could hack
> > around this in bcache but I think dm is doing the wrong thing here.
> 
> But even bio_alloc_bioset() sets: bio->bi_max_vecs = nr_iovecs;
> And bio_clone_bioset() calls bio_alloc_bioset() with bio->bi_max_vecs.
> Similarly, __bio_clone() is using bi_max_vecs when cloning the bi_io_vec.
> So I'm missing why DM is doing the wrong thing.

I forgot about the bio_clone() one - you're right, that's also a
problem.

So, I had a patch queued up at one point as part of the immutable
biovecs series that changed bio_clone() and the dm bio cloning/splitting
stuff to use bio_segments() instead of bi_max_vecs. That is IMO a better
way of doing it anyways and as far as I could tell perfectly safe (it
was tested), but the patch ended up squashed for various reasons and I'm
not sure I want to recreate it just for this... though it would be the
cleanest fix.

> > Unless I've missed something in my testing (and bcache's BIO_MAX_PAGES
> > check isn't quite right, actually) bcache _is_ splitting its bios
> > whenever bio_segments(bio) > BIO_MAX_PAGES, it's only bi_max_vecs that's
> > potentially > BIO_MAX_PAGES.
> 
> OK, but why drive bi_max_vecs larger than BIO_MAX_PAGES?

bcache has a mempool for bios that are used for reading/writing
(potentially) entire buckets - but in the case where we're only writing
to part of a btree node and the bio didn't have to be split, that's when
we pass down our original huge bio.

I just had the horrible thought that an easy fix would probably be to
just reset bi_max_vecs to bi_vcnt in bcache before passing it down. If I
can't come up with any reasons that won't work, I may just do that.
