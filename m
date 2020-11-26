Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B963C56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:05:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 917492145D
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:05:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 917492145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-L9Zo1CE-NUqJptTNh0WvDA-1; Thu, 26 Nov 2020 12:05:35 -0500
X-MC-Unique: L9Zo1CE-NUqJptTNh0WvDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D752D9CC03;
	Thu, 26 Nov 2020 17:05:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EE1660636;
	Thu, 26 Nov 2020 17:05:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18A234BB40;
	Thu, 26 Nov 2020 17:05:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQH3OGl028677 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 12:03:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61C0C2026D3D; Thu, 26 Nov 2020 17:03:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C1092026D38
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:03:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEB6D858EEC
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:03:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-505-pwtCC4wNNjCMBuSsNc2ySQ-1;
	Thu, 26 Nov 2020 12:03:17 -0500
X-MC-Unique: pwtCC4wNNjCMBuSsNc2ySQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BDDFCACC4;
	Thu, 26 Nov 2020 17:03:15 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 30EB01E10D0; Thu, 26 Nov 2020 18:03:15 +0100 (CET)
Date: Thu, 26 Nov 2020 18:03:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126170315.GU422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-36-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-36-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 35/44] block: move the policy field to struct
	block_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:13, Christoph Hellwig wrote:
> Move the policy field to struct block_device and rename it to the
> more descriptive bd_read_only.  Also turn the field into a bool as it
> is used as such.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/blk-core.c          | 2 +-
>  block/genhd.c             | 8 ++++----
>  block/ioctl.c             | 2 +-
>  block/partitions/core.c   | 4 ++--
>  include/linux/blk_types.h | 1 +
>  include/linux/genhd.h     | 4 ++--
>  6 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9121390be97a76..d64ffcb6f9ae5d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -696,7 +696,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
>  {
>  	const int op = bio_op(bio);
>  
> -	if (part->policy && op_is_write(op)) {
> +	if (part->bdev->bd_read_only && op_is_write(op)) {
>  		char b[BDEVNAME_SIZE];
>  
>  		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
> diff --git a/block/genhd.c b/block/genhd.c
> index 0371558ccde14c..ae312ccc6dd7c0 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1679,14 +1679,14 @@ void set_disk_ro(struct gendisk *disk, int flag)
>  	struct disk_part_iter piter;
>  	struct hd_struct *part;
>  
> -	if (disk->part0.policy != flag) {
> +	if (disk->part0.bdev->bd_read_only != flag) {
>  		set_disk_ro_uevent(disk, flag);
> -		disk->part0.policy = flag;
> +		disk->part0.bdev->bd_read_only = flag;
>  	}
>  
>  	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
>  	while ((part = disk_part_iter_next(&piter)))
> -		part->policy = flag;
> +		part->bdev->bd_read_only = flag;
>  	disk_part_iter_exit(&piter);
>  }
>  
> @@ -1696,7 +1696,7 @@ int bdev_read_only(struct block_device *bdev)
>  {
>  	if (!bdev)
>  		return 0;
> -	return bdev->bd_part->policy;
> +	return bdev->bd_read_only;
>  }
>  
>  EXPORT_SYMBOL(bdev_read_only);
> diff --git a/block/ioctl.c b/block/ioctl.c
> index a6d8171221c7dc..d61d652078f41c 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -345,7 +345,7 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
>  		if (ret)
>  			return ret;
>  	}
> -	bdev->bd_part->policy = n;
> +	bdev->bd_read_only = n;
>  	return 0;
>  }
>  
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index d1093adf2570e2..f397ec9922bd6e 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -199,7 +199,7 @@ static ssize_t part_ro_show(struct device *dev,
>  			    struct device_attribute *attr, char *buf)
>  {
>  	struct hd_struct *p = dev_to_part(dev);
> -	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
> +	return sprintf(buf, "%d\n", p->bdev->bd_read_only);
>  }
>  
>  static ssize_t part_alignment_offset_show(struct device *dev,
> @@ -420,7 +420,7 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  	bdev->bd_start_sect = start;
>  	bdev_set_nr_sectors(bdev, len);
>  	p->partno = partno;
> -	p->policy = get_disk_ro(disk);
> +	bdev->bd_read_only = get_disk_ro(disk);
>  
>  	if (info) {
>  		err = -ENOMEM;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index b237f1e4081405..758cf71c9aa2a6 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -23,6 +23,7 @@ struct block_device {
>  	sector_t		bd_start_sect;
>  	struct disk_stats __percpu *bd_stats;
>  	unsigned long		bd_stamp;
> +	bool			bd_read_only;	/* read-only policy */
>  	dev_t			bd_dev;
>  	int			bd_openers;
>  	struct inode *		bd_inode;	/* will die */
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 349cf6403ccddc..dcbf9ef7610ea6 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -55,7 +55,7 @@ struct hd_struct {
>  
>  	struct block_device *bdev;
>  	struct device __dev;
> -	int policy, partno;
> +	int partno;
>  	struct rcu_work rcu_work;
>  };
>  
> @@ -278,7 +278,7 @@ extern void set_disk_ro(struct gendisk *disk, int flag);
>  
>  static inline int get_disk_ro(struct gendisk *disk)
>  {
> -	return disk->part0.policy;
> +	return disk->part0.bdev->bd_read_only;
>  }
>  
>  extern void disk_block_events(struct gendisk *disk);
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

