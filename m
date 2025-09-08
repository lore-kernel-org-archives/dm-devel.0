Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350DF3054D9
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757337506; cv=none; b=Rc1TGmD3vcrf54Vb+h3xxniLa0z71BbzP79vvM1pFFg/0qYtzX9SFWD7kELZgwE+ob+W7LTUBqe4E4jWcu7h/djhYH/mnRX3ZbNwdQJVp/WRTzdvPPW3PRlC7CzhwMr7Am34YFHF4DtIUQeR6YzmYZKlrOF7l0clln0J3NnzWi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757337506; c=relaxed/simple;
	bh=PK0y0vqtsy6YkAkyBvw6BE/xj6vfcZUDENEyZlWAzG4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=iDCeyNlyUX7Q2cfDsby7Js4JmEJX68iXxi35mu1TryJX+TcEZ3CCvZS9TFAgJPsYzcFyADWgeTx5vpZ22rbbuH3TwXo6m1p2ac5lvzwvQtM0Mfw6vhChM6KaUL7G8Ljy9hmyWMVnFzPF8YFdNoQ3Y9f0IQVTIA9FRQoDOtjxh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7kkl3mo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7kkl3mo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757337503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=bVVzzwf9omM4d7hkeIxwEE/rlE76W3S1JrGVa6DtMKY=;
	b=f7kkl3mow5oL027GsozpMt7/8RX7WPlDZjLt6fFf1NFqDSQfj+zINKGgzE8L6Xiiyszf/V
	KzxUVgWbNO/7k/aesGHt1nyfiCj9Ak3GpisT1X8HCzdD8P3vs8OCAViMWtqVK2SCdYjM47
	H/ejzd+NrZlTh+dXbq4vPSxa7NaJorE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-50BIsSqkOUSbNrQHvul63Q-1; Mon,
 08 Sep 2025 09:18:19 -0400
X-MC-Unique: 50BIsSqkOUSbNrQHvul63Q-1
X-Mimecast-MFC-AGG-ID: 50BIsSqkOUSbNrQHvul63Q_1757337498
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18B9718002C0;
	Mon,  8 Sep 2025 13:18:18 +0000 (UTC)
Received: from debian4.vm (unknown [10.44.32.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 0E9281955F24;
	Mon,  8 Sep 2025 13:18:13 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Mon, 08 Sep 2025 15:18:11 +0200
Message-ID: <20250908131811.800802198@debian4.vm>
User-Agent: quilt/0.68
Date: Mon, 08 Sep 2025 15:16:49 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com,
 linux-s390@vger.kernel.org,
 dm-devel@lists.linux.dev,
 ifranzki@linux.ibm.com,
 agk@redhat.com,
 snitzer@kernel.org,
 gmazyland@gmail.com,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2 7/7] dm-integrity: enable asynchronous hash interface
References: <20250908131642.385445532@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This commit enables the asynchronous hash interface in dm-integrity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |  243 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 199 insertions(+), 44 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-09-03 15:41:06.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-09-03 16:25:58.000000000 +0200
@@ -224,6 +224,7 @@ struct dm_integrity_c {
 	int failed;
 
 	struct crypto_shash *internal_shash;
+	struct crypto_ahash *internal_ahash;
 	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
@@ -279,6 +280,9 @@ struct dm_integrity_c {
 	bool fix_hmac;
 	bool legacy_recalculate;
 
+	mempool_t ahash_req_pool;
+	struct ahash_request *journal_ahash_req;
+
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
 	struct alg_spec journal_mac_alg;
@@ -328,6 +332,8 @@ struct dm_integrity_io {
 	unsigned payload_len;
 	bool integrity_payload_from_mempool;
 	bool integrity_range_locked;
+
+	struct ahash_request *ahash_req;
 };
 
 struct journal_completion {
@@ -354,6 +360,7 @@ struct bitmap_block_status {
 static struct kmem_cache *journal_io_cache;
 
 #define JOURNAL_IO_MEMPOOL	32
+#define AHASH_MEMPOOL		32
 
 #ifdef DEBUG_PRINT
 #define DEBUG_print(x, ...)			printk(KERN_DEBUG x, ##__VA_ARGS__)
@@ -1636,8 +1643,8 @@ static void integrity_end_io(struct bio
 	dec_in_flight(dio);
 }
 
-static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
-				      const char *data, unsigned offset, char *result)
+static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t sector,
+					    const char *data, unsigned offset, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_shash);
@@ -1689,14 +1696,90 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
+static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
+					    sector_t sector, struct page *page, unsigned offset, char *result)
+{
+	__le64 sector_le = cpu_to_le64(sector);
+	struct ahash_request *req;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct scatterlist sg[3], *s = sg;
+	int r;
+	unsigned int digest_size;
+	unsigned int nbytes = 0;
+
+	might_sleep();
+
+	req = *ahash_req;
+	if (unlikely(!req)) {
+		req = mempool_alloc(&ic->ahash_req_pool, GFP_NOIO);
+		*ahash_req = req;
+	}
+
+	ahash_request_set_tfm(req, ic->internal_ahash);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done, &wait);
+
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
+		sg_init_table(sg, 3);
+		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
+		nbytes += SALT_SIZE;
+		s++;
+	} else {
+		sg_init_table(sg, 2);
+	}
+
+	if (likely(!is_vmalloc_addr(&sector_le))) {
+		sg_set_buf(s, &sector_le, sizeof(sector_le));
+	} else {
+		struct page *sec_page = vmalloc_to_page(&sector_le);
+		unsigned int sec_off = offset_in_page(&sector_le);
+		sg_set_page(s, sec_page, sizeof(sector_le), sec_off);
+	}
+	nbytes += sizeof(sector_le);
+	s++;
+
+	sg_set_page(s, page, ic->sectors_per_block << SECTOR_SHIFT, offset);
+	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
+
+	ahash_request_set_crypt(req, sg, result, nbytes);
+
+	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "crypto_ahash_digest", r);
+		goto failed;
+	}
+
+	digest_size = ic->internal_hash_digestsize;
+	if (unlikely(digest_size < ic->tag_size))
+		memset(result + digest_size, 0, ic->tag_size - digest_size);
+
+	return;
+
+failed:
+	/* this shouldn't happen anyway, the hash functions have no reason to fail */
+	get_random_bytes(result, ic->tag_size);
+}
+
+static void integrity_sector_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
+				      sector_t sector, const char *data, unsigned offset, char *result)
+{
+	if (likely(ic->internal_shash != NULL))
+		integrity_sector_checksum_shash(ic, sector, data, offset, result);
+	else
+		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data, offset, result);
+}
+
 static void *integrity_kmap(struct dm_integrity_c *ic, struct page *p)
 {
-	return kmap_local_page(p);
+	if (likely(ic->internal_shash != NULL))
+		return kmap_local_page(p);
+	else
+		return p;
 }
 
 static void integrity_kunmap(struct dm_integrity_c *ic, const void *ptr)
 {
-	kunmap_local(ptr);
+	if (likely(ic->internal_shash != NULL))
+		kunmap_local(ptr);
 }
 
 static void *integrity_identity(struct dm_integrity_c *ic, void *data)
