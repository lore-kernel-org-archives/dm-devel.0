Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A134307BE
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613739; cv=none; b=biXp06g4qwM7U9h6zvOWP5coy2PKpHz98psmwn2cjLjGeWmk7Pa5djsI3uizSWCE9POO6pdXvbCZ3WaYzvV4PCs1pTUd4hvpBmvFdLJu4LtKC31eMNz5YECjHNfSjKAkL1zNN3RuQ0g3jgcwxNQ1KjQkeZ7oOXy/MBEjwG+E1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613739; c=relaxed/simple;
	bh=5dpj79E3TkNUWGbk/4n3VwDNeI0EzjnkWAvWxRr+Ucg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjmf+O+sNm+UQGyZFaHbfj7CocBLRVLFPzOpGpVaUrFiLjthDzTf18UBQoPunPbHXNIZFvhyAm31Vh/4mWy3yJjB6fWkSa7aptehLOmEnaiNtKGEezQKujOag8LU+DNZmATj6pIcgF06bP8R3jFBfeYvXtFOi7KO0EyWf/TNPVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HmqB+RB/; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HmqB+RB/"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 669DxOAv2807632
	for <dm-devel@lists.linux.dev>; Thu, 9 Jul 2026 09:15:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=c+FOvJbopOOU6Ylh/wpHLfBaMAWWNrX6SWR1vtup78M=; b=HmqB+RB/G7PE
	IIy+yTPG2BlgFicXtNPO1cFQ19KT2J6v4UewzerznqCNBNqZTIq8cMRFiKy2fIPY
	qlAR4JHgI9h160fX4U2CnMYhat9eEUmugD9rCWNfnnjCqiryJxL5cGPmZ8ipbyR0
	oWvll4vGG8Z3v0B9NJqRJ2D51Gbavr1Dsgm9/ja6FkE9ToKThcLUDPmWlSvTlXrl
	7PDK66IviFyluFVUbTejrMh4VgQeYUUKT4VA6SQHb4y8n8MGTnLUOzydP4IVLprD
	u9EDzKMSbmL6iyjVFDQlF+f9pBvGuxW8xfEg464ESbCiW3hV2w9dEWEInYpx/8R0
	nrZUPxPasA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4f9adreve5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 09 Jul 2026 09:15:36 -0700 (PDT)
Received: from twshared132625.14.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Thu, 9 Jul 2026 16:15:35 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5F75024D56C58; Thu,  9 Jul 2026 09:15:20 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, <bmarzins@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 1/3] dm: initialize dma_alignment to 0
Date: Thu, 9 Jul 2026 09:15:17 -0700
Message-ID: <20260709161519.1559723-2-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260709161519.1559723-1-kbusch@meta.com>
References: <20260709161519.1559723-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: axURE0buEUhcyez7-q3xQfPEXO5nPZLE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfXxepfkCEfkPCF
 UdCbFty+X1xw1Xyog7wkHn7yPm1GLiA3BzHrtRFx0zY2njCssumig2Me3XiCCf57vuNoCEbICsf
 7Vs+9qJe4FJRdlraBTygRMjm7aZqPNM=
X-Proofpoint-GUID: axURE0buEUhcyez7-q3xQfPEXO5nPZLE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfXy9zcsXkdkwtt
 6/0GHeoxPgHKUPODrrICY/3ezdiFZ/lWGBsnF/PCzEE51hbyf/KHYA/ptfuyqz5LRt179Eyr77S
 gM4WPmNhlwGZXfBD/nIilW+kZ999a6XjqXrK4trBv69lMJmqLJvPEFH3+FGr7w57d1H7PBzbvRU
 5S4o2wUes5ncFPNw46UsXx8IF6UXvFj4mVZlyuLRXDjlnr3r43rirqWRPRifPxU45IiRkUrz4MJ
 xUSOShovxlmnHKfneos4CUElkVpoifzoAk54r0zRZuxYxBoMGMG06Ej/JaoHo6cDKToA/qKvx9x
 rBSKM+StVW8VcQ9Z0M/5P+0+vKMB52+144lHuHectMoP45Hf5V4TEdkY00wLTxzQS8O98MWvFEl
 BhkYhhgQDEPada+jpc4OaMxKM0g91LICUNuuWVCuZPORR7RirXHaUHlr4BVemtdJdczGRmuP/i/
 Fk4m3WDZ9Fh4aXPMG1Q==
X-Authority-Analysis: v=2.4 cv=WZE8rUhX c=1 sm=1 tr=0 ts=6a4fc928 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=Jf3zCm2W71OrLVUcjEQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_03,2026-07-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

All device mappers that want to override the dma_alignment do so.
However, because the default stacking limit is set to 511, a device
mapper couldn't make it smaller even if it is capable of handling
finer grained alignment.

Set the default dm stacking dma_alignment limit to 0 so that it can be
stacked with any value a device mapper wants. If a mapper doesn't
override the value, the initial 0 value will get changed to the original
default 511 value when the limits are validated after the device
stacking is complete.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index dc2eff6b739df..80326f8096cb7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -591,6 +591,7 @@ static void dm_set_stacking_limits(struct queue_limit=
s *limits)
 {
 	blk_set_stacking_limits(limits);
 	limits->features |=3D BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POL=
L;
+	limits->dma_alignment =3D 0;
 }
=20
 /*
--=20
2.52.0

