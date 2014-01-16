From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2 for-3.14] dm cache: add block sizes and
	total cache blocks to status output
Date: Wed, 15 Jan 2014 19:16:08 -0600
Message-ID: <4DBC7936-62EF-475A-AAFF-B8B6977DD4E8@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
	<20140109221323.GA5555@redhat.com>
	<20140109235506.GA6154@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140109235506.GA6154@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

I know I'm pushing my luck...

Is it too late to ask for just one more thing?  Would you also consider printing the policy name in the status (INFO)?
  <policy_name> <#policy args> <policy args>

This is especially useful when you pass in "default" in the CTR, because you cannot get this value from anywhere... right?

 brassow


On Jan 9, 2014, at 5:55 PM, Mike Snitzer wrote:

> Improve cache_status to emit:
> <metadata block size> <#used metadata blocks>/<#total metadata blocks>
> <cache block size> <#used cache blocks>/<#total cache blocks>
> ...
> 
> Adding the block sizes allows for easier calculation of the overall size
> of both the metadata and cache devices.  Adding <#total cache blocks>
> provides useful context for how much of the cache is used.
> 
> While updating the status documentation in cache.txt spaces were
> tabify'd.
> 
> Requested-by: Jonathan Brassow <jbrassow@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> Documentation/device-mapper/cache.txt |   48 ++++++++++++++++++---------------
> drivers/md/dm-cache-target.c          |   14 ++++++---
> 2 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
> index 719320b..742c4eb 100644
> --- a/Documentation/device-mapper/cache.txt
> +++ b/Documentation/device-mapper/cache.txt
> @@ -217,36 +217,40 @@ the characteristics of a specific policy, always request it by name.
> Status
> ------
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
> +metadata block size	 : Fixed block size for each metadata block
> +#used metadata blocks	 : Number of metadata blocks used
> +#total metadata blocks	 : Total number of metadata blocks
> +cache block size	 : Configurable block size for the cache device
> +#used cache blocks	 : Number of blocks resident in the cache
> +#total cache blocks	 : Total number of cache blocks
> +#read hits		 : Number of times a READ bio has been mapped
> 			     to the cache
> -#read misses             : Number of times a READ bio has been mapped
> +#read misses		 : Number of times a READ bio has been mapped
> 			     to the origin
> -#write hits              : Number of times a WRITE bio has been mapped
> +#write hits		 : Number of times a WRITE bio has been mapped
> 			     to the cache
> -#write misses            : Number of times a WRITE bio has been
> +#write misses		 : Number of times a WRITE bio has been
> 			     mapped to the origin
> -#demotions               : Number of times a block has been removed
> +#demotions		 : Number of times a block has been removed
> 			     from the cache
> -#promotions              : Number of times a block has been moved to
> +#promotions		 : Number of times a block has been moved to
> 			     the cache
> -#blocks in cache         : Number of blocks resident in the cache
> -#dirty                   : Number of blocks in the cache that differ
> +#dirty			 : Number of blocks in the cache that differ
> 			     from the origin
> -#feature args            : Number of feature args to follow
> -feature args             : 'writethrough' (optional)
> -#core args               : Number of core arguments (must be even)
> -core args                : Key/value pairs for tuning the core
> +#feature args		 : Number of feature args to follow
> +feature args		 : 'writethrough' (optional)
> +#core args		 : Number of core arguments (must be even)
> +core args		 : Key/value pairs for tuning the core
> 			     e.g. migration_threshold
> -#policy args             : Number of policy arguments to follow (must be even)
> -policy args              : Key/value pairs
> -			     e.g. 'sequential_threshold 1024
> +#policy args		 : Number of policy arguments to follow (must be even)
> +policy args		 : Key/value pairs
> +			     e.g. sequential_threshold
> 
> Messages
> --------
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 1b1469e..9ad7a2f 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2826,9 +2826,10 @@ static void cache_resume(struct dm_target *ti)
> /*
>  * Status format:
>  *
> - * <#used metadata blocks>/<#total metadata blocks>
> + * <metadata block size> <#used metadata blocks>/<#total metadata blocks>
> + * <cache block size> <#used cache blocks>/<#total cache blocks>
>  * <#read hits> <#read misses> <#write hits> <#write misses>
> - * <#demotions> <#promotions> <#blocks in cache> <#dirty>
> + * <#demotions> <#promotions> <#dirty>
>  * <#features> <features>*
>  * <#core args> <core args>
>  * <#policy args> <policy args>*
> @@ -2869,17 +2870,20 @@ static void cache_status(struct dm_target *ti, status_type_t type,
> 
> 		residency = policy_residency(cache->policy);
> 
> -		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u ",
> +		DMEMIT("%u %llu/%llu %u %llu/%llu %u %u %u %u %u %u %llu ",
> +		       (unsigned)(DM_CACHE_METADATA_BLOCK_SIZE >> SECTOR_SHIFT),
> 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
> 		       (unsigned long long)nr_blocks_metadata,
> +		       cache->sectors_per_block,
> +		       (unsigned long long) from_cblock(residency),
> +		       (unsigned long long) from_cblock(cache->cache_size),
> 		       (unsigned) atomic_read(&cache->stats.read_hit),
> 		       (unsigned) atomic_read(&cache->stats.read_miss),
> 		       (unsigned) atomic_read(&cache->stats.write_hit),
> 		       (unsigned) atomic_read(&cache->stats.write_miss),
> 		       (unsigned) atomic_read(&cache->stats.demotion),
> 		       (unsigned) atomic_read(&cache->stats.promotion),
> -		       (unsigned long long) from_cblock(residency),
> -		       cache->nr_dirty);
> +		       (unsigned long long) from_cblock(cache->nr_dirty));
> 
> 		if (writethrough_mode(&cache->features))
> 			DMEMIT("1 writethrough ");
> -- 
> 1.7.4.4
> 