@@ -1705,7 +1788,10 @@ static void *integrity_identity(struct d
 	BUG_ON(offset_in_page(data));
 	BUG_ON(!virt_addr_valid(data));
 #endif
-	return data;
+	if (likely(ic->internal_shash != NULL))
+		return data;
+	else
+		return virt_to_page(data);
 }
 
 static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
@@ -1759,7 +1845,7 @@ static noinline void integrity_recheck(s
 				goto free_ret;
 			}
 
-			integrity_sector_checksum(ic, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
+			integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
 			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
 						&dio->metadata_offset, ic->tag_size, TAG_CMP);
 			if (r) {
@@ -1863,7 +1949,7 @@ again:
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
-				integrity_sector_checksum(ic, sector, mem, bv_copy.bv_offset + pos, checksums_ptr);
+				integrity_sector_checksum(ic, &dio->ahash_req, sector, mem, bv_copy.bv_offset + pos, checksums_ptr);
 				checksums_ptr += ic->tag_size;
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
@@ -1971,6 +2057,7 @@ static int dm_integrity_map(struct dm_ta
 	dio->ic = ic;
 	dio->bi_status = 0;
 	dio->op = bio_op(bio);
+	dio->ahash_req = NULL;
 
 	if (ic->mode == 'I') {
 		bio->bi_iter.bi_sector = dm_target_offset(ic->ti, bio->bi_iter.bi_sector);
@@ -2140,10 +2227,10 @@ retry_kmap:
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
 
-						integrity_sector_checksum(ic, logical_sector, js_page, js_offset, checksums_onstack);
+						integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, js_page, js_offset, checksums_onstack);
 						memcpy(journal_entry_tag(ic, je), checksums_onstack, ic->tag_size);
 					} else
-						integrity_sector_checksum(ic, logical_sector, js_page, js_offset, journal_entry_tag(ic, je));
+						integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, js_page, js_offset, journal_entry_tag(ic, je));
 				}
 
 				journal_entry_set_sector(je, logical_sector);
@@ -2519,7 +2606,7 @@ skip_spinlock:
 			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
 				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
-			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
+			integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
 			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;
 			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
@@ -2599,7 +2686,7 @@ static void dm_integrity_inline_recheck(
 		}
 		bio_put(outgoing_bio);
 
