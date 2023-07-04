Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AAD0EB64DD
	for <dm-devel@archiver.kernel.org>; Tue,  4 Jul 2023 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688488134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sWaHyEgoZ8lA2no+qdFsWZV46bPTHQjbaHS48KUmtI0=;
	b=M/kJeaysaTDFalsKMnhMWOaf+c2BjIM5FFnpKn36LA2klpzkAp7aQ0AETdhxC1qw76ylnh
	7LNWd0tzt/tgzY+JO9nOrfpKfWc1Uz/zwoVoP8lschkq35kXiSdM0Xo7ZpFeSRBsi9AZ0O
	LTxtSaFB61C74/Ska2aZuo4HBAaki28=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-POtHli-MMByYnGilHu_4MQ-1; Tue, 04 Jul 2023 12:28:50 -0400
X-MC-Unique: POtHli-MMByYnGilHu_4MQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC5E8101A528;
	Tue,  4 Jul 2023 16:28:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7AE2023439;
	Tue,  4 Jul 2023 16:28:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23E071946589;
	Tue,  4 Jul 2023 16:28:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E3CB1946588
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Jul 2023 16:28:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EAB191121318; Tue,  4 Jul 2023 16:28:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E33601121314
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 16:28:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C551D8037BA
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 16:28:45 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-M5RiuStZPVuLA3gXUkJ4jA-1; Tue, 04 Jul 2023 12:28:44 -0400
X-MC-Unique: M5RiuStZPVuLA3gXUkJ4jA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3D9612CF;
 Tue,  4 Jul 2023 16:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8C9C433C7;
 Tue,  4 Jul 2023 16:28:39 +0000 (UTC)
Date: Tue, 4 Jul 2023 10:28:36 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <ZKRItBRhm8f5Vba/@kbusch-mbp>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
MIME-Version: 1.0
In-Reply-To: <20230704122224.16257-1-jack@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 01/32] block: Provide blkdev_get_handle_*
 functions
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org,
 Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 linux-mm@kvack.org, Song Liu <song@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, linux-fsdevel@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:
> +struct bdev_handle *blkdev_get_handle_by_dev(dev_t dev, blk_mode_t mode,
> +		void *holder, const struct blk_holder_ops *hops)
> +{
> +	struct bdev_handle *handle = kmalloc(sizeof(struct bdev_handle),
> +					     GFP_KERNEL);

I believe 'sizeof(*handle)' is the preferred style.

> +	struct block_device *bdev;
> +
> +	if (!handle)
> +		return ERR_PTR(-ENOMEM);
> +	bdev = blkdev_get_by_dev(dev, mode, holder, hops);
> +	if (IS_ERR(bdev))
> +		return ERR_CAST(bdev);

Need a 'kfree(handle)' before the error return. Or would it be simpler
to get the bdev first so you can check the mode settings against a
read-only bdev prior to the kmalloc?

> +	handle->bdev = bdev;
> +	handle->holder = holder;
> +	return handle;
> +}
> +EXPORT_SYMBOL(blkdev_get_handle_by_dev);
> +
>  /**
>   * blkdev_get_by_path - open a block device by name
>   * @path: path to the block device to open
> @@ -884,6 +902,28 @@ struct block_device *blkdev_get_by_path(const char *path, blk_mode_t mode,
>  }
>  EXPORT_SYMBOL(blkdev_get_by_path);
>  
> +struct bdev_handle *blkdev_get_handle_by_path(const char *path, blk_mode_t mode,
> +		void *holder, const struct blk_holder_ops *hops)
> +{
> +	struct bdev_handle *handle;
> +	dev_t dev;
> +	int error;
> +
> +	error = lookup_bdev(path, &dev);
> +	if (error)
> +		return ERR_PTR(error);
> +
> +	handle = blkdev_get_handle_by_dev(dev, mode, holder, hops);
> +	if (!IS_ERR(handle) && (mode & BLK_OPEN_WRITE) &&
> +	    bdev_read_only(handle->bdev)) {
> +		blkdev_handle_put(handle);
> +		return ERR_PTR(-EACCES);
> +	}
> +
> +	return handle;
> +}
> +EXPORT_SYMBOL(blkdev_get_handle_by_path);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

