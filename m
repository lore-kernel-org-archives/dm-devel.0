Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D33C43217
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-R4UkTjQ2M-6R7Ql1YUTI8A-1; Wed, 01 Dec 2021 02:48:34 -0500
X-MC-Unique: R4UkTjQ2M-6R7Ql1YUTI8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF75681CCB4;
	Wed,  1 Dec 2021 07:48:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8B50694BF;
	Wed,  1 Dec 2021 07:48:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 816D71806D2F;
	Wed,  1 Dec 2021 07:48:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IbDG008843 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 45F692026D4D; Wed,  1 Dec 2021 05:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4170E2026D46
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29D6F811E84
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-214-Ro_39oCWN4GMyB2NfjVMgA-1; Wed, 01 Dec 2021 00:18:35 -0500
X-MC-Unique: Ro_39oCWN4GMyB2NfjVMgA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF18C1FD2F;
	Wed,  1 Dec 2021 05:18:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2D0513425;
	Wed,  1 Dec 2021 05:18:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4HzNL6gFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:53 +0800
Message-Id: <20211201051756.53742-15-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IbDG008843
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 14/17] btrfs: remove buffered IO stripe boundary
	calculation
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

This will remove btrfs_bio_ctrl::len_to_stripe_boundary, so that buffer
IO will no longer limits its bio size according to stripe length.

This will move the bio split to btrfs_map_bio() for all buffered IO.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8f5a1059a296..7fabf46312dd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3301,7 +3301,7 @@ static int btrfs_bio_add_page(struct btrfs_bio_ctrl *bio_ctrl,
 
 	ASSERT(bio);
 	/* The limit should be calculated when bio_ctrl->bio is allocated */
-	ASSERT(bio_ctrl->len_to_oe_boundary && bio_ctrl->len_to_stripe_boundary);
+	ASSERT(bio_ctrl->len_to_oe_boundary);
 	if (bio_ctrl->bio_flags != bio_flags)
 		return 0;
 
@@ -3312,9 +3312,7 @@ static int btrfs_bio_add_page(struct btrfs_bio_ctrl *bio_ctrl,
 	if (!contig)
 		return 0;
 
-	real_size = min(bio_ctrl->len_to_oe_boundary,
-			bio_ctrl->len_to_stripe_boundary) - bio_size;
-	real_size = min(real_size, size);
+	real_size = min(bio_ctrl->len_to_oe_boundary - bio_size, size);
 
 	/*
 	 * If real_size is 0, never call bio_add_*_page(), as even size is 0,
@@ -3335,11 +3333,8 @@ static int calc_bio_boundaries(struct btrfs_bio_ctrl *bio_ctrl,
 			       struct btrfs_inode *inode, u64 file_offset)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_io_geometry geom;
 	struct btrfs_ordered_extent *ordered;
-	struct extent_map *em;
 	u64 logical = (bio_ctrl->bio->bi_iter.bi_sector << SECTOR_SHIFT);
-	int ret;
 
 	/*
 	 * Pages for compressed extent are never submitted to disk directly,
@@ -3350,22 +3345,8 @@ static int calc_bio_boundaries(struct btrfs_bio_ctrl *bio_ctrl,
 	 */
 	if (bio_ctrl->bio_flags & EXTENT_BIO_COMPRESSED) {
 		bio_ctrl->len_to_oe_boundary = U32_MAX;
-		bio_ctrl->len_to_stripe_boundary = U32_MAX;
 		return 0;
 	}
-	em = btrfs_get_chunk_map(fs_info, logical, fs_info->sectorsize);
-	if (IS_ERR(em))
-		return PTR_ERR(em);
-	ret = btrfs_get_io_geometry(fs_info, em, btrfs_op(bio_ctrl->bio),
-				    logical, &geom);
-	free_extent_map(em);
-	if (ret < 0) {
-		return ret;
-	}
-	if (geom.len > U32_MAX)
-		bio_ctrl->len_to_stripe_boundary = U32_MAX;
-	else
-		bio_ctrl->len_to_stripe_boundary = (u32)geom.len;
 
 	if (!btrfs_is_zoned(fs_info) ||
 	    bio_op(bio_ctrl->bio) != REQ_OP_ZONE_APPEND) {
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

