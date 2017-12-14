From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Wed, 13 Dec 2017 16:11:44 -0800
Message-ID: <4540fbf0-81e3-57b4-91e6-e33d5b5c578b@infradead.org>
References: <20171213213332.2914-1-scott.bauer@intel.com>
 <20171213213332.2914-2-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171213213332.2914-2-scott.bauer@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>, dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On 12/13/2017 01:33 PM, Scott Bauer wrote:
> This device mapper module remaps and unstripes IO so it lands
> solely on a single drive in a RAID 0/dm-stripe target.
> In a 4 drive RAID 0 the mapper exposes 1/4th of the LBA range
> as a virtual drive. Each IO to that virtual drive will land on
> only one of the 4 drives, selected by the user.
> 
> Signed-off-by: Scott Bauer <scott.bauer@intel.com>
> Acked-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/md/Kconfig       |  10 +++
>  drivers/md/Makefile      |   1 +
>  drivers/md/dm-unstripe.c | 204 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 215 insertions(+)
>  create mode 100644 drivers/md/dm-unstripe.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 83b9362be09c..948874fcc67c 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -269,6 +269,16 @@ config DM_BIO_PRISON
>  
>  source "drivers/md/persistent-data/Kconfig"
>  
> +config DM_UN_STRIPE
> +       tristate "Transpose IO to individual drives on a raid device"
> +       depends on BLK_DEV_DM
> +       ---help---
> +         Enable this feature if you with to unstripe I/O on a RAID 0
> +	 device to the respective drive. If your hardware has physical
> +	 RAID 0 this module can unstripe the I/O to respective sides.

Please use tabs (consistenly) at the beginning of each line (after "config").

> +
> +	 If unsure say N.
> +
>  config DM_CRYPT
>  	tristate "Crypt target support"
>  	depends on BLK_DEV_DM

> diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
> new file mode 100644
> index 000000000000..d1105e92bb3f
> --- /dev/null
> +++ b/drivers/md/dm-unstripe.c
> @@ -0,0 +1,204 @@
> +/*
> + * Copyright © 2017 Intel Corporation
> + *
> + * Authors:
> + *    Scott  Bauer      <scott.bauer@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include "dm.h"
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +#include <linux/slab.h>
> +#include <linux/bitops.h>
> +#include <linux/device-mapper.h>
> +
> +
> +struct unstripe {
> +	struct dm_dev *ddisk;
> +	sector_t chunk_sectors;
> +	sector_t stripe_sectors;
> +	u8 chunk_shift;
> +	u8 cur_drive;
> +};
> +
> +
> +#define DM_MSG_PREFIX "dm-unstripe"
> +static const char *parse_err = "Please provide the necessary information:"
> +	"<drive> <device (0 indexed)> <total_devices>"
> +	" <chunk size in 512B sectors || 0 to use max hw sector size>";
> +
> +/*
> + * Argument layout:
> + * <drive> <stripe/drive to extract (0 indexed)>
> + *         <total_devices> <chunk size in 512B sect>
> + */
> +static int set_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct block_device *bbdev;
> +	struct unstripe *target;
> +	unsigned int chunk_size;
> +	u64 tot_sec, mod;
> +	u8 cur_drive, tot_drives;
> +	char dummy;
> +	int ret;
> +
> +	if (argc != 4) {
> +		DMERR("%s", parse_err);
> +		return -EINVAL;
> +	}
> +
> +	if (sscanf(argv[1], "%hhu%c", &cur_drive, &dummy) != 1 ||
> +	    sscanf(argv[2], "%hhu%c", &tot_drives, &dummy) != 1 ||
> +	    sscanf(argv[3], "%u%c", &chunk_size, &dummy) != 1) {
> +		DMERR("%s", parse_err);
> +		return -EINVAL;
> +	}
> +
> +	if (tot_drives == 0 || (cur_drive > tot_drives && tot_drives > 1)) {

	                                  >=

> +		DMERR("Please provide a drive between [0,%hhu)", tot_drives);
> +		return -EINVAL;
> +	}
> +
> +	target = kzalloc(sizeof(*target), GFP_KERNEL);
> +
> +	if (!target) {
> +		DMERR("Failed to allocate space for DM unstripe!");
> +		return -ENOMEM;
> +	}
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &target->ddisk);
> +	if (ret) {
> +		kfree(target);
> +		DMERR("dm-unstripe dev lookup failure! for drive %s", argv[0]);
> +		return ret;
> +	}
> +
> +	bbdev = target->ddisk->bdev;
> +
> +	target->cur_drive = cur_drive;
> +	if (chunk_size)
> +		target->chunk_sectors = chunk_size;
> +	else
> +		target->chunk_sectors =
> +			queue_max_hw_sectors(bdev_get_queue(bbdev));
> +
> +	target->stripe_sectors = (tot_drives - 1) * target->chunk_sectors;
> +	target->chunk_shift = fls(target->chunk_sectors) - 1;
> +
> +	ret = dm_set_target_max_io_len(ti, target->chunk_sectors);
> +	if (ret) {
> +		dm_put_device(ti, target->ddisk);
> +		kfree(target);
> +		DMERR("Failed to set max io len!");
> +		return ret;
> +	}
> +	ti->private = target;
> +
> +	tot_sec = i_size_read(bbdev->bd_inode) >> SECTOR_SHIFT;
> +	mod = tot_sec % target->chunk_sectors;

Did you build this on 32-bit also?  Is that '%' OK on 32-bit?

> +
> +	if (ti->len == 1)
> +		ti->len = (tot_sec / tot_drives) - mod;
> +	ti->begin = 0;
> +	return 0;
> +}


-- 
~Randy
