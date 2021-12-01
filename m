Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECF1C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-535--v6KLKMbPQqdhwdG9ERx1A-1; Wed, 01 Dec 2021 02:48:33 -0500
X-MC-Unique: -v6KLKMbPQqdhwdG9ERx1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47213760EA;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D4286060F;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08DCF180BAD1;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IOU4008762 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5D7604047279; Wed,  1 Dec 2021 05:18:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 596B54047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42FED185A7B2
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-306-59P9tQ_ZOxeFT-BAUCEZgg-1; Wed, 01 Dec 2021 00:18:22 -0500
X-MC-Unique: 59P9tQ_ZOxeFT-BAUCEZgg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDCDB1FD58;
	Wed,  1 Dec 2021 05:18:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D23F413425;
	Wed,  1 Dec 2021 05:18:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sFzaJ5wFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:44 +0800
Message-Id: <20211201051756.53742-6-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IOU4008762
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 05/17] btrfs: move btrfs_bio_wq_end_io() calls
	into submit_stripe_bio()
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

This is a preparation patch for the incoming chunk mapping layer bio
split.

Function btrfs_bio_wq_end_io() is going to remap bio::bi_private and
bio::bi_end_io so that the real endio function will be executed in a
workqueue.

The problem is, remapped bio::bi_private will be a newly allocated
memory, and after the original endio executed, the memory will be freed.

This will not work well with split bio.

So this patch will move all btrfs_bio_wq_end_io() call into one helper
function, btrfs_bio_final_endio_remap(), and call that helper in
submit_stripe_bio().

This refactor also unified all data bio behaviors.

Before this patch, compressed bio no matter if read or write, will
always be delayed using workqueue.

However all data write operations are already delayed using ordered
extent, and all metadata write doesn't need any delayed execution.

