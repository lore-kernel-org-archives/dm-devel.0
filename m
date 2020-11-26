Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,FSL_HELO_FAKE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586CFC63777
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A83DA20DD4
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A83DA20DD4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-tmbZSgwJNc6jZoIP3jWaiw-1; Thu, 26 Nov 2020 03:36:47 -0500
X-MC-Unique: tmbZSgwJNc6jZoIP3jWaiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98BEF85C734;
	Thu, 26 Nov 2020 08:36:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BBE060864;
	Thu, 26 Nov 2020 08:36:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52A1550037;
	Thu, 26 Nov 2020 08:36:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQ1BKYr028569 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 20:11:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 56AC4AE7C5; Thu, 26 Nov 2020 01:11:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51071AE7C6
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 01:11:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07C77185A794
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 01:11:18 +0000 (UTC)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
	[209.85.210.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-447-bLk1jAatN72pC1PpDdKsIw-1; Wed, 25 Nov 2020 20:11:13 -0500
X-MC-Unique: bLk1jAatN72pC1PpDdKsIw-1
Received: by mail-pf1-f196.google.com with SMTP id n137so124788pfd.3;
	Wed, 25 Nov 2020 17:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=f8bMvE80grJsQDxQbN+SXa4Ok4avPUhhCBLg+N5g7uE=;
	b=rReVpNkrQsf7S1BRVvr3375g7ShCQc83wPMXjjhQwHWKXfdBdamewnXDeNjVqu2F/7
	DV84vcoKyEXOR5aSxx8D+zxV/3Xez2AcEicsDkPgc4taLjMETGmKnERdmAfr2TNa2Y2z
	8eR2bwyPJTAwdeDuIVxXMeScmiUNT9g/VY5nj18F9DY7cLMCMqf0R6OQ9ynkZJ5JExc5
	woS24y0aTKR8IKCIiPQxS4cpvgMR3FOy39pOyc31scVJ1ihAH2Vrcoc6KelXc0bTuOST
	K7flYJ8zrx1g7FgL9iL/YsNvzhjBF6QixKDS3UF74NqFPy8xVcgkLzaS9IpKd1ZY/J37
	vrpg==
X-Gm-Message-State: AOAM531Z9BmPu4pZM/FWqGJ1zDVeZxx9OBo3pbA8dMn5AEyuOPlbFHn8
	kOWf8zXcVhUW1sLUwrHvc6c=
X-Google-Smtp-Source: ABdhPJy2rvS54nam6WzB3Gos6rktAfztTZ/apost62cNhHmAqWfXtcE8/JRGjAG0GRNN0NDnAydY0Q==
X-Received: by 2002:a17:90a:8909:: with SMTP id
	u9mr643556pjn.100.1606353071628; 
	Wed, 25 Nov 2020 17:11:11 -0800 (PST)
Received: from google.com (c-67-188-94-199.hsd1.ca.comcast.net.
	[67.188.94.199]) by smtp.gmail.com with ESMTPSA id
	s10sm3915048pjn.35.2020.11.25.17.11.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 25 Nov 2020 17:11:10 -0800 (PST)
Date: Wed, 25 Nov 2020 17:11:07 -0800
From: Minchan Kim <minchan@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126011107.GA57352@google.com>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-61-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-61-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 26 Nov 2020 03:35:50 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
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
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 60/78] zram: remove the claim mechanism
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

On Mon, Nov 16, 2020 at 03:57:51PM +0100, Christoph Hellwig wrote:
> The zram claim mechanism was added to ensure no new opens come in
> during teardown.  But the proper way to archive that is to call
> del_gendisk first, which takes care of all that.  Once del_gendisk
> is called in the right place, the reset side can also be simplified
> as no I/O can be outstanding on a block device that is not open.

