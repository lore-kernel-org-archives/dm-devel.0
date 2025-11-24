Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8963148AF
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004165; cv=none; b=iFUeyQ7NI1hi3eD3cXtctOf0lgDUfkqrqECXdOUD5qLK1/1UV478nyGplnIRmNnq2Kn2g/0HIYTqiuXvtkP7k9KiQStEynvAV56OT/ooqPizLpijyUPdWhvvQpFg51BUlDVRHCxXo4UDIZ5KcDV/9u4HQLU0jX/ZQCTxU3vJeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004165; c=relaxed/simple;
	bh=qIouyY3fKmuViCEeKZxTjLce/wKwht8J40XAeImObcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8zM+Yv6qaStnNszZDoiPTbPel8nH0m2BVi/eaXX9ibpUxcqdFYUFRDnJDcSuxs+pTAe5mpD+WWq/VTv5LiRZlsAMP2cn0U2wCcGq+nxweUwnqPmx3nS2ZyESP0bnRKGtIQaKq7xnLBM4aABy9Y301adTNCPjOZy4GxsVWlcxSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=RyGQ53QU; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="RyGQ53QU"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOGf3d23009840
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 09:09:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=e3O4DzHwT2aUh+ZzPv0ZOqRBYBNwIQBl0Mi1HJ6BUMI=; b=RyGQ53QU2k5S
	rI3FkG0md2Jhq/rGP36irZBUp30jO6dgc17FkShaoMxf2+pUnwhc8hl1oM6E0nYy
	Vm9abrSJQohVBhB+JfB8IW2WB8vbIg1CvWh0CzLPDrhTivWGGDnNDOoA0CGMpd+X
	1I7mmycCeq4KvbNvjvCJAT6hATRow7dlM8LCO9siWb1rEtqsGrk53s4nLgmDSPAM
	hKn2y0KgKPc4wHWU0UpQmCG2YYaRSlXIQIQN2Hjd4yJo3A1Rlrl/IR2TUCdhIWnA
	yisd65W0hmZFOKCCQnKgn/CrGhC6l4P/jGe3dNgffHcHSkJDCcdPiU8qfYYL3JsH
	Ra+Q68P+iA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ams9119jb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 09:09:22 -0800 (PST)
Received: from twshared13861.04.snb2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 24 Nov 2025 17:09:20 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 4B6F041D0F4E; Mon, 24 Nov 2025 09:09:08 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <linux-block@vger.kernel.org>,
        <snitzer@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>,
        <ebiggers@kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/3] dm-crypt: allow unaligned bio_vecs for direct io
Date: Mon, 24 Nov 2025 09:09:02 -0800
Message-ID: <20251124170903.3931792-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124170903.3931792-1-kbusch@meta.com>
References: <20251124170903.3931792-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: c6l7LH79-aa6njZflJZmNbRryiBp3HYT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE1MCBTYWx0ZWRfX0Q+NaSXCDvFz
 z8CzCfx4Mx3v/0dr87m6bZ/zCdwinAevyb9UpDuGts5m7wtvi2bqc6ZvT53ECyVfkz7A55PeTTW
 QPky9GW8gUrXCSyKnjI0xXAV/Era6dApxK9zkTViodAdTxG9lIWvqT7rmc4dO1LyegRkk4JgkMQ
 Gv80yTVvujjTYwvKzVDEh6t2wH96kw7LjswPc6VCq2QNdlkyRIt3+OfZe+B02rWywEs3nQ0lyfa
 NCa9JHCzS4dZFCKYkElfZVV1rfdjXwVKUSa4aDORnBGs6dGe6H32whjE0RXnh9OSmAnmBWhhZfi
 TtW/fRFDGoHOVmfZF+xDPFksUX4wRehpnp9VL6ubR3gn7qGBHW3OL6cxP0Kn4ewr/2g57BBs4ha
 T7Gw/yyFHVWUUxQee9yYhoV5qVZcdQ==
X-Authority-Analysis: v=2.4 cv=BL2+bVQG c=1 sm=1 tr=0 ts=69249142 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=_h08JpkXp4QKfwmzJH8A:9
X-Proofpoint-ORIG-GUID: c6l7LH79-aa6njZflJZmNbRryiBp3HYT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Many storage devices can handle DMA for data that is not aligned to the
sector block size. The block and filesystem layers have introduced
updates to allow that kind of memory alignment flexibility when
possible.

dm-crypt, however, currently constrains itself to aligned memory because
it sends a single scatterlist element for the input ot the encrypt and
decrypt algorithms. This forces applications that have unaligned data to
copy through a bounce buffer, increasing CPU and memory utilization.

