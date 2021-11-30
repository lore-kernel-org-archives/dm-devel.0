Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5692DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 19:04:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-AJ7Noy9NMMaOMWSFaBDbKQ-1; Tue, 30 Nov 2021 14:04:52 -0500
X-MC-Unique: AJ7Noy9NMMaOMWSFaBDbKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66F20101F001;
	Tue, 30 Nov 2021 19:04:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4860910013D6;
	Tue, 30 Nov 2021 19:04:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E92F94A705;
	Tue, 30 Nov 2021 19:04:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUJ4kbC017822 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 14:04:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 248AF1121319; Tue, 30 Nov 2021 19:04:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FECB1121315
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 19:04:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05AB185A5B5
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 19:04:41 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-159-bap7eJpQP0mLoNG3_y-f-g-1; Tue, 30 Nov 2021 14:04:39 -0500
X-MC-Unique: bap7eJpQP0mLoNG3_y-f-g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B4523B81BE9;
	Tue, 30 Nov 2021 19:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F987C53FCC;
	Tue, 30 Nov 2021 19:04:36 +0000 (UTC)
Date: Tue, 30 Nov 2021 11:04:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211130190436.GI8467@magnolia>
References: <20211129102203.2243509-1-hch@lst.de>
	<20211129102203.2243509-26-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211129102203.2243509-26-hch@lst.de>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 25/29] dax: return the partition offset from
 fs_dax_get_by_bdev
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Nov 29, 2021 at 11:21:59AM +0100, Christoph Hellwig wrote:
> Prepare for the removal of the block_device from the DAX I/O path by
> returning the partition offset from fs_dax_get_by_bdev so that the file
> systems have it at hand for use during I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  drivers/dax/super.c | 9 ++++++---
>  drivers/md/dm.c     | 4 ++--
>  fs/erofs/internal.h | 2 ++
>  fs/erofs/super.c    | 4 ++--
>  fs/ext2/ext2.h      | 1 +
>  fs/ext2/super.c     | 2 +-
>  fs/ext4/ext4.h      | 1 +
>  fs/ext4/super.c     | 2 +-
>  fs/xfs/xfs_buf.c    | 2 +-
>  fs/xfs/xfs_buf.h    | 1 +
>  include/linux/dax.h | 6 ++++--
>  11 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45d931aefd063..e7152a6c4cc40 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -69,17 +69,20 @@ EXPORT_SYMBOL_GPL(dax_remove_host);
>  /**
>   * fs_dax_get_by_bdev() - temporary lookup mechanism for filesystem-dax
>   * @bdev: block device to find a dax_device for
> + * @start_off: returns the byte offset into the dax_device that @bdev starts
>   */
> -struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off)
>  {
>  	struct dax_device *dax_dev;
> +	u64 part_size;
>  	int id;
>  
>  	if (!blk_queue_dax(bdev->bd_disk->queue))
>  		return NULL;
>  
> -	if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> -	    (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
> +	*start_off = get_start_sect(bdev) * SECTOR_SIZE;
> +	part_size = bdev_nr_sectors(bdev) * SECTOR_SIZE;
> +	if (*start_off % PAGE_SIZE || part_size % PAGE_SIZE) {
>  		pr_info("%pg: error: unaligned partition for dax\n", bdev);
>  		return NULL;
>  	}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4eba27e75c230..4e997c02bb0a0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -637,7 +637,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>  			     struct mapped_device *md)
>  {
>  	struct block_device *bdev;
> -
> +	u64 part_off;
>  	int r;
>  
>  	BUG_ON(td->dm_dev.bdev);
> @@ -653,7 +653,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>  	}
>  
>  	td->dm_dev.bdev = bdev;
> -	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
> +	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off);
>  	return 0;
>  }
>  
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 3265688af7f9f..c1e65346e9f15 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -51,6 +51,7 @@ struct erofs_device_info {
>  	char *path;
>  	struct block_device *bdev;
>  	struct dax_device *dax_dev;
> +	u64 dax_part_off;
>  
>  	u32 blocks;
>  	u32 mapped_blkaddr;
> @@ -109,6 +110,7 @@ struct erofs_sb_info {
>  #endif	/* CONFIG_EROFS_FS_ZIP */
>  	struct erofs_dev_context *devs;
>  	struct dax_device *dax_dev;
> +	u64 dax_part_off;
>  	u64 total_blocks;
>  	u32 primarydevice_blocks;
>  
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 0aed886473c8d..71efce16024d9 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -312,7 +312,7 @@ static int erofs_init_devices(struct super_block *sb,
>  			goto err_out;
>  		}
>  		dif->bdev = bdev;
> -		dif->dax_dev = fs_dax_get_by_bdev(bdev);
> +		dif->dax_dev = fs_dax_get_by_bdev(bdev, &dif->dax_part_off);
>  		dif->blocks = le32_to_cpu(dis->blocks);
>  		dif->mapped_blkaddr = le32_to_cpu(dis->mapped_blkaddr);
>  		sbi->total_blocks += dif->blocks;
> @@ -644,7 +644,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	sb->s_fs_info = sbi;
>  	sbi->opt = ctx->opt;
> -	sbi->dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
> +	sbi->dax_dev = fs_dax_get_by_bdev(sb->s_bdev, &sbi->dax_part_off);
>  	sbi->devs = ctx->devs;
>  	ctx->devs = NULL;
>  
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 3be9dd6412b78..d4f306aa5aceb 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -118,6 +118,7 @@ struct ext2_sb_info {
>  	spinlock_t s_lock;
>  	struct mb_cache *s_ea_block_cache;
>  	struct dax_device *s_daxdev;
> +	u64 s_dax_part_off;
>  };
>  
>  static inline spinlock_t *
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 7e23482862e69..94f1fbd7d3ac2 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -831,7 +831,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb_block = sb_block;
> -	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
> +	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev, &sbi->s_dax_part_off);
>  
>  	spin_lock_init(&sbi->s_lock);
>  	ret = -EINVAL;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 404dd50856e5d..9cc55bcda6ba4 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1697,6 +1697,7 @@ struct ext4_sb_info {
>  	 */
>  	struct percpu_rw_semaphore s_writepages_rwsem;
>  	struct dax_device *s_daxdev;
> +	u64 s_dax_part_off;
>  #ifdef CONFIG_EXT4_DEBUG
>  	unsigned long s_simulate_fail;
>  #endif
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8d7e3449c6472..56228e33e52a2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3913,7 +3913,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!sbi->s_blockgroup_lock)
>  		goto out_free_base;
>  
> -	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
> +	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev, &sbi->s_dax_part_off);
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb = sb;
>  	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4d4553ffa7050..bbb0fbd34e649 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1945,7 +1945,7 @@ xfs_alloc_buftarg(
>  	btp->bt_mount = mp;
>  	btp->bt_dev =  bdev->bd_dev;
>  	btp->bt_bdev = bdev;
> -	btp->bt_daxdev = fs_dax_get_by_bdev(bdev);
> +	btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off);
>  
>  	/*
>  	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index bd7f709f0d232..edcb6254fa6a8 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -89,6 +89,7 @@ typedef struct xfs_buftarg {
>  	dev_t			bt_dev;
>  	struct block_device	*bt_bdev;
>  	struct dax_device	*bt_daxdev;
> +	u64			bt_dax_part_off;
>  	struct xfs_mount	*bt_mount;
>  	unsigned int		bt_meta_sectorsize;
>  	size_t			bt_meta_sectormask;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b79036743e7fa..f6f353382cc90 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -117,7 +117,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>  	put_dax(dax_dev);
>  }
>  
> -struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
> +		u64 *start_off);
>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
>  
> @@ -138,7 +139,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
>  }
>  
> -static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> +static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev,
> +		u64 *start_off)
>  {
>  	return NULL;
>  }
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

