Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1F13CDBC3
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320978; cv=none; b=HEPn1PZDKS8aBYwNdk249OrY2nQIPiuQnOW1+uwoWXZAnW41EjoPLZBb43A9iQn4oAUiRbTSNICEx9s1WLWXzqnx9JWIX2wBCgQKNZZVWoI9hAULoezyl2ZNZXVMo1g4RezkoudjdD2oFvYEAQ43EGA3LwyMVyHZwFhW3CrGUWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320978; c=relaxed/simple;
	bh=t3zk8zvQ1DiSSovPWsnR8dTPTOVXAS5862x6D1wAUz4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srNzNjpjYuuVqo1rzmNHWisgct8smB744DwzDYfC4fMfJeoGqgmOYIQPJlIiF9pGPvaLel7Hj4P5564LvVN4ty1YE005632+XKy2B92FOdzUE6jeyvlLNtJzQVgeNVyCW45/ycyX0SHA643fVSSVFqb52NKaA9u2GhRLAj63LNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=a1pDwle8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="a1pDwle8"
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65OEhXGg3927454
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:09:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=wGn86Bzy428SsRS3YWgR++pwndLALlx3xQfXFRyyX4A=; b=a1pDwle8XSTM
	+pwzwPZ5wueL54ogMHzaIsQzw9ELXkAcAy7NYS7mE0VekQHrb6tlQe/nfH/WxoNx
	QmzmOfZ7v+WYAn0iP4wHBtIoRGFgO9bnxfeQkr5aRTaTp4PM16jpVqyWD6LZYi8P
	EC8cf3tEY+O76Ti1GFoxWOBfDe/WaAV/gnkaVI/AF8MJqRlqxizWHnf+apxYWI8F
	D03BZ8bwhRMOYXGVe+3KsAleuONeX7QE1LiqADGeAERFocq5Gg3lDWDRW+NHOpAR
	L6eJEU4crRg1I2meiqYmGnnljTx7TMGbdskFFNFBHuKafIjkJRHcbGVTJ7rAMSbo
	zCrrblLcwg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eyx350ea2-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:09:32 -0700 (PDT)
Received: from twshared90881.15.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 24 Jun 2026 17:09:26 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 8AEAA23C452C1; Wed, 24 Jun 2026 10:09:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 5/5] block: validate user space vectors during extraction
Date: Wed, 24 Jun 2026 10:09:05 -0700
Message-ID: <20260624170905.3972095-6-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624170905.3972095-1-kbusch@meta.com>
References: <20260624170905.3972095-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDE0MyBTYWx0ZWRfX9xEQtEyEuwvR
 GpC96aRwEwax2piz3oFaYEQ5K2nNuMTALnvNts7hT/Z8XOE50CIWOPVMETRuuj8Pbintg1oabUY
 Y4E8+0dsTwoutZ7zqyzu7UsztXCIeks=
X-Proofpoint-GUID: z2nNdsMz5EfgprsEtS_DFIvsUVpm6CKw
X-Proofpoint-ORIG-GUID: z2nNdsMz5EfgprsEtS_DFIvsUVpm6CKw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDE0MyBTYWx0ZWRfXzWXwTH7rEdZ6
 hWPDrdhs/mu7jlUdkOlZhtXiQdnV6fH/g308WKMgusDdOCbY8LP3VhNv6/MQMsayMkQtO2Jd8bI
 B6Y2hZqAFFLljSIkwcc8b2wdLTDou9tdW2ghiQ8pLYYPEz7ET+e5mkkmD7rfA/elqAbqrxPdz37
 YRpNWRM58DEWKTyLlT2c7v46bk1wm+fN32fhc/sWfh1lzz+wGRslgwT0F1uUsP4cfrXKjIpXPtV
 VTlkqtubnVvQnUEmgxCiusP9zzcVuAyMmnJKv/SHUPi83DudpWml+eKZiSYju4yCSEW1t495Nek
 deFdSnj9pDcLiueALXs+HX41KkDef41xOs+YsgVC+auy+B1FLkQatlR2hGTbAkfAaGjw8raZ1/w
 OUi/0X6kA34Zu2BK/hQAWEKUeUDrTQ==
