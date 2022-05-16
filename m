Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2516BC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 14:00:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-PCIz4YBxOSGdA5ohDpcQhg-1; Mon, 16 May 2022 10:00:53 -0400
X-MC-Unique: PCIz4YBxOSGdA5ohDpcQhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3E0B29ABA0F;
	Mon, 16 May 2022 14:00:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3CA744A18E;
	Mon, 16 May 2022 14:00:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D342194704E;
	Mon, 16 May 2022 14:00:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C7B11947040
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 14:00:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C54514DE22F; Mon, 16 May 2022 14:00:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7838414C4EB3
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:00:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C821811E7A
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:00:49 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-gBjsf-GCP2SeDK8wnG2mLQ-2; Mon, 16 May 2022 10:00:47 -0400
X-MC-Unique: gBjsf-GCP2SeDK8wnG2mLQ-2
X-IronPort-AV: E=Sophos;i="5.91,230,1647273600"; d="scan'208";a="304658017"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 16 May 2022 22:00:45 +0800
IronPort-SDR: hjh4NBCfc6tf/kPJuAfFIN+k0DuxCJx9KE2yn5FIONuiDiSSy9eBTj2fW0+F/JojSSba4l9+UN
 AOgo7yA39Ym3AIcdH4V6Z2TkTrJoDa78v1au5VMN73MFXI29eJ87xQDXNlDC+m2Nlg/l9qvpOt
 IKi5Ni41p1gf0+889TNTE0jJXd6L9Ly7I+gaYQi0SSDFxqVZH3Xm1TeJgLGNDj30fr98l7qqL0
 VAjkkgil3bkWJvqtXZML8WwxHvazRyJzGDeTZN+z4o+kqPdSkJMozb7mGhuvVaH5whRfLo/uSd
 uqeJs+VUVWr3cPjZ2AuaN+GB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 06:26:27 -0700
IronPort-SDR: cSGacJZQC5NCIvu36uH9TRYISkRvxlxFMcsvoutqdm91Nvi/eOfn6STb1LoG1RE16ypyAojyFi
 Lgf3Z2p6FkBhRXTqZS7greeKfhW6BCbezfQe7SMqYRK2Z84AdCgRWpUy2MCrboAWMI7def00+y
 FLGVFVzA3BShKGF6SbAMmvOBxWnsyyvE66B7mXpmH8rb4ld60Adx9SlUS6u6Jo2q+T3NqUHU5Q
 zJj7VCEgogX5ejHqy11864ytC+JL5FyxjFcpF7SyPFJ/tV41I7aMP+baB2W5m7LVYVoq2Al681
 HiU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 07:00:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L219n13vfz1SVnx
 for <dm-devel@redhat.com>; Mon, 16 May 2022 07:00:44 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id LvWmLgxwLwS9 for <dm-devel@redhat.com>;
 Mon, 16 May 2022 07:00:43 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L219d6jhvz1Rvlc;
 Mon, 16 May 2022 07:00:37 -0700 (PDT)
Message-ID: <d2fd2554-19c3-6ca3-6175-b8e8563986a5@opensource.wdc.com>
Date: Mon, 16 May 2022 16:00:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 naohiro.aota@wdc.com, Johannes.Thumshirn@wdc.com, snitzer@kernel.org,
 dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de
References: <20220516133921.126925-1-p.raghav@samsung.com>
 <CGME20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685@eucas1p1.samsung.com>
 <20220516133921.126925-3-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220516133921.126925-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 02/13] block: allow blk-zoned devices to
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
Cc: jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 Chris Mason <clm@fb.com>, matias.bjorling@wdc.com, gost.dev@samsung.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 jonathan.derrick@linux.dev, Keith Busch <kbusch@kernel.org>,
 Johannes Thumshirn <jth@kernel.org>, linux-btrfs@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>
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

