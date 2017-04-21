From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-region-hash: fix strange usage of
	mempool_alloc.
Date: Fri, 21 Apr 2017 09:02:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1704210847510.31816@file01.intranet.prod.int.rdu2.redhat.com>
References: <87efx1xb9h.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87efx1xb9h.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 10 Apr 2017, NeilBrown wrote:

> mempool_alloc() should only be called with GFP_ATOMIC when
> it is not safe to wait. Passing __GFP_NOFAIL to kmalloc()
> says that it is safe to wait indefinitely.  So this code is
> inconsistent.
> 
> Clearly it is OK to wait indefinitely in this code, and
> mempool_alloc() is able to do that.  So just use
> mempool_alloc, and allow it to sleep.  If no memory is
> available it will wait for something to be returned to the
> pool, and will retry a normal allocation regularly.

The region hash code is buggy anyway, because it may allocate more entries 
than the size of the pool and not give them back.

That kmalloc was introduced in the commit c06aad854 to work around a 
deadlock due to incorrect mempool usage.

Your patch slightly increases the probability of the deadlock because 
mempool_alloc does all allocations with __GFP_NOMEMALLOC, so it uses 
higher limit than kmalloc(GFP_NOIO).

Mikulas

> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/dm-region-hash.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> index 85c32b22a420..a6279f5d779e 100644
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -287,9 +287,7 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
>  {
>  	struct dm_region *reg, *nreg;
>  
> -	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
> -	if (unlikely(!nreg))
> -		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> +	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
>  
>  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
>  		      DM_RH_CLEAN : DM_RH_NOSYNC;
> -- 
> 2.12.2
> 
> 
