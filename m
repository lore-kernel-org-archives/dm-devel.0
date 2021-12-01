Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770EFC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-7dOLUq5xNh6cbbXKz72fvQ-1; Wed, 01 Dec 2021 02:48:37 -0500
X-MC-Unique: 7dOLUq5xNh6cbbXKz72fvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3258E192AB76;
	Wed,  1 Dec 2021 07:48:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18ECB7621D;
	Wed,  1 Dec 2021 07:48:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9657180C677;
	Wed,  1 Dec 2021 07:48:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IYx1008810 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1DAD7492C38; Wed,  1 Dec 2021 05:18:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 196E7492C3B
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2B0F802E5E
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:33 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-154--jyrqxVaOJ-oEhQp0N9v9Q-1; Wed, 01 Dec 2021 00:18:32 -0500
X-MC-Unique: -jyrqxVaOJ-oEhQp0N9v9Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 452581FD58;
	Wed,  1 Dec 2021 05:18:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 494C113425;
	Wed,  1 Dec 2021 05:18:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id gBN1BqYFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:51 +0800
Message-Id: <20211201051756.53742-13-wqu@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IYx1008810
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 12/17] btrfs: return proper mapped length for
	RAID56 profiles in __btrfs_map_block()
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

For profiles other than RAID56, __btrfs_map_block() returns @map_length
as min(stripe_end, logical + *length), which is also the same result
from btrfs_get_io_geometry().

But for RAID56, __btrfs_map_block() returns @map_length as stripe_len.

This strange behavior is going to hurt incoming bio split at
btrfs_map_bio() time, as we will use @map_length as bio split size.

Fix this behavior by:

- Return @map_length by the same calculatioin as other profiles

- Save stripe_len into btrfs_io_context

- Pass btrfs_io_context::stripe_len to raid56_*() functions

- Update raid56_*() functions to make its stripe_len parameter more
  explicit

- Add extra ASSERT()s to make sure the passed stripe_len is correct

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c  | 12 ++++++++++--
 fs/btrfs/raid56.h  |  2 +-
 fs/btrfs/scrub.c   |  4 ++--
 fs/btrfs/volumes.c | 13 ++++++++++---
 fs/btrfs/volumes.h |  1 +
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 13e726c88a81..d35cfd750b76 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -969,6 +969,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	int stripe_npages = DIV_ROUND_UP(stripe_len, PAGE_SIZE);
 	void *p;
 
