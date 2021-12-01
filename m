Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494E1C43219
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-pgQNRHqFMkWUoaih8KABzg-1; Wed, 01 Dec 2021 02:48:32 -0500
X-MC-Unique: pgQNRHqFMkWUoaih8KABzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47382192AB94;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F49060622;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 096BF1806D03;
	Wed,  1 Dec 2021 07:48:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IZju008818 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 43958401E44; Wed,  1 Dec 2021 05:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40243401E38
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29A85805B9A
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:35 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-341-KFhSZ4MnOcS5Dy7FSNnsdw-1; Wed, 01 Dec 2021 00:18:33 -0500
X-MC-Unique: KFhSZ4MnOcS5Dy7FSNnsdw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A3BC212BA;
	Wed,  1 Dec 2021 05:18:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E0A013425;
	Wed,  1 Dec 2021 05:18:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id OGsUG6cFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:52 +0800
Message-Id: <20211201051756.53742-14-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IZju008818
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 13/17] btrfs: allow btrfs_map_bio() to split bio
	according to chunk stripe boundaries
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

With the new btrfs_bio_split() helper, we are able to split bio
according to chunk stripe boundaries at btrfs_map_bio() time.

Although currently due bio split at buffered/compressed/direct IO time,
this ability is not yet utilized.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 48 ++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 365e43bbfd14..35ba1ea95295 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6893,29 +6893,43 @@ static int submit_one_mapped_range(struct btrfs_fs_info *fs_info, struct bio *bi
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num)
 {
-	u64 logical = bio->bi_iter.bi_sector << 9;
-	u64 length = 0;
-	u64 map_length;
+	const u64 orig_logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	const unsigned int orig_length = bio->bi_iter.bi_size;
+	const enum btrfs_map_op op = btrfs_op(bio);
+	u64 cur_logical = orig_logical;
 	int ret;
-	struct btrfs_io_context *bioc = NULL;
 
-	length = bio->bi_iter.bi_size;
-	map_length = length;
+	while (cur_logical < orig_logical + orig_length) {
+		u64 map_length = orig_logical + orig_length - cur_logical;
+		struct btrfs_io_context *bioc = NULL;
+		struct bio *cur_bio;
 
-	btrfs_bio_counter_inc_blocked(fs_info);
-	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
-				&map_length, &bioc, mirror_num, 1);
-	if (ret) {
-		btrfs_bio_counter_dec(fs_info);
-		return errno_to_blk_status(ret);
-	}
+		ret = __btrfs_map_block(fs_info, op, cur_logical, &map_length,
+					&bioc, mirror_num, 1);
+		if (ret)
+			return errno_to_blk_status(ret);
 
-	ret = submit_one_mapped_range(fs_info, bio, bioc, map_length, mirror_num);
-	if (ret < 0) {
+		if (cur_logical + map_length < orig_logical + orig_length) {
+			/*
+			 * For now zoned write should never cross stripe
+			 * boundary
+			 */
+			ASSERT(bio_op(bio) != REQ_OP_ZONE_APPEND);
+
+			/* Split the bio */
+			cur_bio = btrfs_bio_split(fs_info, bio, map_length);
+		} else {
+			/* Use the existing bio directly */
+			cur_bio = bio;
+		}
+		btrfs_bio_counter_inc_blocked(fs_info);
+		ret = submit_one_mapped_range(fs_info, cur_bio, bioc,
+					      map_length, mirror_num);
 		btrfs_bio_counter_dec(fs_info);
-		return errno_to_blk_status(ret);
+		if (ret < 0)
+			return errno_to_blk_status(ret);
+		cur_logical += map_length;
 	}
-	btrfs_bio_counter_dec(fs_info);
 	return BLK_STS_OK;
 }
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

