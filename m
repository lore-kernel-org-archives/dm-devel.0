Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB939E198
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773673796; cv=none; b=OLQR7qOv8wzIZQkjqGKV6gMv5kNtYNps3lHt6X21jELFClUf2tK28rGs49mh1pvQ5XgLZpCzGrP7fTi+B1/F84j2P0eejfwdza5uuVGMdZI5jkpwzLJCvHCDRDcY/RbY2E6dvCWZcUk/ijO38DdthqZAJhm1uhoVfXEkJtVj1R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773673796; c=relaxed/simple;
	bh=LjTbO0QcyLaeLP2PxAtL3DYXapLhfJIVrteWkU4tiUU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUdI+zXlJX2CCPCeQFacWkp24Wwoji+LT1dwAIlcXlRoD3zv+rng3kG3M7m+xSuQan5Lg0sGtLO547Gh6/ijG4OE7H9X4bB540w55ts8KZDSmj+nVoHYZhQMbvrxUX5GjfV67IRLhUtpxMFby/oXzQIuFxWXMhtuAr7n/Iz8QjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=UXq1ixYu; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="UXq1ixYu"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GF1rrI011456
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:09:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=9PjAvW1i2Vl3H8atQ8BRPUshCuGo4SnuteKi+uQseG0=; b=UXq1ixYurage
	P7rhm/OdOb/W5W+mZGBLBFIFiqY/HpohKP3XlLq3OwgfMu5wK8Gw6rXxxfwPGXOb
	JAFKGy1/oSPfHYEJjyRLr+FXSYIANm74V3S890S9inMiCeYyN4CWjpuMOtFkemrP
	p0mrwtGLGlAjBgnP2W5a5Q3WwDnUgeyvNUs5VOVdOxrKUWFbw+e78V+CBNnsb41O
	uRpA6guaSr1x7nlCxjRaJXdXVTnIIZLY+389fF8Eiag5Pr7v6ATtPX1Zl28JWTwI
	g/htNHFlUi1ABHE7UdI/zCQHxaeplhBdul752v7rjVhSEedwaDtx0O4gtOojcIE1
	+wEm8Cb20w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cxechcm27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:09:54 -0700 (PDT)
Received: from twshared26141.04.snb1.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 16 Mar 2026 15:09:53 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id D1C05BA0A7B6; Mon, 16 Mar 2026 08:09:42 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many segments
Date: Mon, 16 Mar 2026 08:09:41 -0700
Message-ID: <20260316150941.1813568-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260316150229.1771884-1-kbusch@meta.com>
References: <20260316150229.1771884-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZfsQ98VA c=1 sm=1 tr=0 ts=69b81d42 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VwQbUJbxAAAA:8 a=uKr_gk69WBrFS6epR-gA:9
X-Proofpoint-GUID: 7U612tpQjPcw4CYbYsXh9OiiGhXXfBYy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExNCBTYWx0ZWRfX5BBbzF7AZ8hn
 l7yjoZ1Py4myfACA5yx2WLbC5bOvjqTOWBiY0h5gJ8yxRmcxNK0PQbkYUKDabrB07TdkbY593ew
 V+fZhYjD7vNGh/SG0rvb4WvFPp/CpO8YLxLN66S1Z3+AfcXAcQ6xLl9z66dQ4yTeCsr/ZIaaJPu
 BsNyT2FKgGZ1AsS49c5VPDQvCR+nLXqrrqrI18zzab+lJgP0yLUAPwCipYlsvenC05h97FoeJ7k
 F4vvyIQYyHBgF9qYFDgrPIzBFZC5/vGEtbzX7l9vROoBDuHmBOchvuy0CA54FDRy9ha/uAxkC5O
 GzzlWuvonN2Tvot/WC150jzLiR9gIDsdi9BulYv8g7cbw6u5BPs4IZJQYAJpoi2GozaSPI35NWD
 dzHdZLzZf5iVb61lJjzEecP1Z2QW43xJHL02bbcIePaLmF78nTvWMEjkHMPQ6+kua6JBa050z4n
 ux0869eUb+TXSdHfL7Q==
X-Proofpoint-ORIG-GUID: 7U612tpQjPcw4CYbYsXh9OiiGhXXfBYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

In the unlikely case where the base bio uses a highly fragmented vector,
the four inline scatterlist elements may not be enough, so allocate a
temporary scatterlist when needed.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 51 +++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bbb4346d0127f..0a5bf6df17caf 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -100,6 +100,8 @@ struct dm_crypt_request {
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
 	u64 iv_sector;
+	struct scatterlist *__sg_in;
+	struct scatterlist *__sg_out;
 };
