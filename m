Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D6F2F7EEE
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 20:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578284; cv=none; b=eT7VtVUpxdrppd9NATfSOcd40uwlXBahX0o7ySjvEA2aNeSjM3PmvVPMxRwd0iREzR1XhyQrqxlEoyySmfwS/U2YGmyjWZYr7PVeCEEPemQbq2F78Cx3eZEXKazWQCdb2tYDiDd8yWZW8fRIEzdR8mFRCONyQieJ1S4m060Jwf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578284; c=relaxed/simple;
	bh=6yoex7MT6I2MljP5YBkjutcnk1MhwdfVLtivr4rMEF0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDQQ0weBttUHOBwjzHh0ne6xmoCf7T/2nLUGx59Y8YULCndQto/IgkH5M9P5UeeJ+C9RMDB72Ev54P7cA9NE+DtEYdA7zzUgHJMVdvQcs/lledSFCrwyeoqocGzigWTOV5cEKBVnNDp0h+7cjqwHdVH/DzMRA7b3Q6FUQepzccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=U6UZaZ4+; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="U6UZaZ4+"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KJQXEv2644575
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=E8PCNizpCzRiU6yDjfTzKwif7soQiblzQTtqQGf8vCo=; b=U6UZaZ4+pTXo
	OOqYzxHnK2xEHNwEJEpXD+3+3ZQTIknKWIXF49ItnGGxwBZw6+Ftke3EZGqRmSgp
	eWSuoPsVo1z8U11/Lz+K8FzORZYMsYmu+zTD0Ztgq+F3Yr2gxpAF3QevKbHYrZDp
	Q/Pogwa9Yp1SUdzpyPzfdks+FteNuzUVLffJjMNYWKuP/Vap9ZHIcjFkuNK3bAlH
	vuQrdeBcKMcg/fAvBa+gt7X1I2aviqe4Ihc2Ccyjvr9m6X9ll/d+yKXGuL90kWm+
	L3n1EHZZpp0eZQHcucYt1BhexAtNomnHUcFjqSA//xJQDblUGYd5fU7U8Hco8q0E
	5b63DG6xFA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fg4t1c4u2-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:22 -0700 (PDT)
Received: from twshared21689.34.frc3.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 20:11:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1494825A0028E; Mon, 20 Jul 2026 13:11:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, Hannes Reinecke <hare@kernel.org>
Subject: [PATCH RESEND 4/5] zloop: set dma_alignment from the backing files for direct I/O
Date: Mon, 20 Jul 2026 13:10:56 -0700
Message-ID: <20260720201057.1862857-5-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX2Op17O8i9O3A
 ueBMObipomb0b7VWeP/49Y3IebIEI7WIfW1o7qtmUjQesP3vNZ1KXHtHXA7wh885Y56rFPBuFIf
 I4UawiztTFN91cf2KATd61n49yxHTxQCsIZTwfmU1xacMJEw1TUVeLfw6c7FUuOMDHzKlSWQUtK
 bLnhJsNnvrJLLVpQShRPrUuKZusFvyApA3YIAH++c254aCTEfixzadkzNZVLGmdppAyuklSE5tZ
 5qeSQI24KumH7LF0Ai/rsPNfC5eBrHwkTV/hK4A4SAwERFMYYUCG7XX2sKDS+KCCiD+jihIc30/
 iVXiDC3GslTFVXhms8HjelJt1sTR/UWL9u/i4fXtVIT7wYKzVZuSdNc+wvWlRvLxP6+Sg5aOSsf
 isDulXJoQMiMvw+yKw1/F9vSm/9Wqjp47PgeRwfqxHCUDAEykm8hqp6xve+OUC8oo4QhgCFxQxG
 g8RyfQU453U+cNBu7nA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX1/JktPJOP/DY
 OH1nIs5nSzQGq05MeBeSAYCuQSR1WtdrvtwA/DyYbpBIOdhaeRtXxNWxoqIbe6rFyVoYC0Xf/9B
 YRqc9FlSbI+mHJs5670TuzrG6HMOVpg=
