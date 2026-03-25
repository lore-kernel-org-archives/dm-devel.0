Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4378F22576E
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774467393; cv=none; b=mflEV9/UeN7EedwJkIhIgQgLk29AVbKKgSCVV/jaG7hcS9LT8TdvCMeKICfTaQvYXVyKL2xLpnQsoC/b5Okgm8Jgo6wqA+jgiVGHvtF6m8t6pP0Q+/rsi4UHEHppWB17QXmxzmBqWebQDwt4W3fk5+jZ5vMiwgo5F4IW7PdshSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774467393; c=relaxed/simple;
	bh=y3ch744VeObj6sfg9NjYQyLQbWkTYuuRxBEBHniyWBU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Lgpz2G7gNAZ/5CF+RMYyr638z3K+VXHWbSjSgwJ2cXKVX6HrHGeJEQIvDCdl5aPXrrpQGuj3zK9gPUmZrir+m7SyA/BCIFRRMsGFXDeTp1eB4NValYD6wSdgA3SBai2keIKMsan9Is/sfAUOMGrMbtcYwVZGtsnTLUehAMsmDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=P1gloXpl; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="P1gloXpl"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PFtuvK1965264
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=UxiGs+5CbQWjyDDwFR
	1mbVN7qgtXVq8rQ6CPr/wZkuE=; b=P1gloXplwTsQsMQahPzkUkXcv7dfizhrzD
	Yygz/gt4ihvPKMVQcglWsHm35aqP/6IldjGW67PXXxDeU0koxz4Dq+2FmERy9Bul
	AADNeKcvWF9jikma8OvcuZMfNrHHyG2TL6JfTNzvzAXa2aaqalz1c+0q2+0LtWK8
	ldzZEArG3ddwHo5irY4TA3+j2JZr9lK7MxCr4g9yIrhOGEq/vaFw5TrZ6+bwCsMa
	mUC9JX/ABoHpzVEkXlmwJBLs2kxxvta7r7YD7mO+vELIYgiCPmT6Jg3U7rSQ9vqw
	UYjxbY1/dpCwU5mVc/F0at2tEsZPqE+kN5a4TE+kXpysJOMi1q5A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d45cgjx5w-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:31 -0700 (PDT)
Received: from twshared18080.32.frc3.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 25 Mar 2026 19:36:30 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id B50BCD2EC963; Wed, 25 Mar 2026 12:36:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <mpatocka@redhat.com>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH 1/3] dm-integrity: fix mismatched queue limits
Date: Wed, 25 Mar 2026 12:36:06 -0700
Message-ID: <20260325193608.2827042-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=FOcWBuos c=1 sm=1 tr=0 ts=69c4393f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VwQbUJbxAAAA:8 a=po2vHTGQ69wFjfYcvKgA:9
X-Proofpoint-GUID: maBbL2h15xQwrq-ePa0p-Ls4nsHkgFMs
X-Proofpoint-ORIG-GUID: maBbL2h15xQwrq-ePa0p-Ls4nsHkgFMs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MyBTYWx0ZWRfXzSjWTJA6y+C0
 5cEtGJUoav9LQSXWngtfELDumhBY3gqwjgmLerrD04H3FjGV7DKEA6n0+1DBC43DbXDYw82jxmj
 zCs1+/uiiyjKSNt/5itRtqcZrdq2RnpOyNO+a2z7xhrhOoRs4+ANCr4quEkGtmWB/H1/u5Da4Fx
 ybO7DNevfejG/fb0RiqgXbOqgZDd1AkVIJb3TEI7XVFtQ4PrYRZHpWY7VQKUepDnzJCYaNhBMkL
 kpRq4T4BPOfk55ubS07qShQ1Jnn+k6nM3jrrs0+RB4Lq7OpXNModKFDi2pXG0k05+dTxWcxn3+Y
 4VUUsMu1qUn8TZdzWfLJ7QpqBF9nDPo59y0auMWdxJTMamwIbtbz/qOCC8cw6oFZ+TjeHHfBznA
 OC9QMQOYbVGIg5m1mq6QrXmudUnL6B0u1UHpZ0kOEotxti6R+SzfwWnCZd4KcypF8AJrMV+ijyz
 11e4Ct50USElm7+BKng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

A user can integritysetup a device with a backing device using a 4k
logical block size, but request the dm device use 1k or 2k. This
mismatch creates an inconsistency such that the dm device would report
limits for IO that it can't actually execute. Fix this by using the
backing device's limits if they are larger.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-integrity.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 06e805902151c..8dfd498ed1ffd 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target=
 *ti, struct queue_limits *lim
 	struct dm_integrity_c *ic =3D ti->private;
=20
 	if (ic->sectors_per_block > 1) {
-		limits->logical_block_size =3D ic->sectors_per_block << SECTOR_SHIFT;
-		limits->physical_block_size =3D ic->sectors_per_block << SECTOR_SHIFT;
-		limits->io_min =3D ic->sectors_per_block << SECTOR_SHIFT;
+		limits->logical_block_size =3D
+				max(limits->logical_block_size,
+				    ic->sectors_per_block << SECTOR_SHIFT);
+		limits->physical_block_size =3D
+				max(limits->physical_block_size,
+				    ic->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min =3D
+				max(limits->io_min,
+				    ic->sectors_per_block << SECTOR_SHIFT);
 		limits->dma_alignment =3D limits->logical_block_size - 1;
 		limits->discard_granularity =3D ic->sectors_per_block << SECTOR_SHIFT;
 	}
--=20
2.52.0

