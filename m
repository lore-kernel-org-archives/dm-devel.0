Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE82C2FDC3D
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773673367; cv=none; b=Hco+99so/9+epRIsDe3oWbTR+xQZEEMDd9axA4+YuuNYn1pxLNnbnEgoqB0meIuXYdksymHwFHl8FO0V1uK7frNtN0iIzrVAwFSgQR4Cyjh8znf+1kisjBO8fMlJFeOAJYhzVKGeJhDqUBNDxU6oboeE8ud2vO1QR6wJL/pU36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773673367; c=relaxed/simple;
	bh=/4EsLkzXzw32z2n0e9+8Cku8ZdPnNFS8ovsqAsmNRkc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qK5/iN2P8rR0G9nwGcJ6d8Si6NjsoLn+i38KF2TQLgq0ZO5nLm1RTLvOr11GX+D6bGTXByZc1ZcqmYrgtud9hclVxFok0Sox5t/NBITgZjq5zYMtUH0kTE6fHFPdnXO2If5EouwcmgP1KrhHLefUOkS4zMItBrLEa4GXXg9ZhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JYJcoa4t; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JYJcoa4t"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G8aqam010308
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:02:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=u7xOyKKSZf5YKpznst
	wYHYtqKASayigx8bYJzVCvj24=; b=JYJcoa4tjVUBHxhL68lCD2XAzxnDBwrPOv
	VtM6t+y31MIiJYs+7Ed1mzSyG9sEg23uvY22TLEHdq8M+H/8XzoAHwJZ86hEaACi
	SmxU19+PT+IC7i6Xo8L3T70lNsVrsP+b9Dr32SEBCqCPSj79DcleI8l4MNRn0BPx
	2rxshQ2x6lMebJ6CfRi4CnLPH/J0SNIjOoKRQN1Ft0szZMypDicsXc6HwJ2Todvi
	C+Lux+vghVkY6AIoU7/BGc//GMJrEhmUDozeg9LdS6MI2ro6VyGO6Lz00vPjeV/r
	jgwVlT04w436R2aC5ePwp5JHVLlWro322ntZ2iXEwjq0QvcVU4xQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cxegembun-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:02:43 -0700 (PDT)
Received: from twshared111727.16.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 16 Mar 2026 15:02:41 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 86D6ABA09B2A; Mon, 16 Mar 2026 08:02:30 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for direct io
Date: Mon, 16 Mar 2026 08:02:29 -0700
Message-ID: <20260316150229.1771884-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rCLit4JAwVDkGWz6lYzT5iliTacSKT6_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExMSBTYWx0ZWRfX1+98nUhwxy2f
 U64lul/aJxzQRc4AdSbl7iQ/3mc94EK0nTXjzhH9ssdwQ7Ffq3kga+pGI0FQg/vOPNGpnGnaNnV
 j0S9BqhdQfhoXxBW7X1qfHMLGWkbfZjtYtFp/+EsLkEqj5hrzu4q/467u2fmM/6fIgmMUvytHcI
 5CtvKYl/HymPyzvqJYHfr6c2KVkZII77bmiwbFOGN4rAvyEGctn7ZAIn541IAKlRkQOztXbI0LD
 pNIXfwkxn0mRXycQFbWD3AF5TsDjpatzPWmMseUH7khhJkKr9vycCvc+OgJoVAysNb8RDHwlYoh
 avfraf8cpMS13RnX6wufZJ6rUyqdBz1qmTGHHEeJI8rwgqs/Ddo4X85Ep4DUZSlMUYuz+3M+qQD
 FbuoLSJ54AZWeg0TYYkDmQiuRm1zIWxof0vuiKYce+dxUWf6F5d590LCHZf496TW3sqODieTwPS
 4IvLytd45B5PffJZi3g==
X-Authority-Analysis: v=2.4 cv=Rdqdyltv c=1 sm=1 tr=0 ts=69b81b93 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=IXXs4cDxjPlTTCw5R5gA:9
X-Proofpoint-GUID: rCLit4JAwVDkGWz6lYzT5iliTacSKT6_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01

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
index 54823341c9fda..bbb4346d0127f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -150,6 +150,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sec=
tors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (eleph=
ant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_DISCONTIGUOUS_SEGS,	/* Can use partial sector segments */
 };
=20
 /*
@@ -215,6 +216,7 @@ struct crypt_config {
 	unsigned int key_extra_size; /* additional keys length */
 	unsigned int key_mac_size;   /* MAC key size for authenc(...) */
=20
+	unsigned int io_alignment;
 	unsigned int integrity_tag_size;
 	unsigned int integrity_iv_size;
 	unsigned int used_tag_size;
@@ -1384,22 +1386,48 @@ static int crypt_convert_block_aead(struct crypt_=
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
@@ -1416,15 +1444,18 @@ static int crypt_convert_block_skcipher(struct cr=
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
@@ -1455,9 +1486,6 @@ static int crypt_convert_block_skcipher(struct cryp=
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
@@ -2788,10 +2816,12 @@ static void crypt_dtr(struct dm_target *ti)
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
@@ -2827,6 +2857,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, c=
onst char *ivmode)
 		if (cc->key_extra_size > ELEPHANT_MAX_KEY_SIZE)
 			return -EINVAL;
 		set_bit(CRYPT_ENCRYPT_PREPROCESS, &cc->cipher_flags);
+		unaligned_allowed =3D false;
 	} else if (strcmp(ivmode, "lmk") =3D=3D 0) {
 		cc->iv_gen_ops =3D &crypt_iv_lmk_ops;
 		/*
@@ -2839,10 +2870,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti,=
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
@@ -2852,6 +2885,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti, =
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
@@ -3722,7 +3761,11 @@ static void crypt_io_hints(struct dm_target *ti, s=
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
index dc2eff6b739df..aecb19a6913db 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1767,6 +1767,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
 	bool zoned =3D false;
=20
 	dm_set_stacking_limits(limits);
+	limits->dma_alignment =3D 0;
=20
 	t->integrity_supported =3D true;
 	for (unsigned int i =3D 0; i < t->num_targets; i++) {
--=20
2.52.0

