Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6624FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 19:07:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-E4BqQ1tAN4iQlzquO6zC_g-1; Tue, 30 Nov 2021 14:07:10 -0500
X-MC-Unique: E4BqQ1tAN4iQlzquO6zC_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AD0D1023F4E;
	Tue, 30 Nov 2021 19:07:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1B95D9DE;
	Tue, 30 Nov 2021 19:07:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E34B41806D2C;
	Tue, 30 Nov 2021 19:07:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUJ731Z017993 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 14:07:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D6835C08090; Tue, 30 Nov 2021 19:07:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D28C1C15E6F
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 19:07:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9577181944B
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 19:07:03 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-598-Et9sraN_Mum-V09isHzw6g-1; Tue, 30 Nov 2021 14:06:59 -0500
X-MC-Unique: Et9sraN_Mum-V09isHzw6g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id 6015ECE1A42;
	Tue, 30 Nov 2021 19:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA8FC53FC7;
	Tue, 30 Nov 2021 19:06:53 +0000 (UTC)
Date: Tue, 30 Nov 2021 11:06:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211130190653.GJ8467@magnolia>
References: <20211129102203.2243509-1-hch@lst.de>
	<20211129102203.2243509-27-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211129102203.2243509-27-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 26/29] fsdax: shift partition offset handling
 into the file systems
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 29, 2021 at 11:22:00AM +0100, Christoph Hellwig wrote:
> Remove the last user of ->bdev in dax.c by requiring the file system to
> pass in an address that already includes the DAX offset.  As part of the
> only set ->bdev or ->daxdev when actually required in the ->iomap_begin
> methods.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com> [erofs]

