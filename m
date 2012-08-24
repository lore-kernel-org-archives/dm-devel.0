From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Date: Thu, 23 Aug 2012 23:24:18 -0700
Message-ID: <20120824062418.GD11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-13-git-send-email-koverstreet@google.com>
 <20120822210740.GM19212@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120822210740.GM19212-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Aug 22, 2012 at 02:07:40PM -0700, Tejun Heo wrote:
> On Wed, Aug 22, 2012 at 10:04:09AM -0700, Kent Overstreet wrote:
> > Previously, there was bio_clone() but it only allocated from the fs bio
> > set; as a result various users were open coding it and using
> > __bio_clone().
> > 
> > This changes bio_clone() to become bio_clone_bioset(), and then we add
> > bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> > the functionality the last patch adedd.
> > 
> > This will also help in a later patch changing how bio cloning works.
> 
> I'd prefer simply adding @bioset to bio_clone() so that the caller
> always has to make the choice consciously.  We're updating all the
> callers anyway.

Possibly, but the btrfs code uses bio_clone() and there fs_bio_set may
be correct (will have to look at what it's doing, if it's cloning a bio
that was allocated out of fs_bio_set that would be bad..)

I would also prefer to simply drop bio_clone() so that
bio_clone_bioset() matches bio_alloc_bioset(), but regardless that'll
have to be a different patch (and I don't think I've had to update any
of the bio_clone() callers in this patch series anyways).