X-Authority-Analysis: v=2.4 cv=FbgHAp+6 c=1 sm=1 tr=0 ts=6a5e80ea cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=mpKBkMY7X3-XUUdAYUMA:9
X-Proofpoint-ORIG-GUID: zTygc2opBbKyc_gvIebKaImHQceaKKaq
X-Proofpoint-GUID: zTygc2opBbKyc_gvIebKaImHQceaKKaq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_05,2026-07-20_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct I/O request's use pages handed to the backing files unchanged, so
the backing's DMA alignment requirement applies. Track dio_mem_align and
advertise it as the device's dma_alignment so we communicate proper
limits and misaligned I/O is rejected here instead of reaching the
backend.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/block/zloop.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 55eeb6aac0ea3..f97a20cfdb7ce 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -144,6 +144,7 @@ struct zloop_device {
 	unsigned int		nr_conv_zones;
 	unsigned int		max_open_zones;
 	unsigned int		block_size;
+	unsigned int		dio_mem_align;
=20
 	spinlock_t		open_zones_lock;
 	struct list_head	open_zones_lru_list;
@@ -1037,20 +1038,30 @@ static int zloop_get_block_size(struct zloop_devi=
ce *zlo,
 	struct kstat st;
=20
 	/*
-	 * If the FS block size is lower than or equal to 4K, use that as the
-	 * device block size. Otherwise, fallback to the FS direct IO alignment
-	 * constraint if that is provided, and to the FS underlying device
-	 * physical block size if the direct IO alignment is unknown.
+	 * Use the dio alignment of the file system if provided.  The incoming
+	 * request's bio_vec is forwarded to the backing file unchanged, so its
+	 * required memory alignment becomes the device's dma_alignment when
+	 * used for direct-io.
 	 */
-	if (file_inode(zone->file)->i_sb->s_blocksize <=3D SZ_4K)
-		zlo->block_size =3D file_inode(zone->file)->i_sb->s_blocksize;
-	else if (!vfs_getattr(&zone->file->f_path, &st, STATX_DIOALIGN, 0) &&
-		 (st.result_mask & STATX_DIOALIGN))
+	if (!vfs_getattr(&zone->file->f_path, &st, STATX_DIOALIGN, 0) &&
+	    (st.result_mask & STATX_DIOALIGN)) {
 		zlo->block_size =3D st.dio_offset_align;
-	else if (sb_bdev)
+		zlo->dio_mem_align =3D st.dio_mem_align - 1;
+	} else if (sb_bdev) {
 		zlo->block_size =3D bdev_physical_block_size(sb_bdev);
-	else
+		zlo->dio_mem_align =3D bdev_dma_alignment(sb_bdev);
+	} else {
 		zlo->block_size =3D SECTOR_SIZE;
+		zlo->dio_mem_align =3D SECTOR_SIZE - 1;
+	}
+
+	/*
+	 * Prefer the FS block size for the device block size when it is no
+	 * larger than 4K; otherwise keep the direct I/O / physical block size
+	 * selected above.
+	 */
+	if (file_inode(zone->file)->i_sb->s_blocksize <=3D SZ_4K)
+		zlo->block_size =3D file_inode(zone->file)->i_sb->s_blocksize;
=20
 	if (zlo->zone_capacity & ((zlo->block_size >> SECTOR_SHIFT) - 1)) {
 		pr_err("Zone capacity is not aligned to block size %u\n",
@@ -1279,6 +1290,10 @@ static int zloop_ctl_add(struct zloop_options *opt=
s)
=20
 	lim.physical_block_size =3D zlo->block_size;
 	lim.logical_block_size =3D zlo->block_size;
+	/* Direct I/O forwards the request pages to the backing files as-is. */
+	if (!opts->buffered_io)
+		lim.dma_alignment =3D max_t(unsigned int, zlo->dio_mem_align,
+					  SECTOR_SIZE - 1);
 	if (zlo->zone_append)
 		lim.max_hw_zone_append_sectors =3D lim.max_hw_sectors;
 	lim.max_open_zones =3D zlo->max_open_zones;
--=20
2.52.0

