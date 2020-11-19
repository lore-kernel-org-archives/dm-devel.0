Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46006C388F9
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 10:07:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57DF122259
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 10:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57DF122259
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-MkuItc1jO-SvibV-P_sXyg-1; Thu, 19 Nov 2020 05:07:48 -0500
X-MC-Unique: MkuItc1jO-SvibV-P_sXyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 616178143F3;
	Thu, 19 Nov 2020 10:07:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F07F160C0F;
	Thu, 19 Nov 2020 10:07:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A9712180954D;
	Thu, 19 Nov 2020 10:07:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJA7cNI001153 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 05:07:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 367622026D5D; Thu, 19 Nov 2020 10:07:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 321F32026D76
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 10:07:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2958185A7BC
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 10:07:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-222-YzIBFOZBOPeEGAoyGXyfZA-1;
	Thu, 19 Nov 2020 05:07:33 -0500
X-MC-Unique: YzIBFOZBOPeEGAoyGXyfZA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3BBD2B114;
	Thu, 19 Nov 2020 10:07:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id E777D1E130B; Thu, 19 Nov 2020 11:07:30 +0100 (CET)
Date: Thu, 19 Nov 2020 11:07:30 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119100730.GU1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-13-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-13-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 12/20] block: simplify the block device
	claiming interface
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

