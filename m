Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF942EEDA
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613740; cv=none; b=D9XBq9LlUnTI7q5Ll/NyntoXm7OC+V4/Uvgr2JrdTXOqiUEr6bDq+qS6MkVJH5BSAYfoszpT7PTHT3XlFEA5bFWLMkIyC+uraWUe32EXtl+fVlgYNMRYJI5ImoRAg1NzYmRU3uZNXcgPNmdVYbA3CW76hVtBTsuehiMG2YEMnHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613740; c=relaxed/simple;
	bh=3D9+KuV1g+gHlttxh+yi9F9oQTGgIuQSRtWj/Tg4i3U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2iLiTWbfcRedPQdoJWTxjf5F2Pc2iY3a8L+pj7pVjRSadBwE6L7h+8bUu2bMROuFARWkCRcMc2qoNDTR5/kFOXKz+qJufaZ6ysSS8cyt5HkG21PvqYiEVkOtRChm5z8rBAqmkRpQimquJojqyiDD8F2SpLxFJKO587biuvDlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=o2UwUFqE; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="o2UwUFqE"
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 669EV2Of2899437
	for <dm-devel@lists.linux.dev>; Thu, 9 Jul 2026 09:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=e2QiL9tTF7X37gtssEffuRunfoEui3fWuLZhEUqj8zw=; b=o2UwUFqECYHz
	kG7PInOsu9aCWXdTKkGUJB7TfedKLXd7do+zuhdItVAaGAfT2vyQ28iihQlU8AE0
	1FLR8vEiisL+nTT9CN+2EvEzl9BbXVbgQlDaUq7AjaDCe5ShRRb152g5afTOC4Gu
	kfdTyj3egiEIh8yllS7T6hSXPZexcrewDqmRBPUNKO5r5pWoJGDVYnGtXWeBFcrO
	TYrmwarAeRbh2l+TvPHubcj/WWDmZ3JRUExoUuWTmG3wvTf3UEq+745KwcZLzJOp
	vVmzdlwXvP7lXlUIyAD0dIdgX5gGZ+LxSKytsJ+jzUF0UsYKEbuLp90dwrqqFtf7
	hYtNvACDaQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fadfagq5a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 09 Jul 2026 09:15:38 -0700 (PDT)
Received: from twshared95846.15.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Thu, 9 Jul 2026 16:15:36 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id EB6A424D56C61; Thu,  9 Jul 2026 09:15:20 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, <bmarzins@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 3/3] dm-crypt: allow unaligned bio_vecs for direct io
Date: Thu, 9 Jul 2026 09:15:19 -0700
Message-ID: <20260709161519.1559723-4-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260709161519.1559723-1-kbusch@meta.com>
References: <20260709161519.1559723-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NtqhhJoPWx1WlHvi_5TfWpkogIW3RT31
X-Proofpoint-ORIG-GUID: NtqhhJoPWx1WlHvi_5TfWpkogIW3RT31
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfX7rP9m8ZhvS2C
 1Mup57mUdb8zqsOodfUNEpaMmNJMqma0P6hbCMIsrpePW+15mdSBi7HedGPZDJIbw+g3Nis2SW5
 qP7uhd82fbZbLsVWAQRhZnPF6Ob+uydRD6Gv5kfDi/LNDEdaJUYAzVMDuUzJc/YVFWBMoqn3e3n
 9S2EPclKMkgwP08Jdtb02Y8EnABEsKrEPUUQfUKXCuF6EFwlS6qc5APETbIUS7XleA1druOqnwc
 +fkBSobxc9WBwMFnyRSDScq+F5gARWT0RqLQLZ67MknMB3qccp6JWtp4O6LFbJNsajRYPCHOmrV
 nq1XzYIUMswSdHWErh6TdAY8ZkXOCaat7KqoGG0sLYzg66YxzRirfviUv9lXvtRb7M6rMYs66Nw
 JdeMK2sTy0nLsoQo5Zq6TEtjDoq/GyvyQTXwCZsWELxCgwfw3TQlwafAOeL99vDWakPXPKODG7W
 MqXTn5nnflSuhmAw+HA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfX4OLxlH+XkLVz
 FvmbbHyYymXCw2AN5RqnpOKb6oe52ufBJc9/ozXQSbvq9yFvIXkp4UcQaOvp7tyPQC2GFkMecIt
 MlyUgxTahsZDg8s02DAbg05FishTrVQ=
X-Authority-Analysis: v=2.4 cv=D8l37PRj c=1 sm=1 tr=0 ts=6a4fc92a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_1IyUuN4QrATX339ibzo:22 a=VwQbUJbxAAAA:8 a=ueb96tMFbk4oWExii0sA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_03,2026-07-09_02,2025-10-01_01

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

Use multiple scatterlist elements as needed to relax the memory
alignment requirement. To keep this simple, this more flexible
constraint is enabled only for certain encryption and initialization
vector types, specifically the ones that don't have additional use for
the request scatterlist elements beyond pointing to user data.

