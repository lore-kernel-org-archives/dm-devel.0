From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: [patch] dm-raid1.c  fix  a race bug in __rh_alloc()
Date: Fri, 24 Jun 2005 10:33:25 -0500
Message-ID: <1c9f4f0a9145ce7e3390f1ff66cc3ad7@redhat.com>
References: <003101c572e3$4a0a9f80$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: multipart/mixed; boundary="===============1162375261=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <003101c572e3$4a0a9f80$1f000064@polaris>
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


--===============1162375261==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--413915152


--Apple-Mail-8--413915152
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

I believe this also fixes Jun'ichi's issue ([dm-devel] [PATCH] 
2.6.12-rc6: fix __rh_alloc()/rh_update_states() race in dm-raid1.c)

  brassow

On Jun 16, 2005, at 9:21 PM, Zhao Qian wrote:

> after write_unlock_irq and just before read_lock, there's a small 
> window which enables a race causing deletion of the region struct in 
> function rh_update_states(). then in rh_dec(), the __rh_lookup() will 
> return null, causing kernel panic.
>
>
> [root@darkstar md]# diff -u dm-raid1.orig.c dm-raid1.c
> --- dm-raid1.orig.c     2005-06-16 14:17:04.000000000 +0800
> +++ dm-raid1.c  2005-06-17 10:02:04.000000000 +0800
> @@ -252,15 +252,16 @@
>
>         else {
>                 __rh_insert(rh, nreg);
> -               if (nreg->state == RH_CLEAN) {
> -                       spin_lock(&rh->region_lock);
> -                       list_add(&nreg->list, &rh->clean_regions);
> -                       spin_unlock(&rh->region_lock);
> -               }
>                 reg = nreg;
>         }
>         write_unlock_irq(&rh->hash_lock);
>         read_lock(&rh->hash_lock);
> +       if (reg->state == RH_CLEAN) {
> +               spin_lock(&rh->region_lock);
> +               if ( list_empty(&reg->list) )
> +                       list_add(&reg->list, &rh->clean_regions);
> +               spin_unlock(&rh->region_lock);
> +       }
>
>         return reg;
>  }
>
> Sincerely,
>     Johnson <dujun@aaastor.com>
>     AiM9 <zhaoqian@aaastor.com>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--Apple-Mail-8--413915152
Content-Transfer-Encoding: 7bit
Content-Type: text/enriched;
	charset=US-ASCII

I believe this also fixes Jun'ichi's issue (<bold>[dm-devel] [PATCH]
2.6.12-rc6: fix __rh_alloc()/rh_update_states() race in dm-raid1.c)


 brassow

</bold>

On Jun 16, 2005, at 9:21 PM, Zhao Qian wrote:


<excerpt>after write_unlock_irq and just before read_lock, there's a
small window which enables a race causing deletion of the region
struct in function rh_update_states(). then in rh_dec(), the
__rh_lookup() will return null, causing kernel panic. 



[root@darkstar md]# diff -u dm-raid1.orig.c dm-raid1.c 

--- dm-raid1.orig.c     2005-06-16 14:17:04.000000000 +0800

+++ dm-raid1.c  2005-06-17 10:02:04.000000000 +0800

@@ -252,15 +252,16 @@


        else {

                __rh_insert(rh, nreg);

-               if (nreg->state == RH_CLEAN) {

-                       spin_lock(&rh->region_lock);

-                       list_add(&nreg->list, &rh->clean_regions);

-                       spin_unlock(&rh->region_lock);

-               }

                reg = nreg;

        }

        write_unlock_irq(&rh->hash_lock);

        read_lock(&rh->hash_lock);

+       if (reg->state == RH_CLEAN) {

+               spin_lock(&rh->region_lock);

+               if ( list_empty(&reg->list) )

+                       list_add(&reg->list, &rh->clean_regions);

+               spin_unlock(&rh->region_lock);

+       }


        return reg;

 }


Sincerely,

    Johnson <<dujun@aaastor.com>

    AiM9 <<zhaoqian@aaastor.com>


--

dm-devel mailing list

dm-devel@redhat.com

https://www.redhat.com/mailman/listinfo/dm-devel


</excerpt>
--Apple-Mail-8--413915152--


--===============1162375261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1162375261==--
