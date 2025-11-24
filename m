Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A7C3168EE
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004158; cv=none; b=IzjEFzLpI24Kv09YqIg8EDaLXqRfqBI5lz82ZPH8NbX1Ag4Oz3cFQY0iAQhDwSf3vE0zFdHi0OO+b/WUZsob/uymE/66Zt5u+cbQ5Zp66IF2wUQJF0XRkwNMMH9d2PKRl4KM2aHCZUBOb7T1ltqLMfVNoXdgW2y7rMLdTyp1HO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004158; c=relaxed/simple;
	bh=GUTI/dBbtapq20oXcvVgyKRPg2YJGOlQosAXXZ9IE9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqgU/vkZwtxgNH3iCLhQogXnx8m+yysiLnOGP8GCAarUShmezhC77U3VIb7IcrJuxhZdpwlAOaMAKd1SqWL2GFAFZmmQNcAIktbVSM34slSi6N77m9atmIAqOsl6HtWPurKgeQ/k2kfTvfwHFqmLm96JIYSRIlTKoFBrWxYubVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VTCDwjud; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VTCDwjud"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOEa0tX2694670
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 09:09:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=mqKT7/LioCJJBGWv0S4iF0MaE937RGrix8IdKPTbw2M=; b=VTCDwjudO4U/
	Gc1QLHSwKM03GReN2sJf/gsAgYhu01McpfxpfI+BBbVG2FAjw4flqcPRAnVKsTNP
	KhlFhc30uiy9tFCm9VOeJ1PiEv9piF0dI97gCiDGiaSTpaa36gjPRiF/RVnwMZfd
	iJLdYiii4KyLTIYIcxZiTmtXPknyQfiHZ2firwcjZ8aVjxMIa6DGILp9C9KW5RTQ
	Y6+/RzKy2pu5ApHZ0tW3+L7LYruRpHhHGX/DcoiGk+97Se73Y1R/+96xe2X3sT4F
	MNrZx68VxGMlnLnjYT3ZQmEXHwwE/zNYE8+rgzz0a60bRdQT1WRgPPygoLepR+8D
	1zR5xqiOyw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ams9119hd-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 09:09:15 -0800 (PST)
Received: from twshared40939.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 24 Nov 2025 17:09:13 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 4C78F41D0F4F; Mon, 24 Nov 2025 09:09:08 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <linux-block@vger.kernel.org>,
        <snitzer@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>,
        <ebiggers@kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/3] dm-crypt: dynamic scatterlist for many segments
Date: Mon, 24 Nov 2025 09:09:03 -0800
Message-ID: <20251124170903.3931792-4-kbusch@meta.com>
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
X-Proofpoint-GUID: _7LEdJNdnAqAweYKJyJlmdPNrIIIQbmU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE1MCBTYWx0ZWRfXyjpd3/vUQ7Vq
 ZgkBrN3uzv2v1TXIGgz1u3hzWDd4KgTFtnsJmDJnaBajwomfusQOQOZ4xjQcUhoYAhMSndNgXx/
 Jq2leRMkVFo1mjRO9g/JeTYW7tpcF8xvfrBc8wSfC1Q8uIcGf6NTHuJuzybS9GCCkdF/2dqOGQX
 A5rLxNSb0oUxCBImOHYnsUWnjdHUv/jTM1/dMuLX65LsYw4U3ebXuzH5QmAZL3JVSnv1DsmfAzS
 dRWQSgOv8JDgIPXVKauBgGA+1oo21qMNJNzqHAtPAvF/GYNDmSuSTleedYm/gLJBNSCEjQy7y7M
 R0SRHQG4PFXKEnqLus53ONxVFQXQFJWf5y4eJZ5K1lfyXx7rD/8AKKeRZNvALyoS63bVfMf3dcw
 YUaxDkZiJWJ6KLelHZtQfuDijcymWA==
X-Authority-Analysis: v=2.4 cv=BL2+bVQG c=1 sm=1 tr=0 ts=6924913b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=TomXjiwf8yvF16FIC5MA:9
X-Proofpoint-ORIG-GUID: _7LEdJNdnAqAweYKJyJlmdPNrIIIQbmU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01

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

