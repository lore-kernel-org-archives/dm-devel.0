Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDEEC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-QLtG2t-ZNQCCmXNhVxCviA-1; Mon, 29 Nov 2021 01:56:46 -0500
X-MC-Unique: QLtG2t-ZNQCCmXNhVxCviA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9984B102CC43;
	Mon, 29 Nov 2021 06:56:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FEF55D9C0;
	Mon, 29 Nov 2021 06:56:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BD614A70A;
	Mon, 29 Nov 2021 06:56:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AS5rbar027106 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 00:53:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 35E7B1121319; Sun, 28 Nov 2021 05:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3133C1121315
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59B80801212
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:34 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-29-usymYJlXPhOyKned6OluMQ-1; Sun, 28 Nov 2021 00:53:32 -0500
X-MC-Unique: usymYJlXPhOyKned6OluMQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 54FF61FD45;
	Sun, 28 Nov 2021 05:53:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F2DA13446;
	Sun, 28 Nov 2021 05:53:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id ONQeDFoZo2G7fAAAMHmgww
	(envelope-from <wqu@suse.com>); Sun, 28 Nov 2021 05:53:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 28 Nov 2021 13:52:57 +0800
Message-Id: <20211128055259.39249-10-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AS5rbar027106
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:53 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH RFC 09/11] btrfs: remove bio split operations in
	btrfs_submit_direct()
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

Since btrfs_map_bio() will handle the split, there is no need to do the
split in btrfs_submit_direct() anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 116 +++++++++--------------------------------------
 1 file changed, 22 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bf56c2b4bd9..24c8bb6d8543 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8202,22 +8202,16 @@ static void btrfs_end_dio_bio(struct bio *bio)
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
@@ -8291,20 +8285,9 @@ static void btrfs_submit_direct(const struct iomap_iter *iter,
 {
 	struct inode *inode = iter->inode;
 	const bool write = (btrfs_op(dio_bio) == BTRFS_MAP_WRITE);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	const bool raid56 = (btrfs_data_alloc_profile(fs_info) &
-			     BTRFS_BLOCK_GROUP_RAID56_MASK);
 	struct btrfs_dio_private *dip;
 	struct bio *bio;
-	u64 start_sector;
-	int async_submit = 0;
-	u64 submit_len;
-	u64 clone_offset = 0;
-	u64 clone_len;
-	u64 logical;
-	int ret;
 	blk_status_t status;
-	struct btrfs_io_geometry geom;
 	struct btrfs_dio_data *dio_data = iter->iomap.private;
 	struct extent_map *em = NULL;
 
@@ -8331,84 +8314,29 @@ static void btrfs_submit_direct(const struct iomap_iter *iter,
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
-
-		/*
-		 * Increase the count before we submit the bio so we know
-		 * the end IO handler won't happen before we increase the
-		 * count. Otherwise, the dip might get freed before we're
-		 * done setting it up.
-		 *
-		 * We transfer the initial reference to the last bio, so we
-		 * don't need to increment the reference count for the last one.
-		 */
-		if (submit_len > 0) {
-			refcount_inc(&dip->refs);
-			/*
-			 * If we are submitting more than one bio, submit them
-			 * all asynchronously. The exception is RAID 5 or 6, as
-			 * asynchronous checksums make it difficult to collect
-			 * full stripe writes.
-			 */
-			if (!raid56)
-				async_submit = 1;
-		}
+	/*
+	 * This will never fail as it's passing GPF_NOFS and
+	 * the allocation is backed by btrfs_bioset.
+	 */
+	bio = btrfs_bio_clone(dio_bio);
+	bio->bi_private = dip;
+	bio->bi_end_io = btrfs_end_dio_bio;
 
-		status = btrfs_submit_dio_bio(bio, inode, file_offset,
-						async_submit);
+	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+		status = extract_ordered_extent(BTRFS_I(inode), bio,
+						file_offset);
 		if (status) {
 			bio_put(bio);
-			if (submit_len > 0)
-				refcount_dec(&dip->refs);
-			goto out_err_em;
+			goto out_err;
 		}
+	}
 
-		dio_data->submitted += clone_len;
-		clone_offset += clone_len;
-		start_sector += clone_len >> 9;
-		file_offset += clone_len;
-
-		free_extent_map(em);
-	} while (submit_len > 0);
+	status = btrfs_submit_dio_bio(bio, inode, file_offset);
+	if (status) {
+		bio_put(bio);
+		goto out_err_em;
+	}
+	dio_data->submitted += dio_bio->bi_iter.bi_size;
 	return;
 
 out_err_em:
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

