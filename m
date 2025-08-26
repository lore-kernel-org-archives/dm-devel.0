Received: from leontynka.twibright.com (leontynka.twibright.com [109.81.181.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6645306D3F;
	Tue, 26 Aug 2025 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.81.181.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217915; cv=none; b=jq0C4irIJDIFv1ALObkT1mfK/4bvbXYA9DjcIFgKBNXpnf8b3lmon7degAnks30g47l7FsaHKaBQqC/KgK9duQ/L6F235opk4vDZf1WDWh8VVpncHE9PWpv+arDCwtXWWBeV0A+uy08NkeNeCPjsVRphYZl/4VXMtReQThsJ4AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217915; c=relaxed/simple;
	bh=kOx2wyAS5FIlvweLVk9mWXhq0zauNHlUJaZZUd/rijY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=IK/XKl+Z9RooqkPaX26w2RSMCzLISuSB93u8gZVhF+S+I8PPcU5RlPXepY0oqWd7HqzIQoP5hH3LBt4WKHhrr5HSd//+/St7y4Ox6b/MuMoiXnt8B2OpZVgaPxvGTsukIQyKSt44ZSS6JigLKQBJpFtnDaI+EwdsFmQE0P6e+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; arc=none smtp.client-ip=109.81.181.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from zen ([192.168.128.17] helo=debian.vm)
	by leontynka.twibright.com with smtp (Exim 4.96)
	(envelope-from <mpatocka@redhat.com>)
	id 1uqu9Q-008VrV-3D;
	Tue, 26 Aug 2025 15:55:53 +0200
Received: by debian.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 15:55:52 +0200
Message-ID: <20250826135552.498962056@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 15:54:56 +0200
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
Subject: [PATCH 3/7] dm-integrity: introduce integrity_kmap and integrity_kunmap
References: <20250826135453.012446010@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

This abstraction will be used later, for the asynchronous hash interface.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-21 18:21:12.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-21 18:22:00.000000000 +0200
@@ -1688,6 +1688,16 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
+static void *integrity_kmap(struct dm_integrity_c *ic, struct page *p)
+{
+	return kmap_local_page(p);
+}
+
+static void integrity_kunmap(struct dm_integrity_c *ic, const void *ptr)
+{
+	kunmap_local(ptr);
+}
+
 static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
 {
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
@@ -1838,7 +1848,7 @@ static void integrity_metadata(struct wo
 			char *mem, *checksums_ptr;
 
 again:
-			mem = kmap_local_page(bv_copy.bv_page);
+			mem = integrity_kmap(ic, bv_copy.bv_page);
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1848,7 +1858,7 @@ again:
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
 				sector += ic->sectors_per_block;
 			} while (pos < bv_copy.bv_len && sectors_to_process && checksums != checksums_onstack);
-			kunmap_local(mem);
+			integrity_kunmap(ic, mem);
 
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
@@ -2072,19 +2082,6 @@ retry_kmap:
 					js++;
 					mem_ptr += 1 << SECTOR_SHIFT;
 				} while (++s < ic->sectors_per_block);
-#ifdef INTERNAL_VERIFY
-				if (ic->internal_hash) {
-					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
-
-					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
-					if (unlikely(crypto_memneq(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
-						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
-							    logical_sector);
-						dm_audit_log_bio(DM_MSG_PREFIX, "journal-checksum",
-								 bio, logical_sector, 0);
-					}
-				}
-#endif
 			}
 
 			if (!ic->internal_hash) {
@@ -2506,11 +2503,11 @@ skip_spinlock:
 		unsigned pos = 0;
 		while (dio->bio_details.bi_iter.bi_size) {
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-			const char *mem = kmap_local_page(bv.bv_page);
+			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
 				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
 			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, dio->integrity_payload + pos);
-			kunmap_local(mem);
+			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;
 			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
 		}
@@ -2626,17 +2623,17 @@ static int dm_integrity_end_io(struct dm
 			while (dio->bio_details.bi_iter.bi_size) {
 				char digest[HASH_MAX_DIGESTSIZE];
 				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-				char *mem = kmap_local_page(bv.bv_page);
+				char *mem = integrity_kmap(ic, bv.bv_page);
 				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, digest);
 				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
 						min(ic->internal_hash_digestsize, ic->tag_size)))) {
-					kunmap_local(mem);
+					integrity_kunmap(ic, mem);
 					dm_integrity_free_payload(dio);
 					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
 					queue_work(ic->offload_wq, &dio->work);
 					return DM_ENDIO_INCOMPLETE;
 				}
-				kunmap_local(mem);
+				integrity_kunmap(ic, mem);
 				pos += ic->tuple_size;
 				bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
 			}

