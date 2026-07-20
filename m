Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F923B47DF
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578287; cv=none; b=OpB/3c+w8JPdMlJKcdQGxoOeQNEMIXIHH9rYAekDHBG4M5oUAS+JDojR2XBpVPGQAaq/n5y9x1hu+g3SUoP5gkFaMylyEl53XEsV/hKbXdM6Jj4Ul15+DiMwzcofjq7Iq7sOZAua9Yg5zs4oDOB1TmMKPIaLuhgzplQpWAcTfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578287; c=relaxed/simple;
	bh=4Ufd1cKEAW/vVKZPyn1hSS7idDIFldZqPDymbVADKpM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=td8SOQ1Sn4W3J6Q4pgYxdwlFyYwUbNcqAiMv1FQL2tTFK5CI71hmHbq6F47KAdJdj7gqOR/z5WOlISnEDqUYLiiOLFEfd/LawBRDBm6UR57k7wjb7uhGJ3uvI6Ip/ZVUDURpJ9Mp9gOF4byaIt9S7jPY2I2SmDhzDvmm4PDufvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SolxgFuc; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SolxgFuc"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KJQkQt2797068
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=jkx678gHemJwfPTUCxVPJsQAnafxbenwVYd+UUmdfN0=; b=SolxgFucmP40
	SHcy9kdnHjCS29JqDUF/nvZIe28lj7xCnBddhYHIcAnLf6a57+R9EfFwAwebpflt
	Ozkn8qilFYwJi2N8tuUWyqOBOTVtVdYg84hcOvtjvE97a6jbcumEGLHn7zhjry4a
	/F2EMl28BU7mpOfLp6IYzzCH/OOEn7MXRueToMX9E3EYme/Hd3AGGKBorKXaUID/
	CElI40Xoz3R1vc2gyD6jzED3J5nkPuja5ZPprRriEpCPmtq41vHgQlJrO65JZb6C
	t8P+Q7TWuTFXK9k4iSJbrd8KPVCG2dRPR0alTWJ7qm/noezhpimk9DQK4z3XpksQ
	m42jhuS+jA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fgu4dfyys-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:24 -0700 (PDT)
Received: from twshared25342.02.snb2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 20:11:21 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 8EEB325A00283; Mon, 20 Jul 2026 13:11:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>, Hannes Reinecke <hare@kernel.org>
Subject: [PATCH RESEND 1/5] block: use blkdev_iov_iter_get_pages status for errors
Date: Mon, 20 Jul 2026 13:10:53 -0700
Message-ID: <20260720201057.1862857-2-kbusch@meta.com>
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
X-Proofpoint-GUID: -shHfgCha5mlV0JQ_Y7YDPsUL8e-YkH3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX7PIbai6OybFr
 GXAGChHXdrwbM2SXjcojoF2NNJz0xiBjUhgIHOEPMjAu49Kdra5guHBWMeivY8z/8B8pJvGv3zy
 46PHWplACEajb4wPeqdKJDyuEGiMT29+kIAamIthT56g6qZo2RBMSAFuPP3YFe+ZizsMIqAPWXs
 da2cChzwlwlkgNiGJPAPP8mOggHJKh4fOSO8q894mAIGUqKzR9MgOqm8zhcXqO7FTUeOmqCLaGg
 pb22QM3SLznXn0YB1JHbeV6jDp0wA72bqiitVrW3k7FhlOsdncG54Bi1RMsvm9tUQKvvVPHG/BJ
 QWEUzAanJ16+oDJgm2nn3tWiEe0opbr3UHDzOaRqCnEQY8wFSV/Byk/wx9wrM4K6Nn092VVsCaF
 ScikRGhfxF8nVC2rX4B157xsunV4z9h720lfbujfbv1pp12vfx42PK7ZPplxdLc5QAOUPiwferX
 RgeUnGFpF9xY+mCiAvg==
X-Proofpoint-ORIG-GUID: -shHfgCha5mlV0JQ_Y7YDPsUL8e-YkH3
X-Authority-Analysis: v=2.4 cv=NOrlPU6g c=1 sm=1 tr=0 ts=6a5e80ec cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=xbwd-4vLOdmjPcKMbXEA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfXxxEUzfqDO6y7
 dqIwLEpUwtXYr5bA4sWhX4s91XfVB6akPXRF7tnhuS9KIXblBPoidi1NQa2P63Y+gAjRv2tbKOT
 prCi9ymtGuY9TySaUkw0djPW5m/Gpqo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_05,2026-07-20_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

blkdev_iov_iter_get_pages() can return various error values, including
EIO, EFAULT, and ENOMEM. Set the actual reported status so user space
can know why an operation failed.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.52.0

