From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: remove test for impossible
	conditions
Date: Mon, 24 Jul 2017 15:35:56 +0900
Message-ID: <3b339c62-095d-6e39-7d87-63b11e14c2f0@wdc.com>
References: <alpine.LRH.2.02.1707211150200.31337@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1707211150200.31337@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 7/22/17 00:56, Mikulas Patocka wrote:
> Hi
> 
> Here I send a patch that removes some impossible code from dm-zoned. The 
> target also contains large number of GFP_KERNEL allocations, they should 
> be changed to GFP_NOIO, if I/O processing could be delayed because of the 
> allocation (i.e. anywhere except initialization you should use GFP_NOIO).
> 
> Regarding this "if (!nr_sectors && bio_op(bio) != REQ_OP_WRITE)" - could 
> this be removed too? Does it really process some zero-sized requests that 
> are not flushes? It doesn't seem so.
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The value REQ_OP_FLUSH is used by the block code in the request structure. 
> It is not used in the bio structure.
> 
> This patch removes the tests for REQ_OP_FLUSH from dm-zoned-target.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-zoned-target.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-zoned-target.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zoned-target.c
> +++ linux-2.6/drivers/md/dm-zoned-target.c
> @@ -588,7 +588,7 @@ static int dmz_map(struct dm_target *ti,
>  
>  	bio->bi_bdev = dev->bdev;
>  
> -	if (!nr_sectors && (bio_op(bio) != REQ_OP_FLUSH) && (bio_op(bio) != REQ_OP_WRITE))
> +	if (!nr_sectors && bio_op(bio) != REQ_OP_WRITE)
>  		return DM_MAPIO_REMAPPED;
>  
>  	/* The BIO should be block aligned */
> @@ -603,7 +603,7 @@ static int dmz_map(struct dm_target *ti,
>  	bioctx->status = BLK_STS_OK;
>  
>  	/* Set the BIO pending in the flush list */
> -	if (bio_op(bio) == REQ_OP_FLUSH || (!nr_sectors && bio_op(bio) == REQ_OP_WRITE)) {
> +	if (!nr_sectors && bio_op(bio) == REQ_OP_WRITE) {
>  		spin_lock(&dmz->flush_lock);
>  		bio_list_add(&dmz->flush_list, bio);
>  		spin_unlock(&dmz->flush_lock);
> 

Good catch !

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal,
Western Digital
