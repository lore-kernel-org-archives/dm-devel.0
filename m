Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8253B39E6F9
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405285; cv=none; b=e5DMBT9QnjNX4kzexBBZM0Qc9XPo7nk2S7iNfqdPcMpfLEjQnSTDtEJDxBQP2SsmuCWwVn+mBq/qecWzRoUkOfDkOKYEJ2BQka56fJ7Uil8R/L3TYhO4sQfRn1ZlsbsS64qKtznAHrMuTeku+NgQ3NZ0vC/nlTxhaKguwhUsGMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405285; c=relaxed/simple;
	bh=uoYeTVO/oNx7JVivr+YReXOWFEc0wL2JJKTh1X9OQXI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEIKkVJMtplK7iKPNcNShwhhK1fUtYG9TB7o9cx2cG/M3oG37lUgozpu7czMGPH4fHt8IniftN6l4oa2a+LXUh6xltQF208ts++hrtD9MrgIlQazcN59zpYOkjBBbSUrU0qEy90a18eeZvTDhCliffBerB8sBhM6U1x8zM/hqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Msk8AYLl; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Msk8AYLl"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60EET5oS3316672
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=t++cTXL1wgV9wEspodYuYmUnkMprtJ4AbLORX5XRU70=; b=Msk8AYLlS9ks
	3s4Hj6Q2bZAhVsqVPYaQhFD1L+M6DzSLyB7+dmhrgjD7pdDbwQler9jfSSeY919w
	XtsvdEIsJITlgTb1DLDWbb37VeSF9ZvuPd6J2WxGUTB76QZyUALkqFsCrH7RRhbm
	qvZ5++Q5/2o5EHoXscpm0ZtE9wBFr4+xm5ZZM3xzJlveIMkU4Jf5KPhqHnxhalyL
	XEZU9KuDUq40y5Tje2rofJoT4w8s/GZT3wgzhyBEfRYD5vvP3zSZwJuFVcNUqHpa
	1OyXBPZdvOO2VxxiUtP0xA1RtJEcNJAlGwDvg/rNAlfo79lYR8NeAVVaTaINDvPz
	b2iV1RooGQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4bp12adg4c-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:23 -0800 (PST)
Received: from twshared18080.32.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:41:21 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 02BB563A8FF9; Wed, 14 Jan 2026 07:41:13 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <linux-block@vger.kernel.org>,
        <snitzer@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>,
        <ebiggers@kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/3] block: remove stacking default dma_alignment
Date: Wed, 14 Jan 2026 07:41:11 -0800
Message-ID: <20260114154113.3207790-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114154113.3207790-1-kbusch@meta.com>
References: <20260114154113.3207790-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _XE9lSqwSkIczeuEXU0Z1DdkVrQeqiuK
X-Proofpoint-GUID: _XE9lSqwSkIczeuEXU0Z1DdkVrQeqiuK
X-Authority-Analysis: v=2.4 cv=KcjfcAYD c=1 sm=1 tr=0 ts=6967b923 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=wfdUoG3Gv6Dt7mlkbiwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMSBTYWx0ZWRfXymynpJKxAFJd
 kjt8GaIS3jq5G/pxs+xzCo+nkch16eU1YP3xidjrmxVW6UryDpjGjGr6F01mXkltaP1RJoJewUA
 reyIrQWb8XPlwaHCOvgnMryi1RsTsrlB4U3bnAPcRaVYH4aE2CyXODuzsyIlB43cnUOQkd4tAyH
 F+C/UoTap9xJudZNrc+IIXRQ6ueLBot0XO4K5HEpMW29EwSWdNiVGVjN9BYYya4zzNBzScOtG4Y
 ACe2JI/RTCQMCV1d9Y5+RIOpPAY5mllT0wf0xcHlCOfjsRePIzI5I6TbN1zeKwJTFhMtT1BaXGQ
 siu8HbmLY4J7NxwKvfWUlAJi/JsyN2SpaEGXilZ9lFF9ZfJuG4B19oGypqiTTQrFeo2HOlplcKV
 L2bw9J0OG25inIZ2o1Z6isCSsjVIJ4v8rItG9MEQ39zgGYx5DoeZFYSN8bKlDzn8X95rbhZomkx
 Af4SlDDMAmCSDgfm6Lg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The dma_alignment becomes 511 anyway if the caller doesn't explicitly
set it. But setting this default prevents the stacked device from
requesting a lower value even if it can handle lower alignments.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-settings.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b38e94c85402a..2a7cb46973440 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -41,7 +41,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->physical_block_size =3D SECTOR_SIZE;
 	lim->io_min =3D SECTOR_SIZE;
 	lim->discard_granularity =3D SECTOR_SIZE;
-	lim->dma_alignment =3D SECTOR_SIZE - 1;
 	lim->seg_boundary_mask =3D BLK_SEG_BOUNDARY_MASK;
=20
 	/* Inherit limits from component devices */
--=20
2.47.3

