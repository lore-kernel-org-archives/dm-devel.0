From: Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v2 3/3] block: warn if !__GFP_DIRECT_RECLAIM in
 bio_crypt_set_ctx()
Date: Thu, 17 Sep 2020 22:26:06 +0000
Message-ID: <20200917222606.GC421296@google.com>
References: <20200916035315.34046-1-ebiggers@kernel.org>
 <20200916035315.34046-4-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200916035315.34046-4-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Miaohe Lin <linmiaohe@huawei.com>
List-Id: dm-devel.ids

On Tue, Sep 15, 2020 at 08:53:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> bio_crypt_set_ctx() assumes its gfp_mask argument always includes
> __GFP_DIRECT_RECLAIM, so that the mempool_alloc() will always succeed.
> 
> For now this assumption is still fine, since no callers violate it.
> Making bio_crypt_set_ctx() able to fail would add unneeded complexity.
> 
> However, if a caller didn't use __GFP_DIRECT_RECLAIM, it would be very
> hard to notice the bug.  Make it easier by adding a WARN_ON_ONCE().
> 
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Satya Tangirala <satyat@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index bbe7974fd74f0..5da43f0973b46 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -81,7 +81,15 @@ subsys_initcall(bio_crypt_ctx_init);
>  void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
>  		       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE], gfp_t gfp_mask)
>  {
> -	struct bio_crypt_ctx *bc = mempool_alloc(bio_crypt_ctx_pool, gfp_mask);
> +	struct bio_crypt_ctx *bc;
> +
> +	/*
> +	 * The caller must use a gfp_mask that contains __GFP_DIRECT_RECLAIM so
> +	 * that the mempool_alloc() can't fail.
> +	 */
> +	WARN_ON_ONCE(!(gfp_mask & __GFP_DIRECT_RECLAIM));
> +
> +	bc = mempool_alloc(bio_crypt_ctx_pool, gfp_mask);
>  
>  	bc->bc_key = key;
>  	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
> -- 
Looks good!

Reviewed-by: Satya Tangirala <satyat@google.com>

> 2.28.0
> 
