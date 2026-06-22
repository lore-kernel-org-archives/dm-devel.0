Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADD8341065
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150194; cv=none; b=qURUnfMk9FI4ZNdClNvfpExucwtXf7jS2ikxdk/ZZg9YASLdBl2qToGf0rR08qIabOPCzdjAbMASi7z12wADFqdlyLc2BNamklEJCGV42qdhvz0qL6rRNnKVyfhrJRjgy/l2eY3NNq2orR9emjO3if/bKwJZfO5qJkJ307QEDUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150194; c=relaxed/simple;
	bh=i6XyfTKS0OC3DtGc4HnKa+aEtXtud1PYnmp4y37/BnI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucul4p/NxaRWl+ba9nKjIQggZEFKCf/fs/NflAben9Fi+e4qXx3ZS9xkKvzmTpzPX1HNLvZVY1wOf7bIm3hhVb9zs6kmcq6DQUeSygkoE68c/XI1tbjbuHodGrF+827yXxarLAbY96v5MgJKbmSEeoUpXd0iyTYLpa7MwlZaBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=p/PNwBfP; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="p/PNwBfP"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MHVU5D2357964
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=eHPTl4shIvkRyyHdVGqO++Nc71dmiBDeeS+bTk7Mqww=; b=p/PNwBfPMf/s
	PKuTuAlMQ0OjWgur5CgHB8b8NMPahCJ1pdP8gZ7SEgOrCOgCOCmKSvV4Vi1uatm3
	XJPfE8ucx9jEOvOXHcRLSRL6IHYnMMuSEb7bfA2giJytRyM/VUaGqcl+Q65iSBDs
	y4oV5ASHaWRByGJdTB9UPxSOeSPJbFB+2X2u1OgbK+MrXJMQ1lMbDLunDPYOsAaw
	g0vlrR/Zkaljw/aFa8dhpJD7bPeUdNkjq6i9ey4a89WpOZw3Ae85HQ5u+yvdsYEP
	ZFRDDsFyVIwo2h4Jbn054JOCVncFgixh0dwC2Sjowc11TP8CZ6mxIQj3/rYF8QXe
	skoT04RqAQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4excgdrh08-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:11 -0700 (PDT)
Received: from twshared4973.01.snb2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 22 Jun 2026 17:43:02 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 290C323A15DE8; Mon, 22 Jun 2026 10:42:47 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCHv2 6/6] block: validate user space vectors during extraction
Date: Mon, 22 Jun 2026 10:42:41 -0700
Message-ID: <20260622174241.2299563-7-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260622174241.2299563-1-kbusch@meta.com>
References: <20260622174241.2299563-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX5AHZom4fnUU2
 sclcdmwyMjijrHAb2xo/6Kfq2fjTr90zNlO0yMzM/kLeUJhpsUdBH5zwkEBkTOIESuaR9tvAYCu
 OEbdbUZ6LS91phxRVHR+sTxdpBHaA8s=
X-Proofpoint-ORIG-GUID: S4lKFzOfLYxfS-Fm6FBqHsnwXGGVWFbu
X-Proofpoint-GUID: S4lKFzOfLYxfS-Fm6FBqHsnwXGGVWFbu
X-Authority-Analysis: v=2.4 cv=GK841ONK c=1 sm=1 tr=0 ts=6a39742f cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=sJVWJGQxNneOVQlFS3cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX7ijVYnRsvHHL
 /VGbTnwtcWITZaz9mvcdRrR1hcnomJgvw8XNLVbCXnmLlTJ+z5zBhYc1EQxWzzQRt8mzOnP1PHw
 lanpIbfMM31ZmnfgNdDifFOApP24pFs7hSHiGDCnAMWH3azcY/Nt+QkP+jmf6RrsA5Ge+dM6ZRN
 YjqNrK6bHNN/3aFN6OS9bg3sS01/D88A+ed02REfT4lM+GTw1qfkkiJHKYAWSX/DtNg4pRr+FdD
 WIR6SK4Dx/dpuWsNhOeRYr+QvHnqpgzwHTNkRzKAywRHOsnxE1+Wl9U8Bpu6ihRlPy2avb6q06h
 NEQpONmxcQNU+pgHNPAR/x6o9piMh8Y18tDdRGS/xMrJviEfUVeAeJgQ2i7pIGB3Ht4PGFRwcud
 pjMMCnYQ5PjnTiaenunsm4/quAs6HkyZILE3R51nr+31q86yFE8y2DXPd7xkDNAKa58PkRkZvBt
 l1ej7gQW3LowdrNE/sQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_03,2026-06-22_01,2025-10-01_01

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
 block/bio.c          | 50 +++++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c      |  2 +-
 block/fops.c         |  1 +
 fs/iomap/direct-io.c |  1 +
 include/linux/bio.h  |  2 +-
 include/linux/uio.h  |  3 ++-
 lib/iov_iter.c       |  9 +++++++-
 7 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f2a5f4d0a9672..4360149d4eba2 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1220,10 +1220,39 @@ static int bio_iov_iter_align_down(struct bio *bi=
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
+	 * The vectors are owned and laid out by the caller; we only forward
+	 * them. Most callers are already aligned, but io_uring can place a
+	 * user chosen offset through a registered buffer, where only the first
+	 * vector may be unaligned.
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
@@ -1242,7 +1271,7 @@ static int bio_iov_iter_align_down(struct bio *bio,=
 struct iov_iter *iter,
  * is returned only if 0 pages could be pinned.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-			   unsigned len_align_mask)
+			   unsigned mem_align_mask, unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags =3D 0;
=20
@@ -1251,6 +1280,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
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
@@ -1265,8 +1298,19 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
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
@@ -1377,7 +1421,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio=
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
index b5c320da28123..84eeabd97e1f0 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -47,6 +47,7 @@ static inline int blkdev_iov_iter_get_pages(struct bio =
*bio,
 		struct iov_iter *iter, struct block_device *bdev)
 {
 	return bio_iov_iter_get_pages(bio, iter,
+			bdev_dma_alignment(bdev),
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
index a9bc5b3067e32..653dee76c0b33 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -391,7 +391,8 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i, st=
ruct page ***pages,
 			       size_t *offset0);
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
index 273919b161617..8d5ca3e38522a 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1886,6 +1886,8 @@ static unsigned int get_contig_folio_len(struct pag=
e **pages,
  * @max_size:	maximum size to extract from @iter
  * @nr_vecs:	number of vectors in @bv (on in and output)
  * @max_vecs:	maximum vectors in @bv, including those filled before call=
ing
+ * @mem_align_mask:	reject with -EINVAL if the source address or length =
is not
+ *		aligned to this mask
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
2.52.0