+	ASSERT(stripe_len == BTRFS_STRIPE_LEN);
+
 	rbio = kzalloc(sizeof(*rbio) +
 		       sizeof(*rbio->stripe_pages) * num_pages +
 		       sizeof(*rbio->bio_pages) * num_pages +
@@ -1725,6 +1727,9 @@ int raid56_parity_write(struct bio *bio, struct btrfs_io_context *bioc,
 	struct blk_plug_cb *cb;
 	int ret;
 
+	/* Currently we only support fixed stripe len */
+	ASSERT(stripe_len == BTRFS_STRIPE_LEN);
+
 	rbio = alloc_rbio(fs_info, bioc, stripe_len);
 	if (IS_ERR(rbio)) {
 		btrfs_put_bioc(bioc);
@@ -2122,6 +2127,9 @@ int raid56_parity_recover(struct bio *bio, struct btrfs_io_context *bioc,
 	struct btrfs_raid_bio *rbio;
 	int ret;
 
+	/* Currently we only support fixed stripe len */
+	ASSERT(stripe_len == BTRFS_STRIPE_LEN);
+
 	if (generic_io) {
 		ASSERT(bioc->mirror_num == mirror_num);
 		btrfs_bio(bio)->mirror_num = mirror_num;
@@ -2671,12 +2679,12 @@ void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
 
 struct btrfs_raid_bio *
 raid56_alloc_missing_rbio(struct bio *bio, struct btrfs_io_context *bioc,
-			  u64 length)
+			  u64 stripe_len)
 {
 	struct btrfs_fs_info *fs_info = bioc->fs_info;
 	struct btrfs_raid_bio *rbio;
 
-	rbio = alloc_rbio(fs_info, bioc, length);
+	rbio = alloc_rbio(fs_info, bioc, stripe_len);
 	if (IS_ERR(rbio))
 		return NULL;
 
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 72c00fc284b5..7322dcae4498 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -46,7 +46,7 @@ void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio);
 
 struct btrfs_raid_bio *
 raid56_alloc_missing_rbio(struct bio *bio, struct btrfs_io_context *bioc,
-			  u64 length);
+			  u64 stripe_len);
 void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
 
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 15a123e67108..58c7e8fcdeb1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2230,7 +2230,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
 
-	rbio = raid56_alloc_missing_rbio(bio, bioc, length);
+	rbio = raid56_alloc_missing_rbio(bio, bioc, bioc->stripe_len);
 	if (!rbio)
 		goto rbio_out;
 
@@ -2846,7 +2846,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
 
-	rbio = raid56_parity_alloc_scrub_rbio(bio, bioc, length,
+	rbio = raid56_parity_alloc_scrub_rbio(bio, bioc, bioc->stripe_len,
 					      sparity->scrub_dev,
 					      sparity->dbitmap,
 					      sparity->nsectors);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index af01d54502ab..365e43bbfd14 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6051,6 +6051,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 		ret = -ENOMEM;
 		goto out;
 	}
+	bioc->stripe_len = map->stripe_len;
 
 	for (i = 0; i < num_stripes; i++) {
 		bioc->stripes[i].physical =
@@ -6406,6 +6407,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 {
 	struct extent_map *em;
 	struct map_lookup *map;
+	const u64 orig_length = *length;
 	u64 stripe_offset;
 	u64 stripe_nr;
 	u64 stripe_len;
@@ -6427,6 +6429,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	ASSERT(bioc_ret);
 	ASSERT(op != BTRFS_MAP_DISCARD);
+	ASSERT(orig_length);
 
 	em = btrfs_get_chunk_map(fs_info, logical, *length);
 	ASSERT(!IS_ERR(em));
@@ -6522,7 +6525,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			num_stripes = map->num_stripes;
 			max_errors = nr_parity_stripes(map);
 
-			*length = map->stripe_len;
+			/* Return the length to the full stripe end */
+			*length = min(raid56_full_stripe_start + em->start +
+				      data_stripes * stripe_len,
+				      logical + orig_length) - logical;
 			stripe_index = 0;
 			stripe_offset = 0;
 		} else {
@@ -6574,6 +6580,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		ret = -ENOMEM;
 		goto out;
 	}
+	bioc->stripe_len = map->stripe_len;
 
 	for (i = 0; i < num_stripes; i++) {
 		bioc->stripes[i].physical = map->stripes[stripe_index].physical +
@@ -6824,9 +6831,9 @@ static int submit_one_mapped_range(struct btrfs_fs_info *fs_info, struct bio *bi
 		/* In this case, map_length has been set to the length of
 		   a single stripe; not the whole write */
 		if (btrfs_op(bio) == BTRFS_MAP_WRITE) {
-			ret = raid56_parity_write(bio, bioc, map_length);
+			ret = raid56_parity_write(bio, bioc, bioc->stripe_len);
 		} else {
-			ret = raid56_parity_recover(bio, bioc, map_length,
+			ret = raid56_parity_recover(bio, bioc, bioc->stripe_len,
 						    mirror_num, 1);
 		}
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8825a17d0620..b2dbf895b4e3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -450,6 +450,7 @@ struct btrfs_io_context {
 	struct bio *orig_bio;
 	void *private;
 	atomic_t error;
+	u32 stripe_len;
 	int max_errors;
 	int num_stripes;
 	int mirror_num;
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

