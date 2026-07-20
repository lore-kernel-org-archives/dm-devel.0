Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13127263B
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 20:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578284; cv=none; b=jhcOoS6QDF7io54tKWuVuVTYq9DkOr8kMbCaVztbjM0IYZz+pNhcH/EUnpbW1haDhxazNYWREMylIlyDb2ji7/gE48bATkkz6o0TftkMX5DP3/OP/RA9957L/6SxReRvIr7zfmU102esO3o/3TmDUKXBIaF9Zs68tgWjcKByi0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578284; c=relaxed/simple;
	bh=w3Xa/iXqzZWiooILbdH/Rjm/ENI/F9TkzgM2t/CehlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBGTIP1gflxsn6VGnK9o9uQAN4m4dSj0pZWxK+YJPYqmZQlhisxjo5F0VsfPlEhvvZQ08mGqvywCVW4bF6ZPfkEMDHjGFYsS/HvebsWwV9SLGNS0+cGGvnwqD04OBYZ2UEgyMRXjz4gMtR/5skKlVnxbFRVHqI1/4UKonIwAAWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=meld+Cxw; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="meld+Cxw"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KJPa6A2812993
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=6IkMvZEDQC8Kyw2HxFcjW9YV77xNYp0pa980zCACESc=; b=meld+Cxw4Sft
	ROjZZBiHj/zqHlsx1v81YLehgeX4PxOlbyeZWLjI25bJLIQ6tBggtR7zhbckk18X
	FLTovdFm7eyi1VMijCtdfqyrbXOjKVz0+RFBMg0+q8hg0t7UlEqvSH1KCEsVdXLO
	SpnBwE3XjZ64jhsUlz1o5/i+yciCcUeygZRKVhX+Gi6hSmw2QfE3RGGvzxZS/4eC
	qCIHBtP9+bIUYnga4UPlK6zblhBFumoQqW5mirYeruIONdyrsguWzp5mFK2+ZEjs
	q3478xqZgxMthiSdRRDz91jVW5I6tLvM+ehz5XcQTAkssM5MuTMyd10cop1RCCfj
	jHaaebR66A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fg8sgbh44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:21 -0700 (PDT)
Received: from twshared19691.04.snb1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 20:11:21 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id C72C025A0028A; Mon, 20 Jul 2026 13:11:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, Hannes Reinecke <hare@kernel.org>
Subject: [PATCH RESEND 3/5] loop: set dma_alignment from the backing file for direct I/O
Date: Mon, 20 Jul 2026 13:10:55 -0700
Message-ID: <20260720201057.1862857-4-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260720201057.1862857-1-kbusch@meta.com>
References: <20260720201057.1862857-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=MKZQXsZl c=1 sm=1 tr=0 ts=6a5e80e9 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=crHB47gyY4rKiduisYu9:22 a=VwQbUJbxAAAA:8 a=w3YrK2sSALtTPwlh2GsA:9
X-Proofpoint-GUID: mRZqJJXnwM76RCKFQJq6U24BXlwvddn9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX6nA9Ptp5+rZe
 Py4LMZlSjY1hIYJg8xuFV14qnG9p7WGHbjPpdehFwP5tpsyucK5Ed8VoUTudGFYVaVgVfiF9dPi
 dSSgd/wkO0J/MiADqrbN15UBxNseOIs=
X-Proofpoint-ORIG-GUID: mRZqJJXnwM76RCKFQJq6U24BXlwvddn9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfXwcGC2DpZaLSr
 xADk08mDePToYf2bAU80W863XuAZv43qUhmJ4lPtlrn8+O0J8G/J0dvviYrSbP73ht1lUfBr4d2
 u/3HKbh2SRYr2Yq6SbKn7nga/X7QFkdthRFnyu00VpxqmMG9OcVQUPv3wM6lcFm7XTsUkc+437h
 /6nkBSEmnmJKUUpetpzBNtdezQpejPwf+ijEVEerTvnxfGxliSsY5fg17tZ3TzSQh0zHWq4Upsf
 1T4bpwKJxRn5g4p4dM0dNtkjqTg9qIhcdoUl7g0nGVhITrAL9LK00lpeETo13A/nkoR8U8eJ6YN
 8deFM65qDyR+/0lJtK9vK57T0Jvd0bSWLPKRJ34BVnA7cqwKWYvLyc7PVwoll1iBzyr5czYfPe6
 DF4EGAzZf6oisW7odEmwojqdfJ8ykq245bc6Mz3zVfi4qYNgBv9whSUf9T0HSqS2X0F4J5JwI0F
 iP1H3J7q8Z2iVDml0cQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_05,2026-07-20_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct I/O user pages are forwarded to the backing file unchanged, so
the backing's DMA alignment requirement applies to them. Track the
backing's dio_mem_align and advertise it as the loop device's
dma_alignment so we advertise proper limits and misaligned I/O is
rejected here instead of being dispatched to the backend.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/block/loop.c | 46 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 310de0463beb1..5fe61d542f8b7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -54,6 +54,7 @@ struct loop_device {
=20
 	struct file	*lo_backing_file;
 	unsigned int	lo_min_dio_size;
+	unsigned int	lo_dio_mem_align;
 	struct block_device *lo_device;
=20
 	gfp_t		old_gfp_mask;
@@ -447,26 +448,37 @@ static void loop_reread_partitions(struct loop_devi=
ce *lo)
 			__func__, lo->lo_number, lo->lo_file_name, rc);
 }
