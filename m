Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37E9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 13:54:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-Osr9KjW4PHeAKiEiT31Ibw-1; Mon, 16 May 2022 09:54:29 -0400
X-MC-Unique: Osr9KjW4PHeAKiEiT31Ibw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 753871801389;
	Mon, 16 May 2022 13:54:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3667640D1B98;
	Mon, 16 May 2022 13:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D693C194704E;
	Mon, 16 May 2022 13:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9109B1947040
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 13:54:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D8B544266E; Mon, 16 May 2022 13:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 699B544266A
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:54:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51761811E76
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:54:24 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-RL_AqfDGMsexix3bpL6zGA-2; Mon, 16 May 2022 09:54:22 -0400
X-MC-Unique: RL_AqfDGMsexix3bpL6zGA-2
X-IronPort-AV: E=Sophos;i="5.91,229,1647273600"; d="scan'208";a="205306021"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 16 May 2022 21:54:19 +0800
IronPort-SDR: 1B7oOKfIGs+DEs4JvIW6JWLDfHwmzUr59Pa0O2c2J2AVRuxmkmBU2RctWBIsqCu1l3YgrcbVJC
 gXVkPlQuNgKv64IOoSEcq2xx97LzBXIpDcP0tX3hztB3K9paH2ncEFQmE/jMppmtEM3LKKvqjD
 8ZN6GZLUO3n93b4YKFMC3PpbJkRMb9397rlSeJfnGERK0GowmVc/yj7cW2ngeeb3h6k4uBhyvC
 2Y4d5uPCS9CoAd9qMQ/t8RW2NQerib/UpMb0NNbxYE4XcSoaF74/gZH2oOGVE3H8vhtXrCb4Q/
 cUS5nURART3B2AZoufVoazOj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 06:18:12 -0700
IronPort-SDR: xMRAiCLidMMRrN5fD7puHLfIn3E3GZq5z2NwAe1xx64GV3AYHTOzG7kmHmRe9awQKSOg37LiN7
 Bus8yHMKh7DGVv94NpsHMUK3k4u49OXaXVVwvR/Ike49A8D9TpA5oTOgj3Hd06Ij7WsoRDXmPB
 /1Kc08Ac/UXuF2ChQrIFeDAk+iu/kOlVJoMRMb4sr6DVH34j90yBq7nQVhSgG027FxCx2Zh9b3
 ikL+07ch/jarM8+2TmGPTpNBEsUaqC5/RyqUxrMbTHZro12vL+ST+RCG8Hk5ET610VdOxCLDpj
 mDk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 06:54:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L212M1QRWz1SVp1
 for <dm-devel@redhat.com>; Mon, 16 May 2022 06:54:19 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id u1TVZ_y96yIL for <dm-devel@redhat.com>;
 Mon, 16 May 2022 06:54:18 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L212D5R0Cz1Rvlc;
 Mon, 16 May 2022 06:54:12 -0700 (PDT)
Message-ID: <487c9368-36fe-25ec-7a76-f6aa50c4d3d5@opensource.wdc.com>
Date: Mon, 16 May 2022 15:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 naohiro.aota@wdc.com, Johannes.Thumshirn@wdc.com, snitzer@kernel.org,
 dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de
References: <20220516133921.126925-1-p.raghav@samsung.com>
 <CGME20220516133924eucas1p1817f306e3f2442088bf49ab513657cbe@eucas1p1.samsung.com>
 <20220516133921.126925-2-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220516133921.126925-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 01/13] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/05/16 15:39, Pankaj Raghav wrote:
> Adapt blkdev_nr_zones and blk_queue_zone_no function so that it can
> also work for non-power-of-2 zone sizes.
> 
> As the existing deployments of zoned devices had power-of-2
> assumption, power-of-2 optimized calculation is kept for those devices.
> 
> There are no direct hot paths modified and the changes just
> introduce one new branch per call.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-zoned.c      | 13 ++++++++++---
>  include/linux/blkdev.h |  8 +++++++-
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 38cd840d8..140230134 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -111,16 +111,23 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>   * blkdev_nr_zones - Get number of zones
>   * @disk:	Target gendisk
>   *
> - * Return the total number of zones of a zoned block device.  For a block
> - * device without zone capabilities, the number of zones is always 0.
> + * Return the total number of zones of a zoned block device, including the
> + * eventual small last zone if present. For a block device without zone
> + * capabilities, the number of zones is always 0.
>   */
>  unsigned int blkdev_nr_zones(struct gendisk *disk)
>  {
>  	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
> +	sector_t capacity = get_capacity(disk);
>  
>  	if (!blk_queue_is_zoned(disk->queue))
>  		return 0;
> -	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return (capacity + zone_sectors - 1) >>
> +		       ilog2(zone_sectors);

Why the line break here ? This fits on one line, no ?

> +
> +	return div64_u64(capacity + zone_sectors - 1, zone_sectors);
>  }
>  EXPORT_SYMBOL_GPL(blkdev_nr_zones);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 1b24c1fb3..22fe512ee 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -675,9 +675,15 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>  static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>  					     sector_t sector)
>  {
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +
>  	if (!blk_queue_is_zoned(q))
>  		return 0;
> -	return sector >> ilog2(q->limits.chunk_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return sector >> ilog2(zone_sectors);
> +
> +	return div64_u64(sector, zone_sectors);
>  }
>  
>  static inline bool blk_queue_zone_is_seq(struct request_queue *q,


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