=20
 struct crypt_config;
@@ -1386,18 +1388,32 @@ static int crypt_convert_block_aead(struct crypt_=
config *cc,
 	return r;
 }
=20
-static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist *=
sg,
+static void crypt_free_sgls(struct dm_crypt_request *dmreq)
+{
+	if (dmreq->__sg_in !=3D dmreq->sg_in)
+		kfree(dmreq->__sg_in);
+	if (dmreq->__sg_out !=3D dmreq->sg_out)
+		kfree(dmreq->__sg_out);
+	dmreq->__sg_in =3D NULL;
+	dmreq->__sg_out =3D NULL;
+}
+
+static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist *=
*psg,
 			   struct bvec_iter *iter, struct bio *bio,
 			   int max_segs)
 {
 	unsigned int bytes =3D cc->sector_size;
+	struct scatterlist *sg =3D *psg;
 	struct bvec_iter tmp =3D *iter;
 	int segs, i =3D 0;
=20
 	bio_advance_iter(bio, &tmp, bytes);
 	segs =3D tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
-	if (segs > max_segs)
-		return -EIO;
+	if (segs > max_segs) {
+		sg =3D kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOIO);
+		if (!sg)
+			return -ENOMEM;
+	}
=20
 	sg_init_table(sg, segs);
 	do {
@@ -1406,7 +1422,7 @@ static int crypt_build_sgl(struct crypt_config *cc,=
 struct scatterlist *sg,
=20
 		/* Reject unexpected unaligned bio. */
 		if (unlikely((len | bv.bv_offset) & cc->io_alignment))
-			return -EIO;
+			goto error;
=20
 		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
 		bio_advance_iter_single(bio, iter, len);
@@ -1414,8 +1430,13 @@ static int crypt_build_sgl(struct crypt_config *cc=
, struct scatterlist *sg,
 	} while (bytes);
=20
 	if (WARN_ON_ONCE(i !=3D segs))
-		return -EIO;
+		goto error;
+	*psg =3D sg;
 	return 0;
+error:
+	if (sg !=3D *psg)
+		kfree(sg);
+	return -EIO;
 }
=20
 static int crypt_convert_block_skcipher(struct crypt_config *cc,
@@ -1444,18 +1465,21 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 	sector =3D org_sector_of_dmreq(cc, dmreq);
 	*sector =3D cpu_to_le64(ctx->cc_sector - cc->iv_offset);
=20
-	sg_in  =3D &dmreq->sg_in[0];
-	sg_out =3D &dmreq->sg_out[0];
+	dmreq->__sg_in =3D &dmreq->sg_in[0];
+	dmreq->__sg_out =3D &dmreq->sg_out[0];
=20
-	r =3D crypt_build_sgl(cc, sg_in, &ctx->iter_in, ctx->bio_in,
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_in, &ctx->iter_in, ctx->bio_in,
 			    ARRAY_SIZE(dmreq->sg_in));
 	if (r < 0)
 		return r;
=20
-	r =3D crypt_build_sgl(cc, sg_out, &ctx->iter_out, ctx->bio_out,
+	r =3D crypt_build_sgl(cc, &dmreq->__sg_out, &ctx->iter_out, ctx->bio_ou=
t,
 			    ARRAY_SIZE(dmreq->sg_out));
 	if (r < 0)
-		return r;
+		goto out;
+
+	sg_in =3D dmreq->__sg_in;
+	sg_out =3D dmreq->__sg_out;
=20
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1464,7 +1488,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 		} else {
 			r =3D cc->iv_gen_ops->generator(cc, org_iv, dmreq);
 			if (r < 0)
-				return r;
+				goto out;
 			/* Data can be already preprocessed in generator */
 			if (test_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags))
 				sg_in =3D sg_out;
@@ -1485,6 +1509,9 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
=20
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r =3D cc->iv_gen_ops->post(cc, org_iv, dmreq);
+out:
+	if (r !=3D -EINPROGRESS && r !=3D -EBUSY)
+		crypt_free_sgls(dmreq);
=20
 	return r;
 }
@@ -1550,7 +1577,9 @@ static void crypt_free_req_skcipher(struct crypt_co=
nfig *cc,
 				    struct skcipher_request *req, struct bio *base_bio)
 {
 	struct dm_crypt_io *io =3D dm_per_bio_data(base_bio, cc->per_bio_data_s=
ize);
+	struct dm_crypt_request *dmreq =3D dmreq_of_req(cc, req);
=20
+	crypt_free_sgls(dmreq);
 	if ((struct skcipher_request *)(io + 1) !=3D req)
 		mempool_free(req, &cc->req_pool);
 }
--=20
2.52.0

