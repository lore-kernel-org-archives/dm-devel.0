Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA51C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 04:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658982835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4hegd5KLtVXg3bc8s+5kLKZOe96NzWIIV2xWIEP3LFk=;
	b=ikgqmDfqqx8Xw10cFZTZTHsAziHgD+puDLbWpDb2F0rAzAskYvX5Ov9lQaiTOhbuh3v1Wj
	5xLQlnhy8qxFjvemcuEoSCunfBT9a/lNXx4RNaxfBz8VUMiC+BuA0ye9yByaYOBkdD/AY4
	XFvbPqJKx8g42pFgk6d4fMM9uc2s2Mc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-zVxsZAEMPjqd9XnbnRv2qQ-1; Thu, 28 Jul 2022 00:33:52 -0400
X-MC-Unique: zVxsZAEMPjqd9XnbnRv2qQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B9D8380390C;
	Thu, 28 Jul 2022 04:33:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7650CC04482;
	Thu, 28 Jul 2022 04:33:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5719B1945DAD;
	Thu, 28 Jul 2022 04:33:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9AC131945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 04:33:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BA192166B29; Thu, 28 Jul 2022 04:33:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 869152166B26
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 04:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6535F803520
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 04:33:46 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-Q2pDsaQzNkenLq2GA7oMRg-1; Thu, 28 Jul 2022 00:33:44 -0400
X-MC-Unique: Q2pDsaQzNkenLq2GA7oMRg-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="319209026"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 12:33:21 +0800
IronPort-SDR: aaeq43CqZM5HmX+5LFwpygRUqDbe3RT30AsNpBiUVbHm4F4eBHj7ZEZWbeBl+khxkRg6TSfaYb
 8K0JqVdEq3aCvhGtc9J5y+NqukDd4DHyM/oNJMtQpjYaQ/F381V9QD4U0CmjJNGH5tEU+F0ORi
 /1hsKYZtCDpHwmE4lBJUI2XAa2dPUOmRTmyNB2ogQakujJ66lkGssBsfbDTgu0wDdF/ja8icmX
 z0TeoR+o5mQiBNPx4Ph5S/hplI6JjcTvLzP2H16ZvMLi/USQXPotIKUQoVRVT5J85hrggJwmvc
 95o0kG38LxOhyY192uVcc39W
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:54:32 -0700
IronPort-SDR: xP03APbcigP/hiSv7kZD7WJhsF6yoXlSVwZEIsL3cQyJ/qFVSaXQU1nhoN+YTkJqXY57vMqtfk
 +3xziOgPvsm1zdAeFlP7/TIR9gAsH5nHI4KJm+HdS2gnl+z4tcBY7RzNS7UIhWDjv4i2XIul9F
 154PbHs8z4CDxBlQ7jkjk2uQZjaCOFDt2Yj2Lxm5sUcnUjKozWlcrx5755qa7C18/Zitlqtl4I
 Q7vW5wqLX5Cc9e3zUd5O4OQJq2uZHslESwsHzLu580b0cuVmdp+pmcNZ/EpR425Sb8kpgDISnf
 CoE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 21:33:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ltd7P1CRKz1Rwnm
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 21:33:20 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id l3xMxqvogxA6 for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 21:33:16 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ltd7G0cPXz1RtVk;
 Wed, 27 Jul 2022 21:33:13 -0700 (PDT)
Message-ID: <8fc11ae3-ddc4-4509-5374-04722a740bde@opensource.wdc.com>
Date: Thu, 28 Jul 2022 13:33:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162257eucas1p2848a75c4aa7e559abb5d9ae0fbd374c1@eucas1p2.samsung.com>
 <20220727162245.209794-12-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-12-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 11/11] dm: add power-of-2 zoned target for
 non-power-of-2 zoned devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> Only power-of-2(po2) zoned devices were supported in linux but now non
> power-of-2(npo2) zoned device support has been added to the block layer.

Please rephrase this spelling out "zone size" in the text. As mentioned
before, "power-of-2(po2) zoned devices" is very unclear to people not
familiar with zoned block devices.

> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zoned
> devices, it was suggested to create a dm target for npo2 zoned device to
> appear as a po2 target so that file systems can initially work without any
> explicit changes by using this target.
> 
> The design of this target is very simple: introduce gaps between the
> underlying device's zone size and the nearest po2 device zone size.
> Device's actual zone size becomes the zone capacity of the target and
> device's nearest po2 zone size becomes the target's zone size.

The design of this target is very simple: remap the device zone size to
the zone capacity and change the zone size to be the nearest power of 2
numner of sectors.

> 
> For e.g., a device with a zone size/capacity of 3M will have an equivalent
> target layout as follows:
> 
> Device layout :-
> zone capacity = 3M
> zone size = 3M
> 
> |--------------|-------------|
> 0             3M            6M
> 
> Target layout :-
> zone capacity=3M
> zone size = 4M
> 
> |--------------|---|--------------|---|
> 0             3M  4M             7M  8M
> 
> All IOs will be remapped from target to the actual device location.

That is what DM does... Instead of this obvious statement, explain how the
remapping is done.

> 
> The area between target's zone capacity and zone size will be emulated
> in the target.
> The read IOs that fall in the emulated gap area will return 0 filled
> bio and all the other IOs in that area will result in an error.
> If a read IO span across the emulated area boundary, then the IOs are
> split across them. All other IO operations that span across the emulated
> area boundary will result in an error.
> 
> The target can be easily created as follows:
> dmsetup create <label> --table '0 <size_sects> po2z /dev/nvme<id>'

0 -> <start offset> ? Or are you allowing only entire devices ?

> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/Kconfig            |   9 ++
>  drivers/md/Makefile           |   2 +
>  drivers/md/dm-po2z-target.c   | 261 ++++++++++++++++++++++++++++++++++
>  drivers/md/dm-table.c         |  13 +-
>  drivers/md/dm-zone.c          |   1 +
>  include/linux/device-mapper.h |   9 ++
>  6 files changed, 292 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/md/dm-po2z-target.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdbc4e..d58ccfee765b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -518,6 +518,15 @@ config DM_FLAKEY
>  	help
>  	 A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_PO2Z

Maybe DM_PO2_ZONE ?

or DM_ZONE_PO2SIZE ?

To be clearer...

> +	tristate "Power-of-2 target for non power-of-2 zoned devices"

...for zoned block devices with a zone size that is not a power of 2
number of sectors.

> +	depends on BLK_DEV_DM
> +	depends on BLK_DEV_ZONED
> +	help
> +	  A target that converts a zoned device with non power-of-2 zone size to
> +	  be power of 2. This is done by introducing gaps in between the zone

...to have zones with size equal to a power of 2 n umber of sectors. And
drop the "This done...".
How the target works and how to use it should be documented under
Documentation/admin-guide/device-mapper/

> +	  capacity and the power of 2 zone size.
> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 270f694850ec..98af4ed98f73 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -26,6 +26,7 @@ dm-era-y	+= dm-era-target.o
>  dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
>  dm-verity-y	+= dm-verity-target.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
> +dm-po2z-y       += dm-po2z-target.o

dm-po2zone ?

Spelling out "zone" makes things clearer I think.

>  
>  md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
> @@ -60,6 +61,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> +obj-$(CONFIG_DM_PO2Z)		+= dm-po2z.o
>  obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
>  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
>  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
> diff --git a/drivers/md/dm-po2z-target.c b/drivers/md/dm-po2z-target.c
> new file mode 100644
> index 000000000000..e9c5b7d00eda
> --- /dev/null
> +++ b/drivers/md/dm-po2z-target.c
> @@ -0,0 +1,261 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/device-mapper.h>
> +
> +#define DM_MSG_PREFIX "po2z"

s/po2z/po2zone ?

