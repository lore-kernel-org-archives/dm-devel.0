Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43F3A0B0A
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405296; cv=none; b=CmqQrCGk38JwIEp1kmztAdg5MjunFP3v3eN2XJyK97BwyEEr0bBfqpuVyYtjGCPzZbqqmhGSIqxiVCl4rsXwr+5bN6GX+3k0js9Lcfk6T3pv2SrR6DoiysebU2fCP/Hy0rNRjJLiDXX1x20mxS0qrWlSfVr1+KX/rpbNnmFoG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405296; c=relaxed/simple;
	bh=GUTI/dBbtapq20oXcvVgyKRPg2YJGOlQosAXXZ9IE9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DAAuXt9op1dm6OzMeK8l9CxgxCJYc/XQHiAgdJ1Ds/ygjb9SOK1GDgfQW1Y6Ef6doAOzsTlJBzX5PV9g9OTE8YvQ8ex5J8G6RRd3b5I1x08Wh+fqsOGOIuwTEnL32Aai8SBfDYHB5XmXYy2m98EFnmeka1mwJv4hzUJP3NFbrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZRmRQtBs; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZRmRQtBs"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60EET5ob3316672
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=mqKT7/LioCJJBGWv0S4iF0MaE937RGrix8IdKPTbw2M=; b=ZRmRQtBs44j0
	hZi0ZLYxB5C7VNJgdOSAhUv8z9x92tSIvCD0VZFA03KxfaFx2XmuRz0lW9STK1eJ
	yDTvH1htnFkEK3B2muI+da9jqnjra/epv+O4DymcA0VtduxIYGbQ6FVR5IyVDwUM
	j2z3j3Y3WRwYnXqnRBdF+P9eIzR5hoQLkwx0Fpb1bqnXPj/1wINW48xBgFvq2Sr1
	lW1eXhtc3PINF02qDFftEnUII4ceqzRwsEQd5O8hUegUUsrFOUdYhatAUQ5Zhka0
	zPKITx0iFDEf3/65swol+Qm1Jjg3VoLVDUsmi3qLZJZsUlMfPaeFW+QSd2n5I5dM
	OT7lAJLEqw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4bp12adg4c-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:27 -0800 (PST)
Received: from twshared18017.01.snb2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:41:23 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 04D0763A8FFB; Wed, 14 Jan 2026 07:41:13 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <linux-block@vger.kernel.org>,
        <snitzer@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>,
        <ebiggers@kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/3] dm-crypt: dynamic scatterlist for many segments
Date: Wed, 14 Jan 2026 07:41:13 -0800
Message-ID: <20260114154113.3207790-4-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114154113.3207790-1-kbusch@meta.com>
References: <20260114154113.3207790-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cVPiq0gB25uGkEavguF0ep_orIX5v55-
X-Proofpoint-GUID: cVPiq0gB25uGkEavguF0ep_orIX5v55-
X-Authority-Analysis: v=2.4 cv=KcjfcAYD c=1 sm=1 tr=0 ts=6967b927 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=TomXjiwf8yvF16FIC5MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMSBTYWx0ZWRfX6v7G9dFTW11x
 Gh4uopeyx9Z+bh0X72qlQjBRtxAo39vMR5Fr2OOsQRHF2jc8nZzDPfCUdreUj/e5WvV+TboYRuM
 gov/iWcpPznOvdxErwnkHmxJmU9u1By5pt541eVrCYstfxnxU+1dEu40/abuAo4ThQaVvsFrVtp
 l5D5dBXiFooUQpkQsCFmZNnJuRPVMMVqsVgoqY7hHClAT4NSQhEc9/FlkFmKLnQin4DN0WfIja3
 VtrkmIvUigIKWRY7IEuAlrGdTHfq/ttlVA/3UUv7deSHoRV+bgS5vszEFXcPQR++XeDBDS5lYPE
 0qU1rIGd1kHd5uxTfN0dHPODGeJgBomZXa6t1McPsNZ5tEPfh+ALbWKXRP3+sAtQ+lMMY83D+9w
 qjfbGF9Y3YslfVgoDzni8zn33YAyv1VDqa5Wx5QcQ5JS9HgDGoqPUgiaHcl154m/KucRv6xIC6Y
 WD6ay5qeWh1JLlXWbwg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

