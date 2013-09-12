From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 7/7] dm: optimize clone_rq() when
 track_peak_rq_based_ios is disabled
Date: Thu, 12 Sep 2013 19:00:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309121857440.31794@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379024698-10487-8-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids



On Thu, 12 Sep 2013, Mike Snitzer wrote:

> Make use of static keys to eliminate the relevant branch in clone_rq()
> when dm_mod's 'track_peak_rq_based_ios' paramter is set to 0 (disabled).
> 
> Even if 'track_peak_rq_based_ios' is set to 0 it will not take effect
> until the next request-based table reload.  Once it is disabled the
> 'peak_rq_based_ios' parameter will be reset to 0.

This patch changes it so that the value track_peak_rq_based_ios is sampled 
only when reloading a table. I think it will be confusing to the user if 
he changes the value, but the change doesn't take effect until something 
reloads some table.

Mikulas

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index de83930..d9e38a7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -19,6 +19,7 @@
>  #include <linux/idr.h>
>  #include <linux/hdreg.h>
>  #include <linux/delay.h>
> +#include <linux/static_key.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -242,10 +243,14 @@ static unsigned reserved_rq_based_ios_latch;
>   * Optionally track the maximum numbers of IOs in a cloned request.
>   */
>  static unsigned track_peak_rq_based_ios;
> +static unsigned track_peak_rq_based_ios_latch;
>  static unsigned peak_rq_based_ios;
>  
> +static struct static_key_deferred track_peak_rq_based_ios_enabled; /* defaults to false */
> +
>  /*
> - * This mutex protects reserved_bio_based_ios_latch and reserved_rq_based_ios_latch.
> + * This mutex protects reserved_bio_based_ios_latch, reserved_rq_based_ios_latch
> + * and track_peak_rq_based_ios_latch.
>   */
>  static DEFINE_MUTEX(dm_mempools_lock);
>  
> @@ -305,6 +310,26 @@ unsigned dm_get_reserved_rq_based_ios(void)
>  }
>  EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
>  
> +static void __track_peak_rq_based_ios_refresh(void)
> +{
> +	bool enabled = static_key_false(&track_peak_rq_based_ios_enabled.key);
> +
> +	BUG_ON(!mutex_is_locked(&dm_mempools_lock));
> +
> +	track_peak_rq_based_ios_latch = ACCESS_ONCE(track_peak_rq_based_ios);
> +
> +	if (track_peak_rq_based_ios_latch) {
> +		if (enabled)
> +			return; /* already enabled */
> +		static_key_slow_inc(&track_peak_rq_based_ios_enabled.key);
> +	} else {
> +		if (!enabled)
> +			return; /* already disabled */
> +		static_key_slow_dec(&track_peak_rq_based_ios_enabled.key);
> +		ACCESS_ONCE(peak_rq_based_ios) = 0;
> +	}
> +}
> +
>  static int __init local_init(void)
>  {
>  	int r = -ENOMEM;
> @@ -1725,7 +1750,7 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
>  		return NULL;
>  	}
>  
> -	if (unlikely(ACCESS_ONCE(track_peak_rq_based_ios))) {
> +	if (static_key_false(&track_peak_rq_based_ios_enabled.key)) {
>  		struct bio *bio;
>  		unsigned num_bios = 0;
>  
> @@ -2984,6 +3009,10 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
>  		if (reserved_rq_based_ios != reserved_rq_based_ios_latch)
>  			__reserved_request_based_ios_refresh();
>  		pool_size = reserved_rq_based_ios_latch;
> +
> +		/* Check if track_peak_rq_based_ios changed. */
> +		if (track_peak_rq_based_ios != track_peak_rq_based_ios_latch)
> +			__track_peak_rq_based_ios_refresh();
>  		mutex_unlock(&dm_mempools_lock);
>  
>  		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
> -- 
> 1.8.1.4
> 
