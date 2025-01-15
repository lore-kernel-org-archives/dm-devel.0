Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D79158DD8
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736959630; cv=none; b=A3GkMbrJZlohLMlLCi14+spuG1PhVP9h+1ns1kosjMEm1kHCXG2E97QYfh7upCiuMPRAE9r5zmifzjpl8MGvOmL1kqNYzC6M3h6Xcj0/30O7S6oQJPV3zCpaGdYfT1RAvR4DZu2LRGKKcrKBilsDhXiQaGNTq3mYih4FevllrXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736959630; c=relaxed/simple;
	bh=G+fvF48YfbKuog3nI67/dt1+JMG6V5Tpe/UHt2hhdCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8gmSTG2Edp2UGrrEALi4p/FBroBKfJjdDrOGprVtG2IefcUtH5Bps4k0lFRn/fJKeksr3vKkWusCqA2dll0QkYkbyzb2JRjpOP6rwSWS8Oc8WJlWpvb9BkNHi/Vo9JvZPCqu6O3iDpzu4/Z8gdXSHoQpMqDpSb3kNHI1ujRinQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=latSbLJi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="latSbLJi"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGYe5l002621;
	Wed, 15 Jan 2025 16:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=scpuqhXPhbiuq44wy
	jfbjdOTgP76P4lcB3OUmTPwB5U=; b=latSbLJian6+bErHkudQIzvgSESBJCPVV
	CZp/pi2wA6GzDHkZHZNpcuBUBOa13im1zhEtZOPiMrUAlpNzd1JQAyyOGv7Gi9DR
	vH1ZcSTwJns08EyMF0boeUSqJu0XhB8TKQYmq29JCbQJrots/Z32fotTGC/tIzeV
	ejNZEepxQJT7sAGh0EDZDQkXLiN7130d+kF1AKOV5W+RQEQwBV8Sn5nsJPeDN8jR
	PswZVjY5iffnWCXGTAe/zbEX58iKjuwsndfzAVf/iVURFRafBlO4ZwgXDEyn9BZC
	LWpDjVPPUcy/qsh0kuBBr7ZmJaa7Dkw7dwwA8LhyfUf4wYVd6evzw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4465gbue8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:47:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FEYwsT017366;
	Wed, 15 Jan 2025 16:47:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk99hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:47:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGkw7A26935768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:46:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 754F32004B;
	Wed, 15 Jan 2025 16:46:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08BB020043;
	Wed, 15 Jan 2025 16:46:58 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:46:57 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        ifranzki@linux.ibm.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, dengler@linux.ibm.com
Subject: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Date: Wed, 15 Jan 2025 17:46:57 +0100
Message-ID: <20250115164657.84650-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250115164657.84650-1-freude@linux.ibm.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LTXOP66trlUHBc0MPESF1sJCcK-BV80A
X-Proofpoint-ORIG-GUID: LTXOP66trlUHBc0MPESF1sJCcK-BV80A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501150122

Use the async digest in-kernel crypto API instead of the
synchronous digest API. This has the advantage of being able
to use synchronous as well as asynchronous digest implementations
as the in-kernel API has an automatic wrapping mechanism
to provide all synchronous digests via the asynch API.

