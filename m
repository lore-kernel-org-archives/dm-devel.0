Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9565F34F24F
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405817; cv=none; b=J8b90ZA4nGqr/nzv9eGguWkLWj5naF49+JyEhTRxe/lNNKhAA9mHCg+SbbWmSBdUNZWs78FlAMnZnY3zqmV4byNdGikoJgBbWgGAC+IPp+2GbKHDVuHtYdN6w/klDdOC+LSC+DYqa4D+8ZwF//nW/LjfmJJ6/yzInFD5iEs2ZYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405817; c=relaxed/simple;
	bh=T8weHn8otMphpEreUJWqv5SlzDSbz8VmMVimy7muyEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYsYphOqZKUtsd3wiA8/gtijxrNWB564Yvb021BZF4WI6KLdo6Z6M9sdt3OpWq+tU+yzxLu2j96O6WPHqPyKFGZ78zWcItjcfx9zpK9ndYXUc4izMTsCN6klu4n0O/TIMSpVb5oSxR5omQErfgHEVh2ENkWcV4JCr1lfbNDYX8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Q5gHH5DJ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Q5gHH5DJ"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EETUH04028597
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=l/N0oNZdrOxC+sMk7wLBt3mzHipkA8OrRZGOO0xO1fI=; b=Q5gHH5DJCkKD
	XO0ecH6AdjNeDaEBiq39eablHUGyqkusjNCr4MyinHf1foajOOTVwO2sN/916p+1
	chhuhDl+VhqHsQ1JDiUTG9yh8uV/9W2OJff2+RUh1DjVdHJkIwWgnx/R6LtAAKyk
	f8EmhNjdNHqFAQwU01t2A2UV1/OteDAaoRo6UWEqc8VElv1TmRJiRwxoJ+bawNUn
	U2lu0Puo5eTdn80JR6F7h2FqXDHMBi3Qz7Jtg78lBOHJ63OoX0QZ+FaCZIQrMp0z
	BUKZAwDLMa/pZTDHOvUJOtTS/Q6dGzuWkNe60Z2kGQ7mLoPf0rTwyCaEoedXEXc0
	Ekb004f+pw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bp6pwujf4-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:14 -0800 (PST)
Received: from twshared25002.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:50:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1AD5263A9E16; Wed, 14 Jan 2026 07:50:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <snitzer@kernel.org>, <hch@lst.de>,
        <ebiggers@kernel.org>
CC: <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many segments
Date: Wed, 14 Jan 2026 07:49:54 -0800
Message-ID: <20260114154954.3282207-3-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=GYIaXAXL c=1 sm=1 tr=0 ts=6967bb37 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=uKr_gk69WBrFS6epR-gA:9
X-Proofpoint-GUID: yH_LfLes0JCH_UNjDaFhsVWl-uj8CTtA
X-Proofpoint-ORIG-GUID: yH_LfLes0JCH_UNjDaFhsVWl-uj8CTtA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMiBTYWx0ZWRfXypkl/tSzvggy
 6mcHESe8rcCVVxwDB0v/XhRNdXiwznRKpdDn6Dzb4UqTx0sbRyNNDZOCQfSYTb6KsSk3zNIj5Pk
 mxGe95TzPuP6qlBGN1QEm+CodgKKqo5FtFviHtOmedTzyczX/JtMIGkn3UAmzauHt7X879pkXQV
 s3WCsVJQlM2SIaKjaB+M8mHQ31ICLbYMSE7yb7yfK8WWaKurwiSsu2C1yelk7XNX5llIcmoFE1Q
 ZwvhX3XkV/0fwWpCZO2W+k2MxpUgoL/XAWQxyao9Z+Aol1gBzWAc5x+vROQy5E11u/OoEsUi1bf
 knHxxKvza5sl2UhUAOVApJe+typwgGrGLh3HvyFOTZ9y+nUdmRQqrX8kRvExOpDnbFdMTky8MbT
 rab0lOnr8JuBzRgsvaw6q7VOcEptu0762iJYYrtso/8GWBzpo+3smx+wAtWxfyzsaLfLOwlJ+7Y
 nVSrfL/PuztaUigVhFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

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