X-Authority-Analysis: v=2.4 cv=FqI1OWrq c=1 sm=1 tr=0 ts=6a3c0f4c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=VwQbUJbxAAAA:8 a=Hx0Vx7WpTRxxbsLxYwoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_03,2026-06-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The bio-based drivers don't necessarily check the alignment split, and
stacking block drivers don't always handle a misalignment detected after
submitting the bio. Validate user vectors against the device's
dma_alignment as the bio is built from the iov_iter, rejecting
misaligned early with -EINVAL.

Cc: stable@vger.kernel.org
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio.c          | 56 +++++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c      |  2 +-
 block/fops.c         |  2 +-
 fs/iomap/direct-io.c |  1 +
 include/linux/bio.h  |  2 +-
 include/linux/uio.h  | 10 +++++++-
 lib/iov_iter.c       |  9 ++++++-
 7 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f2a5f4d0a9672..faad41a72ac77 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1220,10 +1220,45 @@ static int bio_iov_iter_align_down(struct bio *bi=
o, struct iov_iter *iter,
 	return 0;
 }
=20
+#ifdef CONFIG_DEBUG_KERNEL
+static inline bool bio_iov_bvec_aligned(const struct bio *bio,
+					unsigned mem_align_mask)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+
+	/*
+	 * Correct callers never break the alignment requirements, so this
+	 * exhaustive check is only paid for in debug builds.
+	 */
+	for_each_mp_bvec(bv, bio->bi_io_vec, iter, bio->bi_iter)
+		if ((bv.bv_offset | bv.bv_len) & mem_align_mask)
+			return false;
+	return true;
+}
+#else
+static inline bool bio_iov_bvec_aligned(const struct bio *bio,
+					unsigned mem_align_mask)
+{
+	/*
+	 * We forward the bio_vec as-is, so ITER_BVEC callers must provide
+	 * segments already aligned to the device's DMA alignment. The only
+	 * unchecked user-controllable offset that reaches here is an io_uring
+	 * registered buffer where just the first segment can be unaligned
+	 * (the rest is virtually contiguous), so checking only that one is
+	 * sufficient to know if the entire vector is valid.
+	 */
+	return !(mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
+							mem_align_mask);
+}
+#endif
+
 /**
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
  * @iter: iov iterator describing the region to be added
+ * @mem_align_mask: the mask the source address and length must be align=
ed to,
+ *	0 for no requirement
  * @len_align_mask: the mask to align the total size to, 0 for any lengt=
h
  *
  * This takes either an iterator pointing to user memory, or one pointin=
g to
@@ -1242,7 +1277,7 @@ static int bio_iov_iter_align_down(struct bio *bio,=
 struct iov_iter *iter,
  * is returned only if 0 pages could be pinned.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-			   unsigned len_align_mask)
+			   unsigned mem_align_mask, unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags =3D 0;
=20
@@ -1251,6 +1286,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
 iov_iter *iter,
=20
 	if (iov_iter_is_bvec(iter)) {
 		bio_iov_bvec_set(bio, iter);
+
+		if (!bio_iov_bvec_aligned(bio, mem_align_mask))
+			return -EINVAL;
+
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
@@ -1265,8 +1304,19 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
 iov_iter *iter,
=20
 		ret =3D iov_iter_extract_bvecs(iter, bio->bi_io_vec,
 				BIO_MAX_SIZE - bio->bi_iter.bi_size,
-				&bio->bi_vcnt, bio->bi_max_vecs, flags);
+				&bio->bi_vcnt, bio->bi_max_vecs,
+				mem_align_mask, flags);
 		if (ret <=3D 0) {
+			/*
+			 * A misaligned vector fails the whole I/O.  Release any
+			 * pages pinned by earlier iterations before returning
+			 * since this bio won't be submitted to release them.
+			 */
+			if (ret =3D=3D -EINVAL) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_PAGE_PINNED);
+				bio->bi_vcnt =3D 0;
+			}
 			if (!bio->bi_vcnt)
 				return ret;
 			break;
@@ -1377,7 +1427,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio=
, struct iov_iter *iter,
 		ssize_t ret;
