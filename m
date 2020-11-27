Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A0AC63798
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 13:22:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9A122224D
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 13:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9A122224D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-Fcpl0B4zOga4HjP-AnXs2g-1; Fri, 27 Nov 2020 08:22:36 -0500
X-MC-Unique: Fcpl0B4zOga4HjP-AnXs2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCE39106F8C8;
	Fri, 27 Nov 2020 13:22:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 861555D6D1;
	Fri, 27 Nov 2020 13:22:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09B484A7C6;
	Fri, 27 Nov 2020 13:22:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARDMR30019201 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 08:22:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B4A38D7B19; Fri, 27 Nov 2020 13:22:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE746D7B20
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 13:22:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 784F5103B805
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 13:22:25 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-186-QkSrgrKLNSmp8Zq4YonGQw-1;
	Fri, 27 Nov 2020 08:22:22 -0500
X-MC-Unique: QkSrgrKLNSmp8Zq4YonGQw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8DA62ABD7;
	Fri, 27 Nov 2020 13:22:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 54A1F1E1318; Fri, 27 Nov 2020 14:22:21 +0100 (CET)
Date: Fri, 27 Nov 2020 14:22:21 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201127132221.GF27162@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-45-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-45-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 44/44] block: stop using bdget_disk for
	partition 0
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

