Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCF158218
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725562925; cv=none; b=iB/Xr/Nvny/g3sHPp3a6fKyBm5kX3gGJQUf9Fx43WGI2DtkSRpAZmxK2TSS/+hP9gSrMWGJ0DUuKb/pIsfIfRoznf6bBaoVRR+METRFEZ1GMTb2mBQCCVN8gKc7NofauGA8WxUx6eCOFxH/60j9XyPtp34ZId1iaz2EWYIxPDmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725562925; c=relaxed/simple;
	bh=LE+OcBAv61ehFYgpmA/CcuY1z15rfWre/z1v732hnZw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=hTx9T43Idv8qZQTqzH1XXOKnLywR7WDaBEZ17s9ixwzv+hVvm54N9imAW1lrrgDiuAAtj9eeewLkF6jvsS9+/U+64YylNsfQtBf5Xn8NpnUNUeO8RW2GFAHq20bsn4/zzG44P63jQbqoqq4gI2qyQIh8e2uqAncNNHjCDSy3Akc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ya9rSlaE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ya9rSlaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725562922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YP9Wsd2lMgPvzAlXzCVvyDHOpVs3FCK8YWB9NL/0ku4=;
	b=Ya9rSlaEdYhiMeIykWjYuYO3IU5ZHKv128NvGRLjPQf4lExAMpbqcsJseLSr0XJ/X+zCoZ
	5adtvFkhfXl/6u/BdysfVLCSsPmhKbckLilENgM1+H1jnm2VYJ0oltUld4R3F64YzS8gZT
	uMCaPrad+mIOoUSvUIITRFlnP6v3nT0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-40guRiKvPwSm6jkOOJd-Xw-1; Thu,
 05 Sep 2024 15:01:59 -0400
X-MC-Unique: 40guRiKvPwSm6jkOOJd-Xw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5477019560A7;
	Thu,  5 Sep 2024 19:01:58 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4EEA1955D44;
	Thu,  5 Sep 2024 19:01:56 +0000 (UTC)
Date: Thu, 5 Sep 2024 21:01:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: support recalculation in the 'I' mode
Message-ID: <f36f7696-21f0-f6e7-7220-d87287d42a42@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

In the kernel 6.11, dm-integrity was enhanced with an inline ('I') mode.
This mode uses devices with non-power-of-2 sector size. The extra
metadata after each sector are used to hold the integrity hash.

This commit enhances the inline mode, so that there is automatic
recalculation of the integrity hashes when the 'reclaculate' parameter is
used. It allows us to activate the device instantly, and the
recalculation is done on background.

If the device is deactivated while recalculation is in progress, it will
remember the point where it stopped and it will continue from this point
when activated again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |  288 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 246 insertions(+), 42 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-09-05 20:28:38.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2024-09-05 20:47:27.000000000 +0200
@@ -284,6 +284,7 @@ struct dm_integrity_c {
 
 	mempool_t recheck_pool;
 	struct bio_set recheck_bios;
+	struct bio_set recalc_bios;
 
 	struct notifier_block reboot_notifier;
 };
@@ -321,7 +322,9 @@ struct dm_integrity_io {
 	struct dm_bio_details bio_details;
 
 	char *integrity_payload;
+	unsigned payload_len;
 	bool integrity_payload_from_mempool;
+	bool integrity_range_locked;
 };
 
 struct journal_completion {
@@ -359,7 +362,7 @@ static struct kmem_cache *journal_io_cac
 #endif
 
 static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map);
-static int dm_integrity_map_inline(struct dm_integrity_io *dio);
+static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map);
 static void integrity_bio_wait(struct work_struct *w);
 static void dm_integrity_dtr(struct dm_target *ti);
 
