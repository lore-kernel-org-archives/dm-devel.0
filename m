Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA099C64E75
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 14:55:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A48221D1A
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 14:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A48221D1A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-ZllEkfSiNleWHeT-4sRJjg-1; Thu, 26 Nov 2020 09:55:37 -0500
X-MC-Unique: ZllEkfSiNleWHeT-4sRJjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601DE56C61;
	Thu, 26 Nov 2020 14:55:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D0685D9C6;
	Thu, 26 Nov 2020 14:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 262075002C;
	Thu, 26 Nov 2020 14:55:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQEtTI8015315 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 09:55:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 815EC10F8E10; Thu, 26 Nov 2020 14:55:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D87C10F8E0F
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 14:55:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BD2910580C1
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 14:55:26 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-520-oFu_uyNON3O5dy66gKJqmg-1;
	Thu, 26 Nov 2020 09:55:23 -0500
X-MC-Unique: oFu_uyNON3O5dy66gKJqmg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 75E3FADB3;
	Thu, 26 Nov 2020 14:55:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id E17411E10D0; Thu, 26 Nov 2020 15:55:21 +0100 (CET)
Date: Thu, 26 Nov 2020 15:55:21 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126145521.GG422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-21-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-21-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 20/44] block: refactor blkdev_get
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

On Thu 26-11-20 14:03:58, Christoph Hellwig wrote:
> Move more code that is only run on the outer open but not the open of
> the underlying whole device when opening a partition into blkdev_get,
> which leads to a much easier to follow structure.
> 
> This allows to simplify the disk and module refcounting so that one
> reference is held for each open, similar to what we do with normal
> file operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/block_dev.c | 185 +++++++++++++++++++++++--------------------------
>  1 file changed, 86 insertions(+), 99 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 41c50cfba864e2..86a61a2141f642 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1403,46 +1403,12 @@ EXPORT_SYMBOL_GPL(bdev_disk_changed);
>   *  mutex_lock(part->bd_mutex)
>   *    mutex_lock_nested(whole->bd_mutex, 1)
>   */
> -
> -static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
> -		int for_part)
> +static int __blkdev_get(struct block_device *bdev, struct gendisk *disk,
> +		int partno, fmode_t mode)
>  {
> -	struct block_device *whole = NULL, *claiming = NULL;
> -	struct gendisk *disk;
>  	int ret;
> -	int partno;
> -	bool first_open = false, unblock_events = true, need_restart;
> -
> - restart:
> -	need_restart = false;
> -	ret = -ENXIO;
> -	disk = bdev_get_gendisk(bdev, &partno);
> -	if (!disk)
> -		goto out;
> -
> -	if (partno) {
> -		whole = bdget_disk(disk, 0);
> -		if (!whole) {
> -			ret = -ENOMEM;
> -			goto out_put_disk;
> -		}
> -	}
>  
> -	if (!for_part && (mode & FMODE_EXCL)) {
> -		WARN_ON_ONCE(!holder);
> -		if (whole)
> -			claiming = whole;
> -		else
> -			claiming = bdev;
> -		ret = bd_prepare_to_claim(bdev, claiming, holder);
> -		if (ret)
> -			goto out_put_whole;
> -	}
> -
> -	disk_block_events(disk);
> -	mutex_lock_nested(&bdev->bd_mutex, for_part);
>  	if (!bdev->bd_openers) {
> -		first_open = true;
>  		bdev->bd_disk = disk;
>  		bdev->bd_contains = bdev;
>  		bdev->bd_partno = partno;
> @@ -1454,15 +1420,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  				goto out_clear;
>  
>  			ret = 0;
> -			if (disk->fops->open) {
> +			if (disk->fops->open)
>  				ret = disk->fops->open(bdev, mode);
> -				/*
> -				 * If we lost a race with 'disk' being deleted,
> -				 * try again.  See md.c
> -				 */
> -				if (ret == -ERESTARTSYS)
> -					need_restart = true;
> -			}
>  
>  			if (!ret) {
>  				bd_set_nr_sectors(bdev, get_capacity(disk));
> @@ -1482,14 +1441,23 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  			if (ret)
>  				goto out_clear;
>  		} else {
> -			BUG_ON(for_part);
> -			ret = __blkdev_get(whole, mode, NULL, 1);
> -			if (ret)
> +			struct block_device *whole = bdget_disk(disk, 0);
> +
> +			mutex_lock_nested(&whole->bd_mutex, 1);
> +			ret = __blkdev_get(whole, disk, 0, mode);
> +			if (ret) {
> +				mutex_unlock(&whole->bd_mutex);
> +				bdput(whole);
>  				goto out_clear;
> -			bdev->bd_contains = bdgrab(whole);
> +			}
> +			whole->bd_part_count++;
> +			mutex_unlock(&whole->bd_mutex);
> +
> +			bdev->bd_contains = whole;
>  			bdev->bd_part = disk_get_part(disk, partno);
>  			if (!(disk->flags & GENHD_FL_UP) ||
>  			    !bdev->bd_part || !bdev->bd_part->nr_sects) {
> +				__blkdev_put(whole, mode, 1);
>  				ret = -ENXIO;
>  				goto out_clear;
>  			}
> @@ -1509,58 +1477,17 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  			    (!ret || ret == -ENOMEDIUM))
>  				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
>  			if (ret)
> -				goto out_unlock_bdev;
> +				return ret;
>  		}
>  	}
>  	bdev->bd_openers++;
> -	if (for_part)
> -		bdev->bd_part_count++;
> -	if (claiming)
> -		bd_finish_claiming(bdev, claiming, holder);
> -
> -	/*
> -	 * Block event polling for write claims if requested.  Any write holder
> -	 * makes the write_holder state stick until all are released.  This is
> -	 * good enough and tracking individual writeable reference is too
> -	 * fragile given the way @mode is used in blkdev_get/put().
> -	 */
> -	if (claiming && (mode & FMODE_WRITE) && !bdev->bd_write_holder &&
> -	    (disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE)) {
> -		bdev->bd_write_holder = true;
> -		unblock_events = false;
> -	}
> -	mutex_unlock(&bdev->bd_mutex);
> -
> -	if (unblock_events)
> -		disk_unblock_events(disk);
> -
> -	/* only one opener holds refs to the module and disk */
> -	if (!first_open)
> -		put_disk_and_module(disk);
> -	if (whole)
> -		bdput(whole);
>  	return 0;
>  
>   out_clear:
>  	disk_put_part(bdev->bd_part);
>  	bdev->bd_disk = NULL;
>  	bdev->bd_part = NULL;
> -	if (bdev != bdev->bd_contains)
> -		__blkdev_put(bdev->bd_contains, mode, 1);
>  	bdev->bd_contains = NULL;
> - out_unlock_bdev:
> -	if (claiming)
> -		bd_abort_claiming(bdev, claiming, holder);
> -	mutex_unlock(&bdev->bd_mutex);
> -	disk_unblock_events(disk);
> - out_put_whole:
> - 	if (whole)
> -		bdput(whole);
> - out_put_disk:
> -	put_disk_and_module(disk);
> -	if (need_restart)
> -		goto restart;
> - out:
>  	return ret;
>  }
>  
> @@ -1585,7 +1512,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>   */
>  static int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
>  {
> -	int ret, perm = 0;
> +	struct block_device *claiming;
> +	bool unblock_events = true;
> +	struct gendisk *disk;
> +	int perm = 0;
> +	int partno;
> +	int ret;
>  
>  	if (mode & FMODE_READ)
>  		perm |= MAY_READ;
> @@ -1595,13 +1527,67 @@ static int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
>  	if (ret)
>  		goto bdput;
>  
> -	ret =__blkdev_get(bdev, mode, holder, 0);
> -	if (ret)
> +	/*
> +	 * If we lost a race with 'disk' being deleted, try again.  See md.c.
> +	 */
> +retry:
> +	ret = -ENXIO;
> +	disk = bdev_get_gendisk(bdev, &partno);
> +	if (!disk)
>  		goto bdput;
> -	return 0;
>  
> +	if (mode & FMODE_EXCL) {
> +		WARN_ON_ONCE(!holder);
> +	
> +		ret = -ENOMEM;
> +		claiming = bdget_disk(disk, 0);
> +		if (!claiming)
> +			goto put_disk;
> +		ret = bd_prepare_to_claim(bdev, claiming, holder);
> +		if (ret)
> +			goto put_claiming;
> +	}
> +
> +	disk_block_events(disk);
> +
> +	mutex_lock(&bdev->bd_mutex);
> +	ret =__blkdev_get(bdev, disk, partno, mode);
> +	if (!(mode & FMODE_EXCL)) {
> +		; /* nothing to do here */
> +	} else if (ret) {
> +		bd_abort_claiming(bdev, claiming, holder);
> +	} else {
> +		bd_finish_claiming(bdev, claiming, holder);
> +
> +		/*
> +		 * Block event polling for write claims if requested.  Any write
> +		 * holder makes the write_holder state stick until all are
> +		 * released.  This is good enough and tracking individual
> +		 * writeable reference is too fragile given the way @mode is
> +		 * used in blkdev_get/put().
> +		 */
> +		if ((mode & FMODE_WRITE) && !bdev->bd_write_holder &&
> +		    (disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE)) {
> +			bdev->bd_write_holder = true;
> +			unblock_events = false;
> +		}
> +	}
> +	mutex_unlock(&bdev->bd_mutex);
> +
> +	if (unblock_events)
> +		disk_unblock_events(disk);
> +
> +put_claiming:
> +	if (mode & FMODE_EXCL)
> +		bdput(claiming);
> +put_disk:
> +	if (ret)
> +		put_disk_and_module(disk);
> +	if (ret == -ERESTARTSYS)
> +		goto retry;
>  bdput:
> -	bdput(bdev);
> +	if (ret)
> +		bdput(bdev);
>  	return ret;
>  }
>  
> @@ -1749,8 +1735,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  		if (bdev_is_partition(bdev))
>  			victim = bdev->bd_contains;
>  		bdev->bd_contains = NULL;
> -
> -		put_disk_and_module(disk);
>  	} else {
>  		if (!bdev_is_partition(bdev) && disk->fops->release)
>  			disk->fops->release(disk, mode);
> @@ -1763,6 +1747,8 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  
>  void blkdev_put(struct block_device *bdev, fmode_t mode)
>  {
> +	struct gendisk *disk = bdev->bd_disk;
> +
>  	mutex_lock(&bdev->bd_mutex);
>  
>  	if (mode & FMODE_EXCL) {
> @@ -1791,7 +1777,7 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
>  		 * unblock evpoll if it was a write holder.
>  		 */
>  		if (bdev_free && bdev->bd_write_holder) {
> -			disk_unblock_events(bdev->bd_disk);
> +			disk_unblock_events(disk);
>  			bdev->bd_write_holder = false;
>  		}
>  	}
> @@ -1801,11 +1787,12 @@ void blkdev_put(struct block_device *bdev, fmode_t mode)
>  	 * event.  This is to ensure detection of media removal commanded
>  	 * from userland - e.g. eject(1).
>  	 */
> -	disk_flush_events(bdev->bd_disk, DISK_EVENT_MEDIA_CHANGE);
> +	disk_flush_events(disk, DISK_EVENT_MEDIA_CHANGE);
>  
>  	mutex_unlock(&bdev->bd_mutex);
>  
>  	__blkdev_put(bdev, mode, 0);
> +	put_disk_and_module(disk);
>  }
>  EXPORT_SYMBOL(blkdev_put);
>  
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

