From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: Re: [PATCH-RFC] Bug in dm-raid1 as used by pvmove
Date: Thu, 18 May 2006 23:45:09 -0500
Message-ID: <e6862225c1d72fa1707005745fa9282f@redhat.com>
References: <17504.8384.533148.557081@cse.unsw.edu.au>
	<17517.7366.969023.850708@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17517.7366.969023.850708@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jonathan E Brassow <jbrassowredhatcom@suse.de>
List-Id: dm-devel.ids

Sorry for not responding... earlier.

I didn't need the test case, because the more I looked at it, the more 
obvious it became.  I also quickly discovered the compile bug, and 
mirror_map uses bio_ro_region now in newer kernels.

I've also check to make sure that it doesn't screw anything up when 
fault tolerance is included (see http://www.brassow.com/mirroring).  We 
had to check to ensure that if bio_map was called (which alters the bio 
and takes off the ti->begin) that a later function would not then call 
the updated bio_to_region - effectively subtracting off ti->begin 
twice.

thanks for the update though,
  brassow

On May 18, 2006, at 8:17 PM, Neil Brown wrote:

> On Tuesday May 9, Jonathan E Brassow wrote:
>> It looks reasonable at first glance, but I have to think about it
>> more.  Do you have a test case that I can reproduce with?
>
> Not really... The customer does, but I don't have precise details.
> I think is several drives, with several lvs across them, and active
> NFS activity on these.
> In this situation 'pvmove' everything off a device which contains a
> non-initial section of at least one of the lvs.  The active traffic on
> the filesystem in an important part of the test case I think.
>
> I have since found that not only didn't the original patch compile,
> but it wasn't complete either.
>
> The mirror_map function sets map_context->ll to a value which is
> effectively the same as bio_to_region.  As I changed bio_to_region, I
> need to change that assignment to.
>
> This is the current patch.  Note that the declaration of two structures
> needed to be moved up for it to compile.
>
> NeilBrown
>
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/dm-raid1.c |   63 
> ++++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
>
> diff ./drivers/md/dm-raid1.c~current~ ./drivers/md/dm-raid1.c
> --- ./drivers/md/dm-raid1.c~current~	2006-05-12 14:28:37.000000000 
> +1000
> +++ ./drivers/md/dm-raid1.c	2006-05-19 11:15:58.000000000 +1000
> @@ -106,12 +106,42 @@ struct region {
>  	struct bio_list delayed_bios;
>  };
>
> +
> +/*-----------------------------------------------------------------
> + * Mirror set structures.
> + *---------------------------------------------------------------*/
> +struct mirror {
> +	atomic_t error_count;
> +	struct dm_dev *dev;
> +	sector_t offset;
> +};
> +
> +struct mirror_set {
> +	struct dm_target *ti;
> +	struct list_head list;
> +	struct region_hash rh;
> +	struct kcopyd_client *kcopyd_client;
> +
> +	spinlock_t lock;	/* protects the next two lists */
> +	struct bio_list reads;
> +	struct bio_list writes;
> +
> +	/* recovery */
> +	region_t nr_regions;
> +	int in_sync;
> +
> +	struct mirror *default_mirror;	/* Default mirror */
> +
> +	unsigned int nr_mirrors;
> +	struct mirror mirror[0];
> +};
> +
>  /*
>   * Conversion fns
>   */
>  static inline region_t bio_to_region(struct region_hash *rh, struct 
> bio *bio)
>  {
> -	return bio->bi_sector >> rh->region_shift;
> +	return (bio->bi_sector - rh->ms->ti->begin) >> rh->region_shift;
>  }
>
>  static inline sector_t region_to_sector(struct region_hash *rh, 
> region_t region)
> @@ -539,35 +569,6 @@ static void rh_start_recovery(struct reg
>  	wake();
>  }
>
> -/*-----------------------------------------------------------------
> - * Mirror set structures.
> - *---------------------------------------------------------------*/
> -struct mirror {
> -	atomic_t error_count;
> -	struct dm_dev *dev;
> -	sector_t offset;
> -};
> -
> -struct mirror_set {
> -	struct dm_target *ti;
> -	struct list_head list;
> -	struct region_hash rh;
> -	struct kcopyd_client *kcopyd_client;
> -
> -	spinlock_t lock;	/* protects the next two lists */
> -	struct bio_list reads;
> -	struct bio_list writes;
> -
> -	/* recovery */
> -	region_t nr_regions;
> -	int in_sync;
> -
> -	struct mirror *default_mirror;	/* Default mirror */
> -
> -	unsigned int nr_mirrors;
> -	struct mirror mirror[0];
> -};
> -
>  /*
>   * Every mirror should look like this one.
>   */
> @@ -1113,7 +1114,7 @@ static int mirror_map(struct dm_target *
>  	struct mirror *m;
>  	struct mirror_set *ms = ti->private;
>
> -	map_context->ll = bio->bi_sector >> ms->rh.region_shift;
> +	map_context->ll = bio_to_region(&ms->rh, bio);
>
>  	if (rw == WRITE) {
>  		queue_bio(ms, bio, rw);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