In the unlikely case where the incoming bio uses a highly fragmented
vector, the four inline scatterlist elements may not be enough, so
allocate a temporary scatterlist when needed, falling back to a mempool
for the in and out buffers to guarantee forward progress if the initial
allocation fails.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 161 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 140 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index fc9c875cccfd2..66f666d9812f0 100644
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
@@ -1351,22 +1358,92 @@ static int crypt_convert_block_aead(struct crypt_=
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
+			   struct bvec_iter iter, struct bio *bio,
+			   int max_segs, mempool_t *pool, bool *pooled)
+{
+	unsigned int bytes =3D cc->sector_size;
+	struct scatterlist *sg =3D *psg;
+	struct bvec_iter tmp =3D iter;
+	int segs, i =3D 0;
+
+	*pooled =3D false;
+	bio_advance_iter(bio, &tmp, bytes);
+	segs =3D tmp.bi_idx - iter.bi_idx + !!tmp.bi_bvec_done;
+	if (segs > max_segs) {
+		if (unlikely(segs > BIO_MAX_VECS))
+			return -EIO;
+		sg =3D kmalloc_array(segs, sizeof(struct scatterlist),
+				   GFP_NOWAIT | __GFP_NOMEMALLOC);
+		if (!sg) {
+			sg =3D mempool_alloc(pool, in_interrupt() ? GFP_ATOMIC :
+								GFP_NOIO);
+			if (!sg)
+				return -ENOMEM;
+			*pooled =3D true;
+		}
+	}
+
+	sg_init_table(sg, segs);
+	do {
+		struct bio_vec bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, iter);
+		int len =3D min(bytes, bv.bv_len);
+
+		/* Reject unexpected unaligned bio. */
+		if (unlikely((len | bv.bv_offset) & cc->io_alignment))
+			goto error;
+
+		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
+		bio_advance_iter_single(bio, &iter, len);
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
@@ -1383,15 +1460,23 @@ static int crypt_convert_block_skcipher(struct cr=
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
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_in, ctx->iter_in, ctx->bio_in,
+			    ARRAY_SIZE(dmreq->sg_in), &cc->sg_in_pool,
+			    &dmreq->sg_in_pooled);
+	if (r < 0)
+		goto out;
=20
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_out, ctx->iter_out, ctx->bio_out=
,
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
@@ -1400,7 +1485,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 		} else {
 			r =3D cc->iv_gen_ops->generator(cc, org_iv, dmreq);
 			if (r < 0)
-				return r;
+				goto out;
 			/* Data can be already preprocessed in generator */
 			if (test_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags))
 				sg_in =3D sg_out;
@@ -1420,13 +1505,16 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 		r =3D crypto_skcipher_decrypt(req);
=20
 	if (unlikely(r =3D=3D -ENOMEM))
-		return r;
+		goto out;
=20
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
 	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
 	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+out:
+	if (r !=3D -EINPROGRESS && r !=3D -EBUSY)
+		crypt_free_sgls(cc, dmreq);
=20
 	return r;
 }
@@ -1492,7 +1580,9 @@ static void crypt_free_req_skcipher(struct crypt_co=
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
@@ -2731,6 +2821,8 @@ static void crypt_dtr(struct dm_target *ti)
=20
 	mempool_exit(&cc->page_pool);
 	mempool_exit(&cc->req_pool);
+	mempool_exit(&cc->sg_in_pool);
+	mempool_exit(&cc->sg_out_pool);
 	mempool_exit(&cc->tag_pool);
=20
 	WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) !=3D 0);
@@ -2765,10 +2857,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti,=
 const char *ivmode)
 {
 	struct crypt_config *cc =3D ti->private;
=20
-	if (crypt_integrity_aead(cc))
+	if (crypt_integrity_aead(cc)) {
 		cc->iv_size =3D crypto_aead_ivsize(any_tfm_aead(cc));
-	else
+		cc->io_alignment =3D cc->sector_size - 1;
+	} else {
 		cc->iv_size =3D crypto_skcipher_ivsize(any_tfm(cc));
+	}
=20
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
@@ -2803,6 +2897,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, c=
onst char *ivmode)
 		if (cc->key_extra_size > ELEPHANT_MAX_KEY_SIZE)
 			return -EINVAL;
 		set_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags);
+		cc->io_alignment =3D cc->sector_size - 1;
 	} else if (strcmp(ivmode, "lmk") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_lmk_ops;
 		/*
@@ -2815,10 +2910,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti,=
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
@@ -3285,6 +3382,20 @@ static int crypt_ctr(struct dm_target *ti, unsigne=
d int argc, char **argv)
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_si=
ze,
 		      ARCH_DMA_MINALIGN);
=20
+	ret =3D mempool_init_kmalloc_pool(&cc->sg_in_pool, MIN_IOS,
+			BIO_MAX_VECS * sizeof(struct scatterlist));
+	if (ret) {
+		ti->error =3D "Cannot allocate crypt scatterlist mempool";
+		goto bad;
+	}
+
+	ret =3D mempool_init_kmalloc_pool(&cc->sg_out_pool, MIN_IOS,
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
@@ -3495,10 +3606,16 @@ static int crypt_map(struct dm_target *ti, struct=
 bio *bio)
 		}
 	}
=20
-	if (crypt_integrity_aead(cc))
+	if (crypt_integrity_aead(cc)) {
 		io->ctx.r.req_aead =3D (struct aead_request *)(io + 1);
-	else
+	} else {
+		struct dm_crypt_request *dmreq;
+
 		io->ctx.r.req =3D (struct skcipher_request *)(io + 1);
+		dmreq =3D dmreq_of_req(cc, io->ctx.r.req);
+		dmreq->__sg_in =3D &dmreq->sg_in[0];
+		dmreq->__sg_out =3D &dmreq->sg_out[0];
+	}
=20
 	if (bio_data_dir(io->base_bio) =3D=3D READ) {
 		if (kcryptd_io_read(io, CRYPT_MAP_READ_GFP))
@@ -3694,7 +3811,9 @@ static void crypt_io_hints(struct dm_target *ti, st=
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

