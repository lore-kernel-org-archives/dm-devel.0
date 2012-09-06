From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 0/8] Block cleanups
Date: Thu, 6 Sep 2012 16:48:05 -0700
Message-ID: <20120906234805.GD9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346970902-10931-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
List-Id: dm-devel.ids

Hello, guys.

(cc'ing Jens, Alasdair and Neil)

On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
> Screwed up the bio_reset() patch in the last patch series when I went to edit
> the description, fixed that here.
> 
> Only other change is the dm patch - made the front_pad conditional on
> DM_TYPE_BIO_BASED.
> 
> Kent Overstreet (8):
>   block: Generalized bio pool freeing
>   block: Ues bi_pool for bio_integrity_alloc()
>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
>   block: Add bio_reset()
>   pktcdvd: Switch to bio_kmalloc()
>   block: Kill bi_destructor
>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
>   block: Add bio_clone_bioset(), bio_clone_kmalloc()

This series looks good to me now.  If someone can ack the dm patch, I
think it's good to go.  Jens, what do you think?

Thanks.

-- 
tejun