=20
-static unsigned int loop_query_min_dio_size(struct loop_device *lo)
+static void loop_update_dio_alignment(struct loop_device *lo)
 {
 	struct file *file =3D lo->lo_backing_file;
 	struct block_device *sb_bdev =3D file->f_mapping->host->i_sb->s_bdev;
 	struct kstat st;
=20
 	/*
-	 * Use the minimal dio alignment of the file system if provided.
+	 * Use the dio alignment of the file system if provided.  The incomoing
+	 * request's bio_vec is forwarded to the backing file unchanged, so its
+	 * required memory alignment becomes the device's dma_alignment when
+	 * used for direct-io.
 	 */
 	if (!vfs_getattr(&file->f_path, &st, STATX_DIOALIGN, 0) &&
-	    (st.result_mask & STATX_DIOALIGN))
-		return st.dio_offset_align;
+	    (st.result_mask & STATX_DIOALIGN)) {
+		lo->lo_min_dio_size =3D st.dio_offset_align;
+		lo->lo_dio_mem_align =3D st.dio_mem_align - 1;
+		return;
+	}
=20
 	/*
 	 * In a perfect world this wouldn't be needed, but as of Linux 6.13 onl=
y
 	 * a handful of file systems support the STATX_DIOALIGN flag.
 	 */
-	if (sb_bdev)
-		return bdev_logical_block_size(sb_bdev);
-	return SECTOR_SIZE;
+	if (sb_bdev) {
+		lo->lo_min_dio_size =3D bdev_logical_block_size(sb_bdev);
+		lo->lo_dio_mem_align =3D bdev_dma_alignment(sb_bdev);
+		return;
+	}
+
+	lo->lo_min_dio_size =3D SECTOR_SIZE;
+	lo->lo_dio_mem_align =3D SECTOR_SIZE - 1;
 }
=20
 static inline int is_loop_device(struct file *file)
@@ -509,7 +521,7 @@ static void loop_assign_backing_file(struct loop_devi=
ce *lo, struct file *file)
 			lo->old_gfp_mask & ~(__GFP_IO | __GFP_FS));
 	if (lo->lo_backing_file->f_flags & O_DIRECT)
 		lo->lo_flags |=3D LO_FLAGS_DIRECT_IO;
-	lo->lo_min_dio_size =3D loop_query_min_dio_size(lo);
+	loop_update_dio_alignment(lo);
 }
=20
 static int loop_check_backing_file(struct file *file)
@@ -940,6 +952,19 @@ static unsigned int loop_default_blocksize(struct lo=
op_device *lo)
 	return SECTOR_SIZE;
 }
=20
+static void loop_set_dma_limit(struct loop_device *lo, struct queue_limi=
ts *lim)
+{
+	/*
+	 * Direct I/O forwards the user pages to the backing file unchanged, so
+	 * track the backing's DMA alignment requirement as the mode is toggled=
.
+	 */
+	if (lo->lo_flags & LO_FLAGS_DIRECT_IO)
+		lim->dma_alignment =3D max_t(unsigned int, lo->lo_dio_mem_align,
+					   SECTOR_SIZE - 1);
+	else
+		lim->dma_alignment =3D SECTOR_SIZE - 1;
+}
+
 static void loop_update_limits(struct loop_device *lo, struct queue_limi=
ts *lim,
 		unsigned int bsize)
 {
@@ -961,6 +986,7 @@ static void loop_update_limits(struct loop_device *lo=
, struct queue_limits *lim,
 	lim->logical_block_size =3D bsize;
 	lim->physical_block_size =3D bsize;
 	lim->io_min =3D bsize;
+	loop_set_dma_limit(lo, lim);
 	lim->features &=3D ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_ROTATIONAL);
 	if (file->f_op->fsync && !(lo->lo_flags & LO_FLAGS_READ_ONLY))
 		lim->features |=3D BLK_FEAT_WRITE_CACHE;
@@ -1416,6 +1442,7 @@ static int loop_set_dio(struct loop_device *lo, uns=
igned long arg)
 {
 	bool use_dio =3D !!arg;
 	unsigned int memflags;
+	struct queue_limits lim;
=20
 	if (lo->lo_state !=3D Lo_bound)
 		return -ENXIO;
@@ -1434,6 +1461,9 @@ static int loop_set_dio(struct loop_device *lo, uns=
igned long arg)
 		lo->lo_flags |=3D LO_FLAGS_DIRECT_IO;
 	else
 		lo->lo_flags &=3D ~LO_FLAGS_DIRECT_IO;
+	lim =3D queue_limits_start_update(lo->lo_queue);
+	loop_set_dma_limit(lo, &lim);
+	queue_limits_commit_update(lo->lo_queue, &lim);
 	blk_mq_unfreeze_queue(lo->lo_queue, memflags);
 	return 0;
 }
--=20
2.52.0

