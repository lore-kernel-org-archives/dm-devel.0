Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42044C6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663778280;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dor0eGHyOIgR2X7ENMmx/2/0LBtaGg6982rLuZ46yG4=;
	b=cwAmNjseyyrj4eg6xZQuAeKgxvWyU4G5hBmA3+eI8fR1xWGP8txAwKHOiTNFaQqYmRH1rw
	WFU//o5LriswGyR83UcMRCXyoFnIcWgMpppk+6MR1+BJV8YfOsr2OkOfsJdkocWv68XqOo
	Jj9kK7G/TtUlemVofUNB++HEyVs/Sdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-TN0k0-V0P_WxM0EPrhrDdg-1; Wed, 21 Sep 2022 12:37:59 -0400
X-MC-Unique: TN0k0-V0P_WxM0EPrhrDdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DBE4800B30;
	Wed, 21 Sep 2022 16:37:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 52AC32027062;
	Wed, 21 Sep 2022 16:37:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C2F619465B1;
	Wed, 21 Sep 2022 16:37:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC73019465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 16:37:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6361F2027062; Wed, 21 Sep 2022 16:37:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE572027061
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 16:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 376668027FD
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 16:37:12 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-iJLKV-8YNaKlVsNWwv26Uw-1; Wed, 21 Sep 2022 12:37:09 -0400
X-MC-Unique: iJLKV-8YNaKlVsNWwv26Uw-1
Received: by mail-qk1-f199.google.com with SMTP id
 bp17-20020a05620a459100b006ce7f4bb0b7so4603018qkb.5
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 09:37:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=lqzqaP5jMRc9ul8czUeQa1CY6lTx+AewIdXg2AMrOqY=;
 b=aa7fzdnL2ZVGoAS3vwPRRMdg48qmkYcCILBLPt0lc8MmekNynmWIsZCKS+sJFPtfUf
 EszMmsZR5lj7SYwQbskAQKrU9AVIfnoOk2ly1L4AnfmyfrdnU7l0K3e6raKbpJ/VhwzD
 0YOhqJLBYW0YOaBzItumOP/Yo0WXhVKYQFsiAoJT6krZLnqNnHnxMcwxGwtxo7Dj+vqO
 SXi7NlK8D/Glxjb5GK9CEbdq3P+PczJ69fhJC46AmY5Cf8KPn58ZMyRF1weiMAlX3VyO
 U4vGu8v1ynFXPLfxt1UtDSbVwKOpmyvAragXxrnuYrXXEGBL84rmYVDepRUXNksuHQyk
 h2wQ==
X-Gm-Message-State: ACrzQf0pdFa8xg9F2ggI0UUGGMoilcYvyPVyAnTyZaTZ9hCpAVNMm90I
 XSoPJFcn9V6yzcZ369BqC1eegLpYJ4P3NDWcBfi35md1PoE1DmR/FOGF4uwSThoJ+C5XaCA8nhl
 UWX8Er+WOpNyB6g==
X-Received: by 2002:a05:622a:30e:b0:35c:e8a6:a556 with SMTP id
 q14-20020a05622a030e00b0035ce8a6a556mr14071819qtw.467.1663778228384; 
 Wed, 21 Sep 2022 09:37:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM73ar8vwn+/9ZPLcWA6EkpKeKs46ioSv3qzivY5dXWi+h/4WTEEx97j1Ng5CPvwi80ruOPMAw==
X-Received: by 2002:a05:622a:30e:b0:35c:e8a6:a556 with SMTP id
 q14-20020a05622a030e00b0035ce8a6a556mr14071765qtw.467.1663778227809; 
 Wed, 21 Sep 2022 09:37:07 -0700 (PDT)
Received: from localhost ([217.138.198.196]) by smtp.gmail.com with ESMTPSA id
 g22-20020ac87d16000000b00342f844e30fsm2195205qtb.31.2022.09.21.09.37.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 09:37:07 -0700 (PDT)
