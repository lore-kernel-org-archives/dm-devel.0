Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE3BC63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:00:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E985206D8
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E985206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-4sCv9zv8NQq2q8NGMlTC4w-1; Tue, 24 Nov 2020 12:00:40 -0500
X-MC-Unique: 4sCv9zv8NQq2q8NGMlTC4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 534AF80F050;
	Tue, 24 Nov 2020 17:00:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1955C60BE5;
	Tue, 24 Nov 2020 17:00:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17CD3180954D;
	Tue, 24 Nov 2020 17:00:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOH0IL3017285 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:00:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 765E3176C7; Tue, 24 Nov 2020 17:00:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70C79175AE
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:00:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF9E1811E97
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:00:15 +0000 (UTC)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
	[209.85.160.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-311-UZvj0-4ZPWi_fuIUNWiz_w-1; Tue, 24 Nov 2020 12:00:12 -0500
X-MC-Unique: UZvj0-4ZPWi_fuIUNWiz_w-1
Received: by mail-qt1-f195.google.com with SMTP id l7so10270013qtp.8;
	Tue, 24 Nov 2020 09:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=fWmahOo+BxCVV9NEre8zWFBYKORZfhSvfmLWizAk7Sk=;
	b=MiBujcycx4tgZQFsgbjrKByQtcKjlJzedZwez5cjHfkEe515/AAs4qdPuOZe0MDNCa
	oP8w5f1Pv1wvQovVtWv68/ErQN77apQO/k/2HHm40IoKhPHrE2nGHCPlKW4AruYKPMFU
	Hleo0ZRfCh/7YHeZaJP9rtBCp0KgXnZd6TA9aZwQxXLOzAgkuJ7Z/H0cDmmIOR8VvNVq
	v9acvMiuNSf288b2blNrZpG+wV1qM0lvhasdgI8cELLRVwZ8BItgDOEKk39XqkFASOfD
	Tjl1o5zEsryfmEu+dlOgXwJmNtHq77BE/disO4OfLJ1CjXmVirbl7dnHJQKI0f4Bw2JF
	qung==
X-Gm-Message-State: AOAM531P+c+4qx4qt/YW0ntg+Y2dRQkO2hoaFqgwbCZJF9WC49aVovr9
	fEszH3/e2zQ1noLTzc4uuKQY8zvemRW5AA==
X-Google-Smtp-Source: ABdhPJw9lXoUdb+9nSlmHwoziLxai+Rt3I7zgIJ1oTBqcvjWZC4/0fG7FN8qIJjp6NzaYQdsfu0bWw==
X-Received: by 2002:a05:622a:18d:: with SMTP id
	s13mr5279508qtw.306.1606237211875; 
	Tue, 24 Nov 2020 09:00:11 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	q20sm13543500qke.0.2020.11.24.09.00.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:00:11 -0800 (PST)
Date: Tue, 24 Nov 2020 11:59:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X708BTJ5njtbC2z1@mtj.duckdns.org>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-12-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-12-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 11/20] block: reference struct block_device
 from struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

This is great. So much simpler & better. Some nits below.

> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index a02e224115943d..0ba0bf44b88af3 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -340,12 +340,11 @@ void delete_partition(struct hd_struct *part)
>  	device_del(part_to_dev(part));
>  
>  	/*
> -	 * Remove gendisk pointer from idr so that it cannot be looked up
> -	 * while RCU period before freeing gendisk is running to prevent
> -	 * use-after-free issues. Note that the device number stays
> -	 * "in-use" until we really free the gendisk.
> +	 * Remove the block device from the inode hash, so that it cannot be
> +	 * looked up while waiting for the RCU grace period.
>  	 */
> -	blk_invalidate_devt(part_devt(part));
> +	remove_inode_hash(part->bdev->bd_inode);

I don't think this is necessary now that the bdev and inode lifetimes are
one. Before, punching out the association early was necessary because we
could be in a situation where we can successfully look up a part from idr
and then try to pin the associated disk which may already be freed. With the
new code, the lookup is through the inode whose lifetime is one and the same
with gendisk, so use-after-free isn't possible and __blkdev_get() will
reliably reject such open attempts.

...
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 4c4d6c30382c06..e94633dc6ad93b 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -870,34 +870,50 @@ void __init bdev_cache_init(void)
>  	blockdev_superblock = bd_mnt->mnt_sb;   /* For writeback */
>  }
>  
> -static struct block_device *bdget(dev_t dev)
> +struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>  {
>  	struct block_device *bdev;
>  	struct inode *inode;
>  
> -	inode = iget_locked(blockdev_superblock, dev);
> +	inode = new_inode(blockdev_superblock);
>  	if (!inode)
>  		return NULL;
>  
> -	bdev = &BDEV_I(inode)->bdev;
> +	bdev = I_BDEV(inode);
> +	spin_lock_init(&bdev->bd_size_lock);
> +	bdev->bd_disk = disk;
> +	bdev->bd_partno = partno;
> +	bdev->bd_contains = NULL;
> +	bdev->bd_super = NULL;
> +	bdev->bd_inode = inode;
> +	bdev->bd_part_count = 0;
> +
> +	inode->i_mode = S_IFBLK;
> +	inode->i_rdev = 0;
> +	inode->i_bdev = bdev;
> +	inode->i_data.a_ops = &def_blk_aops;

Missing the call to mapping_set_gfp_mask().

>  
> -	if (inode->i_state & I_NEW) {
> -		spin_lock_init(&bdev->bd_size_lock);
> -		bdev->bd_contains = NULL;
> -		bdev->bd_super = NULL;
> -		bdev->bd_inode = inode;
> -		bdev->bd_part_count = 0;
> -		bdev->bd_dev = dev;
> -		inode->i_mode = S_IFBLK;
> -		inode->i_rdev = dev;
> -		inode->i_bdev = bdev;
> -		inode->i_data.a_ops = &def_blk_aops;
> -		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
> -		unlock_new_inode(inode);
> -	}
>  	return bdev;
>  }
...
>  /**
>   * bdgrab -- Grab a reference to an already referenced block device
>   * @bdev:	Block device to grab a reference to.
> @@ -957,6 +973,10 @@ static struct block_device *bd_acquire(struct inode *inode)
>  		bd_forget(inode);
>  
>  	bdev = bdget(inode->i_rdev);
> +	if (!bdev) {
> +		blk_request_module(inode->i_rdev);
> +		bdev = bdget(inode->i_rdev);
> +	}

One side effect here is that, before, a device which uses the traditional
consecutive devt range would reserve all minors for the partitions whether
they exist or not and fail open requests without requesting the matching
module. After the change, trying to open an non-existent partition would
trigger module probe. I don't think the behavior change is consequential in
any sane not-crazily-arcane setup but it might be worth mentioning in the
commit log.

Thank you.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

