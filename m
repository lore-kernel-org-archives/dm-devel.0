Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0692C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27D6C20715
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27D6C20715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-yFFhGoSqMvqu9T6qldASbg-1; Wed, 18 Nov 2020 16:34:50 -0500
X-MC-Unique: yFFhGoSqMvqu9T6qldASbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D470B18B9EFB;
	Wed, 18 Nov 2020 21:34:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6E085D6A8;
	Wed, 18 Nov 2020 21:34:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88E151809CA1;
	Wed, 18 Nov 2020 21:34:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AILYVpt000525 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 16:34:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 153F9A9F36; Wed, 18 Nov 2020 21:34:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10287A9F1E
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94E03101A540
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-337-hr-ptzTePx-hEsNUzraS5Q-1;
	Wed, 18 Nov 2020 16:34:26 -0500
X-MC-Unique: hr-ptzTePx-hEsNUzraS5Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 01321B000;
	Wed, 18 Nov 2020 21:34:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id BCB4E1E1330; Wed, 18 Nov 2020 15:46:40 +0100 (CET)
Date: Wed, 18 Nov 2020 15:46:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201118144640.GO1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-11-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-11-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 10/20] block: refactor __blkdev_put
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:50, Christoph Hellwig wrote:
> Reorder the code to have one big section for the last close, and to use
> bdev_is_partition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 29db12c3bb501c..4c4d6c30382c06 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1745,22 +1745,22 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  		WARN_ON_ONCE(bdev->bd_holders);
>  		sync_blockdev(bdev);
>  		kill_bdev(bdev);
> -
>  		bdev_write_inode(bdev);
> -	}
> -	if (bdev->bd_contains == bdev) {
> -		if (disk->fops->release)
> +
> +		if (!bdev_is_partition(bdev) && disk->fops->release)
>  			disk->fops->release(disk, mode);
> -	}
> -	if (!bdev->bd_openers) {
> +
>  		disk_put_part(bdev->bd_part);
>  		bdev->bd_part = NULL;
>  		bdev->bd_disk = NULL;
> -		if (bdev != bdev->bd_contains)
> +		if (bdev_is_partition(bdev))
>  			victim = bdev->bd_contains;
>  		bdev->bd_contains = NULL;
>  
>  		put_disk_and_module(disk);
> +	} else {
> +		if (!bdev_is_partition(bdev) && disk->fops->release)
> +			disk->fops->release(disk, mode);
>  	}
>  	mutex_unlock(&bdev->bd_mutex);
>  	bdput(bdev);
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

