From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 3/3] raid0: conditional mddev->queue access
	to suit dm-raid
Date: Tue, 21 Apr 2015 11:00:29 -0500
Message-ID: <5E3718B1-96FF-4531-8651-80E28360B424@redhat.com>
References: <1429274386-16385-4-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1429274386-16385-4-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids


> On Apr 17, 2015, at 7:39 AM, heinzm@redhat.com wrote:
> 
> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> This patch is a prerequisite for dm-raid "raid0" support to allow
> dm-raid to access the MD RAID0 personality doing unconditional
> accesses to mddev->queue, which is NULL in case of dm-raid stacked
> on top of MD.
> 
> This patch is here for completeness; it has been send to Neil Brown
> and linux-raid, Neil said he applied it on Feb 23rd but it did not
> show up in upstream as yet.
> 
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
> 
> ---
> drivers/md/raid0.c | 48 +++++++++++++++++++++++++++---------------------
> 1 file changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 3ed9f42..e074813 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -271,14 +271,16 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
> 		goto abort;
> 	}
> 
> -	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> -	blk_queue_io_opt(mddev->queue,
> -			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
> -
> -	if (!discard_supported)
> -		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> -	else
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> +	if (mddev->queue) {
> +		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> +		blk_queue_io_opt(mddev->queue,
> +				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
> +
> +		if (!discard_supported)
> +			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> +		else
> +			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> +	}
> 
> 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
> 	*private_conf = conf;
> @@ -429,9 +431,12 @@ static int raid0_run(struct mddev *mddev)
> 	}
> 	if (md_check_no_bitmap(mddev))
> 		return -EINVAL;
> -	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> -	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> -	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
> +
> +	if (mddev->queue) {
> +		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> +		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> +		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
> +	}
> 
> 	/* if private is not null, we are here after takeover */
> 	if (mddev->private == NULL) {
> @@ -448,16 +453,17 @@ static int raid0_run(struct mddev *mddev)
> 	printk(KERN_INFO "md/raid0:%s: md_size is %llu sectors.\n",
> 	       mdname(mddev),
> 	       (unsigned long long)mddev->array_sectors);
> -	/* calculate the max read-ahead size.
> -	 * For read-ahead of large files to be effective, we need to
> -	 * readahead at least twice a whole stripe. i.e. number of devices
> -	 * multiplied by chunk size times 2.
> -	 * If an individual device has an ra_pages greater than the
> -	 * chunk size, then we will not drive that device as hard as it
> -	 * wants.  We consider this a configuration error: a larger
> -	 * chunksize should be used in that case.
> -	 */
> -	{
> +
> +	if (mddev->queue) {
> +		/* calculate the max read-ahead size.
> +		 * For read-ahead of large files to be effective, we need to
> +		 * readahead at least twice a whole stripe. i.e. number of devices
> +		 * multiplied by chunk size times 2.
> +		 * If an individual device has an ra_pages greater than the
> +		 * chunk size, then we will not drive that device as hard as it
> +		 * wants.  We consider this a configuration error: a larger
> +		 * chunksize should be used in that case.
> +		 */
> 		int stripe = mddev->raid_disks *
> 			(mddev->chunk_sectors << 9) / PAGE_SIZE;
> 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)

fold in with conditionalization of gendisk structure?

 brassow