> +
> +struct dm_po2z_target {
> +	struct dm_dev *dev;
> +	sector_t zone_size; /* Actual zone size of the underlying dev*/
> +	sector_t zone_size_po2; /* zone_size rounded to the nearest po2 value */
> +	sector_t zone_size_diff; /* diff between zone_size_po2 and zone_size */
> +	u32 nr_zones;

s/u32/unsigned int. This is not a hw driver.

> +};
> +
> +static inline u32 npo2_zone_no(struct dm_po2z_target *dmh, sector_t sect)
> +{
> +	return div64_u64(sect, dmh->zone_size);
> +}
> +
> +static inline u32 po2_zone_no(struct dm_po2z_target *dmh, sector_t sect)
> +{
> +	return sect >> ilog2(dmh->zone_size_po2);

You could saves the shift as "zone_size_po2_shift" in struct dm_po2z_target.

> +}
> +
> +static inline sector_t target_to_device_sect(struct dm_po2z_target *dmh,
> +					     sector_t sect)
> +{
> +	u32 zone_idx = po2_zone_no(dmh, sect);
> +
> +	return sect - (zone_idx * dmh->zone_size_diff);

The idx variable seems unnecessary. And use unsgined int, not u32.

> +}
> +
> +static inline sector_t device_to_target_sect(struct dm_po2z_target *dmh,
> +					     sector_t sect)
> +{
> +	u32 zone_idx = npo2_zone_no(dmh, sect);
> +
> +	return sect + (zone_idx * dmh->zone_size_diff);

same.

> +}
> +
> +/*
> + * This target works on the complete zoned device. Partial mapping is not
> + * supported.
> + * Construct a zoned po2 logical device: <dev-path>
> + */
> +static int dm_po2z_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct dm_po2z_target *dmh = NULL;
> +	int ret;
> +	sector_t zone_size;
> +	sector_t dev_capacity;
> +
> +	if (argc < 1)

	if (argc != 1) ?

> +		return -EINVAL;
> +
> +	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
> +	if (!dmh)
> +		return -ENOMEM;
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &dmh->dev);
> +
> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		return ret;

You are leaking dmh.