-		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, integrity_identity(ic, outgoing_data), 0, digest);
+		integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, integrity_identity(ic, outgoing_data), 0, digest);
 		if (unlikely(crypto_memneq(digest, dio->integrity_payload, min(ic->internal_hash_digestsize, ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
@@ -2623,32 +2710,58 @@ static void dm_integrity_inline_recheck(
 	bio_endio(bio);
 }
 
+static inline bool dm_integrity_check(struct dm_integrity_c *ic, struct dm_integrity_io *dio)
+{
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	unsigned pos = 0;
+
+	while (dio->bio_details.bi_iter.bi_size) {
+		char digest[HASH_MAX_DIGESTSIZE];
+		struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
+		char *mem = integrity_kmap(ic, bv.bv_page);
+		integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);
+		if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
+				min(ic->internal_hash_digestsize, ic->tag_size)))) {
+			integrity_kunmap(ic, mem);
+			dm_integrity_free_payload(dio);
+			INIT_WORK(&dio->work, dm_integrity_inline_recheck);
+			queue_work(ic->offload_wq, &dio->work);
+			return false;
+		}
+		integrity_kunmap(ic, mem);
+		pos += ic->tuple_size;
+		bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+	}
+
+	return true;
+}
+
+static void dm_integrity_inline_async_check(struct work_struct *w)
+{
+	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
+	struct dm_integrity_c *ic = dio->ic;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+
+	if (likely(dm_integrity_check(ic, dio)))
+		bio_endio(bio);
+}
+
 static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *status)
 {
 	struct dm_integrity_c *ic = ti->private;
+	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
 	if (ic->mode == 'I') {
-		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
-		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK)) {
-			unsigned pos = 0;
+		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK) && likely(dio->bio_details.bi_iter.bi_size != 0)) {
 			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
 			    unlikely(dio->integrity_range_locked))
-				goto skip_check;
-			while (dio->bio_details.bi_iter.bi_size) {
-				char digest[HASH_MAX_DIGESTSIZE];
-				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-				char *mem = integrity_kmap(ic, bv.bv_page);
-				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);
-				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
-						min(ic->internal_hash_digestsize, ic->tag_size)))) {
-					integrity_kunmap(ic, mem);
-					dm_integrity_free_payload(dio);
-					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
-					queue_work(ic->offload_wq, &dio->work);
+			    	goto skip_check;
+			if (likely(ic->internal_shash != NULL)) {
+				if (unlikely(!dm_integrity_check(ic, dio)))
 					return DM_ENDIO_INCOMPLETE;
-				}
-				integrity_kunmap(ic, mem);
-				pos += ic->tuple_size;
-				bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+			} else {
+				INIT_WORK(&dio->work, dm_integrity_inline_async_check);
+				queue_work(ic->offload_wq, &dio->work);
+				return DM_ENDIO_INCOMPLETE;
 			}
 		}
 skip_check:
@@ -2656,6 +2769,8 @@ skip_check:
 		if (unlikely(dio->integrity_range_locked))
 			remove_range(ic, &dio->range);
 	}
+	if (unlikely(dio->ahash_req))
+		mempool_free(dio->ahash_req, &ic->ahash_req_pool);
 	return DM_ENDIO_DONE;
 }
 
