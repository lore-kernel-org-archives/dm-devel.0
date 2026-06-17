Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0102C1DE4F1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781739241; cv=none; b=kBD6/f8mosGww9L26+9Gh9zP3p6VoGkVKkBpYicH7JI6rjRhJSxFC6g2Da17lHJk3T8p1fSubE1yf7ubzsoAQ72GCEWFq1jNZ4Awkg7wWZKRhAZI9J8b2xobRgNDrgcWc9Qmf4myY+hyX6ZATlouN689wx4x5U68Vg557gA6jSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781739241; c=relaxed/simple;
	bh=bYGJHmHFIdg/vZp+bBJZjvaSuFW3cm1oJyzL7R50C2w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZYt8Drk0FGtSlzWLTSK55m2JgvPmFS/aH1z/7NI1wzMjjI3BGRkM5zYBCiVqS/cHgWkRxzAZxFX8Av1TCZZ8bBj2GZAjPdzXDOMKqzcaQFbqmw8w6ouqz1aXQgbPF+KUYo8DO0UzJv+c+zxWJ3hmVtDu0rw/TVPDU6m//yOirQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dFL2otj5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dFL2otj5"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HK0vT7981659
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 16:33:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=M8oj17OkIUhfmg6VbN8ApgSdYh1H4y5vkkOv0aGYNNU=; b=dFL2otj5cPi/
	cFzux+jvpGhB9xcXMoAy4jOlTY9E3ohTXgZ7fzCVnSiBeYmFhzlHnq77alP64aab
	L5hyUk1VxPNLQPXxO/B+IYcY5SMvw3WGcttOTqOEE/EaVlMnB/E7e9qC7ddQSmOq
	QHlQwmN6yfHzWWB0HS0+TeJTz2dbonCPe6nmmGICVWsJXUu4DcyzY4Nu5J23n4PQ
	tPpTk+0Mm7Vj7wK4BbkT3u3i4hTC3c3Tis8vk8ZRolj1eJPgAzBsKSnMp1+Tmfaw
	g1dyW5K45f0BCyKOb2v3/TpekvefZuFS+nOKHiZbONbyTvBWW86GnUATo8cthTWC
	VG8tJZ4EDQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4euegcr67j-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 16:33:59 -0700 (PDT)
Received: from twshared25719.01.snb2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 17 Jun 2026 23:33:57 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id E030723517B5B; Wed, 17 Jun 2026 16:32:35 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] block: validate user space vectors during extraction
Date: Wed, 17 Jun 2026 16:32:35 -0700
Message-ID: <20260617233235.1016063-2-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617233235.1016063-1-kbusch@meta.com>
References: <20260617233235.1016063-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: AL5Hr4UCBaPRWD6ejVEYNTK1kvFK_Xa2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDIyNSBTYWx0ZWRfX2I7DXIO6djxT
 TF21Qxr1JjpBdqaOhdi3VuQ19BWlIEAKPXjqjusC5rI/tFhfEP9p3rYMZOL8J8LKRtcF+EhlR+f
 qIadWqgG7oZRBNIFeDSzETjwH3yWy4s=
X-Authority-Analysis: v=2.4 cv=NpXhtcdJ c=1 sm=1 tr=0 ts=6a332ee7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=4h92JMTCafKA-fb_NiOh:22 a=VwQbUJbxAAAA:8 a=MFjv_cZ18IANV4BSG9cA:9
X-Proofpoint-ORIG-GUID: AL5Hr4UCBaPRWD6ejVEYNTK1kvFK_Xa2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDIyNSBTYWx0ZWRfX8Klcllw6RSTR
 3XEOjn2mOg9i9Z5Yloh2XFKiXzYS8GH9rmeFtC3aLXmQyoOLAJWAcYZhfHnAamvsC3QRyTfj8t9
 UMB/XeQhEn5RyP5R+mRdHQh7fu0YdGml+IdajeNtzD4EDcnZQl8VcNUeAfaErlbaje3WfAxwQgt
 8zDojQybNm4FseixlqIEkB0LcB6a124Bcx+dW8GJyUn73zHcMkd2zzE0VYa8h1NP90epbk6dwd/
 SvwU/K+dQFOXcqNExrD/y3PqxFsXJpi3sYgpY07fLYxJACOf2hgXZCnYPdyDWytiEgoBB4lLjIh
 Z6kq0ZEfcdmkUbkan8W9Pke5c0QsiGxHe6j8DDvBOG7zWoS9Oxt7SA15SCxewXhw5wRJMsjO0kn
 K4qKtYQIcT7BXD0zPj4VByxaDmUTJFcYSq56UUR5tco9T8ITCplivQF4FV2l5GXO7Xz4jXpCF1t
 VQ1er/61/3kqFRtypfg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The blk-mq based drivers have every incoming bio validated by an
unconditional __bio_split_to_limits() call, which rejects any segment
that does not meet the queue's dma_alignment with BLK_STS_INVAL, so they
only see viable requests. A bio-based driver, though, receives a bio
whose memory alignment has not been checked.

Misalignment is possible for vectors supplied from user space direct-io.
When a stacking driver forwards a misaligned bio to a member device,
that member may reject it with BLK_STS_INVAL if the lower level attempts
to split the bio to the queue limits. The stacker tends to mishandle the
error: dm-raid1 may degrade an otherwise healthy array.

