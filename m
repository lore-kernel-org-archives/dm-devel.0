Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8188BC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660152723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=90S6dLqwPw3Yezf16mOmEHTj+sgfN1jcXQlJ46DjcL0=;
	b=K7e3ksVK1tO/xC1tfsN5rnvIV33hFAZyBeVp7FsmUlPb/ZXhffNPZrMoi6LfXId16kiyWU
	LrFa16kIRJtC0ltL8Nw6EcHCfYlBkL7swlFMLNmIl5dNIL7THKkTp3K3im8F+e9Atd3A0M
	dq8sKAEgjkJEjRFSLx7Y4h1t6g/dUpU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-G1FiRm5aMIqhLBr-LUf7Ig-1; Wed, 10 Aug 2022 13:32:00 -0400
X-MC-Unique: G1FiRm5aMIqhLBr-LUf7Ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09D031C0BDED;
	Wed, 10 Aug 2022 17:31:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8DD5F2166B26;
	Wed, 10 Aug 2022 17:31:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43D2A1946A50;
	Wed, 10 Aug 2022 17:31:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B7581946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 17:31:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56BA3400DFA6; Wed, 10 Aug 2022 17:31:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B3B404754B
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:31:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37D12811E87
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:31:56 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-BTIQbvcWMUC0Us1ZHnXHug-2; Wed, 10 Aug 2022 13:31:54 -0400
X-MC-Unique: BTIQbvcWMUC0Us1ZHnXHug-2
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="320462059"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 01:31:53 +0800
IronPort-SDR: WarLaoAWL5HkTah6WITuBwmfJ6HvWSrK319VfQoATLBoQ0TTWTHbgwiQpezlFXLrzXQsDoX+RG
 ZARwOFJ1FkyxR1jZKP9lALY4BlotkNGb1V0y1Mmaum2m986F+9RtmQuZvzEIO9NM/BXG/TiEpf
 b2iXXxBH7a8fa14vD7TSMb1X24j1yGIq61+s+OXUJS+OdM5iQNf41CY9TJ+HiNb1RrXGaMqyr7
 DYjm1HkkCkiHdre2iYph/FtdOs5Yi3uUMMbdXlANZOeNKKZLq9HSxDnkBPd7VSF8upsW6Jzkj7
 EJa3HBzHIERHULPw5o+SmF23
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:52:48 -0700
IronPort-SDR: NDHZkXls+PWGhrigFHBn0ENGEipgjK/wdPKgcTEojFJXExs8BbZHTAAnPAiOjvI1KWuWFOSbop
 yckDe66yIE1gjmZw9hZ5fw2JOFGSRz7stMUVt6m0um7HE8ZqX+1XFmJrJcst4GPLmvhs5c7OvM
 ij6S8+Eyph7PwvnW9Olj5pWvEC65T8II9EfrVfjKcAajnXEwA1kC9E1jFNW7j6Yz7JtzWbvchc
 NVw/GLmvmdVKvFhfMSjNWufvx6cBlut6tmoiKoMYg56OlGC3LXoHDbHVzlpQUkVOwAN6Ws9i9t
 vx8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 10:31:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2xnh5lV2z1Rw4L
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 10:31:52 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id buTbjHH-IB4x for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 10:31:49 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2xnc6NWnz1RtVk;
 Wed, 10 Aug 2022 10:31:48 -0700 (PDT)
