Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3404AC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF87A61057
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF87A61057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-EJNlc33wOaqDwd-jznFAKA-1; Tue, 09 Nov 2021 04:00:38 -0500
X-MC-Unique: EJNlc33wOaqDwd-jznFAKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E484E1023F53;
	Tue,  9 Nov 2021 09:00:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB53E1048102;
	Tue,  9 Nov 2021 09:00:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 777994EA37;
	Tue,  9 Nov 2021 09:00:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A98xX4i017425 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 03:59:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFEFF40CFD10; Tue,  9 Nov 2021 08:59:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB48C40CFD02
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D1E4801212
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-361-j4et8X9NO5CUREAfA-SsWw-1; Tue, 09 Nov 2021 03:59:32 -0500
X-MC-Unique: j4et8X9NO5CUREAfA-SsWw-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZd-000s62-5h; Tue, 09 Nov 2021 08:33:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:58 +0100
Message-Id: <20211109083309.584081-19-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 18/29] fsdax: decouple zeroing from the iomap
	buffered I/O code
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Unshare the DAX and iomap buffered I/O page zeroing code.  This code
previously did a IS_DAX check deep inside the iomap code, which in
fact was the only DAX check in the code.  Instead move these checks
into the callers.  Most callers already have DAX special casing anyway
and XFS will need it for reflink support as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c               | 77 ++++++++++++++++++++++++++++++++++--------
 fs/ext2/inode.c        |  6 ++--
 fs/ext4/inode.c        |  4 +--
 fs/iomap/buffered-io.c | 35 +++++++------------
 fs/xfs/xfs_iomap.c     |  6 ++++
 include/linux/dax.h    |  6 +++-
 6 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index dc9ebeff850ab..5b52b878124ac 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1135,24 +1135,73 @@ static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
 	return rc;
 }
 
-s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
+static loff_t dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
-	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	long rc, id;
-	unsigned offset = offset_in_page(pos);
-	unsigned size = min_t(u64, PAGE_SIZE - offset, length);
+	const struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	loff_t written = 0;
+
+	/* already zeroed?  we're done. */
+	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+		return length;
+
+	do {
+		unsigned offset = offset_in_page(pos);
+		unsigned size = min_t(u64, PAGE_SIZE - offset, length);
+		pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
+		long rc;
+		int id;
 
-	id = dax_read_lock();
-	if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
-		rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
-	else
-		rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
-	dax_read_unlock(id);
+		id = dax_read_lock();
+		if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
+			rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
+		else
+			rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
+		dax_read_unlock(id);
 
-	if (rc < 0)
-		return rc;
-	return size;
+		if (rc < 0)
+			return rc;
+		pos += size;
+		length -= size;
+		written += size;
+		if (did_zero)
+			*did_zero = true;
+	} while (length > 0);
+
+	return written;
+}
+
+int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
+		const struct iomap_ops *ops)
+{
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_ZERO,
+	};
+	int ret;
+
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = dax_zero_iter(&iter, did_zero);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_zero_range);
+
+int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
+		const struct iomap_ops *ops)
+{
+	unsigned int blocksize = i_blocksize(inode);
+	unsigned int off = pos & (blocksize - 1);
+
+	/* Block boundary? Nothing to do */
+	if (!off)
+		return 0;
+	return dax_zero_range(inode, pos, blocksize - off, did_zero, ops);
 }
+EXPORT_SYMBOL_GPL(dax_truncate_page);
 
 static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		struct iov_iter *iter)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 333fa62661d56..ae9993018a015 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1297,9 +1297,9 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	inode_dio_wait(inode);
 
 	if (IS_DAX(inode)) {
-		error = iomap_zero_range(inode, newsize,
-					 PAGE_ALIGN(newsize) - newsize, NULL,
-					 &ext2_iomap_ops);
+		error = dax_zero_range(inode, newsize,
+				       PAGE_ALIGN(newsize) - newsize, NULL,
+				       &ext2_iomap_ops);
 	} else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
 				newsize, ext2_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0f06305167d5a..8c443b753b815 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3783,8 +3783,8 @@ static int ext4_block_zero_page_range(handle_t *handle,
 		length = max;
 
 	if (IS_DAX(inode)) {
-		return iomap_zero_range(inode, from, length, NULL,
-					&ext4_iomap_ops);
+		return dax_zero_range(inode, from, length, NULL,
+				      &ext4_iomap_ops);
 	}
 	return __ext4_block_zero_page_range(handle, mapping, from, length);
 }
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1753c26c8e76e..b1511255b4df8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -870,26 +870,8 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 }
 EXPORT_SYMBOL_GPL(iomap_file_unshare);
 
-static s64 __iomap_zero_iter(struct iomap_iter *iter, loff_t pos, u64 length)
-{
-	struct page *page;
-	int status;
-	unsigned offset = offset_in_page(pos);
-	unsigned bytes = min_t(u64, PAGE_SIZE - offset, length);
-
-	status = iomap_write_begin(iter, pos, bytes, &page);
-	if (status)
-		return status;
-
-	zero_user(page, offset, bytes);
-	mark_page_accessed(page);
-
-	return iomap_write_end(iter, pos, bytes, bytes, page);
-}
-
 static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
-	struct iomap *iomap = &iter->iomap;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
@@ -900,12 +882,19 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		return length;
 
 	do {
-		s64 bytes;
+		unsigned offset = offset_in_page(pos);
+		size_t bytes = min_t(u64, PAGE_SIZE - offset, length);
+		struct page *page;
+		int status;
 
-		if (IS_DAX(iter->inode))
-			bytes = dax_iomap_zero(pos, length, iomap);
-		else
-			bytes = __iomap_zero_iter(iter, pos, length);
+		status = iomap_write_begin(iter, pos, bytes, &page);
+		if (status)
+			return status;
+
+		zero_user(page, offset, bytes);
+		mark_page_accessed(page);
+
+		bytes = iomap_write_end(iter, pos, bytes, bytes, page);
 		if (bytes < 0)
 			return bytes;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d6d71ae9f2ae4..604000b6243ec 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1321,6 +1321,9 @@ xfs_zero_range(
 {
 	struct inode		*inode = VFS_I(ip);
 
+	if (IS_DAX(inode))
+		return dax_zero_range(inode, pos, len, did_zero,
+				      &xfs_buffered_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
 				&xfs_buffered_write_iomap_ops);
 }
@@ -1333,6 +1336,9 @@ xfs_truncate_page(
 {
 	struct inode		*inode = VFS_I(ip);
 
+	if (IS_DAX(inode))
+		return dax_truncate_page(inode, pos, did_zero,
+					&xfs_buffered_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
 				   &xfs_buffered_write_iomap_ops);
 }
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 324363b798ecd..a5cc2f1aa840e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -14,6 +14,7 @@ typedef unsigned long dax_entry_t;
 struct dax_device;
 struct gendisk;
 struct iomap_ops;
+struct iomap_iter;
 struct iomap;
 
 struct dax_operations {
@@ -124,6 +125,10 @@ struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
+int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
+		const struct iomap_ops *ops);
+int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
+		const struct iomap_ops *ops);
 #else
 static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
 {
@@ -204,7 +209,6 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
-s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap);
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

