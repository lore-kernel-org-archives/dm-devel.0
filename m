Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994CDC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660150994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kVlpEXHerjhF9TmM8AZSHmh3DgLbbxL+Jtm/X/3C7hI=;
	b=eS7gLCzz0aDpf/i7rxQhucn/riNEpumwBlqfiFlgr+i3vxZIz0yYPVk7rLP5CTgCIQT7DT
	zghaglEUNWiJOAWwhxMSJCiIzDSShpvQrYaPIaWSmp/2RuKO4QlMuBUMg/g0cBbZOURipY
	IUpk4RrJyxecAou57OdIvSv08jNKLoA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-2dCbAJ-ZML2dQK7-LrMrPw-1; Wed, 10 Aug 2022 13:03:11 -0400
X-MC-Unique: 2dCbAJ-ZML2dQK7-LrMrPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E2B41C0BDF0;
	Wed, 10 Aug 2022 17:03:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1569BC15BA1;
	Wed, 10 Aug 2022 17:03:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C46BA1946A50;
	Wed, 10 Aug 2022 17:03:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25B301946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 17:03:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1575C407F3A7; Wed, 10 Aug 2022 17:03:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1156E407F3A6
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:03:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA5D51C0BDEE
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:03:06 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-vxjsJ4iwPvK3Fq70se-Gqw-1; Wed, 10 Aug 2022 13:03:05 -0400
X-MC-Unique: vxjsJ4iwPvK3Fq70se-Gqw-1
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="208916982"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 01:03:04 +0800
IronPort-SDR: KJEgp8MHHiRfHpnb4gf+57S4NaV5aVYuAfXnMyhITYraqa5MaqmzOORNM+zSdIA9f9ZrPzo0/a
 PIfo7TvUO2xfPrevkgZSx01yJXwDbaq9nyjv0n4FLjdzTaqkTMtpigiX9/23ep31LE6MPXakkD
 ZieKMso3V9elHMWfZiK1gj2rYIMVKLUDZC+HymNMvK4msanY2uCVt1bWpZuhg5qrkZ6CaHtJFk
 2ebTwTFteR1xLnekmkge16S48JDEc5tDXeEPRP8lV2sftzBeCYqaX78BJ7WLxxKgu59habxFT2
 1gmcc2C/VlbJbq1J1Lnr++Cw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:18:39 -0700
IronPort-SDR: mpivN+uREPytkPjhhvldMmJLPN2DUEdtfRj4J6hoLddPN6ho0j7QfKvRpBWptJSLfD75PxKJdP
 7BsdBG8NkSRstpEBijFmZweiD89RJDOOccj7ZbTRHADf0dg9miMXwfV2JYfVLKJZ2VOWS0wS7V
 qSnvYk/f3ZfhwPhadPbJxFrJZ0lXyIc0tqPpIymMrmPPX1hPWfZLoxHFChUdLHluxEw9+AG2n2
 PgOJKMVBsapLiiu6lgA/WrCXTVO8N6atUapW4LOcghrnzZ0AEMIWfhYJPfhz7OiDMUKr5xORGT
 Pe0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 10:03:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2x8R3Lnxz1Rw4L
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 10:03:03 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id iHps1L3fUMz5 for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 10:03:02 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2x8P5ybyz1RtVk;
 Wed, 10 Aug 2022 10:03:01 -0700 (PDT)
Message-ID: <d7343e70-cbfa-4163-a78e-963fbf3bb38c@opensource.wdc.com>
Date: Wed, 10 Aug 2022 10:03:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83@eucas1p1.samsung.com>
 <20220803094801.177490-4-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v9 03/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:47, Pankaj Raghav wrote:
> Checking if a given sector is aligned to a zone is a common
> operation that is performed for zoned devices. Add
> bdev_is_zone_start helper to check for this instead of opencoding it
> everywhere.
> 
> Convert the calculations on zone size to be generic instead of relying on
> power-of-2(po2) based arithmetic in the block layer using the helpers
> wherever possible.
> 
> The only hot path affected by this change for zoned devices with po2
> zone size is in blk_check_zone_append() but bdev_is_zone_start() helper is
> used to optimize the calculation for po2 zone sizes.
> 
> Finally, allow zoned devices with non po2 zone sizes provided that their
> zone capacity and zone size are equal. The main motivation to allow zoned
> devices with non po2 zone size is to remove the unmapped LBA between
> zone capcity and zone size for devices that cannot have a po2 zone
> capacity.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-core.c       |  2 +-
>  block/blk-zoned.c      | 24 ++++++++++++++++++------
>  include/linux/blkdev.h | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a0d1104c5590..1cb519220ffb 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -563,7 +563,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
>  	    !bio_zone_is_seq(bio))
>  		return BLK_STS_IOERR;
>  
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index dce9c95b4bcd..665b822d13f9 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -285,10 +285,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
>  		return -EINVAL;
>  
>  	/* Check alignment (handle eventual smaller last zone) */
> -	if (sector & (zone_sectors - 1))
> +	if (!bdev_is_zone_start(bdev, sector))
>  		return -EINVAL;
>  
> -	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
> +	if (!bdev_is_zone_start(bdev, nr_sectors) && end_sector != capacity)
>  		return -EINVAL;
>  
>  	/*
> @@ -486,14 +486,26 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>  	 * smaller last zone.
>  	 */
>  	if (zone->start == 0) {
> -		if (zone->len == 0 || !is_power_of_2(zone->len)) {
> -			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
> -				disk->disk_name, zone->len);
> +		if (zone->len == 0) {
> +			pr_warn("%s: Invalid zero zone size", disk->disk_name);
> +			return -ENODEV;
> +		}
> +
> +		/*
> +		 * Non power-of-2 zone size support was added to remove the
> +		 * gap between zone capacity and zone size. Though it is technically
> +		 * possible to have gaps in a non power-of-2 device, Linux requires
> +		 * the zone size to be equal to zone capacity for non power-of-2
> +		 * zoned devices.
> +		 */
> +		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
> +			pr_err("%s: Invalid zone capacity: %lld with non power-of-2 zone size: %lld",
> +			       disk->disk_name, zone->capacity, zone->len);
>  			return -ENODEV;
>  		}
>  
>  		args->zone_sectors = zone->len;
> -		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
> +		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
>  	} else if (zone->start + args->zone_sectors < capacity) {
>  		if (zone->len != args->zone_sectors) {
>  			pr_warn("%s: Invalid zoned device with non constant zone size\n",
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 22f97427b60b..5aa15172299d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -709,6 +709,30 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  	return div64_u64(sector, zone_sectors);
>  }
>  
> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
> +						   sector_t sec)
> +{
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
> +	u64 remainder = 0;
> +
> +	if (!bdev_is_zoned(bdev))
> +		return 0;
> +
> +	if (is_power_of_2(zone_sectors))
> +		return sec & (zone_sectors - 1);
> +
> +	div64_u64_rem(sec, zone_sectors, &remainder);
> +	return remainder;
> +}
> +
> +static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))
> +		return false;
> +
> +	return bdev_offset_from_zone_start(bdev, sec) == 0;
> +}
> +
>  static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
>  	if (!blk_queue_is_zoned(disk->queue))
> @@ -753,6 +777,12 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
>  	return 0;
>  }
> +
> +static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
> +{
> +	return false;
> +}

Is this one really necessary ? Any caller of this would also depend on
CONFIG_BLK_DEV_ZONED and not compiled if not enabled. So there should be no
callers of this for the !CONFIG_BLK_DEV_ZONED case.

> +
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