> +	}
> +
> +	zone_size = bdev_zone_sectors(dmh->dev->bdev);
> +	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
> +	if (ti->len != dev_capacity || ti->begin) {
> +		DMERR("%pg Partial mapping of the target not supported",
> +		      dmh->dev->bdev);

dmh is leaked.

> +		return -EINVAL;
> +	}
> +
> +	if (is_power_of_2(zone_size)) {
> +		DMERR("%pg: this target is not useful for power-of-2 zoned devices",
> +		      dmh->dev->bdev);
> +		return -EINVAL;

Same here.

And as suggested before, we could simply warn here but let the target be
created. If used with a power of 2 zone size device, it should still work.

> +	}
> +
> +	dmh->zone_size = zone_size;
> +	dmh->zone_size_po2 = 1 << get_count_order_long(zone_size);
> +	dmh->zone_size_diff = dmh->zone_size_po2 - dmh->zone_size;
> +	ti->private = dmh;
> +	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
> +	ti->len = dmh->zone_size_po2 * dmh->nr_zones;
> +
> +	return 0;
> +}
> +
> +static int dm_po2z_report_zones_cb(struct blk_zone *zone, unsigned int idx,
> +				   void *data)
> +{
> +	struct dm_report_zones_args *args = data;
> +	struct dm_po2z_target *dmh = args->tgt->private;
> +
> +	zone->start = device_to_target_sect(dmh, zone->start);
> +	zone->wp = device_to_target_sect(dmh, zone->wp);

You could simplify this to a single call to device_to_target_sect() by
saving the diff between device zone start and remapped zone start and add
that diff to the wp field.

> +	zone->len = dmh->zone_size_po2;
> +	args->next_sector = zone->start + zone->len;
> +
> +	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
> +}
> +
> +static int dm_po2z_report_zones(struct dm_target *ti,
> +				struct dm_report_zones_args *args,
> +				unsigned int nr_zones)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +	sector_t sect = po2_zone_no(dmh, args->next_sector) * dmh->zone_size;
> +
> +	return blkdev_report_zones(dmh->dev->bdev, sect, nr_zones,
> +				   dm_po2z_report_zones_cb, args);
> +}
> +
> +static int dm_po2z_end_io(struct dm_target *ti, struct bio *bio,
> +			  blk_status_t *error)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	if (bio->bi_status == BLK_STS_OK && bio_op(bio) == REQ_OP_ZONE_APPEND)
> +		bio->bi_iter.bi_sector =
> +			device_to_target_sect(dmh, bio->bi_iter.bi_sector);
> +
> +	return DM_ENDIO_DONE;
> +}
> +
> +static void dm_po2z_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	limits->chunk_sectors = dmh->zone_size_po2;
> +}
> +
> +static bool bio_across_emulated_zone_area(struct dm_po2z_target *dmh,
> +					  struct bio *bio)
> +{
> +	u32 zone_idx = po2_zone_no(dmh, bio->bi_iter.bi_sector);
> +	sector_t size = bio->bi_iter.bi_size >> SECTOR_SHIFT;

Rename that to nr_sectors to be clear about the unit.

> +
> +	return (bio->bi_iter.bi_sector - (zone_idx * dmh->zone_size_po2) +
> +		size) > dmh->zone_size;

This is hard to read and actually seems very wrong. Shouldn't this be simply:

	return bio->bi_iter.bi_sector + nr_sectors >
		zone_idx * dmh->zone_size_po2 + dmh->zone_size;

Thatis, check that the BIO goes beyond the zone capacity of the target.
?

> +}
> +
> +static int dm_po2z_map_read(struct dm_po2z_target *dmh, struct bio *bio)
> +{
> +	sector_t start_sect, size, relative_sect_in_zone, split_io_pos;
> +	u32 zone_idx;
> +
> +	/*
> +	 * Read does not extend into the emulated zone area (area between
> +	 * zone capacity and zone size)
> +	 */
> +	if (!bio_across_emulated_zone_area(dmh, bio)) {

hu... why not use dm_accept_partial_bio() in dm_po2z_map() to never have
to deal with this here ? That is, dm_po2z_map_read() is called for any
read BIO fully within the zone capacity. And create a
dm_po2z_map_read_zero() helper for any read BIO that is after the zone
capacity. Way simpler I think.

> +		bio->bi_iter.bi_sector =
> +			target_to_device_sect(dmh, bio->bi_iter.bi_sector);
> +		return DM_MAPIO_REMAPPED;
> +	}
> +
> +	start_sect = bio->bi_iter.bi_sector;
> +	size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +	zone_idx = po2_zone_no(dmh, start_sect);
> +	relative_sect_in_zone = start_sect - (zone_idx * dmh->zone_size_po2);
> +
> +	/*
> +	 * If the starting sector is in the emulated area then fill
> +	 * all the bio with zeros. If bio is across emulated zone boundary,
> +	 * split the bio across boundaries and fill zeros only for the
> +	 * bio that is between the zone capacity and the zone size.
> +	 */
> +	if (relative_sect_in_zone < dmh->zone_size &&
> +	    ((relative_sect_in_zone + size) > dmh->zone_size)) {
> +		split_io_pos = (zone_idx * dmh->zone_size_po2) + dmh->zone_size;
> +		dm_accept_partial_bio(bio, split_io_pos - start_sect);

See above. Do that in dm_po2z_map(). This will simplify this function.

> +		bio->bi_iter.bi_sector = target_to_device_sect(dmh, start_sect);
> +
> +		return DM_MAPIO_REMAPPED;
> +	} else if (relative_sect_in_zone >= dmh->zone_size &&
> +		   ((relative_sect_in_zone + size) > dmh->zone_size_po2)) {

No need for the else after return. And this can NEVER happen since BIOs
can never cross zone boundaries.

> +		split_io_pos = (zone_idx + 1) * dmh->zone_size_po2;
> +		dm_accept_partial_bio(bio, split_io_pos - start_sect);
> +	}
> +
> +	zero_fill_bio(bio);
> +	bio_endio(bio);
> +	return DM_MAPIO_SUBMITTED;
> +}
> +
> +static int dm_po2z_map(struct dm_target *ti, struct bio *bio)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	bio_set_dev(bio, dmh->dev->bdev);
> +	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
> +		/*
> +		 * Read operation on the emulated zone area (between zone capacity
> +		 * and zone size) will fill the bio with zeroes. Any other operation
> +		 * in the emulated area should return an error.
> +		 */
> +		if (bio_op(bio) == REQ_OP_READ)
> +			return dm_po2z_map_read(dmh, bio);
> +
> +		if (!bio_across_emulated_zone_area(dmh, bio)) {
> +			bio->bi_iter.bi_sector = target_to_device_sect(dmh,
> +								       bio->bi_iter.bi_sector);
> +			return DM_MAPIO_REMAPPED;
> +		}
> +		return DM_MAPIO_KILL;
> +	}
> +	return DM_MAPIO_REMAPPED;
> +}
> +
> +static int dm_po2z_iterate_devices(struct dm_target *ti,
> +				   iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +	sector_t len = dmh->nr_zones * dmh->zone_size;
> +
> +	return fn(ti, dmh->dev, 0, len, data);
> +}
> +
> +static struct target_type dm_po2z_target = {
> +	.name = "po2z",
> +	.version = { 1, 0, 0 },
> +	.features = DM_TARGET_ZONED_HM | DM_TARGET_EMULATED_ZONES,
> +	.map = dm_po2z_map,
> +	.end_io = dm_po2z_end_io,
> +	.report_zones = dm_po2z_report_zones,
> +	.iterate_devices = dm_po2z_iterate_devices,
> +	.module = THIS_MODULE,
> +	.io_hints = dm_po2z_io_hints,
> +	.ctr = dm_po2z_ctr,
> +};
> +
> +static int __init dm_po2z_init(void)
> +{
> +	int r = dm_register_target(&dm_po2z_target);
> +
> +	if (r < 0)
> +		DMERR("register failed %d", r);
> +
> +	return r;

Simplify:

	return dm_register_target(&dm_po2z_target);

> +}
> +
> +static void __exit dm_po2z_exit(void)
> +{
> +	dm_unregister_target(&dm_po2z_target);
> +}
> +
> +/* Module hooks */
> +module_init(dm_po2z_init);
> +module_exit(dm_po2z_exit);
> +
> +MODULE_DESCRIPTION(DM_NAME "power-of-2 zoned target");
> +MODULE_AUTHOR("Pankaj Raghav <p.raghav@samsung.com>");
> +MODULE_LICENSE("GPL");
> +

