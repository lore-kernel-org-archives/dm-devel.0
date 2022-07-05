Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B41C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xYCFEeQWaCZram3W8Qvnwoln9tosV3/rzy+Y2UPwsUU=;
	b=C2ZjPcZ5mTevCmF3CtXGHEB9czxMOIPpjeiQ5F59xZsuUY78viLE4Y4ve04T7NlBmWYf+t
	BDjxBcdS3iAQNeFjEfK/Cn0a96XiCCg15C7sE1TH4E+rJ0xHGAsDQbewBvue8iRhlq+QDR
	YHplDoBuMww+fS26suOhet5gdWGCCTQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-w4xIndAgN_2V9w8FQQ_dFg-1; Mon, 04 Jul 2022 22:41:41 -0400
X-MC-Unique: w4xIndAgN_2V9w8FQQ_dFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20EB380390C;
	Tue,  5 Jul 2022 02:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7F44010FA6;
	Tue,  5 Jul 2022 02:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A73B7194704A;
	Tue,  5 Jul 2022 02:41:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C66511947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:41:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF18BC44AEE; Tue,  5 Jul 2022 02:41:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AAB16C44AEC
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:41:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3AA880390C
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:41:37 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-I0PgU7lTPPCic1ftfBIswg-1; Mon, 04 Jul 2022 22:41:36 -0400
X-MC-Unique: I0PgU7lTPPCic1ftfBIswg-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="203466742"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:41:34 +0800
IronPort-SDR: IGC1UHHq5BC84aI/YPI3tOEnSXT+LdCf/BbDRDSQOA48fM74jKzt8zVC1OAd1jbot/0Pz+R+fb
 /xB4k9KKk6YaFsOYgj7PROv0XWdTVIxi4RlDfO9IVsnz5SL4UTtDKUU+MEoDc0WOZnuxSGoDqq
 hyhw8KGgICkH2R7GrveQOl1xhz3DAmewikEl7RvUYSLkm+291Z2tX3oMq+0ybUOTtUbXHgc50v
 bj7YjTsGlExYsUbh1NkOhd+v/JrTpxm/jfu7d6fVUMjHL4wmrP6NWU/bhVh2kXoRsdGxuxHa9X
 nh+rGycqWURbgyI2JJ/dhmIl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:03:26 -0700
IronPort-SDR: ZNJpGbg/so9EcmFycWKIi3+OtTN1lOwGLMF9vwAouRYT0LtcqanzLExY3+giPx3Ir0YAAQVHY3
 AYu7XA5waHIGQq3pPBILs5/UfnFPaTceqq+jIo0jZZr2NUnVU7UhIRzpu9bEgAJ70+CMkdtcMR
 XurElbP80vy2Ye3prRWUVl3iB+BU5MUuBzUn0J2zu0uFWJziaiVKE7zsqQrT2yUJo1fCtXwixk
 cxGnb7q4BhZEvmGDg1lI1gfDhtlB6aZtZcP5PGtWa62zqlqB7ZgCs/0+MQtQVLgn85nmq23U2A
 6C8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:41:35 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRl26FMYz1RwqM
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:41:34 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id riHyzEV4MwN5 for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:41:34 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRl10ptgz1RtVk;
 Mon,  4 Jul 2022 19:41:32 -0700 (PDT)
Message-ID: <612f6e15-ea72-374a-9eba-d3a13a63ee00@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:41:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-9-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 08/17] block: pass a gendisk to
 blk_queue_set_zoned
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
> Prepare for storing the zone related field in struct gendisk instead
> of struct request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-settings.c           | 9 +++++----
>  block/partitions/core.c        | 2 +-
>  drivers/block/null_blk/zoned.c | 2 +-
>  drivers/nvme/host/zns.c        | 2 +-
>  drivers/scsi/sd.c              | 6 +++---
>  drivers/scsi/sd_zbc.c          | 2 +-
>  include/linux/blkdev.h         | 2 +-
>  7 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 6ccceb421ed2f..35b7bba306a83 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -893,18 +893,19 @@ static bool disk_has_partitions(struct gendisk *disk)
>  }
>  
>  /**
> - * blk_queue_set_zoned - configure a disk queue zoned model.
> + * disk_set_zoned - configure the zoned model for a disk
>   * @disk:	the gendisk of the queue to configure
>   * @model:	the zoned model to set
>   *
> - * Set the zoned model of the request queue of @disk according to @model.
> + * Set the zoned model of @disk to @model.
> + *
>   * When @model is BLK_ZONED_HM (host managed), this should be called only
>   * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
>   * If @model specifies BLK_ZONED_HA (host aware), the effective model used
>   * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
>   * on the disk.
>   */
> -void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
> +void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  {
>  	struct request_queue *q = disk->queue;
>  
> @@ -948,7 +949,7 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  		blk_queue_clear_zone_settings(q);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
> +EXPORT_SYMBOL_GPL(disk_set_zoned);
>  
>  int bdev_alignment_offset(struct block_device *bdev)
>  {
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index 7dc487f5b03cd..1a45b1dd64918 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -330,7 +330,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
>  	case BLK_ZONED_HA:
>  		pr_info("%s: disabling host aware zoned block device support due to partitions\n",
>  			disk->disk_name);
> -		blk_queue_set_zoned(disk, BLK_ZONED_NONE);
> +		disk_set_zoned(disk, BLK_ZONED_NONE);
>  		break;
>  	case BLK_ZONED_NONE:
>  		break;
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 2fdd7b20c224e..b47bbd114058d 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -159,7 +159,7 @@ int null_register_zoned_dev(struct nullb *nullb)
>  	struct nullb_device *dev = nullb->dev;
>  	struct request_queue *q = nullb->q;
>  
> -	blk_queue_set_zoned(nullb->disk, BLK_ZONED_HM);
> +	disk_set_zoned(nullb->disk, BLK_ZONED_HM);
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>  	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>  
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
> index 9f81beb4df4ef..0ed15c2fd56de 100644
> --- a/drivers/nvme/host/zns.c
> +++ b/drivers/nvme/host/zns.c
> @@ -109,7 +109,7 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
>  		goto free_data;
>  	}
>  
> -	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
> +	disk_set_zoned(ns->disk, BLK_ZONED_HM);
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>  	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
>  	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index cb587e488601c..eb02d939dd448 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2934,15 +2934,15 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>  
>  	if (sdkp->device->type == TYPE_ZBC) {
>  		/* Host-managed */
> -		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
> +		disk_set_zoned(sdkp->disk, BLK_ZONED_HM);
>  	} else {
>  		sdkp->zoned = zoned;
>  		if (sdkp->zoned == 1) {
>  			/* Host-aware */
> -			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
> +			disk_set_zoned(sdkp->disk, BLK_ZONED_HA);
>  		} else {
>  			/* Regular disk or drive managed disk */
> -			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
> +			disk_set_zoned(sdkp->disk, BLK_ZONED_NONE);
>  		}
>  	}
>  
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 6acc4f406eb8c..0f5823b674685 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -929,7 +929,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  		/*
>  		 * This can happen for a host aware disk with partitions.
>  		 * The block device zone model was already cleared by
> -		 * blk_queue_set_zoned(). Only free the scsi disk zone
> +		 * disk_set_zoned(). Only free the scsi disk zone
>  		 * information and exit early.
>  		 */
>  		sd_zbc_free_zone_info(sdkp);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b9baee910b825..ddf8353488fc8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -291,7 +291,7 @@ struct queue_limits {
>  typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
>  			       void *data);
>  
> -void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
> +void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
>  


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

