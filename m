Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7B41448E0
	for <dm-devel@lists.linux.dev>; Tue, 25 Jun 2024 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338310; cv=none; b=gQk5era1Thrro2s0bBAzry7vlTogW5cuS8Eb1wDhy+vocZ40M5BNEUw42gXLbvlSuCbQldCYfjT80V+Lq7StcDJLPtAITXptvS3DDBmg8pRJFWW0Ih1t1Apr/WgdAU9jr4aEMJ5XbuvOPPQ2v20Aa/JFYQmFQ85zKfxGG/t8ZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338310; c=relaxed/simple;
	bh=3Gezm0fnZ1Tf9kx9sSgvYcn9adCrxAyKMXW1T/o9UqY=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ElzN+4h7xsb1oVOASYQIo7XQZtM5oRkZtlw9XqogBwqGrYFyw8d/OhFQjLR32X2eLXMYzmnwjkt8FpLZ3XE6M35wf1ayQtr6nutCGQu8LedmzkHL7M5KdTjFauSTmua04z0nz1qv7vl4grJ/AT8Ik6GGLvtekvu3YfGD5qjaTmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAVkZd+M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAVkZd+M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719338307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6ZyD8rVuX7TqXjvfYk7wNwaCO+A5YpaaAbLd2/zed28=;
	b=SAVkZd+MqT2cWet/hm/bWHJwwb4cV30ygU/BAvyvpzLBudqqINNimgC9PjJ7R/fAhKqypl
	cYdTGUS9alBUMBJASJ39gmnTSboUbOVHn8SvZ304YWTTZND1oQHoiVDg4JIDqgyyMI+Sgt
	aY9xqKY0lJNyOydya4nui3TGLXsVEpI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-cbYYCvAAM52eInOHx8IVcA-1; Tue,
 25 Jun 2024 13:58:25 -0400
X-MC-Unique: cbYYCvAAM52eInOHx8IVcA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 716EC19560AF;
	Tue, 25 Jun 2024 17:58:24 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27C83300021A;
	Tue, 25 Jun 2024 17:58:24 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 26AE330C1C04; Tue, 25 Jun 2024 17:58:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 259703FB52;
	Tue, 25 Jun 2024 19:58:23 +0200 (CEST)
Date: Tue, 25 Jun 2024 19:58:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] dm-integrity: introduce the Inline mode
Message-ID: <c994d5e-cc3d-d7f5-ce3-fd2cf91e850@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This commit introduces a new 'I' mode for dm-integrity.

The 'I' mode may be selected if the underlying device has non-power-of-2
sector size. In this mode, dm-integrity will store integrity data
directly in device's sectors and it will not use journal.

This mode improves performance and reduces flash wear because there would
be no journal writes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |  404 ++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/scsi_debug.c |    1 
 2 files changed, 360 insertions(+), 45 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-06-25 19:32:00.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2024-06-25 19:33:16.000000000 +0200
@@ -44,6 +44,7 @@
 #define BITMAP_FLUSH_INTERVAL		(10 * HZ)
 #define DISCARD_FILLER			0xf6
 #define SALT_SIZE			16
