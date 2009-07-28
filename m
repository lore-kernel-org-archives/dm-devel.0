From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RESEND][PATCH] Send uevents for disk write_protect changes
Date: Tue, 28 Jul 2009 09:12:56 +0200
Message-ID: <20090728071256.GQ4148@kernel.dk>
References: <200907211128.07252.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753447AbZG1HM7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200907211128.07252.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 21 2009, Nikanth Karthikesan wrote:
> Hi
> 
> This patch is needed for the dm-multipath, so that the daemon can capture the 
> event and reload the dm table when the read-only setting of the disk changes. 
> Can this be merged?

Looks fine to me, merged for 2.6.32.

> 
> Thanks
> Nikanth
> 
> From: Hannes Reinecke <hare@suse.de>
> Subject: Send uevents for write_protect changes
> 
> Whenever a block device changes it's read-only attribute
> notify the userspace about it.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index f4c64c2..b89328e 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1215,6 +1215,16 @@ void put_disk(struct gendisk *disk)
>  
>  EXPORT_SYMBOL(put_disk);
>  
> +static void set_disk_ro_uevent(struct gendisk *gd, int ro)
> +{
> +	char event[] = "DISK_RO=1";
> +	char *envp[] = { event, NULL };
> +
> +	if (!ro)
> +		event[8] = '0';
> +	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
> +}
> +
>  void set_device_ro(struct block_device *bdev, int flag)
>  {
>  	bdev->bd_part->policy = flag;
> @@ -1227,8 +1237,12 @@ void set_disk_ro(struct gendisk *disk, int flag)
>  	struct disk_part_iter piter;
>  	struct hd_struct *part;
>  
> -	disk_part_iter_init(&piter, disk,
> -			    DISK_PITER_INCL_EMPTY | DISK_PITER_INCL_PART0);
> +	if (disk->part0.policy != flag) {
> +		set_disk_ro_uevent(disk, flag);
> +		disk->part0.policy = flag;
> +	}
> +
> +	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
>  	while ((part = disk_part_iter_next(&piter)))
>  		part->policy = flag;
>  	disk_part_iter_exit(&piter);
> 
> 

-- 
Jens Axboe
