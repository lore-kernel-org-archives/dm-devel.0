Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D582C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1AM1vRXQtl+AtpJHsZy01a8aF4GIrLSBSm01LXtVTkI=;
	b=bLN9nRsOKwt7skxP2hWRlDHsOc3Q+L3/9fpRJdlkyAFxQE5T/9YGwZDVT3eyNhy6w1dC/j
	G4SVK/7Z01h8HAk8jUkv05mURkQrmlE5iA5DGdhG/zoIM8uVs/AuE3pYfxpuldA3nX5FLb
	YW2nqDYtEQNfAa0T5X2BM45ZKjmQBM0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-5mlR6gfZMlOFQJFL6eHx1w-1; Mon, 13 Feb 2023 15:14:48 -0500
X-MC-Unique: 5mlR6gfZMlOFQJFL6eHx1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5080585A5A3;
	Mon, 13 Feb 2023 20:14:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E326140EBF4;
	Mon, 13 Feb 2023 20:14:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2FDF01946588;
	Mon, 13 Feb 2023 20:14:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 532E21946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 46C8C492B16; Mon, 13 Feb 2023 20:14:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F123492B15
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FFF786C175
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:44 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-NnMmczZrPTCmMetpbRucXw-1; Mon, 13 Feb 2023 15:14:42 -0500
X-MC-Unique: NnMmczZrPTCmMetpbRucXw-1
Received: by mail-qt1-f180.google.com with SMTP id m12so15198005qth.4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=DO9v91SkRUXmPAyvBJ6dtMBOijUjIDbuD+T7vXtg2QI=;
 b=CztspQQ0h6Ff6WGaNFC0s3yCAjCdWPYTn+TEkisQCXmBrwY+okr/3jsdxLVOZJVfTp
 LwtuWGcF178rCeWhxC0uJ5/L2sNC5e01tOo2BoGbQ5OPkwpXJ+LpKJ6oGtqquiATi7R3
 B4cZmTrfwVL8EiZ33n4wd4ntjc3qLwn4whI751plRl9HbxmykPuZjqRMrbSiLr5Lig8l
 41+YFa4IpwQmOYqppPrVJecNisPk8qeh6WMxDlMo2lzR6MHpVm96BX96TXOmStl7VOkI
 CPKeZJoDoGhW4ZVGzcpbxH2e7cQ9bfEZUm3jEQ9Kxt35PpnbGFX433JUyXRYBpBa3yhA
 8Fnw==
X-Gm-Message-State: AO0yUKUDKkBoWBTUubi2Eb1S1E2AJLwy0JKLsm/x70gN65dFXOzO/WdZ
 v1j40RTICA7fqUWh0irDB8Df5D0atuB9FEzVMw7iB1p722neznEODzlrRqmloUeJxTn6DC+lwfY
 3yCYuKzXY/5R/pqCIMrSB7XxMgTQfG5p7CsBtUsXhJNRr4rZa1xKGmZIIzC/OWRp7Jlsi+Q==
X-Google-Smtp-Source: AK7set/3QXu6o4UsBxuYJ6nl2Ps1HFsbtVPogzrf08ckOMUQPAk0qpCAGbkVKGpNZsbxPdBT7Q11ew==
X-Received: by 2002:a05:622a:151:b0:3b8:2a6c:d1e9 with SMTP id
 v17-20020a05622a015100b003b82a6cd1e9mr44960123qtw.18.1676319281545; 
 Mon, 13 Feb 2023 12:14:41 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 q3-20020a378e03000000b0073b428119d9sm2697928qkd.106.2023.02.13.12.14.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:41 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:31 -0500
