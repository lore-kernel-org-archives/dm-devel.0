Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E01AC56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:05:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E81D220B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E81D220B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-Alg6mBeSOhybc_WeghI_Yw-1; Thu, 26 Nov 2020 10:05:55 -0500
X-MC-Unique: Alg6mBeSOhybc_WeghI_Yw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2C149CC03;
	Thu, 26 Nov 2020 15:05:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C89F60855;
	Thu, 26 Nov 2020 15:05:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3CE6180954D;
	Thu, 26 Nov 2020 15:05:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQF5l9d016035 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 10:05:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 274759D48C; Thu, 26 Nov 2020 15:05:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BB1C77CD
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:05:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3B5F811E78
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:05:42 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-554-UXfG1SDKMZ6qELFSsoqMcA-1;
	Thu, 26 Nov 2020 10:05:38 -0500
X-MC-Unique: UXfG1SDKMZ6qELFSsoqMcA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3A9DEACE0;
	Thu, 26 Nov 2020 15:05:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id C51F51E10D0; Thu, 26 Nov 2020 16:05:36 +0100 (CET)
Date: Thu, 26 Nov 2020 16:05:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126150536.GH422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-22-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-22-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 21/44] block: move bdput() to the callers of
	__blkdev_get
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:03:59, Christoph Hellwig wrote:
> This will allow for a more symmetric calling convention going forward.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 86a61a2141f642..d0783c55a0ce65 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1458,6 +1458,7 @@ static int __blkdev_get(struct block_device *bdev, struct gendisk *disk,
>  			if (!(disk->flags & GENHD_FL_UP) ||
>  			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
>  				__blkdev_put(whole, mode, 1);
> +				bdput(whole);
>  				ret = -ENXIO;
>  				goto out_clear;
>  			}
> @@ -1740,9 +1741,10 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  			disk->fops->release(disk, mode);
>  	}
>  	mutex_unlock(&bdev->bd_mutex);
> -	bdput(bdev);
> -	if (victim)
> +	if (victim) {
>  		__blkdev_put(victim, mode, 1);
> +		bdput(victim);
> +	}
>  }
>  
>  void blkdev_put(struct block_device *bdev, fmode_t mode)
> @@ -1792,6 +1794,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
>  	mutex_unlock(&bdev->bd_mutex);
>  
>  	__blkdev_put(bdev, mode, 0);
> +	bdput(bdev);
>  	put_disk_and_module(disk);
>  }
>  EXPORT_SYMBOL(blkdev_put);
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

