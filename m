From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-writecache: add unlikely for returned value of
 rb_next/prev
Date: Tue, 23 Apr 2019 11:50:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1904231150360.17390@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190412152814.27158-1-huye@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412152814.27158-1-huye@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <huye@redhat.com>
Cc: snitzer@redhat.com, agk@redhat.com, prarit@redhat.com, chengnt@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Fri, 12 Apr 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> In functions writecache_discard and writecache_find_entry, there is
> high probablity that the pointer of structure rb_node doesn't equal
> to NULL. Add unlikly for the pointer node.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 5b4d1c1..cfbbfbc 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -571,7 +571,7 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
>  			node = rb_prev(&e->rb_node);
>  		else
>  			node = rb_next(&e->rb_node);
> -		if (!node)
> +		if (unlikely(!node))
>  			return e;
>  		e2 = container_of(node, struct wc_entry, rb_node);
>  		if (read_original_sector(wc, e2) != block)
> @@ -804,7 +804,7 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
>  			writecache_free_entry(wc, e);
>  		}
>  
> -		if (!node)
> +		if (unlikely(!node))
>  			break;
>  
>  		e = container_of(node, struct wc_entry, rb_node);
> -- 
> 1.8.3.1
> 
