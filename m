From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Fri, 18 Dec 2009 12:33:23 -0500
Message-ID: <20091218173322.GA4163@redhat.com>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Fri, Dec 18 2009 at  2:30am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> The dm device limits function passes the start sector within the block
> device to the block layer stacking function.  However, the partition's
> offset on the physical device is not added, resulting in incorrect
> alignment reporting.
> 
> Add the partition offset to the values passed to blk_stack_limits().
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Martin,

This is not required because DM assumes alignment_offset has already
been accounted for by the caller (e.g. LVM2 or some other ficitional DM
consumer).

Below, "start" represents the aligned start of the data for a given volume.
That start must have already been shifted by alignment_offset; as is the
case with lvm2 (>= 2.02.51), see the following lvm2 commits:
http://sources.redhat.com/git/gitweb.cgi?p=lvm2.git;a=commit;h=282029eb45e56
http://sources.redhat.com/git/gitweb.cgi?p=lvm2.git;a=commit;h=6c88b6c660020

All this being said, how did you arrive at this patch?  Why do you feel
it is needed?  Was it just from code inspection?

Regards,
Mike


> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index be62547..67efac9 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -495,6 +495,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  	struct queue_limits *limits = data;
>  	struct block_device *bdev = dev->bdev;
>  	struct request_queue *q = bdev_get_queue(bdev);
> +	sector_t offset = (get_start_sect(bdev) + start) << 9;
>  	char b[BDEVNAME_SIZE];
>  
>  	if (unlikely(!q)) {
> @@ -503,7 +504,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  		return 0;
>  	}
>  
> -	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
> +	if (blk_stack_limits(limits, &q->limits, offset) < 0)
>  		DMWARN("%s: target device %s is misaligned: "
>  		       "physical_block_size=%u, logical_block_size=%u, "
>  		       "alignment_offset=%u, start=%llu",
> @@ -511,7 +512,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  		       q->limits.physical_block_size,
>  		       q->limits.logical_block_size,
>  		       q->limits.alignment_offset,
> -		       (unsigned long long) start << 9);
> +		       (unsigned long long) offset);
>  
>  
>  	/*
