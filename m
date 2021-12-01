Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79884C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-ln_R8UhSPAK8cU57To1gNg-1; Wed, 01 Dec 2021 02:48:43 -0500
X-MC-Unique: ln_R8UhSPAK8cU57To1gNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A91FC760CA;
	Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C5035D6CF;
	Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 67EA01802FEB;
	Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IdsK008859 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B164492CA3; Wed,  1 Dec 2021 05:18:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86028492C3B
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20DE7185A7B2
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-438-aANUZuouO3GLY82zg2_OLg-1; Wed, 01 Dec 2021 00:18:37 -0500
X-MC-Unique: aANUZuouO3GLY82zg2_OLg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2761212BA;
	Wed,  1 Dec 2021 05:18:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A773B13425;
	Wed,  1 Dec 2021 05:18:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id WEKEHasFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:55 +0800
Message-Id: <20211201051756.53742-17-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IdsK008859
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 16/17] btrfs: remove the stripe boundary
	calculation for direct IO
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

In btrfs_submit_direct() we have a do {} while () loop to handle the bio
split due to stripe boundary.

Since btrfs_map_bio() can handle it for us now, there is no need to
manually do the split anymore.

Also since we don't need to split bio, there is no special check for
RAID56 anymore, make btrfs_submit_dio_bio() to have the same rule as
btrfs_submit_data_bio() for async submit.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 113 ++++++++++-------------------------------------
 1 file changed, 24 insertions(+), 89 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 186304c69900..8ffec0fe6c4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8222,22 +8222,16 @@ static void btrfs_end_dio_bio(struct bio *bio)
 }
 
 static inline blk_status_t btrfs_submit_dio_bio(struct bio *bio,
-		struct inode *inode, u64 file_offset, int async_submit)
+		struct inode *inode, u64 file_offset)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_dio_private *dip = bio->bi_private;
 	bool write = btrfs_op(bio) == BTRFS_MAP_WRITE;
+	bool async_submit;
 	blk_status_t ret;
 
-	/*
-	 * Check btrfs_submit_data_bio() for rules about async submit.
-	 *
-	 * The only exception is for RAID56, when there are more than one bios
-	 * to submit, async submit seems to make it harder to collect csums
-	 * for the full stripe.
-	 */
-	if (async_submit)
-		async_submit = !atomic_read(&BTRFS_I(inode)->sync_writers);
+	/* Check btrfs_submit_data_bio() for rules about async submit. */
+	async_submit = !atomic_read(&BTRFS_I(inode)->sync_writers);
 
 	if (!write)
 		btrfs_bio(bio)->endio_type = BTRFS_WQ_ENDIO_DATA;
@@ -8311,25 +8305,12 @@ static void btrfs_submit_direct(const struct iomap_iter *iter,
 		struct bio *dio_bio, loff_t file_offset)
 {
 	struct inode *inode = iter->inode;
+	struct btrfs_dio_data *dio_data = iter->iomap.private;
 	const bool write = (btrfs_op(dio_bio) == BTRFS_MAP_WRITE);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	const bool raid56 = (btrfs_data_alloc_profile(fs_info) &
-			     BTRFS_BLOCK_GROUP_RAID56_MASK);
 	struct btrfs_dio_private *dip;
 	struct bio *bio;
 	const u32 length = dio_bio->bi_iter.bi_size;
-	u32 submitted_bytes = 0;
-	u64 start_sector;
-	int async_submit = 0;
-	u64 submit_len;
-	u64 clone_offset = 0;
-	u64 clone_len;
-	u64 logical;
-	int ret;
 	blk_status_t status;
-	struct btrfs_io_geometry geom;
-	struct btrfs_dio_data *dio_data = iter->iomap.private;
-	struct extent_map *em = NULL;
 
 	dip = btrfs_create_dio_private(dio_bio, inode, file_offset, length);
 	if (!dip) {
@@ -8353,80 +8334,34 @@ static void btrfs_submit_direct(const struct iomap_iter *iter,
 			goto out_err;
 	}
 
-	start_sector = dio_bio->bi_iter.bi_sector;
-	submit_len = dio_bio->bi_iter.bi_size;
-
-	do {
-		logical = start_sector << 9;
-		em = btrfs_get_chunk_map(fs_info, logical, submit_len);
-		if (IS_ERR(em)) {
-			status = errno_to_blk_status(PTR_ERR(em));
-			em = NULL;
-			goto out_err_em;
-		}
-		ret = btrfs_get_io_geometry(fs_info, em, btrfs_op(dio_bio),
-					    logical, &geom);
-		if (ret) {
-			status = errno_to_blk_status(ret);
-			goto out_err_em;
-		}
-
-		clone_len = min(submit_len, geom.len);
-		ASSERT(clone_len <= UINT_MAX);
-
-		/*
-		 * This will never fail as it's passing GPF_NOFS and
-		 * the allocation is backed by btrfs_bioset.
-		 */
-		bio = btrfs_bio_clone_partial(dio_bio, clone_offset, clone_len);
-		bio->bi_private = dip;
-		bio->bi_end_io = btrfs_end_dio_bio;
-
-		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-			status = extract_ordered_extent(BTRFS_I(inode), bio,
-							file_offset);
-			if (status) {
-				bio_put(bio);
-				goto out_err;
-			}
-		}
-
-		ASSERT(submit_len >= clone_len);
-		submit_len -= clone_len;
+	/*
+	 * This will never fail as it's passing GPF_NOFS and
+	 * the allocation is backed by btrfs_bioset.
+	 */
+	bio = btrfs_bio_clone(dio_bio);
+	bio->bi_private = dip;
+	bio->bi_end_io = btrfs_end_dio_bio;
 
-		if (submit_len > 0) {
-			/*
-			 * If we are submitting more than one bio, submit them
-			 * all asynchronously. The exception is RAID 5 or 6, as
-			 * asynchronous checksums make it difficult to collect
-			 * full stripe writes.
-			 */
-			if (!raid56)
-				async_submit = 1;
-		}
 
-		status = btrfs_submit_dio_bio(bio, inode, file_offset,
-						async_submit);
+	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+		status = extract_ordered_extent(BTRFS_I(inode), bio,
+						file_offset);
 		if (status) {
 			bio_put(bio);
-			goto out_err_em;
+			goto out_err;
 		}
-
-		submitted_bytes += clone_len;
-		dio_data->submitted += clone_len;
-		clone_offset += clone_len;
-		start_sector += clone_len >> 9;
-		file_offset += clone_len;
-
-		free_extent_map(em);
-	} while (submit_len > 0);
+	}
+	status = btrfs_submit_dio_bio(bio, inode, file_offset);
+	if (status) {
+		bio_put(bio);
+		goto out_err;
+	}
+	dio_data->submitted += length;
 	return;
 
-out_err_em:
-	free_extent_map(em);
 out_err:
 	dip->dio_bio->bi_status = status;
-	dio_private_finish(dip, status, length - submitted_bytes);
+	dio_private_finish(dip, status, length);
 }
 
 const struct iomap_ops btrfs_dio_iomap_ops = {
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