@@ -1946,8 +1949,13 @@ static int dm_integrity_map(struct dm_ta
 	dio->bi_status = 0;
 	dio->op = bio_op(bio);
 
-	if (ic->mode == 'I')
-		return dm_integrity_map_inline(dio);
+	if (ic->mode == 'I') {
+		bio->bi_iter.bi_sector = dm_target_offset(ic->ti, bio->bi_iter.bi_sector);
+		dio->integrity_payload = NULL;
+		dio->integrity_payload_from_mempool = false;
+		dio->integrity_range_locked = false;
+		return dm_integrity_map_inline(dio, true);
+	}
 
 	if (unlikely(dio->op == REQ_OP_DISCARD)) {
 		if (ti->max_io_len) {
@@ -2397,15 +2405,13 @@ journal_read_write:
 	do_endio_flush(ic, dio);
 }
 
-static int dm_integrity_map_inline(struct dm_integrity_io *dio)
+static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map)
 {
 	struct dm_integrity_c *ic = dio->ic;
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	struct bio_integrity_payload *bip;
-	unsigned payload_len, digest_size, extra_size, ret;
-
-	dio->integrity_payload = NULL;
-	dio->integrity_payload_from_mempool = false;
+	unsigned ret;
+	sector_t recalc_sector;
 
 	if (unlikely(bio_integrity(bio))) {
 		bio->bi_status = BLK_STS_NOTSUPP;
@@ -2418,28 +2424,67 @@ static int dm_integrity_map_inline(struc
 		return DM_MAPIO_REMAPPED;
 
 retry:
-	payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
-	digest_size = crypto_shash_digestsize(ic->internal_hash);
-	extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-	payload_len += extra_size;
-	dio->integrity_payload = kmalloc(payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	if (unlikely(!dio->integrity_payload)) {
-		const unsigned x_size = PAGE_SIZE << 1;
-		if (payload_len > x_size) {
-			unsigned sectors = ((x_size - extra_size) / ic->tuple_size) << ic->sb->log2_sectors_per_block;
-			if (WARN_ON(!sectors || sectors >= bio_sectors(bio))) {
-				bio->bi_status = BLK_STS_NOTSUPP;
-				bio_endio(bio);
-				return DM_MAPIO_SUBMITTED;
+	if (!dio->integrity_payload) {
+		unsigned digest_size, extra_size;
+		dio->payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
+		digest_size = crypto_shash_digestsize(ic->internal_hash);
+		extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
+		dio->payload_len += extra_size;
+		dio->integrity_payload = kmalloc(dio->payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		if (unlikely(!dio->integrity_payload)) {
+			const unsigned x_size = PAGE_SIZE << 1;
+			if (dio->payload_len > x_size) {
+				unsigned sectors = ((x_size - extra_size) / ic->tuple_size) << ic->sb->log2_sectors_per_block;
+				if (WARN_ON(!sectors || sectors >= bio_sectors(bio))) {
+					bio->bi_status = BLK_STS_NOTSUPP;
+					bio_endio(bio);
+					return DM_MAPIO_SUBMITTED;
+				}
+				dm_accept_partial_bio(bio, sectors);
+				goto retry;
 			}
-			dm_accept_partial_bio(bio, sectors);
-			goto retry;
 		}
+	}
+
+	dio->range.logical_sector = bio->bi_iter.bi_sector;
+	dio->range.n_sectors = bio_sectors(bio);
+
+	if (!(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)))
+		goto skip_spinlock;
+#ifdef CONFIG_64BIT
+	/*
+	 * On 64-bit CPUs we can optimize the lock away (so that it won't cause
+	 * cache line bouncing) and use acquire/release barriers instead.
+	 *
+	 * Paired with smp_store_release in integrity_recalc_inline.
+	 */
+	recalc_sector = le64_to_cpu(smp_load_acquire(&ic->sb->recalc_sector));
+	if (likely(dio->range.logical_sector + dio->range.n_sectors <= recalc_sector))
+		goto skip_spinlock;
+#endif
+	spin_lock_irq(&ic->endio_wait.lock);
+	recalc_sector = le64_to_cpu(ic->sb->recalc_sector);
+	if (dio->range.logical_sector + dio->range.n_sectors <= recalc_sector)
+		goto skip_unlock;
+	if (unlikely(!add_new_range(ic, &dio->range, true))) {
+		if (from_map) {
+			spin_unlock_irq(&ic->endio_wait.lock);
+			INIT_WORK(&dio->work, integrity_bio_wait);
+			queue_work(ic->wait_wq, &dio->work);
+			return DM_MAPIO_SUBMITTED;
+		}
+		wait_and_add_new_range(ic, &dio->range);
+	}
+	dio->integrity_range_locked = true;
+skip_unlock:
+	spin_unlock_irq(&ic->endio_wait.lock);
+skip_spinlock:
+
+	if (unlikely(!dio->integrity_payload)) {
 		dio->integrity_payload = page_to_virt((struct page *)mempool_alloc(&ic->recheck_pool, GFP_NOIO));
 		dio->integrity_payload_from_mempool = true;
 	}
 
-	bio->bi_iter.bi_sector = dm_target_offset(ic->ti, bio->bi_iter.bi_sector);
 	dio->bio_details.bi_iter = bio->bi_iter;
 
 	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
@@ -2470,8 +2515,8 @@ retry:
 	}
 
 	ret = bio_integrity_add_page(bio, virt_to_page(dio->integrity_payload),
-					payload_len, offset_in_page(dio->integrity_payload));
-	if (unlikely(ret != payload_len)) {
+					dio->payload_len, offset_in_page(dio->integrity_payload));
+	if (unlikely(ret != dio->payload_len)) {
 		bio->bi_status = BLK_STS_RESOURCE;
 		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
@@ -2579,6 +2624,9 @@ static int dm_integrity_end_io(struct dm
 		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
 		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK)) {
 			unsigned pos = 0;
+			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+			    unlikely(dio->integrity_range_locked))
+				goto skip_check;
 			while (dio->bio_details.bi_iter.bi_size) {
 				char digest[HASH_MAX_DIGESTSIZE];
 				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
@@ -2598,9 +2646,10 @@ static int dm_integrity_end_io(struct dm
 				bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
 			}
 		}
-		if (likely(dio->op == REQ_OP_READ) || likely(dio->op == REQ_OP_WRITE)) {
-			dm_integrity_free_payload(dio);
-		}
+skip_check:
+		dm_integrity_free_payload(dio);
+		if (unlikely(dio->integrity_range_locked))
+			remove_range(ic, &dio->range);
 	}
 	return DM_ENDIO_DONE;
 }
@@ -2608,8 +2657,26 @@ static int dm_integrity_end_io(struct dm
 static void integrity_bio_wait(struct work_struct *w)
 {
 	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
+	struct dm_integrity_c *ic = dio->ic;
 
-	dm_integrity_map_continue(dio, false);
+	if (ic->mode == 'I') {
+		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+		int r = dm_integrity_map_inline(dio, false);
+		switch (r) {
+			case DM_MAPIO_KILL:
+				bio->bi_status = BLK_STS_IOERR;
+				fallthrough;
+			case DM_MAPIO_REMAPPED:
+				submit_bio_noacct(bio);
+				fallthrough;
+			case DM_MAPIO_SUBMITTED:
+				return;
+			default:
+				BUG();
+		}
+	} else {
+		dm_integrity_map_continue(dio, false);
+	}
 }
 
 static void pad_uncommitted(struct dm_integrity_c *ic)
@@ -3081,6 +3148,133 @@ free_ret:
 	kvfree(recalc_tags);
 }
 
+static void integrity_recalc_inline(struct work_struct *w)
+{
+	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, recalc_work);
+	size_t recalc_tags_size;
+	u8 *recalc_buffer = NULL;
+	u8 *recalc_tags = NULL;
+	struct dm_integrity_range range;
+	struct bio *bio;
+	struct bio_integrity_payload *bip;
+	__u8 *t;
+	unsigned int i;
+	int r;
+	unsigned ret;
+	unsigned int super_counter = 0;
+	unsigned recalc_sectors = RECALC_SECTORS;
+
+retry:
+	recalc_buffer = kmalloc(recalc_sectors << SECTOR_SHIFT, GFP_NOIO | __GFP_NOWARN);
+	if (!recalc_buffer) {
+oom:
+		recalc_sectors >>= 1;
+		if (recalc_sectors >= 1U << ic->sb->log2_sectors_per_block)
+			goto retry;
+		DMCRIT("out of memory for recalculate buffer - recalculation disabled");
+		goto free_ret;
+	}
+
+	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tuple_size;
+	if (crypto_shash_digestsize(ic->internal_hash) > ic->tuple_size)
+		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tuple_size;
+	recalc_tags = kmalloc(recalc_tags_size, GFP_NOIO | __GFP_NOWARN);
+	if (!recalc_tags) {
+		kfree(recalc_buffer);
+		recalc_buffer = NULL;
+		goto oom;
+	}
+
+	spin_lock_irq(&ic->endio_wait.lock);
+
+next_chunk:
+	if (unlikely(dm_post_suspending(ic->ti)))
+		goto unlock_ret;
+
+	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
+	if (unlikely(range.logical_sector >= ic->provided_data_sectors))
+		goto unlock_ret;
+	range.n_sectors = min((sector_t)recalc_sectors, ic->provided_data_sectors - range.logical_sector);
+
+	add_new_range_and_wait(ic, &range);
+	spin_unlock_irq(&ic->endio_wait.lock);
+
+	if (unlikely(++super_counter == RECALC_WRITE_SUPER)) {
+		recalc_write_super(ic);
+		super_counter = 0;
+	}
+
+	if (unlikely(dm_integrity_failed(ic)))
+		goto err;
+
+	DEBUG_print("recalculating: %llx - %llx\n", range.logical_sector, range.n_sectors);
+
+	bio = bio_alloc_bioset(ic->dev->bdev, 1, REQ_OP_READ, GFP_NOIO, &ic->recalc_bios);
+	bio->bi_iter.bi_sector = ic->start + SB_SECTORS + range.logical_sector;
+	__bio_add_page(bio, virt_to_page(recalc_buffer), range.n_sectors << SECTOR_SHIFT, offset_in_page(recalc_buffer));
+	r = submit_bio_wait(bio);
+	bio_put(bio);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "reading data", r);
+		goto err;
+	}
+
+	t = recalc_tags;
+	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
+		memset(t, 0, ic->tuple_size);
+		integrity_sector_checksum(ic, range.logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
+		t += ic->tuple_size;
+	}
+
+	bio = bio_alloc_bioset(ic->dev->bdev, 1, REQ_OP_WRITE, GFP_NOIO, &ic->recalc_bios);
+	bio->bi_iter.bi_sector = ic->start + SB_SECTORS + range.logical_sector;
+	__bio_add_page(bio, virt_to_page(recalc_buffer), range.n_sectors << SECTOR_SHIFT, offset_in_page(recalc_buffer));
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
+	if (unlikely(IS_ERR(bip))) {
+		bio_put(bio);
+		DMCRIT("out of memory for bio integrity payload - recalculation disabled");
+		goto err;
+	}
+	ret = bio_integrity_add_page(bio, virt_to_page(recalc_tags), t - recalc_tags, offset_in_page(recalc_tags));
+	if (unlikely(ret != t - recalc_tags)) {
+		bio_put(bio);
+		dm_integrity_io_error(ic, "attaching integrity tags", -ENOMEM);
+		goto err;
+	}
+
+	r = submit_bio_wait(bio);
+	bio_put(bio);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "writing data", r);
+		goto err;
+	}
+
+	cond_resched();
+	spin_lock_irq(&ic->endio_wait.lock);
+	remove_range_unlocked(ic, &range);
+#ifdef CONFIG_64BIT
+	/* Paired with smp_load_acquire in dm_integrity_map_inline. */
+	smp_store_release(&ic->sb->recalc_sector, cpu_to_le64(range.logical_sector + range.n_sectors));
+#else
+	ic->sb->recalc_sector = cpu_to_le64(range.logical_sector + range.n_sectors);
+#endif
+	goto next_chunk;
+
+err:
+	remove_range(ic, &range);
+	goto free_ret;
+
+unlock_ret:
+	spin_unlock_irq(&ic->endio_wait.lock);
+
+	recalc_write_super(ic);
+
+free_ret:
+	kfree(recalc_buffer);
+	kfree(recalc_tags);
+}
+
 static void bitmap_block_work(struct work_struct *w)
 {
 	struct bitmap_block_status *bbs = container_of(w, struct bitmap_block_status, work);
@@ -4619,6 +4813,17 @@ static int dm_integrity_ctr(struct dm_ta
 			r = -ENOMEM;
 			goto bad;
 		}
+		r = bioset_init(&ic->recalc_bios, 1, 0, BIOSET_NEED_BVECS);
+		if (r) {
+			ti->error = "Cannot allocate bio set";
+			goto bad;
+		}
+		r = bioset_integrity_create(&ic->recalc_bios, 1);
+		if (r) {
+			ti->error = "Cannot allocate bio integrity set";
+			r = -ENOMEM;
+			goto bad;
+		}
 	}
 
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
@@ -4830,7 +5035,7 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
-		INIT_WORK(&ic->recalc_work, integrity_recalc);
+		INIT_WORK(&ic->recalc_work, ic->mode == 'I' ? integrity_recalc_inline : integrity_recalc);
 	} else {
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 			ti->error = "Recalculate can only be specified with internal_hash";
@@ -4847,17 +5052,15 @@ try_smaller_buffer:
 		goto bad;
 	}
 
-	if (ic->mode != 'I') {
-		ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
-				1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
-		if (IS_ERR(ic->bufio)) {
-			r = PTR_ERR(ic->bufio);
-			ti->error = "Cannot initialize dm-bufio";
-			ic->bufio = NULL;
-			goto bad;
-		}
-		dm_bufio_set_sector_offset(ic->bufio, ic->start + ic->initial_sectors);
+	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
+			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
+	if (IS_ERR(ic->bufio)) {
+		r = PTR_ERR(ic->bufio);
+		ti->error = "Cannot initialize dm-bufio";
+		ic->bufio = NULL;
+		goto bad;
 	}
+	dm_bufio_set_sector_offset(ic->bufio, ic->start + ic->initial_sectors);
 
 	if (ic->mode != 'R' && ic->mode != 'I') {
 		r = create_journal(ic, &ti->error);
@@ -4979,6 +5182,7 @@ static void dm_integrity_dtr(struct dm_t
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
+	bioset_exit(&ic->recalc_bios);
 	bioset_exit(&ic->recheck_bios);
 	mempool_exit(&ic->recheck_pool);
 	mempool_exit(&ic->journal_io_mempool);
@@ -5033,7 +5237,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 12, 0},
+	.version		= {1, 13, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,

