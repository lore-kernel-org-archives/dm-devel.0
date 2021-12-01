Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4E8C4321E
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-9q88T_GaPaOOdmRE9w6BWg-1; Wed, 01 Dec 2021 02:48:33 -0500
X-MC-Unique: 9q88T_GaPaOOdmRE9w6BWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC3B21023F66;
	Wed,  1 Dec 2021 07:48:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2CA210016F4;
	Wed,  1 Dec 2021 07:48:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD1CC4A7CA;
	Wed,  1 Dec 2021 07:48:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IK6d008743 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 717684047279; Wed,  1 Dec 2021 05:18:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D28C4047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5694885A5A8
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:20 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-440-4Df4_dEdPwCPpbGTU6qonA-1; Wed, 01 Dec 2021 00:18:19 -0500
X-MC-Unique: 4Df4_dEdPwCPpbGTU6qonA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C358B1FD2F;
	Wed,  1 Dec 2021 05:18:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C84D113425;
	Wed,  1 Dec 2021 05:18:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4EeAJZgFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:41 +0800
Message-Id: <20211201051756.53742-3-wqu@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IK6d008743
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 02/17] btrfs: save bio::bi_iter into
	btrfs_bio::iter before submitting
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

Since block layer will advance bio::bi_iter, at endio time we can no
longer rely on bio::bi_iter for split bio.

But for the incoming btrfs_bio split at btrfs_map_bio() time, we have to
ensure endio function is only executed for the split range, not the
whole original bio.

Thus this patch will introduce a new helper, btrfs_bio_save_iter(), to
save bi_iter into btrfs_bio::iter.

The following call sites need this helper call:

- btrfs_submit_compressed_read()
  For compressed read. For compressed write it doesn't really care as
  they use ordered extent.

- raid56_parity_write()
- raid56_parity_recovery()
  For RAID56.

- submit_stripe_bio()
  For all other cases.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c |  3 +++
 fs/btrfs/raid56.c      |  2 ++
 fs/btrfs/volumes.c     | 14 ++++++++++++++
 fs/btrfs/volumes.h     | 18 ++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e776956d5bc9..cc8d13369f53 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -870,6 +870,9 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bio->bi_iter.bi_size;
 
+	/* Save bi_iter so that end_bio_extent_readpage() won't freak out. */
+	btrfs_bio_save_iter(btrfs_bio(bio));
+
 	while (cur_disk_byte < disk_bytenr + compressed_len) {
 		u64 offset = cur_disk_byte - disk_bytenr;
 		unsigned int index = offset >> PAGE_SHIFT;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0e239a4c3b26..13e726c88a81 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1731,6 +1731,7 @@ int raid56_parity_write(struct bio *bio, struct btrfs_io_context *bioc,
 		return PTR_ERR(rbio);
 	}
 	bio_list_add(&rbio->bio_list, bio);
+	btrfs_bio_save_iter(btrfs_bio(bio));
 	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 	rbio->operation = BTRFS_RBIO_WRITE;
 
@@ -2135,6 +2136,7 @@ int raid56_parity_recover(struct bio *bio, struct btrfs_io_context *bioc,
 
 	rbio->operation = BTRFS_RBIO_READ_REBUILD;
 	bio_list_add(&rbio->bio_list, bio);
+	btrfs_bio_save_iter(btrfs_bio(bio));
 	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f38c230111be..b70037cc1a51 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6829,6 +6829,20 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		BUG();
 	}
 
+	/*
+	 * At endio time, bi_iter is no longer reliable, thus we have to save
+	 * current bi_iter into btrfs_bio so that even for split bio we can
+	 * iterate only the split part.
+	 *
+	 * And this has to be done before any bioc error, as endio functions
+	 * will rely on bbio::iter.
+	 *
+	 * For bio create by btrfs_bio_slit() or btrfs_bio_clone*(), it's
+	 * already set, but we can still have original bio which has its
+	 * iter not initialized.
+	 */
+	btrfs_bio_save_iter(btrfs_bio(bio));
+
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bioc->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3b8130680749..f9178d2c2fd6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -334,6 +334,12 @@ struct btrfs_bio {
 	struct btrfs_device *device;
 	u8 *csum;
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+	/*
+	 * Saved bio::bi_iter before submission.
+	 *
+	 * This allows us to interate the cloned/split bio properly, as at
+	 * endio time bio::bi_iter is no longer reliable.
+	 */
 	struct bvec_iter iter;
 
 	/*
@@ -356,6 +362,18 @@ static inline void btrfs_bio_free_csum(struct btrfs_bio *bbio)
 	}
 }
 
+/*
+ * To save bbio::bio->bi_iter into bbio::iter so for callers who need the
+ * original bi_iter can access the original part of the bio.
+ * This is especially important for the incoming split btrfs_bio, which needs
+ * to call its endio for and only for the split range.
+ */
+static inline void btrfs_bio_save_iter(struct btrfs_bio *bbio)
+{
+	if (!bbio->iter.bi_size)
+		bbio->iter = bbio->bio.bi_iter;
+}
+
 struct btrfs_io_stripe {
 	struct btrfs_device *dev;
 	u64 physical;
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