+#define RECHECK_POOL_SIZE		256
 
 /*
  * Warning - DEBUG_PRINT prints security-sensitive data to the log,
@@ -62,6 +63,7 @@
 #define SB_VERSION_3			3
 #define SB_VERSION_4			4
 #define SB_VERSION_5			5
+#define SB_VERSION_6			6
 #define SB_SECTORS			8
 #define MAX_SECTORS_PER_BLOCK		8
 
@@ -86,6 +88,7 @@ struct superblock {
 #define SB_FLAG_DIRTY_BITMAP		0x4
 #define SB_FLAG_FIXED_PADDING		0x8
 #define SB_FLAG_FIXED_HMAC		0x10
+#define SB_FLAG_INLINE			0x20
 
 #define	JOURNAL_ENTRY_ROUNDUP		8
 
@@ -166,6 +169,7 @@ struct dm_integrity_c {
 	struct dm_dev *meta_dev;
 	unsigned int tag_size;
 	__s8 log2_tag_size;
+	unsigned int tuple_size;
 	sector_t start;
 	mempool_t journal_io_mempool;
 	struct dm_io_client *io;
@@ -279,6 +283,7 @@ struct dm_integrity_c {
 	atomic64_t number_of_mismatches;
 
 	mempool_t recheck_pool;
+	struct bio_set recheck_bios;
 
 	struct notifier_block reboot_notifier;
 };
@@ -314,6 +319,9 @@ struct dm_integrity_io {
 	struct completion *completion;
 
 	struct dm_bio_details bio_details;
+
+	char *integrity_payload;
+	bool integrity_payload_from_mempool;
 };
 
 struct journal_completion {
@@ -370,6 +378,7 @@ static const struct blk_integrity_profil
 };
 
 static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map);
+static int dm_integrity_map_inline(struct dm_integrity_io *dio);
 static void integrity_bio_wait(struct work_struct *w);
 static void dm_integrity_dtr(struct dm_target *ti);
 
@@ -479,7 +488,9 @@ static void wraparound_section(struct dm
 
 static void sb_set_version(struct dm_integrity_c *ic)
 {
-	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC))
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_INLINE))
+		ic->sb->version = SB_VERSION_6;
+	else if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC))
 		ic->sb->version = SB_VERSION_5;
 	else if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING))
 		ic->sb->version = SB_VERSION_4;
@@ -1913,6 +1924,35 @@ error:
 	dec_in_flight(dio);
 }
 
+static inline bool dm_integrity_check_limits(struct dm_integrity_c *ic, sector_t logical_sector, struct bio *bio)
+{
+	if (unlikely(logical_sector + bio_sectors(bio) > ic->provided_data_sectors)) {
+		DMERR("Too big sector number: 0x%llx + 0x%x > 0x%llx",
+		      logical_sector, bio_sectors(bio),
+		      ic->provided_data_sectors);
+		return false;
+	}
+	if (unlikely((logical_sector | bio_sectors(bio)) & (unsigned int)(ic->sectors_per_block - 1))) {
+		DMERR("Bio not aligned on %u sectors: 0x%llx, 0x%x",
+		      ic->sectors_per_block,
+		      logical_sector, bio_sectors(bio));
+		return false;
+	}
+	if (ic->sectors_per_block > 1 && likely(bio_op(bio) != REQ_OP_DISCARD)) {
+		struct bvec_iter iter;
+		struct bio_vec bv;
+
+		bio_for_each_segment(bv, bio, iter) {
+			if (unlikely(bv.bv_len & ((ic->sectors_per_block << SECTOR_SHIFT) - 1))) {
+				DMERR("Bio vector (%u,%u) is not aligned on %u-sector boundary",
+					bv.bv_offset, bv.bv_len, ic->sectors_per_block);
+				return false;
+			}
+		}
+	}
+	return true;
+}
+
 static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_integrity_c *ic = ti->private;
@@ -1925,6 +1965,9 @@ static int dm_integrity_map(struct dm_ta
 	dio->bi_status = 0;
 	dio->op = bio_op(bio);
 
+	if (ic->mode == 'I')
+		return dm_integrity_map_inline(dio);
+
 	if (unlikely(dio->op == REQ_OP_DISCARD)) {
 		if (ti->max_io_len) {
 			sector_t sec = dm_target_offset(ti, bio->bi_iter.bi_sector);
@@ -1954,31 +1997,8 @@ static int dm_integrity_map(struct dm_ta
 		 */
 		bio->bi_opf &= ~REQ_FUA;
 	}
