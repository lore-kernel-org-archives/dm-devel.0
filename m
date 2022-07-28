Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E58C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658977674;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZVTt/vR/AxzmnTU29hVc5mG7k+NvMexGJggMtusN9uw=;
	b=ExYWnTHYvvFTSLGIufalwhLkm5/3ohx3b2VrHjv4cuRgKY09vq+MA+2iR6YAUq/XVL7F34
	q4nK55U/mxbDN6zRew9I+805RQFWtw+2+Ib6opQdl5tyfitOkUF239XTlc4LFUYcOHkytc
	XfHDPBjUL2WWruaSgyRxSIunzAoisS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-bRXliihrOsWuLhon5Foj6Q-1; Wed, 27 Jul 2022 23:07:52 -0400
X-MC-Unique: bRXliihrOsWuLhon5Foj6Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CE4C8039A0;
	Thu, 28 Jul 2022 03:07:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0B0C492CA2;
	Thu, 28 Jul 2022 03:07:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD58F1945DAD;
	Thu, 28 Jul 2022 03:07:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E9DF1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:07:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEC2E40315E; Thu, 28 Jul 2022 03:07:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAADE492C3B
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:07:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE5EA8001EA
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:07:49 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-aq23KgSKP8S-NvfYnGuyMA-1; Wed, 27 Jul 2022 23:07:47 -0400
X-MC-Unique: aq23KgSKP8S-NvfYnGuyMA-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="207729960"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:07:22 +0800
IronPort-SDR: ImAlzTIwBsHoJLBaARJnlM83VSKKGFmR/RbqM47jIDdW694VX1KwMEiUlMXyJH76DtMtCmOdsY
 pJJtiWiBNDwsrRAFtWCf3kkQWv+d3BRKLpkU/ulHGV02KuVBYjQouC7/qdSscfAu79KEZG7HhC
 gRi3Z7XNl3sZsAJuZxAlfRh8cZckl8Wy4ApCCH5Q2nDkVRx+knPmkOyYQB+kmTlttgsuqaBli9
 WyEjX28j3yk1UYTsFlyUHvvwtIAbv1HjN0jqGzcKXeMJykvCoWvgszwIRdaFeZ/EKGsb1p6i31
 y8/Qfcjbmt6AwXGdcHM1vy3C
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:28:33 -0700
IronPort-SDR: EhHrMBroxpDRuHStdAOhA+Pu6ajC0IktcUAgDpLD//6fJvc6uuDc/KjseiNxJuTwEHSpb76YST
 7fQR4gVkjf+mJvJuVITKwWKlJFvSDWFJWQWgtAk4RcdM2lwlJ5nm38D0aN7fTf2+dG1I2+fEe/
 b0oIjxeGhA+d360KBz9dAvyz//KBwJIMifKoHqY2jBFyEzRHZmQO0C2gcPiiDJ0wYadXImsCil
 Q7rOZ25YTtFP2OnWFQWAQtIDwVxvvLTwLejvG/qyk9bhwiFlqHT4NUU9+LNzwU0pKwYWP6fKCn
 Z/o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:07:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbD95Ks9z1Rwnx
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:07:21 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id bELEkQ7JZTmN for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:07:19 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbD46Qd4z1RtVk;
 Wed, 27 Jul 2022 20:07:16 -0700 (PDT)
Message-ID: <e9663c20-65d5-48f5-3fe1-e3a8f5ab3214@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:07:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> Checking if a given sector is aligned to a zone is a common
> operation that is performed for zoned devices. Add
> bdev_is_zone_start helper to check for this instead of opencoding it

The patch actually introduces bdev_is_zone_aligned(). I agree with Bart
that bdev_is_zone_start() is a better name.

> everywhere.
> 
> Convert the calculations on zone size to be generic instead of relying on
> power_of_2 based logic in the block layer using the helpers wherever

s/based logic/arithmetics

> possible.
> 
> The only hot path affected by this change for power_of_2 zoned devices
> is in blk_check_zone_append() but bdev_is_zone_start() helper is
> used to optimize the calculation for po2 zone sizes. Note that the append
> path cannot be accessed by direct raw access to the block device but only
> through a filesystem abstraction.

And so what ? What is the point here ?

> 
> Finally, allow non power of 2 zoned devices provided that their zone

Please spell things out clearly: ...allow zoned devices with a zone size
that is not a power of 2 number of sectors...

> capacity and zone size are equal. The main motivation to allow non
> power_of_2 zoned device is to remove the unmapped LBA between zcap and
> zsze for devices that cannot have a power_of_2 zcap.

zcap, zsze are nvme field names. Please phrase these in plain english to
clarify.

