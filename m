From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Date: Fri, 24 Aug 2012 13:36:20 -0700
Message-ID: <20120824203620.GG21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-13-git-send-email-koverstreet@google.com>
 <20120822210740.GM19212@google.com>
 <20120824062418.GD11977@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120824062418.GD11977-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Thu, Aug 23, 2012 at 11:24:18PM -0700, Kent Overstreet wrote:
> > I'd prefer simply adding @bioset to bio_clone() so that the caller
> > always has to make the choice consciously.  We're updating all the
> > callers anyway.
> 
> Possibly, but the btrfs code uses bio_clone() and there fs_bio_set may
> be correct (will have to look at what it's doing, if it's cloning a bio
> that was allocated out of fs_bio_set that would be bad..)

Yeah, I think it's generally a good idea to require explicit bioset
specification even if that ends up being fs_bio_set or NULL.

> I would also prefer to simply drop bio_clone() so that
> bio_clone_bioset() matches bio_alloc_bioset(), but regardless that'll
> have to be a different patch (and I don't think I've had to update any
> of the bio_clone() callers in this patch series anyways).

Ooh yeah, bio_clone_bioset() would be the better name for it.

Thanks.

-- 
tejun
