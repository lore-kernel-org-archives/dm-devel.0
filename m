Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA37242D63
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212216; cv=none; b=D6pFnNpQKW4W2m3GY9yt69hYHrEaReVgXRZipZFXGjP+fwRp3qM9VTIFR9T/WYrw/6VGKYwtDQihkGHf6jUBRDg2xHmYpVIos6O9YGNB+Elp69DLq5FPxl+aEZkc4cAvclWxuE+X7NsLtsRypSPc9eAhHz20XWkw9k95iCsaA8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212216; c=relaxed/simple;
	bh=ulDFdQ2NVV6nKVTrHUERVlJyCw9OstZSSVl171NWk+g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P+AowtRIcrP0esp/JpDIEJ8axT8peptKFTWs04VSh6xoGJakFitGXmOrwIg1vs3Y7Tl0R4I4NeklqtYelzh4ZaNKqCS9aljyL9INQRs3iNwK7gRu9ETbXLLy5uUknvY50gVFLxvjRhxHHDJh464vVvnk19bDdE1t0sdqxi4KVt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=proVjXH9; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="proVjXH9"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58I75dEB2634803
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 09:16:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=jLwvibaJzHKStENea7
	UMs0vbMVGV75H2z6urrGsGw80=; b=proVjXH9YT6+3JjofjRKH6dWRj3D6w0zv8
	FXqvfF28Kqzy7cPtL6gn13/ig3Uk8RUVM3xCjuQ088XL+IlyVDAEdPaaJ+5HUIFs
	IHD87H0nodcPRC3pdspjAv/xvapuC8t9Wc70rhOMl+4VDWcLe6zTG+8fY29s8o/d
	GG6Bl/BnXwRZJEMsSJCIpidXcdUHpNTnTLTT+2V4xBYe9yArkM3QrpuEniSAiphc
	rC4vC6i8JRe44Ui9svt9ExMfVw4FXOrwrLjVPtCd3RPUFpRCZwUKTD6738BZXhX5
	PvH/jUFw5fPUVGRUf958MCHLACxyxU1BVI84jbElCgrhP1JG/23Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 498dcx3d46-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 09:16:53 -0700 (PDT)
Received: from twshared7571.34.frc3.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 16:16:50 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 635461D2C204; Thu, 18 Sep 2025 09:16:43 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <snitzer@kernel.org>, <linux-block@vger.kernel.org>, <mpatocka@redhat.com>,
        <ebiggers@google.com>, Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH] dm-crypt: allow unaligned bio_vecs for direct io
Date: Thu, 18 Sep 2025 09:16:42 -0700
Message-ID: <20250918161642.2867886-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE0MyBTYWx0ZWRfXzaedlXvqs4yI
 PUOI6pbc6ShXxC4apue+HT2Vyb2arYJ4mhCZj+4/7Z2unFJu+oHFTzNet8k/wFeCD3zWCED0Rg/
 bllxQOfXhObGxZgFA7zDqo63JoXcnVtrOjg1ze/Nn2d702Ffu/bIUmnliQnM2qfRg7OwXEUFXhg
 zBY5UsNEO1p64ulpTTJstObCxH51gPxflCSrcjnH1GWi+9KwU8DLvaIwApTPRPrE1Xq5e5wIuNO
 H1VZe8pgeUk6sa6g05wV5bqYS4D49YaINBI2MjL0L/b9cUIR1Z/fNpynIt1+1uSCVC1p5OUq2fE
 PhEUsmKoKd9Gk3kBWC4ce/dH9jjhSfj0u9+uSqaDUOUuksKVmuwW0BeYCBRXO8=
X-Proofpoint-GUID: AnMFxSm3N5xTj35O-pDqnLFfA7IkXTXZ
X-Authority-Analysis: v=2.4 cv=JuHxrN4C c=1 sm=1 tr=0 ts=68cc3075 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=uud4dMGIaqtzyunwYh0A:9
X-Proofpoint-ORIG-GUID: AnMFxSm3N5xTj35O-pDqnLFfA7IkXTXZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Most storage devices can handle DMA for data that is not aligned to the
sector block size. The block and filesystem layers have introduced
updates to allow that kind of memory alignment flexibility when
possible.

dm-crypt, however, currently constrains itself to aligned memory because
it sends a single scatterlist element for the input ot the encrypt and
decrypt algorithms. This forces applications that have unaligned data to
copy through a bounce buffer, increasing CPU and memory utilization.

It appears to be a pretty straight forward thing to modify for skcipher
since there are 3 unused scatterlist elements immediately available. In
practice, that should be enough as the sector granularity of data
generally doesn't straddle more than one page, if at all.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77f..f860716b7a5c1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1429,18 +1429,14 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 					struct skcipher_request *req,
 					unsigned int tag_offset)
 {
-	struct bio_vec bv_in =3D bio_iter_iovec(ctx->bio_in, ctx->iter_in);
 	struct bio_vec bv_out =3D bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+	unsigned int bytes =3D cc->sector_size;
 	struct scatterlist *sg_in, *sg_out;
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv;
 	__le64 *sector;
 	int r =3D 0;
=20
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
-		return -EIO;
-
 	dmreq =3D dmreq_of_req(cc, req);
 	dmreq->iv_sector =3D ctx->cc_sector;
 	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
@@ -1457,11 +1453,24 @@ static int crypt_convert_block_skcipher(struct cr=
ypt_config *cc,
 	*sector =3D cpu_to_le64(ctx->cc_sector - cc->iv_offset);
=20
 	/* For skcipher we use only the first sg item */
-	sg_in  =3D &dmreq->sg_in[0];
 	sg_out =3D &dmreq->sg_out[0];
=20
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	do {
+		struct bio_vec bv_in =3D bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+		int len =3D min(bytes, bv_in.bv_len);
+
+		if (r >=3D ARRAY_SIZE(dmreq->sg_in))
+			return -EINVAL;
+
+		sg_in =3D &dmreq->sg_in[r++];
+		memset(sg_in, 0, sizeof(*sg_in));
+		sg_set_page(sg_in, bv_in.bv_page, len, bv_in.bv_offset);
+		bio_advance_iter_single(ctx->bio_in, &ctx->iter_in, len);
+		bytes -=3D len;
+	} while (bytes);
+
+	sg_mark_end(sg_in);
+	sg_in =3D dmreq->sg_in[0];
=20
 	sg_init_table(sg_out, 1);
 	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
@@ -1495,7 +1504,6 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r =3D cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
 	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
=20
 	return r;
@@ -3750,7 +3758,8 @@ static void crypt_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)
 	limits->physical_block_size =3D
 		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
 	limits->io_min =3D max_t(unsigned int, limits->io_min, cc->sector_size)=
;
-	limits->dma_alignment =3D limits->logical_block_size - 1;
+	if (crypt_integrity_aead(cc))
+		limits->dma_alignment =3D limits->logical_block_size - 1;
=20
 	/*
 	 * For zoned dm-crypt targets, there will be no internal splitting of
--=20
2.47.3

