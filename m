Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428C036E476
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774890088; cv=none; b=IlIHjcV3XgVr4/apzv87wOSUJoHCJ7dkDikJVj8OgYYKPM8rZNklQuai3vwVZZ2RGdsNX8O9dhuDMxVzxsOrVr3utnCc8kBt+1jzAkWdT85P4iWSmpyeiVs+PVcg0DToyzvt1HBfGSnYOSvqgw1ycgZbgnakX+MeC/japlNeqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774890088; c=relaxed/simple;
	bh=axUhxbp8rDkJABamV7IbvV2jUVsfqvZh2igNJ666gE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvauMdvhBdh8xLfFuwmj7cJQ6eCZrVdHfm5wvh7GQ5N4EBgKXJ8yRd0iBGeDuLieC2E64KdLxGRBv9WAtl86TpK1xbcuEbBBkrNwNw/jFuNhNYMazuoHwYgp0/Kn7JXBWT4YjL/qqB9AJMFaBNaEWTUGcrBU0vxWJ9LoHQD12nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JNsFn96X; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JNsFn96X"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62U3a6IS3368507
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=lY8pahXhcSOJhBOFrc4+Iz3rCrwcSLa9ZN6rjmtfA2w=; b=JNsFn96XyqWL
	nis6MqRPfxKejQpqYpXXiEFVSw+KlZXYzud2lXriu3BeyRvsjf8pLx3yO1NEE9Tj
	zx855d7+bpSeNXvfpuYhTsAT68ZxPgGcguwOmiEkuros5eAdhqZl1GLTygX+oFV1
	PlcLP4mGZpv20NSo5+LAtRIXoGCEWBUjepoNdB419COxyeZiFIdToxx0VashpjAC
	ShxveQY3mn0NQxTQY03qu820BkhXx+/1v/Zp91IlSLdYTTTnDksfwG6h7yykbbLZ
	paAyFT8BGGwuFjZobidp+SrR3T+AymI46uvGLAVGuHOc6c4uPVcOYI4FY8nKvGTA
	zLBrJehlEA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d6xgexx46-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:26 -0700 (PDT)
Received: from twshared124412.16.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 30 Mar 2026 17:01:21 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 6FA57DFA084A; Mon, 30 Mar 2026 10:01:16 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 2/2] dm-crypt: allow unaligned bio_vecs for direct io
Date: Mon, 30 Mar 2026 10:01:14 -0700
Message-ID: <20260330170114.764606-3-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260330170114.764606-1-kbusch@meta.com>
References: <20260330170114.764606-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDEzNyBTYWx0ZWRfX6K9TdtNR41i2
 pUapInBDL0NWGea3tVF+XhizU8h0htteYaAZd+acJ9u0ViPer98NJr10rxaKY0GyPvWIByxuxB7
 MUadxFhNRXgi99qnuyj0QHQGqRbFBf1X6DWrxnmHQwTUXtlwAh1RD40a12MCfha469TyyVa0cW/
 1FyTB9QN3wHv0/DyO0dtK4KBFZHNuJ0ODvEsV8f9e2VwhVxcKINQvy/8GHAJuGVHIMJQPLg3Gme
 DIAL5r906+LNguuKn0cwmcPpVcpmH5bdbgA7GXOdn+8W2RbGzdbdKMXT60PSPLEUzS44+0K52qT
 P3zWAuZKYcEyPHiJQsY0btVOir8lZdQHkIKAC9+0HGtYO/XjAg2t9b6jpY0sM7fp7VU4A6OyVrJ
 iVWqjYH44HHTZIPAV3TS+Eo1kK0x6usQFGaXnnD0lTEx6Omhx05dK5xJQL8frRcauUV7bskwQt/
 It5MJdHAPgbH8oCTp/g==
X-Proofpoint-GUID: 05FS1qaedRVevNvAtR-iZgSviNE5k_HS
X-Proofpoint-ORIG-GUID: 05FS1qaedRVevNvAtR-iZgSviNE5k_HS
X-Authority-Analysis: v=2.4 cv=YcWwJgRf c=1 sm=1 tr=0 ts=69caac66 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=57FBJkq0ZimG-tUVacAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Many storage devices can handle DMA for data that is not aligned to the
logical block size. The block and filesystem layers have introduced
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
scatterlist elements beyond pointing to user data.

In the unlikely case where the incoming bio uses a highly fragmented
vector, the four inline scatterlist elements may not be enough, so
allocate a temporary scatterlist when needed, falling back to a mempool
for the in and out buffers to guarantee forward progress if the initial
allocation fails.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 147 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 127 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817f..19e8101580d1a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -101,6 +101,10 @@ struct dm_crypt_request {
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
 	u64 iv_sector;
+	struct scatterlist *__sg_in;
+	struct scatterlist *__sg_out;
+	bool sg_in_pooled;
+	bool sg_out_pooled;
 };
