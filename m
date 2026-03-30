Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFB83793D3
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774890089; cv=none; b=kQKnRKAwCG4gBMwyFMITfeuFnAeiqBT85u+jdI15DfqVi/fmfG8qo4PNWgdntVt/jBqCJlXdFq6lcXtlcwuUCU0R6/N7lHXIB629ioeoQAjuk0zD2AW6WVIlyUsc3d+Y75S6fhnF3OvvAjWt6/2sB0bwBlGHw0Yi3UYixa20QHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774890089; c=relaxed/simple;
	bh=5dpj79E3TkNUWGbk/4n3VwDNeI0EzjnkWAvWxRr+Ucg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JC0l1vDxSEvaFVyqM5QBx9Tab8Cl1KNxsXk2oMLbRUMY8MXuDFRDbbd1NWNmODd2vDWImOMNnj9nPcB61JIIbVq9QkaYIwDXqECGYbVEPkOaXFAXbhGUg+Rrhfa8afCaFWHyf0ft04bXpHbWpk7PGIQq0lxfond+h4PH0HRellw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ClKpljK7; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ClKpljK7"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62U3a6IT3368507
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=c+FOvJbopOOU6Ylh/wpHLfBaMAWWNrX6SWR1vtup78M=; b=ClKpljK74dxo
	kevIdNJuTWFX+l/gW8LHikI7ThkKyi15REQGd7b2EZ8DAJWqxP3sUZOQI6hOr1KR
	G0uGs2lXs9TJ1pjc9kptnSREU8o7I2JBPFfdUBHzQLmKKmZmlp1vSlkSpbnRratr
	JCV96E6RAzNoMCrPfyOlkb3PCQUpo/C8GfBenWQP5nmnrVTIJ7G4ZYTYhmvofrJn
	BMs6OClAtmpGcDh2MlgyIInxrEDjpITifPzOe7prcrs2NM05C++drErkt9sOMYGZ
	ZIEI1PDMWCfTEKALVHb0tEzIG7sZUXddWv2JmTAPCjLM31852GYa9U7xytVWR4Px
	0PJfeBTEoQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d6xgexx46-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:26 -0700 (PDT)
Received: from twshared10186.03.snb1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 30 Mar 2026 17:01:22 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 54FBBDFA0848; Mon, 30 Mar 2026 10:01:16 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 1/2] dm: initialize dma_alignment to 0
Date: Mon, 30 Mar 2026 10:01:13 -0700
Message-ID: <20260330170114.764606-2-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260330170114.764606-1-kbusch@meta.com>
References: <20260330170114.764606-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDEzNyBTYWx0ZWRfXxUAQm3teUN8/
 mskRG5j55hXDYCvhMdKCg/iOG5YxMmGOnBVab8hQO6A4zYEEYLCulEqSf0sf5Wg4yMMdze0rfvC
 Z446DUslLV5I87tPrwBv9ZhCUPMfIsGiKPzKLulBiXWQi/UTeN6r76hrtbaploB6E+DUc69bAL8
 m5T1e/CGgaXa3PMtcNG7lZ6ftZedtET6MmpM/Mdnxb7A6at8Yd8b5iEi2G2pHvQdqmHqiL2MpXs
 MYY9bQbMKPPN5Yz0r379r3BC2ZqAXBEUTdueDIfjV8GvYKqBQxgaWctwKJHUtFWTWtCqP5Pq6iA
 dfwfzRzNA2z0GJCYlE88Aak/JXRF8OriI4hq2sWvminMAflUCq3CDgqU/R8OppthS8izTS1k3zs
 Svlh1Z5wGfhz4IFzHbEkPT6eS6ttsEdC9LVXdr4Q1FUpkrX63x1cKg56K7MShY/PYG0sGFuidlH
 8wTFlvqTbH/TnM4VSuw==
X-Proofpoint-GUID: 4ZQb6GviM00W1X_qKpNsUMQP9ktOhPON
X-Proofpoint-ORIG-GUID: 4ZQb6GviM00W1X_qKpNsUMQP9ktOhPON
X-Authority-Analysis: v=2.4 cv=YcWwJgRf c=1 sm=1 tr=0 ts=69caac66 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=Jf3zCm2W71OrLVUcjEQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01

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

