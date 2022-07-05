Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8B8C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988008;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=odFGwZOUGtUlRNnjJCA7SNgMGah9w5pAFjRgT4aX7r4=;
	b=HYybS1A2HHklq7Pe5ZMmlaGn/rU9PoTzIdFNK28t/Oww37FNQ0WgdT+N9MuVzO+/NHMgxT
	ZHSUp2Sz4+diNnA9UnhI77+GFyhdwoQ7RqikIOBRe+3L+fMHil26E6pJPUoFqsRrP+elcn
	dvM8raXk9lnexC5uebySOFygahO6yFU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-VaECViCSPBO8RVOxZyY7EQ-1; Mon, 04 Jul 2022 22:26:45 -0400
X-MC-Unique: VaECViCSPBO8RVOxZyY7EQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0059F811E80;
	Tue,  5 Jul 2022 02:26:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5375492C3B;
	Tue,  5 Jul 2022 02:26:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76353194704A;
	Tue,  5 Jul 2022 02:26:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26ECE1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:26:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3A52111F5; Tue,  5 Jul 2022 02:26:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF86018EB7
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:26:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9943A185A7B2
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:26:39 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-WSLqfly6Mku1n2ZU1973aw-1; Mon, 04 Jul 2022 22:26:37 -0400
X-MC-Unique: WSLqfly6Mku1n2ZU1973aw-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="309128373"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:26:35 +0800
IronPort-SDR: hFxYoA8vxqpvr1xKkmbq4/smqT0JCQkNf2GD8bvvTnZjg38/hgi93lKrVD44C1o/XbKwD9dSsA
 QlSfaXGFpgzEEDs+2lU5ujEk6g9uBc1Kqvlrx+04v97QjVJMxzs+P2zDIdi19vHpKV63KG4sqv
 i3YU1sI0op3YkHvV8kWZWH9qQUgc1q1MLvp+H184ls4s+UmqxkyoLdfwemzdKPfvWoXgHPXxa/
 CPtzPFzPJksCm+QUtAN70G60ykX1YKGwiI5uHkFtrjC3vtgxrVQo9rsDB41lB/tkZMhs8nqvo4
 MDkvqpZ82RgHtgZSAFcQv5AM
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:43:54 -0700
IronPort-SDR: VwPToROZCciVaEHynlx6M55boFeZox3ELjmpBKMpYz56jj5AhRQx+UB0CIXT5DYcrG2LlReXP3
 TTuya+2JItIvxv3/M+zfYkKA5oNzcmi6w2mriDeH4uoRpzAphn6kKYAW0VGzArm/4hcGrFgeYb
 IBESCZYWMRtOSiE4U8PkGK6XVDE65kQvENPJXlJ+AGLV6ySrt2BMUGsxXIBZcYejvCChKT/dO6
 gxNeVr+2BjKKiuF9rwMqvXk8N4oaAxDxhPS2zw54tcukrI316CPMf6qTPMV5l02VTwuiE2h1Vf
 WWM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:26:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRPl49VCz1Rw4L
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:26:35 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id k0xIhEfRHpWl for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:26:35 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRPk0fwcz1RtVk;
 Mon,  4 Jul 2022 19:26:33 -0700 (PDT)
Message-ID: <cf7b3c89-b820-9b27-b3ed-b9b625e59482@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:26:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 01/17] block: remove a superflous ifdef in
 blkdev.h
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> It doesn't hurt to lways have the blk_zone_cond_str prototype, and the

s/lways/always

> two inlines can also be defined unconditionally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b9a94c53c6cd3..270cd0c552924 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -899,8 +899,6 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>  	return bdev->bd_queue;	/* this is never NULL */
>  }
>  
> -#ifdef CONFIG_BLK_DEV_ZONED
> -
>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);

This is defined in block/blk-zoned.c and so not compiled if
CONFIG_BLK_DEV_ZONED is not defined. But I guess this should be fine since
if there is a user of this function with !CONFIG_BLK_DEV_ZONED, a build
should fail anyway.

>  
> @@ -915,7 +913,6 @@ static inline unsigned int bio_zone_is_seq(struct bio *bio)
>  	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
>  				     bio->bi_iter.bi_sector);
>  }
> -#endif /* CONFIG_BLK_DEV_ZONED */
>  
>  /*
>   * Return how much of the chunk is left to be used for I/O at a given offset.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

