Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82956C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 19:37:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D185E208FE
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 19:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D185E208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-8D_uMboRPRm4mGcMrRhAUw-1; Tue, 24 Nov 2020 14:37:49 -0500
X-MC-Unique: 8D_uMboRPRm4mGcMrRhAUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B00E803F4F;
	Tue, 24 Nov 2020 19:37:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94CE25D9C0;
	Tue, 24 Nov 2020 19:37:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B68B4BB7B;
	Tue, 24 Nov 2020 19:37:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOJbbIE006867 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 14:37:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A6662166B2C; Tue, 24 Nov 2020 19:37:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94F342166B2D
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 19:37:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A099800198
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 19:37:33 +0000 (UTC)
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com
	[209.85.160.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-30-NNF8JcmpNH2mNNuJQZY_cQ-1; Tue, 24 Nov 2020 14:37:28 -0500
X-MC-Unique: NNF8JcmpNH2mNNuJQZY_cQ-1
Received: by mail-qt1-f193.google.com with SMTP id v11so16931180qtq.12;
	Tue, 24 Nov 2020 11:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=MOALJb5ZWPUh3aGAOfM0OVshborSGP7hJGfOxgGOGv8=;
	b=UamESDKxuwtbfLb4Ngerno7bJoF2arO2AMQd8//1Dpme+r2KtFwhNaYD8BoQK9QL/6
	/W35Srii1pV/RkRy0F4vDDzM0HuCch7Tkh3AWls7tSObc8XjzFDznDHoMTUzRAxLB5gZ
	c1NwrE24Jvta9iP8tPvSQ0Dc3Toqiuw9nOXUP85bGOsA4wh0VEe5KAE6SfOIPArv7txB
	hQMIROkEhF69D9zkdwM7ZWKKvjt9rIcnw8oH5h2KM8w+Spnz6rHyD8RSwE82wk8zhoJT
	HkXx3jCjgi9S5BnYVgIFP7ClVxpUiTN3iNAWfxhCfAxqi0mp71u4G60YLyT8H/LAJxVh
	jgSA==
X-Gm-Message-State: AOAM5336uzDWypBPVrZcbgQnz5X2bwFq/8ZPib6y9ARQKQTWbYq3P+Vs
	tKMoXDwy5KJJqFTu+g2LtrA=
X-Google-Smtp-Source: ABdhPJybxY5/E0+KDq94c9P/N9IKjFDU+Ct8NW6WiHsGOrtJ7iW5aHJE2Msrh+VJOHLo1ru6UJnxSg==
X-Received: by 2002:ac8:7192:: with SMTP id w18mr6129290qto.149.1606246647881; 
	Tue, 24 Nov 2020 11:37:27 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	t126sm68819qkh.133.2020.11.24.11.37.27
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 11:37:27 -0800 (PST)
Date: Tue, 24 Nov 2020 14:37:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71g4Tm+3RiRg4Gf@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-24-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-24-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 23/45] block: remove i_bdev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:29PM +0100, Christoph Hellwig wrote:
> Switch the block device lookup interfaces to directly work with a dev_t
> so that struct block_device references are only acquired by the
> blkdev_get variants (and the blk-cgroup special case).  This means that
> we not don't need an extra reference in the inode and can generally
     ^
     now
> simplify handling of struct block_device to keep the lookups contained
> in the core block layer code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
...
> @@ -1689,14 +1599,12 @@ static int blkdev_open(struct inode * inode, struct file * filp)
>  	if ((filp->f_flags & O_ACCMODE) == 3)
>  		filp->f_mode |= FMODE_WRITE_IOCTL;
>  
> -	bdev = bd_acquire(inode);
> -	if (bdev == NULL)
> -		return -ENOMEM;
> -
> +	bdev = blkdev_get_by_dev(inode->i_rdev, filp->f_mode, filp);
> +	if (IS_ERR(bdev))
> +		return PTR_ERR(bdev);
>  	filp->f_mapping = bdev->bd_inode->i_mapping;
>  	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
> -
> -	return blkdev_get(bdev, filp->f_mode, filp);
> +	return 0;
>  }

I was wondering whether losing the stale bdev flushing in bd_acquire() would
cause user-visible behavior changes but can't see how it would given that
userland has no way of holding onto a specific instance of block inode.
Maybe it's something worth mentioning in the commit message?

Other than that, for the block part:

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