the changes below should be a different prep patch.

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 534fddfc2b42..d77feff124af 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1614,13 +1614,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  	return true;
>  }
>  
> -static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
> +/*
> + * Callback function to check for device zone sector across devices. If the
> + * DM_TARGET_EMULATED_ZONES target feature flag is not set, then the target
> + * should have the same zone sector as the underlying devices.
> + */
> +static int check_valid_device_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
>  					   sector_t start, sector_t len, void *data)
>  {
>  	unsigned int *zone_sectors = data;
>  
> -	if (!bdev_is_zoned(dev->bdev))
> +	if (!bdev_is_zoned(dev->bdev) ||
> +	    dm_target_supports_emulated_zones(ti->type))
>  		return 0;
> +
>  	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
>  }
>  
> @@ -1646,7 +1653,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
>  	if (!zone_sectors)
>  		return -EINVAL;
>  
> -	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
> +	if (dm_table_any_dev_attr(t, check_valid_device_zone_sectors, &zone_sectors)) {
>  		DMERR("%s: zone sectors is not consistent across all zoned devices",
>  		      dm_device_name(t->md));
>  		return -EINVAL;
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 31c16aafdbfc..2b6b3883471f 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -302,6 +302,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	if (dm_table_supports_zone_append(t)) {
>  		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
>  		dm_cleanup_zoned_dev(md);
> +
>  		return 0;
>  	}
>  
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 920085dd7f3b..7dbd28b8de01 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -294,6 +294,15 @@ struct target_type {
>  #define dm_target_supports_mixed_zoned_model(type) (false)
>  #endif
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +#define DM_TARGET_EMULATED_ZONES	0x00000400
> +#define dm_target_supports_emulated_zones(type) \
> +	((type)->features & DM_TARGET_EMULATED_ZONES)
> +#else
> +#define DM_TARGET_EMULATED_ZONES	0x00000000
> +#define dm_target_supports_emulated_zones(type) (false)
> +#endif
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

