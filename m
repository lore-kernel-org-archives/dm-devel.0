Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74134C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7IHgZ7V0Ff3QN1QKOuTVkA3hlit63bYSGiMTeTd4dhU=;
	b=Ce9n52RkCbEJz7OXy2hIKRwQHcEguTsfv7uF8rIDLsHD7q22zXJwf9hKzSFD6DhzCtrxIZ
	eVXODHj/OlU0cBbFsdaUuIisNkvc+qjZrTT/F7H+KU9HSLHEHKbvZcvNCCPLktLLFJSy6c
	Ld4JjfGO5CBpgmHjPDoOie7G4V8I7o0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-OM_Bh8K_PESSpvIYtITChg-1; Mon, 04 Jul 2022 22:43:16 -0400
X-MC-Unique: OM_Bh8K_PESSpvIYtITChg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21EB13C01DA2;
	Tue,  5 Jul 2022 02:43:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11CB340E7F29;
	Tue,  5 Jul 2022 02:43:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A530C194704A;
	Tue,  5 Jul 2022 02:43:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0CDE1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:43:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5911112131B; Tue,  5 Jul 2022 02:43:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A178E1121315
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:43:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87319185A7A4
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:43:12 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-7i2rvJTPPPCjLI_re8xzuw-1; Mon, 04 Jul 2022 22:43:10 -0400
X-MC-Unique: 7i2rvJTPPPCjLI_re8xzuw-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="209700546"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:43:07 +0800
IronPort-SDR: bwApCJ955OzTnHN8iWMXr8Avu6LTIaen6cYurz/jf7W9jdxxorL/+q5LWPOATMjy2cN4xtmFr7
 HStfFkKYezgjbnc3oQHTEGZpZm4k3LYh7tJ0097aoZSeVgyN0eXo8OE0bfoa/npL2tWuSfcVPs
 UU3BmK+4bY55dpe3QzGsW5206RgtOectGUsUi6XJNJ6kt9iFVqg44xKvzsbcOp3ksSYGHnQhCv
 Fz1rD9B1sCGx6Giy5PX8E/CcYKsN1B+lhCGyjPJ0pWp7VvjLzUyReck+scJrhZAYDg58HLiK8l
 a0JJYVqFmHTqSzAVMbVi7u/c
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:00:28 -0700
IronPort-SDR: DohDl9VKdZo4KN84KekSSb6eI2ImD3y0VvZLlOiNUUQNJcu+bhKj5yK/fUtWk2fwX4NMuJAAuw
 VwzLkraJGrwZtRfXL+W8jYNgAv2BxGLGqwyFX5aK8pHplSX/+ksvVMXvJ0PJ1mUbBEgYqZia6P
 hiA/goq1HwR4vLTskRY7SD87wTrRWqS3T/BpMbLEmKgX+WP+n9b1fB40OHnQBGLmX2bBOjarox
 UD84QSy7N4d4eEUz4vbkMTKVtexNPyMPzP1t6C8Ez2q0wjiOIW92rqxMuOlNwSDLVesqjCu7dj
 gzs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:43:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRmr50YYz1Rw4L
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:43:08 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id mb863Thdr0TA for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:43:08 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRmq1bd3z1RtVk;
 Mon,  4 Jul 2022 19:43:07 -0700 (PDT)
Message-ID: <c8f470fd-be57-8d04-cce3-30c4701f8864@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:43:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-12-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-12-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
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
> Always use the bdev based helpers instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


> ---
>  block/blk-sysfs.c      |  4 ++--
>  include/linux/blkdev.h | 37 ++++++++++---------------------------
>  2 files changed, 12 insertions(+), 29 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 7590810cf13fc..5ce72345ac666 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -330,12 +330,12 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
>  
>  static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
>  {
> -	return queue_var_show(queue_max_open_zones(q), page);
> +	return queue_var_show(bdev_max_open_zones(q->disk->part0), page);
>  }
>  
>  static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
>  {
> -	return queue_var_show(queue_max_active_zones(q), page);
> +	return queue_var_show(bdev_max_active_zones(q->disk->part0), page);
>  }
>  
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ddf8353488fc8..a14cc3e46e6ad 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -704,21 +704,22 @@ static inline void blk_queue_max_open_zones(struct request_queue *q,
>  	q->max_open_zones = max_open_zones;
>  }
>  
> -static inline unsigned int queue_max_open_zones(const struct request_queue *q)
> -{
> -	return q->max_open_zones;
> -}
> -
>  static inline void blk_queue_max_active_zones(struct request_queue *q,
>  		unsigned int max_active_zones)
>  {
>  	q->max_active_zones = max_active_zones;
>  }
>  
> -static inline unsigned int queue_max_active_zones(const struct request_queue *q)
> +static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
> +{
> +	return bdev->bd_disk->queue->max_open_zones;
> +}
> +
> +static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
> -	return q->max_active_zones;
> +	return bdev->bd_disk->queue->max_active_zones;
>  }
> +
>  #else /* CONFIG_BLK_DEV_ZONED */
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>  {
> @@ -734,11 +735,11 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>  {
>  	return 0;
>  }
> -static inline unsigned int queue_max_open_zones(const struct request_queue *q)
> +static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }
> -static inline unsigned int queue_max_active_zones(const struct request_queue *q)
> +static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }
> @@ -1316,24 +1317,6 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
>  	return 0;
>  }
>  
> -static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
> -{
> -	struct request_queue *q = bdev_get_queue(bdev);
> -
> -	if (q)
> -		return queue_max_open_zones(q);
> -	return 0;
> -}
> -
> -static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
> -{
> -	struct request_queue *q = bdev_get_queue(bdev);
> -
> -	if (q)
> -		return queue_max_active_zones(q);
> -	return 0;
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