=20
 struct crypt_config;
@@ -216,6 +220,9 @@ struct crypt_config {
 	unsigned int key_extra_size; /* additional keys length */
 	unsigned int key_mac_size;   /* MAC key size for authenc(...) */
=20
+	unsigned int io_alignment;
+	mempool_t sg_in_pool;
+	mempool_t sg_out_pool;
 	unsigned int integrity_tag_size;
 	unsigned int integrity_iv_size;
 	unsigned int used_tag_size;
@@ -1349,22 +1356,89 @@ static int crypt_convert_block_aead(struct crypt_=
config *cc,
 	return r;
 }
=20
+static void crypt_free_sg(struct scatterlist *sg, struct scatterlist *in=
line_sg,
+			  mempool_t *pool, bool from_pool)
+{
+	if (sg =3D=3D inline_sg)
+		return;
+	if (from_pool)
+		mempool_free(sg, pool);
+	else
+		kfree(sg);
+}
+
+static void crypt_free_sgls(struct crypt_config *cc,
+			    struct dm_crypt_request *dmreq)
+{
+	crypt_free_sg(dmreq->__sg_in, dmreq->sg_in,
+		      &cc->sg_in_pool, dmreq->sg_in_pooled);
+	crypt_free_sg(dmreq->__sg_out, dmreq->sg_out,
+		      &cc->sg_out_pool, dmreq->sg_out_pooled);
+	dmreq->__sg_in =3D NULL;
+	dmreq->__sg_out =3D NULL;
+}
+
+static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist *=
*psg,
+			   struct bvec_iter *iter, struct bio *bio,
+			   int max_segs, mempool_t *pool, bool *pooled)
+{
+	unsigned int bytes =3D cc->sector_size;
+	struct scatterlist *sg =3D *psg;
+	struct bvec_iter tmp =3D *iter;
+	int segs, i =3D 0;
+
+	*pooled =3D false;
+	bio_advance_iter(bio, &tmp, bytes);
+	segs =3D tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
+	if (segs > max_segs) {
+		if (unlikely(segs > BIO_MAX_VECS))
+			return -EIO;
+		sg =3D kmalloc_array(segs, sizeof(struct scatterlist),
+				   GFP_NOWAIT | __GFP_NOMEMALLOC);
+		if (!sg) {
+			sg =3D mempool_alloc(pool, GFP_NOIO);
+			*pooled =3D true;
+		}
+	}
+
+	sg_init_table(sg, segs);
+	do {
+		struct bio_vec bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, *iter);
+		int len =3D min(bytes, bv.bv_len);
+
+		/* Reject unexpected unaligned bio. */
+		if (unlikely((len | bv.bv_offset) & cc->io_alignment))
+			goto error;
+
+		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
+		bio_advance_iter_single(bio, iter, len);
+		bytes -=3D len;
+	} while (bytes);
+
+	if (WARN_ON_ONCE(i !=3D segs))
+		goto error;
+	*psg =3D sg;
+	return 0;
+error:
+	if (sg !=3D *psg) {
+		if (*pooled)
+			mempool_free(sg, pool);
+		else
+			kfree(sg);
+	}
+	return -EIO;
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
@@ -1381,15 +1455,23 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 	sector =3D org_sector_of_dmreq(cc, dmreq);
 	*sector =3D cpu_to_le64(ctx->cc_sector - cc->iv_offset);
=20
-	/* For skcipher we use only the first sg item */
-	sg_in  =3D &dmreq->sg_in[0];
-	sg_out =3D &dmreq->sg_out[0];
+	dmreq->__sg_in =3D &dmreq->sg_in[0];
+	dmreq->__sg_out =3D &dmreq->sg_out[0];
+
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_in, &ctx->iter_in, ctx->bio_in,
+			    ARRAY_SIZE(dmreq->sg_in), &cc->sg_in_pool,
+			    &dmreq->sg_in_pooled);
+	if (r < 0)
+		return r;
=20
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_out, &ctx->iter_out, ctx->bio_ou=
t,
+			    ARRAY_SIZE(dmreq->sg_out), &cc->sg_out_pool,
+			    &dmreq->sg_out_pooled);
+	if (r < 0)
+		goto out;
=20
-	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	sg_in =3D dmreq->__sg_in;
+	sg_out =3D dmreq->__sg_out;
=20
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1398,7 +1480,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 		} else {
 			r =3D cc->iv_gen_ops->generator(cc, org_iv, dmreq);
 			if (r < 0)
-				return r;
+				goto out;
 			/* Data can be already preprocessed in generator */
 			if (test_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags))
 				sg_in =3D sg_out;