> 
> To make this work bdev_get_queue(), bdev_zone_sectors() and
> bdev_is_zoned() are moved earlier without modifications.

"moved earlier" -> declared earlier in xxx.h ?

> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-core.c       |  2 +-
>  block/blk-zoned.c      | 24 +++++++++---
>  include/linux/blkdev.h | 84 ++++++++++++++++++++++++++++++------------
>  3 files changed, 79 insertions(+), 31 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3d286a256d3d..1f7e9a90e198 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -570,7 +570,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	if (!bdev_is_zone_aligned(bio->bi_bdev, bio->bi_iter.bi_sector) ||
>  	    !bio_zone_is_seq(bio))
>  		return BLK_STS_IOERR;
>  
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index dce9c95b4bcd..a01a231ad328 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -285,10 +285,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
>  		return -EINVAL;
>  
>  	/* Check alignment (handle eventual smaller last zone) */
> -	if (sector & (zone_sectors - 1))
> +	if (!bdev_is_zone_aligned(bdev, sector))
>  		return -EINVAL;
>  
> -	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
> +	if (!bdev_is_zone_aligned(bdev, nr_sectors) && end_sector != capacity)
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
> +			pr_warn("%s: Invalid zone size", disk->disk_name);

You removed the zone size value print, so please update the message to
something like:

pr_warn("%s: Invalid zero zone size", disk->disk_name);

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
> +			pr_warn("%s: Invalid zone capacity for non power of 2 zone size",
> +				disk->disk_name);

As Bart suggested, please print the zone capacity and zone size values.

>  			return -ENODEV;
>  		}
>  
>  		args->zone_sectors = zone->len;
> -		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
> +		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);

		args->nr_zones = disk_zone_no(disk, capacity);

>  	} else if (zone->start + args->zone_sectors < capacity) {
>  		if (zone->len != args->zone_sectors) {
>  			pr_warn("%s: Invalid zoned device with non constant zone size\n",
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 85b832908f28..1be805223026 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -634,6 +634,11 @@ static inline bool queue_is_mq(struct request_queue *q)
>  	return q->mq_ops;
>  }
>  
> +static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> +{
> +	return bdev->bd_queue;	/* this is never NULL */
> +}
> +
>  #ifdef CONFIG_PM
>  static inline enum rpm_status queue_rpm_status(struct request_queue *q)
>  {
> @@ -665,6 +670,25 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  	}
>  }
>  
> +static inline bool bdev_is_zoned(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return blk_queue_is_zoned(q);
> +
> +	return false;
> +}
> +
> +static inline sector_t bdev_zone_sectors(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (!blk_queue_is_zoned(q))
> +		return 0;
> +	return q->limits.chunk_sectors;
> +}
> +
>  #ifdef CONFIG_BLK_DEV_ZONED
>  static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  {
> @@ -684,6 +708,30 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
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
> +static inline bool bdev_is_zone_aligned(struct block_device *bdev, sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))
> +		return false;

This is checked in bdev_offset_from_zone_start(). No need to add it again
here.

> +
> +	return bdev_offset_from_zone_start(bdev, sec) == 0;
> +}
> +
>  static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
>  	if (!blk_queue_is_zoned(disk->queue))
> @@ -728,6 +776,18 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
>  	return 0;
>  }
> +
> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
> +						   sector_t sec)
> +{
> +	return 0;
> +}

This one is not used when CONFIG_BLK_DEV_ZONED is not set. No need to
define it.

> +
> +static inline bool bdev_is_zone_aligned(struct block_device *bdev, sector_t sec)
> +{
> +	return false;
> +}
> +
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;
> @@ -891,11 +951,6 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags);
>  int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
>  			unsigned int flags);
>  
> -static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> -{
> -	return bdev->bd_queue;	/* this is never NULL */
> -}
> -
>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>  
> @@ -1295,25 +1350,6 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>  	return BLK_ZONED_NONE;
>  }
>  
> -static inline bool bdev_is_zoned(struct block_device *bdev)
> -{
> -	struct request_queue *q = bdev_get_queue(bdev);
> -
> -	if (q)
> -		return blk_queue_is_zoned(q);
> -
> -	return false;
> -}
> -
> -static inline sector_t bdev_zone_sectors(struct block_device *bdev)
> -{
> -	struct request_queue *q = bdev_get_queue(bdev);
> -
> -	if (!blk_queue_is_zoned(q))
> -		return 0;
> -	return q->limits.chunk_sectors;
> -}
> -
>  static inline int queue_dma_alignment(const struct request_queue *q)
>  {
>  	return q ? q->dma_alignment : 511;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