-	if (unlikely(dio->range.logical_sector + bio_sectors(bio) > ic->provided_data_sectors)) {
-		DMERR("Too big sector number: 0x%llx + 0x%x > 0x%llx",
-		      dio->range.logical_sector, bio_sectors(bio),
-		      ic->provided_data_sectors);
-		return DM_MAPIO_KILL;
-	}
-	if (unlikely((dio->range.logical_sector | bio_sectors(bio)) & (unsigned int)(ic->sectors_per_block - 1))) {
-		DMERR("Bio not aligned on %u sectors: 0x%llx, 0x%x",
-		      ic->sectors_per_block,
-		      dio->range.logical_sector, bio_sectors(bio));
+	if (unlikely(!dm_integrity_check_limits(ic, dio->range.logical_sector, bio)))
 		return DM_MAPIO_KILL;
-	}
-
-	if (ic->sectors_per_block > 1 && likely(dio->op != REQ_OP_DISCARD)) {
-		struct bvec_iter iter;
-		struct bio_vec bv;
-
-		bio_for_each_segment(bv, bio, iter) {
-			if (unlikely(bv.bv_len & ((ic->sectors_per_block << SECTOR_SHIFT) - 1))) {
-				DMERR("Bio vector (%u,%u) is not aligned on %u-sector boundary",
-					bv.bv_offset, bv.bv_len, ic->sectors_per_block);
-				return DM_MAPIO_KILL;
-			}
-		}
-	}
 
 	bip = bio_integrity(bio);
 	if (!ic->internal_hash) {
@@ -2394,6 +2414,213 @@ journal_read_write:
 	do_endio_flush(ic, dio);
 }
 
