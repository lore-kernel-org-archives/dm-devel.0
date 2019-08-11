From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm writecache: remove unused member pointer in
 writeback_struct
Date: Sun, 11 Aug 2019 14:10:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908111410040.13454@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190811161233.7616-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190811161233.7616-1-yehs2007@zoho.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: prarit@redhat.com, Huaisheng Ye <yehs1@lenovo.com>, snitzer@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tyu1@lenovo.com, agk@redhat.com
List-Id: dm-devel.ids



On Mon, 12 Aug 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> The stucture member pointer page in writeback_struct never has been
> used actually. Remove it.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 1cb137f..5c7009d 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -190,7 +190,6 @@ struct writeback_struct {
>  	struct dm_writecache *wc;
>  	struct wc_entry **wc_list;
>  	unsigned wc_list_n;
> -	struct page *page;
>  	struct wc_entry *wc_list_inline[WB_LIST_INLINE];
>  	struct bio bio;
>  };
> -- 
> 1.8.3.1
> 
> 
