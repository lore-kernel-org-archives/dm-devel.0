Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A88340DB8
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322037; cv=none; b=o0IBYFv4zY9IiJCrHk0DM/GZRW7rkYCki89FTCRoXE6ROOrfSThqu87eX7vCeXg9/fbcjuyA8QD/a5r43OJfY3mjMYqrLtPcAvbAvcErLfPJfVDE6kDZRXXOegz35ZvmkQxOXJbwQdv6R5P0j5nolRkNQQIK4KwKxMlSbqDLmM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322037; c=relaxed/simple;
	bh=Fh9BHVIGfQ/RpNprhH8RMfglcQOp0BiJIvJASEH71yg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fhjM3kpKJiyDrV2z+GOosMlDAjdDCwGkun2/0lGdk+IeSMrfqu7DIk6gwjKdC3AxCTut1oFqfr6hpqOrdv73qJ7/upzr+dfhldaa77Z4/AuW0fVmxlmgVPZWJGxbEDXvx7vtEHVqHITX5h1VzxPFiqazpXiq6mWBP/D+nlYt5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JR9XLhQ3; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JR9XLhQ3"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 65OEmHIY4026006
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:27:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=iio3hccJh+B4s2gOQB4736zZXTM3PJ1TkZjIqDtxVOQ=; b=JR9XLhQ3ntPR
	+ZhJCJTDh1AK3er5sJznNKZ4mMKekiL/8hRfqJhLYkXyHRU0butMdjmAfArwh2YO
	6+mKe628A4UFMPBEJGYxsGpUEb9kKs1dpVvlRKajp1NAWyEfizGy4aRHckE00hm7
	+EVInK24t/tw5sGxYwvOmMX9Q9eeiSVUKje/EHF2WmFSKceLAD/Tiw1zhUhYFc+Q
	nRREkZItJmBhKi2fUHwClKN3PD/LHbdNKvsWmG1XwDO14z3/HEst2nYnPXQWWNIz
	FKYC+Kx6UxCDCrYd9/ogTeIWW174ywLdFJJZvOz+Gm08M6xe5/n9H2raouZQ1Xx7
	g4Ud2WGdNg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4eyudja6q9-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:27:13 -0700 (PDT)
Received: from twshared11639.02.snb2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 24 Jun 2026 17:27:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 4863A23C452BD; Wed, 24 Jun 2026 10:09:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCH v3 3/5] loop: set dma_alignment from the backing file for direct I/O
Date: Wed, 24 Jun 2026 10:09:03 -0700
Message-ID: <20260624170905.3972095-4-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDE0NiBTYWx0ZWRfX846lQulr6RXt
 NSQDBdve2Sp4V+ILGIJgjHtHU25o06V3Oi7jRsET3dg/quRhzJO7S/yvg722cTt2RGEs0Ud/YI8
 4PhLpbTZCsC6daXO8qX6qyIiq7OOWW6LS6j/E76OMcobA2kYesJYS1iAaAmxvekT/ax1dc+D0OW
 OkvBnMaDrA1P3rsC8kozk0MPaBCz0JyIuCqWgMCjKQv6X1Whz3nlKcc1nXVkOcByD5a7TEVNOgp
 eor3tWjBSR+14pJZ582DJjcAavyMJA6QBRTevZxFhKCYU9kSodbAaPinku7xRK8cxGl5ZIirdfA
 2cM+JOv/dnyRql9xN8YX+Ntatg+Wu8mkFEuMADoLxLOtJ7OhBWbakCnARa4nUPmEwLc+DdGqhXv
 Bv+29QFLcx9SzLojrw1dR9vI9OTT+A==
X-Proofpoint-ORIG-GUID: VK_ilMKhEEcA4yfTxqHlDYRTpQ8pueWB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDE0NiBTYWx0ZWRfX4hgMBhdR6VRs
 qi5e0Ev4+Nc/Az5jYRE6cuXooSMz+pOnr26i/Z0QiQrCmZqjrQ3Bze6TYHf/9G79dJivM8I/Yke
 CljZtO4WAuMx+UWgeIk8uHy0VCTfsLo=
X-Authority-Analysis: v=2.4 cv=K/8S2SWI c=1 sm=1 tr=0 ts=6a3c1371 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VwQbUJbxAAAA:8 a=w3YrK2sSALtTPwlh2GsA:9
X-Proofpoint-GUID: VK_ilMKhEEcA4yfTxqHlDYRTpQ8pueWB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_03,2026-06-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct I/O user pages are forwarded to the backing file unchanged, so
the backing's DMA alignment requirement applies to them. Track the
backing file's dio_mem_align and advertise it as the loop device's
dma_alignment if it is larger than the default so we advertise proper
limits and misaligned I/O is rejected early instead of being dispatched
to the backend.

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
2.53.0-Meta

