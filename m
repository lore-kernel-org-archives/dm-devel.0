Received: from leontynka.twibright.com (leontynka.twibright.com [109.81.181.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC98352FDF;
	Tue, 26 Aug 2025 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.81.181.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217786; cv=none; b=o2QmPGbf4wyJeDjq77tEjSccQMTfDPG8Xa7rhRqnos7QfWaJyei07SAQfJvyCxrVVemBLdSQakvkXeUxfu5lABI9XEij4+05D3R9Rs6gyavOVRdC5DliMrLUWv3V7pgepDxsxKp8m1lneRUNJcFz85YG5nvSVvgKniU57cvao9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217786; c=relaxed/simple;
	bh=dn2NfWACofZ69eOD3sNRkPRFohsh/ayFLZUSR3XeEBY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=evJpigB+K/SyELGN7iKmWLL3MwS60nNo7Xom2DJNBJoiCCpJNFgzzzB0NcZQ15z+eu4TqlMVDOCwj8slVopCTOch8ePGarw3R979QDt/MjLjRxIis0/gHu693HaMm33i7L7nstMSrQcUXzEORDdjLP5Wb5mxPHNG0isMMq9rsV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; arc=none smtp.client-ip=109.81.181.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from zen ([192.168.128.17] helo=debian.vm)
	by leontynka.twibright.com with smtp (Exim 4.96)
	(envelope-from <mpatocka@redhat.com>)
	id 1uqu9W-008Vs1-0f;
	Tue, 26 Aug 2025 15:55:59 +0200
Received: by debian.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 15:55:57 +0200
Message-ID: <20250826135557.707275415@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 15:55:00 +0200
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
Subject: [PATCH 7/7] dm-integrity: enable asynchronous hash interface
References: <20250826135453.012446010@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

This commit enables the asynchronous hash interface in dm-integrity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |  196 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 162 insertions(+), 34 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-25 18:17:21.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-25 22:08:31.000000000 +0200
@@ -224,6 +224,7 @@ struct dm_integrity_c {
 	int failed;
 
 	struct crypto_shash *internal_shash;
+	struct crypto_ahash *internal_ahash;
 	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
@@ -1636,8 +1637,8 @@ static void integrity_end_io(struct bio
 	dec_in_flight(dio);
 }
 
-static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
-				      const char *data, unsigned offset, char *result)
+static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t sector,
+					    const char *data, unsigned offset, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_shash);
@@ -1689,14 +1690,84 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
+static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, sector_t sector,
+					    struct page *page, unsigned offset, char *result)
+{
+	__le64 sector_le = cpu_to_le64(sector);
+	HASH_REQUEST_ON_STACK(req, ic->internal_ahash);
+	DECLARE_CRYPTO_WAIT(wait);
+	struct scatterlist sg[3], *s = sg;
+	int r;
+	unsigned int digest_size;
+	unsigned int nbytes = 0;
+
+	might_sleep();
+
+	req->base.flags &= ~CRYPTO_TFM_REQ_ON_STACK;
+	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
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
+	s++;
+	nbytes += sizeof(sector_le);
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
+static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
+				      const char *data, unsigned offset, char *result)
+{
+	if (likely(ic->internal_shash != NULL))
+		integrity_sector_checksum_shash(ic, sector, data, offset, result);
+	else
+		integrity_sector_checksum_ahash(ic, sector, (struct page *)data, offset, result);
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
@@ -1705,7 +1776,10 @@ static void *integrity_identity(struct d
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
@@ -2623,32 +2697,58 @@ static void dm_integrity_inline_recheck(
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
+		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);
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
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_c *ic = dio->ic;
+
+	if (likely(dm_integrity_check(ic, dio)))
+		bio_endio(bio);
+}
+
 static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *status)
 {
 	struct dm_integrity_c *ic = ti->private;
 	if (ic->mode == 'I') {
 		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
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
@@ -4229,27 +4329,49 @@ nomem:
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
@@ -4709,7 +4831,7 @@ static int dm_integrity_ctr(struct dm_ta
 		buffer_sectors = 1;
 	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
 
-	r = get_mac(&ic->internal_shash, &ic->internal_hash_alg, &ti->error,
+	r = get_mac(&ic->internal_shash, &ic->internal_ahash, &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
@@ -4717,8 +4839,12 @@ static int dm_integrity_ctr(struct dm_ta
 		ic->internal_hash = true;
 		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_shash);
 	}
+	if (ic->internal_ahash) {
+		ic->internal_hash = true;
+		ic->internal_hash_digestsize = crypto_ahash_digestsize(ic->internal_ahash);
+	}
 
-	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
+	r = get_mac(&ic->journal_mac, NULL, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
 	if (r)
 		goto bad;
@@ -5240,6 +5366,8 @@ static void dm_integrity_dtr(struct dm_t
 
 	if (ic->internal_shash)
 		crypto_free_shash(ic->internal_shash);
+	if (ic->internal_ahash)
+		crypto_free_ahash(ic->internal_ahash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)
@@ -5256,7 +5384,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 13, 0},
+	.version		= {1, 14, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,

