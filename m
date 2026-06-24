Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3423DD533
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322603; cv=none; b=nBsqIzMRJ/PHoQVBdOc1zCA+sqFpVg/0KruzGXTcDG9D/0q+DZdSk5mG5Q6KXSsiMF5oMSofOflWueV8elD47UHTwCPNfjcs26UeAyVQGp86XQu/bbdzeG5DHHLN2TXll+sqe8GElWNgapu9DiVJmpwTYWaPB6W6YocK6sj6jn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322603; c=relaxed/simple;
	bh=md82v5nTc8XTnpQSe3fblUv/07h/vGTvQ6G3iw0BEx0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hm9CnFXp9qdVURLrWGMxEIPvyvVsxKPyMgrSMIUvKaDpm2ONs9WoLSwHNoSlg6XsiMET3JDihftV9OCJ5x0dxx17xzMZ/8vEvjirI/XXQ46AfnmMWuLZcvXSOv6KMoAtqT2L0Ukoq0yqWSmsQKVHxECx1Fh6yLYlPR8y1lhQdws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cmyX4eQP; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cmyX4eQP"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65OEjKXR3972464
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:36:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=fGtIVAQu0NKnCIpvhzj3m60yyJwuBfFcp94oXfJymWE=; b=cmyX4eQP6ReH
	NQ5SeMPvA61OfSTXZwHqzdXbU9saZR9+flSfdE/8pXeCnRxU+np/6FnDH0iW3F8z
	3e6Pwsdcql8G2HzFxsBt0rcKU9fhbo36yojLhL9zrhsnZkR5CO67hjsu2VxfMC3E
	o11sdbucdECxksIFyT3Lou4ZEEWZYqd8Jj7ywo+KhRsidhaoQqp83aj60QeTV58f
	gVoFHDeeUSWgWmdn2UXgn2yetf3/I++Dc1P9on+OhVageGzCtcEKtMSQcf/yFh9p
	HNDzlbpHE7W6QR0TZ39V56MVvldP5I9Fj7lO7MueO2db09gq7i+nlChaz7BPQ0K1
	SE2dUkZRdg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eyumst2sw-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:36:39 -0700 (PDT)
Received: from twshared100448.16.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 24 Jun 2026 17:36:39 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0A15923C452B9; Wed, 24 Jun 2026 10:09:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCH v3 1/5] block: use blkdev_iov_iter_get_pages status for errors
Date: Wed, 24 Jun 2026 10:09:01 -0700
Message-ID: <20260624170905.3972095-2-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=eoTvCIpX c=1 sm=1 tr=0 ts=6a3c15a7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8 a=xbwd-4vLOdmjPcKMbXEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDE0NyBTYWx0ZWRfX8Es/YuLmK9p7
 iILL0/FXov86nSkjg1wNZ4tm6UWb44Y/1GMnhTUDgEvoam/pZ+Jg/Iu4rifnYCAMImgiUQaMgn0
 GcGht2fHAw63IFyKTa+jkz7bTDza+Uy06B9yIExMFLqKJdu0WhPr7f/RJl9GyieOOXdJ2xHlD2r
 uA18ejpsu8M/eZU1Njcn/0EyTBclMR8NnJ8RL4/RF31+j0zdsGAaf+V+eup/qeVYXL47rhrlYfR
 OhdBWaUDQAQ4y/vbKz+djV87hdqB58P9RCTmOZdGXBrczpNdjwFlulaY2i4xhC5sBiHth84AkCj
 xoEKgWAHuhwlcDsewJ7sEvKYWH627l5wVfqtowr4ZmiQs2x0RL7cOS1IznL4W9Jty9byXlRxfaX
 rR5uRDrJRvGadvdN5oESsgqfmdgkVg==
X-Proofpoint-ORIG-GUID: 1WdcWUq963BJoKK_x1IocS7Qq3uwO-nZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDE0NyBTYWx0ZWRfX2n6E2MT5joyf
 RV+Jq4e3TEVYb1ikgDQ9uxn+Uo4m1xwdUNFQ22qvc41J9VUD800R+ujPLVu0mpAZ/bw68DeH8na
 bNVT1VUOIdvKh9wrKsg/KOQdKoCYNJo=
X-Proofpoint-GUID: 1WdcWUq963BJoKK_x1IocS7Qq3uwO-nZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_03,2026-06-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

blkdev_iov_iter_get_pages() can return various error values, including
EIO, EFAULT, and ENOMEM. Set the actual reported status so user space
can know a little more on why an operation failed.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180dec..0827bb884d473 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -218,7 +218,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb,=
 struct iov_iter *iter,
=20
 		ret =3D blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret)) {
-			bio_endio_status(bio, BLK_STS_IOERR);
+			bio_endio_status(bio, errno_to_blk_status(ret));
 			break;
 		}
 		if (iocb->ki_flags & IOCB_NOWAIT) {
--=20
2.53.0-Meta

