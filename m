From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] dm: add asymmetric stripe target device dirver
Date: Mon, 25 Dec 2017 20:22:51 -0800
Message-ID: <c5b29845-3a96-db67-be2b-a75f734009f0@infradead.org>
References: <5a41c7d3.4662650a.ea76c.4e6c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5a41c7d3.4662650a.ea76c.4e6c@mx.google.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: tgvlcw@gmail.com, agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net
List-Id: dm-devel.ids

On 12/25/2017 07:52 PM, tgvlcw@gmail.com wrote:
> From: liuchaowei <tgvlcw@gmail.com>
> 
> This asymmetric stripe target device driver can achieve better io
> performance between those devices which possess different io performance
> 
> There are 2 storage device or flash devices: A and B, their sequential
> read permance are 220M/s and 315M/s inspectively, so their sequential

       performance                    respectively,

> read speed could be approximately equal to 2:3, if we use stripe type
> to combine these two devices, their layout could be showed below:
> --------------------------------------------------------
> |    A1    |    A2    |    B1    |    B2    |    B3    |
> --------------------------------------------------------
> 
> If we seletect asymmetric stripe type, their layout could be illustrated

        select

> follow:
> --------------------------------------------------------
> |         A1          |               B1               |
> --------------------------------------------------------
> 
> The former has 5 stripe devices and each stripe device has also equal
> chunk size, e.g.: 256secs. If there is a data block which size is
> 1280secs, so transfer the data to this stripe defvice will be split

                                                device

> to 5 ios which io size is 256secs. But if we use the asymmetric
> stripe device, it only has two stripe devices and each one has be
> setting in optimal chunk size, e.g.: ratio is 2:3, the first one
> optimal chunk size is 512secs, the second is 768secs.  And same
> 1280secs data block just only be splited two ios, this can be achieve

                                   split into two ios,

> perfect io performance.
> 
> Change-Id: Iebaee3480e27022e2b3a7edbfb65425b1166274e
> Signed-off-by: liuchaowei <tgvlcw@gmail.com>
> ---
>  Documentation/device-mapper/asymmetric-striped.txt |  85 ++++
>  drivers/md/Kconfig                                 |  11 +
>  drivers/md/Makefile                                |   1 +
>  drivers/md/dm-asymmetric-stripe.c                  | 523 +++++++++++++++++++++
>  drivers/md/dm.c                                    |   5 +
>  include/linux/device-mapper.h                      |  15 +
>  6 files changed, 640 insertions(+)
>  create mode 100644 Documentation/device-mapper/asymmetric-striped.txt
>  create mode 100644 drivers/md/dm-asymmetric-stripe.c
> 
> diff --git a/Documentation/device-mapper/asymmetric-striped.txt b/Documentation/device-mapper/asymmetric-striped.txt
> new file mode 100644
> index 000000000000..0412a224a49e
> --- /dev/null
> +++ b/Documentation/device-mapper/asymmetric-striped.txt
> @@ -0,0 +1,85 @@
> +dm-asymmetric-stripe
> +=========
> +
> +Device-Mapper's "asm-striped" target is used to create a striped (i.e. RAID-0)
> +device across one or more underlying devices. Data is written in "chunks",
> +with consecutive chunks rotating among the underlying devices. This can
> +potentially provide improved I/O throughput by utilizing several physical
> +devices in parallel. However, in order to gain maximum I/O performance bewteen

                                                                          between

> +slow and fast device, there is a ratio to set up the chunk size among these
> +device.
> +
> +Parameters: <num devs> <chunk size> <ratio> [<dev path> <offset>]+
> +<num devs>: Number of underlying devices.
> +<chunk size>: Size of each chunk of data. Must be at least as
> +large as the system's PAGE_SIZE.
> +<ratio>: The proportion of per io size, it is the times as much
> +as 1 chunk size
> +<dev path>: Full pathname to the underlying block-device, or a
> +"major:minor" device-number.
> +<offset>: Starting sector within the device.
> +
> +One or more underlying devices can be specified. The striped device
> +size must be a multiple of the chunk size multiplied by the number of underlying
> +devices. However, there is a ratio can be setting, e.g.: 2:3 means the first one

                     there is a ratio that can be set,

> +striped device optimal width size is 2 time as much as 1 chunk size, the second

                                          times

> +striped device is 3.
> +
> +
> +Example scripts
> +===============
> +
> +[[
> +#!/usr/bin/perl -w
> +# Create a striped device across any number of underlying devices. The device
> +# will be called "stripe_dev" and have a chunk-size of 128k.
> +
> +my $chunk_size = 128 * 2;
> +my $ratio = "2:3";
> +my $dev_name = "stripe_dev";
> +my $num_devs = @ARGV;
> +my @devs = @ARGV;
> +
> +if ($num_devs < 2) {
> +die("Specify at least two devices\n");
> +}
> +
> +
> +$stripe_average_size = 1073741824
> +$stripe_dev_size = $stripe_average_size * 5;
> +
> +$table = "0 $stripe_dev_size asm-striped $num_devs $chunk_size $ratio";
> +for ($i = 0; $i < $num_devs; $i++) {
> +$table .= " $devs[$i] 0";
> +}
> +
> +`echo $table | dmsetup create $dev_name`;
> +]]
> +
> +
> +Why asymmetric striped
> +=======================
> +Considering one case:
> +There are 2 storage device or flash devices: A and B, their sequential
> +read permance are 220M/s and 315M/s inspectively, so their sequential

        performance                    respectively,

> +read speed could be approximately equal to 2:3, if we use stripe type
> +to combine these two devices, their layout could be showed below:
> +--------------------------------------------------------
> +|    A1    |    A2    |    B1    |    B2    |    B3    |
> +--------------------------------------------------------
> +
> +If we seletect asymmetric stripe type, their layout could be illustrated

         select

