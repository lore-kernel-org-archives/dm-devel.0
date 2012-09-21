From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce to not
 use bi_io_vec
Date: Thu, 20 Sep 2012 17:25:55 -0700
Message-ID: <20120921002555.GV7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-20-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-20-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Mon, Sep 10, 2012 at 05:22:30PM -0700, Kent Overstreet wrote:
> A bunch of what __blk_queue_bounce() was doing was problematic for the
> immutable bvec work; this cleans that up and the code is quite a bit
> smaller, too.
> 
> The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
> because that one's looping over the original bio, not the bounce bio -
> since the bounce code doesn't own that bio the __ version wasn't
> correct.

I do like the new implementation.  I think the function is broken
before and after tho.  Allocating from fs_bio_set from block layer is
never safe and nothing seems to prevent multiple allocators compete in
the bounce page mempool.  This will need a separate bioset and the
multiple mempool allocation would have to be put inside a mutex.

Also, how was this tested?

Thanks.

-- 
tejun
