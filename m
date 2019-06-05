From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] dm-region-hash: Fix a missing-check bug in __rh_alloc()
Date: Wed, 5 Jun 2019 08:05:18 +0200
Message-ID: <79ec221d-6970-3b30-0660-4a288a4c465e@suse.cz>
References: <20190524031248.GA6295@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190524031248.GA6295@zhanggen-UX430UQ>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 24. 05. 19, 5:12, Gen Zhang wrote:
> In function __rh_alloc(), the pointer nreg is allocated a memory space
> via kmalloc(). And it is used in the following codes. However, when 
> there is a memory allocation error, kmalloc() fails. Thus null pointer
> dereference may happen. And it will cause the kernel to crash. Therefore,
> we should check the return value and handle the error.
> Further, in __rh_find(), we should also check the return value and
> handle the error.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> 
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

What's the purpose of checking NO_FAIL allocations?

thanks,
-- 
js
suse labs
