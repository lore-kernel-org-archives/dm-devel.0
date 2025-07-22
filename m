Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7572624
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753191536; cv=none; b=qLGt8LmAqkF0lcccTOTJdkn8zPaCvf2IhmKMVZcxAa3ojzBD8K2netdWeYkH4SejcAs2adyL6n094YFTMqqTfW44z9tXqi2hPHZpVfuVwYpJn35Yy3ZRJbDeAo2CLObfLuXnyD3Hoew2Tf1jaR0yopXbmID+7jQ3ZwO4XTwpJjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753191536; c=relaxed/simple;
	bh=lZeib0hYG9ehADH6KjfUMG4Zzx11QD2kDDMK6adogmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaPoaLQp9l6uitBAtOieiYXRikxh7JZ/lZkVwqHajpmhBDBLEFBNwOAeKngPFf2noHhuN/88mbQbAiA2K8xl3NX1QqQw41Xxa9cSyLwhKtmdYc9EBl10+igzaZUZ11d6Ihbdq9Nn3kge1S57dHUib+cdzNxiZfx5eaxkNkP3CYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rcPOETFs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rcPOETFs"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MCJ3WU017775;
	Tue, 22 Jul 2025 13:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mTYT8cQYiv47JbLsS
	6OsK0C9QSDSleCPtyt7TxREJo0=; b=rcPOETFsET4roH0wfmPwGvwPHrmWqi78i
	Oc91tEg0e3B/IZprYgPgbe+G+tio0wWT04h1Uduh0/AbKXa+IqR0i+BWH85qIUx6
	VmQizCckcV6e/cfsG9IFtrMdx43gxaUwKD5hNWrmUQXFcaKEsCVSKrpU30tf4jA6
	xGukAExM25ppLJz2qjZ8RfVrUv8THHzk3UbAEWl4XHcMp43ZRbft/rO0ib/Cslsa
	F/KaCJd2AjZmkYXnJNEtiMj/6bmbqegogOOb51Mq1db3M6ClH0+PZd9wBL8O3dU0
	QGfKa922iRYUS9xyZ0+dHKo2gV6DZvStEh519nIvJdLHv6Fowd8bA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4805uqxp1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:38 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56MDWbfg016384;
	Tue, 22 Jul 2025 13:38:38 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4805uqxp1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:38 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56MCcdvC024697;
	Tue, 22 Jul 2025 13:38:37 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 480rd2arm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 13:38:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56MDcXIq52035954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 13:38:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A6AE20040;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6684E20043;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.205.11])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Jul 2025 13:38:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, mpatocka@redhat.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, gmazyland@gmail.com
Subject: [PATCH v5 2/2] dm-integrity: introduce ahash support for the internal hash
Date: Tue, 22 Jul 2025 15:38:32 +0200
Message-ID: <20250722133832.319226-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250722133832.319226-1-freude@linux.ibm.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 43KpiThMxs1P4R1YjlXnstGtmNMiNCpU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDExMiBTYWx0ZWRfX7vAP9uJyfnVV
 n5LRyMI9r2MT66xkg0dq6X8PEOY2WNDX4cXL1AEvUIu9StD/OaOqXo/iWf4DoODm5zajXtN8a4+
 50gs5G7VUFcDc4L+fxFbSUdaTNYnLGAG/myB/w+caXk3KsuNImsEbRtwEv7W2i5AsZRespHDJ/n
 6mdYSsbn6pzQlQsiis3AP3XEWIE9SLVamCQa61xrlUU8rr1mcHYvFNgFWSLh4Eaxm80pcZ3vp5M
 z27bgJuTsGVUXkSifnuvV/s/7S4ZP0DPntwsNZ/ZGsaMiu/c1fFkbJN5hYBXY32L5WGaqL5dVBm
 QwiwZFYofmj4Lu4V9f8EQbleIxhS2e0ejrtSQEiTzN3EPWTaZc6ppvV9PKeAw1LiTTBOw0Wshr3
 mSsCWq8wGX1I9Pagf81r+xc1mv6gltQbgYgs8V0ftd6iJfhXrbq1aQFbg+JlpX6sjkYabEhJ
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=687f945f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=3Sv-yYmx81DwnBrmGtYA:9
X-Proofpoint-GUID: lzQDUK1sbqyejygab8lhVpxU-0i6fiTl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220112