In the unlikely case where the base bio uses a highly fragmented vector,
the four inline scatterlist elements may not be enough, so allocate a
temporary scatterlist for the cause.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 48 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0b3f5411695ac..a634881a490ce 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -97,6 +97,8 @@ struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
+	struct scatterlist *__sg_in;
+	struct scatterlist *__sg_out;
 	u64 iv_sector;
 };
=20
@@ -1346,6 +1348,8 @@ static int crypt_convert_block_aead(struct crypt_co=
nfig *cc,
 	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
 		dmreq->iv_sector >>=3D cc->sector_shift;
 	dmreq->ctx =3D ctx;
+	dmreq->__sg_in =3D NULL;
+	dmreq->__sg_out =3D NULL;
=20
 	*org_tag_of_dmreq(cc, dmreq) =3D tag_offset;
=20
@@ -1425,18 +1429,22 @@ static int crypt_convert_block_aead(struct crypt_=
config *cc,
 	return r;
 }
=20
-static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist *=
sg,
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
@@ -1446,7 +1454,7 @@ static int crypt_build_sgl(struct crypt_config *cc,=
 struct scatterlist *sg,
 		/* Reject unexpected unaligned bio. */
 		if (unlikely((len | bv.bv_offset) &
 				bdev_dma_alignment(cc->dev->bdev)))
-			return -EIO;
+			goto error;
=20
 		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
 		bio_advance_iter_single(bio, iter, len);
@@ -1454,8 +1462,13 @@ static int crypt_build_sgl(struct crypt_config *cc=
, struct scatterlist *sg,
 	} while (bytes);
=20
 	if (WARN_ON_ONCE(i !=3D segs))
-		return -EINVAL;
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
@@ -1484,18 +1497,26 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 	sector =3D org_sector_of_dmreq(cc, dmreq);
 	*sector =3D cpu_to_le64(ctx->cc_sector - cc->iv_offset);
=20
+	dmreq->__sg_in =3D NULL;
+	dmreq->__sg_out =3D NULL;
 	sg_in  =3D &dmreq->sg_in[0];
 	sg_out =3D &dmreq->sg_out[0];
=20
-	r =3D crypt_build_sgl(cc, sg_in, &ctx->iter_in, ctx->bio_in,
+	r =3D crypt_build_sgl(cc, &sg_in, &ctx->iter_in, ctx->bio_in,
 			    ARRAY_SIZE(dmreq->sg_in));
 	if (r < 0)
 		return r;
+	else if (sg_in !=3D dmreq->sg_in)
+		dmreq->__sg_in =3D sg_in;
=20
-	r =3D crypt_build_sgl(cc, sg_out, &ctx->iter_out, ctx->bio_out,
+	r =3D crypt_build_sgl(cc, &sg_out, &ctx->iter_out, ctx->bio_out,
 			    ARRAY_SIZE(dmreq->sg_out));
-	if (r < 0)
+	if (r < 0) {
+		kfree(dmreq->__sg_in);
 		return r;
+	} else if (sg_out !=3D dmreq->sg_out) {
+		dmreq->__sg_in =3D sg_out;
+	}
=20
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1504,7 +1525,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 		} else {
 			r =3D cc->iv_gen_ops->generator(cc, org_iv, dmreq);
 			if (r < 0)
-				return r;
+				goto out;
 			/* Data can be already preprocessed in generator */
 			if (test_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags))
 				sg_in =3D sg_out;
@@ -1526,6 +1547,13 @@ static int crypt_convert_block_skcipher(struct cry=
pt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r =3D cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
+out:
+	if (r =3D=3D -EINPROGRESS && r =3D=3D -EBUSY) {
+		kfree(dmreq->__sg_in);
+		kfree(dmreq->__sg_out);
+		dmreq->__sg_in =3D NULL;
+		dmreq->__sg_out =3D NULL;
+	}
 	return r;
 }
=20
@@ -2301,6 +2329,8 @@ static void kcryptd_async_done(void *data, int erro=
r)
 	} else if (error < 0)
 		io->error =3D BLK_STS_IOERR;
=20
+	kfree(dmreq->__sg_in);
+	kfree(dmreq->__sg_out);
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
=20
 	if (!atomic_dec_and_test(&ctx->cc_pending))
--=20
2.47.3