Tested with crc32, sha256, hmac-sha256 and the s390 specific
implementations for hmac-sha256 and protected key phmac-sha256.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/md/dm-integrity.c | 220 ++++++++++++++++++++++++--------------
 1 file changed, 138 insertions(+), 82 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ee9f7cecd78e..1504db9276d1 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -195,7 +195,7 @@ struct dm_integrity_c {
 	struct scatterlist **journal_io_scatterlist;
 	struct skcipher_request **sk_requests;
 
-	struct crypto_shash *journal_mac;
+	struct crypto_ahash *journal_mac;
 
 	struct journal_node *journal_tree;
 	struct rb_root journal_tree_root;
@@ -221,7 +221,7 @@ struct dm_integrity_c {
 
 	int failed;
 
-	struct crypto_shash *internal_hash;
+	struct crypto_ahash *internal_hash;
 
 	struct dm_target *ti;
 
@@ -488,11 +488,14 @@ static void sb_set_version(struct dm_integrity_c *ic)
 
 static int sb_mac(struct dm_integrity_c *ic, bool wr)
 {
-	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
-	int r;
-	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
+	unsigned int mac_size = crypto_ahash_digestsize(ic->journal_mac);
 	__u8 *sb = (__u8 *)ic->sb;
 	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
+	struct ahash_request *req;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct scatterlist sg;
+	unsigned int nbytes;
+	int r;
 
 	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT ||
 	    mac_size > HASH_MAX_DIGESTSIZE) {
@@ -500,29 +503,44 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
 		return -EINVAL;
 	}
 
-	desc->tfm = ic->journal_mac;
+	req = ahash_request_alloc(ic->journal_mac, GFP_KERNEL);
+	if (unlikely(!req)) {
+		dm_integrity_io_error(ic, "ahash_request_alloc", -ENOMEM);
+		return -ENOMEM;
+	}
+	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
+
+	sg_init_table(&sg, 1);
+	nbytes = mac - sb;
+	sg_set_buf(&sg, sb, nbytes);
 
 	if (likely(wr)) {
-		r = crypto_shash_digest(desc, sb, mac - sb, mac);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_digest", r);
+		ahash_request_set_crypt(req, &sg, mac, nbytes);
+		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_ahash_digest", r);
+			ahash_request_free(req);
 			return r;
 		}
 	} else {
 		__u8 actual_mac[HASH_MAX_DIGESTSIZE];
 
-		r = crypto_shash_digest(desc, sb, mac - sb, actual_mac);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_digest", r);
+		ahash_request_set_crypt(req, &sg, actual_mac, nbytes);
+		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_ahash_digest", r);
+			ahash_request_free(req);
 			return r;
 		}
 		if (memcmp(mac, actual_mac, mac_size)) {
 			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
 			dm_audit_log_target(DM_MSG_PREFIX, "mac-superblock", ic->ti, 0);
+			ahash_request_free(req);
 			return -EILSEQ;
 		}
 	}
 
+	ahash_request_free(req);
 	return 0;
 }
 
@@ -775,51 +793,62 @@ static struct journal_sector *access_journal_data(struct dm_integrity_c *ic, uns
 
 static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 result[JOURNAL_MAC_SIZE])
 {
-	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
+	unsigned int j, size, nsg, nbytes = 0;
+	struct scatterlist *sg = NULL, *s;
+	struct ahash_request *req = NULL;
+	DECLARE_CRYPTO_WAIT(wait);
+	__le64 *section_le = NULL;
 	int r;
-	unsigned int j, size;
 
-	desc->tfm = ic->journal_mac;
+	req = ahash_request_alloc(ic->journal_mac, GFP_KERNEL);
+	if (unlikely(!req)) {
+		dm_integrity_io_error(ic, "ahash_request_alloc", -ENOMEM);
+		goto err;
+	}
+	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
 
-	r = crypto_shash_init(desc);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_init", r);
+	nsg = ic->journal_section_entries;
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC))
+		nsg += 2;
+	sg = kmalloc_array(nsg, sizeof(*sg), GFP_KERNEL);
+	if (unlikely(!sg)) {
+		dm_integrity_io_error(ic, "kmalloc_array", -ENOMEM);
 		goto err;
 	}
+	sg_init_table(sg, nsg);
+	s = sg;
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
-		__le64 section_le;
-
-		r = crypto_shash_update(desc, (__u8 *)&ic->sb->salt, SALT_SIZE);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_update", r);
-			goto err;
-		}
+		sg_set_buf(s, (__u8 *)&ic->sb->salt, SALT_SIZE);
+		nbytes += SALT_SIZE;
+		s++;
 
-		section_le = cpu_to_le64(section);
-		r = crypto_shash_update(desc, (__u8 *)&section_le, sizeof(section_le));
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_update", r);
+		section_le = kmalloc(sizeof(__le64), GFP_KERNEL);
+		if (unlikely(!section_le)) {
+			dm_integrity_io_error(ic, "kmalloc(sizeof(__le64))", -ENOMEM);
 			goto err;
 		}
+		*section_le = cpu_to_le64(section);
+		sg_set_buf(s, (__u8 *)section_le, sizeof(*section_le));
+		nbytes += sizeof(*section_le);
+		s++;
 	}
 
 	for (j = 0; j < ic->journal_section_entries; j++) {
 		struct journal_entry *je = access_journal_entry(ic, section, j);
 
-		r = crypto_shash_update(desc, (__u8 *)&je->u.sector, sizeof(je->u.sector));
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_update", r);
-			goto err;
-		}
+		sg_set_buf(s, (__u8 *)&je->u.sector, sizeof(je->u.sector));
+		nbytes += sizeof(je->u.sector);
+		s++;
 	}
 