From: Mikulas Patocka <mpatocka@redhat.com>

Introduce ahash support for the "internal hash" algorithm.

Rework the dm-integrity code to be able to run the "internal hash"
either with a synchronous ("shash") or asynchronous ("ahash") hash
algorithm implementation.

The get_mac() function now tries to decide which of the digest
implementations to use if there is a choice:
- If an ahash and shash tfm is available and both are backed by the
  same driver name it is assumed that the shash is the faster
  implementation and thus the shash tfm is delivered to the caller.
- If an ahash and shash tfm is available but the backing device driver
  divers (different driver names) it is assumed that the ahash
  implementation is a "better" hardware based implementation and thus
  the ahash tfm is delivered to the caller.
- If there is no choice, for example only an ahash or an shash
  implementation is available then this tfm is delivered to the
  caller. Especially in cases where only an ahash implementation is
  available this is now used instead of failing.
- The caller can steer this choice by passing a NULL to the ahash or
  shash parameter, thus enforcing to only allocate an algorithm of the
  remaining possibility.

The function integrity_sector_checksum() is now only a dispatcher
function calling one of the two new functions
integrity_ahash_sector_checksum() or integrity_shash_sector_checksum()
based on which tfm is allocated based on the two new fields
internal_shash and internal_ahash in struct dm_integrity_c.

Together with this comes some slight rework around availability and
digest size of the internal hash in use.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/md/dm-integrity.c | 352 +++++++++++++++++++++++++++-----------
 1 file changed, 254 insertions(+), 98 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 40f5bd5b0764..9dd1f18e0adb 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -222,7 +222,9 @@ struct dm_integrity_c {
 
 	int failed;
 
-	struct crypto_shash *internal_hash;
+	bool have_internal_hash;
+	struct crypto_shash *internal_shash;
+	struct crypto_ahash *internal_ahash;
 	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
@@ -289,6 +291,8 @@ struct dm_integrity_c {
 	struct bio_set recalc_bios;
 
 	struct notifier_block reboot_notifier;
+
+	struct dm_integrity_io *dummy_dio;
 };
 
 struct dm_integrity_range {
@@ -327,6 +331,8 @@ struct dm_integrity_io {
 	unsigned payload_len;
 	bool integrity_payload_from_mempool;
 	bool integrity_range_locked;
+
+	__le64 sector_le;
 };
 
 struct journal_completion {
@@ -1560,7 +1566,7 @@ static void submit_flush_bio(struct dm_integrity_c *ic, struct dm_integrity_io *
 	unsigned long flags;
 
 	spin_lock_irqsave(&ic->endio_wait.lock, flags);
-	bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 	bio_list_add(&ic->flush_bio_list, bio);
 	spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
 
@@ -1588,7 +1594,7 @@ static void do_endio(struct dm_integrity_c *ic, struct bio *bio)
 
 static void do_endio_flush(struct dm_integrity_c *ic, struct dm_integrity_io *dio)
 {
-	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 
 	if (unlikely(dio->fua) && likely(!bio->bi_status) && likely(!dm_integrity_failed(ic)))
 		submit_flush_bio(ic, dio);
@@ -1607,7 +1613,7 @@ static void dec_in_flight(struct dm_integrity_io *dio)
 		if (dio->op == REQ_OP_WRITE || unlikely(dio->op == REQ_OP_DISCARD))
 			schedule_autocommit(ic);
 
-		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+		bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 		if (unlikely(dio->bi_status) && !bio->bi_status)
 			bio->bi_status = dio->bi_status;
 		if (likely(!bio->bi_status) && unlikely(bio_sectors(bio) != dio->range.n_sectors)) {
@@ -1623,7 +1629,7 @@ static void dec_in_flight(struct dm_integrity_io *dio)
 
 static void integrity_end_io(struct bio *bio)
 {
-	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_io *dio = bio->bi_private;
 
 	dm_bio_restore(&dio->bio_details, bio);
 	if (bio->bi_integrity)
@@ -1635,63 +1641,121 @@ static void integrity_end_io(struct bio *bio)
 	dec_in_flight(dio);
 }
 
-static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
-				      const char *data, char *result)
+static bool integrity_shash_sector_checksum(struct dm_integrity_io *dio,
+					    sector_t sector, const char *data,
+					    char *result)
 {
+	struct dm_integrity_c *ic = dio->ic;
 	__le64 sector_le = cpu_to_le64(sector);
-	SHASH_DESC_ON_STACK(req, ic->internal_hash);
+	SHASH_DESC_ON_STACK(req, ic->internal_shash);
 	int r;
-	unsigned int digest_size;
 
-	req->tfm = ic->internal_hash;
+	req->tfm = ic->internal_shash;
 
 	r = crypto_shash_init(req);
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_init", r);
-		goto failed;
+		return false;
 	}
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
 		r = crypto_shash_update(req, (__u8 *)&ic->sb->salt, SALT_SIZE);
 		if (unlikely(r < 0)) {
 			dm_integrity_io_error(ic, "crypto_shash_update", r);
-			goto failed;
+			return false;
 		}
 	}
 
 	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof(sector_le));
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		goto failed;
+		return false;
 	}
 
 	r = crypto_shash_update(req, data, ic->sectors_per_block << SECTOR_SHIFT);
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		goto failed;
+		return false;
 	}
 
 	r = crypto_shash_final(req, result);
 	if (unlikely(r < 0)) {
 		dm_integrity_io_error(ic, "crypto_shash_final", r);
-		goto failed;
+		return false;
 	}
 
-	digest_size = ic->internal_hash_digestsize;
-	if (unlikely(digest_size < ic->tag_size))
-		memset(result + digest_size, 0, ic->tag_size - digest_size);
+	return true;
+}
 