@@ -2916,7 +3031,7 @@ static void do_journal_write(struct dm_i
 					void *js_page = integrity_identity(ic, (char *)js - offset_in_page(js));
 					unsigned js_offset = offset_in_page(js);
 
-					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
+					integrity_sector_checksum(ic, &ic->journal_ahash_req, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  js_page, js_offset, test_tag);
 					if (unlikely(crypto_memneq(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
 						dm_integrity_io_error(ic, "tag mismatch when replaying journal", -EILSEQ);
@@ -3000,6 +3115,7 @@ static void integrity_recalc(struct work
 	size_t recalc_tags_size;
 	u8 *recalc_buffer = NULL;
 	u8 *recalc_tags = NULL;
+	struct ahash_request *ahash_req = NULL;
 	struct dm_integrity_range range;
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
@@ -3113,7 +3229,7 @@ next_chunk:
 		void *ptr = recalc_buffer + (i << SECTOR_SHIFT);
 		void *ptr_page = integrity_identity(ic, (char *)ptr - offset_in_page(ptr));
 		unsigned ptr_offset = offset_in_page(ptr);
-		integrity_sector_checksum(ic, logical_sector + i, ptr_page, ptr_offset, t);
+		integrity_sector_checksum(ic, &ahash_req, logical_sector + i, ptr_page, ptr_offset, t);
 		t += ic->tag_size;
 	}
 
@@ -3157,6 +3273,7 @@ unlock_ret:
 free_ret:
 	kfree(recalc_buffer);
 	kvfree(recalc_tags);
+	mempool_free(ahash_req, &ic->ahash_req_pool);
 }
 
 static void integrity_recalc_inline(struct work_struct *w)
@@ -3165,6 +3282,7 @@ static void integrity_recalc_inline(stru
 	size_t recalc_tags_size;
 	u8 *recalc_buffer = NULL;
 	u8 *recalc_tags = NULL;
+	struct ahash_request *ahash_req = NULL;
 	struct dm_integrity_range range;
 	struct bio *bio;
 	struct bio_integrity_payload *bip;
@@ -3237,7 +3355,7 @@ next_chunk:
 		void *ptr_page = integrity_identity(ic, (char *)ptr - offset_in_page(ptr));
 		unsigned ptr_offset = offset_in_page(ptr);
 		memset(t, 0, ic->tuple_size);
-		integrity_sector_checksum(ic, range.logical_sector + i, ptr_page, ptr_offset, t);
+		integrity_sector_checksum(ic, &ahash_req, range.logical_sector + i, ptr_page, ptr_offset, t);
 		t += ic->tuple_size;
 	}
 
@@ -3289,6 +3407,7 @@ unlock_ret:
 free_ret:
 	kfree(recalc_buffer);
 	kfree(recalc_tags);
+	mempool_free(ahash_req, &ic->ahash_req_pool);
 }
 
 static void bitmap_block_work(struct work_struct *w)
@@ -4229,27 +4348,49 @@ nomem:
 	return -ENOMEM;
 }
 
-static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
-		   char *error_alg, char *error_key)
+static int get_mac(struct crypto_shash **shash, struct crypto_ahash **ahash,
+		   struct alg_spec *a, char **error, char *error_alg, char *error_key)
 {
 	int r;
 
 	if (a->alg_string) {
-		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
-		if (IS_ERR(*hash)) {
+		if (ahash) {
+			*ahash = crypto_alloc_ahash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+			if (IS_ERR(*ahash)) {
+				*ahash = NULL;
+				goto try_shash;
+			}
+
+			if (a->key) {
+				r = crypto_ahash_setkey(*ahash, a->key, a->key_size);
+				if (r) {
+					*error = error_key;
+					return r;
+				}
+			} else if (crypto_ahash_get_flags(*ahash) & CRYPTO_TFM_NEED_KEY) {
+				*error = error_key;
+				return -ENOKEY;
+			}
+
+			return 0;
+		}
+
+try_shash:
+		*shash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+		if (IS_ERR(*shash)) {
 			*error = error_alg;
-			r = PTR_ERR(*hash);
-			*hash = NULL;
+			r = PTR_ERR(*shash);
+			*shash = NULL;
 			return r;
 		}
 
 		if (a->key) {
-			r = crypto_shash_setkey(*hash, a->key, a->key_size);
+			r = crypto_shash_setkey(*shash, a->key, a->key_size);
 			if (r) {
 				*error = error_key;
 				return r;
 			}
-		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
+		} else if (crypto_shash_get_flags(*shash) & CRYPTO_TFM_NEED_KEY) {
 			*error = error_key;
 			return -ENOKEY;
 		}
@@ -4709,7 +4850,7 @@ static int dm_integrity_ctr(struct dm_ta
 		buffer_sectors = 1;
 	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
 
-	r = get_mac(&ic->internal_shash, &ic->internal_hash_alg, &ti->error,
+	r = get_mac(&ic->internal_shash, &ic->internal_ahash, &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
@@ -4717,8 +4858,18 @@ static int dm_integrity_ctr(struct dm_ta
 		ic->internal_hash = true;
 		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_shash);
 	}
+	if (ic->internal_ahash) {
+		ic->internal_hash = true;
+		ic->internal_hash_digestsize = crypto_ahash_digestsize(ic->internal_ahash);
+		r = mempool_init_kmalloc_pool(&ic->ahash_req_pool, AHASH_MEMPOOL,
+					      sizeof(struct ahash_request) + crypto_ahash_reqsize(ic->internal_ahash));
+		if (r) {
+			ti->error = "Cannot allocate mempool";
+			goto bad;
+		}
+	}
 
-	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
+	r = get_mac(&ic->journal_mac, NULL, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
 	if (r)
 		goto bad;
@@ -5201,6 +5352,8 @@ static void dm_integrity_dtr(struct dm_t
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
+	mempool_free(ic->journal_ahash_req, &ic->ahash_req_pool);
+	mempool_exit(&ic->ahash_req_pool);
 	bioset_exit(&ic->recalc_bios);
 	bioset_exit(&ic->recheck_bios);
 	mempool_exit(&ic->recheck_pool);
@@ -5240,6 +5393,8 @@ static void dm_integrity_dtr(struct dm_t
 
 	if (ic->internal_shash)
 		crypto_free_shash(ic->internal_shash);
+	if (ic->internal_ahash)
+		crypto_free_ahash(ic->internal_ahash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)
@@ -5256,7 +5411,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 13, 0},
+	.version		= {1, 14, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,

