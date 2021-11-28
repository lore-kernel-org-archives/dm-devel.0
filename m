Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740EFC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:46 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-_E0Y7fBAPcuJuVjCIsB4Zw-1; Mon, 29 Nov 2021 01:56:41 -0500
X-MC-Unique: _E0Y7fBAPcuJuVjCIsB4Zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97E2F1006AA5;
	Mon, 29 Nov 2021 06:56:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FAF37944B;
	Mon, 29 Nov 2021 06:56:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 586F31805302;
	Mon, 29 Nov 2021 06:56:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AS5rTSw027047 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 00:53:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75AC651DC; Sun, 28 Nov 2021 05:53:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4A751E3
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE789811E76
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-453-Zmn8S9SXMzKD6gilLnkLug-1; Sun, 28 Nov 2021 00:53:25 -0500
X-MC-Unique: Zmn8S9SXMzKD6gilLnkLug-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B46C82170C;
	Sun, 28 Nov 2021 05:53:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE53413446;
	Sun, 28 Nov 2021 05:53:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id qMwrI1MZo2G7fAAAMHmgww
	(envelope-from <wqu@suse.com>); Sun, 28 Nov 2021 05:53:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 28 Nov 2021 13:52:52 +0800
Message-Id: <20211128055259.39249-5-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AS5rTSw027047
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:53 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH RFC 04/11] btrfs: introduce btrfs_bio_split()
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This new function will handle the split of a btrfs bio, to co-operate
with the incoming chunk mapping time bio split.

This patch will introduce the following new members:

- btrfs_bio::offset_to_original
  Since btrfs_bio::csum is still storing the checksum for the original
  logical bytenr, we need to know the offset between current advanced
  bio and the original logical bytenr.

  Thus here we need such new member.
  And the new member will fit into the existing hole between
  btrfs_bio::mirror_num and btrfs_bio::device, it should not increase
  the memory usage of btrfs_bio.

- btrfs_bio::parent and btrfs_bio::orig_endio
  To record where the parent bio is and the original endio function.

- btrfs_bio::is_split_bio
  To distinguish bio created by btrfs_bio_split() and
  btrfs_bio_clone*().

  For cloned bio, they still have their csum pointed to correct memory,
  while split bio must rely on its parent bbio to grab csum pointer.

- split_bio_endio()
  Just to call the original endio function then call bio_endio() on
  the original bio.
  This will ensure the original bio is freed after all cloned bio.

Currently there is no other caller utilizing above new members/functions
yet.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 76 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h |  2 ++
 fs/btrfs/volumes.h   | 43 +++++++++++++++++++++++--
 3 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b289d26aca0d..34195891b0b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3005,7 +3005,6 @@ static void end_bio_extent_readpage(struct bio *bio)
 	int ret;
 	struct bvec_iter_all iter_all;
 
-	ASSERT(!bio_flagged(bio, BIO_CLONED));
 	bio_for_each_segment_all(bvec, bio, iter_all) {
 		bool uptodate = !bio->bi_status;
 		struct page *page = bvec->bv_page;
@@ -3184,6 +3183,81 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, u64 offset, u64 size)
 	return bio;
 }
 
