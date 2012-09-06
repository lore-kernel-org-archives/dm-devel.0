From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 7/8] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Date: Thu, 6 Sep 2012 16:45:10 -0700
Message-ID: <20120906234510.GB9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-8-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346970902-10931-8-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Sep 06, 2012 at 03:35:01PM -0700, Kent Overstreet wrote:
> Previously, bio_kmalloc() and bio_alloc_bioset() behaved slightly
> different because there was some almost-duplicated code - this fixes
> some of that.
> 
> The important change is that previously bio_kmalloc() always set
> bi_io_vec = bi_inline_vecs, even if nr_iovecs == 0 - unlike
> bio_alloc_bioset(). This would cause bio_has_data() to return true; I
> don't know if this resulted in any actual bugs but it was certainly
> wrong.
> 
> bio_kmalloc() and bio_alloc_bioset() also have different arbitrary
> limits on nr_iovecs - 1024 (UIO_MAXIOV) for bio_kmalloc(), 256
> (BIO_MAX_PAGES) for bio_alloc_bioset(). This patch doesn't fix that, but
> at least they're enforced closer together and hopefully they will be
> fixed in a later patch.
> 
> This'll also help with some future cleanups - there are a fair number of
> functions that allocate bios (e.g. bio_clone()), and now they don't have
> to be duplicated for bio_alloc(), bio_alloc_bioset(), and bio_kmalloc().
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> v7: Re-add dropped comments, improv patch description

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
