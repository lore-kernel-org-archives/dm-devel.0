From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: reinitialize lru in writeback instead of
 endio
Date: Mon, 1 Jun 2020 10:29:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006011022220.23428@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200530091250.58420-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200530091250.58420-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: snitzer@redhat.com, agk@redhat.com, prarit@redhat.com, tyu1@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Sat, 30 May 2020, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> When wc_entry has been removed from wbl->list in writeback, it will
> be not used again except waiting to be set free in writecache_free_entry.
> 
> That is a little of annoying, it has to reinitialize lru of wc_entry
> in endio before calling writecache_free_entry.
> 
> Using list_del_init instead of list_del in writeback for simpler code.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

This patch doesn't fix anything, so I think we don't need it.

Actually, it's better to keep the list entry uninitialized, because it 
helps us catch bugs where this uninitialized list entry could be used 
improperly.

Mikulas

> ---
>  drivers/md/dm-writecache.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 7bbc21b..66f3a3b 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -1519,7 +1519,6 @@ static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *
>  			e = wb->wc_list[i];
>  			BUG_ON(!e->write_in_progress);
>  			e->write_in_progress = false;
> -			INIT_LIST_HEAD(&e->lru);
>  			if (!writecache_has_error(wc))
>  				writecache_free_entry(wc, e);
>  			BUG_ON(!wc->writeback_size);
> @@ -1555,7 +1554,6 @@ static void __writecache_endio_ssd(struct dm_writecache *wc, struct list_head *l
>  		do {
>  			BUG_ON(!e->write_in_progress);
>  			e->write_in_progress = false;
> -			INIT_LIST_HEAD(&e->lru);
>  			if (!writecache_has_error(wc))
>  				writecache_free_entry(wc, e);
>  
> @@ -1654,7 +1652,7 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
>  	while (wbl->size) {
>  		wbl->size--;
>  		e = container_of(wbl->list.prev, struct wc_entry, lru);
> -		list_del(&e->lru);
> +		list_del_init(&e->lru);
>  
>  		max_pages = e->wc_list_contiguous;
>  
> @@ -1685,7 +1683,7 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
>  			if (!wc_add_block(wb, f, GFP_NOWAIT | __GFP_NOWARN))
>  				break;
>  			wbl->size--;
> -			list_del(&f->lru);
> +			list_del_init(&f->lru);
>  			wb->wc_list[wb->wc_list_n++] = f;
>  			e = f;
>  		}
> @@ -1712,7 +1710,7 @@ static void __writecache_writeback_ssd(struct dm_writecache *wc, struct writebac
>  
>  		wbl->size--;
>  		e = container_of(wbl->list.prev, struct wc_entry, lru);
> -		list_del(&e->lru);
> +		list_del_init(&e->lru);
>  
>  		n_sectors = e->wc_list_contiguous << (wc->block_size_bits - SECTOR_SHIFT);
>  
> @@ -1732,7 +1730,7 @@ static void __writecache_writeback_ssd(struct dm_writecache *wc, struct writebac
>  			wbl->size--;
>  			f = container_of(wbl->list.prev, struct wc_entry, lru);
>  			BUG_ON(f != e + 1);
> -			list_del(&f->lru);
> +			list_del_init(&f->lru);
>  			e = f;
>  		}
>  
> -- 
> 1.8.3.1
> 