On 2022/05/16 15:39, Pankaj Raghav wrote:
> Checking if a given sector is aligned to a zone is a common
> operation that is performed for zoned devices. Add
> blk_queue_is_zone_start helper to check for this instead of opencoding it
> everywhere.
> 
> Convert the calculations on zone size to be generic instead of relying on
> power_of_2 based logic in the block layer using the helpers wherever
> possible.
> 
> The only hot path affected by this change for power_of_2 zoned devices
> is in blk_check_zone_append() but blk_queue_is_zone_start() helper is
> used to optimize the calculation for po2 zone sizes. Note that the append
> path cannot be accessed by direct raw access to the block device but only
> through a filesystem abstraction.
> 
> Finally, allow non power of 2 zoned devices provided that their zone
> capacity and zone size are equal. The main motivation to allow non
> power_of_2 zoned device is to remove the unmapped LBA between zcap and
> zsze for devices that cannot have a power_of_2 zcap.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-core.c       |  3 +--
>  block/blk-zoned.c      | 27 +++++++++++++++++++++------
>  include/linux/blkdev.h | 22 ++++++++++++++++++++++
>  3 files changed, 44 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f305cb66c..b7051b7ea 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -634,8 +634,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (pos & (blk_queue_zone_sectors(q) - 1) ||
> -	    !blk_queue_zone_is_seq(q, pos))
> +	if (!blk_queue_is_zone_start(q, pos) || !blk_queue_zone_is_seq(q, pos))
>  		return BLK_STS_IOERR;
>  
>  	/*
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 140230134..cfc2fb804 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -289,10 +289,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  		return -EINVAL;
>  
>  	/* Check alignment (handle eventual smaller last zone) */
> -	if (sector & (zone_sectors - 1))
> +	if (!blk_queue_is_zone_start(q, sector))
>  		return -EINVAL;
>  
> -	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
> +	if (!blk_queue_is_zone_start(q, nr_sectors) && end_sector != capacity)
>  		return -EINVAL;
>  
>  	/*
> @@ -490,14 +490,29 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>  	 * smaller last zone.
>  	 */
>  	if (zone->start == 0) {
> -		if (zone->len == 0 || !is_power_of_2(zone->len)) {
> -			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
> -				disk->disk_name, zone->len);
> +		if (zone->len == 0) {
> +			pr_warn("%s: Invalid zone size",
> +				disk->disk_name);

This fits on one line, no ?

> +			return -ENODEV;
> +		}
> +
> +		/*
> +		 * Don't allow zoned device with non power_of_2 zone size with
> +		 * zone capacity less than zone size.
> +		 */
> +		if (!is_power_of_2(zone->len) &&
> +		    zone->capacity < zone->len) {
> +			pr_warn("%s: Invalid zoned size with non power of 2 zone size and zone capacity < zone size",
> +				disk->disk_name);

Very long... What about:

pr_warn("%s: Invalid zone capacity for non power of 2 zone size",
	disk->disk_name);

>  			return -ENODEV;
>  		}
>  
>  		args->zone_sectors = zone->len;
> -		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
> +		/*
> +		 * Division is used to calculate nr_zones for both power_of_2
> +		 * and non power_of_2 zone sizes as it is not in the hot path.
> +		 */

This comment is not very useful.

> +		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
>  	} else if (zone->start + args->zone_sectors < capacity) {
>  		if (zone->len != args->zone_sectors) {
>  			pr_warn("%s: Invalid zoned device with non constant zone size\n",
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 22fe512ee..32d7bd7b1 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -686,6 +686,22 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>  	return div64_u64(sector, zone_sectors);
>  }
>  
> +static inline bool blk_queue_is_zone_start(struct request_queue *q, sector_t sec)
> +{
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	u64 remainder = 0;
> +
> +	if (!blk_queue_is_zoned(q))
> +		return false;
> +
> +	if (is_power_of_2(zone_sectors))
> +		return IS_ALIGNED(sec, zone_sectors);
> +
> +	div64_u64_rem(sec, zone_sectors, &remainder);
> +	/* if there is a remainder, then the sector is not aligned */

Hmmm... Fairly obvious. Not sure this comment is useful.

> +	return remainder == 0;
> +}
> +
>  static inline bool blk_queue_zone_is_seq(struct request_queue *q,
>  					 sector_t sector)
>  {
> @@ -732,6 +748,12 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>  {
>  	return 0;
>  }
> +
> +static inline bool blk_queue_is_zone_start(struct request_queue *q, sector_t sec)
> +{
> +	return false;
> +}
> +
>  static inline unsigned int queue_max_open_zones(const struct request_queue *q)
>  {
>  	return 0;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

