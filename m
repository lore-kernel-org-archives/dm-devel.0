Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D48C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989645;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B4VdCzekr8AnFPZSDWv4EedFzAgZnxwFb8+AiQeoaDk=;
	b=SQ7wKEns8fqAh/GJ9Pji8EdC0g3+j+0Y8u9gsy7u6XT8ziLWCftMvlzlTjprows40SJL7b
	VAZy8iczCu4u9utCNaX3sRweRJP/e0HI0zElnuKSbeAOyR6sKKy47sfB44wyfmmJnKbF2w
	3sEi2ucdT3M5rwgGoe2UzZXHZSfvUjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-qEKJA-IHM8mVSuTv9oszgg-1; Mon, 04 Jul 2022 22:54:02 -0400
X-MC-Unique: qEKJA-IHM8mVSuTv9oszgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C965D185A7B2;
	Tue,  5 Jul 2022 02:54:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B35982026D64;
	Tue,  5 Jul 2022 02:54:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FFC1194704A;
	Tue,  5 Jul 2022 02:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E09271947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:53:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6748112131B; Tue,  5 Jul 2022 02:53:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A22DC1121315
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:53:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 657A3803524
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:53:59 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-KiLZOUMDOcGTlYX1c4canQ-1; Mon, 04 Jul 2022 22:53:57 -0400
X-MC-Unique: KiLZOUMDOcGTlYX1c4canQ-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205520878"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:53:56 +0800
IronPort-SDR: esGNLlNiNmvdSG3quEnva5Bq7SIua98ICOW17E4VjkW+ZvmUKgfCVhYfdpb2+YGY0ZXImw+ucv
 0Wave8sQptyVzTHfPBHrNwCWoJW1kIIz+JMUTYJk6dTP4q+NQWR0sNsC//YbjOyLfNZqEcMIR5
 fjhAxQAgMrsPh9+vvBQusOkgSwPqUMaR4GzzZ7yhOQGlqSzstfcfuiDKLHq87SNx6tIToqonU3
 kHqboFkikUZXcuMA3y68qQX5cjOf1Zhq9bBK3T0iHskxv9SJMS/XKtJCAbNX34AxyXGbUQ820M
 E1575UolKeCvnZn60omZmBUA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:15:48 -0700
IronPort-SDR: u+cJiZ9WEGMvjCS97Zj8vq1wB4pAGG7R4zDOzCfk1n19QHRVOmDUERhg6L7vCa+fZ/p3guCKeg
 wMmftXvg2YrAox0xFhwwwA61BMx3Q2y2lagBbsx6rrgOGYW43bDOn85SbigzrmPqSO7J8EOgGF
 o6nEu76QQnkzEHPtPvqVgrovFmSwm0VVb0GkLfGbL7ra9i5VIynV39QIs9WzhLfaCXSNQwpIys
 wFV+ryNkG1P+DuCpI3towi4rDATYpYwFlP2maqARvzPYIZ9zPF1SL4inzK2vVjHMh1oOjMc4pr
 n48=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:53:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS1J1xmRz1Rwnx
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:53:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id MY3q68Xmo8GX for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:53:55 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS1G2BYxz1RtVk;
 Mon,  4 Jul 2022 19:53:54 -0700 (PDT)
Message-ID: <0388d3ac-2339-7c27-aac6-3cf192a9bf08@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:53:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-14-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-14-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 13/17] block: replace blkdev_nr_zones with
 bdev_nr_zones
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Pass a block_device instead of a request_queue a that is what most

s/a that/as that

