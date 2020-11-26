Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15701C56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:48:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 70845207BC
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70845207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-1uwaAZMdMAq5DwORDaJoAw-1; Thu, 26 Nov 2020 12:48:10 -0500
X-MC-Unique: 1uwaAZMdMAq5DwORDaJoAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B04D805BFE;
	Thu, 26 Nov 2020 17:48:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D55A100AE2D;
	Thu, 26 Nov 2020 17:48:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C09DC4BB7B;
	Thu, 26 Nov 2020 17:48:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQHm3bK001329 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 12:48:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3B7EB2026D36; Thu, 26 Nov 2020 17:48:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 372CA2026D47
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:48:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19955858284
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:48:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-174-Eyw9rcAINoaHBL3_Wuhfyg-1;
	Thu, 26 Nov 2020 12:47:56 -0500
X-MC-Unique: Eyw9rcAINoaHBL3_Wuhfyg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 14588ACA9;
	Thu, 26 Nov 2020 17:47:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id AC5821E10D0; Thu, 26 Nov 2020 18:47:54 +0100 (CET)
Date: Thu, 26 Nov 2020 18:47:54 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126174754.GY422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-40-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-40-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 39/44] block: pass a block_device to
	blk_alloc_devt
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:17, Christoph Hellwig wrote:
> Pass the block_device actually needed instead of the hd_struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/blk.h             |  2 +-
>  block/genhd.c           | 14 +++++++-------
>  block/partitions/core.c |  2 +-
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk.h b/block/blk.h
> index d5bf8f3a078186..9657c6da7c770c 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -350,7 +350,7 @@ static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
>  
>  struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector);
>  
> -int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
> +int blk_alloc_devt(struct block_device *part, dev_t *devt);
>  void blk_free_devt(dev_t devt);
>  char *disk_name(struct gendisk *hd, int partno, char *buf);
>  #define ADDPART_FLAG_NONE	0
> diff --git a/block/genhd.c b/block/genhd.c
> index a85ffd7385718d..89cd0ba8e3b84a 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -559,8 +559,8 @@ static int blk_mangle_minor(int minor)
>  }
>  
>  /**
> - * blk_alloc_devt - allocate a dev_t for a partition
> - * @part: partition to allocate dev_t for
> + * blk_alloc_devt - allocate a dev_t for a block device
> + * @bdev: block device to allocate dev_t for
>   * @devt: out parameter for resulting dev_t
>   *
>   * Allocate a dev_t for block device.
> @@ -572,14 +572,14 @@ static int blk_mangle_minor(int minor)
>   * CONTEXT:
>   * Might sleep.
>   */
> -int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
> +int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
>  {
> -	struct gendisk *disk = part_to_disk(part);
> +	struct gendisk *disk = bdev->bd_disk;
>  	int idx;
>  
>  	/* in consecutive minor range? */
> -	if (part->bdev->bd_partno < disk->minors) {
> -		*devt = MKDEV(disk->major, disk->first_minor + part->bdev->bd_partno);
> +	if (bdev->bd_partno < disk->minors) {
> +		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
>  		return 0;
>  	}
>  
> @@ -735,7 +735,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>  
>  	disk->flags |= GENHD_FL_UP;
>  
> -	retval = blk_alloc_devt(disk->part0->bd_part, &devt);
> +	retval = blk_alloc_devt(disk->part0, &devt);
>  	if (retval) {
>  		WARN_ON(1);
>  		return;
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index ecc3228a086956..4f823c4c733518 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -392,7 +392,7 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  	pdev->type = &part_type;
>  	pdev->parent = ddev;
>  
> -	err = blk_alloc_devt(p, &devt);
> +	err = blk_alloc_devt(bdev, &devt);
>  	if (err)
>  		goto out_bdput;
>  	pdev->devt = devt;
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

