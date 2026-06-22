Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFE929B781
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150187; cv=none; b=Gr1tXw78lkNS++JTBMkN3WlELbMqqPs1rqwAt2gJxc5MlaxJ1oQLYbj3qbJmHTQu5QoHzJ589p/EYNd9KaJmiNN7/SWwe2kxYldtrn5RL5F4YH2sO1C+zfYm+s+R2x0r8LWI5IcUTdDhFjCkSkfBzQUaOF0XFsEpcreG7dKsCOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150187; c=relaxed/simple;
	bh=HCwdxVfb5FLyCB74gfm8Qm2x0J04N7DthRxNKqz97TU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qweSQYqZOnuqLxH6E7N7QISj052XCCT13D0d2qMsUTrHduxROjDiFZY1SF/42Q3GhWNt3uYP/Se32DjMCzP/VxDOBaF03a/SI2G2+hNOC8yjjYXsKVjoM6PFWIMuyYvU4APz1MWyeW7Vs81vW7Q8e9TbjAqS1ZG37FcoV3Ifo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=X7xpyDQT; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="X7xpyDQT"
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MHVgL82279058
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=xVNj/MY3hnE3hUQyxKPtG7Nou5db4RL6KUNVunkMOfs=; b=X7xpyDQTMSlg
	3/BI9/BtFIJb+2/mzDFTJStI0ewBVH+fVxpt2/f/szVZtuI4261KcGW9Xt7Yqd7s
	n4AA80X7g5ScjkMkgvhO1Q7MU+rMbYIK7SklYWycxHj8QpooIQo7dDL5yY+tGHi8
	yMtaNyK9R/OkCYERY6R1DVfpOXD8IjMOQFyxf7/py2FIHY5yB/i4yKq9gkjdETdR
	43ob+KmY9s0ZNGViLs5hhJUicc7QMi9R+qhhWW+eYmc/j/9f94fZmvwShCRnPf6b
	UU6uhY5CxnzYI+alEGkPtoBp0U8E/gf8X6vket9pSHsoUBbxGSbHanIf19cFGd1v
	WEDqXTMKPA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4excejgfac-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:04 -0700 (PDT)
Received: from twshared50265.32.frc3.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 22 Jun 2026 17:43:02 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0932723A15DE6; Mon, 22 Jun 2026 10:42:47 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv2 5/6] zloop: set dma_alignment from the backing files for direct I/O
Date: Mon, 22 Jun 2026 10:42:40 -0700
Message-ID: <20260622174241.2299563-6-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX3jIUt+fN9w1B
 KergT07K/pLyFvNpAIQNFpOd1S1sKi88IIvT65ZE7wK1PpFMUg3ZiubRo8yQLIeuvFJmhp8P+wc
 4KaqCz1UUd+m/ymMYIIdxwFOsXzQdpRK2mdARw6wCr9pvYcbTuSMRPe6b7GI6NdlT/uc5JwbJA6
 0w1o5krZlrwnocUP0RGr8aMpO5YoyeOPr+mh5Mj03WO2kxjL8nFKfQOKD19szsbdOGSn0ipXRNZ
 TciN34BjQ6Zi/QOKZPt0oSQB1Yp/6rDBBLpf80TWoR/UiIaQMmof/LdOLqIinkNgZ+IMAtJQIX5
 5qig63svsU2oOpnmHc5jM39jgI7APGjJn3W4VogE6rJI2iCmt+EZBBEwHZdnLLxRM4YvKpDUkHl
 r7OAjBfBhtggvQo37426DApZEKDJk8ilqneNecuRWZHNBojq7T/8UtDxbDR1XqsqRHkwshr53Fo
 UAyW/6GSlyUkeqrlomg==
X-Authority-Analysis: v=2.4 cv=T7u8ifKQ c=1 sm=1 tr=0 ts=6a397428 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=VwQbUJbxAAAA:8 a=fUb_SF9hUEpPheumoKcA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX0wMXNrm/gMSL
 383ni0W8teHJ/OdeWzzKhdU6HKIfI7c/grQznoKLkrjxNc8qI3rTGtjU6Si4ZOF61JPXl/2nevf
 bSLdM+dDCVMdH7HpeiTFbcUZ2ioVJ/Y=
X-Proofpoint-ORIG-GUID: Py2cxlsz3NkX3w5ySJ1fL74l_sDL2FgW
X-Proofpoint-GUID: Py2cxlsz3NkX3w5ySJ1fL74l_sDL2FgW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_03,2026-06-22_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct I/O request's use pages handed to the backing files unchanged, so
the backing's DMA alignment requirement applies. Track dio_mem_align and
advertise it as the device's dma_alignment so we communicate proper
limits and misaligned I/O is rejected here instead of reaching the
backend.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/block/zloop.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 55eeb6aac0ea3..1149b817b5bc9 100644
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
@@ -1035,6 +1036,9 @@ static int zloop_get_block_size(struct zloop_device=
 *zlo,
 {
 	struct block_device *sb_bdev =3D zone->file->f_mapping->host->i_sb->s_b=
dev;
 	struct kstat st;
+	bool have_dioalign =3D !vfs_getattr(&zone->file->f_path, &st,
+					  STATX_DIOALIGN, 0) &&
+			     (st.result_mask & STATX_DIOALIGN);
=20
 	/*
 	 * If the FS block size is lower than or equal to 4K, use that as the
@@ -1044,14 +1048,25 @@ static int zloop_get_block_size(struct zloop_devi=
ce *zlo,
 	 */
 	if (file_inode(zone->file)->i_sb->s_blocksize <=3D SZ_4K)
 		zlo->block_size =3D file_inode(zone->file)->i_sb->s_blocksize;
-	else if (!vfs_getattr(&zone->file->f_path, &st, STATX_DIOALIGN, 0) &&
-		 (st.result_mask & STATX_DIOALIGN))
+	else if (have_dioalign)
 		zlo->block_size =3D st.dio_offset_align;
 	else if (sb_bdev)
 		zlo->block_size =3D bdev_physical_block_size(sb_bdev);
 	else
 		zlo->block_size =3D SECTOR_SIZE;
=20
+	/*
+	 * In direct I/O the request's pages are handed to the backing files
+	 * unchanged, so track their required memory alignment as a mask for
+	 * dma_alignment.
+	 */
+	if (have_dioalign)
+		zlo->dio_mem_align =3D st.dio_mem_align - 1;
+	else if (sb_bdev)
+		zlo->dio_mem_align =3D bdev_dma_alignment(sb_bdev);
+	else
+		zlo->dio_mem_align =3D SECTOR_SIZE - 1;
+
 	if (zlo->zone_capacity & ((zlo->block_size >> SECTOR_SHIFT) - 1)) {
 		pr_err("Zone capacity is not aligned to block size %u\n",
 		       zlo->block_size);
@@ -1279,6 +1294,9 @@ static int zloop_ctl_add(struct zloop_options *opts=
)
=20
 	lim.physical_block_size =3D zlo->block_size;
 	lim.logical_block_size =3D zlo->block_size;
+	/* Direct I/O hands the request's pages to the backing files unchanged.=
 */
+	if (!opts->buffered_io)
+		lim.dma_alignment =3D zlo->dio_mem_align;
 	if (zlo->zone_append)
 		lim.max_hw_zone_append_sectors =3D lim.max_hw_sectors;
 	lim.max_open_zones =3D zlo->max_open_zones;
--=20
2.52.0