=20
 		ret =3D iov_iter_extract_bvecs(iter, bio->bi_io_vec + 1, len,
-				&bio->bi_vcnt, bio->bi_max_vecs - 1, 0);
+				&bio->bi_vcnt, bio->bi_max_vecs - 1, 0, 0);
 		if (ret <=3D 0) {
 			if (!bio->bi_vcnt) {
 				folio_put(folio);
diff --git a/block/blk-map.c b/block/blk-map.c
index 768549f19f97e..c9535efe1a913 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -274,7 +274,7 @@ static int bio_map_user_iov(struct request *rq, struc=
t iov_iter *iter,
 	 * No alignment requirements on our part to support arbitrary
 	 * passthrough commands.
 	 */
-	ret =3D bio_iov_iter_get_pages(bio, iter, 0);
+	ret =3D bio_iov_iter_get_pages(bio, iter, 0, 0);
 	if (ret)
 		goto out_put;
 	ret =3D blk_rq_append_bio(rq, bio);
diff --git a/block/fops.c b/block/fops.c
index 0098a90a956e1..e519d7f43b310 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -46,7 +46,7 @@ static bool blkdev_dio_invalid(struct block_device *bde=
v, struct kiocb *iocb,
 static inline int blkdev_iov_iter_get_pages(struct bio *bio,
 		struct iov_iter *iter, struct block_device *bdev)
 {
-	return bio_iov_iter_get_pages(bio, iter,
+	return bio_iov_iter_get_pages(bio, iter, bdev_dma_alignment(bdev),
 			bdev_logical_block_size(bdev) - 1);
 }
=20
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b485e3b191daf..ff458aa12ae29 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -358,6 +358,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_it=
er *iter,
 				iomap_max_bio_size(&iter->iomap), alignment);
 	else
 		ret =3D bio_iov_iter_get_pages(bio, dio->submit.iter,
+					     bdev_dma_alignment(bio->bi_bdev),
 					     alignment - 1);
 	if (unlikely(ret))
 		goto out_put_bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f5..ce34ea49ef358 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -477,7 +477,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t =
sector, void *data,
 		size_t len, enum req_op op);
=20
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-		unsigned len_align_mask);
+		unsigned mem_align_mask, unsigned len_align_mask);
=20
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index a9bc5b3067e32..fe2e985d74d24 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -389,9 +389,17 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i, s=
truct page ***pages,
 			       size_t maxsize, unsigned int maxpages,
 			       iov_iter_extraction_t extraction_flags,
 			       size_t *offset0);
+/*
+ * Block-layer consumers (e.g. bio_iov_iter_get_pages()) require that th=
e
+ * segments of an ITER_BVEC iterator are already aligned to the target d=
evice's
+ * DMA alignment, and forward them as-is.  In-kernel users that build th=
eir own
+ * bvecs must not create sub-aligned segments; iov_iter_extract_bvecs() =
enforces
+ * the same for the segments it extracts via @mem_align_mask.
+ */
 ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv=
,
 		size_t max_size, unsigned short *nr_vecs,
-		unsigned short max_vecs, iov_iter_extraction_t extraction_flags);
+		unsigned short max_vecs, unsigned mem_align_mask,
+		iov_iter_extraction_t extraction_flags);
=20
 /**
  * iov_iter_extract_will_pin - Indicate how pages from the iterator will=
 be retained
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 273919b161617..c343075951ded 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1886,6 +1886,8 @@ static unsigned int get_contig_folio_len(struct pag=
e **pages,
  * @max_size:	maximum size to extract from @iter
  * @nr_vecs:	number of vectors in @bv (on in and output)
  * @max_vecs:	maximum vectors in @bv, including those filled before call=
ing
+ * @mem_align_mask:	reject with -EINVAL if the source address or
+ *		length is not aligned to this mask
  * @extraction_flags: flags to qualify request
  *
  * Like iov_iter_extract_pages(), but returns physically contiguous rang=
es
@@ -1897,14 +1899,19 @@ static unsigned int get_contig_folio_len(struct p=
age **pages,
  */
 ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv=
,
 		size_t max_size, unsigned short *nr_vecs,
-		unsigned short max_vecs, iov_iter_extraction_t extraction_flags)
+		unsigned short max_vecs, unsigned mem_align_mask,
+		iov_iter_extraction_t extraction_flags)
 {
+	unsigned long start =3D (unsigned long)iter_iov_addr(iter);
 	unsigned short entries_left =3D max_vecs - *nr_vecs;
 	unsigned short nr_pages, i =3D 0;
 	size_t left, offset, len;
 	struct page **pages;
 	ssize_t size;
=20
+	if ((start | iter_iov_len(iter)) & mem_align_mask)
+		return -EINVAL;
+
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far a=
s
 	 * possible so that we can start filling biovecs from the beginning
--=20
2.53.0-Meta