Message-Id: <20230213201401.45973-10-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 09/39] dm: address indent/space issues
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-cache-policy.h                     | 2 +-
 drivers/md/dm-crypt.c                            | 2 +-
 drivers/md/dm-integrity.c                        | 5 ++---
 drivers/md/dm-log.c                              | 8 ++++----
 drivers/md/dm-raid.c                             | 8 ++++----
 drivers/md/dm-raid1.c                            | 2 +-
 drivers/md/dm-table.c                            | 4 ++--
 drivers/md/dm-thin.c                             | 6 +++---
 drivers/md/dm-writecache.c                       | 2 +-
 drivers/md/persistent-data/dm-btree.c            | 6 +++---
 drivers/md/persistent-data/dm-space-map-common.c | 2 +-
 drivers/md/persistent-data/dm-space-map-common.h | 2 +-
 12 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 07264a6d60d9..f46f4d2fc43f 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -76,7 +76,7 @@ struct dm_cache_policy {
 	 * background work.
 	 */
 	int (*get_background_work)(struct dm_cache_policy *p, bool idle,
-			           struct policy_work **result);
+				   struct policy_work **result);
 
 	/*
 	 * You must pass in the same work pointer that you were given, not
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d0ba9679c740..007c286702c2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2503,7 +2503,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 		type = &key_type_encrypted;
 		set_key = set_key_encrypted;
 	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
-	           !strncmp(key_string, "trusted:", key_desc - key_string + 1)) {
+		   !strncmp(key_string, "trusted:", key_desc - key_string + 1)) {
 		type = &key_type_trusted;
 		set_key = set_key_trusted;
 	} else {
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e8573dd93483..ed6515411e85 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2301,7 +2301,6 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 		else
 skip_check:
 			dec_in_flight(dio);
-
 	} else {
 		INIT_WORK(&dio->work, integrity_metadata);
 		queue_work(ic->metadata_wq, &dio->work);
@@ -4085,7 +4084,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		} else if (sscanf(opt_string, "block_size:%u%c", &val, &dummy) == 1) {
 			if (val < 1 << SECTOR_SHIFT ||
 			    val > MAX_SECTORS_PER_BLOCK << SECTOR_SHIFT ||
-			    (val & (val -1))) {
+			    (val & (val - 1))) {
 				r = -EINVAL;
 				ti->error = "Invalid block_size argument";
 				goto bad;
@@ -4405,7 +4404,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 	if (ic->internal_hash) {
 		size_t recalc_tags_size;
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
-		if (!ic->recalc_wq ) {
+		if (!ic->recalc_wq) {
 			ti->error = "Cannot allocate workqueue";
 			r = -ENOMEM;
 			goto bad;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 2601dc9acb08..5b0d5187568e 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -758,8 +758,8 @@ static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 	log_clear_bit(lc, lc->recovering_bits, region);
 	if (in_sync) {
 		log_set_bit(lc, lc->sync_bits, region);
-                lc->sync_count++;
-        } else if (log_test_bit(lc->sync_bits, region)) {
+		lc->sync_count++;
+	} else if (log_test_bit(lc->sync_bits, region)) {
 		lc->sync_count--;
 		log_clear_bit(lc, lc->sync_bits, region);
 	}
@@ -767,9 +767,9 @@ static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 
 static region_t core_get_sync_count(struct dm_dirty_log *log)
 {
-        struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = (struct log_c *) log->context;
 
-        return lc->sync_count;
+	return lc->sync_count;
 }
 
 #define	DMEMIT_SYNC \
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index bf53777c7f85..ecd69e877621 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -363,8 +363,8 @@ static struct {
 	const int mode;
 	const char *param;
 } _raid456_journal_mode[] = {
-	{ R5C_JOURNAL_MODE_WRITE_THROUGH , "writethrough" },
-	{ R5C_JOURNAL_MODE_WRITE_BACK    , "writeback" }
+	{ R5C_JOURNAL_MODE_WRITE_THROUGH, "writethrough" },
+	{ R5C_JOURNAL_MODE_WRITE_BACK,    "writeback" }
 };
 
 /* Return MD raid4/5/6 journal mode for dm @journal_mode one */
@@ -1115,7 +1115,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]		Defines granularity of bitmap
  *    [journal_dev <dev>]		raid4/5/6 journaling deviice
- *    					(i.e. write hole closing log)
+ *					(i.e. write hole closing log)
  *
  * RAID10-only options:
  *    [raid10_copies <# copies>]	Number of copies.  (Default: 2)
@@ -4002,7 +4002,7 @@ static int raid_preresume(struct dm_target *ti)
 	}
 
 	/* Resize bitmap to adjust to changed region size (aka MD bitmap chunksize) or grown device size */
