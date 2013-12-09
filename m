From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 3.4,3.5 and earlier] dm: fix truncated status strings
Date: Mon, 9 Dec 2013 16:17:01 +0000
Message-ID: <20131209161701.GK4278@hercules>
References: <alpine.LRH.2.02.1312061425320.3666@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1312061425320.3666@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 06, 2013 at 02:31:03PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I noticed that the upstream commit 
> fd7c092e711ebab55b2688d3859d95dfd0301f73 wasn't added to 3.4 stable 
> kernel, so here I am resending it. It can also, with small changes, be 
> applied to 3.5, 3.2, 3.0 and other stable kernels.
> 
> Mikulas
> 

Thank you Mikulas, I was going to queue this backport to the 3.5
kernel when I noticed something that seems to be wrong:

[ ... ]

>  static int stripe_end_io(struct dm_target *ti, struct bio *bio,
> Index: linux-3.4.71/drivers/md/dm-thin.c
> ===================================================================
> --- linux-3.4.71.orig/drivers/md/dm-thin.c	2013-05-20 17:55:14.000000000 +0200
> +++ linux-3.4.71/drivers/md/dm-thin.c	2013-11-30 01:01:51.000000000 +0100
> @@ -2325,8 +2325,8 @@ static int pool_message(struct dm_target
>   *    <transaction id> <used metadata sectors>/<total metadata sectors>
>   *    <used data sectors>/<total data sectors> <held metadata root>
>   */
> -static int pool_status(struct dm_target *ti, status_type_t type,
> -		       char *result, unsigned maxlen)
> +static void pool_status(struct dm_target *ti, status_type_t type,
> +			char *result, unsigned maxlen)
>  {
>  	int r, count;
>  	unsigned sz = 0;
> @@ -2343,32 +2343,41 @@ static int pool_status(struct dm_target
>  
>  	switch (type) {
>  	case STATUSTYPE_INFO:
> -		r = dm_pool_get_metadata_transaction_id(pool->pmd,
> -							&transaction_id);
> -		if (r)
> -			return r;
> -
> -		r = dm_pool_get_free_metadata_block_count(pool->pmd,
> -							  &nr_free_blocks_metadata);
> -		if (r)
> -			return r;
> +		r = dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
> +		if (r) {
> +			DMERR("dm_pool_get_metadata_transaction_id returned %d", r);
> +			goto err;
> +		}
> +
> +		r = dm_pool_get_free_metadata_block_count(pool->pmd, &nr_free_blocks_metadata);
> +		if (r) {
> +			DMERR("dm_pool_get_free_metadata_block_count returned %d", r);
> +			goto err;
> +		}
>  
>  		r = dm_pool_get_metadata_dev_size(pool->pmd, &nr_blocks_metadata);
> -		if (r)
> -			return r;
> +		if (r) {
> +			DMERR("dm_pool_get_metadata_dev_size returned %d", r);
> +			goto err;
> +		}
>  
> -		r = dm_pool_get_free_block_count(pool->pmd,
> -						 &nr_free_blocks_data);
> -		if (r)
> -			return r;
> +		r = dm_pool_get_free_block_count(pool->pmd, &nr_free_blocks_data);
> +		if (r) {
> +			DMERR("dm_pool_get_free_block_count returned %d", r);
> +			goto err;
> +		}
>  
>  		r = dm_pool_get_data_dev_size(pool->pmd, &nr_blocks_data);
> -		if (r)
> -			return r;
> +		if (r) {
> +			DMERR("dm_pool_get_data_dev_size returned %d", r);
> +			goto err;
> +		}
>  
>  		r = dm_pool_get_held_metadata_root(pool->pmd, &held_root);

Looking at the original commit, the above line seems to be wrong.
Shouldn't it be:

		r = dm_pool_get_metadata_snap(pool->pmd, &held_root);

Cheers,
--
Luis
