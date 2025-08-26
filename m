Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B432635CEB2
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219206; cv=none; b=mZfbRuFL7s4ozqLCJR137/3kHutoMfaCoz5aDgBTFB0bNrtkgVh7jU+KGi15sEln90YAfkj8EdR4CON/uec54UUMdA9vhYcsOxUmJ5O1XmCzBIH9Yd/nOFpE6Lmacru5a07zf8wPo2FRB+OctdWkNwi4Jkp22otXtiDVEOBWmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219206; c=relaxed/simple;
	bh=rvF5jSUwWOoTNaTQBb5u1CfGCNm0egn2f1ssl98Y4Bs=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=C/ZN9NnL9LNolYRUlUhQ+FsaO9VqRdwTkJ17lqtqcl36naEZSjVtKsrgOmw3U1r63iHukLsns7B83VFFZJN0X0CRFmWYM9x2bwQqguiUEE6fAz29yQVatcabYhiEnQzVmM9hv/TmmE5b951MFC/Sj+jnM7hQ5kt5+N+AyTtAcfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqypFged; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqypFged"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=VYqi+N/TuOiFMps/2KbLsF+zFjOeuKWpoElaMu1qObQ=;
	b=RqypFgedcAzKv0qH+5oP7PcZOs/GtFZ1/R92+NrASz8m+LRyILFS3uW7F/lrZDZVnc2qKN
	FPy7De9XURg+RGkoxdZJqVL2oO4kTMa3mzv3OrpNhiime5doSfp5Z4nnPVjG8/aHHjHZun
	NH1NBu7z4Rv80zMpJ71F4ugYTfkL5RM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-UAw-A35UNZ-e5yNZnTYccQ-1; Tue,
 26 Aug 2025 10:39:59 -0400
X-MC-Unique: UAw-A35UNZ-e5yNZnTYccQ-1
X-Mimecast-MFC-AGG-ID: UAw-A35UNZ-e5yNZnTYccQ_1756219198
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 167E0195609F;
	Tue, 26 Aug 2025 14:39:58 +0000 (UTC)
Received: from debian4.vm (unknown [10.22.80.227])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 916B819560AB;
	Tue, 26 Aug 2025 14:39:53 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 16:39:51 +0200
Message-ID: <20250826143951.838912710@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 16:36:51 +0200
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
Subject: [PATCH 5/7] dm-integrity: add the "offset" argument
References: <20250826143646.570314717@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Make sure that the "data" argument passed to integrity_sector_checksum is
always page-aligned and add an "offset" argument that specifies the
offset from the start of the page. This will enable us to use the
asynchronous hash interface later.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |   49 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-25 15:38:52.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-25 15:40:31.000000000 +0200
@@ -1636,7 +1636,7 @@ static void integrity_end_io(struct bio
 }
 
 static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
-				      const char *data, char *result)
+				      const char *data, unsigned offset, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_hash);
@@ -1665,7 +1665,7 @@ static void integrity_sector_checksum(st
 		goto failed;
 	}
 
-	r = crypto_shash_update(req, data, ic->sectors_per_block << SECTOR_SHIFT);
+	r = crypto_shash_update(req, data + offset, ic->sectors_per_block << SECTOR_SHIFT);
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_update", r);
 		goto failed;
@@ -1698,6 +1698,15 @@ static void integrity_kunmap(struct dm_i
 	kunmap_local(ptr);
 }
 
