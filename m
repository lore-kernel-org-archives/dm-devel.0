Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86E2C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-bZvdE2yDPIeDV2_gwrWXyw-1; Mon, 29 Nov 2021 01:56:30 -0500
X-MC-Unique: bZvdE2yDPIeDV2_gwrWXyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 975612F21;
	Mon, 29 Nov 2021 06:56:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3375D6D7;
	Mon, 29 Nov 2021 06:56:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5749C4A7C8;
	Mon, 29 Nov 2021 06:56:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AS5rV8P027074 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 00:53:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1837F40CFD13; Sun, 28 Nov 2021 05:53:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 134FF40CFD0A
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF75B8007B1
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:30 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-376-W2ogIjfxNAK_48GY3Cn3vA-1; Sun, 28 Nov 2021 00:53:28 -0500
X-MC-Unique: W2ogIjfxNAK_48GY3Cn3vA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EDD51FD36;
	Sun, 28 Nov 2021 05:53:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6693413446;
	Sun, 28 Nov 2021 05:53:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id WHPHDVYZo2G7fAAAMHmgww
	(envelope-from <wqu@suse.com>); Sun, 28 Nov 2021 05:53:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 28 Nov 2021 13:52:54 +0800
Message-Id: <20211128055259.39249-7-wqu@suse.com>
In-Reply-To: <20211128055259.39249-1-wqu@suse.com>
References: <20211128055259.39249-1-wqu@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AS5rV8P027074
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:53 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH RFC 06/11] btrfs: make end_bio_extent_readpage()
	to handle split bio properly
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This involves the following modifications:

- Use bio_for_each_segment() instead of bio_for_each_segment_all()
  bio_for_each_segment_all() will iterate all bvecs, even if they are
  not referred by current bi_iter.

  *_all() variant can only be used if the bio is never split.

  Change it to bio_for_each_segment() call so we won't have endio called
  on the same range by both split and parent bios.

- Make check_data_csum() to take bbio->offset_to_original into
  consideration
  Since btrfs bio can be split now, split/original bio can all start
  with some offset to the original logical bytenr.

  Take btrfs_bio::offset_to_original into consideration to get correct
  checksum offset.

- Remove the BIO_CLONED ASSERT() in submit_read_repair()

