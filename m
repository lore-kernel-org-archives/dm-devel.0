Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CC2C56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 16:37:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CA4920B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 16:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CA4920B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-bpDUpMSQNDu_5x0aWI7sZw-1; Thu, 26 Nov 2020 11:36:59 -0500
X-MC-Unique: bpDUpMSQNDu_5x0aWI7sZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C518042AA;
	Thu, 26 Nov 2020 16:36:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E8DB60862;
	Thu, 26 Nov 2020 16:36:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A1251809CA4;
	Thu, 26 Nov 2020 16:36:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQGXm7G023787 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 11:33:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A3B852026D36; Thu, 26 Nov 2020 16:33:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EF462026D47
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 16:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F624811E85
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 16:33:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-125-2zxyjgM2NSmdiXBEvfr4Qg-1;
	Thu, 26 Nov 2020 11:33:43 -0500
X-MC-Unique: 2zxyjgM2NSmdiXBEvfr4Qg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 40B53ACC4;
	Thu, 26 Nov 2020 16:33:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id A9A321E10D0; Thu, 26 Nov 2020 17:33:41 +0100 (CET)
Date: Thu, 26 Nov 2020 17:33:41 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126163341.GL422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-25-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-25-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 24/44] block: simplify bdev/disk lookup in
	blkdev_get
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

On Thu 26-11-20 14:04:02, Christoph Hellwig wrote:
> To simplify block device lookup and a few other upcoming areas, make sure
> that we always have a struct block_device available for each disk and
> each partition, and only find existing block devices in bdget.  The only
> downside of this is that each device and partition uses a little more
> memory.  The upside will be that a lot of code can be simplified.
> 
> With that all we need to look up the block device is to lookup the inode
> and do a few sanity checks on the gendisk, instead of the separate lookup
> for the gendisk.  For blk-cgroup which wants to access a gendisk without
> opening it, a new blkdev_{get,put}_no_open low-level interface is added
> to replace the previous get_gendisk use.
> 
> Note that the change to look up block device directly instead of the two
> step lookup using struct gendisk causes a subtile change in behavior:
> accessing a non-existing partition on an existing block device can now
> cause a call to request_module.  That call is harmless, and in practice
> no recent system will access these nodes as they aren't created by udev
> and static /dev/ setups are unusual.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I still found some smaller issues (see below) but overall this looks sane
and also simpler to review due to patch refactoring so thanks for that!

> @@ -1384,7 +1376,7 @@ static int __blkdev_get(struct block_device *bdev, struct gendisk *disk,
>  			struct block_device *whole = bdget_disk(disk, 0);
>  
>  			mutex_lock_nested(&whole->bd_mutex, 1);
> -			ret = __blkdev_get(whole, disk, 0, mode);
> +			ret = __blkdev_get(whole, mode);
>  			if (ret) {
>  				mutex_unlock(&whole->bd_mutex);
>  				bdput(whole);
> @@ -1394,9 +1386,8 @@ static int __blkdev_get(struct block_device *bdev, struct gendisk *disk,
>  			mutex_unlock(&whole->bd_mutex);
>  
>  			bdev->bd_contains = whole;
> -			bdev->bd_part = disk_get_part(disk, partno);
> -			if (!(disk->flags & GENHD_FL_UP) ||
> -			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
> +			bdev->bd_part = disk_get_part(disk, bdev->bd_partno);
> +			if (!bdev->bd_part || !bdev->bd_part->nr_sects) {

AFAICT it is still possible that we see !(disk->flags & GENHD_FL_UP) here,
isn't it? Is it safe to remove because the nr_sects check is already
equivalent to it? Or something else?

>  				__blkdev_put(whole, mode, 1);
>  				bdput(whole);
>  				ret = -ENXIO;
> @@ -1426,12 +1417,51 @@ static int __blkdev_get(struct block_device *bdev, struct gendisk *disk,
>  
>   out_clear:
>  	disk_put_part(bdev->bd_part);
> -	bdev->bd_disk = NULL;
>  	bdev->bd_part = NULL;
>  	bdev->bd_contains = NULL;
>  	return ret;
>  }
>  
> +struct block_device *blkdev_get_no_open(dev_t dev)
> +{
> +	struct block_device *bdev = bdget(dev);
> +	struct gendisk *disk;

I think bdget() above needs to be already under bdev_lookup_sem. Otherwise
disk_to_dev(bdev->bd_disk)->kobj below is a potential use-after-free.

> +
> +	down_read(&bdev_lookup_sem);
> +	if (!bdev) {
> +		up_read(&bdev_lookup_sem);
> +		blk_request_module(dev);
> +		down_read(&bdev_lookup_sem);
> +
> +		bdev = bdget(dev);
> +		if (!bdev)
> +			return NULL;

Here you return with bdev_lookup_sem held.

> +	}
> +
> +	disk = bdev->bd_disk;
> +	if (!kobject_get_unless_zero(&disk_to_dev(disk)->kobj))
> +		goto bdput;
> +	if ((disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
> +		goto bdput;

I think here you need to jump to put_disk.

> +	if (!try_module_get(bdev->bd_disk->fops->owner))
> +		goto put_disk;
> +	up_read(&bdev_lookup_sem);
> +	return bdev;
> +put_disk:
> +	put_disk(disk);
> +bdput:
> +	bdput(bdev);
> +	up_read(&bdev_lookup_sem);
> +	return NULL;
> +}

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