+static void *integrity_identity(struct dm_integrity_c *ic, void *data)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(offset_in_page(data));
+	BUG_ON(!virt_addr_valid(data));
+#endif
+	return data;
+}
+
 static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
 {
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
@@ -1722,6 +1731,7 @@ static noinline void integrity_recheck(s
 			sector_t alignment;
 			char *mem;
 			char *buffer = page_to_virt(page);
+			unsigned int buffer_offset;
 			int r;
 			struct dm_io_request io_req;
 			struct dm_io_region io_loc;
@@ -1739,7 +1749,7 @@ static noinline void integrity_recheck(s
 			alignment &= -alignment;
 			io_loc.sector = round_down(io_loc.sector, alignment);
 			io_loc.count += sector - io_loc.sector;
-			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
+			buffer_offset = (sector - io_loc.sector) << SECTOR_SHIFT;
 			io_loc.count = round_up(io_loc.count, alignment);
 
 			r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
@@ -1748,7 +1758,7 @@ static noinline void integrity_recheck(s
 				goto free_ret;
 			}
 
-			integrity_sector_checksum(ic, logical_sector, buffer, checksum);
+			integrity_sector_checksum(ic, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
 			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
 						&dio->metadata_offset, ic->tag_size, TAG_CMP);
 			if (r) {
@@ -1765,7 +1775,7 @@ static noinline void integrity_recheck(s
 			}
 
 			mem = bvec_kmap_local(&bv);
-			memcpy(mem + pos, buffer, ic->sectors_per_block << SECTOR_SHIFT);
+			memcpy(mem + pos, buffer + buffer_offset, ic->sectors_per_block << SECTOR_SHIFT);
 			kunmap_local(mem);
 
 			pos += ic->sectors_per_block << SECTOR_SHIFT;
@@ -1852,7 +1862,7 @@ again:
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
-				integrity_sector_checksum(ic, sector, mem + bv_copy.bv_offset + pos, checksums_ptr);
+				integrity_sector_checksum(ic, sector, mem, bv_copy.bv_offset + pos, checksums_ptr);
 				checksums_ptr += ic->tag_size;
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
@@ -2123,14 +2133,16 @@ retry_kmap:
 
 				if (ic->internal_hash) {
 					unsigned int digest_size = ic->internal_hash_digestsize;
+					void *js_page = integrity_identity(ic, (char *)js - offset_in_page(js));
+					unsigned js_offset = offset_in_page(js);
 
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
 
-						integrity_sector_checksum(ic, logical_sector, (char *)js, checksums_onstack);
+						integrity_sector_checksum(ic, logical_sector, js_page, js_offset, checksums_onstack);
 						memcpy(journal_entry_tag(ic, je), checksums_onstack, ic->tag_size);
 					} else
-						integrity_sector_checksum(ic, logical_sector, (char *)js, journal_entry_tag(ic, je));
+						integrity_sector_checksum(ic, logical_sector, js_page, js_offset, journal_entry_tag(ic, je));
 				}
 
 				journal_entry_set_sector(je, logical_sector);
@@ -2506,7 +2518,7 @@ skip_spinlock:
 			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
 				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
-			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, dio->integrity_payload + pos);
+			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
 			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;
 			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
@@ -2586,7 +2598,7 @@ static void dm_integrity_inline_recheck(
 		}
 		bio_put(outgoing_bio);
 
-		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
+		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, integrity_identity(ic, outgoing_data), 0, digest);
 		if (unlikely(crypto_memneq(digest, dio->integrity_payload, min(ic->internal_hash_digestsize, ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
@@ -2624,7 +2636,7 @@ static int dm_integrity_end_io(struct dm
 				char digest[HASH_MAX_DIGESTSIZE];
 				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 				char *mem = integrity_kmap(ic, bv.bv_page);
-				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, digest);
+				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);
 				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
 						min(ic->internal_hash_digestsize, ic->tag_size)))) {
 					integrity_kunmap(ic, mem);
@@ -2899,9 +2911,12 @@ static void do_journal_write(struct dm_i
 #endif
 				    ic->internal_hash) {
 					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					struct journal_sector *js = access_journal_data(ic, i, l);
+					void *js_page = integrity_identity(ic, (char *)js - offset_in_page(js));
+					unsigned js_offset = offset_in_page(js);
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
-								  (char *)access_journal_data(ic, i, l), test_tag);
+								  js_page, js_offset, test_tag);
 					if (unlikely(crypto_memneq(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
 						dm_integrity_io_error(ic, "tag mismatch when replaying journal", -EILSEQ);
 						dm_audit_log_target(DM_MSG_PREFIX, "integrity-replay-journal", ic->ti, 0);
@@ -3094,7 +3109,10 @@ next_chunk:
 
 	t = recalc_tags;
 	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
+		void *ptr = recalc_buffer + (i << SECTOR_SHIFT);
+		void *ptr_page = integrity_identity(ic, (char *)ptr - offset_in_page(ptr));
+		unsigned ptr_offset = offset_in_page(ptr);
+		integrity_sector_checksum(ic, logical_sector + i, ptr_page, ptr_offset, t);
 		t += ic->tag_size;
 	}
 
@@ -3214,8 +3232,11 @@ next_chunk:
 
 	t = recalc_tags;
 	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
+		void *ptr = recalc_buffer + (i << SECTOR_SHIFT);
+		void *ptr_page = integrity_identity(ic, (char *)ptr - offset_in_page(ptr));
+		unsigned ptr_offset = offset_in_page(ptr);
 		memset(t, 0, ic->tuple_size);
-		integrity_sector_checksum(ic, range.logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
+		integrity_sector_checksum(ic, range.logical_sector + i, ptr_page, ptr_offset, t);
 		t += ic->tuple_size;
 	}
 

