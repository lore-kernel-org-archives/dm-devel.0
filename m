From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v3 for-3.14] dm cache: add block sizes and
 total cache blocks to status output
Date: Fri, 10 Jan 2014 15:13:45 +0000
Message-ID: <20140110151345.GB26346@debian>
References: <20140109210412.GA5288@redhat.com> <20140110101116.GA20496@debian>
	<20140110141028.GA10511@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140110141028.GA10511@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

You're determined to do this, so I'll ack the patch.

On Fri, Jan 10, 2014 at 09:10:28AM -0500, Mike Snitzer wrote:
> Improve cache_status to emit:
> <metadata block size> <#used metadata blocks>/<#total metadata blocks>
> <cache block size> <#used cache blocks>/<#total cache blocks>
> ...
> 
> Adding the block sizes allows for easier calculation of the overall size
> of both the metadata and cache devices.  Adding <#total cache blocks>
> provides useful context for how much of the cache is used.
> 
> Unfortunately these additions to the status will require updates to
> users' scripts that monitor the cache status.  But these changes help
> provide more comprehensive information about the cache device and will
> simplify tools that are being developed to manage dm-cache devices --
> because they won't need to issue 3 operations to cobble together the
> information that we can easily provide via a single status ioctl.
> 
> While updating the status documentation in cache.txt spaces were
> tabify'd.
> 
> Requested-by: Jonathan Brassow <jbrassow@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  Documentation/device-mapper/cache.txt |   50 ++++++++++++++++++--------------
>  drivers/md/dm-cache-target.c          |   16 ++++++----
>  2 files changed, 38 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
> index 719320b..63fd7cf 100644
> --- a/Documentation/device-mapper/cache.txt
> +++ b/Documentation/device-mapper/cache.txt
> @@ -217,36 +217,42 @@ the characteristics of a specific policy, always request it by name.
>  Status
>  ------
>  
> -<#used metadata blocks>/<#total metadata blocks> <#read hits> <#read misses>
> -<#write hits> <#write misses> <#demotions> <#promotions> <#blocks in cache>
> -<#dirty> <#features> <features>* <#core args> <core args>* <#policy args>
> -<policy args>*
> -
> -#used metadata blocks    : Number of metadata blocks used
> -#total metadata blocks   : Total number of metadata blocks
> -#read hits               : Number of times a READ bio has been mapped
> +<metadata block size> <#used metadata blocks>/<#total metadata blocks>
> +<cache block size> <#used cache blocks>/<#total cache blocks>
> +<#read hits> <#read misses> <#write hits> <#write misses>
> +<#demotions> <#promotions> <#dirty> <#features> <features>*
> +<#core args> <core args>* <#policy args> <policy args>*
> +
> +metadata block size	 : Fixed block size for each metadata block in
> +			     sectors
> +#used metadata blocks	 : Number of metadata blocks used
> +#total metadata blocks	 : Total number of metadata blocks
> +cache block size	 : Configurable block size for the cache device
> +			     in sectors
> +#used cache blocks	 : Number of blocks resident in the cache
> +#total cache blocks	 : Total number of cache blocks
> +#read hits		 : Number of times a READ bio has been mapped
>  			     to the cache
> -#read misses             : Number of times a READ bio has been mapped
> +#read misses		 : Number of times a READ bio has been mapped
>  			     to the origin
> -#write hits              : Number of times a WRITE bio has been mapped
> +#write hits		 : Number of times a WRITE bio has been mapped
>  			     to the cache
> -#write misses            : Number of times a WRITE bio has been
> +#write misses		 : Number of times a WRITE bio has been
>  			     mapped to the origin
> -#demotions               : Number of times a block has been removed
> +#demotions		 : Number of times a block has been removed
>  			     from the cache
> -#promotions              : Number of times a block has been moved to
> +#promotions		 : Number of times a block has been moved to
>  			     the cache
> -#blocks in cache         : Number of blocks resident in the cache
> -#dirty                   : Number of blocks in the cache that differ
> +#dirty			 : Number of blocks in the cache that differ
>  			     from the origin
> -#feature args            : Number of feature args to follow
> -feature args             : 'writethrough' (optional)
> -#core args               : Number of core arguments (must be even)
> -core args                : Key/value pairs for tuning the core
> +#feature args		 : Number of feature args to follow
> +feature args		 : 'writethrough' (optional)
> +#core args		 : Number of core arguments (must be even)
> +core args		 : Key/value pairs for tuning the core
>  			     e.g. migration_threshold
> -#policy args             : Number of policy arguments to follow (must be even)
> -policy args              : Key/value pairs
> -			     e.g. 'sequential_threshold 1024
> +#policy args		 : Number of policy arguments to follow (must be even)
> +policy args		 : Key/value pairs
> +			     e.g. sequential_threshold
>  
>  Messages
>  --------
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 1b1469e..11ad705 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2826,9 +2826,10 @@ static void cache_resume(struct dm_target *ti)
>  /*
>   * Status format:
>   *
> - * <#used metadata blocks>/<#total metadata blocks>
> + * <metadata block size> <#used metadata blocks>/<#total metadata blocks>
> + * <cache block size> <#used cache blocks>/<#total cache blocks>
>   * <#read hits> <#read misses> <#write hits> <#write misses>
> - * <#demotions> <#promotions> <#blocks in cache> <#dirty>
> + * <#demotions> <#promotions> <#dirty>
>   * <#features> <features>*
>   * <#core args> <core args>
>   * <#policy args> <policy args>*
> @@ -2869,17 +2870,20 @@ static void cache_status(struct dm_target *ti, status_type_t type,
>  
>  		residency = policy_residency(cache->policy);
>  
> -		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u ",
> +		DMEMIT("%u %llu/%llu %u %llu/%llu %u %u %u %u %u %u %llu ",
> +		       (unsigned)(DM_CACHE_METADATA_BLOCK_SIZE >> SECTOR_SHIFT),
>  		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
>  		       (unsigned long long)nr_blocks_metadata,
> +		       cache->sectors_per_block,
> +		       (unsigned long long) from_cblock(residency),
> +		       (unsigned long long) from_cblock(cache->cache_size),
>  		       (unsigned) atomic_read(&cache->stats.read_hit),
>  		       (unsigned) atomic_read(&cache->stats.read_miss),
>  		       (unsigned) atomic_read(&cache->stats.write_hit),
>  		       (unsigned) atomic_read(&cache->stats.write_miss),
>  		       (unsigned) atomic_read(&cache->stats.demotion),
>  		       (unsigned) atomic_read(&cache->stats.promotion),
> -		       (unsigned long long) from_cblock(residency),
> -		       cache->nr_dirty);
> +		       (unsigned long long) from_cblock(cache->nr_dirty));
>  
>  		if (writethrough_mode(&cache->features))
>  			DMEMIT("1 writethrough ");
> @@ -3129,7 +3133,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  
>  static struct target_type cache_target = {
>  	.name = "cache",
> -	.version = {1, 2, 0},
> +	.version = {1, 3, 0},
>  	.module = THIS_MODULE,
>  	.ctr = cache_ctr,
>  	.dtr = cache_dtr,
> -- 
> 1.7.4.4
> 
