From: Hannes Reinecke <hare@suse.de>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 08:46:35 +0100
Message-ID: <804df5df-2598-df69-757d-85df18185d4c@suse.de>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111021256.37490-3-snitzer@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 01/11/2018 03:12 AM, Mike Snitzer wrote:
> Since I can remember DM has forced the block layer to allow the
> allocation and initialization of the request_queue to be distinct
> operations.  Reason for this is block/genhd.c:add_disk() has requires
> that the request_queue (and associated bdi) be tied to the gendisk
> before add_disk() is called -- because add_disk() also deals with
> exposing the request_queue via blk_register_queue().
> 
> DM's dynamic creation of arbitrary device types (and associated
> request_queue types) requires the DM device's gendisk be available so
> that DM table loads can establish a master/slave relationship with
> subordinate devices that are referenced by loaded DM tables -- using
> bd_link_disk_holder().  But until these DM tables, and their associated
> subordinate devices, are known DM cannot know what type of request_queue
> it needs -- nor what its queue_limits should be.
> 
> This chicken and egg scenario has created all manner of problems for DM
> and, at times, the block layer.
> 
> Summary of changes:
> 
> - Add QUEUE_FLAG_DEFER_REG that a block driver can set to defer the
>   required blk_register_queue() until the block driver's request_queue
>   is fully initialized.
> 
> - Return early from blk_unregister_queue() if QUEUE_FLAG_REGISTERED
>   is not set.  It won't be set if a request_queue with
>   QUEUE_FLAG_DEFER_REG set never called blk_register_queue() -- as can
>   happen if a driver encounters an error and must del_gendisk() before
>   calling blk_register_queue().
> 
> - Export blk_register_queue().
> 
> These changes allow DM to use device_add_disk() to anchor its gendisk as
> the "master" for master/slave relationships DM must establish with
> subordinate devices referenced in DM tables that get loaded.  Once all
> "slave" devices for a DM device are known a request_queue can be
> properly initialized and then advertised via sysfs -- important
> improvement being that no request_queue resource initialization is
> missed -- before these changes DM was known to be missing blk-mq debugfs
> and proper block throttle initialization.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-sysfs.c      | 4 ++++
>  block/genhd.c          | 4 +++-
>  include/linux/blkdev.h | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 870484eaed1f..2395122875b4 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -921,6 +921,7 @@ int blk_register_queue(struct gendisk *disk)
>  	mutex_unlock(&q->sysfs_lock);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(blk_register_queue);
>  
>  void blk_unregister_queue(struct gendisk *disk)
>  {
> @@ -929,6 +930,9 @@ void blk_unregister_queue(struct gendisk *disk)
>  	if (WARN_ON(!q))
>  		return;
>  
> +	if (!test_bit(QUEUE_FLAG_REGISTERED, &disk->queue->queue_flags))
> +		return;
> +
>  	mutex_lock(&q->sysfs_lock);
>  	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
>  	mutex_unlock(&q->sysfs_lock);
Why can't we use test_and_clear_bit() here?
Shouldn't that relieve the need for the mutex_lock() here, too?

> diff --git a/block/genhd.c b/block/genhd.c
> index 00620e01e043..3912a82ecc4f 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -682,7 +682,6 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
>  				    exact_match, exact_lock, disk);
>  	}
>  	register_disk(parent, disk);
> -	blk_register_queue(disk);
>  
>  	/*
>  	 * Take an extra ref on queue which will be put on disk_release()
> @@ -692,6 +691,9 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
>  
>  	disk_add_events(disk);
>  	blk_integrity_add(disk);
> +
> +	if (!test_bit(QUEUE_FLAG_DEFER_REG, &disk->queue->queue_flags))
> +		blk_register_queue(disk);
>  }
>  EXPORT_SYMBOL(device_add_disk);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 71a9371c8182..84d144c7b025 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -681,6 +681,7 @@ struct request_queue {
>  #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
>  #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
>  #define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
> +#define QUEUE_FLAG_DEFER_REG	30	/* defer registering queue to a disk */
>  
>  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
> 
Where is this flag used?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