> +follow:
> +--------------------------------------------------------
> +|         A1          |               B1               |
> +--------------------------------------------------------
> +
> +The former has 5 stripe devices and each stripe device has also equal
> +chunk size, e.g.: 256secs. If there is a data block which size is 1280secs,
> +so transfer the data to this stripe defvice will be split to 5 ios which io

                                       device

> +size is 256secs. But if we use the asymmetric stripe device, it only has two
> +stripe devices and each one has be setting in optimal chunk size, e.g.: ratio
> +is 2:3, the first one optimal chunk size is 512secs, the second is 768secs.
> +And same 1280secs data block just only be splited two ios, this can be achieve

                                             split into two ios,

> +perfect io performance.
> +
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 7d5aa2c5c81d..4232b929c2f3 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -455,6 +455,17 @@ config DM_FLAKEY
>         ---help---
>           A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_ASYMMETRIC_STRIPE
> +	tristate "DM asymmetric stripe(asymmetric raid0)"
> +	depends on BLK_DEV_DM
> +	---help---
> +	  This device-mapper target creates a asymmetric raid0/stripe device that
> +          support asymmetric stripe chunk size and can gain same performance as
> +          raid0 device

Align "support" and "raid0" under "This".  And end the sentence with a period (".").

> +
> +          You must configure the accurate ratio between different physical storage
> +          device respectively

End sentence with a period.

> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM

> diff --git a/drivers/md/dm-asymmetric-stripe.c b/drivers/md/dm-asymmetric-stripe.c
> new file mode 100644
> index 000000000000..4ef3915b435a
> --- /dev/null
> +++ b/drivers/md/dm-asymmetric-stripe.c
> @@ -0,0 +1,523 @@
> +/*
> + * Copyright (C) 2018 Smartisan, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: <tgvlcw@gmail.com>
> + * Name: Henry Liu
> + *
> + */
> +
> +
> +#include "dm.h"
> +#include <linux/device-mapper.h>
> +

#include <linux/atomic.h>

> +#include <linux/module.h>
> +#include <linux/init.h>

#include <linux/kernel.h>

> +#include <linux/blkdev.h>
> +#include <linux/bio.h>

#include <linux/bitops.h>

> +#include <linux/slab.h>
> +#include <linux/log2.h>

#include <linux/workqueue.h>

> +
> +#define DM_MSG_PREFIX "asm-striped"
> +#define DM_IO_ERROR_THRESHOLD 15

> +/*
> + * An event is triggered whenever a drive
> + * drops out of a stripe volume.
> + */
> +static void trigger_event(struct work_struct *work)
> +{
> +	asm_stripe_c *sc = container_of(work, asm_stripe_c, trigger_event);
> +
> +	dm_table_event(sc->ti->table);
> +}
> +
> +	static inline

Above line should not be indented.
Above and below should be on one line if <= 80 characters.

> +asm_stripe_c *alloc_context(unsigned int stripes)
> +{
> +	size_t len;
> +
> +	if (dm_array_too_big(sizeof(asm_stripe_c),
> +				sizeof(asm_stripe),
> +				stripes))
> +		return NULL;
> +
> +	len = sizeof(asm_stripe_c) + (sizeof(asm_stripe) * stripes);
> +
> +	return kmalloc(len, GFP_KERNEL);
> +}

> +static int set_stripe_ratio(struct dm_target *ti,
> +		asm_stripe_c *sc,
> +		char *ratio_str)
> +{
> +	char *p;
> +	unsigned int i;
> +	uint32_t r = 0, ratio;
> +	char *tmp_ratio = ratio_str;
> +
> +	if (sizeof(sc->ratio_str) < strlen(ratio_str)) {
> +		ti->error = "Too big stripe ratio string";
> +		return -ENOMEM;
> +	}
> +
> +	strlcpy(sc->ratio_str, ratio_str, strlen(ratio_str) + 1);
> +	for (i = 0; i < sc->stripes; i++) {
> +		p  = strsep(&tmp_ratio, ":");
> +		if (p == NULL)
> +			return -EINVAL;
> +
> +		if (kstrtouint(p, 10, &ratio) || !ratio)
> +			return -EINVAL;
> +
> +		sc->stripe[i].ratio = ratio;
> +		r += ratio;
> +	}
> +
> +	sc->total_ratio = r;
> +	sc->avg_width = ti->len / r;
> +	sc->stripe_size = r * sc->chunk_size;
> +
> +	return 0;
> +}

Insert blank line here.

> +/*
> + * Construct a striped mapping.
> + * <number of stripes> <chunk size> <ratio> [<dev_path> <offset>]+
> + */
> +static int asymmetric_stripe_ctr(struct dm_target *ti,
> +		unsigned int argc,
> +		char **argv)
> +{

[snip]


> +static void asymmetric_stripe_map_range_sector(asm_stripe_c *sc,
> +		sector_t sector,
> +		uint32_t target_stripe,
> +		sector_t *result)
> +{
> +	sector_t width_offset;
> +	uint32_t stripe;
> +
> +	width_offset = stripe_index_fetch(sc, &sector, &stripe);
> +
> +	*result = sector * sc->stripe[target_stripe].opt_io_size;
> +
> +	if (target_stripe < stripe)
> +		*result += sc->stripe[target_stripe].opt_io_size;
> +	else if (target_stripe == stripe)
> +		*result += width_offset;

Here you don't expect target_stripe ever to be > stripe, right?
Then the last "else if" can just be "else"...


> +}
> +


-- 
~Randy