Alternatively, some lower level bio based block drivers never attempt to
split their bio and assume the one received is viable. If it's
unaligned, block devices like brd and pmem may corrupt their data as
they have a strong dependency on sector size aligned bvecs.

Validate the source against the device's dma_alignment where the bio is
built from the iov_iter, rejecting misaligned I/O with -EINVAL before it
is submitted. This is done opportunistically in a path that already pins
the pages, so no additional io vector walking is needed.

The required alignment is supplied by the callers as vec_align_mask
(bdev_dma_alignment()); passthrough and the bounce path pass 0 as they
have no such requirement. If a vector is misaligned while building the
bio, any pages already pinned into that bio are released before
returning.

Cc: stable@vger.kernel.org
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio.c          | 19 ++++++++++++++++---
 block/blk-map.c      |  2 +-
 block/fops.c         |  3 ++-
 fs/iomap/direct-io.c |  3 ++-
 include/linux/bio.h  |  2 +-
 include/linux/uio.h  |  3 ++-
 lib/iov_iter.c       |  9 ++++++++-
 7 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f2a5f4d0a9672..1bd7da889e069 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1242,7 +1242,7 @@ static int bio_iov_iter_align_down(struct bio *bio,=
 struct iov_iter *iter,
  * is returned only if 0 pages could be pinned.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-			   unsigned len_align_mask)
+			   unsigned len_align_mask, unsigned vec_align_mask)
 {
 	iov_iter_extraction_t flags =3D 0;
=20
@@ -1251,6 +1251,11 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
 iov_iter *iter,
=20
 	if (iov_iter_is_bvec(iter)) {
 		bio_iov_bvec_set(bio, iter);
+
+		if (mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
+							vec_align_mask)
+			return -EINVAL;
+
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
@@ -1265,8 +1270,16 @@ int bio_iov_iter_get_pages(struct bio *bio, struct=
 iov_iter *iter,
=20
 		ret =3D iov_iter_extract_bvecs(iter, bio->bi_io_vec,
 				BIO_MAX_SIZE - bio->bi_iter.bi_size,
-				&bio->bi_vcnt, bio->bi_max_vecs, flags);
+				&bio->bi_vcnt, bio->bi_max_vecs,
+				vec_align_mask, flags);
 		if (ret <=3D 0) {
+			if (ret =3D=3D -EINVAL) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_PAGE_PINNED);
+				bio->bi_iter.bi_size =3D 0;
+				bio->bi_vcnt =3D 0;
+				return ret;
+			}
 			if (!bio->bi_vcnt)
 				return ret;
 			break;
@@ -1377,7 +1390,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio=
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
index 15783a6180dec..928ba9be170cd 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -47,7 +47,8 @@ static inline int blkdev_iov_iter_get_pages(struct bio =
*bio,
 		struct iov_iter *iter, struct block_device *bdev)
 {
 	return bio_iov_iter_get_pages(bio, iter,
-			bdev_logical_block_size(bdev) - 1);
+			bdev_logical_block_size(bdev) - 1,
+			bdev_dma_alignment(bdev));
 }
=20
 #define DIO_INLINE_BIO_VECS 4
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b485e3b191daf..645a4e9cd25f9 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -358,7 +358,8 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_it=
er *iter,
 				iomap_max_bio_size(&iter->iomap), alignment);
 	else
 		ret =3D bio_iov_iter_get_pages(bio, dio->submit.iter,
-					     alignment - 1);
+					     alignment - 1,
+					     bdev_dma_alignment(bio->bi_bdev));
 	if (unlikely(ret))
 		goto out_put_bio;
 	ret =3D bio->bi_iter.bi_size;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f5..13be7edb524fc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -477,7 +477,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t =
sector, void *data,
 		size_t len, enum req_op op);
=20
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-		unsigned len_align_mask);
+		unsigned len_align_mask, unsigned vec_align_mask);
=20
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index a9bc5b3067e32..be8b2625b376a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -391,7 +391,8 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i, st=
ruct page ***pages,
 			       size_t *offset0);
 ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv=
,
 		size_t max_size, unsigned short *nr_vecs,
-		unsigned short max_vecs, iov_iter_extraction_t extraction_flags);
+		unsigned short max_vecs, unsigned align_mask,
+		iov_iter_extraction_t extraction_flags);
=20
 /**
  * iov_iter_extract_will_pin - Indicate how pages from the iterator will=
 be retained
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 273919b161617..ccd5b49f6b78d 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1886,6 +1886,8 @@ static unsigned int get_contig_folio_len(struct pag=
e **pages,
  * @max_size:	maximum size to extract from @iter
  * @nr_vecs:	number of vectors in @bv (on in and output)
  * @max_vecs:	maximum vectors in @bv, including those filled before call=
ing
+ * @align_mask:	reject with -EINVAL if the source address or length is n=
ot
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
+		unsigned short max_vecs, unsigned align_mask,
+		iov_iter_extraction_t extraction_flags)
 {
+	unsigned long start =3D (unsigned long)iter_iov_addr(iter);
 	unsigned short entries_left =3D max_vecs - *nr_vecs;
 	unsigned short nr_pages, i =3D 0;
 	size_t left, offset, len;
 	struct page **pages;
 	ssize_t size;
=20
+	if ((start | iter_iov_len(iter)) & align_mask)
+		return -EINVAL;
+
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far a=
s
 	 * possible so that we can start filling biovecs from the beginning
--=20
2.52.0