> callers have at hand.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-zoned.c              | 15 ++++++++-------
>  block/ioctl.c                  |  2 +-
>  drivers/block/null_blk/zoned.c |  2 +-
>  drivers/md/dm-zone.c           |  2 +-
>  drivers/md/dm-zoned-target.c   |  5 ++---
>  drivers/nvme/target/zns.c      |  4 ++--
>  fs/zonefs/super.c              | 17 ++++++++---------
>  include/linux/blkdev.h         |  4 ++--
>  8 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 9085f9fb3ab42..836b96ebfdc04 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -108,21 +108,22 @@ void __blk_req_zone_write_unlock(struct request *rq)
>  EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>  
>  /**
> - * blkdev_nr_zones - Get number of zones
> - * @disk:	Target gendisk
> + * bdev_nr_zones - Get number of zones
> + * @bdev:	Target device
>   *
>   * Return the total number of zones of a zoned block device.  For a block
>   * device without zone capabilities, the number of zones is always 0.
>   */
> -unsigned int blkdev_nr_zones(struct gendisk *disk)
> +unsigned int bdev_nr_zones(struct block_device *bdev)
>  {
> -	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
>  
> -	if (!blk_queue_is_zoned(disk->queue))
> +	if (!blk_queue_is_zoned(bdev_get_queue(bdev)))

bdev_is_zoned() ?

>  		return 0;
> -	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
> +	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
> +		ilog2(zone_sectors);
>  }
> -EXPORT_SYMBOL_GPL(blkdev_nr_zones);
> +EXPORT_SYMBOL_GPL(bdev_nr_zones);
>  
>  /**
>   * blkdev_report_zones - Get zones information
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 46949f1b0dba5..60121e89052bc 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -495,7 +495,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
>  	case BLKGETZONESZ:
>  		return put_uint(argp, bdev_zone_sectors(bdev));
>  	case BLKGETNRZONES:
> -		return put_uint(argp, blkdev_nr_zones(bdev->bd_disk));
> +		return put_uint(argp, bdev_nr_zones(bdev));
>  	case BLKROGET:
>  		return put_int(argp, bdev_read_only(bdev) != 0);
>  	case BLKSSZGET: /* get block device logical block size */
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 576ab3ed082a5..e62c52e964259 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -170,7 +170,7 @@ int null_register_zoned_dev(struct nullb *nullb)
>  			return ret;
>  	} else {
>  		blk_queue_chunk_sectors(q, dev->zone_size_sects);
> -		q->nr_zones = blkdev_nr_zones(nullb->disk);
> +		q->nr_zones = bdev_nr_zones(nullb->disk->part0);
>  	}
>  
>  	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index ae616b87c91ae..6d105abe12415 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -301,7 +301,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	 * correct value to be exposed in sysfs queue/nr_zones.
>  	 */
>  	WARN_ON_ONCE(queue_is_mq(q));
> -	q->nr_zones = blkdev_nr_zones(md->disk);
> +	q->nr_zones = bdev_nr_zones(md->disk->part0);
>  
>  	/* Check if zone append is natively supported */
>  	if (dm_table_supports_zone_append(t)) {
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 0ec5d8b9b1a4e..6ba6ef44b00e2 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -793,8 +793,7 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  			}
>  			zone_nr_sectors = blk_queue_zone_sectors(q);
>  			zoned_dev->zone_nr_sectors = zone_nr_sectors;
> -			zoned_dev->nr_zones =
> -				blkdev_nr_zones(zoned_dev->bdev->bd_disk);
> +			zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
>  		}
>  	} else {
>  		reg_dev = NULL;
> @@ -805,7 +804,7 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  		}
>  		q = bdev_get_queue(zoned_dev->bdev);
>  		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> -		zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
> +		zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
>  	}
>  
>  	if (reg_dev) {
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index c6f0a775efdee..c9b2ce06ca93e 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -60,7 +60,7 @@ bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>  	if (ns->bdev->bd_disk->queue->conv_zones_bitmap)
>  		return false;
>  
> -	ret = blkdev_report_zones(ns->bdev, 0, blkdev_nr_zones(bd_disk),
> +	ret = blkdev_report_zones(ns->bdev, 0, bdev_nr_zones(ns->bdev),
>  				  validate_conv_zones_cb, NULL);
>  	if (ret < 0)
>  		return false;
> @@ -241,7 +241,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
>  {
>  	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
>  
> -	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
> +	return bdev_nr_zones(req->ns->bdev) -
>  		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
>  }
>  
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 053299758deb9..9c0eef1ff32a0 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1394,7 +1394,7 @@ static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
>  {
>  	struct super_block *sb = parent->i_sb;
>  
> -	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk) + type + 1;
> +	inode->i_ino = bdev_nr_zones(sb->s_bdev) + type + 1;
>  	inode_init_owner(&init_user_ns, inode, parent, S_IFDIR | 0555);
>  	inode->i_op = &zonefs_dir_inode_operations;
>  	inode->i_fop = &simple_dir_operations;
> @@ -1540,7 +1540,7 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
>  	/*
>  	 * The first zone contains the super block: skip it.
>  	 */
> -	end = zd->zones + blkdev_nr_zones(sb->s_bdev->bd_disk);
> +	end = zd->zones + bdev_nr_zones(sb->s_bdev);
>  	for (zone = &zd->zones[1]; zone < end; zone = next) {
>  
>  		next = zone + 1;
> @@ -1635,8 +1635,8 @@ static int zonefs_get_zone_info(struct zonefs_zone_data *zd)
>  	struct block_device *bdev = zd->sb->s_bdev;
>  	int ret;
>  
> -	zd->zones = kvcalloc(blkdev_nr_zones(bdev->bd_disk),
> -			     sizeof(struct blk_zone), GFP_KERNEL);
> +	zd->zones = kvcalloc(bdev_nr_zones(bdev), sizeof(struct blk_zone),
> +			     GFP_KERNEL);
>  	if (!zd->zones)
>  		return -ENOMEM;
>  
> @@ -1648,9 +1648,9 @@ static int zonefs_get_zone_info(struct zonefs_zone_data *zd)
>  		return ret;
>  	}
>  
> -	if (ret != blkdev_nr_zones(bdev->bd_disk)) {
> +	if (ret != bdev_nr_zones(bdev)) {
>  		zonefs_err(zd->sb, "Invalid zone report (%d/%u zones)\n",
> -			   ret, blkdev_nr_zones(bdev->bd_disk));
> +			   ret, bdev_nr_zones(bdev));
>  		return -EIO;
>  	}
>  
> @@ -1816,8 +1816,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (ret)
>  		goto cleanup;
>  
> -	zonefs_info(sb, "Mounting %u zones",
> -		    blkdev_nr_zones(sb->s_bdev->bd_disk));
> +	zonefs_info(sb, "Mounting %u zones", bdev_nr_zones(sb->s_bdev));
>  
>  	if (!sbi->s_max_wro_seq_files &&
>  	    !sbi->s_max_active_seq_files &&
> @@ -1833,7 +1832,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!inode)
>  		goto cleanup;
>  
> -	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk);
> +	inode->i_ino = bdev_nr_zones(sb->s_bdev);
>  	inode->i_mode = S_IFDIR | 0555;
>  	inode->i_ctime = inode->i_mtime = inode->i_atime = current_time(inode);
>  	inode->i_op = &zonefs_dir_inode_operations;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e32c147f72868..183aa83143fd2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -298,7 +298,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
>  #define BLK_ALL_ZONES  ((unsigned int)-1)
>  int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>  			unsigned int nr_zones, report_zones_cb cb, void *data);
> -unsigned int blkdev_nr_zones(struct gendisk *disk);
> +unsigned int bdev_nr_zones(struct block_device *bdev);
>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  			    sector_t sectors, sector_t nr_sectors,
>  			    gfp_t gfp_mask);
> @@ -314,7 +314,7 @@ extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  #else /* CONFIG_BLK_DEV_ZONED */
>  
> -static inline unsigned int blkdev_nr_zones(struct gendisk *disk)
> +static inline unsigned int bdev_nr_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

