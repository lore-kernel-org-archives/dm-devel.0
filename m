Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324C3C64EC7
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qSo4887Bx11ASEjK2z3n/yTiEF7FHdORn1MM9sQCJTo=;
	b=JqmzGjuH3uhqpxB7VUlqoq+XJvU0Rn8QJCtgNtsHKpSQfkmpExoOK3nzY+4JsB3y3kvEQg
	x4P8utQN1LmGBnalMLP9cBS9sRQWeDwO7ETmTOAcdbxMbmUWNnYi7ACqWFbAkiv6XJHro3
	EaTcDmlMnQqoVtFtNM/SEZvIAdC3eeU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-PRcVswVcMAmJjrF_bHRnSg-1; Mon, 13 Feb 2023 15:15:26 -0500
X-MC-Unique: PRcVswVcMAmJjrF_bHRnSg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 544601066544;
	Mon, 13 Feb 2023 20:15:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39863492B04;
	Mon, 13 Feb 2023 20:15:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E0CB1946595;
	Mon, 13 Feb 2023 20:15:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F8AB1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C8D71415126; Mon, 13 Feb 2023 20:15:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1244A14171B8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 703B01C087B6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:05 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-90zMnnQXNRqjUBUXGL7vyw-5; Mon, 13 Feb 2023 15:14:58 -0500
X-MC-Unique: 90zMnnQXNRqjUBUXGL7vyw-5
Received: by mail-qt1-f175.google.com with SMTP id 5so15176746qtp.9
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QEMWUkcXcV4PTU9VpSPQBdfUmFLaHGDAfjXl7F4XF0Q=;
 b=DVYRshqDtwHlyKLr+L5AetmhNzt5egxuOr3dDLnrlu7Wkr+8AZB8L1pwIgGCtrPZf+
 mFndr6nDPB/nPy/HieRu/yVzPysrcPjFvQ5wX5d34s1nBDnMq8cXtUF6NkVSdccobMCQ
 S+GOEKlCJ2MXW7uTguD8oos+RNh734JS/zfVcVXg7w9AtdNkLDLVFNDPdBQcKh528Sqr
 9IC2Cz+IG7jeF+sk5jZmICbeJtciUjw73Wbd0WFrOiwLBlLG8LzjwZutUNHntkWx8oyI
 eTcZsj0+zNzE+UwgdEEGpKOhV8i698vxi2kKnUlJOxGUvvybrMfKerD2XgJS1vmz4B2L
 rvBQ==
X-Gm-Message-State: AO0yUKWzMjLJW9JtsilHKpeprJXs5GK7bSwccjwqmENniRQYudiG7UlE
 Rniku2ja0bEw8DttZRiQSF71zTUhn8g+5mE9YceOYsX6Gcdtz9UuDmShx+4l8PpOn1JIQFsuWvB
 U3GfcLtSm1ZVl64aEXxsnQOS9LWG5FR6zxREQaenTu9gNTupVnRni5nNWIbijAHaKy5ttiQ==
X-Google-Smtp-Source: AK7set8EzNP7yOJ/VcNTZT8v2eIXBmmJCEawYoS6NPXNOIdQEkUbui3bJIDj8BM6IoYd1TLxE7uC3g==
X-Received: by 2002:ac8:5f93:0:b0:3bc:e576:c177 with SMTP id
 j19-20020ac85f93000000b003bce576c177mr6445866qta.28.1676319295990; 
 Mon, 13 Feb 2023 12:14:55 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s15-20020ac85ecf000000b003b62e8b77e7sm9741341qtx.68.2023.02.13.12.14.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:55 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:39 -0500
