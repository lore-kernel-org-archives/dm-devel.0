From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
	status output
Date: Thu, 9 Jan 2014 15:28:13 -0600
Message-ID: <684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
References: <20140109210412.GA5288@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140109210412.GA5288@redhat.com>
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

Yes, that'd be nice if we could have this.

It would be great if chunk_size (i.e. cache block size) was also included somehow.  If I had that, I could calculate the size of the cache using the status output alone.  I won't complain much if it isn't there though, because I can get that from the mapping table.

The reason I like adding the total number of cache blocks is because I /can't/ get that information from either type of status (_INFO or _TABLE) for the cache target.  Instead, I would have to get the cache device from the mapping table and query that device for its size - possible, but the level of indirection is a pain.  As it sits in the kernel today, it seems strange to provide some information, but not enough to fill in the whole picture.

Speaking of values I can't compute with the _INFO and _TABLE status...  "block size" does not mean the same thing for the metadata and data numbers - one is in chunk_size and the other is in something else (neither seem to be in sectors, as is DM custom).  Honestly, I'm not very sure why the ratios are provided for the metadata area... who cares?  Is it info we don't need?  No-one has ever asked if the RAID or mirror log areas are mostly full.  I don't need to worry about overfilling, do I?

 brassow

On Jan 9, 2014, at 3:04 PM, Mike Snitzer wrote:

> Improve cache_status to emit <#used cache blocks>/<#total cache blocks>
> This provides useful context for the how much of the cache is used.
> 
> While updating the status documentation in cache.txt spaces were
> tabify'd.
> 
> Requested-by: Jonathan Brassow <jbrassow@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> Documentation/device-mapper/cache.txt |   46 +++++++++++++++++---------------
> drivers/md/dm-cache-target.c          |   10 ++++---
> 2 files changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
> index 0f41ccf..b52ac21 100644
> --- a/Documentation/device-mapper/cache.txt
> +++ b/Documentation/device-mapper/cache.txt
> @@ -216,36 +216,38 @@ the characteristics of a specific policy, always request it by name.
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
> +<#used metadata blocks>/<#total metadata blocks>
> +<#used cache blocks>/<#total cache blocks>
> +<#read hits> <#read misses> <#write hits> <#write misses>
> +<#demotions> <#promotions> <#dirty> <#features> <features>*
> +<#core args> <core args>* <#policy args> <policy args>*
> +
> +#used metadata blocks	 : Number of metadata blocks used
> +#total metadata blocks	 : Total number of metadata blocks
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
> index 167024b..4dee97c 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2832,8 +2832,9 @@ static void cache_resume(struct dm_target *ti)
>  * Status format:
>  *
>  * <#used metadata blocks>/<#total metadata blocks>
> + * <#used cache blocks>/<#total cache blocks>
>  * <#read hits> <#read misses> <#write hits> <#write misses>
> - * <#demotions> <#promotions> <#blocks in cache> <#dirty>
> + * <#demotions> <#promotions> <#dirty>
>  * <#features> <features>*
>  * <#core args> <core args>
>  * <#policy args> <policy args>*
> @@ -2874,17 +2875,18 @@ static void cache_status(struct dm_target *ti, status_type_t type,
> 
> 		residency = policy_residency(cache->policy);
> 
> -		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u ",
> +		DMEMIT("%llu/%llu %llu/%llu %u %u %u %u %u %u %llu ",
> 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
> 		       (unsigned long long)nr_blocks_metadata,
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
