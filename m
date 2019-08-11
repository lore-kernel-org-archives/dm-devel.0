From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm writecache: add unlikely for getting two block
 with same LBA
Date: Sun, 11 Aug 2019 14:11:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908111410590.13454@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190811161233.7616-1-yehs2007@zoho.com>
	<20190811161233.7616-2-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190811161233.7616-2-yehs2007@zoho.com>
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
> In function writecache_writeback, entries g and f has same original
> sector only happens at entry f has been committed, but entry g has
> NOT yet.
> 
> The probability of this happening is very low in the following
>  256 blocks at most of entry e, so add unlikely for the result.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 5c7009d..3643084 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -1628,8 +1628,8 @@ static void writecache_writeback(struct work_struct *work)
>  			if (unlikely(!next_node))
>  				break;
>  			g = container_of(next_node, struct wc_entry, rb_node);
> -			if (read_original_sector(wc, g) ==
> -			    read_original_sector(wc, f)) {
> +			if (unlikely(read_original_sector(wc, g) ==
> +			    read_original_sector(wc, f))) {
>  				f = g;
>  				continue;
>  			}
> -- 
> 1.8.3.1
> 
> 