+static int dm_integrity_map_inline(struct dm_integrity_io *dio)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct bio_integrity_payload *bip;
+	unsigned payload_len, digest_size, extra_size, ret;
+
+	dio->integrity_payload = NULL;
+	dio->integrity_payload_from_mempool = false;
+
+	if (unlikely(bio_integrity(bio))) {
+		bio->bi_status = BLK_STS_NOTSUPP;
+		bio_endio(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	bio_set_dev(bio, ic->dev->bdev);
+	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0))
+		return DM_MAPIO_REMAPPED;
+
+retry:
+	payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
+	digest_size = crypto_shash_digestsize(ic->internal_hash);
+	extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
+	payload_len += extra_size;
+	dio->integrity_payload = kmalloc(payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (unlikely(!dio->integrity_payload)) {
+		const unsigned x_size = PAGE_SIZE << 1;
+		if (payload_len > x_size) {
+			unsigned sectors = ((x_size - extra_size) / ic->tuple_size) << ic->sb->log2_sectors_per_block;
+			if (WARN_ON(!sectors || sectors >= bio_sectors(bio))) {
+				bio->bi_status = BLK_STS_NOTSUPP;
+				bio_endio(bio);
+				return DM_MAPIO_SUBMITTED;
+			}
+			dm_accept_partial_bio(bio, sectors);
+			goto retry;
+		}
+		dio->integrity_payload = page_to_virt((struct page *)mempool_alloc(&ic->recheck_pool, GFP_NOIO));
+		dio->integrity_payload_from_mempool = true;
+	}
+
+	bio->bi_iter.bi_sector = dm_target_offset(ic->ti, bio->bi_iter.bi_sector);
+	dio->bio_details.bi_iter = bio->bi_iter;
+
+	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
+		return DM_MAPIO_KILL;
+	}
+
+	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
+	if (unlikely(IS_ERR(bip))) {
+		bio->bi_status = errno_to_blk_status(PTR_ERR(bip));
+		bio_endio(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	if (dio->op == REQ_OP_WRITE) {
+		unsigned pos = 0;
+		while (dio->bio_details.bi_iter.bi_size) {
+			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
+			const char *mem = bvec_kmap_local(&bv);
+			if (ic->tag_size < ic->tuple_size)
+				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
+			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, dio->integrity_payload + pos);
+			kunmap_local(mem);
+			pos += ic->tuple_size;
+			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+		}
+	}
+
+	ret = bio_integrity_add_page(bio, virt_to_page(dio->integrity_payload),
+					payload_len, offset_in_page(dio->integrity_payload));
+	if (unlikely(ret != payload_len)) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static inline void dm_integrity_free_payload(struct dm_integrity_io *dio)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	if (unlikely(dio->integrity_payload_from_mempool))
+		mempool_free(virt_to_page(dio->integrity_payload), &ic->recheck_pool);
+	else
+		kfree(dio->integrity_payload);
+	dio->integrity_payload = NULL;
+	dio->integrity_payload_from_mempool = false;
+}
+
+static void dm_integrity_inline_recheck(struct work_struct *w)
+{
+	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_c *ic = dio->ic;
+	struct bio *outgoing_bio;
+	void *outgoing_data;
+
+	dio->integrity_payload = page_to_virt((struct page *)mempool_alloc(&ic->recheck_pool, GFP_NOIO));
+	dio->integrity_payload_from_mempool = true;
+
+	outgoing_data = dio->integrity_payload + PAGE_SIZE;
+
+	while (dio->bio_details.bi_iter.bi_size) {
+		char digest[HASH_MAX_DIGESTSIZE];
+		int r;
+		struct bio_integrity_payload *bip;
+		struct bio_vec bv;
+		char *mem;
+
+		outgoing_bio = bio_alloc_bioset(ic->dev->bdev, 1, REQ_OP_READ, GFP_NOIO, &ic->recheck_bios);
+
+		r = bio_add_page(outgoing_bio, virt_to_page(outgoing_data), ic->sectors_per_block << SECTOR_SHIFT, 0);
+		if (unlikely(r != (ic->sectors_per_block << SECTOR_SHIFT))) {
+			bio_put(outgoing_bio);
+			bio->bi_status = BLK_STS_RESOURCE;
+			bio_endio(bio);
+			return;
+		}
+
+		bip = bio_integrity_alloc(outgoing_bio, GFP_NOIO, 1);
+		if (unlikely(IS_ERR(bip))) {
+			bio_put(outgoing_bio);
+			bio->bi_status = errno_to_blk_status(PTR_ERR(bip));
+			bio_endio(bio);
+			return;
+		}
+
+		r = bio_integrity_add_page(outgoing_bio, virt_to_page(dio->integrity_payload), ic->tuple_size, 0);
+		if (unlikely(r != ic->tuple_size)) {
+			bio_put(outgoing_bio);
+			bio->bi_status = BLK_STS_RESOURCE;
+			bio_endio(bio);
+			return;
+		}
+
+		outgoing_bio->bi_iter.bi_sector = dio->bio_details.bi_iter.bi_sector + ic->start + SB_SECTORS;
+
+		r = submit_bio_wait(outgoing_bio);
+		if (unlikely(r != 0)) {
+			bio_put(outgoing_bio);
+			bio->bi_status = errno_to_blk_status(r);
+			bio_endio(bio);
+			return;
+		}
+		bio_put(outgoing_bio);
+
+		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
+		if (unlikely(memcmp(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
+				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
+			atomic64_inc(&ic->number_of_mismatches);
+			dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum",
+				bio, dio->bio_details.bi_iter.bi_sector, 0);
+
+			bio->bi_status = BLK_STS_PROTECTION;
+			bio_endio(bio);
+			return;
+		}
+
+		bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
+		mem = bvec_kmap_local(&bv);
+		memcpy(mem, outgoing_data, ic->sectors_per_block << SECTOR_SHIFT);
+		kunmap_local(mem);
+
+		bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+	}
+
+	bio_endio(bio);
+}
+
+static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *status)
+{
+	struct dm_integrity_c *ic = ti->private;
+	if (ic->mode == 'I') {
+		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK)) {
+			unsigned pos = 0;
+			while (dio->bio_details.bi_iter.bi_size) {
+				char digest[HASH_MAX_DIGESTSIZE];
+				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
+				char *mem = bvec_kmap_local(&bv);
+				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
+				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
+				if (unlikely(memcmp(digest, dio->integrity_payload + pos,
+						min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+					kunmap_local(mem);
+					dm_integrity_free_payload(dio);
+					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
+					queue_work(ic->offload_wq, &dio->work);
+					return DM_ENDIO_INCOMPLETE;
+				}
+				kunmap_local(mem);
+				pos += ic->tuple_size;
+				bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+			}
+		}
+		if (likely(dio->op == REQ_OP_READ) || likely(dio->op == REQ_OP_WRITE)) {
+			dm_integrity_free_payload(dio);
+		}
+	}
+	return DM_ENDIO_DONE;
+}
 
 static void integrity_bio_wait(struct work_struct *w)
 {
@@ -2432,6 +2659,9 @@ static void integrity_commit(struct work
 
 	del_timer(&ic->autocommit_timer);
 
+	if (ic->mode == 'I')
+		return;
+
 	spin_lock_irq(&ic->endio_wait.lock);
 	flushes = bio_list_get(&ic->flush_bio_list);
 	if (unlikely(ic->mode != 'J')) {
@@ -3523,7 +3753,10 @@ static int calculate_device_limits(struc
 		return -EINVAL;
 	ic->initial_sectors = initial_sectors;
 
-	if (!ic->meta_dev) {
+	if (ic->mode == 'I') {
+		if (ic->initial_sectors + ic->provided_data_sectors > ic->meta_device_sectors)
+			return -EINVAL;
+	} else if (!ic->meta_dev) {
 		sector_t last_sector, last_area, last_offset;
 
 		/* we have to maintain excessive padding for compatibility with existing volumes */
@@ -3586,6 +3819,8 @@ static int initialize_superblock(struct
 
 	memset(ic->sb, 0, SB_SECTORS << SECTOR_SHIFT);
 	memcpy(ic->sb->magic, SB_MAGIC, 8);
+	if (ic->mode == 'I')
+		ic->sb->flags |= cpu_to_le32(SB_FLAG_INLINE);
 	ic->sb->integrity_tag_size = cpu_to_le16(ic->tag_size);
 	ic->sb->log2_sectors_per_block = __ffs(ic->sectors_per_block);
 	if (ic->journal_mac_alg.alg_string)
@@ -3595,6 +3830,8 @@ static int initialize_superblock(struct
 	journal_sections = journal_sectors / ic->journal_section_sectors;
 	if (!journal_sections)
 		journal_sections = 1;
+	if (ic->mode == 'I')
+		journal_sections = 0;
 
 	if (ic->fix_hmac && (ic->internal_hash_alg.alg_string || ic->journal_mac_alg.alg_string)) {
 		ic->sb->flags |= cpu_to_le32(SB_FLAG_FIXED_HMAC);
@@ -4157,10 +4394,11 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 
 	if (!strcmp(argv[3], "J") || !strcmp(argv[3], "B") ||
-	    !strcmp(argv[3], "D") || !strcmp(argv[3], "R")) {
+	    !strcmp(argv[3], "D") || !strcmp(argv[3], "R") ||
+	    !strcmp(argv[3], "I")) {
 		ic->mode = argv[3][0];
 	} else {
-		ti->error = "Invalid mode (expecting J, B, D, R)";
+		ti->error = "Invalid mode (expecting J, B, D, R, I)";
 		r = -EINVAL;
 		goto bad;
 	}
@@ -4306,6 +4544,53 @@ static int dm_integrity_ctr(struct dm_ta
 	else
 		ic->log2_tag_size = -1;
 
+	if (ic->mode == 'I') {
+		struct blk_integrity *bi;
+		if (ic->meta_dev) {
+			r = -EINVAL;
+			ti->error = "Metadata device not supported in inline mode";
+			goto bad;
+		}
+		if (!ic->internal_hash_alg.alg_string) {
+			r = -EINVAL;
+			ti->error = "Internal hash not set in inline mode";
+			goto bad;
+		}
+		if (ic->journal_crypt_alg.alg_string || ic->journal_mac_alg.alg_string) {
+			r = -EINVAL;
+			ti->error = "Journal crypt not supported in inline mode";
+			goto bad;
+		}
+		if (ic->discard) {
+			r = -EINVAL;
+			ti->error = "Discards not supported in inline mode";
+			goto bad;
+		}
+		bi = blk_get_integrity(ic->dev->bdev->bd_disk);
+		if (!bi) {
+			r = -EINVAL;
+			ti->error = "The underlying device has no integrity profile";
+			goto bad;
+		}
+		/*printk("tag_size: %u, tuple_size: %u\n", bi->tag_size, bi->tuple_size);*/
+		if (bi->tuple_size < ic->tag_size) {
+			r = -EINVAL;
+			ti->error = "The integrity profile is smaller than tag size";
+			goto bad;
+		}
+		if (bi->tuple_size > PAGE_SIZE / 2) {
+			r = -EINVAL;
+			ti->error = "Too big tuple size";
+			goto bad;
+		}
+		ic->tuple_size = bi->tuple_size;
+		if (1 << bi->interval_exp != ic->sectors_per_block << SECTOR_SHIFT) {
+			r = -EINVAL;
+			ti->error = "Integrity profile sector size mismatch";
+			goto bad;
+		}
+	}
+
 	if (ic->mode == 'B' && !ic->internal_hash) {
 		r = -EINVAL;
 		ti->error = "Bitmap mode can be only used with internal hash";
@@ -4336,12 +4621,26 @@ static int dm_integrity_ctr(struct dm_ta
 		goto bad;
 	}
 
-	r = mempool_init_page_pool(&ic->recheck_pool, 1, 0);
+	r = mempool_init_page_pool(&ic->recheck_pool, 1, ic->mode == 'I' ? 1 : 0);
 	if (r) {
 		ti->error = "Cannot allocate mempool";
 		goto bad;
 	}
 
+	if (ic->mode == 'I') {
+		r = bioset_init(&ic->recheck_bios, RECHECK_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+		if (r) {
+			ti->error = "Cannot allocate bio set";
+			goto bad;
+		}
+		r = bioset_integrity_create(&ic->recheck_bios, RECHECK_POOL_SIZE);
+		if (r) {
+			ti->error = "Cannot allocate bio integrity set";
+			r = -ENOMEM;
+			goto bad;
+		}
+	}
+
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
 					  WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
 	if (!ic->metadata_wq) {
@@ -4418,11 +4717,16 @@ static int dm_integrity_ctr(struct dm_ta
 			should_write_sb = true;
 	}
 
-	if (!ic->sb->version || ic->sb->version > SB_VERSION_5) {
+	if (!ic->sb->version || ic->sb->version > SB_VERSION_6) {
 		r = -EINVAL;
 		ti->error = "Unknown version";
 		goto bad;
 	}
+	if (!!(ic->sb->flags & cpu_to_le32(SB_FLAG_INLINE)) != (ic->mode == 'I')) {
+		r = -EINVAL;
+		ti->error = "Inline flag mismatch";
+		goto bad;
+	}
 	if (le16_to_cpu(ic->sb->integrity_tag_size) != ic->tag_size) {
 		r = -EINVAL;
 		ti->error = "Tag size doesn't match the information in superblock";
@@ -4433,9 +4737,12 @@ static int dm_integrity_ctr(struct dm_ta
 		ti->error = "Block size doesn't match the information in superblock";
 		goto bad;
 	}
-	if (!le32_to_cpu(ic->sb->journal_sections)) {
+	if (!le32_to_cpu(ic->sb->journal_sections) != (ic->mode == 'I')) {
 		r = -EINVAL;
-		ti->error = "Corrupted superblock, journal_sections is 0";
+		if (ic->mode != 'I')
+			ti->error = "Corrupted superblock, journal_sections is 0";
+		else
+			ti->error = "Corrupted superblock, journal_sections is not 0";
 		goto bad;
 	}
 	/* make sure that ti->max_io_len doesn't overflow */
@@ -4487,8 +4794,9 @@ try_smaller_buffer:
 	bits_in_journal = ((__u64)ic->journal_section_sectors * ic->journal_sections) << (SECTOR_SHIFT + 3);
 	if (bits_in_journal > UINT_MAX)
 		bits_in_journal = UINT_MAX;
-	while (bits_in_journal < (ic->provided_data_sectors + ((sector_t)1 << log2_sectors_per_bitmap_bit) - 1) >> log2_sectors_per_bitmap_bit)
-		log2_sectors_per_bitmap_bit++;
+	if (bits_in_journal)
+		while (bits_in_journal < (ic->provided_data_sectors + ((sector_t)1 << log2_sectors_per_bitmap_bit) - 1) >> log2_sectors_per_bitmap_bit)
+			log2_sectors_per_bitmap_bit++;
 
 	log2_blocks_per_bitmap_bit = log2_sectors_per_bitmap_bit - ic->sb->log2_sectors_per_block;
 	ic->log2_blocks_per_bitmap_bit = log2_blocks_per_bitmap_bit;
@@ -4508,7 +4816,6 @@ try_smaller_buffer:
 		goto bad;
 	}
 
-
 	threshold = (__u64)ic->journal_entries * (100 - journal_watermark);
 	threshold += 50;
 	do_div(threshold, 100);
@@ -4560,17 +4867,19 @@ try_smaller_buffer:
 		goto bad;
 	}
 
-	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
-			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
-	if (IS_ERR(ic->bufio)) {
-		r = PTR_ERR(ic->bufio);
-		ti->error = "Cannot initialize dm-bufio";
-		ic->bufio = NULL;
-		goto bad;
+	if (ic->mode != 'I') {
+		ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
+				1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
+		if (IS_ERR(ic->bufio)) {
+			r = PTR_ERR(ic->bufio);
+			ti->error = "Cannot initialize dm-bufio";
+			ic->bufio = NULL;
+			goto bad;
+		}
+		dm_bufio_set_sector_offset(ic->bufio, ic->start + ic->initial_sectors);
 	}
-	dm_bufio_set_sector_offset(ic->bufio, ic->start + ic->initial_sectors);
 
-	if (ic->mode != 'R') {
+	if (ic->mode != 'R' && ic->mode != 'I') {
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
@@ -4630,7 +4939,7 @@ try_smaller_buffer:
 		ic->just_formatted = true;
 	}
 
-	if (!ic->meta_dev) {
+	if (!ic->meta_dev && ic->mode != 'I') {
 		r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
 		if (r)
 			goto bad;
@@ -4657,6 +4966,9 @@ try_smaller_buffer:
 	if (ic->discard)
 		ti->num_discard_bios = 1;
 
+	if (ic->mode == 'I')
+		ti->mempool_needs_integrity = true;
+
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
 
@@ -4690,6 +5002,7 @@ static void dm_integrity_dtr(struct dm_t
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
+	bioset_exit(&ic->recheck_bios);
 	mempool_exit(&ic->recheck_pool);
 	mempool_exit(&ic->journal_io_mempool);
 	if (ic->io)
@@ -4749,6 +5062,7 @@ static struct target_type integrity_targ
 	.ctr			= dm_integrity_ctr,
 	.dtr			= dm_integrity_dtr,
 	.map			= dm_integrity_map,
+	.end_io			= dm_integrity_end_io,
 	.postsuspend		= dm_integrity_postsuspend,
 	.resume			= dm_integrity_resume,
 	.status			= dm_integrity_status,