Use multiple scatterlist elements to relax the memory alignment
requirement. To keep this simple, this lower constraint is enabled only
for certain encryption and initialization vector types, specifically the
ones that don't had additional use for the request base scatterlist
elements beyond holding decrypted data.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 73 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77f..0b3f5411695ac 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -214,6 +214,7 @@ struct crypt_config {
 	unsigned int key_extra_size; /* additional keys length */
 	unsigned int key_mac_size;   /* MAC key size for authenc(...) */
=20
+	unsigned int dio_alignment;
 	unsigned int integrity_tag_size;
 	unsigned int integrity_iv_size;
 	unsigned int used_tag_size;
@@ -1424,22 +1425,49 @@ static int crypt_convert_block_aead(struct crypt_=
config *cc,
 	return r;
 }
=20
+static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist *=
sg,
+			   struct bvec_iter *iter, struct bio *bio,
+			   int max_segs)
+{
+	unsigned int bytes =3D cc->sector_size;
+	struct bvec_iter tmp =3D *iter;
+	int segs, i =3D 0;
+
+	bio_advance_iter(bio, &tmp, bytes);
+	segs =3D tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
+	if (segs > max_segs)
+		return -EIO;
+
+	sg_init_table(sg, segs);
+	do {
+		struct bio_vec bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, *iter);
+		int len =3D min(bytes, bv.bv_len);
+
+		/* Reject unexpected unaligned bio. */
+		if (unlikely((len | bv.bv_offset) &
+				bdev_dma_alignment(cc->dev->bdev)))
+			return -EIO;
+
+		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
+		bio_advance_iter_single(bio, iter, len);
+		bytes -=3D len;
+	} while (bytes);
+
+	if (WARN_ON_ONCE(i !=3D segs))
+		return -EINVAL;
+	return 0;
+}
+
 static int crypt_convert_block_skcipher(struct crypt_config *cc,
 					struct convert_context *ctx,
 					struct skcipher_request *req,
 					unsigned int tag_offset)
 {
-	struct bio_vec bv_in =3D bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out =3D bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct scatterlist *sg_in, *sg_out;
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv;
 	__le64 *sector;
-	int r =3D 0;
-
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
-		return -EIO;
+	int r;
=20
 	dmreq =3D dmreq_of_req(cc, req);
 	dmreq->iv_sector =3D ctx->cc_sector;
@@ -1456,15 +1484,18 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 	sector =3D org_sector_of_dmreq(cc, dmreq);
 	*sector =3D cpu_to_le64(ctx->cc_sector - cc->iv_offset);
=20
-	/* For skcipher we use only the first sg item */
 	sg_in  =3D &dmreq->sg_in[0];
 	sg_out =3D &dmreq->sg_out[0];
=20
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	r =3D crypt_build_sgl(cc, sg_in, &ctx->iter_in, ctx->bio_in,
+			    ARRAY_SIZE(dmreq->sg_in));
+	if (r < 0)
+		return r;
=20
-	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	r =3D crypt_build_sgl(cc, sg_out, &ctx->iter_out, ctx->bio_out,
+			    ARRAY_SIZE(dmreq->sg_out));
+	if (r < 0)
+		return r;
=20
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1495,9 +1526,6 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r =3D cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
-
 	return r;
 }
=20
@@ -2829,10 +2857,12 @@ static void crypt_dtr(struct dm_target *ti)
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 {
 	struct crypt_config *cc =3D ti->private;
+	bool unaligned_allowed =3D true;
=20
-	if (crypt_integrity_aead(cc))
+	if (crypt_integrity_aead(cc)) {
 		cc->iv_size =3D crypto_aead_ivsize(any_tfm_aead(cc));
-	else
+		unaligned_allowed =3D false;
+	} else
 		cc->iv_size =3D crypto_skcipher_ivsize(any_tfm(cc));
=20
 	if (cc->iv_size)
@@ -2868,6 +2898,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, c=
onst char *ivmode)
 		if (cc->key_extra_size > ELEPHANT_MAX_KEY_SIZE)
 			return -EINVAL;
 		set_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags);
+		unaligned_allowed =3D false;
 	} else if (strcmp(ivmode, "lmk") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_lmk_ops;
 		/*
@@ -2880,10 +2911,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti,=
 const char *ivmode)
 			cc->key_parts++;
 			cc->key_extra_size =3D cc->key_size / cc->key_parts;
 		}
+		unaligned_allowed =3D false;
 	} else if (strcmp(ivmode, "tcw") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_tcw_ops;
 		cc->key_parts +=3D 2; /* IV + whitening */
 		cc->key_extra_size =3D cc->iv_size + TCW_WHITENING_SIZE;
+		unaligned_allowed =3D false;
 	} else if (strcmp(ivmode, "random") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_random_ops;
 		/* Need storage space in integrity fields. */
@@ -2893,6 +2926,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, c=
onst char *ivmode)
 		return -EINVAL;
 	}
=20
+	if (unaligned_allowed)
+		cc->dio_alignment =3D 3;
 	return 0;
 }
=20
@@ -3286,6 +3321,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
 	cc->key_size =3D key_size;
 	cc->sector_size =3D (1 << SECTOR_SHIFT);
 	cc->sector_shift =3D 0;
+	cc->dio_alignment =3D 0;
=20
 	ti->private =3D cc;
=20
@@ -3750,7 +3786,8 @@ static void crypt_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)
 	limits->physical_block_size =3D
 		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
 	limits->io_min =3D max_t(unsigned int, limits->io_min, cc->sector_size)=
;
-	limits->dma_alignment =3D limits->logical_block_size - 1;
+	limits->dma_alignment =3D min_not_zero(limits->logical_block_size - 1,
+					     cc->dio_alignment);
=20
 	/*
 	 * For zoned dm-crypt targets, there will be no internal splitting of
--=20
2.47.3