Message-ID: <b73143fd-107d-177d-d647-f17a32b9423e@opensource.wdc.com>
Date: Wed, 10 Aug 2022 10:31:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094816eucas1p1890ceb4faebaf4f0cdbc9581d1308672@eucas1p1.samsung.com>
 <20220803094801.177490-14-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v9 13/13] dm: add power-of-2 target for zoned
 devices with non power-of-2 zone sizes
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:48, Pankaj Raghav wrote:
> Only zoned devices with power-of-2(po2) zone sizes were supported in linux
> but now non power-of-2(npo2) zone sizes support has been added to the
> block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zone
> sizes, it was suggested to create a dm target for npo2 zone size device to
> appear as a po2 size zoned target so that file systems can initially work
> without any explicit changes by using this target.
> 
> The design of this target is very simple: remap the device zone size to
> the zone capacity and change the zone size to be the nearest power of 2
> number of sectors.
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
> dmsetup create <label> --table '0 <size_sects> po2zone /dev/nvme<id>'
> 
> Note that the target does not support partial mapping of the underlying
> device.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> ---
>  .../admin-guide/device-mapper/dm-po2zone.rst  |  71 ++++++
>  .../admin-guide/device-mapper/index.rst       |   1 +
>  drivers/md/Kconfig                            |  10 +
>  drivers/md/Makefile                           |   2 +
>  drivers/md/dm-po2zone-target.c                | 240 ++++++++++++++++++
>  5 files changed, 324 insertions(+)
>  create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zone.rst
>  create mode 100644 drivers/md/dm-po2zone-target.c
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-po2zone.rst b/Documentation/admin-guide/device-mapper/dm-po2zone.rst
> new file mode 100644
> index 000000000000..b2c240697e00
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/dm-po2zone.rst
> @@ -0,0 +1,71 @@
> +==========
> +dm-po2zone
> +==========
> +The dm-po2zone device mapper target exposes a zoned block device with a
> +non-power-of-2(npo2) zone number of sectors as a power-of-2(po2) zone number

s/zone number of sectors/number of sectors per zone (zone size)

> +of sectors.
> +The filesystems that support zoned block devices such as F2FS and BTRFS
> +assume po2 zone size sectors as the kernel has traditionally only supported
> +those devices. However, as the kernel now supports zoned block devices with
> +npo2 zone size sectors, the dm-po2zone target can be used by the filesystems
> +before adding native support.

filesystems will not "use" the target. The user has to set up the target first
and the filesystem will run on top of it. Detail, but rewording this make it
clear that this is not an automatic thing magically happening.

Not that your patch series is lacking f2fs and btrfs patches to check for the
power of 2 zone size of the zoned device. Unless these checks are already in place ?

> +
> +Partial mapping of the underlying device is not supported by this target.
> +
> +Algorithm
> +=========
> +The device mapper target maps the underlying device's zone size to the
> +zone capacity and changes the zone size to the nearest po2 number of sectors.
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
> +If a BIO crosses the emulation gap area, the following operations are performed:
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
> +  echo "0 `blockdev --getsz $1` po2zone $1" | dmsetup create po2z
> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
> index cde52cc09645..1fd04b5b0565 100644
> --- a/Documentation/admin-guide/device-mapper/index.rst
> +++ b/Documentation/admin-guide/device-mapper/index.rst
> @@ -23,6 +23,7 @@ Device Mapper
>      dm-service-time
>      dm-uevent
>      dm-zoned
> +    dm-po2zone
>      era
>      kcopyd
>      linear
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdbc4e..7cdd2d03ba7d 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -518,6 +518,16 @@ config DM_FLAKEY
>  	help
>  	 A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_PO2ZONE
> +	tristate "Power-of-2 zone number of sectors target for zoned block devices"

Hmm... Not super clear. What about something like:

Zoned block devices target emulating a power-of-2 number of sectors per zone

