From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/7] dm: add reserved_bio_based_ios module
	parameter
Date: Thu, 12 Sep 2013 18:47:01 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309121845510.31794@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379024698-10487-4-git-send-email-snitzer@redhat.com>
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

We don't need this. bio-based i/o should be fine with a small mempool, 
there is no need to make it tunable.

Mikulas


On Thu, 12 Sep 2013, Mike Snitzer wrote:

> Allow user to change the number of IOs that are reserved by
> bio-based DM's mempools by writing to this file:
> /sys/module/dm_mod/parameters/reserved_bio_based_ios
> 
> The default value is RESERVED_BIO_BASED_IOS (16).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8553d03..b44ae19 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -217,6 +217,17 @@ static struct kmem_cache *_io_cache;
>  static struct kmem_cache *_rq_tio_cache;
>  
>  /*
> + * Bio-based DM's mempools' reserved IOs set by the user
> + */
> +static unsigned reserved_bio_based_ios;
> +
> +/*
> + * A copy of reserved_bio_based_ios because it can change anytime.
> + * If values disagree, the user has changed reserved_bio_based_ios.
> + */
> +static unsigned reserved_bio_based_ios_latch;
> +
> +/*
>   * Request-based DM's mempools' reserved IOs set by the user
>   */
>  static unsigned reserved_rq_based_ios;
> @@ -228,10 +239,26 @@ static unsigned reserved_rq_based_ios;
>  static unsigned reserved_rq_based_ios_latch;
>  
>  /*
> - * This mutex protects reserved_rq_based_ios_latch.
> + * This mutex protects reserved_bio_based_ios_latch and reserved_rq_based_ios_latch.
>   */
>  static DEFINE_MUTEX(dm_mempools_lock);
>  
> +static void __reserved_bio_based_ios_refresh(void)
> +{
> +	BUG_ON(!mutex_is_locked(&dm_mempools_lock));
> +
> +	reserved_bio_based_ios_latch = ACCESS_ONCE(reserved_bio_based_ios);
> +
> +	/*
> +	 * If the user uses "0", it means default.  Modify
> +	 * reserved_bio_based_ios to report the default to the user.
> +	 */
> +	if (!reserved_bio_based_ios_latch) {
> +		(void)cmpxchg(&reserved_bio_based_ios, 0, RESERVED_BIO_BASED_IOS);
> +		reserved_bio_based_ios_latch = reserved_bio_based_ios;
> +	}
> +}
> +
>  static void __reserved_request_based_ios_refresh(void)
>  {
>  	BUG_ON(!mutex_is_locked(&dm_mempools_lock));
> @@ -274,6 +301,7 @@ static int __init local_init(void)
>  		_major = r;
>  
>  	mutex_lock(&dm_mempools_lock);
> +	__reserved_bio_based_ios_refresh();
>  	__reserved_request_based_ios_refresh();
>  	mutex_unlock(&dm_mempools_lock);
>  
> @@ -2899,7 +2927,14 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
>  
>  	if (type == DM_TYPE_BIO_BASED) {
>  		cachep = _io_cache;
> -		pool_size = RESERVED_BIO_BASED_IOS;
> +
> +		mutex_lock(&dm_mempools_lock);
> +		/* Check if reserved_bio_based_ios changed. */
> +		if (reserved_bio_based_ios != reserved_bio_based_ios_latch)
> +			__reserved_bio_based_ios_refresh();
> +		pool_size = reserved_bio_based_ios_latch;
> +		mutex_unlock(&dm_mempools_lock);
> +
>  		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
>  	} else if (type == DM_TYPE_REQUEST_BASED) {
>  		cachep = _rq_tio_cache;
> @@ -2969,6 +3004,9 @@ module_exit(dm_exit);
>  module_param(major, uint, 0);
>  MODULE_PARM_DESC(major, "The major number of the device mapper");
>  
> +module_param(reserved_bio_based_ios, uint, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
> +
>  module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
>  
> -- 
> 1.8.1.4
> 
