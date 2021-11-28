Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5D6C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-EUzQ3rY7Ns6pItzTAzxJag-1; Mon, 29 Nov 2021 01:56:36 -0500
X-MC-Unique: EUzQ3rY7Ns6pItzTAzxJag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F0D31006AA0;
	Mon, 29 Nov 2021 06:56:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54F155D9C0;
	Mon, 29 Nov 2021 06:56:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DAB94A705;
	Mon, 29 Nov 2021 06:56:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AS5rXgI027090 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 00:53:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4704F492C3B; Sun, 28 Nov 2021 05:53:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42207492C38
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 251D71066559
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:33 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-33-wpf6cJUtM1eHyXqy_CZgNA-1; Sun, 28 Nov 2021 00:53:31 -0500
X-MC-Unique: wpf6cJUtM1eHyXqy_CZgNA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 092911FD41;
	Sun, 28 Nov 2021 05:53:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 100DB13446;
	Sun, 28 Nov 2021 05:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 6BRRNFgZo2G7fAAAMHmgww
	(envelope-from <wqu@suse.com>); Sun, 28 Nov 2021 05:53:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 28 Nov 2021 13:52:56 +0800
Message-Id: <20211128055259.39249-9-wqu@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AS5rXgI027090
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:53 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH RFC 08/11] btrfs: allow btrfs_map_bio() to split
	bio according to chunk stripe boundaries
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

With the new btrfs_bio_split() helper, we are able to split bio
according to chunk stripe boundaries at btrfs_map_bio() time.

Although currently due bio split at submit_extent_page() this ability is
not yet utilized.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 53 +++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e6ed71195e18..7f7e13e4caa3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6878,29 +6878,48 @@ static int submit_one_mapped_range(struct btrfs_fs_info *fs_info, struct bio *bi
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
+			/* Need to split */
+			cur_bio = btrfs_bio_split(fs_info, bio, map_length);
+			if (IS_ERR(cur_bio)) {
+				btrfs_put_bioc(bioc);
+				ret = PTR_ERR(cur_bio);
+				return errno_to_blk_status(ret);
+			}
+		} else {
+			/* Can use the existing bio directly */
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
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

