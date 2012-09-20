From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(),
 and a bugfix
Date: Thu, 20 Sep 2012 14:53:13 -0700
Message-ID: <20120920215313.GE7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-2-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Mon, Sep 10, 2012 at 05:22:12PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().
> 
> This is needed eventually for immutable bio vecs - immutable bvecs
> aren't useful if we still have to copy them, hence the need for the
> pointer. Less code is always nice too, though.
> 
> Also fix an amusing bug in bio_integrity_split() - struct bio_pair
> doesn't have the integrity bvecs after the bio_integrity_payloads, so
> there was a buffer overrun. The code was confusing pointers with arrays.

Aside from what Martin and Vivek already pointed out, it generally
looks okay to me but here are some thoughts.

I'm quite doubtful how much we're gaining by this complex set of slabs
and mempools approach compared to just using kmalloc + one mempool for
the largest size.  I can't think of anything to be gained in terms of
cacheline hotness.  In terms of memory usage too, we're proabably
introducing more fragmentation with all the different slabs.

Jens, what are you thoughts?  For forward progress guarantee, single
mempool per bioset serving the largest one is enough and we can
significantly simplify the whole bioset thing.

Thanks.

-- 
tejun