On Thu 26-11-20 14:04:22, Christoph Hellwig wrote:
> We can just dereference the point in struct gendisk instead.  Also
> remove the now unused export.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/genhd.c                   |  1 -
>  drivers/block/nbd.c             |  4 +---
>  drivers/block/xen-blkfront.c    | 20 +++++---------------
>  drivers/block/zram/zram_drv.c   | 14 ++------------
>  drivers/md/dm.c                 | 16 ++--------------
>  drivers/s390/block/dasd_ioctl.c |  5 ++---
>  fs/block_dev.c                  |  2 +-
>  7 files changed, 13 insertions(+), 49 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index af76c2fff40d31..01876a162f5813 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -920,7 +920,6 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
>  
>  	return bdev;
>  }
> -EXPORT_SYMBOL(bdget_disk);
>  
>  /*
>   * print a full list of all partitions - intended for places where the root
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 014683968ce174..92f84ed0ba9eb6 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1488,12 +1488,10 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
>  static void nbd_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct nbd_device *nbd = disk->private_data;
> -	struct block_device *bdev = bdget_disk(disk, 0);
>  
>  	if (test_bit(NBD_RT_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
> -			bdev->bd_openers == 0)
> +			disk->part0->bd_openers == 0)
>  		nbd_disconnect_and_put(nbd);
> -	bdput(bdev);
>  
>  	nbd_config_put(nbd);
>  	nbd_put(nbd);
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 79521e33d30ed5..188e0b47534bcf 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -2153,7 +2153,7 @@ static void blkfront_closing(struct blkfront_info *info)
>  	}
>  
>  	if (info->gd)
> -		bdev = bdget_disk(info->gd, 0);
> +		bdev = bdgrab(info->gd->part0);
>  
>  	mutex_unlock(&info->mutex);
>  
> @@ -2518,7 +2518,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
>  
>  	disk = info->gd;
>  	if (disk)
> -		bdev = bdget_disk(disk, 0);
> +		bdev = bdgrab(disk->part0);
>  
>  	info->xbdev = NULL;
>  	mutex_unlock(&info->mutex);
> @@ -2595,19 +2595,11 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
>  static void blkif_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct blkfront_info *info = disk->private_data;
> -	struct block_device *bdev;
>  	struct xenbus_device *xbdev;
>  
>  	mutex_lock(&blkfront_mutex);
> -
> -	bdev = bdget_disk(disk, 0);
> -
> -	if (!bdev) {
> -		WARN(1, "Block device %s yanked out from us!\n", disk->disk_name);
> +	if (disk->part0->bd_openers)
>  		goto out_mutex;
> -	}
> -	if (bdev->bd_openers)
> -		goto out;
>  
>  	/*
>  	 * Check if we have been instructed to close. We will have
> @@ -2619,7 +2611,7 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
>  
>  	if (xbdev && xbdev->state == XenbusStateClosing) {
>  		/* pending switch to state closed */
> -		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
> +		dev_info(disk_to_dev(disk), "releasing disk\n");
>  		xlvbd_release_gendisk(info);
>  		xenbus_frontend_closed(info->xbdev);
>   	}
> @@ -2628,14 +2620,12 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
>  
>  	if (!xbdev) {
>  		/* sudden device removal */
> -		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
> +		dev_info(disk_to_dev(disk), "releasing disk\n");
>  		xlvbd_release_gendisk(info);
>  		disk->private_data = NULL;
>  		free_info(info);
>  	}
>  
> -out:
> -	bdput(bdev);
>  out_mutex:
>  	mutex_unlock(&blkfront_mutex);
>  }
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index dc8957d173d37c..b0701bae6e9800 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1760,15 +1760,12 @@ static ssize_t reset_store(struct device *dev,
>  		return -EINVAL;
>  
>  	zram = dev_to_zram(dev);
> -	bdev = bdget_disk(zram->disk, 0);
> -	if (!bdev)
> -		return -ENOMEM;
> +	bdev = zram->disk->part0;
>  
>  	mutex_lock(&bdev->bd_mutex);
>  	/* Do not reset an active device or claimed device */
>  	if (bdev->bd_openers || zram->claim) {
>  		mutex_unlock(&bdev->bd_mutex);
> -		bdput(bdev);
>  		return -EBUSY;
>  	}
>  
> @@ -1779,7 +1776,6 @@ static ssize_t reset_store(struct device *dev,
>  	/* Make sure all the pending I/O are finished */
>  	fsync_bdev(bdev);
>  	zram_reset_device(zram);
> -	bdput(bdev);
>  
>  	mutex_lock(&bdev->bd_mutex);
>  	zram->claim = false;
> @@ -1965,16 +1961,11 @@ static int zram_add(void)
>  
>  static int zram_remove(struct zram *zram)
>  {
> -	struct block_device *bdev;
> -
> -	bdev = bdget_disk(zram->disk, 0);
> -	if (!bdev)
> -		return -ENOMEM;
> +	struct block_device *bdev = zram->disk->part0;
>  
>  	mutex_lock(&bdev->bd_mutex);
>  	if (bdev->bd_openers || zram->claim) {
>  		mutex_unlock(&bdev->bd_mutex);
> -		bdput(bdev);
>  		return -EBUSY;
>  	}
>  
> @@ -1986,7 +1977,6 @@ static int zram_remove(struct zram *zram)
>  	/* Make sure all the pending I/O are finished */
>  	fsync_bdev(bdev);
>  	zram_reset_device(zram);
> -	bdput(bdev);
>  
>  	pr_info("Removed device: %s\n", zram->disk->disk_name);
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 176adcff56b380..ed7e836efbcdbc 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2375,16 +2375,11 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
>   */
>  static int lock_fs(struct mapped_device *md)
>  {
> -	struct block_device *bdev;
>  	int r;
>  
>  	WARN_ON(test_bit(DMF_FROZEN, &md->flags));
>  
> -	bdev = bdget_disk(md->disk, 0);
> -	if (!bdev)
> -		return -ENOMEM;
> -	r = freeze_bdev(bdev);
> -	bdput(bdev);
> +	r = freeze_bdev(md->disk->part0);
>  	if (!r)
>  		set_bit(DMF_FROZEN, &md->flags);
>  	return r;
> @@ -2392,16 +2387,9 @@ static int lock_fs(struct mapped_device *md)
>  
>  static void unlock_fs(struct mapped_device *md)
>  {
> -	struct block_device *bdev;
> -
>  	if (!test_bit(DMF_FROZEN, &md->flags))
>  		return;
> -
> -	bdev = bdget_disk(md->disk, 0);
> -	if (!bdev)
> -		return;
> -	thaw_bdev(bdev);
> -	bdput(bdev);
> +	thaw_bdev(md->disk->part0);
>  	clear_bit(DMF_FROZEN, &md->flags);
>  }
>  
> diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
> index 304eba1acf163c..9f642440894655 100644
> --- a/drivers/s390/block/dasd_ioctl.c
> +++ b/drivers/s390/block/dasd_ioctl.c
> @@ -220,9 +220,8 @@ dasd_format(struct dasd_block *block, struct format_data_t *fdata)
>  	 * enabling the device later.
>  	 */
>  	if (fdata->start_unit == 0) {
> -		struct block_device *bdev = bdget_disk(block->gdp, 0);
> -		bdev->bd_inode->i_blkbits = blksize_bits(fdata->blksize);
> -		bdput(bdev);
> +		block->gdp->part0->bd_inode->i_blkbits =
> +			blksize_bits(fdata->blksize);
>  	}
>  
>  	rc = base->discipline->format_device(base, fdata, 1);
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 58fd6625966511..4edb9f23092285 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1295,7 +1295,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode)
>  			if (ret)
>  				return ret;
>  		} else {
> -			struct block_device *whole = bdget_disk(disk, 0);
> +			struct block_device *whole = bdgrab(disk->part0);
>  
>  			mutex_lock_nested(&whole->bd_mutex, 1);
>  			ret = __blkdev_get(whole, mode);
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