-        if (test_bit(RT_FLAG_RS_BITMAP_LOADED, &rs->runtime_flags) && mddev->bitmap &&
+	if (test_bit(RT_FLAG_RS_BITMAP_LOADED, &rs->runtime_flags) && mddev->bitmap &&
 	    (test_bit(RT_FLAG_RS_GROW, &rs->runtime_flags) ||
 	     (rs->requested_bitmap_chunk_sectors &&
 	       mddev->bitmap_info.chunksize != to_bytes(rs->requested_bitmap_chunk_sectors)))) {
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 13cac904c5b8..bd891bec2fc7 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -904,7 +904,7 @@ static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 	if (IS_ERR(ms->io_client)) {
 		ti->error = "Error creating dm_io client";
 		kfree(ms);
- 		return NULL;
+		return NULL;
 	}
 
 	ms->rh = dm_region_hash_create(ms, dispatch_bios, wakeup_mirrord,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d5a3f73de4bf..eff611ac4ac0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -73,7 +73,7 @@ static sector_t high(struct dm_table *t, unsigned int l, unsigned int n)
 		n = get_child(n, CHILDREN_PER_NODE - 1);
 
 	if (n >= t->counts[l])
-		return (sector_t) - 1;
+		return (sector_t) -1;
 
 	return get_node(t, l, n)[KEYS_PER_NODE - 1];
 }
@@ -1530,7 +1530,7 @@ static bool dm_table_any_dev_attr(struct dm_table *t,
 		if (ti->type->iterate_devices &&
 		    ti->type->iterate_devices(ti, func, data))
 			return true;
-        }
+	}
 
 	return false;
 }
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f4de72a7d783..542927ecea9d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1181,9 +1181,9 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 	discard_parent = bio_alloc(NULL, 1, 0, GFP_NOIO);
 	discard_parent->bi_end_io = passdown_endio;
 	discard_parent->bi_private = m;
- 	if (m->maybe_shared)
- 		passdown_double_checking_shared_status(m, discard_parent);
- 	else {
+	if (m->maybe_shared)
+		passdown_double_checking_shared_status(m, discard_parent);
+	else {
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 369b2a99e459..0ccca4a87a6c 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -531,7 +531,7 @@ static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 		req.notify.context = &endio;
 
 		/* writing via async dm-io (implied by notify.fn above) won't return an error */
-	        (void) dm_io(&req, 1, &region, NULL);
+		(void) dm_io(&req, 1, &region, NULL);
 		i = j;
 	}
 
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index a542d37a9b3e..eab280c520bd 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -727,7 +727,7 @@ static int shadow_child(struct dm_btree_info *info, struct dm_btree_value_type *
  * nodes, so saves metadata space.
  */
 static int split_two_into_three(struct shadow_spine *s, unsigned int parent_index,
-                                struct dm_btree_value_type *vt, uint64_t key)
+				struct dm_btree_value_type *vt, uint64_t key)
 {
 	int r;
 	unsigned int middle_index;
@@ -782,7 +782,7 @@ static int split_two_into_three(struct shadow_spine *s, unsigned int parent_inde
 		if (shadow_current(s) != right)
 			unlock_block(s->info, right);
 
-	        return r;
+		return r;
 	}
 
 
@@ -1217,7 +1217,7 @@ int btree_get_overwrite_leaf(struct dm_btree_info *info, dm_block_t root,
 static bool need_insert(struct btree_node *node, uint64_t *keys,
 			unsigned int level, unsigned int index)
 {
-        return ((index >= le32_to_cpu(node->header.nr_entries)) ||
+	return ((index >= le32_to_cpu(node->header.nr_entries)) ||
 		(le64_to_cpu(node->keys[index]) != keys[level]));
 }
 
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index b1705e0da437..744fca4d1c34 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -391,7 +391,7 @@ int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 }
 
 int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *new_ll,
-	                         dm_block_t begin, dm_block_t end, dm_block_t *b)
+				 dm_block_t begin, dm_block_t end, dm_block_t *b)
 {
 	int r;
 	uint32_t count;
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/persistent-data/dm-space-map-common.h
index e28c12ea4a6c..292a91871d92 100644
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -121,7 +121,7 @@ int sm_ll_lookup(struct ll_disk *ll, dm_block_t b, uint32_t *result);
 int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 			  dm_block_t end, dm_block_t *result);
 int sm_ll_find_common_free_block(struct ll_disk *old_ll, struct ll_disk *new_ll,
-	                         dm_block_t begin, dm_block_t end, dm_block_t *result);
+				 dm_block_t begin, dm_block_t end, dm_block_t *result);
 
 /*
  * The next three functions return (via nr_allocations) the net number of
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

