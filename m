Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82DAC43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988038;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=trTnfX3y5XEzWgRWl+3lY+950qFohXaeJ1Y6KztRuIQ=;
	b=WkIplspJwWm90g76kcIMtqa31CDTMpGjgCuRhY+TASiljcWuZg+PxLeze5PAqsk3LsKyWO
	tOmTXkBADVAstRxUHVbwqRgTKskMCatKnfyU/Av9NJBcEi4LE5T2YhTJo6AzffXsX+uatQ
	bG6yOka7oZckF9y7nd2R76TiP3annoM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-pNVKBL4PPMi0fxrbZBqKAQ-1; Mon, 04 Jul 2022 22:27:15 -0400
X-MC-Unique: pNVKBL4PPMi0fxrbZBqKAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E815D81D9CA;
	Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D72582026D64;
	Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF2C9194704A;
	Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 494E81947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31FE44010FA6; Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E1DD40474E3
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16FD31C06EEA
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:27:13 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-y5WxMg4aP8O-5BVlB3aRhg-1; Mon, 04 Jul 2022 22:27:11 -0400
X-MC-Unique: y5WxMg4aP8O-5BVlB3aRhg-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="204806021"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:27:08 +0800
IronPort-SDR: ZDJch6XEh3czKnzkVX1J47nG6TjWOll9YBdCBl0p2F8ZapdmY2wi9w7NVHloz6vn1amVKBAvEq
 vlhWU94OOlXuyt2gWZdLljZeq1A5zQKrHyCYafLrwlC/JcJ53CtOAX1bPGJzkV6xDiLTGkT3kg
 rgWvREOWIMI3WUOy1R77YXYmEmZvKh+2Q4oZk7++EXYP+WRCbvE+GAkVIcR+afcYe/+S3wY5YE
 iZnZfhGBlGz+vnCfy969IomaALMJElqYAoWuHI6i/DqYlQAUIyIT1p3MZL5iPNbrRZU/J6eHEo
 LQgFA5aIZSeX8HoOoi1VFZr8
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:49:00 -0700
IronPort-SDR: RToAx64vrt3RxUiaeFHW9vIAfk9BekJ1Wf80zhNwIL0PQzuWmyMImvGUcshseymK52mlb279J1
 peGjT1vsrz1OL5IZaESdp05IIoU/oEVZmd1W3V9W6Nc+XAGMxmXOirLhg1xvtcOb1TyNzsGA85
 pvpJvyr/c/alSheqYwQqHEoFfIwMjON+ifi5+w+/T7rrYu2h8c2Za2HorVIW3DgNfXNRCV2vv7
 gjcrZ3vKjilVRlgmuZArh9zeqAzxIbbhKGcmTAbxt4QRcqmd8c7qB2AWoe5qVAynNOD21VsM5C
 eak=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:27:10 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRQP3F6Sz1Rwqy
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:27:09 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id n7HY_0xLp_p6 for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:27:08 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRQN0bjRz1RtVk;
 Mon,  4 Jul 2022 19:27:07 -0700 (PDT)
Message-ID: <2938c7b0-aeb5-f540-1c07-58551c449a3c@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:27:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-3-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 02/17] block: call
 blk_queue_free_zone_bitmaps from disk_release
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> The zone bitmaps are only used for non-passthrough I/O, so free them as
> soon as the disk is released.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-sysfs.c | 2 --
>  block/genhd.c     | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 58cb9cb9f48cd..7590810cf13fc 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -776,8 +776,6 @@ static void blk_release_queue(struct kobject *kobj)
>  	blk_free_queue_stats(q->stats);
>  	kfree(q->poll_stat);
>  
> -	blk_queue_free_zone_bitmaps(q);
> -
>  	if (queue_is_mq(q))
>  		blk_mq_release(q);
>  
> diff --git a/block/genhd.c b/block/genhd.c
> index b1fb7e058b9cc..d0bdeb93e922c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1165,6 +1165,7 @@ static void disk_release(struct device *dev)
>  
>  	disk_release_events(disk);
>  	kfree(disk->random);
> +	blk_queue_free_zone_bitmaps(disk->queue);
>  	xa_destroy(&disk->part_tbl);
>  
>  	disk->queue->disk = NULL;

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