-	return;
+static bool integrity_ahash_sector_checksum(struct dm_integrity_io *dio,
+					    sector_t sector, const char *data,
+					    char *result)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	struct ahash_request *req = (struct ahash_request *)(dio + 1);
+	__le64 *sector_le = &dio->sector_le;
+	struct scatterlist sg[3], *s;
+	DECLARE_CRYPTO_WAIT(wait);
+	int nbytes = 0;
+	int r;
+
+	ahash_request_set_tfm(req, ic->internal_ahash);
+	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
+
+	s = sg;
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
+		sg_init_table(sg, 3);
+		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
+		nbytes += SALT_SIZE;
+		s++;
+	} else {
+		sg_init_table(sg, 2);
+	}
+
+	*sector_le = cpu_to_le64(sector);
+	sg_set_buf(s, (const __u8 *)sector_le, sizeof(*sector_le));
+	nbytes += sizeof(*sector_le);
+	s++;
+
+	sg_set_buf(s, data, ic->sectors_per_block << SECTOR_SHIFT);
+	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
+
+	ahash_request_set_crypt(req, sg, result, nbytes);
 
-failed:
-	/* this shouldn't happen anyway, the hash functions have no reason to fail */
-	get_random_bytes(result, ic->tag_size);
+	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+	if (r) {
+		dm_integrity_io_error(ic, "crypto_ahash_digest", r);
+		return false;
+	}
+
+	return true;
+}
+
+static void integrity_sector_checksum(struct dm_integrity_io *dio,
+				      sector_t sector, const char *data,
+				      char *result)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	bool r;
+
+	if (likely(ic->internal_shash))
+		r = integrity_shash_sector_checksum(dio, sector, data, result);
+	else
+		r = integrity_ahash_sector_checksum(dio, sector, data, result);
+
+	if (unlikely(!r)) {
+		get_random_bytes(result, ic->tag_size);
+	} else {
+		if (unlikely(ic->internal_hash_digestsize < ic->tag_size))
+			memset(result + ic->internal_hash_digestsize,
+			       0, ic->tag_size - ic->internal_hash_digestsize);
+	}
 }
 
 static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
 {
-	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	struct dm_integrity_c *ic = dio->ic;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 	struct bvec_iter iter;
 	struct bio_vec bv;
 	sector_t sector, logical_sector, area, offset;
@@ -1738,7 +1802,7 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 				goto free_ret;
 			}
 
