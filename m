Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E27C3B38B8
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 20:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578285; cv=none; b=ALHUyyq2uHstXyCKp1zh52VzjLwLoz5DKAAmgNgfdGjTr4Tr9BEX1AHvXbEa2GovfvCJ410zgnPtSIjIcWdqefgQTubNFnlmoVPwNTmi2FT1YOc9YWQuC1ia5+9mvJ5GGBW8LkLicP9MXLuqLd7q143pyg7V9iaGJXOq2DIYSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578285; c=relaxed/simple;
	bh=O4AioAC3G8DsznNvnEKnfiaTjLEuHncknSgivw2LW3E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7Uzt6d2q0W1jAmazUQPQLergrsx/LJTHfI5vwLIS77S9ikzx5+xRP2wZuVOjYGirNB6/LTW7c8cpg1OZH2+BNnM7E54N44HqDaC3cP1hDHo7FUQ4qToFSCshFhxDu1sO3VcjuejJUcoy0OAxriiQDJ66FCewWga8ILc4fH62MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=QEGRCkGY; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="QEGRCkGY"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KJQXEx2644575
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=mz92xofgircHI4YMm+iPtuHHV6ROQ/EWWkRXCM1MtNE=; b=QEGRCkGYmgRU
	7pA/egdJFGGAFh6gZt9g1GBwsv9+pJJtG000LQMA6evCeSK9PAvFoeI8vA7Qid65
	Rkq8qbIdiAkG/sC7GLaTciELVQjh21IBWnsvxEP4eTahwVqSP1rfWHsubFfegij3
	dcYIYtMTCdPNIwil4beBjUwhKIlyKRia6nvSIf1EHblE4gc/C6cTJwxd5QmxaD77
	x+u00FxbpoFNl6eMMECULp1EznAXN0/rzOw6YyNvaA9qS4hKGR20idlz2iDMqrtz
	xDwHCXaIPFG3K03xCGGB+YAbKrZ2M2Wwq4luG5lp4CwgyH3I79HLCe77eAwd1GHa
	6zXrWXkvqA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fg4t1c4u2-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:23 -0700 (PDT)
Received: from twshared132622.14.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 20:11:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 9C51625A00285; Mon, 20 Jul 2026 13:11:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, Hannes Reinecke <hare@kernel.org>
Subject: [PATCH RESEND 2/5] block: fix dio leak on metadata mapping error
Date: Mon, 20 Jul 2026 13:10:54 -0700
Message-ID: <20260720201057.1862857-3-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX1xV6k6EnOWF6
 6x+Svei5FMVbb7AgmOvqFIrmMUpGgAv41uQ5hcyFs2L7bVPVgjXjbiiBCj9DkTElK4cIpLCPFhf
 mIbwyHpRMuStfIJ1Nn/NQwZXdo8xu9cBpbyKaK/GIx/cM39R+2V7bZJSt1qJqhvEgYVg7nzkBh+
 vkoahrczp6yHVXuVEunactwL1g0+21PlylT0tSAX2wWJZKxg/7WEdQ7Dl056fYBfK7uMnZdigXR
 emGrquTUdL/xmqsq/6vTYiYJ1OXO40xKkhXYCgJjqN+p+Bro4MQXMC9UiVY9JERxPPzLdfwhPpO
 jr4wkLDxDbZQvatwK5Dwjj3te1b8fueVwew4rkNTHcUV9qqS0TyYjxZX4P9oZO2d08tGSRjEOXh
 5J6knuBsA4EWPa7Wl0fBeMHq5qzkWaJP9jDH0axoe0PBaLBmcipLOHse5Q588U/+oWE2tLvPDde
 5+57fkLPAK+W0Gj9MAQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX1jfRwKVZwX/F
 ov1LPiEYKYYl9I9ctORaME8Aku2RrO1RbAaibhOXy/aLuCRFs4MfJHc+4YlO+9P/V2jThgMfzx6
 mEoYAIptyY6BMePfNOWIqlaKAFQ9hDo=
X-Authority-Analysis: v=2.4 cv=FbgHAp+6 c=1 sm=1 tr=0 ts=6a5e80eb cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=hePQWg9M9jSv14wK35YA:9
X-Proofpoint-ORIG-GUID: sYxiStlE4U-MbDqK7_5hL9S1mrVs3ZXn
X-Proofpoint-GUID: sYxiStlE4U-MbDqK7_5hL9S1mrVs3ZXn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_05,2026-07-20_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

A failed integrity mapping holds a dio reference, so we need to go
through the full bio ending in case there were previously submitted
bio's in the sequence.

Fixes: 2729a60bbfb92 ("block: don't silently ignore metadata for sync rea=
d/write")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 0827bb884d473..0098a90a956e1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -238,8 +238,10 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb=
, struct iov_iter *iter,
 		}
 		if (iocb->ki_flags & IOCB_HAS_METADATA) {
 			ret =3D bio_integrity_map_iter(bio, iocb->private);
-			if (unlikely(ret))
-				goto fail;
+			if (unlikely(ret)) {
+				bio_endio_status(bio, errno_to_blk_status(ret));
+				break;
+			}
 		}
=20
 		if (is_read) {
--=20
2.52.0

