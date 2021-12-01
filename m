Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E781CC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-559-y7FYehkPN4K-uKp6pOjGcQ-1; Wed, 01 Dec 2021 02:48:25 -0500
X-MC-Unique: y7FYehkPN4K-uKp6pOjGcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 912E283DD1B;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7819979453;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5176D1809CB9;
	Wed,  1 Dec 2021 07:48:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15INHt008757 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 525CD4047279; Wed,  1 Dec 2021 05:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D5E74047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 363E885A5A8
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-138-tCDMPQXIPrOFWTekJHdZEA-1; Wed, 01 Dec 2021 00:18:21 -0500
X-MC-Unique: tCDMPQXIPrOFWTekJHdZEA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78C5B1FD2F;
	Wed,  1 Dec 2021 05:18:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7CEF813425;
	Wed,  1 Dec 2021 05:18:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id mFIHE5sFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:43 +0800
Message-Id: <20211201051756.53742-5-wqu@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15INHt008757
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 04/17] btrfs: refactor btrfs_map_bio()
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

Currently in btrfs_map_bio() we call __btrfs_map_block(), then using the
returned bioc to submit real stripes.

This is fine if we're only going to handle one bio a time.

For the incoming bio split at btrfs_map_bio() time, we want to handle
several different bios, thus there we introduce a new helper,
submit_one_mapped_range() to handle the submission part, making it much
easier to make it work in a loop.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 65 ++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b70037cc1a51..3dc759996f55 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6777,29 +6777,15 @@ static void bioc_error(struct btrfs_io_context *bioc, struct bio *bio, u64 logic
 	}
 }
 
-blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
-			   int mirror_num)
+static int submit_one_mapped_range(struct btrfs_fs_info *fs_info, struct bio *bio,
+				   struct btrfs_io_context *bioc, u64 map_length,
+				   int mirror_num)
 {
-	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
-	u64 logical = bio->bi_iter.bi_sector << 9;
-	u64 length = 0;
-	u64 map_length;
-	int ret;
-	int dev_nr;
+	u64 logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	int total_devs;
-	struct btrfs_io_context *bioc = NULL;
-
-	length = bio->bi_iter.bi_size;
-	map_length = length;
-
-	btrfs_bio_counter_inc_blocked(fs_info);
-	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
-				&map_length, &bioc, mirror_num, 1);
-	if (ret) {
-		btrfs_bio_counter_dec(fs_info);
-		return errno_to_blk_status(ret);
-	}
+	int dev_nr;
+	int ret;
 
 	total_devs = bioc->num_stripes;
 	bioc->orig_bio = first_bio;
@@ -6818,14 +6804,13 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 						    mirror_num, 1);
 		}
 
-		btrfs_bio_counter_dec(fs_info);
-		return errno_to_blk_status(ret);
+		return ret;
 	}
 
-	if (map_length < length) {
+	if (map_length < bio->bi_iter.bi_size) {
 		btrfs_crit(fs_info,
-			   "mapping failed logical %llu bio len %llu len %llu",
-			   logical, length, map_length);
+			   "mapping failed logical %llu bio len %u len %llu",
+			   logical, bio->bi_iter.bi_size, map_length);
 		BUG();
 	}
 
@@ -6844,6 +6829,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	btrfs_bio_save_iter(btrfs_bio(bio));
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
+		struct btrfs_device *dev;
+
 		dev = bioc->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
 						   &dev->dev_state) ||
@@ -6860,6 +6847,34 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 		submit_stripe_bio(bioc, bio, bioc->stripes[dev_nr].physical, dev);
 	}
+	return 0;
+}
+
+blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
+			   int mirror_num)
+{
+	u64 logical = bio->bi_iter.bi_sector << 9;
+	u64 length = 0;
+	u64 map_length;
+	int ret;
+	struct btrfs_io_context *bioc = NULL;
+
+	length = bio->bi_iter.bi_size;
+	map_length = length;
+
+	btrfs_bio_counter_inc_blocked(fs_info);
+	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
+				&map_length, &bioc, mirror_num, 1);
+	if (ret) {
+		btrfs_bio_counter_dec(fs_info);
+		return errno_to_blk_status(ret);
+	}
+
+	ret = submit_one_mapped_range(fs_info, bio, bioc, map_length, mirror_num);
+	if (ret < 0) {
+		btrfs_bio_counter_dec(fs_info);
+		return errno_to_blk_status(ret);
+	}
 	btrfs_bio_counter_dec(fs_info);
 	return BLK_STS_OK;
 }
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