Message-Id: <20230213201401.45973-18-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 17/39] dm: add missing empty lines
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c                         |  9 +++
 drivers/md/dm-cache-metadata.c                |  6 ++
 drivers/md/dm-cache-policy-internal.h         |  3 +
 drivers/md/dm-cache-policy-smq.c              |  2 +
 drivers/md/dm-cache-target.c                  | 12 ++-
 drivers/md/dm-crypt.c                         |  3 +
 drivers/md/dm-era-target.c                    | 10 ++-
 drivers/md/dm-flakey.c                        |  1 +
 drivers/md/dm-integrity.c                     | 79 +++++++++++++++++--
 drivers/md/dm-io.c                            |  1 +
 drivers/md/dm-ioctl.c                         | 18 ++++-
 drivers/md/dm-kcopyd.c                        |  2 +
 drivers/md/dm-log.c                           |  6 ++
 drivers/md/dm-mpath.c                         |  3 +
 drivers/md/dm-rq.c                            |  2 +
 drivers/md/dm-snap-persistent.c               |  3 +
 drivers/md/dm-snap.c                          |  7 ++
 drivers/md/dm-stats.c                         | 13 ++-
 drivers/md/dm-sysfs.c                         |  1 +
 drivers/md/dm-thin-metadata.c                 |  1 +
 drivers/md/dm-thin.c                          |  5 ++
 drivers/md/dm-verity-target.c                 |  4 +
 drivers/md/dm-writecache.c                    | 35 ++++++--
 drivers/md/persistent-data/dm-array.c         |  4 +
 drivers/md/persistent-data/dm-bitset.c        |  1 +
 drivers/md/persistent-data/dm-block-manager.c |  7 +-
 .../md/persistent-data/dm-btree-internal.h    |  1 +
 drivers/md/persistent-data/dm-btree-remove.c  |  5 ++
 drivers/md/persistent-data/dm-btree.c         | 10 +++
 .../md/persistent-data/dm-space-map-common.c  |  6 ++
 .../md/persistent-data/dm-space-map-disk.c    |  3 +
 .../persistent-data/dm-space-map-metadata.c   |  3 +
 .../persistent-data/dm-transaction-manager.c  |  1 +
 33 files changed, 240 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 0b25dce09d39..af310bed6ba9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -628,6 +628,7 @@ static void bio_complete(struct bio *bio)
 {
 	struct dm_buffer *b = bio->bi_private;
 	blk_status_t status = bio->bi_status;
+
 	bio_uninit(bio);
 	kfree(bio);
 	b->end_io(b, status);
@@ -660,6 +661,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 
 	do {
 		unsigned int this_step = min((unsigned int)(PAGE_SIZE - offset_in_page(ptr)), len);
+
 		if (!bio_add_page(bio, virt_to_page(ptr), this_step,
 				  offset_in_page(ptr))) {
 			bio_put(bio);
@@ -782,6 +784,7 @@ static void __write_dirty_buffer(struct dm_buffer *b,
 static void __flush_write_list(struct list_head *write_list)
 {
 	struct blk_plug plug;
+
 	blk_start_plug(&plug);
 	while (!list_empty(write_list)) {
 		struct dm_buffer *b =
@@ -1179,6 +1182,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 	for (; n_blocks--; block++) {
 		int need_submit;
 		struct dm_buffer *b;
+
 		b = __bufio_new(c, block, NF_PREFETCH, &need_submit,
 				&write_list);
 		if (unlikely(!list_empty(&write_list))) {
@@ -1463,6 +1467,7 @@ void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block)
 		__link_buffer(b, new_block, LIST_DIRTY);
 	} else {
 		sector_t old_block;
+
 		wait_on_bit_lock_io(&b->state, B_WRITING,
 				    TASK_UNINTERRUPTIBLE);
 		/*
@@ -1553,6 +1558,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_size);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = bdev_nr_sectors(c->bdev);
+
 	if (s >= c->start)
 		s -= c->start;
 	else
@@ -1668,10 +1674,12 @@ static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
 	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+
 	if (likely(c->sectors_per_block_bits >= 0))
 		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
 	else
 		retain_bytes /= c->block_size;
+
 	return retain_bytes;
 }
 
@@ -1806,6 +1814,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	if (block_size <= KMALLOC_MAX_SIZE &&
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
+
 		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", block_size);
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index c4b7fec93b99..8161943fe360 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -535,6 +535,7 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 					    bool may_format_device)
 {
 	int r;
+
 	cmd->bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					  CACHE_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(cmd->bm)) {
@@ -568,6 +569,7 @@ static void update_flags(struct cache_disk_superblock *disk_super,
 			 flags_mutator mutator)
 {
 	uint32_t sb_flags = mutator(le32_to_cpu(disk_super->flags));
+
 	disk_super->flags = cpu_to_le32(sb_flags);
 }
 
@@ -732,6 +734,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 static __le64 pack_value(dm_oblock_t block, unsigned int flags)
 {
 	uint64_t value = from_oblock(block);
+
 	value <<= 16;
 	value = value | (flags & FLAGS_MASK);
 	return cpu_to_le64(value);
@@ -741,6 +744,7 @@ static void unpack_value(__le64 value_le, dm_oblock_t *block, unsigned int *flag
 {
 	uint64_t value = le64_to_cpu(value_le);
 	uint64_t b = value >> 16;
+
 	*block = to_oblock(b);
 	*flags = value & FLAGS_MASK;
 }
@@ -1254,6 +1258,7 @@ static int __insert(struct dm_cache_metadata *cmd,
 {
 	int r;
 	__le64 value = pack_value(oblock, M_VALID);
+
 	__dm_bless_for_disk(&value);
 
 	r = dm_array_set_value(&cmd->info, cmd->root, from_cblock(cblock),
@@ -1580,6 +1585,7 @@ static int __set_dirty_bits_v1(struct dm_cache_metadata *cmd, unsigned int nr_bi
 {
 	int r;
 	unsigned int i;
+
 	for (i = 0; i < nr_bits; i++) {
 		r = __dirty(cmd, to_cblock(i), test_bit(i, bits));
 		if (r)
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 22f2cc3ceb6e..d423cdd339b9 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -89,6 +89,7 @@ static inline int policy_emit_config_values(struct dm_cache_policy *p, char *res
 					    unsigned int maxlen, ssize_t *sz_ptr)
 {
 	ssize_t sz = *sz_ptr;
+
 	if (p->emit_config_values)
 		return p->emit_config_values(p, result, maxlen, sz_ptr);
 
@@ -121,12 +122,14 @@ static inline size_t bitset_size_in_bytes(unsigned int nr_entries)
 static inline unsigned long *alloc_bitset(unsigned int nr_entries)
 {
 	size_t s = bitset_size_in_bytes(nr_entries);
+
 	return vzalloc(s);
 }
 
 static inline void clear_bitset(void *bitset, unsigned int nr_entries)
 {
 	size_t s = bitset_size_in_bytes(nr_entries);
+
 	memset(bitset, 0, s);
 }
 
diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 8cb1c7c3e1e1..358d7333d0e5 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -624,6 +624,7 @@ static void __h_insert(struct smq_hash_table *ht, unsigned int bucket, struct en
 static void h_insert(struct smq_hash_table *ht, struct entry *e)
 {
 	unsigned int h = hash_64(from_oblock(e->oblock), ht->hash_bits);
+
 	__h_insert(ht, h, e);
 }
 
@@ -1633,6 +1634,7 @@ static void smq_tick(struct dm_cache_policy *p, bool can_block)
 static void smq_allow_migrations(struct dm_cache_policy *p, bool allow)
 {
 	struct smq_policy *mq = to_smq_policy(p);
+
 	mq->migrations_allowed = allow;
 }
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 94170947e7fb..a435edfb6a33 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -534,6 +534,7 @@ static unsigned int lock_level(struct bio *bio)
 static struct per_bio_data *get_per_bio_data(struct bio *bio)
 {
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+
 	BUG_ON(!pb);
 	return pb;
 }
@@ -690,6 +691,7 @@ static void clear_discard(struct cache *cache, dm_dblock_t b)
 static bool is_discarded(struct cache *cache, dm_dblock_t b)
 {
 	int r;
+
 	spin_lock_irq(&cache->lock);
 	r = test_bit(from_dblock(b), cache->discard_bitset);
 	spin_unlock_irq(&cache->lock);
@@ -700,6 +702,7 @@ static bool is_discarded(struct cache *cache, dm_dblock_t b)
 static bool is_discarded_oblock(struct cache *cache, dm_oblock_t b)
 {
 	int r;
+
 	spin_lock_irq(&cache->lock);
 	r = test_bit(from_dblock(oblock_to_dblock(cache, b)),
 		     cache->discard_bitset);
@@ -814,6 +817,7 @@ static void accounted_request(struct cache *cache, struct bio *bio)
 static void issue_op(struct bio *bio, void *context)
 {
 	struct cache *cache = context;
+
 	accounted_request(cache, bio);
 }
 
@@ -1074,6 +1078,7 @@ static void quiesce(struct dm_cache_migration *mg,
 static struct dm_cache_migration *ws_to_mg(struct work_struct *ws)
 {
 	struct continuation *k = container_of(ws, struct continuation, ws);
+
 	return container_of(k, struct dm_cache_migration, k);
 }
 
@@ -1225,6 +1230,7 @@ static void mg_complete(struct dm_cache_migration *mg, bool success)
 static void mg_success(struct work_struct *ws)
 {
 	struct dm_cache_migration *mg = ws_to_mg(ws);
+
 	mg_complete(mg, mg->k.input == 0);
 }
 
@@ -1363,6 +1369,7 @@ static void mg_copy(struct work_struct *ws)
 			 * Fallback to a real full copy after doing some tidying up.
 			 */
 			bool rb = bio_detain_shared(mg->cache, mg->op->oblock, mg->overwrite_bio);
+
 			BUG_ON(rb); /* An exclussive lock must _not_ be held for this block */
 			mg->overwrite_bio = NULL;
 			inc_io_migrations(mg->cache);
@@ -1465,12 +1472,15 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 static void invalidate_completed(struct work_struct *ws)
 {
 	struct dm_cache_migration *mg = ws_to_mg(ws);
+
 	invalidate_complete(mg, !mg->k.input);
 }
 
 static int invalidate_cblock(struct cache *cache, dm_cblock_t cblock)
 {
-	int r = policy_invalidate_mapping(cache->policy, cblock);
+	int r;
+
+	r = policy_invalidate_mapping(cache->policy, cblock);
 	if (!r) {
 		r = dm_cache_remove_mapping(cache->cmd, cblock);
 		if (r) {
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 168f49e20beb..d7c0d54bf212 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1257,6 +1257,7 @@ static __le64 *org_sector_of_dmreq(struct crypt_config *cc,
 		       struct dm_crypt_request *dmreq)
 {
 	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size + cc->iv_size;
+
 	return (__le64 *) ptr;
 }
 
@@ -1265,6 +1266,7 @@ static unsigned int *org_tag_of_dmreq(struct crypt_config *cc,
 {
 	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size +
 		  cc->iv_size + sizeof(uint64_t);
+
 	return (unsigned int *)ptr;
 }
 
@@ -1741,6 +1743,7 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
 static void kcryptd_io_bio_endio(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+
 	bio_endio(io->base_bio);
 }
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index a42cfd950e04..f8f7994f4f27 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -112,13 +112,14 @@ static int writeset_marked_on_disk(struct dm_disk_bitset *info,
 				   struct writeset_metadata *m, dm_block_t block,
 				   bool *result)
 {
+	int r;
 	dm_block_t old = m->root;
 
 	/*
 	 * The bitset was flushed when it was archived, so we know there'll
 	 * be no change to the root.
 	 */
-	int r = dm_bitset_test_bit(info, m->root, block, &m->root, result);
+	r = dm_bitset_test_bit(info, m->root, block, &m->root, result);
 	if (r) {
 		DMERR("%s: dm_bitset_test_bit failed", __func__);
 		return r;
@@ -210,6 +211,7 @@ static void sb_prepare_for_write(struct dm_block_validator *v,
 static int check_metadata_version(struct superblock_disk *disk)
 {
 	uint32_t metadata_version = le32_to_cpu(disk->version);
+
 	if (metadata_version < MIN_ERA_VERSION || metadata_version > MAX_ERA_VERSION) {
 		DMERR("Era metadata version %u found, but only versions between %u and %u supported.",
 		      metadata_version, MIN_ERA_VERSION, MAX_ERA_VERSION);
@@ -409,6 +411,7 @@ static int ws_eq(void *context, const void *value1, const void *value2)
 static void setup_writeset_tree_info(struct era_metadata *md)
 {
 	struct dm_btree_value_type *vt = &md->writeset_tree_info.value_type;
+
 	md->writeset_tree_info.tm = md->tm;
 	md->writeset_tree_info.levels = 1;
 	vt->context = md;
@@ -419,9 +422,9 @@ static void setup_writeset_tree_info(struct era_metadata *md)
 }
 
 static void setup_era_array_info(struct era_metadata *md)
-
 {
 	struct dm_btree_value_type vt;
+
 	vt.context = NULL;
 	vt.size = sizeof(__le32);
 	vt.inc = NULL;
@@ -1391,6 +1394,7 @@ static int perform_rpc(struct era *era, struct rpc *rpc)
 static int in_worker0(struct era *era, int (*fn)(struct era_metadata *md))
 {
 	struct rpc rpc;
+
 	rpc.fn0 = fn;
 	rpc.fn1 = NULL;
 
@@ -1401,6 +1405,7 @@ static int in_worker1(struct era *era,
 		      int (*fn)(struct era_metadata *md, void *ref), void *arg)
 {
 	struct rpc rpc;
+
 	rpc.fn0 = NULL;
 	rpc.fn1 = fn;
 	rpc.arg = arg;
@@ -1712,6 +1717,7 @@ static int era_iterate_devices(struct dm_target *ti,
 			       iterate_devices_callout_fn fn, void *data)
 {
 	struct era *era = ti->private;
+
 	return fn(ti, era->origin_dev, 0, get_dev_size(era->origin_dev), data);
 }
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 26ef181ac4dd..cf042804b896 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -327,6 +327,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 	unsigned int elapsed;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+
 	pb->bio_submitted = false;
 
 	if (op_is_zone_mgmt(bio_op(bio)))
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index f650e540a09e..6a9c11abc5e3 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -346,6 +346,7 @@ static struct kmem_cache *journal_io_cache;
 static void __DEBUG_bytes(__u8 *bytes, size_t len, const char *msg, ...)
 {
 	va_list args;
+
 	va_start(args, msg);
 	vprintk(msg, args);
 	va_end(args);
@@ -538,6 +539,7 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
 		}
 	} else {
 		__u8 result[HASH_MAX_DIGESTSIZE];
+
 		r = crypto_shash_final(desc, result);
 		if (unlikely(r < 0)) {
 			dm_integrity_io_error(ic, "crypto_shash_final", r);
@@ -713,6 +715,7 @@ static void block_bitmap_copy(struct dm_integrity_c *ic, struct page_list *dst,
 	for (i = 0; i < n_bitmap_pages; i++) {
 		unsigned long *dst_data = lowmem_page_address(dst[i].page);
 		unsigned long *src_data = lowmem_page_address(src[i].page);
+
 		copy_page(dst_data, src_data);
 	}
 }
@@ -833,6 +836,7 @@ static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 re
 
 	for (j = 0; j < ic->journal_section_entries; j++) {
 		struct journal_entry *je = access_journal_entry(ic, section, j);
+
 		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof je->u.sector);
 		if (unlikely(r < 0)) {
 			dm_integrity_io_error(ic, "crypto_shash_update", r);
@@ -896,6 +900,7 @@ static void rw_section_mac(struct dm_integrity_c *ic, unsigned int section, bool
 static void complete_journal_op(void *context)
 {
 	struct journal_completion *comp = context;
+
 	BUG_ON(!atomic_read(&comp->in_flight));
 	if (likely(atomic_dec_and_test(&comp->in_flight)))
 		complete(&comp->comp);
@@ -932,6 +937,7 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
 
 		while (unlikely(pl_index == section_index)) {
 			unsigned int dummy;
+
 			if (likely(encrypt))
 				rw_section_mac(ic, section, true);
 			section++;
@@ -961,6 +967,7 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
 static void complete_journal_encrypt(struct crypto_async_request *req, int err)
 {
 	struct journal_completion *comp = req->data;
+
 	if (unlikely(err)) {
 		if (likely(err == -EINPROGRESS)) {
 			complete(&comp->ic->crypto_backoff);
@@ -974,6 +981,7 @@ static void complete_journal_encrypt(struct crypto_async_request *req, int err)
 static bool do_crypt(bool encrypt, struct skcipher_request *req, struct journal_completion *comp)
 {
 	int r;
+
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      complete_journal_encrypt, comp);
 	if (likely(encrypt))
@@ -1049,6 +1057,7 @@ static void encrypt_journal(struct dm_integrity_c *ic, bool encrypt, unsigned in
 static void complete_journal_io(unsigned long error, void *context)
 {
 	struct journal_completion *comp = context;
+
 	if (unlikely(error != 0))
 		dm_integrity_io_error(comp->ic, "writing journal", -EIO);
 	complete_journal_op(comp);
@@ -1139,6 +1148,7 @@ static void write_journal(struct dm_integrity_c *ic, unsigned int commit_start,
 			   commit_sections, &io_comp);
 	} else {
 		unsigned int to_end;
+
 		io_comp.in_flight = (atomic_t)ATOMIC_INIT(2);
 		to_end = ic->journal_sections - commit_start;
 		if (ic->journal_io) {
@@ -1228,6 +1238,7 @@ static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *
 
 	if (likely(check_waiting)) {
 		struct dm_integrity_range *range;
+
 		list_for_each_entry(range, &ic->wait_list, wait_entry) {
 			if (unlikely(ranges_overlap(range, new_range)))
 				return false;
@@ -1262,6 +1273,7 @@ static void remove_range_unlocked(struct dm_integrity_c *ic, struct dm_integrity
 		struct dm_integrity_range *last_range =
 			list_first_entry(&ic->wait_list, struct dm_integrity_range, wait_entry);
 		struct task_struct *last_range_task;
+
 		last_range_task = last_range->task;
 		list_del(&last_range->wait_entry);
 		if (!add_new_range(ic, last_range, false)) {
@@ -1321,6 +1333,7 @@ static void add_journal_node(struct dm_integrity_c *ic, struct journal_node *nod
 
 	while (*link) {
 		struct journal_node *j;
+
 		parent = *link;
 		j = container_of(parent, struct journal_node, node);
 		if (sector < j->sector)
@@ -1346,9 +1359,11 @@ static unsigned int find_journal_node(struct dm_integrity_c *ic, sector_t sector
 {
 	struct rb_node *n = ic->journal_tree_root.rb_node;
 	unsigned int found = NOT_FOUND;
+
 	*next_sector = (sector_t)-1;
 	while (n) {
 		struct journal_node *j = container_of(n, struct journal_node, node);
+
 		if (sector == j->sector) {
 			found = j - ic->journal_tree;
 		}
@@ -1508,6 +1523,7 @@ struct flush_request {
 static void flush_notify(unsigned long error, void *fr_)
 {
 	struct flush_request *fr = fr_;
+
 	if (unlikely(error != 0))
 		dm_integrity_io_error(fr->ic, "flushing disk cache", -EIO);
 	complete(&fr->comp);
@@ -1516,7 +1532,6 @@ static void flush_notify(unsigned long error, void *fr_)
 static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_data)
 {
 	int r;
-
 	struct flush_request fr;
 
 	if (!ic->meta_dev)
@@ -1548,6 +1563,7 @@ static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_dat
 static void sleep_on_endio_wait(struct dm_integrity_c *ic)
 {
 	DECLARE_WAITQUEUE(wait, current);
+
 	__add_wait_queue(&ic->endio_wait, &wait);
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	spin_unlock_irq(&ic->endio_wait.lock);
@@ -1585,11 +1601,14 @@ static void submit_flush_bio(struct dm_integrity_c *ic, struct dm_integrity_io *
 
 static void do_endio(struct dm_integrity_c *ic, struct bio *bio)
 {
-	int r = dm_integrity_failed(ic);
+	int r;
+
+	r = dm_integrity_failed(ic);
 	if (unlikely(r) && !bio->bi_status)
 		bio->bi_status = errno_to_blk_status(r);
 	if (unlikely(ic->synchronous_mode) && bio_op(bio) == REQ_OP_WRITE) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&ic->endio_wait.lock, flags);
 		bio_list_add(&ic->synchronous_bios, bio);
 		queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
@@ -1621,7 +1640,6 @@ static void dec_in_flight(struct dm_integrity_io *dio)
 			schedule_autocommit(ic);
 
 		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
-
 		if (unlikely(dio->bi_status) && !bio->bi_status)
 			bio->bi_status = dio->bi_status;
 		if (likely(!bio->bi_status) && unlikely(bio_sectors(bio) != dio->range.n_sectors)) {
@@ -1741,10 +1759,12 @@ static void integrity_metadata(struct work_struct *w)
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
 			unsigned int max_blocks = max_size / ic->tag_size;
+
 			memset(checksums, DISCARD_FILLER, max_size);
 
 			while (bi_size) {
 				unsigned int this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
+
 				this_step_blocks = min(this_step_blocks, max_blocks);
 				r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 							this_step_blocks * ic->tag_size, TAG_WRITE);
@@ -1820,6 +1840,7 @@ static void integrity_metadata(struct work_struct *w)
 			struct bio_vec biv;
 			struct bvec_iter iter;
 			unsigned int data_to_process = dio->range.n_sectors;
+
 			sector_to_block(ic, data_to_process);
 			data_to_process *= ic->tag_size;
 
@@ -1866,8 +1887,10 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 			unsigned int log2_max_io_len = __fls(ti->max_io_len);
 			sector_t start_boundary = sec >> log2_max_io_len;
 			sector_t end_boundary = (sec + bio_sectors(bio) - 1) >> log2_max_io_len;
+
 			if (start_boundary < end_boundary) {
 				sector_t len = ti->max_io_len - (sec & (ti->max_io_len - 1));
+
 				dm_accept_partial_bio(bio, len);
 			}
 		}
@@ -1903,6 +1926,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	if (ic->sectors_per_block > 1 && likely(dio->op != REQ_OP_DISCARD)) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
+
 		bio_for_each_segment(bv, bio, iter) {
 			if (unlikely(bv.bv_len & ((ic->sectors_per_block << SECTOR_SHIFT) - 1))) {
 				DMERR("Bio vector (%u,%u) is not aligned on %u-sector boundary",
@@ -1916,6 +1940,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	if (!ic->internal_hash) {
 		if (bip) {
 			unsigned int wanted_tag_size = bio_sectors(bio) >> ic->sb->log2_sectors_per_block;
+
 			if (ic->log2_tag_size >= 0)
 				wanted_tag_size <<= ic->log2_tag_size;
 			else
@@ -2017,6 +2042,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 						struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
 						unsigned int tag_now = min(biv.bv_len, tag_todo);
 						char *tag_addr;
+
 						BUG_ON(PageHighMem(biv.bv_page));
 						tag_addr = bvec_virt(&biv);
 						if (likely(dio->op == REQ_OP_WRITE))
@@ -2045,8 +2071,10 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 
 				if (ic->internal_hash) {
 					unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
+
 						integrity_sector_checksum(ic, logical_sector, (char *)js, checksums_onstack);
 						memcpy(journal_entry_tag(ic, je), checksums_onstack, ic->tag_size);
 					} else
@@ -2106,6 +2134,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	struct completion read_comp;
 	bool discard_retried = false;
 	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
+
 	if (unlikely(dio->op == REQ_OP_DISCARD) && ic->mode != 'D')
 		need_sync_io = true;
 
@@ -2176,6 +2205,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 			goto journal_read_write;
 		} else {
 			sector_t next_sector;
+
 			journal_read_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 			if (likely(journal_read_pos == NOT_FOUND)) {
 				if (unlikely(dio->range.n_sectors > next_sector - dio->range.logical_sector))
@@ -2183,6 +2213,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 			} else {
 				unsigned int i;
 				unsigned int jp = journal_read_pos + 1;
+
 				for (i = ic->sectors_per_block; i < dio->range.n_sectors; i += ic->sectors_per_block, jp++) {
 					if (!test_journal_node(ic, jp, dio->range.logical_sector + i))
 						break;
@@ -2214,7 +2245,9 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 		 */
 		if (journal_read_pos != NOT_FOUND) {
 			sector_t next_sector;
-			unsigned int new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+			unsigned int new_pos;
+
+			new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 			if (unlikely(new_pos != journal_read_pos)) {
 				remove_range_unlocked(ic, &dio->range);
 				goto retry;
@@ -2223,7 +2256,9 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	}
 	if (ic->mode == 'J' && likely(dio->op == REQ_OP_DISCARD) && !discard_retried) {
 		sector_t next_sector;
-		unsigned int new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+		unsigned int new_pos;
+
+		new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 		if (unlikely(new_pos != NOT_FOUND) ||
 		    unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
 			remove_range_unlocked(ic, &dio->range);
@@ -2377,11 +2412,13 @@ static void integrity_commit(struct work_struct *w)
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
 			struct journal_entry *je;
+
 			je = access_journal_entry(ic, i, j);
 			io_wait_event(ic->copy_to_journal_wait, !journal_entry_is_inprogress(je));
 		}
 		for (j = 0; j < ic->journal_section_sectors; j++) {
 			struct journal_sector *js;
+
 			js = access_journal(ic, i, j);
 			js->commit_id = dm_integrity_commit_id(ic, i, j, ic->commit_seq);
 		}
@@ -2407,6 +2444,7 @@ static void integrity_commit(struct work_struct *w)
 release_flush_bios:
 	while (flushes) {
 		struct bio *next = flushes->bi_next;
+
 		flushes->bi_next = NULL;
 		do_endio(ic, flushes);
 		flushes = next;
@@ -2418,6 +2456,7 @@ static void complete_copy_from_journal(unsigned long error, void *context)
 	struct journal_io *io = context;
 	struct journal_completion *comp = io->comp;
 	struct dm_integrity_c *ic = comp->ic;
+
 	remove_range(ic, &io->range);
 	mempool_free(io, &ic->journal_io_mempool);
 	if (unlikely(error != 0))
@@ -2429,6 +2468,7 @@ static void restore_last_bytes(struct dm_integrity_c *ic, struct journal_sector
 			       struct journal_entry *je)
 {
 	unsigned int s = 0;
+
 	do {
 		js->commit_id = je->last_bytes[s];
 		js++;
@@ -2481,6 +2521,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 			for (k = j + 1; k < ic->journal_section_entries; k++) {
 				struct journal_entry *je2 = access_journal_entry(ic, i, k);
 				sector_t sec2, area2, offset2;
+
 				if (journal_entry_is_unused(je2))
 					break;
 				BUG_ON(unlikely(journal_entry_is_inprogress(je2)) && !from_replay);
@@ -2586,7 +2627,6 @@ static void integrity_writer(struct work_struct *w)
 {
 	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, writer_work);
 	unsigned int write_start, write_sections;
-
 	unsigned int prev_free_sectors;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2732,6 +2772,7 @@ static void integrity_recalc(struct work_struct *w)
 
 	if (ic->mode == 'B') {
 		sector_t start, end;
+
 		start = (range.logical_sector >>
 			 (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)) <<
 			(ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
@@ -2867,12 +2908,14 @@ static void init_journal(struct dm_integrity_c *ic, unsigned int start_section,
 		wraparound_section(ic, &i);
 		for (j = 0; j < ic->journal_section_sectors; j++) {
 			struct journal_sector *js = access_journal(ic, i, j);
+
 			BUILD_BUG_ON(sizeof(js->sectors) != JOURNAL_SECTOR_DATA);
 			memset(&js->sectors, 0, sizeof(js->sectors));
 			js->commit_id = dm_integrity_commit_id(ic, i, j, commit_seq);
 		}
 		for (j = 0; j < ic->journal_section_entries; j++) {
 			struct journal_entry *je = access_journal_entry(ic, i, j);
+
 			journal_entry_set_unused(je);
 		}
 	}
@@ -2883,6 +2926,7 @@ static void init_journal(struct dm_integrity_c *ic, unsigned int start_section,
 static int find_commit_seq(struct dm_integrity_c *ic, unsigned int i, unsigned int j, commit_id_t id)
 {
 	unsigned char k;
+
 	for (k = 0; k < N_COMMIT_IDS; k++) {
 		if (dm_integrity_commit_id(ic, i, j, k) == id)
 			return k;
@@ -2917,6 +2961,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 			DEBUG_bytes(lowmem_page_address(ic->journal_io[0].page), 64, "read journal");
 		if (ic->journal_io) {
 			struct journal_completion crypt_comp;
+
 			crypt_comp.ic = ic;
 			init_completion(&crypt_comp.comp);
 			crypt_comp.in_flight = (atomic_t)ATOMIC_INIT(0);
@@ -2936,6 +2981,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 		for (j = 0; j < ic->journal_section_sectors; j++) {
 			int k;
 			struct journal_sector *js = access_journal(ic, i, j);
+
 			k = find_commit_seq(ic, i, j, js->commit_id);
 			if (k < 0)
 				goto clear_journal;
@@ -2945,6 +2991,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 		if (journal_empty) {
 			for (j = 0; j < ic->journal_section_entries; j++) {
 				struct journal_entry *je = access_journal_entry(ic, i, j);
+
 				if (!journal_entry_is_unused(je)) {
 					journal_empty = false;
 					break;
@@ -3017,6 +3064,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 	} else {
 		unsigned int s;
 		unsigned char erase_seq;
+
 clear_journal:
 		DEBUG_print("clearing journal\n");
 
@@ -3226,6 +3274,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 	DEBUG_print("testing recalc: %x\n", ic->sb->flags);
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 		__u64 recalc_pos = le64_to_cpu(ic->sb->recalc_sector);
+
 		DEBUG_print("recalc pos: %llx / %llx\n", recalc_pos, ic->provided_data_sectors);
 		if (recalc_pos < ic->provided_data_sectors) {
 			queue_work(ic->recalc_wq, &ic->recalc_work);
@@ -3266,6 +3315,7 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 
 	case STATUSTYPE_TABLE: {
 		__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
+
 		watermark_percentage += ic->journal_entries / 2;
 		do_div(watermark_percentage, ic->journal_entries);
 		arg_count = 3;
@@ -3425,6 +3475,7 @@ static int calculate_device_limits(struct dm_integrity_c *ic)
 			return -EINVAL;
 	} else {
 		__u64 meta_size = (ic->provided_data_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+
 		meta_size = (meta_size + ((1U << (ic->log2_buffer_sectors + SECTOR_SHIFT)) - 1))
 				>> (ic->log2_buffer_sectors + SECTOR_SHIFT);
 		meta_size <<= ic->log2_buffer_sectors;
@@ -3442,6 +3493,7 @@ static void get_provided_data_sectors(struct dm_integrity_c *ic)
 {
 	if (!ic->meta_dev) {
 		int test_bit;
+
 		ic->provided_data_sectors = 0;
 		for (test_bit = fls64(ic->meta_device_sectors) - 1; test_bit >= 3; test_bit--) {
 			__u64 prev_data_sectors = ic->provided_data_sectors;
@@ -3504,6 +3556,7 @@ static int initialize_superblock(struct dm_integrity_c *ic,
 		for (test_bit = fls(journal_sections) - 1; test_bit >= 0; test_bit--) {
 			__u32 prev_journal_sections = le32_to_cpu(ic->sb->journal_sections);
 			__u32 test_journal_sections = prev_journal_sections | (1U << test_bit);
+
 			if (test_journal_sections > journal_sections)
 				continue;
 			ic->sb->journal_sections = cpu_to_le32(test_journal_sections);
@@ -3580,6 +3633,7 @@ static struct page_list *dm_integrity_alloc_page_list(unsigned int n_pages)
 static void dm_integrity_free_journal_scatterlist(struct dm_integrity_c *ic, struct scatterlist **sl)
 {
 	unsigned int i;
+
 	for (i = 0; i < ic->journal_sections; i++)
 		kvfree(sl[i]);
 	kvfree(sl);
@@ -3621,6 +3675,7 @@ static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_int
 		for (idx = start_index; idx <= end_index; idx++) {
 			char *va = lowmem_page_address(pl[idx].page);
 			unsigned int start = 0, end = PAGE_SIZE;
+
 			if (idx == start_index)
 				start = start_offset;
 			if (idx == end_index)
@@ -3801,6 +3856,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 			sg_init_table(sg, ic->journal_pages + 1);
 			for (i = 0; i < ic->journal_pages; i++) {
 				char *va = lowmem_page_address(ic->journal_xor[i].page);
+
 				clear_page(va);
 				sg_set_buf(&sg[i], va, PAGE_SIZE);
 			}
@@ -3912,6 +3968,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 
 	for (i = 0; i < N_COMMIT_IDS; i++) {
 		unsigned int j;
+
 retest_commit_id:
 		for (j = 0; j < i; j++) {
 			if (ic->commit_ids[j] == ic->commit_ids[i]) {
@@ -4056,6 +4113,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		const char *opt_string;
 		unsigned int val;
 		unsigned long long llval;
+
 		opt_string = dm_shift_arg(&as);
 		if (!opt_string) {
 			r = -EINVAL;
@@ -4405,6 +4463,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 
 	if (ic->internal_hash) {
 		size_t recalc_tags_size;
+
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq) {
 			ti->error = "Cannot allocate workqueue";
@@ -4519,7 +4578,9 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			goto bad;
 	}
 	if (ic->mode == 'B') {
-		unsigned int max_io_len = ((sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit) * (BITMAP_BLOCK_SIZE * 8);
+		unsigned int max_io_len;
+
+		max_io_len = ((sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit) * (BITMAP_BLOCK_SIZE * 8);
 		if (!max_io_len)
 			max_io_len = 1U << 31;
 		DEBUG_print("max_io_len: old %u, new %u\n", ti->max_io_len, max_io_len);
@@ -4593,7 +4654,9 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		unsigned int i;
 
 		for (i = 0; i < ic->journal_sections; i++) {
-			struct skcipher_request *req = ic->sk_requests[i];
+			struct skcipher_request *req;
+
+			req = ic->sk_requests[i];
 			if (req) {
 				kfree_sensitive(req->iv);
 				skcipher_request_free(req);
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1c04cc9787d1..faa8d0e1b460 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -197,6 +197,7 @@ static void list_get_page(struct dpages *dp,
 static void list_next_page(struct dpages *dp)
 {
 	struct page_list *pl = (struct page_list *) dp->context_ptr;
+
 	dp->context_ptr = pl->next;
 	dp->context_u = 0;
 }
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e73615c57561..2e2777d502aa 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -92,7 +92,9 @@ static struct hash_cell *__get_name_cell(const char *str)
 
 	while (n) {
 		struct hash_cell *hc = container_of(n, struct hash_cell, name_node);
-		int c = strcmp(hc->name, str);
+		int c;
+
+		c = strcmp(hc->name, str);
 		if (!c) {
 			dm_get(hc->md);
 			return hc;
@@ -109,7 +111,9 @@ static struct hash_cell *__get_uuid_cell(const char *str)
 
 	while (n) {
 		struct hash_cell *hc = container_of(n, struct hash_cell, uuid_node);
-		int c = strcmp(hc->uuid, str);
+		int c;
+
+		c = strcmp(hc->uuid, str);
 		if (!c) {
 			dm_get(hc->md);
 			return hc;
@@ -149,7 +153,9 @@ static void __link_name(struct hash_cell *new_hc)
 
 	while (*n) {
 		struct hash_cell *hc = container_of(*n, struct hash_cell, name_node);
-		int c = strcmp(hc->name, new_hc->name);
+		int c;
+
+		c = strcmp(hc->name, new_hc->name);
 		BUG_ON(!c);
 		parent = *n;
 		n = c >= 0 ? &hc->name_node.rb_left : &hc->name_node.rb_right;
@@ -172,7 +178,9 @@ static void __link_uuid(struct hash_cell *new_hc)
 
 	while (*n) {
 		struct hash_cell *hc = container_of(*n, struct hash_cell, uuid_node);
-		int c = strcmp(hc->uuid, new_hc->uuid);
+		int c;
+
+		c = strcmp(hc->uuid, new_hc->uuid);
 		BUG_ON(!c);
 		parent = *n;
 		n = c > 0 ? &hc->uuid_node.rb_left : &hc->uuid_node.rb_right;
@@ -621,6 +629,7 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 	 */
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
 		void *uuid_ptr;
+
 		hc = container_of(n, struct hash_cell, name_node);
 		if (!filter_device(hc, param->name, param->uuid))
 			continue;
@@ -848,6 +857,7 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 
 	if (param->flags & DM_QUERY_INACTIVE_TABLE_FLAG) {
 		int srcu_idx;
+
 		table = dm_get_inactive_table(md, &srcu_idx);
 		if (table) {
 			if (!(dm_table_get_mode(table) & FMODE_WRITE))
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 088746578e7b..0027349aa6be 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -151,6 +151,7 @@ static void io_job_start(struct dm_kcopyd_throttle *t)
 
 	if (unlikely(t->total_period >= (1 << ACCOUNT_INTERVAL_SHIFT))) {
 		int shift = fls(t->total_period >> ACCOUNT_INTERVAL_SHIFT);
+
 		t->total_period >>= shift;
 		t->io_period >>= shift;
 	}
@@ -678,6 +679,7 @@ static void do_work(struct work_struct *work)
 static void dispatch_job(struct kcopyd_job *job)
 {
 	struct dm_kcopyd_client *kc = job->kc;
+
 	atomic_inc(&kc->nr_jobs);
 	if (unlikely(!job->source.count))
 		push(&kc->callback_jobs, job);
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index a58d8ef97020..9683d683396e 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -655,12 +655,14 @@ static int disk_resume(struct dm_dirty_log *log)
 static uint32_t core_get_region_size(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	return lc->region_size;
 }
 
 static int core_resume(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	lc->sync_search = 0;
 	return 0;
 }
@@ -668,12 +670,14 @@ static int core_resume(struct dm_dirty_log *log)
 static int core_is_clean(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	return log_test_bit(lc->clean_bits, region);
 }
 
 static int core_in_sync(struct dm_dirty_log *log, region_t region, int block)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	return log_test_bit(lc->sync_bits, region);
 }
 
@@ -726,12 +730,14 @@ static int disk_flush(struct dm_dirty_log *log)
 static void core_mark_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	log_clear_bit(lc, lc->clean_bits, region);
 }
 
 static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	if (likely(!lc->flush_failed))
 		log_set_bit(lc, lc->clean_bits, region);
 }
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e59f67d72ac2..9669162a38ae 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -137,6 +137,7 @@ static bool mpath_double_check_test_bit(int MPATHF_bit, struct multipath *m)
 
 	if (r) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&m->lock, flags);
 		r = test_bit(MPATHF_bit, &m->flags);
 		spin_unlock_irqrestore(&m->lock, flags);
@@ -711,6 +712,7 @@ static void process_queued_bios(struct work_struct *work)
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(&bios))) {
 		struct dm_mpath_io *mpio = get_mpio_from_bio(bio);
+
 		dm_bio_restore(get_bio_details_from_mpio(mpio), bio);
 		r = __multipath_map_bio(m, bio, mpio);
 		switch (r) {
@@ -2122,6 +2124,7 @@ static int multipath_busy(struct dm_target *ti)
 	/* no paths available, for blk-mq: rely on IO mapping to delay requeue */
 	if (!atomic_read(&m->nr_valid_paths)) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&m->lock, flags);
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			spin_unlock_irqrestore(&m->lock, flags);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 073fb5f1b93d..d5f368965d3b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -128,6 +128,7 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
 {
 	if (unlikely(dm_stats_used(&md->stats))) {
 		struct dm_rq_target_io *tio = tio_from_request(orig);
+
 		tio->duration_jiffies = jiffies - tio->duration_jiffies;
 		dm_stats_account_io(&md->stats, rq_data_dir(orig),
 				    blk_rq_pos(orig), tio->n_sectors, true,
@@ -435,6 +436,7 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 
 	if (unlikely(dm_stats_used(&md->stats))) {
 		struct dm_rq_target_io *tio = tio_from_request(orig);
+
 		tio->duration_jiffies = jiffies;
 		tio->n_sectors = blk_rq_sectors(orig);
 		dm_stats_account_io(&md->stats, rq_data_dir(orig),
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 7d8232b6935f..9258d8bc472d 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -276,6 +276,7 @@ static void skip_metadata(struct pstore *ps)
 {
 	uint32_t stride = ps->exceptions_per_area + 1;
 	chunk_t next_free = ps->next_free;
+
 	if (sector_div(next_free, stride) == NUM_SNAPSHOT_HDR_CHUNKS)
 		ps->next_free++;
 }
@@ -521,6 +522,7 @@ static int read_exceptions(struct pstore *ps,
 		if (DM_PREFETCH_CHUNKS) {
 			do {
 				chunk_t pf_chunk = area_location(ps, prefetch_area);
+
 				if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
 					break;
 				dm_bufio_prefetch(client, pf_chunk, 1);
@@ -879,6 +881,7 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 
 	if (options) {
 		char overflow = toupper(options[0]);
+
 		if (overflow == 'O')
 			store->userspace_supports_overflow = true;
 		else {
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3ae7b6d7b210..fee741b20e78 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -245,12 +245,14 @@ struct dm_snap_tracked_chunk {
 static void init_tracked_chunk(struct bio *bio)
 {
 	struct dm_snap_tracked_chunk *c = dm_per_bio_data(bio, sizeof(struct dm_snap_tracked_chunk));
+
 	INIT_HLIST_NODE(&c->node);
 }
 
 static bool is_bio_tracked(struct bio *bio)
 {
 	struct dm_snap_tracked_chunk *c = dm_per_bio_data(bio, sizeof(struct dm_snap_tracked_chunk));
+
 	return !hlist_unhashed(&c->node);
 }
 
@@ -399,6 +401,7 @@ static struct origin *__lookup_origin(struct block_device *origin)
 static void __insert_origin(struct origin *o)
 {
 	struct list_head *sl = &_origins[origin_hash(o->bdev)];
+
 	list_add_tail(&o->hash_list, sl);
 }
 
@@ -418,6 +421,7 @@ static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
 static void __insert_dm_origin(struct dm_origin *o)
 {
 	struct list_head *sl = &_dm_origins[origin_hash(o->dev->bdev)];
+
 	list_add_tail(&o->hash_list, sl);
 }
 
@@ -868,6 +872,7 @@ static int calc_max_buckets(void)
 {
 	/* use a fixed size of 2MB */
 	unsigned long mem = 2 * 1024 * 1024;
+
 	mem /= sizeof(struct hlist_bl_head);
 
 	return mem;
@@ -1552,6 +1557,7 @@ static bool wait_for_in_progress(struct dm_snapshot *s, bool unlock_origins)
 			 * throttling is unlikely to negatively impact performance.
 			 */
 			DECLARE_WAITQUEUE(wait, current);
+
 			__add_wait_queue(&s->in_progress_wait, &wait);
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			spin_unlock(&s->in_progress_wait.lock);
@@ -2567,6 +2573,7 @@ static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit)
 	if (o) {
 		if (limit) {
 			struct dm_snapshot *s;
+
 			list_for_each_entry(s, &o->snapshots, list)
 				if (unlikely(!wait_for_in_progress(s, true)))
 					goto again;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 3287c0a9dd04..8937bfbdcdc1 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -336,6 +336,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 
 	if (s->n_histogram_entries) {
 		unsigned long long *hi;
+
 		hi = dm_kvzalloc(s->histogram_alloc_size, NUMA_NO_NODE);
 		if (!hi) {
 			r = -ENOMEM;
@@ -357,6 +358,7 @@ static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 		s->stat_percpu[cpu] = p;
 		if (s->n_histogram_entries) {
 			unsigned long long *hi;
+
 			hi = dm_kvzalloc(s->histogram_alloc_size, cpu_to_node(cpu));
 			if (!hi) {
 				r = -ENOMEM;
@@ -495,6 +497,7 @@ static int dm_stats_list(struct dm_stats *stats, const char *program,
 				DMEMIT(" precise_timestamps");
 			if (s->n_histogram_entries) {
 				unsigned int i;
+
 				DMEMIT(" histogram:");
 				for (i = 0; i < s->n_histogram_entries; i++) {
 					if (i)
@@ -567,6 +570,7 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 	 */
 #if BITS_PER_LONG == 32
 	unsigned long flags;
+
 	local_irq_save(flags);
 #else
 	preempt_disable();
@@ -578,6 +582,7 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 		atomic_inc(&shared->in_flight[idx]);
 	} else {
 		unsigned long long duration;
+
 		dm_stat_round(s, shared, p);
 		atomic_dec(&shared->in_flight[idx]);
 		p->sectors[idx] += len;
@@ -592,8 +597,10 @@ static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
 		}
 		if (s->n_histogram_entries) {
 			unsigned int lo = 0, hi = s->n_histogram_entries + 1;
+
 			while (lo + 1 < hi) {
 				unsigned int mid = (lo + hi) / 2;
+
 				if (s->histogram_boundaries[mid - 1] > duration) {
 					hi = mid;
 				} else {
@@ -741,6 +748,7 @@ static void __dm_stat_init_temporary_percpu_totals(struct dm_stat_shared *shared
 		shared->tmp.time_in_queue += READ_ONCE(p->time_in_queue);
 		if (s->n_histogram_entries) {
 			unsigned int i;
+
 			for (i = 0; i < s->n_histogram_entries + 1; i++)
 				shared->tmp.histogram[i] += READ_ONCE(p->histogram[i]);
 		}
@@ -775,6 +783,7 @@ static void __dm_stat_clear(struct dm_stat *s, size_t idx_start, size_t idx_end,
 		local_irq_enable();
 		if (s->n_histogram_entries) {
 			unsigned int i;
+
 			for (i = 0; i < s->n_histogram_entries + 1; i++) {
 				local_irq_disable();
 				p = &s->stat_percpu[smp_processor_id()][x];
@@ -890,6 +899,7 @@ static int dm_stats_print(struct dm_stats *stats, int id,
 		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
 		if (s->n_histogram_entries) {
 			unsigned int i;
+
 			for (i = 0; i < s->n_histogram_entries + 1; i++) {
 				DMEMIT("%s%llu", !i ? " " : ":", shared->tmp.histogram[i]);
 			}
@@ -962,6 +972,7 @@ static int parse_histogram(const char *h, unsigned int *n_histogram_entries,
 		unsigned long long hi;
 		int s;
 		char ch;
+
 		s = sscanf(h, "%llu%c", &hi, &ch);
 		if (!s || (s == 2 && ch != ','))
 			return -EINVAL;
@@ -987,10 +998,8 @@ static int message_stats_create(struct mapped_device *md,
 	unsigned int divisor;
 	const char *program_id, *aux_data;
 	unsigned int stat_flags = 0;
-
 	unsigned int n_histogram_entries = 0;
 	unsigned long long *histogram_boundaries = NULL;
-
 	struct dm_arg_set as, as_backup;
 	const char *a;
 	unsigned int feature_args;
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index a884401f0ca6..c090cb184093 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -143,6 +143,7 @@ int dm_sysfs_init(struct mapped_device *md)
 void dm_sysfs_exit(struct mapped_device *md)
 {
 	struct kobject *kobj = dm_kobject(md);
+
 	kobject_put(kobj);
 	wait_for_completion(dm_get_completion_from_kobject(kobj));
 }
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 259fd752e3d0..93a0ce0cfc2a 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -403,6 +403,7 @@ static void subtree_dec(void *context, const void *value, unsigned int count)
 static int subtree_equal(void *context, const void *value1_le, const void *value2_le)
 {
 	__le64 v1_le, v2_le;
+
 	memcpy(&v1_le, value1_le, sizeof(v1_le));
 	memcpy(&v2_le, value2_le, sizeof(v2_le));
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7cc86298baca..e2ff22e79367 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1038,6 +1038,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 static void free_discard_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
+
 	if (m->cell)
 		cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, &tc->pool->mapping_pool);
@@ -2412,6 +2413,7 @@ static void do_worker(struct work_struct *ws)
 static void do_waker(struct work_struct *ws)
 {
 	struct pool *pool = container_of(to_delayed_work(ws), struct pool, waker);
+
 	wake_worker(pool);
 	queue_delayed_work(pool->wq, &pool->waker, COMMIT_PERIOD);
 }
@@ -2474,6 +2476,7 @@ static struct noflush_work *to_noflush(struct work_struct *ws)
 static void do_noflush_start(struct work_struct *ws)
 {
 	struct noflush_work *w = to_noflush(ws);
+
 	w->tc->requeue_mode = true;
 	requeue_io(w->tc);
 	pool_work_complete(&w->pw);
@@ -2482,6 +2485,7 @@ static void do_noflush_start(struct work_struct *ws)
 static void do_noflush_stop(struct work_struct *ws)
 {
 	struct noflush_work *w = to_noflush(ws);
+
 	w->tc->requeue_mode = false;
 	pool_work_complete(&w->pw);
 }
@@ -3241,6 +3245,7 @@ static dm_block_t calc_metadata_threshold(struct pool_c *pt)
 	 * delete after you've grown the device).
 	 */
 	dm_block_t quarter = get_metadata_dev_size_in_blocks(pt->metadata_dev->bdev) / 4;
+
 	return min((dm_block_t)1024ULL /* 4M */, quarter);
 }
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 99a5b0dc99af..f4955c4dbe47 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -114,6 +114,7 @@ static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
 		do {
 			int r;
 			size_t this_step = min_t(size_t, len, PAGE_SIZE - offset_in_page(data));
+
 			flush_kernel_vmap_range((void *)data, this_step);
 			sg_init_table(&sg, 1);
 			sg_set_page(&sg, vmalloc_to_page(data), this_step, offset_in_page(data));
@@ -683,8 +684,10 @@ static void verity_prefetch_io(struct work_struct *work)
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
 		sector_t hash_block_end;
+
 		verity_hash_at_level(v, pw->block, i, &hash_block_start, NULL);
 		verity_hash_at_level(v, pw->block + pw->n_blocks - 1, i, &hash_block_end, NULL);
+
 		if (!i) {
 			unsigned int cluster = READ_ONCE(dm_verity_prefetch_cluster);
 
@@ -1367,6 +1370,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	hash_position = v->hash_start;
 	for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
+
 		v->hash_level_block[i] = hash_position;
 		s = (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_bits)) - 1)
 					>> ((i + 1) * v->hash_per_block_bits);
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 973e0464fc67..3b012dbfb069 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -83,16 +83,13 @@ struct wc_entry {
 	struct rb_node rb_node;
 	struct list_head lru;
 	unsigned short wc_list_contiguous;
-	bool write_in_progress
 #if BITS_PER_LONG == 64
-		: 1
-#endif
-	;
-	unsigned long index
-#if BITS_PER_LONG == 64
-		: 47
+	bool write_in_progress : 1;
+	unsigned long index : 47;
+#else
+	bool write_in_progress;
+	unsigned long index;
 #endif
-	;
 	unsigned long age;
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	uint64_t original_sector;
@@ -300,6 +297,7 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 	}
 	if (da != p) {
 		long i;
+
 		wc->memory_map = NULL;
 		pages = kvmalloc_array(p, sizeof(struct page *), GFP_KERNEL);
 		if (!pages) {
@@ -309,6 +307,7 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 		i = 0;
 		do {
 			long daa;
+
 			daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i,
 					p - i, DAX_ACCESS, NULL, &pfn);
 			if (daa <= 0) {
@@ -507,6 +506,7 @@ static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 
 	while (1) {
 		unsigned int j;
+
 		i = find_next_bit(wc->dirty_bitmap, bitmap_bits, i);
 		if (unlikely(i == bitmap_bits))
 			break;
@@ -637,6 +637,7 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
 
 	while (1) {
 		struct wc_entry *e2;
+
 		if (flags & WFE_LOWEST_SEQ)
 			node = rb_prev(&e->rb_node);
 		else
@@ -679,6 +680,7 @@ static void writecache_add_to_freelist(struct dm_writecache *wc, struct wc_entry
 {
 	if (WC_MODE_SORT_FREELIST(wc)) {
 		struct rb_node **node = &wc->freetree.rb_node, *parent = NULL;
+
 		if (unlikely(!*node))
 			wc->current_free = e;
 		while (*node) {
@@ -718,6 +720,7 @@ static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, s
 
 	if (WC_MODE_SORT_FREELIST(wc)) {
 		struct rb_node *next;
+
 		if (unlikely(!wc->current_free))
 			return NULL;
 		e = wc->current_free;
@@ -864,6 +867,7 @@ static void writecache_flush_work(struct work_struct *work)
 static void writecache_autocommit_timer(struct timer_list *t)
 {
 	struct dm_writecache *wc = from_timer(wc, t, autocommit_timer);
+
 	if (!writecache_has_error(wc))
 		queue_work(wc->writeback_wq, &wc->flush_work);
 }
@@ -963,6 +967,7 @@ static int writecache_alloc_entries(struct dm_writecache *wc)
 		return -ENOMEM;
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
+
 		e->index = b;
 		e->write_in_progress = false;
 		cond_resched();
@@ -1006,6 +1011,7 @@ static void writecache_resume(struct dm_target *ti)
 		r = writecache_read_metadata(wc, wc->metadata_sectors);
 		if (r) {
 			size_t sb_entries_offset;
+
 			writecache_error(wc, r, "unable to read metadata: %d", r);
 			sb_entries_offset = offsetof(struct wc_memory_superblock, entries);
 			memset((char *)wc->memory_map + sb_entries_offset, -1,
@@ -1035,6 +1041,7 @@ static void writecache_resume(struct dm_target *ti)
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
 		struct wc_memory_entry wme;
+
 		if (writecache_has_error(wc)) {
 			e->original_sector = -1;
 			e->seq_count = -1;
@@ -1056,6 +1063,7 @@ static void writecache_resume(struct dm_target *ti)
 #endif
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
+
 		if (!writecache_entry_is_committed(wc, e)) {
 			if (read_seq_count(wc, e) != -1) {
 erase_this:
@@ -1245,6 +1253,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
 
 	do {
 		struct bio_vec bv = bio_iter_iovec(bio, bio->bi_iter);
+
 		buf = bvec_kmap_local(&bv);
 		size = bv.bv_len;
 		if (unlikely(size > remaining_size))
@@ -1252,6 +1261,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
 
 		if (rw == READ) {
 			int r;
+
 			r = copy_mc_to_kernel(buf, data, size);
 			flush_dcache_page(bio_page(bio));
 			if (unlikely(r)) {
@@ -1379,6 +1389,7 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	while (bio_size < bio->bi_iter.bi_size) {
 		if (!search_used) {
 			struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
+
 			if (!f)
 				break;
 			write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector +
@@ -1388,6 +1399,7 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 		} else {
 			struct wc_entry *f;
 			struct rb_node *next = rb_next(&e->rb_node);
+
 			if (!next)
 				break;
 			f = container_of(next, struct wc_entry, rb_node);
@@ -1428,6 +1440,7 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 	do {
 		bool found_entry = false;
 		bool search_used = false;
+
 		if (writecache_has_error(wc)) {
 			wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
 			return WC_MAP_ERROR;
@@ -1606,6 +1619,7 @@ static int writecache_end_io(struct dm_target *ti, struct bio *bio, blk_status_t
 
 	if (bio->bi_private == (void *)1) {
 		int dir = bio_data_dir(bio);
+
 		if (atomic_dec_and_test(&wc->bio_in_progress[dir]))
 			if (unlikely(waitqueue_active(&wc->bio_in_progress_wait[dir])))
 				wake_up(&wc->bio_in_progress_wait[dir]);
@@ -1944,6 +1958,7 @@ static void writecache_writeback(struct work_struct *work)
 	if (likely(wc->pause != 0)) {
 		while (1) {
 			unsigned long idle;
+
 			if (unlikely(wc->cleaner) || unlikely(wc->writeback_all) ||
 			    unlikely(dm_suspended(wc->ti)))
 				break;
@@ -2389,6 +2404,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		string = dm_shift_arg(&as), opt_params--;
 		if (!strcasecmp(string, "start_sector") && opt_params >= 1) {
 			unsigned long long start_sector;
+
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
@@ -2425,6 +2441,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			wc->autocommit_blocks_set = true;
 		} else if (!strcasecmp(string, "autocommit_time") && opt_params >= 1) {
 			unsigned int autocommit_msecs;
+
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%u%c", &autocommit_msecs, &dummy) != 1)
 				goto invalid_optional;
@@ -2435,6 +2452,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
 			unsigned int max_age_msecs;
+
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%u%c", &max_age_msecs, &dummy) != 1)
 				goto invalid_optional;
@@ -2462,6 +2480,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			wc->metadata_only = true;
 		} else if (!strcasecmp(string, "pause_writeback") && opt_params >= 1) {
 			unsigned int pause_msecs;
+
 			if (WC_MODE_PMEM(wc))
 				goto invalid_optional;
 			string = dm_shift_arg(&as), opt_params--;
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 890f5bea1102..30d77f0f7b83 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -112,6 +112,7 @@ static void on_entries(struct dm_array_info *info, struct array_block *ab,
 		       void (*fn)(void *, const void *, unsigned int))
 {
 	unsigned int nr_entries = le32_to_cpu(ab->nr_entries);
+
 	fn(info->value_type.context, element_at(info, ab, 0), nr_entries);
 }
 
@@ -438,6 +439,7 @@ static int drop_blocks(struct resize *resize, unsigned int begin_index,
 
 	while (begin_index != end_index) {
 		uint64_t key = begin_index++;
+
 		r = dm_btree_remove(&resize->info->btree_info, resize->root,
 				    &key, &resize->root);
 		if (r)
@@ -622,6 +624,7 @@ static void __block_dec(void *context, const void *value)
 static void block_dec(void *context, const void *value, unsigned int count)
 {
 	unsigned int i;
+
 	for (i = 0; i < count; i++, value += sizeof(__le64))
 		__block_dec(context, value);
 }
@@ -695,6 +698,7 @@ int dm_array_resize(struct dm_array_info *info, dm_block_t root,
 		    __dm_written_to_disk(value)
 {
 	int r = array_resize(info, root, old_size, new_size, value, new_root);
+
 	__dm_unbless_for_disk(value);
 	return r;
 }
diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
index cf37cd41f96e..795028ad15bb 100644
--- a/drivers/md/persistent-data/dm-bitset.c
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -74,6 +74,7 @@ int dm_bitset_new(struct dm_disk_bitset *info, dm_block_t *root,
 		  uint32_t size, bit_value_fn fn, void *context)
 {
 	struct packer_context p;
+
 	p.fn = fn;
 	p.nr_bits = size;
 	p.context = context;
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index f8e364a034fc..6be878a0a5fb 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -92,6 +92,7 @@ static void __add_holder(struct block_lock *lock, struct task_struct *task)
 static void __del_holder(struct block_lock *lock, struct task_struct *task)
 {
 	unsigned int h = __find_holder(lock, task);
+
 	lock->holders[h] = NULL;
 	put_task_struct(task);
 }
@@ -355,6 +356,7 @@ struct buffer_aux {
 static void dm_block_manager_alloc_callback(struct dm_buffer *buf)
 {
 	struct buffer_aux *aux = dm_bufio_get_aux_data(buf);
+
 	aux->validator = NULL;
 	bl_init(&aux->lock);
 }
@@ -362,6 +364,7 @@ static void dm_block_manager_alloc_callback(struct dm_buffer *buf)
 static void dm_block_manager_write_callback(struct dm_buffer *buf)
 {
 	struct buffer_aux *aux = dm_bufio_get_aux_data(buf);
+
 	if (aux->validator) {
 		aux->validator->prepare_for_write(aux->validator, (struct dm_block *) buf,
 			 dm_bufio_get_block_size(dm_bufio_get_client(buf)));
@@ -436,6 +439,7 @@ static int dm_bm_validate_buffer(struct dm_block_manager *bm,
 {
 	if (unlikely(!aux->validator)) {
 		int r;
+
 		if (!v)
 			return 0;
 		r = v->check(v, (struct dm_block *) buf, dm_bufio_get_block_size(bm->bufio));
@@ -591,8 +595,7 @@ EXPORT_SYMBOL_GPL(dm_bm_write_lock_zero);
 
 void dm_bm_unlock(struct dm_block *b)
 {
-	struct buffer_aux *aux;
-	aux = dm_bufio_get_aux_data(to_buffer(b));
+	struct buffer_aux *aux = dm_bufio_get_aux_data(to_buffer(b));
 
 	if (aux->write_locked) {
 		dm_bufio_mark_buffer_dirty(to_buffer(b));
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index b77a308bcd36..bd353a00372d 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -119,6 +119,7 @@ static inline void *value_base(struct btree_node *n)
 static inline void *value_ptr(struct btree_node *n, uint32_t index)
 {
 	uint32_t value_size = le32_to_cpu(n->header.value_size);
+
 	return value_base(n) + (value_size * index);
 }
 
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 29f3dda8ff23..ac358f46da27 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -87,6 +87,7 @@ static int node_copy(struct btree_node *left, struct btree_node *right, int shif
 {
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t value_size = le32_to_cpu(left->header.value_size);
+
 	if (value_size != le32_to_cpu(right->header.value_size)) {
 		DMERR("mismatched value size");
 		return -EILSEQ;
@@ -130,6 +131,7 @@ static void delete_at(struct btree_node *n, unsigned int index)
 	unsigned int nr_entries = le32_to_cpu(n->header.nr_entries);
 	unsigned int nr_to_copy = nr_entries - (index + 1);
 	uint32_t value_size = le32_to_cpu(n->header.value_size);
+
 	BUG_ON(index >= nr_entries);
 
 	if (nr_to_copy) {
@@ -265,6 +267,7 @@ static int __rebalance2(struct dm_btree_info *info, struct btree_node *parent,
 		 * Rebalance.
 		 */
 		unsigned int target_left = (nr_left + nr_right) / 2;
+
 		ret = shift(left, right, nr_left - target_left);
 		if (ret)
 			return ret;
@@ -557,6 +560,7 @@ static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
 		 */
 		if (shadow_has_parent(s)) {
 			__le64 location = cpu_to_le64(dm_block_location(shadow_current(s)));
+
 			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i),
 			       &location, sizeof(__le64));
 		}
@@ -650,6 +654,7 @@ static int remove_nearest(struct shadow_spine *s, struct dm_btree_info *info,
 		 */
 		if (shadow_has_parent(s)) {
 			__le64 location = cpu_to_le64(dm_block_location(shadow_current(s)));
+
 			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i),
 			       &location, sizeof(__le64));
 		}
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 1e930e809169..a83b45a648d7 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -510,6 +510,7 @@ static void copy_entries(struct btree_node *dest, unsigned int dest_offset,
 			 unsigned int count)
 {
 	size_t value_size = le32_to_cpu(dest->header.value_size);
+
 	memcpy(dest->keys + dest_offset, src->keys + src_offset, count * sizeof(uint64_t));
 	memcpy(value_ptr(dest, dest_offset), value_ptr(src, src_offset), count * value_size);
 }
@@ -523,6 +524,7 @@ static void move_entries(struct btree_node *dest, unsigned int dest_offset,
 			 unsigned int count)
 {
 	size_t value_size = le32_to_cpu(dest->header.value_size);
+
 	memmove(dest->keys + dest_offset, src->keys + src_offset, count * sizeof(uint64_t));
 	memmove(value_ptr(dest, dest_offset), value_ptr(src, src_offset), count * value_size);
 }
@@ -559,10 +561,12 @@ static void redistribute2(struct btree_node *left, struct btree_node *right)
 
 	if (nr_left < target_left) {
 		unsigned int delta = target_left - nr_left;
+
 		copy_entries(left, nr_left, right, 0, delta);
 		shift_down(right, delta);
 	} else if (nr_left > target_left) {
 		unsigned int delta = nr_left - target_left;
+
 		if (nr_right)
 			shift_up(right, delta);
 		copy_entries(right, 0, left, target_left, delta);
@@ -593,18 +597,21 @@ static void redistribute3(struct btree_node *left, struct btree_node *center,
 
 	if (nr_left < target_left) {
 		unsigned int left_short = target_left - nr_left;
+
 		copy_entries(left, nr_left, right, 0, left_short);
 		copy_entries(center, 0, right, left_short, target_center);
 		shift_down(right, nr_right - target_right);
 
 	} else if (nr_left < (target_left + target_center)) {
 		unsigned int left_to_center = nr_left - target_left;
+
 		copy_entries(center, 0, left, target_left, left_to_center);
 		copy_entries(center, left_to_center, right, 0, target_center - left_to_center);
 		shift_down(right, nr_right - target_right);
 
 	} else {
 		unsigned int right_short = target_right - nr_right;
+
 		shift_up(right, right_short);
 		copy_entries(right, 0, left, nr_left - right_short, right_short);
 		copy_entries(center, 0, left, target_left, nr_left - target_left);
@@ -1004,6 +1011,7 @@ static int rebalance_or_split(struct shadow_spine *s, struct dm_btree_value_type
 	/* Should we move entries to the left sibling? */
 	if (parent_index > 0) {
 		dm_block_t left_b = value64(parent, parent_index - 1);
+
 		r = dm_tm_block_is_shared(s->info->tm, left_b, &left_shared);
 		if (r)
 			return r;
@@ -1021,6 +1029,7 @@ static int rebalance_or_split(struct shadow_spine *s, struct dm_btree_value_type
 	/* Should we move entries to the right sibling? */
 	if (parent_index < (nr_parent - 1)) {
 		dm_block_t right_b = value64(parent, parent_index + 1);
+
 		r = dm_tm_block_is_shared(s->info->tm, right_b, &right_shared);
 		if (r)
 			return r;
@@ -1588,6 +1597,7 @@ EXPORT_SYMBOL_GPL(dm_btree_cursor_end);
 int dm_btree_cursor_next(struct dm_btree_cursor *c)
 {
 	int r = inc_or_backtrack(c);
+
 	if (!r) {
 		r = find_leaf(c);
 		if (r)
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 744fca4d1c34..01a82b17c07c 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -609,6 +609,7 @@ static int sm_ll_inc_overflow(struct ll_disk *ll, dm_block_t b, struct inc_conte
 static inline int shadow_bitmap(struct ll_disk *ll, struct inc_context *ic)
 {
 	int r, inc;
+
 	r = dm_tm_shadow_block(ll->tm, le64_to_cpu(ic->ie_disk.blocknr),
 			       &dm_sm_bitmap_validator, &ic->bitmap_block, &inc);
 	if (r < 0) {
@@ -748,6 +749,7 @@ int sm_ll_inc(struct ll_disk *ll, dm_block_t b, dm_block_t e,
 	*nr_allocations = 0;
 	while (b != e) {
 		int r = __sm_ll_inc(ll, b, e, nr_allocations, &b);
+
 		if (r)
 			return r;
 	}
@@ -930,6 +932,7 @@ int sm_ll_dec(struct ll_disk *ll, dm_block_t b, dm_block_t e,
 	*nr_allocations = 0;
 	while (b != e) {
 		int r = __sm_ll_dec(ll, b, e, nr_allocations, &b);
+
 		if (r)
 			return r;
 	}
@@ -1166,8 +1169,10 @@ static int disk_ll_save_ie(struct ll_disk *ll, dm_block_t index,
 static int disk_ll_init_index(struct ll_disk *ll)
 {
 	unsigned int i;
+
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
+
 		iec->valid = false;
 		iec->dirty = false;
 	}
@@ -1191,6 +1196,7 @@ static int disk_ll_commit(struct ll_disk *ll)
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
+
 		if (iec->valid && iec->dirty)
 			r = ie_cache_writeback(ll, iec);
 	}
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index fccd8a86797c..c06d9070267f 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -49,6 +49,7 @@ static int sm_disk_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
 static int sm_disk_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
 {
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+
 	*count = smd->old_ll.nr_blocks;
 
 	return 0;
@@ -57,6 +58,7 @@ static int sm_disk_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
 static int sm_disk_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
 {
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+
 	*count = (smd->old_ll.nr_blocks - smd->old_ll.nr_allocated) - smd->nr_allocated_this_transaction;
 
 	return 0;
@@ -66,6 +68,7 @@ static int sm_disk_get_count(struct dm_space_map *sm, dm_block_t b,
 			     uint32_t *result)
 {
 	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+
 	return sm_ll_lookup(&smd->ll, b, result);
 }
 
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index ee754bcc2643..f1301fa81f23 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -114,6 +114,7 @@ static bool brb_empty(struct bop_ring_buffer *brb)
 static unsigned int brb_next(struct bop_ring_buffer *brb, unsigned int old)
 {
 	unsigned int r = old + 1;
+
 	return r >= ARRAY_SIZE(brb->bops) ? 0 : r;
 }
 
@@ -182,6 +183,7 @@ struct sm_metadata {
 static int add_bop(struct sm_metadata *smm, enum block_op_type type, dm_block_t b, dm_block_t e)
 {
 	int r = brb_push(&smm->uncommitted, type, b, e);
+
 	if (r) {
 		DMERR("too many recursive allocations");
 		return -ENOMEM;
@@ -487,6 +489,7 @@ static int sm_metadata_new_block(struct dm_space_map *sm, dm_block_t *b)
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
 	int r = sm_metadata_new_block_(sm, b);
+
 	if (r) {
 		DMERR_LIMIT("unable to allocate new metadata block");
 		return r;
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index c0633728b3e7..db9f67eeedc0 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -37,6 +37,7 @@ static unsigned int prefetch_hash(dm_block_t b)
 static void prefetch_wipe(struct prefetch_set *p)
 {
 	unsigned int i;
+
 	for (i = 0; i < PREFETCH_SIZE; i++)
 		p->blocks[i] = PREFETCH_SENTINEL;
 }
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

