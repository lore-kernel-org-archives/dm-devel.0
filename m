Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,FSL_HELO_FAKE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B285C63777
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93E0320B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93E0320B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-JwaYVB6sPgiA8ZD-5RbJmA-1; Thu, 26 Nov 2020 03:36:50 -0500
X-MC-Unique: JwaYVB6sPgiA8ZD-5RbJmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D2231074655;
	Thu, 26 Nov 2020 08:36:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61CE35C1BD;
	Thu, 26 Nov 2020 08:36:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 367261809CA8;
	Thu, 26 Nov 2020 08:36:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQ1GYk5029517 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 20:16:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DB6251009B91; Thu, 26 Nov 2020 01:16:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6FFC1009B86
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 01:16:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEFBD858287
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 01:16:27 +0000 (UTC)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
	[209.85.210.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-265-zS13lUymMiiPkKA3n1x_2Q-1; Wed, 25 Nov 2020 20:16:23 -0500
X-MC-Unique: zS13lUymMiiPkKA3n1x_2Q-1
Received: by mail-pf1-f195.google.com with SMTP id w6so143605pfu.1;
	Wed, 25 Nov 2020 17:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=ffbgfORDd1J1xm3xxXp8xWzEs5sXbivtuhWMZ6CRpX8=;
	b=NLQ6DbAhGjQyeOmDq7rIELKw43JVlrnzWb+kY7QO1HdnKHtr5WGYSe4E0vts6PkAAB
	vRZlEiDqbf1+8HEB3Aj5Rlr7lSidR6TOyqIbXU7fJ/t/fY/G01kTgSZFY+OgUVS6DhQo
	r2M3fI5eJ37jQFoky3bedE/8wEJYAdEYjG8My1zIgqS7zbT3Mc0E7b+2m9vjhnA9QsQk
	wT0ker4t07IdHZVYn0otMwp6t2f5q5kV+a6rwnlKqmY4nQ/RzRfpBkJHenaYWX/nVEt6
	1jUuUFX2TqHulWLU3ma5hvdRO9RrEjseJUTp+YKR/o4o8KaifuPVmggyxFduNMofGia4
	lolg==
X-Gm-Message-State: AOAM532Nfyz7BExZsdS8DPYvy8jo3C/rWnnXNw7Pn8JORXCOhWh6iaoF
	2x2So9RtXzCoie/u3ExKREg=
X-Google-Smtp-Source: ABdhPJxuwzDVcKoe4o/wMgwyIQrHY+YPGkp4YxJA+sp/vPwpgqgEvxXOvnlOmZ0BtRJFwRde4WH8Zg==
X-Received: by 2002:a62:8cc6:0:b029:19a:87b1:99bb with SMTP id
	m189-20020a628cc60000b029019a87b199bbmr637857pfd.6.1606353381534;
	Wed, 25 Nov 2020 17:16:21 -0800 (PST)
Received: from google.com (c-67-188-94-199.hsd1.ca.comcast.net.
	[67.188.94.199]) by smtp.gmail.com with ESMTPSA id
	e128sm2978987pfe.154.2020.11.25.17.16.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 25 Nov 2020 17:16:20 -0800 (PST)
Date: Wed, 25 Nov 2020 17:16:16 -0800
From: Minchan Kim <minchan@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126011616.GB57352@google.com>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-62-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-62-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 26 Nov 2020 03:35:50 -0500
Cc: Justin Sanders <justin@coraid.com>, sergey.senozhatsky.work@gmail.com,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 61/78] zram:  do not call set_blocksize
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 16, 2020 at 03:57:52PM +0100, Christoph Hellwig wrote:
> set_blocksize is used by file systems to use their preferred buffer cache
> block size.  Block drivers should not set it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks.

> ---
>  drivers/block/zram/zram_drv.c | 11 +----------
>  drivers/block/zram/zram_drv.h |  1 -
>  2 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 3641434a9b154d..d00b5761ec0b21 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -403,13 +403,10 @@ static void reset_bdev(struct zram *zram)
>  		return;
>  
>  	bdev = zram->bdev;
> -	if (zram->old_block_size)
> -		set_blocksize(bdev, zram->old_block_size);
>  	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  	/* hope filp_close flush all of IO */
>  	filp_close(zram->backing_dev, NULL);
>  	zram->backing_dev = NULL;
> -	zram->old_block_size = 0;
>  	zram->bdev = NULL;
>  	zram->disk->fops = &zram_devops;
>  	kvfree(zram->bitmap);
> @@ -454,7 +451,7 @@ static ssize_t backing_dev_store(struct device *dev,
>  	struct file *backing_dev = NULL;
>  	struct inode *inode;
>  	struct address_space *mapping;
> -	unsigned int bitmap_sz, old_block_size = 0;
> +	unsigned int bitmap_sz;
>  	unsigned long nr_pages, *bitmap = NULL;
>  	struct block_device *bdev = NULL;
>  	int err;
> @@ -509,14 +506,8 @@ static ssize_t backing_dev_store(struct device *dev,
>  		goto out;
>  	}
>  
> -	old_block_size = block_size(bdev);
> -	err = set_blocksize(bdev, PAGE_SIZE);
> -	if (err)
> -		goto out;
> -
>  	reset_bdev(zram);
>  
> -	zram->old_block_size = old_block_size;
>  	zram->bdev = bdev;
>  	zram->backing_dev = backing_dev;
>  	zram->bitmap = bitmap;
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index f2fd46daa76045..712354a4207c77 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -118,7 +118,6 @@ struct zram {
>  	bool wb_limit_enable;
>  	u64 bd_wb_limit;
>  	struct block_device *bdev;
> -	unsigned int old_block_size;
>  	unsigned long *bitmap;
>  	unsigned long nr_pages;
>  #endif
> -- 
> 2.29.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

