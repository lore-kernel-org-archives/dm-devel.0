Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59DEDC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989464;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RiY/Ht7c04Jc7jQzSfwZXXXhU15PR7LEUMc2/QwizRQ=;
	b=gV941ZE0O5JRDs60UxRwzJWIzShFrV4cnJ2PCP0SihOpYJ2bo/URzp6Uldbt0BwJiAV//a
	uPZvd24UZl0NYJf5/i6mgXO1XwXq0TbCQZdVaw6wajdrh8KJNJ6vfxSiCCce1XKkNKj2u2
	gJ+E6XPWsb+I6hPwgT3lI6rG/HJH5ic=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-VCOYMVFTMQ-LQQZdnnH4mQ-1; Mon, 04 Jul 2022 22:51:01 -0400
X-MC-Unique: VCOYMVFTMQ-LQQZdnnH4mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44FA03804529;
	Tue,  5 Jul 2022 02:50:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E834F40D1B97;
	Tue,  5 Jul 2022 02:50:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 916EA194704A;
	Tue,  5 Jul 2022 02:50:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1F331947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:50:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A455EC4C7A1; Tue,  5 Jul 2022 02:50:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FE89C4C7A0
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:50:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85CCD29DD991
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:50:56 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-3F26XSMyPUa0a3UkU9Yf6w-1; Mon, 04 Jul 2022 22:50:54 -0400
X-MC-Unique: 3F26XSMyPUa0a3UkU9Yf6w-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="309130556"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:50:52 +0800
IronPort-SDR: 7+vZsypaczlCr21JQL3S2GbhbFsIJ+lQDyrjSghVzMeN5gsdH7guyHsRLXRB82U8u+8Ezqtqol
 fY1bQMQYnAdcjZ45HDqkQ7GVdlq9ykP71Qf6Kh9aaNaY0M0dFPTrfYk5VfIAqiKPdy79bX1de/
 qCYgCHb80NkYUA995Nxp08bWYETc2JyPACu/f7oLhZMlTx80ZFBGs5enWHENojdvwboCR4HA3P
 ZsOnA/eS7M6/2U9AwdNdq+jlXF0teFUsvXCmhNj3+ZMeMU4nIc4zSAFuHCYneoe6KIkWRCnoVD
 myUNWYk3shS7Ws+A6wykuYBI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:08:11 -0700
IronPort-SDR: wWfU/xFVt6861fjkktmcrmqrsKcLrTklQHFhUhpgomaQGz6oTQma9XLvafG+dghER5nD0aKq1g
 iVkHMzKqhzW6QcUqARVq9GpXy83/Ul7GSV8sJwtP3F13GOozh2UGyZAyEq6LlV263EZDFsMGdG
 2qCdKDgfIxPVk8iCkbLhDALCQJRE77Glyg1Or8XU0xvbdskXMJSN+Mi1und+i9RefLJtu5NYs9
 RlwkfTuENcA1R3Q74Xcb/3iD9146ZZhYKOZA2gVwP2OedQNJ89MYb+Q0JcRNKRv+spbXeD4oHo
 bLw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:50:52 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRxl3Djrz1Rwnx
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:50:51 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id K6wpzJ6ZHMLV for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:50:50 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRxj3h60z1RtVk;
 Mon,  4 Jul 2022 19:50:49 -0700 (PDT)
Message-ID: <1c7795a3-4a18-6741-a86b-64f1eee42dbd@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:50:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-13-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-13-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 12/17] block: pass a gendisk to
 blk_queue_max_open_zones and blk_queue_max_active_zones
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Switch to a gendisk based API in preparation for moving all zone related
> fields from the request_queue to the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/block/null_blk/zoned.c | 4 ++--
>  drivers/nvme/host/zns.c        | 4 ++--
>  drivers/scsi/sd_zbc.c          | 6 +++---
>  include/linux/blkdev.h         | 8 ++++----
>  4 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index b47bbd114058d..576ab3ed082a5 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -174,8 +174,8 @@ int null_register_zoned_dev(struct nullb *nullb)
>  	}
>  
>  	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
> -	blk_queue_max_open_zones(q, dev->zone_max_open);
> -	blk_queue_max_active_zones(q, dev->zone_max_active);
> +	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
> +	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
>  
>  	return 0;
>  }
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
> index 0ed15c2fd56de..12316ab51bda6 100644
> --- a/drivers/nvme/host/zns.c
> +++ b/drivers/nvme/host/zns.c
> @@ -111,8 +111,8 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
>  
>  	disk_set_zoned(ns->disk, BLK_ZONED_HM);
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> -	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
> -	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
> +	disk_set_max_open_zones(ns->disk, le32_to_cpu(id->mor) + 1);
> +	disk_set_max_active_zones(ns->disk, le32_to_cpu(id->mar) + 1);
>  free_data:
>  	kfree(id);
>  	return status;
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 0f5823b674685..b4106f8997342 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -950,10 +950,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>  	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>  	if (sdkp->zones_max_open == U32_MAX)
> -		blk_queue_max_open_zones(q, 0);
> +		disk_set_max_open_zones(disk, 0);
>  	else
> -		blk_queue_max_open_zones(q, sdkp->zones_max_open);
> -	blk_queue_max_active_zones(q, 0);
> +		disk_set_max_open_zones(disk, sdkp->zones_max_open);
> +	disk_set_max_active_zones(disk, 0);
>  	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
>  
>  	/*
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a14cc3e46e6ad..e32c147f72868 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -698,16 +698,16 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
>  	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
>  }
>  
> -static inline void blk_queue_max_open_zones(struct request_queue *q,
> +static inline void disk_set_max_open_zones(struct gendisk *disk,
>  		unsigned int max_open_zones)
>  {
> -	q->max_open_zones = max_open_zones;
> +	disk->queue->max_open_zones = max_open_zones;
>  }
>  
> -static inline void blk_queue_max_active_zones(struct request_queue *q,
> +static inline void disk_set_max_active_zones(struct gendisk *disk,
>  		unsigned int max_active_zones)
>  {
> -	q->max_active_zones = max_active_zones;
> +	disk->queue->max_active_zones = max_active_zones;
>  }
>  
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