> +	depends on BLK_DEV_DM
> +	depends on BLK_DEV_ZONED
> +	help
> +	  A target that converts a zoned block device with non-power-of-2(npo2) zone
> +	  number of sectors to be power-of-2(po2). Use this target for zoned block
> +	  devices with npo2 zone number of sectors until native support is added to
> +	  the filesystems and applications.
> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 84291e38dca8..c23f81cc8789 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -26,6 +26,7 @@ dm-era-y	+= dm-era-target.o
>  dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
>  dm-verity-y	+= dm-verity-target.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
> +dm-po2zone-y	+= dm-po2zone-target.o
>  
>  md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
> @@ -60,6 +61,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> +obj-$(CONFIG_DM_PO2ZONE)	+= dm-po2zone.o
>  obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
>  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
>  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
> diff --git a/drivers/md/dm-po2zone-target.c b/drivers/md/dm-po2zone-target.c
> new file mode 100644
> index 000000000000..64c4c0611ddf
> --- /dev/null
> +++ b/drivers/md/dm-po2zone-target.c
> @@ -0,0 +1,240 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/device-mapper.h>
> +
> +#define DM_MSG_PREFIX "po2zone"
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
> +static inline sector_t target_to_device_sect(struct dm_po2z_target *dmh,
> +					     sector_t sect)
> +{
> +	return sect - (po2_zone_no(dmh, sect) * dmh->zone_size_diff);
> +}
> +
> +static inline sector_t device_to_target_sect(struct dm_po2z_target *dmh,
> +					     sector_t sect)
> +{
> +	return sect + (npo2_zone_no(dmh, sect) * dmh->zone_size_diff);
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
> +

No need for this blank line.

> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		kfree(dmh);
> +		return ret;
> +	}
> +
> +	zone_size = bdev_zone_sectors(dmh->dev->bdev);
> +	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
> +	if (ti->len != dev_capacity || ti->begin) {
> +		DMERR("%pg Partial mapping of the target not supported",
> +		      dmh->dev->bdev);
> +		kfree(dmh);
> +		return -EINVAL;
> +	}
> +
> +	if (is_power_of_2(zone_size))
> +		DMWARN("%pg:not a useful target for devices with po2 zone number of sectors",

DMWARN("%pg: underlying device has a power-of-2 number of sectors per zone",

?

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
> +	unsigned int zone_idx = po2_zone_no(dmh, bio->bi_iter.bi_sector);
> +	sector_t nr_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +
> +	return (bio->bi_iter.bi_sector + nr_sectors) >
> +	       (zone_idx * dmh->zone_size_po2) + dmh->zone_size;

Better use a bit shift here instead of the multiplication.

> +}
> +
> +static int dm_po2z_map_read_emulated_area(struct dm_po2z_target *dmh,
> +					  struct bio *bio)
> +{
> +	sector_t start_sect = bio->bi_iter.bi_sector;
> +	unsigned int zone_idx = po2_zone_no(dmh, start_sect);
> +	sector_t relative_sect_in_zone = start_sect - (zone_idx * dmh->zone_size_po2);

Same here: bit shift instead of multiplication.

> +	sector_t split_io_pos;
> +
> +	/*
> +	 * If the starting sector is in the emulated area then fill
> +	 * all the bio with zeros. If bio is across emulated zone boundary,
> +	 * split the bio across boundaries and fill zeros only for the
> +	 * bio that is between the zone capacity and the zone size.
> +	 */
> +	if (relative_sect_in_zone < dmh->zone_size) {
> +		split_io_pos = (zone_idx * dmh->zone_size_po2) + dmh->zone_size;
> +		dm_accept_partial_bio(bio, split_io_pos - start_sect);
> +		bio->bi_iter.bi_sector = target_to_device_sect(dmh, start_sect);
> +
> +		return DM_MAPIO_REMAPPED;
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
> +		if (!bio_across_emulated_zone_area(dmh, bio)) {
> +			bio->bi_iter.bi_sector = target_to_device_sect(dmh,
> +								       bio->bi_iter.bi_sector);
> +			return DM_MAPIO_REMAPPED;
> +		}
> +		/*
> +		 * Read operation on the emulated zone area (between zone capacity
> +		 * and zone size) will fill the bio with zeroes. Any other operation
> +		 * in the emulated area should return an error.
> +		 */
> +		if (bio_op(bio) == REQ_OP_READ)
> +			return dm_po2z_map_read_emulated_area(dmh, bio);
> +
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
> +	.name = "po2zone",
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
> +	return dm_register_target(&dm_po2z_target);
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


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

