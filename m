Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF79C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:02:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 25F9460234
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25F9460234
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-rwYp4qDhOSW3VrPQyCQHYA-1; Tue, 09 Nov 2021 04:02:19 -0500
X-MC-Unique: rwYp4qDhOSW3VrPQyCQHYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A597D19200C4;
	Tue,  9 Nov 2021 09:02:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AE5360843;
	Tue,  9 Nov 2021 09:02:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4D2A0181A1CF;
	Tue,  9 Nov 2021 09:02:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9909xH017696 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 04:00:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14CC9404727A; Tue,  9 Nov 2021 09:00:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 105244047272
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E647E106655A
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:08 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-171-gaVoWnkrMGqGAnvPEUIPhw-1; Tue, 09 Nov 2021 04:00:05 -0500
X-MC-Unique: gaVoWnkrMGqGAnvPEUIPhw-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZp-000sBq-OP; Tue, 09 Nov 2021 08:33:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:33:06 +0100
Message-Id: <20211109083309.584081-27-hch@lst.de>
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 26/29] fsdax: shift partition offset handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the last user of ->bdev in dax.c by requiring the file system to
pass in an address that already includes the DAX offset.  As part of the
only set ->bdev or ->daxdev when actually required in the ->iomap_begin
methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c                 |  6 +-----
 fs/erofs/data.c          | 11 ++++++++--
 fs/erofs/internal.h      |  1 +
 fs/ext2/inode.c          |  8 +++++--
 fs/ext4/inode.c          | 16 +++++++++-----
 fs/xfs/libxfs/xfs_bmap.c |  4 ++--
 fs/xfs/xfs_aops.c        |  2 +-
 fs/xfs/xfs_iomap.c       | 45 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_iomap.h       |  5 +++--
 fs/xfs/xfs_pnfs.c        |  2 +-
 10 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0bd6cdcbacfc4..2c13c681edf09 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -711,11 +711,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 
 static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
 {
-	phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
-
-	if (iomap->bdev)
-		paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
-	return PHYS_PFN(paddr);
+	return PHYS_PFN(iomap->addr + (pos & PAGE_MASK) - iomap->offset);
 }
 
 static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0e35ef3f9f3d7..9b1bb177ce303 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -159,6 +159,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 	/* primary device by default */
 	map->m_bdev = sb->s_bdev;
 	map->m_daxdev = EROFS_SB(sb)->dax_dev;
+	map->m_dax_part_off = EROFS_SB(sb)->dax_part_off;
 
 	if (map->m_deviceid) {
 		down_read(&devs->rwsem);
@@ -169,6 +170,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 		}
 		map->m_bdev = dif->bdev;
 		map->m_daxdev = dif->dax_dev;
+		map->m_dax_part_off = dif->dax_part_off;
 		up_read(&devs->rwsem);
 	} else if (devs->extra_devices) {
 		down_read(&devs->rwsem);
@@ -185,6 +187,7 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 				map->m_pa -= startoff;
 				map->m_bdev = dif->bdev;
 				map->m_daxdev = dif->dax_dev;
+				map->m_dax_part_off = dif->dax_part_off;
 				break;
 			}
 		}
@@ -215,9 +218,13 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret)
 		return ret;
 
-	iomap->bdev = mdev.m_bdev;
-	iomap->dax_dev = mdev.m_daxdev;
 	iomap->offset = map.m_la;