@@ -1420,8 +1502,9 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+out:
+	if (r !=3D -EINPROGRESS && r !=3D -EBUSY)
+		crypt_free_sgls(cc, dmreq);
=20
 	return r;
 }
@@ -1487,7 +1570,9 @@ static void crypt_free_req_skcipher(struct crypt_co=
nfig *cc,
 				    struct skcipher_request *req, struct bio *base_bio)
 {
 	struct dm_crypt_io *io =3D dm_per_bio_data(base_bio, cc->per_bio_data_s=
ize);
+	struct dm_crypt_request *dmreq =3D dmreq_of_req(cc, req);
=20
+	crypt_free_sgls(cc, dmreq);
 	if ((struct skcipher_request *)(io + 1) !=3D req)
 		mempool_free(req, &cc->req_pool);
 }
@@ -2717,6 +2802,8 @@ static void crypt_dtr(struct dm_target *ti)
=20
 	mempool_exit(&cc->page_pool);
 	mempool_exit(&cc->req_pool);
+	mempool_exit(&cc->sg_in_pool);
+	mempool_exit(&cc->sg_out_pool);
 	mempool_exit(&cc->tag_pool);
=20
 	WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) !=3D 0);
@@ -2751,9 +2838,10 @@ static int crypt_ctr_ivmode(struct dm_target *ti, =
const char *ivmode)
 {
 	struct crypt_config *cc =3D ti->private;
=20
-	if (crypt_integrity_aead(cc))
+	if (crypt_integrity_aead(cc)) {
 		cc->iv_size =3D crypto_aead_ivsize(any_tfm_aead(cc));
-	else
+		cc->io_alignment =3D cc->sector_size - 1;
+	} else
 		cc->iv_size =3D crypto_skcipher_ivsize(any_tfm(cc));
=20
 	if (cc->iv_size)
@@ -2789,6 +2877,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, c=
onst char *ivmode)
 		if (cc->key_extra_size > ELEPHANT_MAX_KEY_SIZE)
 			return -EINVAL;
 		set_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags);
+		cc->io_alignment =3D cc->sector_size - 1;
 	} else if (strcmp(ivmode, "lmk") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_lmk_ops;
 		/*
@@ -2801,10 +2890,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti,=
 const char *ivmode)
 			cc->key_parts++;
 			cc->key_extra_size =3D cc->key_size / cc->key_parts;
 		}
+		cc->io_alignment =3D cc->sector_size - 1;
 	} else if (strcmp(ivmode, "tcw") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_tcw_ops;
 		cc->key_parts +=3D 2; /* IV + whitening */
 		cc->key_extra_size =3D cc->iv_size + TCW_WHITENING_SIZE;
+		cc->io_alignment =3D cc->sector_size - 1;
 	} else if (strcmp(ivmode, "random") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_random_ops;
 		/* Need storage space in integrity fields. */
@@ -3271,6 +3362,20 @@ static int crypt_ctr(struct dm_target *ti, unsigne=
d int argc, char **argv)
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_si=
ze,
 		      ARCH_DMA_MINALIGN);
=20
+	ret =3D mempool_init_kmalloc_pool(&cc->sg_in_pool, 1,
+			BIO_MAX_VECS * sizeof(struct scatterlist));
+	if (ret) {
+		ti->error =3D "Cannot allocate crypt scatterlist mempool";
+		goto bad;
+	}
+
+	ret =3D mempool_init_kmalloc_pool(&cc->sg_out_pool, 1,
+			BIO_MAX_VECS * sizeof(struct scatterlist));
+	if (ret) {
+		ti->error =3D "Cannot allocate crypt scatterlist mempool";
+		goto bad;
+	}
+
 	ret =3D mempool_init(&cc->page_pool, BIO_MAX_VECS, crypt_page_alloc, cr=
ypt_page_free, cc);
 	if (ret) {
 		ti->error =3D "Cannot allocate page mempool";
@@ -3680,7 +3785,9 @@ static void crypt_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)
 	struct crypt_config *cc =3D ti->private;
=20
 	dm_stack_bs_limits(limits, cc->sector_size);
-	limits->dma_alignment =3D limits->logical_block_size - 1;
+	limits->dma_alignment =3D max(bdev_dma_alignment(cc->dev->bdev),
+				    cc->io_alignment);
+	cc->io_alignment =3D limits->dma_alignment;
=20
 	/*
 	 * For zoned dm-crypt targets, there will be no internal splitting of
--=20
2.52.0

