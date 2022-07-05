Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10EFC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988927;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=m/K11+H4DLYb+OO0l7YScWdMosWjsFRlIKO2ly7OtQ0=;
	b=DWxCeuJBHud3AozDSQUT2h7IRAfn4C0J8ayzWWGJOPRrfxAEOgGghjzAyMMKlN2QqSM/Pi
	RfC+ABUumrFG3OvWKNNWQxOq+OTSzLkr/OX/yc7gxmTETawFVgoC4wiJihV/qz/1OtbUos
	4J/ObqjOyGs8wJksZxT0HClc8Mr4TIk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-ky9byko3NgWmYAWCQ8tWfw-1; Mon, 04 Jul 2022 22:42:06 -0400
X-MC-Unique: ky9byko3NgWmYAWCQ8tWfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83F40811E75;
	Tue,  5 Jul 2022 02:42:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73AFA2166B26;
	Tue,  5 Jul 2022 02:42:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EB21194704A;
	Tue,  5 Jul 2022 02:42:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE1DC1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:42:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 816BE1415130; Tue,  5 Jul 2022 02:42:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D2AC141510F
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:42:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64484185A7B2
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:42:02 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-A19gs6yCPX62d-AVsh-uaQ-1; Mon, 04 Jul 2022 22:42:00 -0400
X-MC-Unique: A19gs6yCPX62d-AVsh-uaQ-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="203466803"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:41:58 +0800
IronPort-SDR: VLuTEOo93w1z8yZvzce921JiOKjvdlF7+Pw6m6Mmv0RAteeMkS0lF6gXmOTfBqH22dK4CyD5Qv
 bVQnEh+OlYAtdwPoEfo3D1KatrnQVt9E7/udoW40dJ7VYVzyLJYMydCVgbph6rbhxAMdOuFHth
 KWofAFDLBir0SFw/Qag3HUWycXWEwAXwY5cvRSGnmpuXVR2/8jA3xPmIPYBAQ9SqAG1WCoDAXS
 1E9HOX5BG7MpsGpKOYw8D7mXbYehZNhTYOvdiJ55btVb9mZlTaTKBDRPza4P8o0G0ZTHQJdcF9
 smimELyiMBZu1OACpBkP8iXN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:59:17 -0700
IronPort-SDR: x6mNVoPiiVhf4T/YHeXu2xVuzoy2WDEfasAQyLH5OSPHo/HZ33+u1uxlpFM39UsJSnKVr1QGJo
 mMi9RMq0SjZ0IOaxqbXB5yXItCtVRLX0sdPI9sTkREq99+jp0lGogMMOqcZSlEeCaJeD5LL7Vc
 +C37jXmXEKXpFkWXKai7Lx3+v6ZhyLBiM1IpF7f9JtGtneoW8b3K1A7hX/pMwG+mKRvItFIZ8Z
 g4/NvPJgeOtDIl3i503o3Z5DT9CTdm5lckui1GkncjsYK4ywSk2bsFP7TU5incYORS6o9WxjVV
 GZ4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:41:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRlV0xV2z1Rwqy
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:41:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id ake7KHecV3Gv for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:41:57 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRlS47xBz1RtVk;
 Mon,  4 Jul 2022 19:41:56 -0700 (PDT)
Message-ID: <fe0c09f3-0c0c-0527-88aa-21e13d91a23c@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:41:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-10-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
>  block/blk-settings.c | 2 +-
>  block/blk-zoned.c    | 4 +++-
>  block/blk.h          | 4 ++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 35b7bba306a83..8bb9eef5310eb 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -946,7 +946,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  		blk_queue_zone_write_granularity(q,
>  						queue_logical_block_size(q));
>  	} else {
> -		blk_queue_clear_zone_settings(q);
> +		disk_clear_zone_settings(disk);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(disk_set_zoned);
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 7fbe395fa51fc..5a97b48102221 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -622,8 +622,10 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  }
>  EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
>  
> -void blk_queue_clear_zone_settings(struct request_queue *q)
> +void disk_clear_zone_settings(struct gendisk *disk)
>  {
> +	struct request_queue *q = disk->queue;
> +
>  	blk_mq_freeze_queue(q);
>  
>  	blk_queue_free_zone_bitmaps(q);
> diff --git a/block/blk.h b/block/blk.h
> index 58ad50cacd2d5..7482a3a441dd9 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -406,10 +406,10 @@ static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
>  void blk_queue_free_zone_bitmaps(struct request_queue *q);
> -void blk_queue_clear_zone_settings(struct request_queue *q);
> +void disk_clear_zone_settings(struct gendisk *disk);
>  #else
>  static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
> -static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
> +static inline void disk_clear_zone_settings(struct gendisk *disk) {}
>  #endif
>  
>  int blk_alloc_ext_minor(void);


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

