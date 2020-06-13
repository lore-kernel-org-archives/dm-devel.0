From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: skip writecache_wait when
 using pmem mode
Date: Sat, 13 Jun 2020 08:46:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006130845530.27500@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200612155544.90348-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200612155544.90348-1-yehs2007@zoho.com>
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
Cc: dm-devel@redhat.com, Huaisheng Ye <yehs1@lenovo.com>, agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Fri, 12 Jun 2020, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> The array bio_in_progress is only used with ssd mode. So skip
> writecache_wait_for_ios in writecache_discard when pmem mode.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 66f3a3b..4367cc7 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -849,8 +849,10 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
>  
>  		if (likely(!e->write_in_progress)) {
>  			if (!discarded_something) {
> -				writecache_wait_for_ios(wc, READ);
> -				writecache_wait_for_ios(wc, WRITE);
> +				if (!WC_MODE_PMEM(wc)) {
> +					writecache_wait_for_ios(wc, READ);
> +					writecache_wait_for_ios(wc, WRITE);
> +				}
>  				discarded_something = true;
>  			}
>  			writecache_free_entry(wc, e);
> -- 
> 1.8.3.1
> 