+	if (flags & IOMAP_DAX) {
+		iomap->dax_dev = mdev.m_daxdev;
+		iomap->offset += mdev.m_dax_part_off;
+	} else {
+		iomap->bdev = mdev.m_bdev;
+	}
 	iomap->length = map.m_llen;
 	iomap->flags = 0;
 	iomap->private = NULL;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index c1e65346e9f15..5c2a83876220c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -438,6 +438,7 @@ static inline int z_erofs_map_blocks_iter(struct inode *inode,
 struct erofs_map_dev {
 	struct block_device *m_bdev;
 	struct dax_device *m_daxdev;
+	u64 m_dax_part_off;
 
 	erofs_off_t m_pa;
 	unsigned int m_deviceid;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index ae9993018a015..da4c301b43051 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -816,9 +816,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return ret;
 
 	iomap->flags = 0;
-	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = (u64)first_block << blkbits;
-	iomap->dax_dev = sbi->s_daxdev;
+	if (flags & IOMAP_DAX)
+		iomap->dax_dev = sbi->s_daxdev;
+	else
+		iomap->bdev = inode->i_sb->s_bdev;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
@@ -827,6 +829,8 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	} else {
 		iomap->type = IOMAP_MAPPED;
 		iomap->addr = (u64)bno << blkbits;
+		if (flags & IOMAP_DAX)
+			iomap->addr += sbi->s_dax_part_off;
 		iomap->length = (u64)ret << blkbits;
 		iomap->flags |= IOMAP_F_MERGED;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8c443b753b815..6cbecd7ff9383 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3274,7 +3274,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 
 static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 			   struct ext4_map_blocks *map, loff_t offset,
-			   loff_t length)
+			   loff_t length, unsigned int flags)
 {
 	u8 blkbits = inode->i_blkbits;
 
@@ -3291,8 +3291,10 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 	if (map->m_flags & EXT4_MAP_NEW)
 		iomap->flags |= IOMAP_F_NEW;
 
-	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
+	if (flags & IOMAP_DAX)
+		iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
+	else
+		iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = (u64) map->m_lblk << blkbits;
 	iomap->length = (u64) map->m_len << blkbits;
 
@@ -3312,9 +3314,13 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 	if (map->m_flags & EXT4_MAP_UNWRITTEN) {
 		iomap->type = IOMAP_UNWRITTEN;
 		iomap->addr = (u64) map->m_pblk << blkbits;
+		if (flags & IOMAP_DAX)
+			iomap->addr += EXT4_SB(inode->i_sb)->s_dax_part_off;
 	} else if (map->m_flags & EXT4_MAP_MAPPED) {
 		iomap->type = IOMAP_MAPPED;
 		iomap->addr = (u64) map->m_pblk << blkbits;
+		if (flags & IOMAP_DAX)
+			iomap->addr += EXT4_SB(inode->i_sb)->s_dax_part_off;
 	} else {
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
@@ -3423,7 +3429,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
-	ext4_set_iomap(inode, iomap, &map, offset, length);
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 
 	return 0;
 }
@@ -3543,7 +3549,7 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 		delalloc = ext4_iomap_is_delalloc(inode, &map);
 
 set_iomap:
-	ext4_set_iomap(inode, iomap, &map, offset, length);
+	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
 	if (delalloc && iomap->type == IOMAP_HOLE)
 		iomap->type = IOMAP_DELALLOC;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4dccd4d90622d..74198dd82b035 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4551,7 +4551,7 @@ xfs_bmapi_convert_delalloc(
 	 * the extent.  Just return the real extent at this offset.
 	 */
 	if (!isnullstartblock(bma.got.br_startblock)) {
-		xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
+		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
 		*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
@@ -4598,7 +4598,7 @@ xfs_bmapi_convert_delalloc(
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
-	xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
+	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
 	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c8c15c3c31471..6ac3449a68ba0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -359,7 +359,7 @@ xfs_map_blocks(
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 704292c6ce0c7..74dbf1fd99d39 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -54,7 +54,8 @@ xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
 	struct xfs_bmbt_irec	*imap,
-	u16			flags)
+	unsigned int		flags,
+	u16			iomap_flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
@@ -71,16 +72,22 @@ xfs_bmbt_to_iomap(
 		iomap->type = IOMAP_DELALLOC;
 	} else {
 		iomap->addr = BBTOB(xfs_fsb_to_db(ip, imap->br_startblock));
+		if (flags & IOMAP_DAX)
+			iomap->addr += target->bt_dax_part_off;
+
 		if (imap->br_state == XFS_EXT_UNWRITTEN)
 			iomap->type = IOMAP_UNWRITTEN;
 		else
 			iomap->type = IOMAP_MAPPED;
+
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->bdev = target->bt_bdev;
-	iomap->dax_dev = target->bt_daxdev;
-	iomap->flags = flags;
+	if (flags & IOMAP_DAX)
+		iomap->dax_dev = target->bt_daxdev;
+	else
+		iomap->bdev = target->bt_bdev;
+	iomap->flags = iomap_flags;
 
 	if (xfs_ipincount(ip) &&
 	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
@@ -801,7 +808,7 @@ xfs_direct_write_iomap_begin(
 
 	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags);
 
 allocate_blocks:
 	error = -EAGAIN;
@@ -832,18 +839,19 @@ xfs_direct_write_iomap_begin(
 		return error;
 
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags | IOMAP_F_NEW);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
+				 iomap_flags | IOMAP_F_NEW);
 
 out_found_cow:
 	xfs_iunlock(ip, lockmode);
 	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
 	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
 	if (imap.br_startblock != HOLESTARTBLOCK) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
 		if (error)
 			return error;
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED);
 
 out_unlock:
 	if (lockmode)
@@ -1053,23 +1061,24 @@ xfs_buffered_write_iomap_begin(
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW);
 
 found_imap:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
 
 found_cow:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (imap.br_startoff <= offset_fsb) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
 		if (error)
 			return error;
-		return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
+					 IOMAP_F_SHARED);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -1178,7 +1187,8 @@ xfs_read_iomap_begin(
 	if (error)
 		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared ? IOMAP_F_SHARED : 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
+				 shared ? IOMAP_F_SHARED : 0);
 }
 
 const struct iomap_ops xfs_read_iomap_ops = {
@@ -1237,7 +1247,8 @@ xfs_seek_iomap_begin(
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
 		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
-		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
+					  IOMAP_F_SHARED);
 		/*
 		 * This is a COW extent, so we must probe the page cache
 		 * because there could be dirty page cache being backed
@@ -1259,7 +1270,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	xfs_trim_extent(&imap, offset_fsb, end_fsb);
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
@@ -1306,7 +1317,7 @@ xfs_xattr_iomap_begin(
 	if (error)
 		return error;
 	ASSERT(nimaps);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
 }
 
 const struct iomap_ops xfs_xattr_iomap_ops = {
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 5648262a71736..fe7a625361d95 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -18,8 +18,9 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
-int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-		struct xfs_bmbt_irec *, u16);
+int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
+		struct xfs_bmbt_irec *imap, unsigned int flags,
+		u16 iomap_flags);
 
 int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
 		bool *did_zero);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index e188e1cf97cc5..d6334abbc0b3e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -173,7 +173,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

