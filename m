Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9C4C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WQ9HMg60ATPzpFd+6VegjaW75VSFixzqHUTh0Vu+xrs=;
	b=X7hXdCC5DD+qXdguMiwR3LXLjceOyj8MAfmU5NlOzFsJuKGIvX/vs/sUr+/KfQ8V16vKJp
	Ka0uspa63MxjTyO2gHGj5uG2acF30W6VWC7xfGL/wQ+jgj90gnvHz3Yf9YJaWBYdk5Vvew
	7GsM1zzOldjdvZQYijcxDw55uvWwwho=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-gz9GbpzhP1W5UUj4QUrSdQ-1; Mon, 04 Jul 2022 22:54:21 -0400
X-MC-Unique: gz9GbpzhP1W5UUj4QUrSdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 718AA8001EA;
	Tue,  5 Jul 2022 02:54:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 60B511410F3C;
	Tue,  5 Jul 2022 02:54:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3AE44194704A;
	Tue,  5 Jul 2022 02:54:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 500441947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:54:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C7CC40B40C6; Tue,  5 Jul 2022 02:54:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2872440CF8EB
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:54:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1096D1019C88
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:54:18 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-2nIMZPWmNpCZDB4lTNezMw-1; Mon, 04 Jul 2022 22:54:16 -0400
X-MC-Unique: 2nIMZPWmNpCZDB4lTNezMw-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="204808228"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:54:13 +0800
IronPort-SDR: eQ4C/i5rYhO7QBgCIe/3qbFeTER54JM+VYLspF3jwB91rCmXHj0gYnTIVl0QpT/KRRCrVJHulg
 OrPBMqIeVxpCDOMz/jGxGO38YRRUpE0k2OHlDsCpeu3bp9ufgeFrCWLFOm5SyC8rMP/mWOulz6
 KKFLWoVwU2vyhnl2ZoR4SVrRR2C7bwvFx2lYHwJ421FLjkwkNzDABbfMp2t3iXjgxKbPXY3ETE
 4B0cUVdFKUZTuZ9Q6yiS6Io/ETmKYczcpJ5+Fx0sd2F6694zavr1JWFygW5zST9M+iDxr5V5pL
 6U8VhdJXK7+m1trjWSJY7itH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:16:06 -0700
IronPort-SDR: HClMINnCBlbG8MrGy9kIoPaqkchg+QctesBkCLMz6cTVCWYxe7HUdACPNJ6wNDCqQ80BUNZI5b
 GYJL+SuoJNVEwkfGjoR+Bb6WvTQ04ljJ9GIIAZ2LuGyvTTf/SoXj/8TDrln5auuWyKFKcgVWDG
 /pUjCgQV39yK6Qh0l0wYPQJC7J3w7qh/96SPBJDCI83ry5ROeBpykUDJVb6S43sNPGvpcFL0VB
 adP1qcOqIsinBG4+vXL99bTIATgAEStIBL7zcM1mS6KDtJmi/tUMP7FhrkQIpn67BAUAo8YMU6
 dfc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:54:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS1f698lz1Rwqy
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:54:14 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id xUT0k8TJoOAP for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:54:14 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS1d2xSKz1RtVk;
 Mon,  4 Jul 2022 19:54:13 -0700 (PDT)
Message-ID: <95cab434-b11c-fd49-5b4e-5e80b5850030@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:54:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-15-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-15-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 14/17] block: use bdev based helpers in
 blkdev_zone_mgmt / blkdev_zone_mgmt_all
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use the bdev based helpers instead of the queue based ones to clean up
> the code a bit and prepare for storing all zone related fields in
> struct gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-zoned.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 836b96ebfdc04..ee8752f083a94 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -190,8 +190,8 @@ int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>  			 gfp_t gfp_mask)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
> -	sector_t capacity = get_capacity(bdev->bd_disk);
> -	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	sector_t capacity = bdev_nr_sectors(bdev);
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
>  	unsigned long *need_reset;
>  	struct bio *bio = NULL;
>  	sector_t sector = 0;
> @@ -262,8 +262,8 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  		     gfp_t gfp_mask)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
> -	sector_t zone_sectors = blk_queue_zone_sectors(q);
> -	sector_t capacity = get_capacity(bdev->bd_disk);
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
> +	sector_t capacity = bdev_nr_sectors(bdev);
>  	sector_t end_sector = sector + nr_sectors;
>  	struct bio *bio = NULL;
>  	int ret = 0;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

