From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] 2.6.12-rc6: fix rh_dec()/rh_inc() race in
	dm-raid1.c
Date: Fri, 24 Jun 2005 10:19:18 -0500
Message-ID: <5d3aa9a8d94cf891a9a4b86c8f506379@redhat.com>
References: <42B2027D.7040807@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42B2027D.7040807@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Nomura Jun'ichi <jnomura@redhat.com>
List-Id: dm-devel.ids

could this be solved by doing your patch in rh_dec and just moving the  
atomic_inc in rh_inc?  The reason I ask is that the mark_region log  
call can block.

  brassow
On Jun 16, 2005, at 5:51 PM, Jun'ichi Nomura wrote:

> Hello,
>
> Attached patch fixes the another bug in dm-raid1.c that
> the dirty region may stay in or be moved to clean list
> and freed while in use.
>
> It happens as follows:
>
>    CPU0                                   CPU1
>     
> ----------------------------------------------------------------------- 
> -------
>    rh_dec()
>      if (atomic_dec_and_test(pending))
>         <the region is still marked dirty>
>                                           rh_inc()
>                                             if the region is clean
>                                                mark the region dirty
>                                                and remove from clean  
> list
>         mark the region clean
>         and move to clean list
>                                                   atomic_inc(pending)
>
> At this stage, the region is in clean list and
> will be mistakenly reclaimed by rh_update_states() later.
>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>
> --- kernel/drivers/md/dm-raid1.c.orig	2005-06-16 07:13:50.610325768  
> -0400
> +++ kernel/drivers/md/dm-raid1.c	2005-06-16 10:34:12.510719112 -0400
> @@ -375,16 +380,18 @@ static void rh_inc(struct region_hash *r
>
>  	read_lock(&rh->hash_lock);
>  	reg = __rh_find(rh, region);
> +
> +	atomic_inc(&reg->pending);
> +
> +	spin_lock_irq(&rh->region_lock);
>  	if (reg->state == RH_CLEAN) {
>  		rh->log->type->mark_region(rh->log, reg->key);
>
> -		spin_lock_irq(&rh->region_lock);
>  		reg->state = RH_DIRTY;
>  		list_del_init(&reg->list);	/* take off the clean list */
> -		spin_unlock_irq(&rh->region_lock);
>  	}
> +	spin_unlock_irq(&rh->region_lock);
>
> -	atomic_inc(&reg->pending);
>  	read_unlock(&rh->hash_lock);
>  }
>
> @@ -408,6 +414,10 @@ static void rh_dec(struct region_hash *r
>
>  	if (atomic_dec_and_test(&reg->pending)) {
>  		spin_lock_irqsave(&rh->region_lock, flags);
> +		if (atomic_read(&reg->pending)) { /* check race */
> +			spin_unlock_irqrestore(&rh->region_lock, flags);
> +			return;
> +		}
>  		if (reg->state == RH_RECOVERING) {
>  			list_add_tail(&reg->list, &rh->quiesced_regions);
>  		} else {
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
