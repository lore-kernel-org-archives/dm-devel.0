Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3FCC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:35:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-0rOijxfrO4inWSA2ozjO5g-1; Tue, 23 Nov 2021 17:34:55 -0500
X-MC-Unique: 0rOijxfrO4inWSA2ozjO5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E21D1B18BC1;
	Tue, 23 Nov 2021 22:34:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F81379453;
	Tue, 23 Nov 2021 22:34:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 411CB4A704;
	Tue, 23 Nov 2021 22:34:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMVSl8023149 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:31:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C59FF4010FFC; Tue, 23 Nov 2021 22:31:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0BA740CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:31:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6D3E1066559
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:31:28 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-6c1_A-wzMnyLuRExVgUVmA-1; Tue, 23 Nov 2021 17:31:24 -0500
X-MC-Unique: 6c1_A-wzMnyLuRExVgUVmA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9413360F5B;
	Tue, 23 Nov 2021 22:31:23 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:31:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123223123.GF266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 08/29] dax: remove dax_capable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:32:48AM +0100, Christoph Hellwig wrote:
> Just open code the block size and dax_dev == NULL checks in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/dax/super.c          | 36 ------------------------------------
>  drivers/md/dm-table.c        | 22 +++++++++++-----------
>  drivers/md/dm.c              | 21 ---------------------
>  drivers/md/dm.h              |  4 ----
>  drivers/nvdimm/pmem.c        |  1 -
>  drivers/s390/block/dcssblk.c |  1 -
>  fs/erofs/super.c             | 11 +++++++----
>  fs/ext2/super.c              |  6 ++++--
>  fs/ext4/super.c              |  9 ++++++---
>  fs/xfs/xfs_super.c           | 21 ++++++++-------------
>  include/linux/dax.h          | 14 --------------
>  11 files changed, 36 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 482fe775324a4..803942586d1b6 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -108,42 +108,6 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  	return dax_dev;
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> -
> -bool generic_fsdax_supported(struct dax_device *dax_dev,
> -		struct block_device *bdev, int blocksize, sector_t start,
> -		sector_t sectors)
> -{
> -	if (blocksize != PAGE_SIZE) {
> -		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> -		return false;
> -	}
> -
> -	if (!dax_dev) {
> -		pr_debug("%pg: error: dax unsupported by block device\n", bdev);
> -		return false;
> -	}
> -
> -	return true;
> -}
> -EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> -
> -bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> -		int blocksize, sector_t start, sector_t len)
> -{
> -	bool ret = false;
> -	int id;
> -
> -	if (!dax_dev)
> -		return false;
> -
> -	id = dax_read_lock();
> -	if (dax_alive(dax_dev) && dax_dev->ops->dax_supported)
> -		ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
> -						  start, len);
> -	dax_read_unlock(id);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(dax_supported);

Hooray, more dax helpers goaway!

>  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
>  
>  enum dax_device_flags {

<skipping to xfs part>

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 875fd3151d6c9..3a45d5caa28d5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -331,28 +331,23 @@ xfs_set_inode_alloc(
>  	return xfs_is_inode32(mp) ? maxagi : agcount;
>  }
>  
> -static bool
> -xfs_buftarg_is_dax(
> -	struct super_block	*sb,
> -	struct xfs_buftarg	*bt)
> -{
> -	return dax_supported(bt->bt_daxdev, bt->bt_bdev, sb->s_blocksize, 0,
> -			bdev_nr_sectors(bt->bt_bdev));
> -}
> -
>  static int
>  xfs_setup_dax_always(
>  	struct xfs_mount	*mp)
>  {
> -	struct super_block	*sb = mp->m_super;
> -
> -	if (!xfs_buftarg_is_dax(sb, mp->m_ddev_targp) &&
> -	   (!mp->m_rtdev_targp || !xfs_buftarg_is_dax(sb, mp->m_rtdev_targp))) {
> +	if (!mp->m_ddev_targp->bt_daxdev &&
> +	   (!mp->m_rtdev_targp || !mp->m_rtdev_targp->bt_daxdev)) {

Nit: This  ^ paren should be indented one more column because it's a
sub-clause of the if() test.

>  		xfs_alert(mp,
>  			"DAX unsupported by block device. Turning off DAX.");
>  		goto disable_dax;
>  	}
>  
> +	if (mp->m_super->s_blocksize != PAGE_SIZE) {
> +		xfs_alert(mp,
> +			"DAX not supported for blocksize. Turning off DAX.\n");

Nit: xfs_alert() already adds a newline to the end of the format string.

With those two things fixed up, for the XFS parts and everything XFS
depends on:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(I don't feel confident saying that I've looked at dcssblk or dm-table,
though I didn't see anything obviously wrong there...)

--D

> +		goto disable_dax;
> +	}
> +
>  	if (xfs_has_reflink(mp)) {
>  		xfs_alert(mp, "DAX and reflink cannot be used together!");
>  		return -EINVAL;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index e2e9a67004cbd..439c3c70e347b 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -111,12 +111,6 @@ int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #if IS_ENABLED(CONFIG_FS_DAX)
>  int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
>  void dax_remove_host(struct gendisk *disk);
> -bool generic_fsdax_supported(struct dax_device *dax_dev,
> -		struct block_device *bdev, int blocksize, sector_t start,
> -		sector_t sectors);
> -
> -bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> -		int blocksize, sector_t start, sector_t len);
>  
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
> @@ -139,14 +133,6 @@ static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
>  static inline void dax_remove_host(struct gendisk *disk)
>  {
>  }
> -#define generic_fsdax_supported		NULL
> -
> -static inline bool dax_supported(struct dax_device *dax_dev,
> -		struct block_device *bdev, int blocksize, sector_t start,
> -		sector_t len)
> -{
> -	return false;
> -}
>  
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

