From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: correct uncommitted_block when discarding
 uncommitted entry
Date: Sat, 13 Jun 2020 08:40:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006130839480.27500@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200612155911.96528-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200612155911.96528-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Fri, 12 Jun 2020, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> When uncommitted entry has been discarded, correct wc->uncommitted_block
> for getting the exact number.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

Also, add:
Cc: stable@vger.kernel.org

> ---
>  drivers/md/dm-writecache.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 4367cc7..64b4527 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -855,6 +855,8 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
>  				}
>  				discarded_something = true;
>  			}
> +			if (!writecache_entry_is_committed(wc, e))
> +				wc->uncommitted_blocks--;
>  			writecache_free_entry(wc, e);
>  		}
>  
> -- 
> 1.8.3.1
> 
