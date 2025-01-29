Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106161DE8BE
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738167941; cv=none; b=BMR3WFJBsgZzi+bXbJ3DCMF4nLGeWcZm6Wc18KRDQx5C48SJ3XZ28VIunYyJtB9UnNt4kAn9AgqaEtH70jYSrhXKRFyZrbP/F0sCuDLrVWB+Ebld9LGCAGGw2MHCvUo5lrsJDG4o+uFocjeS0Nuai0m13yEH89K58YZv8EHANKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738167941; c=relaxed/simple;
	bh=et7diaJtCk/LuV5JsdjZk5JDvqspM6G7OXEgp72sPZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwL5foSD9biXyC+0fMvjoB/wuMfNzvfWEFbUtn+6CzHw6TbYQUhQA/676q7PJ6XdqMn1hJLWX7btm34991RYc491aKOJE2k3I6y+P259orDcMOby3MbBo8CH9xpkCQICeQB1KbwSSGr66Kn4T8ysBu0OxwJMNztmDuJkZ+4tzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pn0N9swN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pn0N9swN"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50TF1XSf024168;
	Wed, 29 Jan 2025 16:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zLCPMveFANUCzMGzK
	9e6rtaVJh3sxntGi6Br014wCBI=; b=pn0N9swNY2yY2NwASvDxmfgPyq72yZtga
	C1s9lVTq3hcIodoAfEnRM38HSEqirJlVGABiwPX/5zWh/ys9Hmp88/iolafgrNYK
	PIUbcN3FVjWadsYpfYIe3ZPp7OnL8bxDPYKW21HZu5WAzqYShLrWNk4stFeVopfU
	oZLKqYL4Sh91qsbpLc0Myk1wO/1znpmMpuSynC+tr17xfaDSvGLjnrFdMRTWTzJb
	1YjwHahSWEChMT9N+rhi/Y48qQqTjMhhLS/XU5hVj2DZeJSSs4XgYrlVgfCpj/GN
	PQK/bmGZyVaXYyy2dQRJ8B/x8mspyLoJhZX3FqmQVT5atsF4wUO3g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fpm1gf7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 16:25:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50TFkZGA012328;
	Wed, 29 Jan 2025 16:25:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44dany9p2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jan 2025 16:25:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50TGPTV656426828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jan 2025 16:25:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5074620118;
	Wed, 29 Jan 2025 16:25:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 070E12011B;
	Wed, 29 Jan 2025 16:25:29 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.56.44])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jan 2025 16:25:28 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, mpatocka@redhat.com
Cc: linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au
Subject: [PATCH v2 1/2] dm-integrity: use internal variable for digestsize
Date: Wed, 29 Jan 2025 17:25:27 +0100
Message-ID: <20250129162528.57124-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129162528.57124-1-freude@linux.ibm.com>
References: <20250129162528.57124-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p9LNZjLN15IuyIum0LJLqEsnaOMVQro5
X-Proofpoint-GUID: p9LNZjLN15IuyIum0LJLqEsnaOMVQro5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-29_03,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501290129

Instead of calling digestsize() each time the digestsize for
the internal hash is needed, store the digestsize in a new
field internal_hash_digestsize within struct dm_integrity_c
once and use this value when needed.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/md/dm-integrity.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ee9f7cecd78e..af0276ad84bd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -222,6 +222,7 @@ struct dm_integrity_c {
 	int failed;
 
 	struct crypto_shash *internal_hash;
+	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
 
@@ -1676,7 +1677,7 @@ static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector
 		goto failed;
 	}
 
-	digest_size = crypto_shash_digestsize(ic->internal_hash);
+	digest_size = ic->internal_hash_digestsize;
 	if (unlikely(digest_size < ic->tag_size))
 		memset(result + digest_size, 0, ic->tag_size - digest_size);
 
@@ -1776,7 +1777,7 @@ static void integrity_metadata(struct work_struct *w)
 	if (ic->internal_hash) {
 		struct bvec_iter iter;
 		struct bio_vec bv;
-		unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+		unsigned int digest_size = ic->internal_hash_digestsize;
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
@@ -2124,7 +2125,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 
 				if (ic->internal_hash) {
-					unsigned int digest_size = crypto_shash_digestsize(ic->internal_hash);
+					unsigned int digest_size = ic->internal_hash_digestsize;
 
 					if (unlikely(digest_size > ic->tag_size)) {
 						char checksums_onstack[HASH_MAX_DIGESTSIZE];
@@ -2428,7 +2429,7 @@ static int dm_integrity_map_inline(struct dm_integrity_io *dio, bool from_map)
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
 		dio->payload_len = ic->tuple_size * (bio_sectors(bio) >> ic->sb->log2_sectors_per_block);
-		digest_size = crypto_shash_digestsize(ic->internal_hash);
+		digest_size = ic->internal_hash_digestsize;
 		extra_size = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
 		dio->payload_len += extra_size;
 		dio->integrity_payload = kmalloc(dio->payload_len, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
@@ -2595,7 +2596,8 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 		bio_put(outgoing_bio);
 
 		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
-		if (unlikely(memcmp(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+		if (unlikely(memcmp(digest, dio->integrity_payload,
+				    min(ic->internal_hash_digestsize, ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
 			atomic64_inc(&ic->number_of_mismatches);
@@ -2635,7 +2637,7 @@ static int dm_integrity_end_io(struct dm_target *ti, struct bio *bio, blk_status
 				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
 				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
 				if (unlikely(memcmp(digest, dio->integrity_payload + pos,
-						min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+						min(ic->internal_hash_digestsize, ic->tag_size)))) {
 					kunmap_local(mem);
 					dm_integrity_free_payload(dio);
 					INIT_WORK(&dio->work, dm_integrity_inline_recheck);
@@ -3017,8 +3019,8 @@ static void integrity_recalc(struct work_struct *w)
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
@@ -3177,8 +3179,8 @@ static void integrity_recalc_inline(struct work_struct *w)
 	}
 
 	recalc_tags_size = (recalc_sectors >> ic->sb->log2_sectors_per_block) * ic->tuple_size;
-	if (crypto_shash_digestsize(ic->internal_hash) > ic->tuple_size)
-		recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tuple_size;
+	if (ic->internal_hash_digestsize > ic->tuple_size)
+		recalc_tags_size += ic->internal_hash_digestsize - ic->tuple_size;
 	recalc_tags = kmalloc(recalc_tags_size, GFP_NOIO | __GFP_NOWARN);
 	if (!recalc_tags) {
 		kfree(recalc_buffer);
@@ -4707,7 +4709,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			r = -EINVAL;
 			goto bad;
 		}
-		ic->tag_size = crypto_shash_digestsize(ic->internal_hash);
+		ic->tag_size = ic->internal_hash_digestsize;
 	}
 	if (ic->tag_size > MAX_TAG_SIZE) {
 		ti->error = "Too big tag size";
-- 
2.43.0