Thus this patch will make compressed bios follow the same data
read/write behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c |  4 +---
 fs/btrfs/disk-io.c     |  9 +--------
 fs/btrfs/inode.c       | 20 +++++---------------
 fs/btrfs/volumes.c     | 41 +++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.h     |  9 ++++++++-
 5 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index cc8d13369f53..8668c5190805 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -429,10 +429,8 @@ static blk_status_t submit_compressed_bio(struct btrfs_fs_info *fs_info,
 {
 	blk_status_t ret;
 
+	btrfs_bio(bio)->endio_type = BTRFS_WQ_ENDIO_DATA;
 	ASSERT(bio->bi_iter.bi_size);
-	ret = btrfs_bio_wq_end_io(fs_info, bio, BTRFS_WQ_ENDIO_DATA);
-	if (ret)
-		return ret;
 	ret = btrfs_map_bio(fs_info, bio, mirror_num);
 	return ret;
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5c598e124c25..ce7c5a16df04 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -920,14 +920,7 @@ blk_status_t btrfs_submit_metadata_bio(struct inode *inode, struct bio *bio,
 	blk_status_t ret;
 
 	if (btrfs_op(bio) != BTRFS_MAP_WRITE) {
-		/*
-		 * called for a read, do the setup so that checksum validation
-		 * can happen in the async kernel threads
-		 */
-		ret = btrfs_bio_wq_end_io(fs_info, bio,
-					  BTRFS_WQ_ENDIO_METADATA);
-		if (ret)
-			goto out_w_error;
+		btrfs_bio(bio)->endio_type = BTRFS_WQ_ENDIO_METADATA;
 		ret = btrfs_map_bio(fs_info, bio, mirror_num);
 	} else if (!should_async_write(fs_info, BTRFS_I(inode))) {
 		ret = btree_csum_one_bio(bio);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 126d2117954c..007a20a9b076 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2511,7 +2511,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	enum btrfs_wq_endio_type metadata = BTRFS_WQ_ENDIO_DATA;
+	enum btrfs_wq_endio_type endio_type = BTRFS_WQ_ENDIO_DATA;
 	blk_status_t ret = 0;
 	int skip_sum;
 	int async = !atomic_read(&BTRFS_I(inode)->sync_writers);
@@ -2520,7 +2520,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 		test_bit(BTRFS_FS_STATE_NO_CSUMS, &fs_info->fs_state);
 
 	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
-		metadata = BTRFS_WQ_ENDIO_FREE_SPACE;
+		endio_type = BTRFS_WQ_ENDIO_FREE_SPACE;
 
 	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
 		struct page *page = bio_first_bvec_all(bio)->bv_page;
@@ -2532,10 +2532,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 	}
 
 	if (btrfs_op(bio) != BTRFS_MAP_WRITE) {
-		ret = btrfs_bio_wq_end_io(fs_info, bio, metadata);
-		if (ret)
-			goto out;
-
+		btrfs_bio(bio)->endio_type = endio_type;
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
 			ret = btrfs_submit_compressed_read(inode, bio,
 							   mirror_num,
@@ -8090,10 +8087,6 @@ static blk_status_t submit_dio_repair_bio(struct inode *inode, struct bio *bio,
 
 	BUG_ON(bio_op(bio) == REQ_OP_WRITE);
 
-	ret = btrfs_bio_wq_end_io(fs_info, bio, BTRFS_WQ_ENDIO_DATA);
-	if (ret)
-		return ret;
-
 	refcount_inc(&dip->refs);
 	ret = btrfs_map_bio(fs_info, bio, mirror_num);
 	if (ret)
@@ -8219,11 +8212,8 @@ static inline blk_status_t btrfs_submit_dio_bio(struct bio *bio,
 	if (async_submit)
 		async_submit = !atomic_read(&BTRFS_I(inode)->sync_writers);
 
-	if (!write) {
-		ret = btrfs_bio_wq_end_io(fs_info, bio, BTRFS_WQ_ENDIO_DATA);
-		if (ret)
-			goto err;
-	}
+	if (!write)
+		btrfs_bio(bio)->endio_type = BTRFS_WQ_ENDIO_DATA;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		goto map;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3dc759996f55..af01d54502ab 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6725,10 +6725,31 @@ static void btrfs_end_bio(struct bio *bio)
 	}
 }
 
-static void submit_stripe_bio(struct btrfs_io_context *bioc, struct bio *bio,
-			      u64 physical, struct btrfs_device *dev)
+/*
+ * Endio remaps which can't handle cloned bio needs to go here.
+ *
+ * Currently it's only btrfs_bio_wq_end_io().
+ */
+static int btrfs_bio_final_endio_remap(struct btrfs_fs_info *fs_info,
+				       struct bio *bio)
+{
+	blk_status_t sts;
+
+	/* For write bio, we don't to put their endio into wq */
+	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
+		return 0;
+
+	sts = btrfs_bio_wq_end_io(fs_info, bio, btrfs_bio(bio)->endio_type);
+	if (sts != BLK_STS_OK)
+		return blk_status_to_errno(sts);
+	return 0;
+}
+
+static int submit_stripe_bio(struct btrfs_io_context *bioc, struct bio *bio,
+			     u64 physical, struct btrfs_device *dev)
 {
 	struct btrfs_fs_info *fs_info = bioc->fs_info;
+	int ret;
 
 	bio->bi_private = bioc;
 	btrfs_bio(bio)->device = dev;
@@ -6755,9 +6776,14 @@ static void submit_stripe_bio(struct btrfs_io_context *bioc, struct bio *bio,
 		dev->devid, bio->bi_iter.bi_size);
 	bio_set_dev(bio, dev->bdev);
 
-	btrfs_bio_counter_inc_noblocked(fs_info);
+	/* Do the final endio remap if needed */
+	ret = btrfs_bio_final_endio_remap(fs_info, bio);
+	if (ret < 0)
+		return ret;
 
+	btrfs_bio_counter_inc_noblocked(fs_info);
 	btrfsic_submit_bio(bio);
+	return ret;
 }
 
 static void bioc_error(struct btrfs_io_context *bioc, struct bio *bio, u64 logical)
@@ -6845,9 +6871,16 @@ static int submit_one_mapped_range(struct btrfs_fs_info *fs_info, struct bio *bi
 		else
 			bio = first_bio;
 
-		submit_stripe_bio(bioc, bio, bioc->stripes[dev_nr].physical, dev);
+		ret = submit_stripe_bio(bioc, bio,
+					bioc->stripes[dev_nr].physical, dev);
+		if (ret < 0)
+			goto error;
 	}
 	return 0;
+error:
+	for (; dev_nr < total_devs; dev_nr++)
+		bioc_error(bioc, first_bio, logical);
+	return ret;
 }
 
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f9178d2c2fd6..f88f39042558 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -328,7 +328,14 @@ struct btrfs_fs_devices {
  * Mostly for btrfs specific features like csum and mirror_num.
  */
 struct btrfs_bio {
-	unsigned int mirror_num;
+	u16 mirror_num;
+
+	/*
+	 * To tell which workqueue the bio's endio should be exeucted in.
+	 *
+	 * Only for read bios.
+	 */
+	u16 endio_type;
 
 	/* @device is for stripe IO submission. */
 	struct btrfs_device *device;
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