-	size = crypto_shash_digestsize(ic->journal_mac);
+	size = crypto_ahash_digestsize(ic->journal_mac);
 
 	if (likely(size <= JOURNAL_MAC_SIZE)) {
-		r = crypto_shash_final(desc, result);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_final", r);
+		ahash_request_set_crypt(req, sg, result, nbytes);
+		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_ahash_digest", r);
 			goto err;
 		}
 		memset(result + size, 0, JOURNAL_MAC_SIZE - size);
@@ -830,16 +859,24 @@ static void section_mac(struct dm_integrity_c *ic, unsigned int section, __u8 re
 			dm_integrity_io_error(ic, "digest_size", -EINVAL);
 			goto err;
 		}
-		r = crypto_shash_final(desc, digest);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_final", r);
+		ahash_request_set_crypt(req, sg, digest, nbytes);
+		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		if (unlikely(r)) {
+			dm_integrity_io_error(ic, "crypto_ahash_digest", r);
 			goto err;
 		}
 		memcpy(result, digest, JOURNAL_MAC_SIZE);
 	}
 
+	ahash_request_free(req);
+	kfree(section_le);
+	kfree(sg);
 	return;
+
 err:
+	ahash_request_free(req);
+	kfree(section_le);
+	kfree(sg);
 	memset(result, 0, JOURNAL_MAC_SIZE);
 }
 
@@ -1637,53 +1674,65 @@ static void integrity_end_io(struct bio *bio)
 static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
 				      const char *data, char *result)
 {
-	__le64 sector_le = cpu_to_le64(sector);
-	SHASH_DESC_ON_STACK(req, ic->internal_hash);
-	int r;
+	struct ahash_request *req = NULL;
+	struct scatterlist sg[3], *s;
+	DECLARE_CRYPTO_WAIT(wait);
+	__le64 *sector_le = NULL;
 	unsigned int digest_size;
+	unsigned int nbytes = 0;
+	int r;
 
-	req->tfm = ic->internal_hash;
-
-	r = crypto_shash_init(req);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_init", r);
+	req = ahash_request_alloc(ic->internal_hash, GFP_KERNEL);
+	if (unlikely(!req)) {
+		dm_integrity_io_error(ic, "ahash_request_alloc", -ENOMEM);
 		goto failed;
 	}
+	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
 
+	s = sg;
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
-		r = crypto_shash_update(req, (__u8 *)&ic->sb->salt, SALT_SIZE);
-		if (unlikely(r < 0)) {
-			dm_integrity_io_error(ic, "crypto_shash_update", r);
-			goto failed;
-		}
+		sg_init_table(sg, 3);
+		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
+		nbytes += SALT_SIZE;
+		s++;
+	} else {
+		sg_init_table(sg, 2);
 	}
 
-	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof(sector_le));
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_update", r);
+	sector_le = kmalloc(sizeof(__le64), GFP_KERNEL);
+	if (unlikely(!sector_le)) {
+		dm_integrity_io_error(ic, "kmalloc(sizeof(__le64))", -ENOMEM);
 		goto failed;
 	}
+	*sector_le = cpu_to_le64(sector);
+	sg_set_buf(s, (const __u8 *)sector_le, sizeof(*sector_le));
+	nbytes += sizeof(*sector_le);
+	s++;
 
-	r = crypto_shash_update(req, data, ic->sectors_per_block << SECTOR_SHIFT);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		goto failed;
-	}
+	sg_set_buf(s, data, ic->sectors_per_block << SECTOR_SHIFT);
+	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
+
+	ahash_request_set_crypt(req, sg, result, nbytes);
 
-	r = crypto_shash_final(req, result);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_final", r);
+	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+	if (r) {
+		dm_integrity_io_error(ic, "crypto_ahash_digest", r);
 		goto failed;
 	}
 
-	digest_size = crypto_shash_digestsize(ic->internal_hash);
+	digest_size = crypto_ahash_digestsize(ic->internal_hash);
 	if (unlikely(digest_size < ic->tag_size))
 		memset(result + digest_size, 0, ic->tag_size - digest_size);
 
+	ahash_request_free(req);
+	kfree(sector_le);
+
 	return;
 
 failed:
 	/* this shouldn't happen anyway, the hash functions have no reason to fail */
+	ahash_request_free(req);
+	kfree(sector_le);
 	get_random_bytes(result, ic->tag_size);
 }
 
@@ -1776,7 +1825,7 @@ static void integrity_metadata(struct work_struct *w)
 	if (ic->internal_hash) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
-		unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+		unsigned int digest_size = crypto_ahash_digestsize(ic->internal_hash);
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
@@ -2124,7 +2173,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 
 				if (ic->internal_hash) {
-					unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+					unsigned int digest_size = crypto_ahash_digestsize(ic->internal_hash);
 
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
@@ -2428,7 +2477,7 @@ static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map)
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
 		dio->payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
