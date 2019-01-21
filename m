From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/4] dm: fix redundant IO accounting for bios
 that need splitting
Date: Mon, 21 Jan 2019 11:52:04 +0800
Message-ID: <20190121035203.GC24610@ming.t460p>
References: <20190119180506.1300-1-snitzer@redhat.com>
	<20190119180506.1300-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190119180506.1300-3-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, NeilBrown <neilb@suse.com>
List-Id: dm-devel.ids

On Sat, Jan 19, 2019 at 01:05:04PM -0500, Mike Snitzer wrote:
> The risk of redundant IO accounting was not taken into consideration
> when commit 18a25da84354 ("dm: ensure bio submission follows a
> depth-first tree walk") introduced IO splitting in terms of recursion
> via generic_make_request().
> 
> Fix this by subtracting the split bio's payload from the IO stats that
> were already accounted for by start_io_acct() upon dm_make_request()
> entry.  This repeat oscillation of the IO accounting, up then down,
> isn't ideal but refactoring DM core's IO splitting to pre-split bios
> _before_ they are accounted turned out to be an excessive amount of
> change that will need a full development cycle to refine and verify.
> 
> Before this fix:
> 
>   /dev/mapper/stripe_dev is a 4-way stripe using a 32k chunksize, so
>   bios are split on 32k boundaries.
> 
>   # fio --name=16M --filename=/dev/mapper/stripe_dev --rw=write --bs=64k --size=16M \
>     	--iodepth=1 --ioengine=libaio --direct=1 --refill_buffers
> 
>   with debugging added:
>   [103898.310264] device-mapper: core: start_io_acct: dm-2 WRITE bio->bi_iter.bi_sector=0 len=128
>   [103898.318704] device-mapper: core: __split_and_process_bio: recursing for following split bio:
>   [103898.329136] device-mapper: core: start_io_acct: dm-2 WRITE bio->bi_iter.bi_sector=64 len=64
>   ...
> 
>   16M written yet 136M (278528 * 512b) accounted:
>   # cat /sys/block/dm-2/stat | awk '{ print $7 }'
>   278528
> 
> After this fix:
> 
>   16M written and 16M (32768 * 512b) accounted:
>   # cat /sys/block/dm-2/stat | awk '{ print $7 }'
>   32768
> 
> Fixes: 18a25da84354 ("dm: ensure bio submission follows a depth-first tree walk")
> Cc: stable@vger.kernel.org # 4.16+
> Reported-by: Bryan Gurney <bgurney@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fcb97b0a5743..fbadda68e23b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1584,6 +1584,9 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
>  	ci->sector = bio->bi_iter.bi_sector;
>  }
>  
> +#define __dm_part_stat_sub(part, field, subnd)	\
> +	(part_stat_get(part, field) -= (subnd))
> +
>  /*
>   * Entry point to split a bio into clones and submit them to the targets.
>   */
> @@ -1638,6 +1641,19 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  				struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
>  							  GFP_NOIO, &md->queue->bio_split);
>  				ci.io->orig_bio = b;
> +
> +				/*
> +				 * Adjust IO stats for each split, otherwise upon queue
> +				 * reentry there will be redundant IO accounting.
> +				 * NOTE: this is a stop-gap fix, a proper fix involves
> +				 * significant refactoring of DM core's bio splitting
> +				 * (by eliminating DM's splitting and just using bio_split)
> +				 */
> +				part_stat_lock();
> +				__dm_part_stat_sub(&dm_disk(md)->part0,
> +						   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
> +				part_stat_unlock();
> +
>  				bio_chain(b, bio);
>  				ret = generic_make_request(bio);
>  				break;

This ways is a bit ugly, but looks it works and it is simple, especially
DM target may accept partial bio, so:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming
