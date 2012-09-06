From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 6/8] block: Kill bi_destructor
Date: Thu, 6 Sep 2012 16:42:42 -0700
Message-ID: <20120906234242.GA9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346970902-10931-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Sep 06, 2012 at 03:35:00PM -0700, Kent Overstreet wrote:
> Now that we've got generic code for freeing bios allocated from bio
> pools, this isn't needed anymore.
> 
> This patch also makes bio_free() static, since without bi_destructor
> there should be no need for it to be called anywhere else.
> 
> bio_free() is now only called from bio_put, so we can refactor those a
> bit - move some code from bio_put() to bio_free() and kill the redundant
> bio->bi_next = NULL.
> 
> v5: Switch to BIO_KMALLOC_POOL ((void *)~0), per Boaz
> v6: BIO_KMALLOC_POOL now NULL, drop bio_free's EXPORT_SYMBOL
> v7: No #define BIO_KMALLOC_POOL anymore
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