-			integrity_sector_checksum(ic, logical_sector, buffer, checksum);
+			integrity_sector_checksum(dio, logical_sector, buffer, checksum);
 			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
 						&dio->metadata_offset, ic->tag_size, TAG_CMP);
 			if (r) {
@@ -1774,11 +1838,11 @@ static void integrity_metadata(struct work_struct *w)
 
 	int r;
 
-	if (ic->internal_hash) {
+	if (ic->have_internal_hash) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
 		unsigned int digest_size = ic->internal_hash_digestsize;
-		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+		struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
 		char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
@@ -1842,7 +1906,7 @@ static void integrity_metadata(struct work_struct *w)
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
-				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
+				integrity_sector_checksum(dio, sector, mem + pos, checksums_ptr);
 				checksums_ptr += ic->tag_size;
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
@@ -1942,7 +2006,7 @@ static inline bool dm_integrity_check_limits(struct dm_integrity_c *ic, sector_t
 static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_integrity_c *ic = ti->private;
-	struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_io *dio = dm_per_bio_data(bio, ic->ti->per_io_data_size);
 	struct bio_integrity_payload *bip;
 
 	sector_t area, offset;
@@ -1992,7 +2056,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_KILL;
 
 	bip = bio_integrity(bio);
-	if (!ic->internal_hash) {
+	if (!ic->have_internal_hash) {
 		if (bip) {
 			unsigned int wanted_tag_size = bio_sectors(bio) >> ic->sb->log2_sectors_per_block;
 
@@ -2073,10 +2137,10 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 					mem_ptr += 1 << SECTOR_SHIFT;
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
-				if (ic->internal_hash) {
+				if (ic->have_internal_hash) {
 					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
-					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
+					integrity_sector_checksum(dio, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(crypto_memneq(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
 						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
 							    logical_sector);
@@ -2087,7 +2151,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 #endif
 			}
 
-			if (!ic->internal_hash) {
+			if (!ic->have_internal_hash) {
 				struct bio_integrity_payload *bip = bio_integrity(bio);
 				unsigned int tag_todo = ic->tag_size;
 				char *tag_ptr = journal_entry_tag(ic, je);
@@ -2124,16 +2188,16 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 					je->last_bytes[s] = js[s].commit_id;
 				} while (++s < ic->sectors_per_block);
 
-				if (ic->internal_hash) {
+				if (ic->have_internal_hash) {
 					unsigned int digest_size = ic->internal_hash_digestsize;
 
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
 
-						integrity_sector_checksum(ic, logical_sector, (char *)js, checksums_onstack);
+						integrity_sector_checksum(dio, logical_sector, (char *)js, checksums_onstack);
 						memcpy(journal_entry_tag(ic, je), checksums_onstack, ic->tag_size);
 					} else
-						integrity_sector_checksum(ic, logical_sector, (char *)js, journal_entry_tag(ic, je));
+						integrity_sector_checksum(dio, logical_sector, (char *)js, journal_entry_tag(ic, je));
 				}
 
 				journal_entry_set_sector(je, logical_sector);
@@ -2181,13 +2245,13 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map)
 {
 	struct dm_integrity_c *ic = dio->ic;
-	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 	unsigned int journal_section, journal_entry;
 	unsigned int journal_read_pos;
 	sector_t recalc_sector;
 	struct completion read_comp;
 	bool discard_retried = false;
-	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
+	bool need_sync_io = ic->have_internal_hash && dio->op == REQ_OP_READ;
 
 	if (unlikely(dio->op == REQ_OP_DISCARD) && ic->mode != 'D')
 		need_sync_io = true;
@@ -2360,6 +2424,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 	bio_set_dev(bio, ic->dev->bdev);
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
+	bio->bi_private = dio;
 	bio->bi_end_io = integrity_end_io;
 	bio->bi_iter.bi_size = dio->range.n_sectors << SECTOR_SHIFT;
 
@@ -2410,7 +2475,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map)
 {
 	struct dm_integrity_c *ic = dio->ic;
-	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 	struct bio_integrity_payload *bip;
 	unsigned ret;
 	sector_t recalc_sector;
@@ -2509,7 +2574,7 @@ static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map)
 			const char *mem = bvec_kmap_local(&bv);
 			if (ic->tag_size < ic->tuple_size)
 				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
-			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, dio->integrity_payload + pos);
+			integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector, mem, dio->integrity_payload + pos);
 			kunmap_local(mem);
 			pos += ic->tuple_size;
 			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
@@ -2541,8 +2606,8 @@ static inline void dm_integrity_free_payload(struct dm_integrity_io *dio)
 static void dm_integrity_inline_recheck(struct work_struct *w)
 {
 	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
-	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	struct dm_integrity_c *ic = dio->ic;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 	struct bio *outgoing_bio;
 	void *outgoing_data;
 
@@ -2589,7 +2654,7 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 		}
 		bio_put(outgoing_bio);
 
-		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
+		integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
 		if (unlikely(crypto_memneq(digest, dio->integrity_payload,
 					   min(ic->internal_hash_digestsize, ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
@@ -2614,34 +2679,63 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 	bio_endio(bio);
 }
 
+static bool dm_integrity_inline_verify(struct dm_integrity_io *dio)
+{
+	struct dm_integrity_c *ic = dio->ic;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
+	unsigned pos = 0;
+
+	while (dio->bio_details.bi_iter.bi_size) {
+		char digest[HASH_MAX_DIGESTSIZE];
+		struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
+		char *mem = bvec_kmap_local(&bv);
+		//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
+		integrity_sector_checksum(dio, dio->bio_details.bi_iter.bi_sector, mem, digest);
+		if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
+					   min(ic->internal_hash_digestsize, ic->tag_size)))) {
+			kunmap_local(mem);
+			dm_integrity_free_payload(dio);
+			INIT_WORK(&dio->work, dm_integrity_inline_recheck);
+			queue_work(ic->offload_wq, &dio->work);
+			return false;
+		}
+		kunmap_local(mem);
+		pos += ic->tuple_size;
+		bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+	}
+	return true;
+}
+
+static void dm_integrity_inline_offload(struct work_struct *w)
+{
+	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
+	struct bio *bio;
+
+	if (unlikely(!dm_integrity_inline_verify(dio)))
+		return;
+
+	dm_integrity_free_payload(dio);
+
+	bio = dm_bio_from_per_bio_data(dio, dio->ic->ti->per_io_data_size);
+	bio_endio(bio);
+}
+
 static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *status)
 {
 	struct dm_integrity_c *ic = ti->private;
 	if (ic->mode == 'I') {
-		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+		struct dm_integrity_io *dio = dm_per_bio_data(bio, ic->ti->per_io_data_size);
 		if (dio->op == REQ_OP_READ && likely(*status == BLK_STS_OK)) {
-			unsigned pos = 0;
-			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
-			    unlikely(dio->integrity_range_locked))
+			if (unlikely(dio->integrity_range_locked) ||
+			    !dio->bio_details.bi_iter.bi_size)
 				goto skip_check;
-			while (dio->bio_details.bi_iter.bi_size) {
-				char digest[HASH_MAX_DIGESTSIZE];
-				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-				char *mem = bvec_kmap_local(&bv);
-				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
-				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
-				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
-							   min(ic->internal_hash_digestsize, ic->tag_size)))) {
-					kunmap_local(mem);
-					dm_integrity_free_payload(dio);
-					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
-					queue_work(ic->offload_wq, &dio->work);
-					return DM_ENDIO_INCOMPLETE;
-				}
-				kunmap_local(mem);
-				pos += ic->tuple_size;
-				bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
+			if (unlikely(ic->internal_ahash != NULL)) {
+				INIT_WORK(&dio->work, dm_integrity_inline_offload);
+				queue_work(ic->offload_wq, &dio->work);
+				return DM_ENDIO_INCOMPLETE;
 			}
+			if (unlikely(!dm_integrity_inline_verify(dio)))
+				return DM_ENDIO_INCOMPLETE;
 		}
 skip_check:
 		dm_integrity_free_payload(dio);
@@ -2657,7 +2751,7 @@ static void integrity_bio_wait(struct work_struct *w)
 	struct dm_integrity_c *ic = dio->ic;
 
 	if (ic->mode == 'I') {
-		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+		struct bio *bio = dm_bio_from_per_bio_data(dio, ic->ti->per_io_data_size);
 		int r = dm_integrity_map_inline(dio, false);
 		switch (r) {
 			case DM_MAPIO_KILL:
@@ -2898,14 +2992,11 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 				int r;
 				struct journal_entry *je2 = access_journal_entry(ic, i, l);
 
-				if (
-#ifndef INTERNAL_VERIFY
-				    unlikely(from_replay) &&
-#endif
-				    ic->internal_hash) {
+				if (unlikely(from_replay) &&
+				    ic->have_internal_hash) {
 					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
-					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
+					integrity_sector_checksum(ic->dummy_dio, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
 					if (unlikely(crypto_memneq(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
 						dm_integrity_io_error(ic, "tag mismatch when replaying journal", -EILSEQ);
@@ -3099,7 +3190,7 @@ static void integrity_recalc(struct work_struct *w)
 
 	t = recalc_tags;
 	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
+		integrity_sector_checksum(ic->dummy_dio, logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
 		t += ic->tag_size;
 	}
 
@@ -3220,7 +3311,7 @@ static void integrity_recalc_inline(struct work_struct *w)
 	t = recalc_tags;
 	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
 		memset(t, 0, ic->tuple_size);
-		integrity_sector_checksum(ic, range.logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
+		integrity_sector_checksum(ic->dummy_dio, range.logical_sector + i, recalc_buffer + (i << SECTOR_SHIFT), t);
 		t += ic->tuple_size;
 	}
 
@@ -3292,7 +3383,7 @@ static void bitmap_block_work(struct work_struct *w)
 	while ((bio = bio_list_pop(&bio_queue))) {
 		struct dm_integrity_io *dio;
 
-		dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+		dio = dm_per_bio_data(bio, ic->ti->per_io_data_size);
 
 		if (block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector,
 				    dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
@@ -3314,7 +3405,7 @@ static void bitmap_block_work(struct work_struct *w)
 			   BITMAP_BLOCK_SIZE >> SECTOR_SHIFT, NULL);
 
 	while ((bio = bio_list_pop(&waiting))) {
-		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+		struct dm_integrity_io *dio = dm_per_bio_data(bio, ic->ti->per_io_data_size);
 
 		block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector,
 				dio->range.n_sectors, BITMAP_OP_SET);
@@ -3904,7 +3995,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
 
-	if (!ic->internal_hash) {
+	if (!ic->have_internal_hash) {
 		struct blk_integrity *bi = &limits->integrity;
 
 		memset(bi, 0, sizeof(*bi));
@@ -4212,32 +4303,78 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
 	return -ENOMEM;
 }
 
-static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
+static int get_mac(struct crypto_shash **shash, struct crypto_ahash **ahash,
+		   struct alg_spec *a, char **error,
 		   char *error_alg, char *error_key)
 {
+	const char *ahash_driver_name = NULL;
 	int r;
 
-	if (a->alg_string) {
-		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
-		if (IS_ERR(*hash)) {
+	if (!a->alg_string)
+		return 0;
+
+	if (ahash) {
+		*ahash = crypto_alloc_ahash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+		if (IS_ERR(*ahash)) {
 			*error = error_alg;
-			r = PTR_ERR(*hash);
-			*hash = NULL;
+			r = PTR_ERR(*ahash);
+			*ahash = NULL;
 			return r;
 		}
+		ahash_driver_name = crypto_ahash_driver_name(*ahash);
+	}
 
-		if (a->key) {
-			r = crypto_shash_setkey(*hash, a->key, a->key_size);
-			if (r) {
-				*error = error_key;
-				return r;
+	if (shash) {
+		*shash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+		if (IS_ERR(*shash) && !ahash_driver_name) {
+			*error = error_alg;
+			r = PTR_ERR(*shash);
+			*shash = NULL;
+			return r;
+		}
+		if (!IS_ERR(*shash) && ahash_driver_name) {
+			if (strcmp(crypto_shash_driver_name(*shash), ahash_driver_name)) {
+				/*
+				 * ahash gave a different driver than shash, so probably
+				 * this is a case of real hardware offload.  Use ahash.
+				 */
+				crypto_free_shash(*shash);
+				*shash = NULL;
+			} else {
+				/* ahash and shash are same driver. Use shash. */
+				crypto_free_ahash(*ahash);
+				*ahash = NULL;
 			}
-		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
+		}
+		if (IS_ERR(*shash))
+			*shash = NULL;
+	}
+
+	/* either *ahash or *shash is set now */
+
+	if (a->key) {
+		r = shash && *shash ?
+			crypto_shash_setkey(*shash, a->key, a->key_size) :
+			crypto_ahash_setkey(*ahash, a->key, a->key_size);
+		if (r) {
 			*error = error_key;
-			return -ENOKEY;
+			return r;
 		}
+	} else if ((shash && *shash ?
+		    crypto_shash_get_flags(*shash) :
+		    crypto_ahash_get_flags(*ahash))
+		   & CRYPTO_TFM_NEED_KEY) {
+		*error = error_key;
+		return -ENOKEY;
 	}
 
+	pr_debug("Using %s %s (driver name %s)\n",
+		 ahash && *ahash ? "ahash" : "shash",
+		 a->alg_string,
+		 ahash && *ahash ?
+		 crypto_ahash_driver_name(*ahash) :
+		 crypto_shash_driver_name(*shash));
+
 	return 0;
 }
 
@@ -4692,20 +4829,35 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		buffer_sectors = 1;
 	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
 
-	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
+	r = get_mac(&ic->internal_shash, &ic->internal_ahash,
+		    &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
-	if (ic->internal_hash)
-		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_hash);
+	ic->have_internal_hash = ic->internal_shash || ic->internal_ahash;
+	if (ic->internal_ahash)
+		ti->per_io_data_size += sizeof(struct ahash_request) +
+					crypto_ahash_reqsize(ic->internal_ahash);
+	if (ic->have_internal_hash)
+		ic->internal_hash_digestsize = ic->internal_shash ?
+			crypto_shash_digestsize(ic->internal_shash) :
+			crypto_ahash_digestsize(ic->internal_ahash);
+
+	ic->dummy_dio = kmalloc(ti->per_io_data_size, GFP_KERNEL);
+	if (!ic->dummy_dio) {
+		ti->error = "Cannot allocate dummy dio";
+		r = -ENOMEM;
+		goto bad;
+	}
+	ic->dummy_dio->ic = ic;
 
-	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
+	r = get_mac(&ic->journal_mac, NULL, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
 	if (r)
 		goto bad;
 
 	if (!ic->tag_size) {
-		if (!ic->internal_hash) {
+		if (!ic->have_internal_hash) {
 			ti->error = "Unknown tag size";
 			r = -EINVAL;
 			goto bad;
@@ -4769,13 +4921,13 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		}
 	}
 
-	if (ic->mode == 'B' && !ic->internal_hash) {
+	if (ic->mode == 'B' && !ic->have_internal_hash) {
 		r = -EINVAL;
 		ti->error = "Bitmap mode can be only used with internal hash";
 		goto bad;
 	}
 
-	if (ic->discard && !ic->internal_hash) {
+	if (ic->discard && !ic->have_internal_hash) {
 		r = -EINVAL;
 		ti->error = "Discard can be only used with internal hash";
 		goto bad;
@@ -5025,7 +5177,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		ic->sb->recalc_sector = cpu_to_le64(0);
 	}
 
-	if (ic->internal_hash) {
+	if (ic->have_internal_hash) {
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq) {
 			ti->error = "Cannot allocate workqueue";
@@ -5219,8 +5371,10 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	if (ic->sb)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
 
-	if (ic->internal_hash)
-		crypto_free_shash(ic->internal_hash);
+	if (ic->internal_shash)
+		crypto_free_shash(ic->internal_shash);
+	if (ic->internal_ahash)
+		crypto_free_ahash(ic->internal_ahash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)
@@ -5231,13 +5385,15 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		crypto_free_shash(ic->journal_mac);
 	free_alg(&ic->journal_mac_alg);
 
+	kfree(ic->dummy_dio);
+
 	kfree(ic);
 	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
 }
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 13, 0},
+	.version		= {1, 14, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
-- 
2.43.0