-		digest_size = crypto_shash_digestsize(ic->internal_hash);
+		digest_size = crypto_ahash_digestsize(ic->internal_hash);
 		extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
 		dio->payload_len += extra_size;
 		dio->integrity_payload = kmalloc(dio->payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
@@ -2595,7 +2644,7 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 		bio_put(outgoing_bio);
 
 		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
-		if (unlikely(memcmp(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+		if (unlikely(memcmp(digest, dio->integrity_payload, min(crypto_ahash_digestsize(ic->internal_hash), ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
 			atomic64_inc(&ic->number_of_mismatches);
@@ -2635,7 +2684,7 @@ static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status
 				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
 				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
 				if (unlikely(memcmp(digest, dio->integrity_payload + pos,
-						min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+						min(crypto_ahash_digestsize(ic->internal_hash), ic->tag_size)))) {
 					kunmap_local(mem);
 					dm_integrity_free_payload(dio);
 					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
@@ -3017,8 +3066,8 @@ static void integrity_recalc(struct work_struct *w)
 		goto free_ret;
 	}
 	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size;
-	if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
-		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+	if (crypto_ahash_digestsize(ic->internal_hash) > ic->tag_size)
+		recalc_tags_size += crypto_ahash_digestsize(ic->internal_hash) - ic->tag_size;
 	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
 	if (!recalc_tags) {
 		vfree(recalc_buffer);
@@ -3177,8 +3226,8 @@ static void integrity_recalc_inline(struct work_struct *w)
 	}
 
 	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tuple_size;
-	if (crypto_shash_digestsize(ic->internal_hash) > ic->tuple_size)
-		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tuple_size;
+	if (crypto_ahash_digestsize(ic->internal_hash) > ic->tuple_size)
+		recalc_tags_size += crypto_ahash_digestsize(ic->internal_hash) - ic->tuple_size;
 	recalc_tags = kmalloc(recalc_tags_size, GFP_NOIO | __GFP_NOWARN);
 	if (!recalc_tags) {
 		kfree(recalc_buffer);
@@ -4187,6 +4236,8 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
 	if (!a->alg_string)
 		goto nomem;
 
+	DEBUG_print("%s: alg_string=%s\n", __func__, a->alg_string);
+
 	k = strchr(a->alg_string, ':');
 	if (k) {
 		*k = 0;
@@ -4198,6 +4249,9 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
 		a->key = kmalloc(a->key_size, GFP_KERNEL);
 		if (!a->key)
 			goto nomem;
+
+		DEBUG_print("%s: key=%s\n", __func__, a->key_string);
+
 		if (hex2bin(a->key, a->key_string, a->key_size))
 			goto inval;
 	}
@@ -4211,13 +4265,15 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
 	return -ENOMEM;
 }
 
-static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
+static int get_mac(struct crypto_ahash **hash, struct alg_spec *a, char **error,
 		   char *error_alg, char *error_key)
 {
 	int r;
 
+	DEBUG_print(">%s\n", __func__);
+
 	if (a->alg_string) {
-		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+		*hash = crypto_alloc_ahash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(*hash)) {
 			*error = error_alg;
 			r = PTR_ERR(*hash);
@@ -4226,12 +4282,12 @@ static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
 		}
 
 		if (a->key) {
-			r = crypto_shash_setkey(*hash, a->key, a->key_size);
+			r = crypto_ahash_setkey(*hash, a->key, a->key_size);
 			if (r) {
 				*error = error_key;
 				return r;
 			}
-		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
+		} else if (crypto_ahash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
 			*error = error_key;
 			return -ENOKEY;
 		}
@@ -4707,7 +4763,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			r = -EINVAL;
 			goto bad;
 		}
-		ic->tag_size = crypto_shash_digestsize(ic->internal_hash);
+		ic->tag_size = crypto_ahash_digestsize(ic->internal_hash);
 	}
 	if (ic->tag_size > MAX_TAG_SIZE) {
 		ti->error = "Too big tag size";
@@ -5226,7 +5282,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
 
 	if (ic->internal_hash)
-		crypto_free_shash(ic->internal_hash);
+		crypto_free_ahash(ic->internal_hash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)
@@ -5234,7 +5290,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	free_alg(&ic->journal_crypt_alg);
 
 	if (ic->journal_mac)
-		crypto_free_shash(ic->journal_mac);
+		crypto_free_ahash(ic->journal_mac);
 	free_alg(&ic->journal_mac_alg);
 
 	kfree(ic);
-- 
2.43.0

