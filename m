From: "Du Jun" <dujun@aaastor.com>
Subject: Re: [patch] dm-raid1.c  fix  a race bug in __rh_alloc()
Date: Wed, 29 Jun 2005 09:32:31 +0800
Message-ID: <001a01c57c4a$781ae5e0$bc000064@coldice>
References: <003101c572e3$4a0a9f80$1f000064@polaris><1c9f4f0a9145ce7e3390f1ff66cc3ad7@redhat.com>
	<42C154A0.70309@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

the problem lies on that there's a small window between the write_unlock and
read_lock. for a smarter fix mentioned by Jun'ichi, I think we need a
downgradable rw lock to eliminate the race window.


----- Original Message ----- 
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
To: "device-mapper development" <dm-devel@redhat.com>
Sent: Tuesday, June 28, 2005 9:46 PM
Subject: Re: [dm-devel] [patch] dm-raid1.c fix a race bug in __rh_alloc()


> Hi,
>
> Jonathan E Brassow wrote:
>  > I believe this also fixes Jun'ichi's issue (*[dm-devel] [PATCH]
>  > 2.6.12-rc6: fix __rh_alloc()/rh_update_states() race in dm-raid1.c)
>
> Unfortunately, it doesn't eliminate the possibility of the region
> being freed during lock conversion (though the possibility becomes
> very very low) and also it will cause other problems.
>
> I modified his patch with fixes below
>    - spin_lock should be spin_lock_irq to avoid deadlock,
>    - needs to check pending count to avoid moving dirty region to clean
list,
> and added retry code.
>
> This one should work. How about this?
>
> However, I think we need to find smarter fix not to depend on retry.
>
> Thanks,
>
> Jonathan E Brassow wrote:
> > I believe this also fixes Jun'ichi's issue (*[dm-devel] [PATCH]
> > 2.6.12-rc6: fix __rh_alloc()/rh_update_states() race in dm-raid1.c)
> >
> > brassow
> > *
> > On Jun 16, 2005, at 9:21 PM, Zhao Qian wrote:
> >
> >     after write_unlock_irq and just before read_lock, there's a small
> >     window which enables a race causing deletion of the region struct in
> >     function rh_update_states(). then in rh_dec(), the __rh_lookup()
> >     will return null, causing kernel panic.
>
>


----------------------------------------------------------------------------
----


> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -232,6 +232,7 @@ static struct region *__rh_alloc(struct
>  {
>   struct region *reg, *nreg;
>
> +retry:
>   read_unlock(&rh->hash_lock);
>   nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
>   nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
> @@ -252,15 +253,19 @@ static struct region *__rh_alloc(struct
>
>   else {
>   __rh_insert(rh, nreg);
> - if (nreg->state == RH_CLEAN) {
> - spin_lock(&rh->region_lock);
> - list_add(&nreg->list, &rh->clean_regions);
> - spin_unlock(&rh->region_lock);
> - }
>   reg = nreg;
>   }
>   write_unlock_irq(&rh->hash_lock);
>   read_lock(&rh->hash_lock);
> + /* rare, but it's possible the region is freed by other cpu */
> + if (reg != __rh_lookup(rh, region))
> + goto retry;
> + if (reg->state == RH_CLEAN) {
> + spin_lock_irq(&rh->region_lock);
> + if (!atomic_read(&reg->pending) && list_empty(&reg->list))
> + list_add(&reg->list, &rh->clean_regions);
> + spin_unlock_irq(&rh->region_lock);
> + }
>
>   return reg;
>  }
>


----------------------------------------------------------------------------
----


> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
