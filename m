Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C49B340A6F
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150185; cv=none; b=h0UyM9rgl99kRkGRmk2XlLKDh77Iyj7dFh5ZQLM0ULxNzrTdEvt/zh5C+frkWjBRQDgw44MM6Ice266SuIyb6pbtoS5s77BOQ3yNYRYbKl/zAGQtxgivV9PGZgRMpA7n50/L5PdrsOLrSBcBaAuPqgFHhVb8gcLGUoOE6r4v+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150185; c=relaxed/simple;
	bh=4/QC7AaHBjIh7Azi1SmX+NbNRszt5GwbV38UBfa9yG4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajDlKLhbq7EKujHjrBx98rB5BaNgGJ9jic0FW6kK88PyYdf0JCHxxlb/+mF02McnHsDVeEq99cjXzOZPee38pk1PSCroyoNQI9xZn49hbyIm1XOF9zxep6J7uDXZXU7pB5u/ODKMR/PQcy3sYFRbFtBuNu4o5/ZWakTCCJteByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nf1yS0S6; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nf1yS0S6"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MHVXDR2338892
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=px0zdJjCphXpgaXYxO6RZVlv8ocaaxWmwBiPwnMxVmw=; b=nf1yS0S6PmvO
	Pcb05hAdHfTvu6NKXL4whLpDuKl+xNbNI+VIvAIrfeZSLS88xGWgWtgK/3w41YK/
	/6vu9FSUtEdxctZ4pXaAi4SQRh/DB5YtLuciqZy9SmH4j18GS0LOhMcaO0+mGNe/
	ac0Bn/ZQ4PhqtFqWJJ0YEO1T6DjEP7e4KCPN7Q0FB3aNkOTrWtNu9vD5zhcFIkDv
	j/hIGAEVm8cmDCTZG/GtoGOdMKQeT0Gz0f/8Bax/7WFhcVORb6H+HhIO4xd7nDPD
	OihNGOR2Ltum310b6hZ03WS0N36VnPDMZnIkmK9SzPUBDrH8wfB5j11DTTXMd+v0
	yf0vHwGs4w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ewrcd4x2y-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:03 -0700 (PDT)
Received: from twshared16795.04.snb2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 22 Jun 2026 17:43:01 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0D82323A15DDB; Mon, 22 Jun 2026 10:42:46 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/6] block: introduce bio_endio_errno helper
Date: Mon, 22 Jun 2026 10:42:36 -0700
Message-ID: <20260622174241.2299563-2-kbusch@meta.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX1KD3NsG2BNcb
 55qk/yF0pod0nWDwKSsqxgHRFKLmAovRvbeRrJhLBWwt30mn2YLBtoaQU7XCytEED/vBD+yn1zL
 Qm6a27ayOGeh0Wt6LIVq1oNKHyCwWAk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX5vDZjfL7ZIIU
 3SIgFw8yXEu0osSq9FFAx2KIyHdg47is+dslysE+YfGpLJTppMp/ilcCdBTeApCoG4WUPalewGo
 iIuVOUdF18GAG1ByiaqCvpq6bWL9cmYr7hKOgmAJQMGu5WMkpOfbXwv4dF5qORMc3y7/xkmuEx7
 EhsM7HhTluK+mxRGX5DZEvDOcEb5uZ39IUl34vpjIO7P46AgcIwNHcVTI+qU4VcjpPg0AvMu6I8
 vWn9v+AQFdQWq+2OAi0gBZnidSfqFzNwpQeij/PAgzMWfvjHG0ow9k+cgTRqA23N+3w3rG1y8tu
 XGsWzcs9SS7/yjuT7HdPu8I6xPcJwrOjlbJ3xrmxlIHtLZrA22WOYHNb+H3DFK1y1w5RRq60I4P
 5zx5F/FN9ty8okrUdufNhwXcmjjxtpRgf7z+1bknNJQIh23+3x3LyMJOgBILHz5T0RNP6ZHi5Lo
 MY8CQKxp7uhz0DmtSlg==
X-Authority-Analysis: v=2.4 cv=VZTH+lp9 c=1 sm=1 tr=0 ts=6a397427 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8 a=L_ds5RVfG79Zq-VKFV0A:9
X-Proofpoint-GUID: QtjO_vVUudvrUreXzbhZlTiWn80dnlt1
X-Proofpoint-ORIG-GUID: QtjO_vVUudvrUreXzbhZlTiWn80dnlt1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_03,2026-06-22_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

No functional change; purely introducing a convenience function.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-merge.c      | 4 ++--
 include/linux/blkdev.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ab1161ca69f1e..c93170f340977 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -122,7 +122,7 @@ struct bio *bio_submit_split_bioset(struct bio *bio, =
unsigned int split_sectors,
 	struct bio *split =3D bio_split(bio, split_sectors, GFP_NOIO, bs);
=20
 	if (IS_ERR(split)) {
-		bio_endio_status(bio, errno_to_blk_status(PTR_ERR(split)));
+		bio_endio_errno(bio, PTR_ERR(split));
 		return NULL;
 	}
=20
@@ -142,7 +142,7 @@ EXPORT_SYMBOL_GPL(bio_submit_split_bioset);
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
 	if (unlikely(split_sectors < 0)) {
-		bio_endio_status(bio, errno_to_blk_status(split_sectors));
+		bio_endio_errno(bio, split_sectors);
 		return NULL;
 	}
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95a..88e4bd88c3e28 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1047,6 +1047,11 @@ extern const char *blk_op_str(enum req_op op);
 int blk_status_to_errno(blk_status_t status);
 blk_status_t errno_to_blk_status(int errno);
=20
+static inline void bio_endio_errno(struct bio *bio, int errno)
+{
+	bio_endio_status(bio, errno_to_blk_status(errno));
+}
+
 /* only poll the hardware once, don't continue until a completion was fo=
und */
 #define BLK_POLL_ONESHOT		(1 << 0)
 int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int fl=
ags);
--=20
2.52.0

