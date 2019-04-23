From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-writecache: remove unused member page_offset in
 writeback_struct
Date: Tue, 23 Apr 2019 06:39:15 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1904230638030.11112@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190420162017.6052-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190420162017.6052-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: snitzer@redhat.com, agk@redhat.com, prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Sun, 21 Apr 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> The structure member page_offset in writeback_struct never has been
> used actually. Remove it.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index cfbbfbc..ddf1732 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -190,7 +190,6 @@ struct writeback_struct {
>  	struct dm_writecache *wc;
>  	struct wc_entry **wc_list;
>  	unsigned wc_list_n;
> -	unsigned page_offset;
>  	struct page *page;
>  	struct wc_entry *wc_list_inline[WB_LIST_INLINE];
>  	struct bio bio;
> @@ -1481,7 +1480,6 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
>  		bio->bi_end_io = writecache_writeback_endio;
>  		bio_set_dev(bio, wc->dev->bdev);
>  		bio->bi_iter.bi_sector = read_original_sector(wc, e);
> -		wb->page_offset = PAGE_SIZE;
>  		if (max_pages <= WB_LIST_INLINE ||
>  		    unlikely(!(wb->wc_list = kmalloc_array(max_pages, sizeof(struct wc_entry *),
>  							   GFP_NOIO | __GFP_NORETRY |
> -- 
> 1.8.3.1
> 
> 