Date: Wed, 21 Sep 2022 12:37:05 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <Yys9sTqCIzxVFwyX@redhat.com>
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d@eucas1p2.samsung.com>
 <20220920091119.115879-14-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220920091119.115879-14-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v14 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 20 2022 at  5:11P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Only zoned devices with power-of-2(po2) number of sectors per zone(zone
> size) were supported in linux but now non power-of-2(npo2) zone sizes
> support has been added to the block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zone
> sizes, it was suggested to create a dm target for npo2 zone size device to
> appear as a po2 zone size target so that file systems can initially
> work without any explicit changes.
> 
> The design of this target is very simple: remap the device zone size to
> the zone capacity and change the zone size to be the nearest power of 2
> value.
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
> The area between target's zone capacity and zone size will be emulated
> in the target.
> The read IOs that fall in the emulated gap area will return 0 filled
> bio and all the other IOs in that area will result in an error.
> If a read IO span across the emulated area boundary, then the IOs are
> split across them. All other IO operations that span across the emulated
> area boundary will result in an error.
> 
> The target can be easily created as follows:
> dmsetup create <label> --table '0 <size_sects> po2zoned /dev/nvme<id>'
> 
> The target does not support partial mapping of the underlying
> device as there is no use-case for it.
> 
> Note:
> This target is not related to dm-zoned target, which exposes a zoned block
> device as a regular block device without any write constraint.
> 
> This target only exposes a different zone size than the underlying device.
> The underlying device's other constraints will be directly exposed to the
> target.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> ---
>  .../admin-guide/device-mapper/dm-po2zoned.rst |  79 +++++
>  .../admin-guide/device-mapper/index.rst       |   1 +
>  drivers/md/Kconfig                            |  10 +
>  drivers/md/Makefile                           |   2 +
>  drivers/md/dm-po2zoned-target.c               | 291 ++++++++++++++++++
>  5 files changed, 383 insertions(+)
>  create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zoned.rst
>  create mode 100644 drivers/md/dm-po2zoned-target.c
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-po2zoned.rst b/Documentation/admin-guide/device-mapper/dm-po2zoned.rst
> new file mode 100644
> index 000000000000..8a35eab0b714
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/dm-po2zoned.rst
> @@ -0,0 +1,79 @@
> +===========
> +dm-po2zoned
> +===========
> +The dm-po2zoned device mapper target exposes a zoned block device with a
> +non-power-of-2(npo2) number of sectors per zone as a power-of-2(po2)
> +number of sectors per zone(zone size).
> +The filesystems that support zoned block devices such as F2FS and BTRFS
> +assume po2 zone size as the kernel has traditionally only supported
> +those devices. However, as the kernel now supports zoned block devices with
> +npo2 zone sizes, the filesystems can run on top of the dm-po2zoned target before
> +adding native support.
> +
> +Partial mapping of the underlying device is not supported by this target as
> +there is no use-case for it.
> +
> +.. note::
> +   This target is **not related** to **dm-zoned target**, which exposes a
> +   zoned block device as a regular block device without any write constraint.
> +
> +   This target only exposes a different **zone size** than the underlying device.
> +   The underlying device's other **constraints** will be exposed to the target.
> +
> +Algorithm
> +=========
> +The device mapper target maps the underlying device's zone size to the
> +zone capacity and changes the zone size to the nearest po2 zone size.
> +The gap between the zone capacity and the zone size is emulated in the target.
> +E.g., a zoned block device with a zone size (and capacity) of 3M will have an
> +equivalent target layout with mapping as follows:
> +
> +::
> +
> +  0M           3M  4M        6M 8M
> +  |             |  |          |  |
> +  +x------------+--+x---------+--+x-------  Target
> +  |x            |  |x         |  |x
> +   x               x             x
> +   x               x             x
> +   x              x             x
> +   x             x             x
> +  |x            |x            |x
> +  +x------------+x------------+x----------  Device
> +  |             |             |
> +  0M           3M            6M
> +
> +A simple remap is performed for all the BIOs that do not cross the
> +emulation gap area, i.e., the area between the zone capacity and size.
> +
> +If a BIO lies in the emulation gap area, the following operations are performed:
> +
> +	Read:
> +		- If the BIO lies entirely in the emulation gap area, then zero out the BIO and complete it.
> +		- If the BIO spans the emulation gap area, split the BIO across the zone capacity boundary
> +                  and remap only the BIO within the zone capacity boundary. The other part of the split BIO
> +                  will be zeroed out.
> +
> +	Other operations:
> +                - Return an error
> +
> +Table parameters
> +================
> +
> +::
> +
> +  <dev path>
> +
> +Mandatory parameters:
> +
> +    <dev path>:
> +        Full pathname to the underlying block-device, or a
> +        "major:minor" device-number.
> +
> +Examples
> +========
> +
> +::
> +
> +  #!/bin/sh
> +  echo "0 `blockdev --getsz $1` po2zoned $1" | dmsetup create po2z
> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
> index cde52cc09645..5df93711cef5 100644
> --- a/Documentation/admin-guide/device-mapper/index.rst
> +++ b/Documentation/admin-guide/device-mapper/index.rst
> @@ -23,6 +23,7 @@ Device Mapper
>      dm-service-time
>      dm-uevent
>      dm-zoned
> +    dm-po2zoned
>      era
>      kcopyd
>      linear
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdbc4e..74fdfd02ab5f 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -518,6 +518,16 @@ config DM_FLAKEY
>  	help
>  	 A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_PO2ZONED
> +	tristate "Zoned block devices target emulating a power-of-2 number of sectors per zone"
> +	depends on BLK_DEV_DM
> +	depends on BLK_DEV_ZONED
> +	help
> +	  A target that converts a zoned block device with non-power-of-2(npo2)
> +	  number of sectors per zone to be power-of-2(po2). Use this target for
> +	  zoned block devices with npo2 number of sectors per zone until native
> +	  support is added to the filesystems and applications.
> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 84291e38dca8..ee05722bc637 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -26,6 +26,7 @@ dm-era-y	+= dm-era-target.o
>  dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
>  dm-verity-y	+= dm-verity-target.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
> +dm-po2zoned-y	+= dm-po2zoned-target.o
>  
>  md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
> @@ -60,6 +61,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> +obj-$(CONFIG_DM_PO2ZONED)	+= dm-po2zoned.o
>  obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
>  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
>  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
> diff --git a/drivers/md/dm-po2zoned-target.c b/drivers/md/dm-po2zoned-target.c
> new file mode 100644
> index 000000000000..1d2f46a594f8
> --- /dev/null
> +++ b/drivers/md/dm-po2zoned-target.c
> @@ -0,0 +1,291 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/device-mapper.h>
> +
> +#define DM_MSG_PREFIX "po2zoned"
> +
> +struct dm_po2z_target {
> +	struct dm_dev *dev;
> +	sector_t zone_size; /* Actual zone size of the underlying dev*/
> +	sector_t zone_size_po2; /* zone_size rounded to the nearest po2 value */
> +	unsigned int zone_size_po2_shift;
> +	sector_t zone_size_diff; /* diff between zone_size_po2 and zone_size */
> +	unsigned int nr_zones;
> +};
> +
> +static inline unsigned int npo2_zone_no(struct dm_po2z_target *dmh,
> +					sector_t sect)
> +{
> +	return div64_u64(sect, dmh->zone_size);
> +}
> +
> +static inline unsigned int po2_zone_no(struct dm_po2z_target *dmh,
> +				       sector_t sect)
> +{
> +	return sect >> dmh->zone_size_po2_shift;
> +}
> +
> +static inline sector_t device_to_target_sect(struct dm_target *ti,
> +					     sector_t sect)
> +{
> +	struct dm_po2z_target *dmh = ti->private;
> +
> +	return sect + (npo2_zone_no(dmh, sect) * dmh->zone_size_diff) +
> +	       ti->begin;
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
> +	if (argc != 1)
> +		return -EINVAL;
> +
> +	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
> +	if (!dmh)
> +		return -ENOMEM;
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &dmh->dev);
> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		goto bad;
> +	}
> +
> +	if (!bdev_is_zoned(dmh->dev->bdev)) {
> +		DMERR("%pg is not a zoned device", dmh->dev->bdev);
> +		ret = -EINVAL;
> +		goto bad;
> +	}
> +
> +	zone_size = bdev_zone_sectors(dmh->dev->bdev);
> +	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
> +	if (ti->len != dev_capacity) {
> +		DMERR("%pg Partial mapping of the target is not supported",
> +		      dmh->dev->bdev);
> +		ret = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (is_power_of_2(zone_size))
> +		DMWARN("%pg: underlying device has a power-of-2 number of sectors per zone",
> +		       dmh->dev->bdev);
> +
> +	dmh->zone_size = zone_size;
> +	dmh->zone_size_po2 = 1 << get_count_order_long(zone_size);
> +	dmh->zone_size_po2_shift = ilog2(dmh->zone_size_po2);
> +	dmh->zone_size_diff = dmh->zone_size_po2 - dmh->zone_size;
> +	ti->private = dmh;
> +	ti->max_io_len = dmh->zone_size_po2;
> +	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
> +	ti->len = dmh->zone_size_po2 * dmh->nr_zones;
> +	return 0;
> +
> +bad:
> +	kfree(dmh);
> +	return ret;
> +}

This error handling still isn't correct.  You're using
dm_get_device().  If you return early due to error, _after_
dm_get_device(), you need to dm_put_device().

Basically you need a new label above "bad:" that calls dm_put_device()
then falls through to "bad:".  Or you need to explcitly call
dm_put_device() before "goto bad;" in the if (ti->len != dev_capacity)
error branch.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

