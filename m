Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA27350851
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219184; cv=none; b=GOOb/RADCyRRU4HU6ixN/RRnMg/BIC/3kt45z26SlFICrc3pb/hB9QytLjN+HFWmqTy+kqykQVtD+FuvuW80tEAoOR/eEAsVM5uAKFh7rr7cxbDdg4Njh2IzVrLwmDvRYvotKfolVZ4kbGnTaJQ3Y6iKnCq+qREctJfjw1rzNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219184; c=relaxed/simple;
	bh=8ul5Q8Jg9G8zT+8Lv4JBfXa5L0K8sfBsqMWdFr3Zb3w=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=YO8iqJ+jbeO+vcwmWwCOyVJhTPeUwWaq6oyhVeEUqjWYJFovySd85CUJDuKdb4wJ16VWDkVKWi8QxOQQ2wxseozmIZ/diqZOdn0gQD6yUx2TmOG/ttnghFnyaThO2JoXyQZHrax8F3TIThc3cP2lUCHgbv/sFMOEbuKN20sHFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+AJOwFb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+AJOwFb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=18aezES7Qs6TSKuBa37MTJtT/YYWss2+BiGhUjsgBXw=;
	b=M+AJOwFb/Ai3xdnsJy/o+z6ByXfBG1Ddn4sfut3mFCyagKTDGm/fpMDkRg5190yW3+jMia
	pIaSs10MN1mxwBf8TKvjEHhGtWQlmFfSOfS0h4PuaaxvDVepKq7tOvHBWu1wsnfYf9XLto
	oVRs0hDXhiHJXI5q+ChpSfcotCQNkv8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-c9Ur-ChFPbGKGKy4zfiH0w-1; Tue,
 26 Aug 2025 10:39:36 -0400
X-MC-Unique: c9Ur-ChFPbGKGKy4zfiH0w-1
X-Mimecast-MFC-AGG-ID: c9Ur-ChFPbGKGKy4zfiH0w_1756219175
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98062195608F;
	Tue, 26 Aug 2025 14:39:34 +0000 (UTC)
Received: from debian4.vm (unknown [10.22.80.227])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 33E8330001A2;
	Tue, 26 Aug 2025 14:39:29 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 16:39:28 +0200
Message-ID: <20250826143928.454641830@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 16:36:47 +0200
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
Subject: [PATCH 1/7] dm-integrity: use internal variable for digestsize
References: <20250826143646.570314717@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Instead of calling digestsize() each time the digestsize for
the internal hash is needed, store the digestsize in a new
field internal_hash_digestsize within struct dm_integrity_c
once and use this value when needed.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-15 17:31:52.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-15 17:33:14.000000000 +0200
@@ -223,6 +223,7 @@ struct dm_integrity_c {
 	int failed;
 
 	struct crypto_shash *internal_hash;
+	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
 
@@ -1676,7 +1677,7 @@ static void integrity_sector_checksum(st
 		goto failed;
 	}
 
-	digest_size = crypto_shash_digestsize(ic->internal_hash);
+	digest_size = ic->internal_hash_digestsize;
 	if (unlikely(digest_size < ic->tag_size))
 		memset(result + digest_size, 0, ic->tag_size - digest_size);
 
@@ -1776,7 +1777,7 @@ static void integrity_metadata(struct wo
 	if (ic->internal_hash) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
-		unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+		unsigned int digest_size = ic->internal_hash_digestsize;
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
@@ -2124,7 +2125,7 @@ retry_kmap:
 				} while (++s < ic->sectors_per_block);
 
 				if (ic->internal_hash) {
-					unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+					unsigned int digest_size = ic->internal_hash_digestsize;
 
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
@@ -2428,7 +2429,7 @@ retry:
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
 		dio->payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
-		digest_size = crypto_shash_digestsize(ic->internal_hash);
+		digest_size = ic->internal_hash_digestsize;
 		extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
 		dio->payload_len += extra_size;
 		dio->integrity_payload = kmalloc(dio->payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
@@ -2589,7 +2590,7 @@ static void dm_integrity_inline_recheck(
 		bio_put(outgoing_bio);
 
 		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
-		if (unlikely(crypto_memneq(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+		if (unlikely(crypto_memneq(digest, dio->integrity_payload, min(ic->internal_hash_digestsize, ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
 			atomic64_inc(&ic->number_of_mismatches);
@@ -2629,7 +2630,7 @@ static int dm_integrity_end_io(struct dm
 				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
 				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
 				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
-						min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+						min(ic->internal_hash_digestsize, ic->tag_size)))) {
 					kunmap_local(mem);
 					dm_integrity_free_payload(dio);
 					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
@@ -3011,8 +3012,8 @@ oom:
 		goto free_ret;
 	}
 	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size;
-	if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
-		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+	if (ic->internal_hash_digestsize > ic->tag_size)
+		recalc_tags_size += ic->internal_hash_digestsize - ic->tag_size;
 	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
 	if (!recalc_tags) {
 		vfree(recalc_buffer);
@@ -3171,8 +3172,8 @@ oom:
 	}
 
 	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tuple_size;
-	if (crypto_shash_digestsize(ic->internal_hash) > ic->tuple_size)
-		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tuple_size;
+	if (ic->internal_hash_digestsize > ic->tuple_size)
+		recalc_tags_size += ic->internal_hash_digestsize - ic->tuple_size;
 	recalc_tags = kmalloc(recalc_tags_size, GFP_NOIO | __GFP_NOWARN);
 	if (!recalc_tags) {
 		kfree(recalc_buffer);
@@ -4694,6 +4695,8 @@ static int dm_integrity_ctr(struct dm_ta
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
+	if (ic->internal_hash)
+		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_hash);
 
 	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
@@ -4706,7 +4709,7 @@ static int dm_integrity_ctr(struct dm_ta
 			r = -EINVAL;
 			goto bad;
 		}
-		ic->tag_size = crypto_shash_digestsize(ic->internal_hash);
+		ic->tag_size = ic->internal_hash_digestsize;
 	}
 	if (ic->tag_size > MAX_TAG_SIZE) {
 		ti->error = "Too big tag size";

