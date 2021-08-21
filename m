Return-Path: <SRS0=TqWE=NM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01E4C4338F
	for <dm-devel@archiver.kernel.org>; Sat, 21 Aug 2021 03:19:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F5AD61178
	for <dm-devel@archiver.kernel.org>; Sat, 21 Aug 2021 03:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F5AD61178
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-wuWjM6xpMfWbbyiQ_aH1UQ-1; Fri, 20 Aug 2021 23:19:20 -0400
X-MC-Unique: wuWjM6xpMfWbbyiQ_aH1UQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5471A1008060;
	Sat, 21 Aug 2021 03:19:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B32D9369A;
	Sat, 21 Aug 2021 03:19:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EBAF94BB7C;
	Sat, 21 Aug 2021 03:19:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17L3HCgM016920 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 23:17:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BC34201AC41; Sat, 21 Aug 2021 03:17:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6710C200D8ED
	for <dm-devel@redhat.com>; Sat, 21 Aug 2021 03:17:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC4EA800883
	for <dm-devel@redhat.com>; Sat, 21 Aug 2021 03:17:09 +0000 (UTC)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com
	[209.85.161.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-173-pCRCJHZxO_-AVSDjKf-7Qw-1; Fri, 20 Aug 2021 23:17:05 -0400
X-MC-Unique: pCRCJHZxO_-AVSDjKf-7Qw-1
Received: by mail-oo1-f42.google.com with SMTP id
	o17-20020a4a64110000b0290263e1ba7ff9so3490723ooc.2; 
	Fri, 20 Aug 2021 20:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
	:date:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=MSn7rAHilGstrynTKOQuRFaHHLuxeNAIbh4aZ/yLE2M=;
	b=hP/O+7KJugnuODSV0GfHuOjXnv2+9CuSfUtvFQAJ/IotbBWtz/0ohGt9x9YBFQQmfB
	7k34LCzHgz/wZb0pB9IJ1P26lImfpZ7y0fytXlzNNdCFbs7nYW3gWM2OeDcdi5z37NJ5
	PBhNxbCzKOVo45ZzO9kMh0dYTGK4/76NlNZLbJLYE6m9oCOL/US5IJgyiu9W9pHP7gXF
	vxEjGuw6BPnW7XD0X6WbdjJAt3PEI6BgAbLOvwu8V0B/rwsftyyi+rDBLwQVQhWvmrxT
	4WIcGlm1nOfdB63QwJlj7ed/+EqIgL9nkZ8x37q9e/3kSafBCZBZX6w+OsAibMiLWyqL
	oZvQ==
X-Gm-Message-State: AOAM530+7PF/ROySbq50DFXHfKorMwedCzXleFHJGlxOyDZe+ojM6Rci
	sXWHx89oNFWKil7t58QFpYb6ie8f/tQ=
X-Google-Smtp-Source: ABdhPJz5QoGE5JSa2c7qhLnCr2DfM5AAEX5WXbVUcUlWlBtw/2nBLJjOv+IU9Qi2MRv4sv3YLAZfdw==
X-Received: by 2002:a4a:8d41:: with SMTP id x1mr18707795ook.46.1629515824292; 
	Fri, 20 Aug 2021 20:17:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
	by smtp.gmail.com with ESMTPSA id
	s35sm1892362otv.44.2021.08.20.20.17.02
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 20 Aug 2021 20:17:03 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
	<a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
	<20210816072158.GA27147@lst.de> <20210816141702.GA3449320@roeck-us.net>
	<20210820150803.GA490@lst.de>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <9c2943fd-b540-1f49-43c3-906cbaddd1a5@roeck-us.net>
Date: Fri, 20 Aug 2021 20:17:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210820150803.GA490@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/20/21 8:08 AM, Christoph Hellwig wrote:
> Please try the patch below:
> 
> ---
>>From 7609266da56160d211662cd2fbe26570aad11b15 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 20 Aug 2021 17:00:11 +0200
> Subject: mtd_blkdevs: don't hold del_mtd_blktrans_dev in
>   blktrans_{open,release}
> 
> There is nothing that this protects against except for slightly reducing
> the window when new opens can appear just before calling del_gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A cautious

Tested-by: Guenter Roeck <linux@roeck-us.net>

Cautious because -next is a bit broken right now and I can not run a complete
test for all images.

Guenter

> ---
>   drivers/mtd/mtd_blkdevs.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index 44bea3f65060..6b81a1c9ccbe 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -207,7 +207,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
>   	if (!dev)
>   		return -ERESTARTSYS; /* FIXME: busy loop! -arnd*/
>   
> -	mutex_lock(&mtd_table_mutex);
>   	mutex_lock(&dev->lock);
>   
>   	if (dev->open)
> @@ -233,7 +232,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
>   unlock:
>   	dev->open++;
>   	mutex_unlock(&dev->lock);
> -	mutex_unlock(&mtd_table_mutex);
>   	blktrans_dev_put(dev);
>   	return ret;
>   
> @@ -244,7 +242,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
>   	module_put(dev->tr->owner);
>   	kref_put(&dev->ref, blktrans_dev_release);
>   	mutex_unlock(&dev->lock);
> -	mutex_unlock(&mtd_table_mutex);
>   	blktrans_dev_put(dev);
>   	return ret;
>   }
> @@ -256,7 +253,6 @@ static void blktrans_release(struct gendisk *disk, fmode_t mode)
>   	if (!dev)
>   		return;
>   
> -	mutex_lock(&mtd_table_mutex);
>   	mutex_lock(&dev->lock);
>   
>   	if (--dev->open)
> @@ -272,7 +268,6 @@ static void blktrans_release(struct gendisk *disk, fmode_t mode)
>   	}
>   unlock:
>   	mutex_unlock(&dev->lock);
> -	mutex_unlock(&mtd_table_mutex);
>   	blktrans_dev_put(dev);
>   }
>   
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

