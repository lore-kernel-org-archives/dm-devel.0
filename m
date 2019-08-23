From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm table: fix a potential array out of
 bounds
Date: Fri, 23 Aug 2019 07:28:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908230705510.5296@file01.intranet.prod.int.rdu2.redhat.com>
References: <1566351211-13280-1-git-send-email-kontais@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566351211-13280-1-git-send-email-kontais@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Tao <kontais@zoho.com>
Cc: agk@redhat.com, snitzer@redhat.com, Zhang Tao <zhangtao27@lenovo.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

I tested it and the bug is real - with some table sizes, 
dm_table_find_target will access memory out of bounds if the sector 
argument is beyond limit.

Your patch fixes some of these cases, but not all of them.

I used this script to test all possible table sizes:
#!/bin/bash -e
sync
dmsetup remove_all || true
rmmod dm_mod || true
>t.txt
for i in `seq 1 10000`; do
        echo $i
        echo $((i-1)) 1 error >>t.txt
        dmsetup create error <t.txt
        dmsetup remove error
done

and I modified dm_table_find_target to call dm_table_find_target with too 
high sector number. Without your patch, it fails on table with 16 entries; 
with your patch applied, it fails on 144 entries.

I'll make another patch that passes the test.

Mikulas


On Wed, 21 Aug 2019, Zhang Tao wrote:

> From: Zhang Tao <zhangtao27@lenovo.com>
> 
> allocate num + 1 for target and offset array, n_highs need num + 1
> elements, the last element will be used for node lookup in function
> dm_table_find_target.
> 
> Signed-off-by: Zhang Tao <zhangtao27@lenovo.com>
> ---
>  drivers/md/dm-table.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 7b6c3ee..fd7f604 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -160,20 +160,22 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
>  {
>  	sector_t *n_highs;
>  	struct dm_target *n_targets;
> +	unsigned int alloc_num;
>  
>  	/*
>  	 * Allocate both the target array and offset array at once.
>  	 * Append an empty entry to catch sectors beyond the end of
>  	 * the device.
>  	 */
> -	n_highs = (sector_t *) dm_vcalloc(num + 1, sizeof(struct dm_target) +
> +	alloc_num = num + 1;
> +	n_highs = (sector_t *) dm_vcalloc(alloc_num, sizeof(struct dm_target) +
>  					  sizeof(sector_t));
>  	if (!n_highs)
>  		return -ENOMEM;
>  
> -	n_targets = (struct dm_target *) (n_highs + num);
> +	n_targets = (struct dm_target *) (n_highs + alloc_num);
>  
> -	memset(n_highs, -1, sizeof(*n_highs) * num);
> +	memset(n_highs, -1, sizeof(*n_highs) * alloc_num);
>  	vfree(t->highs);
>  
>  	t->num_allocated = num;
> -- 
> 1.8.3.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