On Wed 18-11-20 09:47:52, Christoph Hellwig wrote:
> Stop passing the whole device as a separate argument given that it
> can be trivially deducted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/block/loop.c   | 12 +++-----
>  fs/block_dev.c         | 69 +++++++++++++++++++-----------------------
>  include/linux/blkdev.h |  6 ++--
>  3 files changed, 38 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index b42c728620c9e4..599e94a7e69259 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1071,7 +1071,6 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>  	struct file	*file;
>  	struct inode	*inode;
>  	struct address_space *mapping;
> -	struct block_device *claimed_bdev = NULL;
>  	int		error;
>  	loff_t		size;
>  	bool		partscan;
> @@ -1090,8 +1089,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>  	 * here to avoid changing device under exclusive owner.
>  	 */
>  	if (!(mode & FMODE_EXCL)) {
> -		claimed_bdev = bdev->bd_contains;
> -		error = bd_prepare_to_claim(bdev, claimed_bdev, loop_configure);
> +		error = bd_prepare_to_claim(bdev, loop_configure);
>  		if (error)
>  			goto out_putf;
>  	}
> @@ -1178,15 +1176,15 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>  	mutex_unlock(&loop_ctl_mutex);
>  	if (partscan)
>  		loop_reread_partitions(lo, bdev);
> -	if (claimed_bdev)
> -		bd_abort_claiming(bdev, claimed_bdev, loop_configure);
> +	if (!(mode & FMODE_EXCL))
> +		bd_abort_claiming(bdev, loop_configure);
>  	return 0;
>  
>  out_unlock:
>  	mutex_unlock(&loop_ctl_mutex);
>  out_bdev:
> -	if (claimed_bdev)
> -		bd_abort_claiming(bdev, claimed_bdev, loop_configure);
> +	if (!(mode & FMODE_EXCL))
> +		bd_abort_claiming(bdev, loop_configure);
>  out_putf:
>  	fput(file);
>  out:
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index e94633dc6ad93b..dd52dbd266cde7 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -110,24 +110,20 @@ EXPORT_SYMBOL(invalidate_bdev);
>  int truncate_bdev_range(struct block_device *bdev, fmode_t mode,
>  			loff_t lstart, loff_t lend)
>  {
> -	struct block_device *claimed_bdev = NULL;
> -	int err;
> -
>  	/*
>  	 * If we don't hold exclusive handle for the device, upgrade to it
>  	 * while we discard the buffer cache to avoid discarding buffers
>  	 * under live filesystem.
>  	 */
>  	if (!(mode & FMODE_EXCL)) {
> -		claimed_bdev = bdev->bd_contains;
> -		err = bd_prepare_to_claim(bdev, claimed_bdev,
> -					  truncate_bdev_range);
> +		int err = bd_prepare_to_claim(bdev, truncate_bdev_range);
>  		if (err)
>  			return err;
>  	}
> +
>  	truncate_inode_pages_range(bdev->bd_inode->i_mapping, lstart, lend);
> -	if (claimed_bdev)
> -		bd_abort_claiming(bdev, claimed_bdev, truncate_bdev_range);
> +	if (!(mode & FMODE_EXCL))
> +		bd_abort_claiming(bdev, truncate_bdev_range);
>  	return 0;
>  }
>  EXPORT_SYMBOL(truncate_bdev_range);
> @@ -1047,7 +1043,6 @@ static bool bd_may_claim(struct block_device *bdev, struct block_device *whole,
>  /**
>   * bd_prepare_to_claim - claim a block device
>   * @bdev: block device of interest
> - * @whole: the whole device containing @bdev, may equal @bdev
>   * @holder: holder trying to claim @bdev
>   *
>   * Claim @bdev.  This function fails if @bdev is already claimed by another
> @@ -1057,9 +1052,10 @@ static bool bd_may_claim(struct block_device *bdev, struct block_device *whole,
>   * RETURNS:
>   * 0 if @bdev can be claimed, -EBUSY otherwise.
>   */
> -int bd_prepare_to_claim(struct block_device *bdev, struct block_device *whole,
> -		void *holder)
> +int bd_prepare_to_claim(struct block_device *bdev, void *holder)
>  {
> +	struct block_device *whole = bdev->bd_contains;
> +
>  retry:
>  	spin_lock(&bdev_lock);
>  	/* if someone else claimed, fail */
> @@ -1099,15 +1095,15 @@ static void bd_clear_claiming(struct block_device *whole, void *holder)
>  /**
>   * bd_finish_claiming - finish claiming of a block device
>   * @bdev: block device of interest
> - * @whole: whole block device
>   * @holder: holder that has claimed @bdev
>   *
>   * Finish exclusive open of a block device. Mark the device as exlusively
>   * open by the holder and wake up all waiters for exclusive open to finish.
>   */
> -static void bd_finish_claiming(struct block_device *bdev,
> -		struct block_device *whole, void *holder)
> +static void bd_finish_claiming(struct block_device *bdev, void *holder)
>  {
> +	struct block_device *whole = bdev->bd_contains;
> +
>  	spin_lock(&bdev_lock);
>  	BUG_ON(!bd_may_claim(bdev, whole, holder));
>  	/*
> @@ -1132,11 +1128,10 @@ static void bd_finish_claiming(struct block_device *bdev,
>   * also used when exclusive open is not actually desired and we just needed
>   * to block other exclusive openers for a while.
>   */
> -void bd_abort_claiming(struct block_device *bdev, struct block_device *whole,
> -		       void *holder)
> +void bd_abort_claiming(struct block_device *bdev, void *holder)
>  {
>  	spin_lock(&bdev_lock);
> -	bd_clear_claiming(whole, holder);
> +	bd_clear_claiming(bdev->bd_contains, holder);
>  	spin_unlock(&bdev_lock);
>  }
>  EXPORT_SYMBOL(bd_abort_claiming);
> @@ -1434,7 +1429,7 @@ static void put_disk_and_module(struct gendisk *disk)
>  static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  		int for_part)
>  {
> -	struct block_device *whole = NULL, *claiming = NULL;
> +	struct block_device *whole = NULL;
>  	struct gendisk *disk = bdev->bd_disk;
>  	int ret;
>  	bool first_open = false, unblock_events = true, need_restart;
> @@ -1462,11 +1457,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  
>  	if (!for_part && (mode & FMODE_EXCL)) {
>  		WARN_ON_ONCE(!holder);
> -		if (whole)
> -			claiming = whole;
> -		else
> -			claiming = bdev;
> -		ret = bd_prepare_to_claim(bdev, claiming, holder);
> +		ret = bd_prepare_to_claim(bdev, holder);
>  		if (ret)
>  			goto out_put_whole;
>  	}
> @@ -1543,21 +1534,23 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  		}
>  	}
>  	bdev->bd_openers++;
> -	if (for_part)
> +	if (for_part) {
>  		bdev->bd_part_count++;
> -	if (claiming)
> -		bd_finish_claiming(bdev, claiming, holder);
> +	} else if (mode & FMODE_EXCL) {
> +		bd_finish_claiming(bdev, holder);
>  
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
>  	}
>  	mutex_unlock(&bdev->bd_mutex);
>  
> @@ -1578,8 +1571,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  		__blkdev_put(bdev->bd_contains, mode, 1);
>  	bdev->bd_contains = NULL;
>   out_unlock_bdev:
> -	if (claiming)
> -		bd_abort_claiming(bdev, claiming, holder);
> +	if (!for_part && (mode & FMODE_EXCL))
> +		bd_abort_claiming(bdev, holder);
>  	mutex_unlock(&bdev->bd_mutex);
>  	disk_unblock_events(disk);
>   out_put_whole:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 044d9dd159d882..696b2f9c5529d8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1988,10 +1988,8 @@ void blkdev_show(struct seq_file *seqf, off_t offset);
>  struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
>  		void *holder);
>  struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder);
> -int bd_prepare_to_claim(struct block_device *bdev, struct block_device *whole,
> -		void *holder);
> -void bd_abort_claiming(struct block_device *bdev, struct block_device *whole,
> -		void *holder);
> +int bd_prepare_to_claim(struct block_device *bdev, void *holder);
> +void bd_abort_claiming(struct block_device *bdev, void *holder);
>  void blkdev_put(struct block_device *bdev, fmode_t mode);
>  
>  struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
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

