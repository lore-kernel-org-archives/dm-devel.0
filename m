Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2101C19F2B
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978098;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8aXJnA5PvhEj1F5puKsTZeJL+J0FWQCApe4bFKazX5o=;
	b=fRz6UXlshd8kjPNvka7RYNrLKKTD5VB47nyLAnPEiaX4+eN08xT1sULokds2u+KyxzfzEG
	AqLPyFANLX454a7AwN63ByCZG012Ykv1uI8Mq3gAr/J6r6EksSq+VbdM6jQ8C4TqwIWmte
	O7YiUFUakpAYjoJ+4jA//Ch8LIbGVMc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-6c6ornKJMsezFRG78-owFw-1; Wed, 27 Jul 2022 23:14:57 -0400
X-MC-Unique: 6c6ornKJMsezFRG78-owFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8AD41C00ACD;
	Thu, 28 Jul 2022 03:14:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8E6118EB7;
	Thu, 28 Jul 2022 03:14:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76A271945DAB;
	Thu, 28 Jul 2022 03:14:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C93DF1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:14:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A3F6E112131E; Thu, 28 Jul 2022 03:14:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F91C1121319
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:14:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E3A7811E75
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:14:53 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-VMOtDXuYNnaN-kNT9dSPlw-1; Wed, 27 Jul 2022 23:14:51 -0400
X-MC-Unique: VMOtDXuYNnaN-kNT9dSPlw-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="207730691"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:14:50 +0800
IronPort-SDR: CA7IkS1GyBf89fN0Gx65oKcObvZRYWUpbsxAlkuBcOyfxWDjaPA+9QFgP65zshcuN++IcXkj1W
 u+u+RUJLzY0Exq/ub7pgsT3UB1IJUhVsYAZZaIAgU8TYIMWpYquMIBzGV+mqYOZXUpS8xPZy88
 KaOjm73iAbU8oUiDh5z964a5oC7HDKt3LhAJ1FL0OCLVhP3UxYpCzDu6GkpQnIcmFnoGTZcF0e
 XCNESuW3hB86FK1ZJSRmjbZaS+bxbe/EfsglSnQKD/I3LoMW8GB9o5A0Y6yzZzXsqFjHNHVSxm
 d4kbrertKQm9XgT9YZTFbsMW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:36:01 -0700
IronPort-SDR: uvfAvqHTFUigI6jmMhl+2vFfR41hH/hVfbCxTDc38a5bGmQ9QyfErOoKkb1iWL7tUlikKKO6l+
 BjJ94yGm6aRnRuYKIPj4aMS0sWslgkxIv5Q4lOURdLJDnctNNSFMMhXxikJEMfnTgLWePrQ30g
 nFd3iKno3svhMQH0JS6gopugl1cyduJ4RyIdISi/0vF7EyKrYDxd4ppZ+FOkXKosOy6LzrGmoV
 SJttrRylmSosIz0MgGvI5J9p5WUpgJBVd5mXCou15NmEe3vOwVszvsC62XFm6+sUroJY9IxU9Q
 ciU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:14:51 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbNn4FZdz1RwqM
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:14:49 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id UZD_qKb6pUEz for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:14:47 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbNj19KLz1RtVk;
 Wed, 27 Jul 2022 20:14:44 -0700 (PDT)
Message-ID: <d32ed9f5-9342-e3e6-ad84-bdf40eac5b0c@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:14:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f@eucas1p1.samsung.com>
 <20220727162245.209794-6-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-6-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 05/11] null_blk: allow non power of 2
 zoned devices
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> Convert the power of 2 based calculation with zone size to be generic in
> null_zone_no with optimization for power of 2 based zone sizes.
> 
> The nr_zones calculation in null_init_zoned_dev has been replaced with a
> division without special handling for power of 2 based zone sizes as
> this function is called only during the initialization and will not
> invoked in the hot path.
> 
> Performance Measurement:
> 
> Device:
> zone size = 128M, blocksize=4k
> 
> FIO cmd:
> 
> fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
> --io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
> --loops=4
> 
> The following results are an average of 4 runs on AMD Ryzen 5 5600X with
> 32GB of RAM:
> 
> Sequential Write:
> 
> x-----------------x---------------------------------x---------------------------------x
> |     IOdepth     |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Sequential read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Random read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Minor variations are noticed in Sequential write with io depth 8 and
> in random read with io depth 16. But overall no noticeable differences
> were noticed
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/block/null_blk/main.c     |  5 ++---
>  drivers/block/null_blk/null_blk.h |  6 ++++++
>  drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
>  3 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index c451c477978f..f1e0605dee94 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1976,9 +1976,8 @@ static int null_validate_conf(struct nullb_device *dev)
>  	if (dev->queue_mode == NULL_Q_BIO)
>  		dev->mbps = 0;
>  
> -	if (dev->zoned &&
> -	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
> -		pr_err("zone_size must be power-of-two\n");
> +	if (dev->zoned && !dev->zone_size) {
> +		pr_err("Invalid zero zone size\n");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
> index 94ff68052b1e..ece6dded9508 100644
> --- a/drivers/block/null_blk/null_blk.h
> +++ b/drivers/block/null_blk/null_blk.h
> @@ -83,6 +83,12 @@ struct nullb_device {
>  	unsigned int imp_close_zone_no;
>  	struct nullb_zone *zones;
>  	sector_t zone_size_sects;
> +	/*
> +	 * zone_size_sects_shift is only useful when the zone size is
> +	 * power of 2. This variable is set to zero when zone size is non
> +	 * power of 2.
> +	 */

Simplify:

	/*
	 * zone_size_sects_shift is used only when the zone size is a
	 * power of 2 number of sectors.
	 */

But personally, I would simply drop this comment. The name is obvious and
the code very clear.

> +	unsigned int zone_size_sects_shift;
>  	bool need_zone_res_mgmt;
>  	spinlock_t zone_res_lock;
>  
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 55a69e48ef8b..015f6823706c 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -16,7 +16,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
>  
>  static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
>  {
> -	return sect >> ilog2(dev->zone_size_sects);
> +	if (dev->zone_size_sects_shift)
> +		return sect >> dev->zone_size_sects_shift;
> +
> +	return div64_u64(sect, dev->zone_size_sects);
>  }
>  
>  static inline void null_lock_zone_res(struct nullb_device *dev)
> @@ -65,10 +68,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
>  	sector_t sector = 0;
>  	unsigned int i;
>  
> -	if (!is_power_of_2(dev->zone_size)) {
> -		pr_err("zone_size must be power-of-two\n");
> -		return -EINVAL;
> -	}
>  	if (dev->zone_size > dev->size) {
>  		pr_err("Zone size larger than device capacity\n");
>  		return -EINVAL;
> @@ -86,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
>  	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
>  	dev_capacity_sects = mb_to_sects(dev->size);
>  	dev->zone_size_sects = mb_to_sects(dev->zone_size);
> -	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
> -		>> ilog2(dev->zone_size_sects);
>  
> +	if (is_power_of_2(dev->zone_size_sects))
> +		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
> +	else
> +		dev->zone_size_sects_shift = 0;
> +
> +	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
> +					      dev->zone_size_sects);
>  	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
>  				    GFP_KERNEL | __GFP_ZERO);
>  	if (!dev->zones)


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

