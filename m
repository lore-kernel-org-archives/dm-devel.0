Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1CF6C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QlckC3UqWK6dePpVJnQDpiw04Zsed1JlCYVfIVlC2R4=;
	b=SG9qSjcdXCv9ODo3iwmKWSGvxdYY3cynV35RDqPHZ25fiocASu2M8IkPN1J4dtm375+3m1
	nmIOxYARZnY6ZHs+5NlDAZBC4sOsiJ/CZsUi8JWScHMOqS1pjBeOKQh4d5F+9iWeBL+vnj
	As8kmyaVvJYoqjfzrsM4odWcCpxub8I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-_7F8ukXgM3u5mY4z3nMRwA-1; Mon, 04 Jul 2022 22:42:34 -0400
X-MC-Unique: _7F8ukXgM3u5mY4z3nMRwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD84F1C0519F;
	Tue,  5 Jul 2022 02:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A2F040B40C6;
	Tue,  5 Jul 2022 02:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57FD0194704A;
	Tue,  5 Jul 2022 02:42:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B450D1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:42:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8AD2E2166B29; Tue,  5 Jul 2022 02:42:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8620D2166B26
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:42:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B16E185A7A4
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:42:30 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-X11YNikYN8ullPSZkMYFCg-1; Mon, 04 Jul 2022 22:42:21 -0400
X-MC-Unique: X11YNikYN8ullPSZkMYFCg-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205520277"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:42:19 +0800
IronPort-SDR: YkjZ3DJWlgRcITYtMr1y0/pjNOPjshNwu6yqchdZCy9X8zxTijX6ajkxIPpaC7TiD1bcXEoviL
 rJxr2VPrGrHdfrlIeP1SS+QxRNPaA2t99fT0inUiRGa0b3dRXtzQElTkjl6B8xaky0kDZBoPku
 vvjMxwz0bl9Z11hRFS3IZmtApdUBS8WGGPLKAgX0uj8ZB2E2+Ayf84S+nTFVQgG8gblMZDCQVn
 MdOdr45JQSS1WgP36x2B1umO1R2999VlEbNDk+qXj90B8Y7YjPnAh+99mudntPUZ1wQJ8UtFkY
 RyC4p3szAe9Qhe4Kt1KZjPMm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:04:11 -0700
IronPort-SDR: Gz4khhNCS4N/JnpyjACewzYWTE6Ue7f2py2y3LDIWRwhq99N+PgM7kdk10ACy8wAsEVUAgrxOu
 +IGiNk5eRgLNkIx2X9nAvXHD1xQ33ILstIvKFDe5hfigjOpy3adBNPQDsIJqNQrT/+zvIN9e22
 s6FBLOrf1pYeQNZJB9bdh/6W3Ik3pFm39LP3IUrQmk23F09BbPAuf3W/iL9Faw7SucJ5NfZwts
 16A7QKRtAtytaNZ/sUVbaoOsxmTlQeTdC5G0qBqwieDzx2+65BIKf+AZSCZGQsHyTA/tOHO91Y
 Zdc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:42:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRlv3sP1z1Rw4L
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:42:19 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id lAaf5TOqaaOd for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:42:19 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRlt1FH1z1RtVk;
 Mon,  4 Jul 2022 19:42:18 -0700 (PDT)
Message-ID: <1b49bf54-4272-b550-b1f8-4f5a46e2575a@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:42:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-11-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-11-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
>  block/blk-zoned.c | 8 +++++---
>  block/blk.h       | 4 ++--
>  block/genhd.c     | 2 +-
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 5a97b48102221..9085f9fb3ab42 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -449,8 +449,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  	return ret;
>  }
>  
> -void blk_queue_free_zone_bitmaps(struct request_queue *q)
> +void disk_free_zone_bitmaps(struct gendisk *disk)
>  {
> +	struct request_queue *q = disk->queue;
> +
>  	kfree(q->conv_zones_bitmap);
>  	q->conv_zones_bitmap = NULL;
>  	kfree(q->seq_zones_wlock);
> @@ -612,7 +614,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  		ret = 0;
>  	} else {
>  		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
> -		blk_queue_free_zone_bitmaps(q);
> +		disk_free_zone_bitmaps(disk);
>  	}
>  	blk_mq_unfreeze_queue(q);
>  
> @@ -628,7 +630,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
>  
>  	blk_mq_freeze_queue(q);
>  
> -	blk_queue_free_zone_bitmaps(q);
> +	disk_free_zone_bitmaps(disk);
>  	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
>  	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
>  	q->nr_zones = 0;
> diff --git a/block/blk.h b/block/blk.h
> index 7482a3a441dd9..b71e22c97d773 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -405,10 +405,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
>  #endif
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
> -void blk_queue_free_zone_bitmaps(struct request_queue *q);
> +void disk_free_zone_bitmaps(struct gendisk *disk);
>  void disk_clear_zone_settings(struct gendisk *disk);
>  #else
> -static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
> +static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
>  static inline void disk_clear_zone_settings(struct gendisk *disk) {}
>  #endif
>  
> diff --git a/block/genhd.c b/block/genhd.c
> index d0bdeb93e922c..9d30f159c59ac 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1165,7 +1165,7 @@ static void disk_release(struct device *dev)
>  
>  	disk_release_events(disk);
>  	kfree(disk->random);
> -	blk_queue_free_zone_bitmaps(disk->queue);
> +	disk_free_zone_bitmaps(disk);
>  	xa_destroy(&disk->part_tbl);
>  
>  	disk->queue->disk = NULL;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

