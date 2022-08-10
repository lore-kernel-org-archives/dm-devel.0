Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC3BC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660150225;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kJmTgwn8RodV2a+l5lSrSmn6jRt2ndZAWiuGCIJdXq8=;
	b=OtO+Q8sO57d3zb92yiEsVcyW+aM7eZD1riyCGzB745znMaYgpYnUn7jSJWWqycsAKpdj+c
	tJsrOptGaFDqbxI0/0V+z16jXvGYHRVgLFHGrcdWVhJQlw4WnkkAR+Sw7qC1sqO1o3GLNY
	ndNuRy81AKC7WbWs+ESZry1TV1dRVYQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-HgGwBbXhPSq_fCugy8CbFg-1; Wed, 10 Aug 2022 12:50:23 -0400
X-MC-Unique: HgGwBbXhPSq_fCugy8CbFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E168E81F46C;
	Wed, 10 Aug 2022 16:50:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C36D72166B26;
	Wed, 10 Aug 2022 16:50:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39AF71946A50;
	Wed, 10 Aug 2022 16:50:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7C9B1946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 16:50:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5A68492CA4; Wed, 10 Aug 2022 16:50:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1A1F492C3B
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 16:50:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8EC2804196
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 16:50:17 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-dKZrxY5VNUSsIpLlh87zsw-1; Wed, 10 Aug 2022 12:50:15 -0400
X-MC-Unique: dKZrxY5VNUSsIpLlh87zsw-1
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="213382751"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 00:50:13 +0800
IronPort-SDR: SOE1ArskomXtLCx2rhmyrkKEfJYReOAaAK5ySF++6jLI0EJLxIDyMHhKsLDjUCxwvjSSEu3p+S
 pgYyrC2WHaPcxcIOZwGTSrohtuOby3t9NOdFmDR5FS2qwpAWDWEIfYzTiTjg1H8a0m/d+SkVOs
 tkdG4ixEwJiNAIFCwuXR4YEZDxAC3aqrvYfOG18XKeAqF+mmbBTwc/j019jAF2fcW/pduXXvv2
 t8D8VQsajADRNBUGaB0wfszaHgGEmLwj+iLGqKyEscZKa+3PA49b1tiRUD8DWsphXx4EYWycgP
 jsKstnJg8CQGoYuVpYQPnUQZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:05:49 -0700
IronPort-SDR: F1dk9L3nTyzb2yOwoSKwyfjye5l7HZ00JJtrSwYwWqsmSDBgKvv3Uw/PHMSc4QSO3vorej0+5a
 nrc5hD7H4K1r0RwVOXgYm+iobAqQkUHFn0QRHiywXdQmxCFv1gds8MeuBLItqGUKeihygOEweU
 Xf72gXoy7z5xBotTxCjc/Ci0fElVkcA9p+2WZcnFRS+fEaDDB5g38yezOigfzf1XgjhKRJ3ego
 H1vUVK5xanVztkTUur6huR9jbGw9Ir6tTlMmil972huVvuvRLze72wpLHN06OzNA7GqYnnH6pG
 S3s=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:50:14 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2wsd19Z5z1Rwnm
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 09:50:13 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id gpHS3MnQ9CNl for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 09:50:12 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2wsb51npz1RtVk;
 Wed, 10 Aug 2022 09:50:11 -0700 (PDT)
Message-ID: <700a5080-aea2-1a56-6bac-bebb03be8b47@opensource.wdc.com>
Date: Wed, 10 Aug 2022 09:50:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803@eucas1p1.samsung.com>
 <20220803094801.177490-3-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v9 02/13] block:rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helpers in blkdev.h
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:47, Pankaj Raghav wrote:
> Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
> in the blkdev.h include file.
> 
> This commit has no functional change, and it is a prep patch for allowing
> zoned devices with non-power-of-2 zone sizes in the block layer.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/linux/blkdev.h | 48 +++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ab82d1ff0cce..22f97427b60b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -635,6 +635,11 @@ static inline bool queue_is_mq(struct request_queue *q)
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
> @@ -666,6 +671,25 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  	}
>  }
>  
> +static inline bool bdev_is_zoned(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return blk_queue_is_zoned(q);

As noted with the comment in bdev_get_queue(), q is never null. So this all
could be simplified to:

	return blk_queue_is_zoned(bdev_get_queue(bdev));

This could be done in a separate patch, or here as well.

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
> @@ -892,11 +916,6 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags);
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
> @@ -1296,25 +1315,6 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
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

