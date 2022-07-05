Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D85C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988342;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dnApMSqqjZ7lCFh+vFI7ARMM7qTioAi8zQxUo1tiB54=;
	b=CXTvErKy6KGzfVYEU1W1tXlR+LsmsV1RwQytasZIRHZk48Sz744+3gE3JzcX9i5ay2Y+5U
	46PRrWz43tp36ijfc0q9+01vE2QtrnClLLVf+3PF+cdFoCVecR/7O4naJxrKb4YNeVtUVG
	Ukik4B43Hi42RBQwBQTTEy1R+biRi5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-8sXux6L7PvucF2mJk6Xs0Q-1; Mon, 04 Jul 2022 22:32:18 -0400
X-MC-Unique: 8sXux6L7PvucF2mJk6Xs0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0086389C7DC;
	Tue,  5 Jul 2022 02:32:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8C84C27E83;
	Tue,  5 Jul 2022 02:32:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CBAE194704A;
	Tue,  5 Jul 2022 02:32:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0368B1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:32:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E28A140D1B97; Tue,  5 Jul 2022 02:32:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE7AC40C1241
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:32:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C51F21C068C7
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:32:14 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-lwFDbqbrPKCGqnvyieQFsQ-1; Mon, 04 Jul 2022 22:32:05 -0400
X-MC-Unique: lwFDbqbrPKCGqnvyieQFsQ-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="203465769"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:32:04 +0800
IronPort-SDR: 1Mn6EJbnaFDU3zym8HGRBMA7D70QChTmPR8EepqzoAwZ40O8gRpOo6rYYatxbBlSRkHBKlknK2
 eTbMezg+7KzULME6Z9ZIVnds7/VyiTExU7EWyGZZTmlD5SkjL9OpyO6/Aqvi0dn+e/nuazRxT2
 TjF+oV9A6SLZDI7k2wMEVLi1Jjnbv1COlP13+ms/X5VlMDXW5Fq2XEIqAKx9bmUtcg2gOjiMYa
 B6hmSAnrsZYRX1449+fcxWEGsB4DIHwtir9Tk2q06V5P1/9UWk1D6050WkFTZrDgxffMgGbsxL
 yXs/fZjHEDeMTjfRuMvy7oOV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:49:23 -0700
IronPort-SDR: j1RXgcKS55vW3QpZ5c8G01sclD1NluFki6BbMzmXK1WjqWlsrjbc5jwVLKatpboZpcJkATn8hO
 5+Off1KcSropMeb2BXHH+KcoCNvJNxAcShmKediSt5CU1K5DEXNigqTp9dUP5rpXxmh+3SmmC0
 4uk4hKRaZO0NVp/pPWhL7z5UXMdJLuLcBlqql0QX2ksqgDGL1Nrg64EKrZQpPfvqznnXLsamY1
 Ne6XGi8D78ghxDXTJU+IyT7kcSoaK5jSoMMZBLKCBWVmCUEjJWF5TcmqLiI/k8cuZpCE2uiTZF
 sV8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:32:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRX05NkBz1RwqM
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:32:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id nkxXbxlh_G6L for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:32:00 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRWz1GBQz1RtVk;
 Mon,  4 Jul 2022 19:31:58 -0700 (PDT)
Message-ID: <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:31:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-6-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 05/17] block: export blkdev_zone_mgmt_all
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
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

On 7/4/22 21:44, Christoph Hellwig wrote:
> Export blkdev_zone_mgmt_all so that the nvme target can use it instead
> of duplicating the functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-zoned.c      | 10 +++++-----
>  include/linux/blkdev.h |  2 ++
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 90a5c9cc80ab3..7fbe395fa51fc 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>  	}
>  }
>  
> -static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
> -					  gfp_t gfp_mask)
> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
> +			 gfp_t gfp_mask)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	sector_t capacity = get_capacity(bdev->bd_disk);
> @@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>  			continue;
>  		}
>  
> -		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
> -				   gfp_mask);
> +		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
>  		bio->bi_iter.bi_sector = sector;
>  		sector += zone_sectors;
>  
> @@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>  	kfree(need_reset);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
>  
>  static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
>  {
> @@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	 */
>  	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
>  		if (!blk_queue_zone_resetall(q))
> -			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
> +			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
>  		return blkdev_zone_reset_all(bdev, gfp_mask);
>  	}
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 270cd0c552924..b9baee910b825 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  			    sector_t sectors, sector_t nr_sectors,
>  			    gfp_t gfp_mask);
> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
> +			 gfp_t gfp_mask);
>  int blk_revalidate_disk_zones(struct gendisk *disk,
>  			      void (*update_driver_data)(struct gendisk *disk));
>  


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