Looks like a straightfoward conversion.  In addition to reviewing the
xfs parts, I spot-checked the ext* bits and didn't see anything
obviously wrong there, but you might want to get an ack from Ted and
Jan.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c            |  6 +-----
>  fs/erofs/data.c     | 11 +++++++++--
>  fs/erofs/internal.h |  1 +
>  fs/ext2/inode.c     |  8 ++++++--
>  fs/ext4/inode.c     | 16 +++++++++++-----
>  fs/xfs/xfs_iomap.c  | 10 ++++++++--
>  6 files changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 148e8b0967f35..e0eecd8e3a8f8 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -711,11 +711,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  
>  static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
>  {
> -	phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
> -
> -	if (iomap->bdev)
> -		paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
> -	return PHYS_PFN(paddr);
> +	return PHYS_PFN(iomap->addr + (pos & PAGE_MASK) - iomap->offset);
>  }
>  
>  static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 0e35ef3f9f3d7..9b1bb177ce303 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -159,6 +159,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>  	/* primary device by default */
>  	map->m_bdev = sb->s_bdev;
>  	map->m_daxdev = EROFS_SB(sb)->dax_dev;
> +	map->m_dax_part_off = EROFS_SB(sb)->dax_part_off;
>  
>  	if (map->m_deviceid) {
>  		down_read(&devs->rwsem);
> @@ -169,6 +170,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>  		}
>  		map->m_bdev = dif->bdev;
>  		map->m_daxdev = dif->dax_dev;
> +		map->m_dax_part_off = dif->dax_part_off;
>  		up_read(&devs->rwsem);
>  	} else if (devs->extra_devices) {
>  		down_read(&devs->rwsem);
> @@ -185,6 +187,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
>  				map->m_pa -= startoff;
>  				map->m_bdev = dif->bdev;
>  				map->m_daxdev = dif->dax_dev;
> +				map->m_dax_part_off = dif->dax_part_off;
>  				break;
>  			}
>  		}
> @@ -215,9 +218,13 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	if (ret)
>  		return ret;
>  
> -	iomap->bdev = mdev.m_bdev;
> -	iomap->dax_dev = mdev.m_daxdev;
>  	iomap->offset = map.m_la;
> +	if (flags & IOMAP_DAX) {
> +		iomap->dax_dev = mdev.m_daxdev;
> +		iomap->offset += mdev.m_dax_part_off;
> +	} else {
> +		iomap->bdev = mdev.m_bdev;
> +	}
>  	iomap->length = map.m_llen;
>  	iomap->flags = 0;
>  	iomap->private = NULL;
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index c1e65346e9f15..5c2a83876220c 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -438,6 +438,7 @@ static inline int z_erofs_map_blocks_iter(struct inode *inode,
>  struct erofs_map_dev {
>  	struct block_device *m_bdev;
>  	struct dax_device *m_daxdev;
> +	u64 m_dax_part_off;
>  
>  	erofs_off_t m_pa;
>  	unsigned int m_deviceid;
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 01d69618277de..602578b72d8c5 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -817,9 +817,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  		return ret;
>  
>  	iomap->flags = 0;
> -	iomap->bdev = inode->i_sb->s_bdev;
>  	iomap->offset = (u64)first_block << blkbits;
> -	iomap->dax_dev = sbi->s_daxdev;
> +	if (flags & IOMAP_DAX)
> +		iomap->dax_dev = sbi->s_daxdev;
> +	else
> +		iomap->bdev = inode->i_sb->s_bdev;
>  
>  	if (ret == 0) {
>  		iomap->type = IOMAP_HOLE;
> @@ -828,6 +830,8 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	} else {
>  		iomap->type = IOMAP_MAPPED;
>  		iomap->addr = (u64)bno << blkbits;
> +		if (flags & IOMAP_DAX)
> +			iomap->addr += sbi->s_dax_part_off;
>  		iomap->length = (u64)ret << blkbits;
>  		iomap->flags |= IOMAP_F_MERGED;
>  	}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 89c4a174bd393..ccafcbc146d3e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3272,7 +3272,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
>  
>  static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  			   struct ext4_map_blocks *map, loff_t offset,
> -			   loff_t length)
> +			   loff_t length, unsigned int flags)
>  {
>  	u8 blkbits = inode->i_blkbits;
>  
> @@ -3289,8 +3289,10 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  	if (map->m_flags & EXT4_MAP_NEW)
>  		iomap->flags |= IOMAP_F_NEW;
>  
> -	iomap->bdev = inode->i_sb->s_bdev;
> -	iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
> +	if (flags & IOMAP_DAX)
> +		iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
> +	else
> +		iomap->bdev = inode->i_sb->s_bdev;
>  	iomap->offset = (u64) map->m_lblk << blkbits;
>  	iomap->length = (u64) map->m_len << blkbits;
>  
> @@ -3310,9 +3312,13 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  	if (map->m_flags & EXT4_MAP_UNWRITTEN) {
>  		iomap->type = IOMAP_UNWRITTEN;
>  		iomap->addr = (u64) map->m_pblk << blkbits;
> +		if (flags & IOMAP_DAX)
> +			iomap->addr += EXT4_SB(inode->i_sb)->s_dax_part_off;
>  	} else if (map->m_flags & EXT4_MAP_MAPPED) {
>  		iomap->type = IOMAP_MAPPED;
>  		iomap->addr = (u64) map->m_pblk << blkbits;
> +		if (flags & IOMAP_DAX)
> +			iomap->addr += EXT4_SB(inode->i_sb)->s_dax_part_off;
>  	} else {
>  		iomap->type = IOMAP_HOLE;
>  		iomap->addr = IOMAP_NULL_ADDR;
> @@ -3421,7 +3427,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	if (ret < 0)
>  		return ret;
>  out:
> -	ext4_set_iomap(inode, iomap, &map, offset, length);
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  
>  	return 0;
>  }
> @@ -3541,7 +3547,7 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
>  		delalloc = ext4_iomap_is_delalloc(inode, &map);
>  
>  set_iomap:
> -	ext4_set_iomap(inode, iomap, &map, offset, length);
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	if (delalloc && iomap->type == IOMAP_HOLE)
>  		iomap->type = IOMAP_DELALLOC;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0ed3e7674353b..e552ce541ec2d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -71,15 +71,21 @@ xfs_bmbt_to_iomap(
>  		iomap->type = IOMAP_DELALLOC;
>  	} else {
>  		iomap->addr = BBTOB(xfs_fsb_to_db(ip, imap->br_startblock));
> +		if (mapping_flags & IOMAP_DAX)
> +			iomap->addr += target->bt_dax_part_off;
> +
>  		if (imap->br_state == XFS_EXT_UNWRITTEN)
>  			iomap->type = IOMAP_UNWRITTEN;
>  		else
>  			iomap->type = IOMAP_MAPPED;
> +
>  	}
>  	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> -	iomap->bdev = target->bt_bdev;
> -	iomap->dax_dev = target->bt_daxdev;
> +	if (mapping_flags & IOMAP_DAX)
> +		iomap->dax_dev = target->bt_daxdev;
> +	else
> +		iomap->bdev = target->bt_bdev;
>  	iomap->flags = iomap_flags;
>  
>  	if (xfs_ipincount(ip) &&
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

