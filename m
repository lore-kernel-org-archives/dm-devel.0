Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F25AC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-0xHofVKJPQCGeKpso1lmdA-1; Wed, 01 Dec 2021 02:48:40 -0500
X-MC-Unique: 0xHofVKJPQCGeKpso1lmdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A57331023F52;
	Wed,  1 Dec 2021 07:48:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CE5B7095E;
	Wed,  1 Dec 2021 07:48:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 668A91802FE8;
	Wed,  1 Dec 2021 07:48:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15Icjn008848 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 08759C23DB5; Wed,  1 Dec 2021 05:18:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04A79C23DB2
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEFB4185A7B2
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-177-PaIVd-eQNnGkCEabhcVPNQ-1; Wed, 01 Dec 2021 00:18:36 -0500
X-MC-Unique: PaIVd-eQNnGkCEabhcVPNQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F3041FD58;
	Wed,  1 Dec 2021 05:18:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 537D713425;
	Wed,  1 Dec 2021 05:18:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0FL8CKoFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:54 +0800
Message-Id: <20211201051756.53742-16-wqu@suse.com>
In-Reply-To: <20211201051756.53742-1-wqu@suse.com>
References: <20211201051756.53742-1-wqu@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15Icjn008848
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 15/17] btrfs: remove stripe boundary calculation
	for compressed IO
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

For compressed IO, we calculate the next stripe start inside
alloc_compressed_bio().

Since now btrfs_map_bio() can handle bio split, we no longer need to
calculate the boundary any more.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 49 +++++-------------------------------------
 1 file changed, 5 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8b4b84b59b0c..70af7d3973b7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -442,21 +442,15 @@ static blk_status_t submit_compressed_bio(struct btrfs_fs_info *fs_info,
  *                      from or written to.
  * @endio_func:         The endio function to call after the IO for compressed data
  *                      is finished.
- * @next_stripe_start:  Return value of logical bytenr of where next stripe starts.
- *                      Let the caller know to only fill the bio up to the stripe
- *                      boundary.
  */
 
 
 static struct bio *alloc_compressed_bio(struct compressed_bio *cb, u64 disk_bytenr,
-					unsigned int opf, bio_end_io_t endio_func,
-					u64 *next_stripe_start)
+					unsigned int opf, bio_end_io_t endio_func)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(cb->inode->i_sb);
-	struct btrfs_io_geometry geom;
 	struct extent_map *em;
 	struct bio *bio;
-	int ret;
 
 	bio = btrfs_bio_alloc(BIO_MAX_VECS);
 
@@ -473,14 +467,7 @@ static struct bio *alloc_compressed_bio(struct compressed_bio *cb, u64 disk_byte
 
 	if (bio_op(bio) == REQ_OP_ZONE_APPEND)
 		bio_set_dev(bio, em->map_lookup->stripes[0].dev->bdev);
-
-	ret = btrfs_get_io_geometry(fs_info, em, btrfs_op(bio), disk_bytenr, &geom);
 	free_extent_map(em);
-	if (ret < 0) {
-		bio_put(bio);
-		return ERR_PTR(ret);
-	}
-	*next_stripe_start = disk_bytenr + geom.len;
 
 	return bio;
 }
@@ -506,7 +493,6 @@ blk_status_t btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 	struct bio *bio = NULL;
 	struct compressed_bio *cb;
 	u64 cur_disk_bytenr = disk_start;
-	u64 next_stripe_start;
 	blk_status_t ret;
 	int skip_sum = inode->flags & BTRFS_INODE_NODATASUM;
 	const bool use_append = btrfs_use_zone_append(inode, disk_start);
@@ -539,28 +525,19 @@ blk_status_t btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 		/* Allocate new bio if submitted or not yet allocated */
 		if (!bio) {
 			bio = alloc_compressed_bio(cb, cur_disk_bytenr,
-				bio_op | write_flags, end_compressed_bio_write,
-				&next_stripe_start);
+				bio_op | write_flags, end_compressed_bio_write);
 			if (IS_ERR(bio)) {
 				ret = errno_to_blk_status(PTR_ERR(bio));
 				bio = NULL;
 				goto finish_cb;
 			}
 		}
-		/*
-		 * We should never reach next_stripe_start start as we will
-		 * submit comp_bio when reach the boundary immediately.
-		 */
-		ASSERT(cur_disk_bytenr != next_stripe_start);
-
 		/*
 		 * We have various limits on the real read size:
-		 * - stripe boundary
 		 * - page boundary
 		 * - compressed length boundary
 		 */
-		real_size = min_t(u64, U32_MAX, next_stripe_start - cur_disk_bytenr);
-		real_size = min_t(u64, real_size, PAGE_SIZE - offset_in_page(offset));
+		real_size = min_t(u64, U32_MAX, PAGE_SIZE - offset_in_page(offset));
 		real_size = min_t(u64, real_size, compressed_len - offset);
 		ASSERT(IS_ALIGNED(real_size, fs_info->sectorsize));
 
@@ -575,9 +552,6 @@ blk_status_t btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 			submit = true;
 
 		cur_disk_bytenr += added;
-		/* Reached stripe boundary */
-		if (cur_disk_bytenr == next_stripe_start)
-			submit = true;
 
 		/* Finished the range */
 		if (cur_disk_bytenr == disk_start + compressed_len)
@@ -797,7 +771,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct bio *comp_bio = NULL;
 	const u64 disk_bytenr = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	u64 cur_disk_byte = disk_bytenr;
-	u64 next_stripe_start;
 	u64 file_offset;
 	u64 em_len;
 	u64 em_start;
@@ -878,27 +851,19 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		/* Allocate new bio if submitted or not yet allocated */
 		if (!comp_bio) {
 			comp_bio = alloc_compressed_bio(cb, cur_disk_byte,
-					REQ_OP_READ, end_compressed_bio_read,
-					&next_stripe_start);
+					REQ_OP_READ, end_compressed_bio_read);
 			if (IS_ERR(comp_bio)) {
 				ret = errno_to_blk_status(PTR_ERR(comp_bio));
 				comp_bio = NULL;
 				goto finish_cb;
 			}
 		}
-		/*
-		 * We should never reach next_stripe_start start as we will
-		 * submit comp_bio when reach the boundary immediately.
-		 */
-		ASSERT(cur_disk_byte != next_stripe_start);
 		/*
 		 * We have various limit on the real read size:
-		 * - stripe boundary
 		 * - page boundary
 		 * - compressed length boundary
 		 */
-		real_size = min_t(u64, U32_MAX, next_stripe_start - cur_disk_byte);
-		real_size = min_t(u64, real_size, PAGE_SIZE - offset_in_page(offset));
+		real_size = min_t(u64, U32_MAX, PAGE_SIZE - offset_in_page(offset));
 		real_size = min_t(u64, real_size, compressed_len - offset);
 		ASSERT(IS_ALIGNED(real_size, fs_info->sectorsize));
 
@@ -910,10 +875,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		ASSERT(added == real_size);
 		cur_disk_byte += added;
 
-		/* Reached stripe boundary, need to submit */
-		if (cur_disk_byte == next_stripe_start)
-			submit = true;
-
 		/* Has finished the range, need to submit */
 		if (cur_disk_byte == disk_bytenr + compressed_len)
 			submit = true;
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