It would be great if it makes the mess simple. Let me have a question
Please see below.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/zram/zram_drv.c | 76 ++++++++++-------------------------
>  1 file changed, 21 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 6d15d51cee2b7e..3641434a9b154d 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1756,64 +1756,33 @@ static ssize_t disksize_store(struct device *dev,
>  static ssize_t reset_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t len)
>  {
> -	int ret;
> -	unsigned short do_reset;
> -	struct zram *zram;
> +	struct zram *zram = dev_to_zram(dev);
>  	struct block_device *bdev;
> +	unsigned short do_reset;
> +	int ret = 0;
>  
>  	ret = kstrtou16(buf, 10, &do_reset);
>  	if (ret)
>  		return ret;
> -
>  	if (!do_reset)
>  		return -EINVAL;
>  
> -	zram = dev_to_zram(dev);
>  	bdev = bdget_disk(zram->disk, 0);
>  	if (!bdev)
>  		return -ENOMEM;
>  
>  	mutex_lock(&bdev->bd_mutex);
> -	/* Do not reset an active device or claimed device */
> -	if (bdev->bd_openers || zram->claim) {
> -		mutex_unlock(&bdev->bd_mutex);
> -		bdput(bdev);
> -		return -EBUSY;
> -	}
> -
> -	/* From now on, anyone can't open /dev/zram[0-9] */
> -	zram->claim = true;
> +	if (bdev->bd_openers)
> +		ret = -EBUSY;
> +	else
> +		zram_reset_device(zram);
>  	mutex_unlock(&bdev->bd_mutex);
> -
> -	/* Make sure all the pending I/O are finished */
> -	fsync_bdev(bdev);
> -	zram_reset_device(zram);
>  	bdput(bdev);
>  
> -	mutex_lock(&bdev->bd_mutex);
> -	zram->claim = false;
> -	mutex_unlock(&bdev->bd_mutex);
> -
> -	return len;
> -}
> -
> -static int zram_open(struct block_device *bdev, fmode_t mode)
> -{
> -	int ret = 0;
> -	struct zram *zram;
> -
> -	WARN_ON(!mutex_is_locked(&bdev->bd_mutex));
> -
> -	zram = bdev->bd_disk->private_data;
> -	/* zram was claimed to reset so open request fails */
> -	if (zram->claim)
> -		ret = -EBUSY;
> -
> -	return ret;
> +	return ret ? ret : len;
>  }
>  
>  static const struct block_device_operations zram_devops = {
> -	.open = zram_open,
>  	.submit_bio = zram_submit_bio,
>  	.swap_slot_free_notify = zram_slot_free_notify,
>  	.rw_page = zram_rw_page,
> @@ -1821,7 +1790,6 @@ static const struct block_device_operations zram_devops = {
>  };
>  
>  static const struct block_device_operations zram_wb_devops = {
> -	.open = zram_open,
>  	.submit_bio = zram_submit_bio,
>  	.swap_slot_free_notify = zram_slot_free_notify,
>  	.owner = THIS_MODULE
> @@ -1972,34 +1940,32 @@ static int zram_add(void)
>  	return ret;
>  }
>  
> -static int zram_remove(struct zram *zram)
> +static bool zram_busy(struct zram *zram)
>  {
>  	struct block_device *bdev;
> +	bool busy = false;
>  
>  	bdev = bdget_disk(zram->disk, 0);
> -	if (!bdev)
> -		return -ENOMEM;
> -
> -	mutex_lock(&bdev->bd_mutex);
> -	if (bdev->bd_openers || zram->claim) {
> -		mutex_unlock(&bdev->bd_mutex);
> +	if (bdev) {
> +		if (bdev->bd_openers)
> +			busy = true;
>  		bdput(bdev);
> -		return -EBUSY;
>  	}
>  
> -	zram->claim = true;
> -	mutex_unlock(&bdev->bd_mutex);
> +	return busy;
> +}
>  
> -	zram_debugfs_unregister(zram);
> +static int zram_remove(struct zram *zram)
> +{
> +	if (zram_busy(zram))
> +		return -EBUSY;
>  
> -	/* Make sure all the pending I/O are finished */
> -	fsync_bdev(bdev);
> +	del_gendisk(zram->disk);
> +	zram_debugfs_unregister(zram);
>  	zram_reset_device(zram);
> -	bdput(bdev);
>  
>  	pr_info("Removed device: %s\n", zram->disk->disk_name);
>  
> -	del_gendisk(zram->disk);
>  	blk_cleanup_queue(zram->disk->queue);
>  	put_disk(zram->disk);
>  	kfree(zram);
> -- 
> 2.29.2
> 

With this patch, how deal with the race?

CPU 1                                     CPU 2

hot_remove_store
  zram_remove
    zram_busy
      return -EBUSY
                                         open /dev/zram0
    del_gendisk
    zram_reset and destroy

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

