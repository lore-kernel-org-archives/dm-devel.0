Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3238DC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 16:38:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-HfawJFnrNCCONndRu5dNxA-1; Tue, 03 May 2022 12:38:19 -0400
X-MC-Unique: HfawJFnrNCCONndRu5dNxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26A8A1DC2437;
	Tue,  3 May 2022 16:38:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC0751121320;
	Tue,  3 May 2022 16:38:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DEB91947049;
	Tue,  3 May 2022 16:38:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3E321947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 16:38:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4D67111E411; Tue,  3 May 2022 16:38:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA701121320
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:38:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30A1F811E80
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:38:09 +0000 (UTC)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-cp7efYOwPfOBRmLtbDDoLQ-1; Tue, 03 May 2022 12:38:03 -0400
X-MC-Unique: cp7efYOwPfOBRmLtbDDoLQ-1
Received: by mail-pf1-f178.google.com with SMTP id j6so15139883pfe.13;
 Tue, 03 May 2022 09:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=lyBgny2owanKpSK297XC+SuygGQevv1e+zn1E24si/Y=;
 b=AT6NmF5XN+xLdxE4g66PYS7AvbRUYR+aoKtEs7kJFMYfzholDBKmy61QvFsTdSVtXZ
 HshlXGEDsBHiK0XNBNrElo1KeRg9HOG9p2LVDoK17jxrcTzLC5WnLGCjI9SKdxXrikQX
 yg8etxJ2pA74kCchVAEyjQhvu44+kOcd3VyKzQ3Lp1lPH5Qm7si7XJqvafDb6RW2HBmJ
 pr2bIR55T1aW5kI10tgC5Xpbec3tAIKbeYoAO/gdGep1p1V324KyBA1upMkMOMypzcEq
 i8UFVsq8u0+LlBar81NySwVXn+HEP0rerHh3eW4BZE8rh4888r9b4kWn8ov3vfhKSDXG
 shjg==
X-Gm-Message-State: AOAM531u04r1yDy9SJu0Phic5eD5OGoxSLSDDNUH+G9/4o1UGtuxPXw6
 NI0nS0Iohmyxiy0ybuZ50EI=
X-Google-Smtp-Source: ABdhPJzonovBzoV4fwi9NXoKhV1eYPIxcI7yjfJw6mLDHLxG6LjY81SsAeWrZCq7zhToKZSiSL9kvA==
X-Received: by 2002:a63:5020:0:b0:39e:5d26:4316 with SMTP id
 e32-20020a635020000000b0039e5d264316mr14532146pgb.294.1651595882292; 
 Tue, 03 May 2022 09:38:02 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
 by smtp.gmail.com with ESMTPSA id
 u17-20020a170903125100b0015e8d4eb27bsm6564629plh.197.2022.05.03.09.37.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 09:38:01 -0700 (PDT)
Message-ID: <3a178153-62c0-e298-ccb0-0edfd41b7ee2@acm.org>
Date: Tue, 3 May 2022 09:37:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895@eucas1p2.samsung.com>
 <20220427160255.300418-2-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 01/16] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
Cc: jiangbo.365@bytedance.com, kch@nvidia.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/27/22 09:02, Pankaj Raghav wrote:
> Adapt blkdev_nr_zones and blk_queue_zone_no function so that it can
> also work for non-power-of-2 zone sizes.
> 
> As the existing deployments of zoned devices had power-of-2
> assumption, power-of-2 optimized calculation is kept for those devices.
> 
> There are no direct hot paths modified and the changes just
> introduce one new branch per call.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   block/blk-zoned.c      | 8 +++++++-
>   include/linux/blkdev.h | 8 +++++++-
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 38cd840d8838..1dff4a8bd51d 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -117,10 +117,16 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>   unsigned int blkdev_nr_zones(struct gendisk *disk)
>   {
>   	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
> +	sector_t capacity = get_capacity(disk);
>   
>   	if (!blk_queue_is_zoned(disk->queue))
>   		return 0;
> -	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return (capacity + zone_sectors - 1) >>
> +		       ilog2(zone_sectors);
> +
> +	return div64_u64(capacity + zone_sectors - 1, zone_sectors);
>   }
>   EXPORT_SYMBOL_GPL(blkdev_nr_zones);

Does anyone need support for more than 4 billion sectors per zone? If 
not, do_div() should be sufficient.

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 60d016138997..c4e4c7071b7b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -665,9 +665,15 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>   static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>   					     sector_t sector)
>   {
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +
>   	if (!blk_queue_is_zoned(q))
>   		return 0;
> -	return sector >> ilog2(q->limits.chunk_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return sector >> ilog2(zone_sectors);
> +
> +	return div64_u64(sector, zone_sectors);
>   }

Same comment here.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

