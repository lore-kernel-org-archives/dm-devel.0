Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D05C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 10:40:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-qQAxU6KGOAiu3XWaM3t72A-1; Mon, 29 Nov 2021 05:40:02 -0500
X-MC-Unique: qQAxU6KGOAiu3XWaM3t72A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0452610168D3;
	Mon, 29 Nov 2021 10:39:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC6915DF21;
	Mon, 29 Nov 2021 10:39:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3C044A706;
	Mon, 29 Nov 2021 10:39:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATAdsuA014414 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 05:39:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3FF81402408; Mon, 29 Nov 2021 10:39:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF6D51402406
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 967E2801E6E
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:54 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-398-kdZ6Cl05Mjm7-pKz4vsVcw-1; Mon, 29 Nov 2021 05:39:52 -0500
X-MC-Unique: kdZ6Cl05Mjm7-pKz4vsVcw-1
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnx-0073Vh-3A; Mon, 29 Nov 2021 10:22:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Nov 2021 11:21:58 +0100
Message-Id: <20211129102203.2243509-25-hch@lst.de>
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 24/29] iomap: add a IOMAP_DAX flag
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a flag so that the file system can easily detect DAX operations
based just on the iomap operation requested instead of looking at
inode state using IS_DAX.  This will be needed to apply the to be
added partition offset only for operations that actually use DAX,
but not things like fiemap that are based on the block device.
In the long run it should also allow turning the bdev, dax_dev
and inline_data into a union.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c              | 7 ++++---
 fs/ext4/inode.c       | 4 ++--
 fs/xfs/xfs_iomap.c    | 7 ++++---
 fs/xfs/xfs_iomap.h    | 3 ++-
 fs/xfs/xfs_pnfs.c     | 2 +-
 include/linux/iomap.h | 5 +++++
 6 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 43d58b4219fd0..148e8b0967f35 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1180,7 +1180,7 @@ int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		.inode		= inode,
 		.pos		= pos,
 		.len		= len,
-		.flags		= IOMAP_ZERO,
+		.flags		= IOMAP_DAX | IOMAP_ZERO,
 	};
 	int ret;
 
@@ -1308,6 +1308,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		.inode		= iocb->ki_filp->f_mapping->host,
 		.pos		= iocb->ki_pos,
 		.len		= iov_iter_count(iter),
+		.flags		= IOMAP_DAX,
 	};
 	loff_t done = 0;
 	int ret;
@@ -1461,7 +1462,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		.inode		= mapping->host,
 		.pos		= (loff_t)vmf->pgoff << PAGE_SHIFT,
 		.len		= PAGE_SIZE,
-		.flags		= IOMAP_FAULT,
+		.flags		= IOMAP_DAX | IOMAP_FAULT,
 	};
 	vm_fault_t ret = 0;
 	void *entry;
@@ -1570,7 +1571,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	struct iomap_iter iter = {
 		.inode		= mapping->host,
 		.len		= PMD_SIZE,
-		.flags		= IOMAP_FAULT,
+		.flags		= IOMAP_DAX | IOMAP_FAULT,
 	};
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 	pgoff_t max_pgoff;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d316a2009489b..89c4a174bd393 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3349,8 +3349,8 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 	 * DAX and direct I/O are the only two operations that are currently
 	 * supported with IOMAP_WRITE.
 	 */
-	WARN_ON(!IS_DAX(inode) && !(flags & IOMAP_DIRECT));
-	if (IS_DAX(inode))
+	WARN_ON(!(flags & (IOMAP_DAX | IOMAP_DIRECT)));
+	if (flags & IOMAP_DAX)
 		m_flags = EXT4_GET_BLOCKS_CREATE_ZERO;
 	/*
 	 * We use i_size instead of i_disksize here because delalloc writeback
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d6beb1502f8bc..0ed3e7674353b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -188,6 +188,7 @@ xfs_iomap_write_direct(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_fileoff_t		count_fsb,
+	unsigned int		flags,
 	struct xfs_bmbt_irec	*imap)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -229,7 +230,7 @@ xfs_iomap_write_direct(
 	 * the reserve block pool for bmbt block allocation if there is no space
 	 * left but we need to do unwritten extent conversion.
 	 */
-	if (IS_DAX(VFS_I(ip))) {
+	if (flags & IOMAP_DAX) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			force = true;
@@ -620,7 +621,7 @@ imap_needs_alloc(
 	    imap->br_startblock == DELAYSTARTBLOCK)
 		return true;
 	/* we convert unwritten extents before copying the data for DAX */
-	if (IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN)
+	if ((flags & IOMAP_DAX) && imap->br_state == XFS_EXT_UNWRITTEN)
 		return true;
 	return false;
 }
@@ -826,7 +827,7 @@ xfs_direct_write_iomap_begin(
 	xfs_iunlock(ip, lockmode);
 
 	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
-			&imap);
+			flags, &imap);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 657cc02290f22..e88dc162c785e 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -12,7 +12,8 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t count_fsb, struct xfs_bmbt_irec *imap);
+		xfs_fileoff_t count_fsb, unsigned int flags,
+		struct xfs_bmbt_irec *imap);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7ce1ea11fc3f3..d6334abbc0b3e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -155,7 +155,7 @@ xfs_fs_map_blocks(
 		xfs_iunlock(ip, lock_flags);
 
 		error = xfs_iomap_write_direct(ip, offset_fsb,
-				end_fsb - offset_fsb, &imap);
+				end_fsb - offset_fsb, 0, &imap);
 		if (error)
 			goto out_unlock;
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6d1b08d0ae930..5b9432f9f79eb 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -141,6 +141,11 @@ struct iomap_page_ops {
 #define IOMAP_NOWAIT		(1 << 5) /* do not block */
 #define IOMAP_OVERWRITE_ONLY	(1 << 6) /* only pure overwrites allowed */
 #define IOMAP_UNSHARE		(1 << 7) /* unshare_file_range */
+#ifdef CONFIG_FS_DAX
+#define IOMAP_DAX		(1 << 8) /* DAX mapping */
+#else
+#define IOMAP_DAX		0
+#endif /* CONFIG_FS_DAX */
 
 struct iomap_ops {
 	/*
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

