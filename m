From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-region-hash: fix a missing-check bug in __rh_alloc()
Date: Sun, 26 May 2019 21:49:14 -0400
Message-ID: <20190527014913.GA10098@redhat.com>
References: <20190527005034.GA16907@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190527005034.GA16907@zhanggen-UX430UQ>
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, May 26 2019 at  8:50pm -0400,
Gen Zhang <blackgod016574@gmail.com> wrote:

> In function __rh_alloc(), the pointer nreg is allocated a memory space
> via kmalloc(). And it is used in the following codes. However, when 
> there is a memory allocation error, kmalloc() fails. Thus null pointer
> dereference may happen. And it will cause the kernel to crash. Therefore,
> we should check the return value and handle the error.
> Further, in __rh_find(), we should also check the return value and
> handle the error.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> ---
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> index 1f76045..2fa1641 100644
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -290,8 +290,11 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
>  	struct dm_region *reg, *nreg;
>  
>  	nreg = mempool_alloc(&rh->region_pool, GFP_ATOMIC);
> -	if (unlikely(!nreg))
> +	if (unlikely(!nreg)) {
>  		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> +		if (!nreg)
> +			return NULL;
> +	}
>  
>  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
>  		      DM_RH_CLEAN : DM_RH_NOSYNC;

This patch isn't needed.  __GFP_NOFAIL means the allocation won't fail.

And there are many other users of __GFP_NOFAIL that don't check for
failure.  

Mike
