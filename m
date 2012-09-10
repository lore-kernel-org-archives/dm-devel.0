From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/9] Prep work for immutable bio vecs
Date: Sun, 9 Sep 2012 18:21:02 -0700
Message-ID: <20120910012101.GB23241@moria.home.lan>
References: <1347058760-30794-1-git-send-email-koverstreet@google.com>
 <20120908194115.GC12773@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120908194115.GC12773-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Sat, Sep 08, 2012 at 12:41:15PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Fri, Sep 07, 2012 at 03:59:11PM -0700, Kent Overstreet wrote:
> > Random assortment of refactoring and trivial cleanups.
> > 
> > Immutable bio vecs and efficient bio splitting require auditing and removing
> > pretty much all bi_idx uses, among other things.
> > 
> > The reason is that with immutable bio vecs we can't use the bvec array
> > directly; if we have a partially completed bvec, that'll be indicated with a
> > field in struct bvec_iter (which gets embedded in struct bio) - bi_bvec_done.
> > 
> > bio_for_each_segments() will handle this transparently, so code needs to be
> > converted to use it or some other generic accessor.
> > 
> > Also, bio splitting means that when a driver gets a bio, bi_idx and
> > bi_bvec_done may both be nonzero. Again, just need to use generic accessors.
> 
> There are three pending patchsets and I don't know how they're
> supposed to come together.  Please explain on which tree the patches
> are based and how they stack and preferably provide a git branch.

Both of the new ones depend on the block cleanups series, but they
shouldn't depend on each other (bar perhaps some trivial merge
conflicts in bio.h)

Git repo - block_stuff branch on http://evilpiepirate.org/git/linux-bcache.git/
