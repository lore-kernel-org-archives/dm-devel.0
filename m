Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979C34F24F
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405815; cv=none; b=NNBojBER3EToOMud48FuLE3qjNZMx7evahsaqjPc11Kn0QZUproZlwNJMz/+7Zvb/bKZq+qbDg2zcWvjlI1gq9Arn6NHUQLOLW8JkzJXtPXBAT38Cg9+HtFEyhPOdLWkna1ItSG8CkeUnQZ3b/B0Ejg4cB9DuxqJHj5dWANf80o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405815; c=relaxed/simple;
	bh=FC9+2dOB82Kl4mvDULZct9hN5oG2Jl6VDvIRk6Nfseo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mC7t1jgrst3ssvmutGPYp3S/nSgfLq0Us2PYYRnU6B5HUqi0o7vRk/mDVc3s0+wGvI88/od2kCHFM5i3pMBu9F1qaqAUPWsvHz4ay/wOLAZEi9Q85Xm9Mwy1zVONfvWXws5dULUdtCQf80/RcZW7U3SpuRtztmaJb5MNa6e5QkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=IdqwFs0Q; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="IdqwFs0Q"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EETPZU2382255
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=/VTA2GlNLhMp0XbEuPyCabHbzLrt0s/9P/0fKYw6xsw=; b=IdqwFs0Q9bBO
	TS7eeK9O0mZr403q9ilvSW1mXUm92fGh/6PTFoPV7Egx68BhWPFpuTMyvDY1p3xj
	NLYQeijnRNbhhz19QzJitbBjPmiagzyiNHefTGP9/OMGe8OBhetEg+N/h0qLqC3L
	Dsz+wputfLx+lje3c5NNyVxuDUhT+LnFf6ALNyAuZWlqZLzV4HZA50LX27QV8BJW
	kDkE1tfQdrI/xLZ2iDMf+BjwLAp4iLkOW/9VPkgm1UtvTXVLNg2bNnYSqluR1gyM
	08s2rwUvlcjs5KvUpsR+6kCXkvKwJ+nPmp6rftFtllU+fR3OHZSM81g6MR28/sC9
	yH3DzqU0Jg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bp0fywsny-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:12 -0800 (PST)
Received: from twshared22445.03.snb1.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:50:10 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 16F9563A9E14; Wed, 14 Jan 2026 07:50:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <snitzer@kernel.org>, <hch@lst.de>,
        <ebiggers@kernel.org>
CC: <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for direct io
Date: Wed, 14 Jan 2026 07:49:53 -0800
Message-ID: <20260114154954.3282207-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114154954.3282207-1-kbusch@meta.com>
References: <20260114154954.3282207-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2fLgddZ7jUEGwlEyw2_UTtd5tgqSH8Ze
X-Authority-Analysis: v=2.4 cv=QKplhwLL c=1 sm=1 tr=0 ts=6967bb34 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=IXXs4cDxjPlTTCw5R5gA:9
X-Proofpoint-GUID: 2fLgddZ7jUEGwlEyw2_UTtd5tgqSH8Ze
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMiBTYWx0ZWRfX+SLizzEYUE1V
 GF9xJa4DCljPG3XUA1iqFMR3ka2cenWDy5I0ggaZaZbhp5awxmtMy5DNwh2pdcOAVJHn4KJ8T2Z
 mFFbAp4TLYYLKhjEouwcwcpyqKl1i/aq+lA9l2gTROoo0OcINefTT+k9XYHKUweNy9mIW/meBRI
 LYJIzw1q/Unksn+bSEt+itKbx7MO8ycArdD4AE+ne57JoPK3aecrB86KFlUiN6rBQvBoOVbDPpy
 UqHVZvNBFSk1s+PGd/zwuru2bMU2QNTr9o+enHNN1rxtRvPgRxU0GiC6GXHRlBSQij6JZFnsn5H
 OtlAtz1NSZwff7CE2H+MsqFOs167YCXbKVXr257Hn26A4SkgznYyMDzhAtbcY5GVNK/7g+AAxTU
 QywaRIoK56hX8cicjTwurj7cWpb0cdnEpHz/DVvfuqYY2s4JNGOudWSpQZ/ujoIKKu3aaGHhlkX
 g5XH8XCLDuF/3PZy94g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Many storage devices can handle DMA for data that is not aligned to the
sector block size. The block and filesystem layers have introduced
updates to allow that kind of memory alignment flexibility when
possible.

dm-crypt, however, currently constrains itself to aligned memory because
it sends a single scatterlist element for the in/out list to the encrypt
and decrypt algorithms. This forces applications that have unaligned
data to copy through a bounce buffer, increasing CPU and memory
utilization.

Use multiple scatterlist elements to relax the memory alignment
requirement. To keep this simple, this more flexible constraint is
enabled only for certain encryption and initialization vector types,
specifically the ones that don't have additional use for the request
base scatterlist elements beyond holding decrypted data.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 79 +++++++++++++++++++++++++++++++++----------
 drivers/md/dm-table.c |  1 +
 2 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77f..5304954b4574b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -149,6 +149,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sec=
tors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (eleph=
ant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_DISCONTIGUOUS_SEGS,	/* Can use partial sector segments */
 };
=20
 /*
@@ -214,6 +215,7 @@ struct crypt_config {
 	unsigned int key_extra_size; /* additional keys length */
 	unsigned int key_mac_size;   /* MAC key size for authenc(...) */
=20
+	unsigned int io_alignment;
 	unsigned int integrity_tag_size;
 	unsigned int integrity_iv_size;
 	unsigned int used_tag_size;
@@ -1424,22 +1426,48 @@ static int crypt_convert_block_aead(struct crypt_=
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
+		if (unlikely((len | bv.bv_offset) & cc->io_alignment))
+			return -EIO;
+
+		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
+		bio_advance_iter_single(bio, iter, len);
+		bytes -=3D len;
+	} while (bytes);
+
+	if (WARN_ON_ONCE(i !=3D segs))
+		return -EIO;
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
@@ -2893,6 +2926,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti, =
const char *ivmode)
 		return -EINVAL;
 	}
=20
+	if (!unaligned_allowed) {
+		cc->io_alignment =3D cc->sector_size - 1;
+	} else {
+		set_bit(CRYPT_DISCONTIGUOUS_SEGS, &cc->cipher_flags);
+		cc->io_alignment =3D 3;
+	}
 	return 0;
 }
=20
@@ -3750,7 +3789,11 @@ static void crypt_io_hints(struct dm_target *ti, s=
truct queue_limits *limits)
 	limits->physical_block_size =3D
 		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
 	limits->io_min =3D max_t(unsigned int, limits->io_min, cc->sector_size)=
;
-	limits->dma_alignment =3D limits->logical_block_size - 1;
+
+	if (test_bit(CRYPT_DISCONTIGUOUS_SEGS, &cc->cipher_flags))
+		limits->dma_alignment =3D cc->io_alignment;
+	else
+		limits->dma_alignment =3D limits->logical_block_size - 1;
=20
 	/*
 	 * For zoned dm-crypt targets, there will be no internal splitting of
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ad0a60a07b935..da0d090675103 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1789,6 +1789,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
 	bool zoned =3D false;
=20
 	dm_set_stacking_limits(limits);
+	limits->dma_alignment =3D 0;
=20
 	t->integrity_supported =3D true;
 	for (unsigned int i =3D 0; i < t->num_targets; i++) {
--=20
2.47.3

