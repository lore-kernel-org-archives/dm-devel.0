Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794B34D389
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774467391; cv=none; b=kX/gfEELTn/WlpvsYGg/JBrWGjKORYkj8LEiw8s+RDJxVKgs7xWz1MURVXyO2fqRQ9Nr7AxohU58fklT7Ckvst3cA4HS3P40PSw+N+JZE3ttSYDICyvjxIp94WWHOrBq7tm9K/MmJqT8Kyyl7Pqgl8MEVrbNdJw+FjXm1d4nQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774467391; c=relaxed/simple;
	bh=yQE6oQyg/vpmNnT/6Ne4EKlyoKLMslx7BjYluZfMxsM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwZztaAp1vRBekRhfDo4cbCEuoGw70Zk8y2E9oz9lBHCxHewOz29WlzQg9tDEjm6HddDT2kfYsft9S2tnpV4a7x1Yni0QMLlgjLN4IcwZndX6/VzUXfmn4I1SmEaRQnd6s/eO9839Ow9YT7eYjF1lz3mkpQxVD8G5NX/6yKXGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZE8VrQC4; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZE8VrQC4"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PHSHC81282299
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=WY/dyrdBMp1uL03d9yaKUCPqj9CWK0Qsiyuf8ek5NIg=; b=ZE8VrQC4ribZ
	DYbwp2pW503/1wu7Qy0GYND6z4ZBt0GCmOZvD+vDV9dKM29Z6hOP9badoJoLtLJt
	BzuRQoBQBLwGCHa6kSEnIX/9G/852GAMF2YJ3tEyLeIQW9iSzougrnmKGM01585R
	vwVc+hr8qAjj9P0TzkzX0hO2vYWAXj4vXKBmjYIT4kkyNxi4U/tILf5VWFh6UtVA
	vPiWmbl0N6Vtmd6D06VgEgU1KUGU6trrAkULNk6SLajuhZxjoq97n7RmZmgfq2K+
	kbHOe2bMqtCWv364D1jt4ultRaMdFxV5BHI0NvWcX6pUNb+9XH9xWnEMdyviJptT
	u3tnGVE6JQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d42kn4svb-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:28 -0700 (PDT)
Received: from twshared6524.02.snb2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 25 Mar 2026 19:36:26 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id B6780D2EC964; Wed, 25 Mar 2026 12:36:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <mpatocka@redhat.com>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH 2/3] dm-integrity: always set the io hints
Date: Wed, 25 Mar 2026 12:36:07 -0700
Message-ID: <20260325193608.2827042-2-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325193608.2827042-1-kbusch@meta.com>
References: <20260325193608.2827042-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MyBTYWx0ZWRfX268S7tiRlyhT
 e2aUENa6vtCyQtix+k6rWZR1ge8zPOi6B+NnnkuNCGGnT/mfC5UemtGjDJV9IPVIMGQyytQwM3j
 pemuXJ1Grv7r96in1hGuFpyUqAQY65OB5qvWuTLd5pYEw4xwBzEOKGItoMlZWtK82f3x4zqvzf6
 uGxGL8DPgm3LTnHWRo9E2xQczzBi1VCuRvFIv9Dq1zI7C8Z+gP0d22YtVd3zdo+9vqTPzll+IfD
 VofmFd4Xg2G0CkDGXGqrRYInZoG2EiXrTO07TMTjRdh5rz7a2+0cbd4UQrPrD5SBAYzv9v7h3Rl
 lr4lfddvm6FTmgqmyFkkQtsh/fI1oVUYFu/qk86lu5KiPDJIweAhRQjdP4dzqpjWsJyBTYD1I7G
 SyxKkD6IQMJ1JxANPnBwRa/i6GL7qE0sh9tm8AoCuX7hDU2DdDlWhrIxSeLQpVJRK9JPAJDS8eg
 ZVT7tPMCQ+i/dUK2UmA==
X-Proofpoint-GUID: CyECNU7Io0ptjULwooMOEkruaNoyuvsO
X-Authority-Analysis: v=2.4 cv=SNhPlevH c=1 sm=1 tr=0 ts=69c4393c cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8 a=q3XtwwhwJ_eMs5fEIHEA:9
X-Proofpoint-ORIG-GUID: CyECNU7Io0ptjULwooMOEkruaNoyuvsO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Don't depend on the defaults to be what is desired if the integrity
device was set up with 512b sector size. Always set the queue limits to
be at least what the device mapper wants.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-integrity.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 8dfd498ed1ffd..d64c15c761d0a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4046,19 +4046,14 @@ static void dm_integrity_io_hints(struct dm_targe=
t *ti, struct queue_limits *lim
 {
 	struct dm_integrity_c *ic =3D ti->private;
=20
-	if (ic->sectors_per_block > 1) {
-		limits->logical_block_size =3D
-				max(limits->logical_block_size,
-				    ic->sectors_per_block << SECTOR_SHIFT);
-		limits->physical_block_size =3D
-				max(limits->physical_block_size,
-				    ic->sectors_per_block << SECTOR_SHIFT);
-		limits->io_min =3D
-				max(limits->io_min,
-				    ic->sectors_per_block << SECTOR_SHIFT);
-		limits->dma_alignment =3D limits->logical_block_size - 1;
-		limits->discard_granularity =3D ic->sectors_per_block << SECTOR_SHIFT;
-	}
+	limits->logical_block_size =3D max(limits->logical_block_size,
+			    ic->sectors_per_block << SECTOR_SHIFT);
+	limits->physical_block_size =3D max(limits->physical_block_size,
+			    ic->sectors_per_block << SECTOR_SHIFT);
+	limits->io_min =3D max(limits->io_min,
+			    ic->sectors_per_block << SECTOR_SHIFT);
+	limits->dma_alignment =3D limits->logical_block_size - 1;
+	limits->discard_granularity =3D ic->sectors_per_block << SECTOR_SHIFT;
=20
 	if (!ic->internal_hash) {
 		struct blk_integrity *bi =3D &limits->integrity;
--=20
2.52.0