For metadata path, there is no change as they only rely on file offset,
doesn't care about btrfs_bio at all.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 34 +++++++++++++++++++---------------
 fs/btrfs/inode.c     | 23 +++++++++++++++++++++--
 fs/btrfs/volumes.h   |  3 ++-
 3 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 34195891b0b5..67965faeef47 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2735,10 +2735,9 @@ static blk_status_t submit_read_repair(struct inode *inode,
 	ASSERT(error_bitmap);
 
 	/*
-	 * We only get called on buffered IO, thus page must be mapped and bio
-	 * must not be cloned.
-	 */
-	ASSERT(page->mapping && !bio_flagged(failed_bio, BIO_CLONED));
+	 * We only get called on buffered IO, thus page must be mapped
+	*/
+	ASSERT(page->mapping);
 
 	/* Iterate through all the sectors in the range */
 	for (i = 0; i < nr_bits; i++) {
@@ -2992,7 +2991,8 @@ static struct extent_buffer *find_extent_buffer_readpage(
  */
 static void end_bio_extent_readpage(struct bio *bio)
 {
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
 	struct btrfs_bio *bbio = btrfs_bio(bio);
 	struct extent_io_tree *tree, *failure_tree;
 	struct processed_extent processed = { 0 };
@@ -3003,11 +3003,15 @@ static void end_bio_extent_readpage(struct bio *bio)
 	u32 bio_offset = 0;
 	int mirror;
 	int ret;
-	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bvec, bio, iter_all) {
+	/*
+	 * We should have saved the orignal bi_iter, and then start iterating
+	 * using that saved iter, as at endio time bi_iter is not reliable.
+	 */
+	ASSERT(bbio->iter.bi_size);
+	__bio_for_each_segment(bvec, bio, iter, bbio->iter) {
 		bool uptodate = !bio->bi_status;
-		struct page *page = bvec->bv_page;
+		struct page *page = bvec.bv_page;
 		struct inode *inode = page->mapping->host;
 		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 		const u32 sectorsize = fs_info->sectorsize;
@@ -3030,19 +3034,19 @@ static void end_bio_extent_readpage(struct bio *bio)
 		 * for unaligned offsets, and an error if they don't add up to
 		 * a full sector.
 		 */
-		if (!IS_ALIGNED(bvec->bv_offset, sectorsize))
+		if (!IS_ALIGNED(bvec.bv_offset, sectorsize))
 			btrfs_err(fs_info,
 		"partial page read in btrfs with offset %u and length %u",
-				  bvec->bv_offset, bvec->bv_len);
-		else if (!IS_ALIGNED(bvec->bv_offset + bvec->bv_len,
+				  bvec.bv_offset, bvec.bv_len);
+		else if (!IS_ALIGNED(bvec.bv_offset + bvec.bv_len,
 				     sectorsize))
 			btrfs_info(fs_info,
 		"incomplete page read with offset %u and length %u",
-				   bvec->bv_offset, bvec->bv_len);
+				   bvec.bv_offset, bvec.bv_len);
 
-		start = page_offset(page) + bvec->bv_offset;
-		end = start + bvec->bv_len - 1;
-		len = bvec->bv_len;
+		start = page_offset(page) + bvec.bv_offset;
+		end = start + bvec.bv_len - 1;
+		len = bvec.bv_len;
 
 		mirror = bbio->mirror_num;
 		if (likely(uptodate)) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e6901aeeb89..1bf56c2b4bd9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3220,6 +3220,24 @@ void btrfs_writepage_endio_finish_ordered(struct btrfs_inode *inode,
 				       finish_ordered_fn, uptodate);
 }
 
+static u8 *bbio_get_real_csum(struct btrfs_fs_info *fs_info,
+			      struct btrfs_bio *bbio)
+{
+	u8 *ret;
+
+	/* Split bbio needs to grab csum from its parent */
+	if (bbio->is_split_bio)
+		ret = btrfs_bio(bbio->parent)->csum;
+	else
+		ret = bbio->csum;
+
+	if (ret == NULL)
+		return ret;
+
+	return ret + (bbio->offset_to_original >> fs_info->sectorsize_bits) *
+		     fs_info->csum_size;
+}
+
 /*
  * check_data_csum - verify checksum of one sector of uncompressed data
  * @inode:	inode
@@ -3247,7 +3265,8 @@ static int check_data_csum(struct inode *inode, struct btrfs_bio *bbio,
 	ASSERT(pgoff + len <= PAGE_SIZE);
 
 	offset_sectors = bio_offset >> fs_info->sectorsize_bits;
-	csum_expected = ((u8 *)bbio->csum) + offset_sectors * csum_size;
+	csum_expected = bbio_get_real_csum(fs_info, bbio) +
+			offset_sectors * csum_size;
 
 	kaddr = kmap_atomic(page);
 	shash->tfm = fs_info->csum_shash;
@@ -3305,7 +3324,7 @@ unsigned int btrfs_verify_data_csum(struct btrfs_bio *bbio,
 	 * Normally this should be covered by above check for compressed read
 	 * or the next check for NODATASUM.  Just do a quicker exit here.
 	 */
-	if (bbio->csum == NULL)
+	if (bbio_get_real_csum(fs_info, bbio) == NULL)
 		return 0;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index baccf895a544..38028926c679 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -401,7 +401,8 @@ static inline struct btrfs_bio *btrfs_bio(struct bio *bio)
 
 static inline void btrfs_bio_free_csum(struct btrfs_bio *bbio)
 {
-	if (bbio->csum != bbio->csum_inline) {
+	/* Only free the csum if we're not a split bio */
+	if (!bbio->is_split_bio && bbio->csum != bbio->csum_inline) {
 		kfree(bbio->csum);
 		bbio->csum = NULL;
 	}
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