+/*
+ * A very simple wrapper to call original endio function and then
+ * call bio_endio() on the parent bio to decrease its bi_remaining count.
+ */
+static void split_bio_endio(struct bio *bio)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+	/* After endio bbio could be freed, thus grab the info before endio */
+	struct bio *parent = bbio->parent;
+
+	/*
+	 * BIO_CLONED can even be set for our parent bio (DIO use clones
+	 * the initial bio, then uses the cloned one for IO).
+	 * So here we don't check BIO_CLONED for parent.
+	 */
+	ASSERT(bio_flagged(bio, BIO_CLONED) && bbio->is_split_bio);
+	ASSERT(bbio->parent && !bbio->is_split_bio);
+
+	bio->bi_end_io = bbio->orig_endio;
+	bio_endio(bio);
+	bio_endio(parent);
+}
+
+/*
+ * Pretty much like bio_split(), caller needs to ensure @src is not freed
+ * before the newly allocated bio, as the new bio is relying on @src for
+ * its bvecs.
+ */
+struct bio *btrfs_bio_split(struct btrfs_fs_info *fs_info,
+			    struct bio *src, unsigned int bytes)
+{
+	struct bio *new;
+	struct btrfs_bio *src_bbio = btrfs_bio(src);
+	struct btrfs_bio *new_bbio;
+	const unsigned int old_offset = src_bbio->offset_to_original;
+
+	/* Src should not be split */
+	ASSERT(!src_bbio->is_split_bio);
+	ASSERT(IS_ALIGNED(bytes, fs_info->sectorsize));
+	ASSERT(bytes < src->bi_iter.bi_size);
+
+	/*
+	 * We're in fact chaining the new bio to the parent, but we still want
+	 * to have independent bi_private/bi_endio, thus we need to manually
+	 * increase the remaining for the source, just like bio_chain().
+	 */
+	bio_inc_remaining(src);
+
+	/* Bioset backed split should not fail */
+	new = bio_split(src, bytes >> SECTOR_SHIFT, GFP_NOFS, &btrfs_bioset);
+	new_bbio = btrfs_bio(new);
+	new_bbio->offset_to_original = old_offset;
+	new_bbio->iter = new->bi_iter;
+	new_bbio->orig_endio = src->bi_end_io;
+	new_bbio->parent = src;
+	new_bbio->endio_type = src_bbio->endio_type;
+	new_bbio->is_split_bio = 1;
+	new->bi_end_io = split_bio_endio;
+
+	/*
+	 * This is very tricky, as if any endio has extra refcount on
+	 * bi_private, we will be screwed up.
+	 *
+	 * We workaround this hacky behavior by reviewing all the involved
+	 * endio stacks. Making sure only split-safe endio remap are called.
+	 *
+	 * Split-unsafe endio remap like btrfs_bio_wq_end_io() will be called
+	 * after btrfs_bio_split().
+	 */
+	new->bi_private = src->bi_private;
+
+	src_bbio->offset_to_original += bytes;
+	return new;
+}
+
 /**
  * Attempt to add a page to bio
  *
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0399cf8e3c32..cb727b77ecda 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -280,6 +280,8 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 struct bio *btrfs_bio_alloc(unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio);
 struct bio *btrfs_bio_clone_partial(struct bio *orig, u64 offset, u64 size);
+struct bio *btrfs_bio_split(struct btrfs_fs_info *fs_info,
+			    struct bio *src, unsigned int bytes);
 
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int btrfs_repair_eb_io_failure(const struct extent_buffer *eb, int mirror_num);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 27d396c152c6..358fc546d611 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -332,15 +332,52 @@ struct btrfs_bio {
 
 	/*
 	 * To tell which workqueue the bio's endio should be exeucted in.
+	 * This member is to make sure btrfs_bio_wq_end_io() is the last
+	 * endio remap in the stack.
 	 *
 	 * Only for read bios.
 	 */
-	u16 endio_type;
+	u8 endio_type;
+
+	/*
+	 * To tell if this btrfs bio is split or just cloned.
+	 * Both btrfs_bio_clone*() and btrfs_bio_split() will make bbio->bio
+	 * to have BIO_CLONED flag.
+	 * But cloned bio still has its bbio::csum pointed to correct memory,
+	 * unlike split bio relies on its parent bbio to grab csum.
+	 *
+	 * Thus we needs this extra flag to distinguish those cloned bio.
+	 */
+	u8 is_split_bio;
+
+	/*
+	 * Records the offset we're from the original bio.
+	 *
+	 * Since btrfs_bio can be split, but our csum is alwasy for the
+	 * original logical bytenr, we need a way to know the bytes offset
+	 * from the original logical bytenr to do proper csum verification.
+	 */
+	unsigned int offset_to_original;
 
 	/* @device is for stripe IO submission. */
 	struct btrfs_device *device;
-	u8 *csum;
-	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+
+	union {
+		/*
+		 * For the parent bio recording the csum for the original
+		 * logical bytenr
+		 */
+		struct {
+			u8 *csum;
+			u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+		};
+
+		/* For child (split) bio to record where its parent is */
+		struct {
+			struct bio *parent;
+			bio_end_io_t *orig_endio;
+		};
+	};
 	struct bvec_iter iter;
 
 	/*
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

