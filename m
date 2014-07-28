From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-switch: quickly load repetitive
	pattern
Date: Mon, 28 Jul 2014 17:49:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407281749460.26574@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407281743120.26574@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1407281747121.26574@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1407281747121.26574@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Jay Wang <jwang@nimblestorage.com>
List-Id: dm-devel.ids

I resent this patch with a correct subject...



On Mon, 28 Jul 2014, Mikulas Patocka wrote:

> dm-switch: introdice switch_region_table_read
> 
> Move a code that reads the table to a separate function.
> It will be needed for the next patch.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-switch.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> Index: linux-3.15/drivers/md/dm-switch.c
> ===================================================================
> --- linux-3.15.orig/drivers/md/dm-switch.c	2014-06-26 22:25:10.000000000 +0200
> +++ linux-3.15/drivers/md/dm-switch.c	2014-06-27 14:08:06.000000000 +0200
> @@ -137,13 +137,23 @@ static void switch_get_position(struct s
>  	*bit *= sctx->region_table_entry_bits;
>  }
>  
> +static unsigned switch_region_table_read(struct switch_ctx *sctx, unsigned long region_nr)
> +{
> +	unsigned long region_index;
> +	unsigned bit;
> +
> +	switch_get_position(sctx, region_nr, &region_index, &bit);
> +
> +	return (ACCESS_ONCE(sctx->region_table[region_index]) >> bit) &
> +		((1 << sctx->region_table_entry_bits) - 1);
> +}
> +
>  /*
>   * Find which path to use at given offset.
>   */
>  static unsigned switch_get_path_nr(struct switch_ctx *sctx, sector_t offset)
>  {
> -	unsigned long region_index;
> -	unsigned bit, path_nr;
> +	unsigned path_nr;
>  	sector_t p;
>  
>  	p = offset;
> @@ -152,9 +162,7 @@ static unsigned switch_get_path_nr(struc
>  	else
>  		sector_div(p, sctx->region_size);
>  
> -	switch_get_position(sctx, p, &region_index, &bit);
> -	path_nr = (ACCESS_ONCE(sctx->region_table[region_index]) >> bit) &
> -	       ((1 << sctx->region_table_entry_bits) - 1);
> +	path_nr = switch_region_table_read(sctx, p);
>  
>  	/* This can only happen if the processor uses non-atomic stores. */
>  	if (unlikely(path_nr >= sctx->nr_paths))
> 
> 
