Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B527C842
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625282; cv=none; b=uOAYQfG5P1ESFMWPXuewbzyEi8E+1O75F3Kz+EOqAkH0K+vNTaV/MPr3LuV1aMW07FlomRDYNMhTiffPrXHi+j3jZ4szd/ZUx1j6fDEEdE5/d7XR2T2FT3Y5IUAOPKuJuI+UzWb6aau7BZjYrlOAjvOoM3t3MPOO029TRNastpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625282; c=relaxed/simple;
	bh=T8weHn8otMphpEreUJWqv5SlzDSbz8VmMVimy7muyEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OQYslk4eQxziMvDvNSHMID2+RpQyGjekgchHhq1qIjxXvau83m1cyUvZaUdkWQgFhmsk1wHFbnYzjG9bwO91FGQwJEiQ26hfDCTZQZb29YcuCYDLFEdZXQFrTuTFlX+U+BOq+RyEohEsnI/NjfscSzs1L3il5I8vbo9+68lSTtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=V+TkjIr7; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="V+TkjIr7"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1Led581400315
	for <dm-devel@lists.linux.dev>; Mon, 1 Dec 2025 13:41:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=l/N0oNZdrOxC+sMk7wLBt3mzHipkA8OrRZGOO0xO1fI=; b=V+TkjIr7KWZb
	sRdL8/VOJPGgPW2bL/cMGaS/KBRtFcoKOttu+76x4hqtNMLkdpqHKW3v+QqUPRiF
	oxZRhhbX9SNSV9sOdtDFClD+M3F9xLwSMco23ZZlHuJZLdgrPT3PzP8q7YZ7B/AB
	vv5ecjvYwPinfcyN3yt3PpPjff8C7qj0jRtJw/cCukmFG+jKaPh7DDuWU7V+qHJq
	RCQ12lMGh/XVa/fVsyvBXNRteMBV8JmZ/lf6gC4ZixKOCYZ9Eghqe2qFl2qVEhx6
	m49T5XFMtWYsR6QlXkS9EG/L+y6fwPGyORjkHssnBZQBI/IgtNh7/iPIH2vrylPR
	I1EWs/1guw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4asehyb15s-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 01 Dec 2025 13:41:18 -0800 (PST)
Received: from twshared71707.17.frc2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 1 Dec 2025 21:41:09 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id AC0FF45AA8A1; Mon,  1 Dec 2025 13:40:56 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <snitzer@kernel.org>, <hch@lst.de>,
        <ebiggers@kernel.org>
CC: <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv3 2/2] dm-crypt: dynamic scatterlist for many segments
Date: Mon, 1 Dec 2025 13:40:52 -0800
Message-ID: <20251201214052.1531952-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251201214052.1531952-1-kbusch@meta.com>
References: <20251201214052.1531952-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDE3MyBTYWx0ZWRfX0UZtjACc9xFc
 MuMG4x1EG5X3Wze7beq7kJTBus4PNJsg27DexZ/biyNvvXOdKWgjwBM+Bow9+8bNhDsOFgyPlIa
 maXf1zgGxNUIVwMTqUegzggGCXeAWjZtVUBwGYhkIWIjrCOxX6J4xQx2K7QevkAuzNcfNaFXyRq
 YZoV12S4LoxDJHc2zSctuGICiC/dR6iVxZkXwp+xA3nwRG3xljGwhKWuTCybmS213d/+Yzo+H/1
 kQLdM1X0kj7urgqtJXDBKLN/6B78ROerahuKj1j7W5pL7o5CIixAG9Ub42RLd6qtYYDnMPA1hGe
 27tG2FEG6WI0YODgesKkKaRBxNeY9awZOn7q80PGIVO2N8OzG1AR6fUftl5loGUWw2OX8ByUg+N
 WqU76JgrzcXqjMJ4MYJG1Ybd8Y0CKA==
X-Authority-Analysis: v=2.4 cv=CecFJbrl c=1 sm=1 tr=0 ts=692e0b7e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=uKr_gk69WBrFS6epR-gA:9
X-Proofpoint-GUID: Bt3m1S11K6rmQtWH3pYqSrMCZFG1t4_d
X-Proofpoint-ORIG-GUID: Bt3m1S11K6rmQtWH3pYqSrMCZFG1t4_d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

In the unlikely case where the base bio uses a highly fragmented vector,
the four inline scatterlist elements may not be enough, so allocate a
temporary scatterlist when needed.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 51 +++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5304954b4574b..d659ea4573192 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -98,6 +98,8 @@ struct dm_crypt_request {
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
 	u64 iv_sector;
+	struct scatterlist *__sg_in;
+	struct scatterlist *__sg_out;
 };
=20
 struct crypt_config;
@@ -1426,18 +1428,32 @@ static int crypt_convert_block_aead(struct crypt_=
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
@@ -1446,7 +1462,7 @@ static int crypt_build_sgl(struct crypt_config *cc,=
 struct scatterlist *sg,
=20
 		/* Reject unexpected unaligned bio. */
 		if (unlikely((len | bv.bv_offset) & cc->io_alignment))
-			return -EIO;
+			goto error;
=20
 		sg_set_page(&sg[i++], bv.bv_page, len, bv.bv_offset);
 		bio_advance_iter_single(bio, iter, len);
@@ -1454,8 +1470,13 @@ static int crypt_build_sgl(struct crypt_config *cc=
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
@@ -1484,18 +1505,21 @@ static int crypt_convert_block_skcipher(struct cr=
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
@@ -1504,7 +1528,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 		} else {
 			r =3D cc->iv_gen_ops->generator(cc, org_iv, dmreq);
 			if (r < 0)
-				return r;
+				goto out;
 			/* Data can be already preprocessed in generator */
 			if (test_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags))
 				sg_in =3D sg_out;
@@ -1525,6 +1549,9 @@ static int crypt_convert_block_skcipher(struct cryp=
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
@@ -1590,7 +1617,9 @@ static void crypt_free_req_skcipher(struct crypt_co=
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
2.47.3

