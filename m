Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A135E958
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774890085; cv=none; b=pS2Cg+Z1WC5Wg9GLE2LXfYOTkgQh03pK888wLpNCnfA6XUGWahBSnxUqXOtcxtH3qijak8qrApS5OUTek+31zQ4ALmbqzsDDh9Fn26n+Rfv24n2nj0LAAVqwyHphYcBeZ82QguTrTMCVoXXkWrtFOwuna/l+UmyxlfU7DI24zqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774890085; c=relaxed/simple;
	bh=ZS7oSKVCs+J4wwSEzeQR850Fv39RO2FiHmYGdrmtboI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bhi9/8NR78KAL9siqprQ59mXAtrqinptDCp0LT8TabCjJQUIH4/FkYuY+s7m2GgudnK4Os6olyNpAbuMz6+AtaYy5C2ELnG3RWhPc+Qhr5kmI4QmufkSvgZO2Qh3ccJUnqzY6q6R58Bhfb7s81o1bNqJIp0NUfEL82e9Dy++rds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MQCdmhHr; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MQCdmhHr"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62U3a6IM3368507
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=o6n6q21Ib3kDEuXDpE
	VoPBqBZqZlQ1cIQf0u8FtKY+I=; b=MQCdmhHrouP8eI4iuSexmivDyKHNzOfAkO
	ewLiE4xc/kjDlOFybZIwvvnZb1e4gvV7nXG73PGV9C8ZSRN/iNhkr40JBjgOAlrv
	ndmC4jmj0a4lbJ/xO8nXNrRgruen43qpEJ/CeSFQ9I98vn/zNMfO0N1jPpm0APlh
	Uf93jDvA+2qj1MLGW2eYzg4KNJ32Z9QN6kGr5FJqzQtVcaCrDWBEAn5V/FQn6+RB
	nLVvATyqp1y/s/mzKMKcHKE8zLb9OvXznO4l8yZsH6BrZ+vZ20EzCw7gRpArEbih
	svbHahMgvHp6DISRNEwH2cVDGg2+6KbG2BdLGFgDEJyYAoUfRwAg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d6xgexx46-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 10:01:22 -0700 (PDT)
Received: from twshared124412.16.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 30 Mar 2026 17:01:20 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 4ABFADFA0846; Mon, 30 Mar 2026 10:01:16 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 0/2] dm: finer grained memory alignment
Date: Mon, 30 Mar 2026 10:01:12 -0700
Message-ID: <20260330170114.764606-1-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDEzNyBTYWx0ZWRfX3Kckel2AA9vC
 v5R1IlgJLN8XTOZ941SbAeT1C9ZwNabb4tHk+KIwAQq490aWilUn8pKKIXBC4R6wf6BMyfgSFi2
 zT1iCcm0io6VunK82AA1VPx+A/hG0xaVqMNaHJFgQgcFd2W5CYs88mc+3EClxwzEHHiw+84ld2i
 2PS5EQHQB7LfjyZyZ/jvZWwNCe0M1LQRTMWuYSN49Z7FfPLQ1zyaLfOuY/pgktI6PueKbrEftZb
 GW+hxz+SuozquLMinNitq8lhSo4W6+8ugyT7gOLMObMMlgoioruCBlD4rH1MiOJ90nkqjxdztx6
 3mnL3E5PLGTJZ0vvzKbx03I5dkKdw3W7P7e81AgKMZpWiMAzPJabaJUtDhtpCCmyPV98Q4kZVfi
 F4gh3YoTvHUNVEEV9pISuCGtNFMK0REaCGpnB+OjUDqGk5bJ4MvkQzvpgVwrUhNHtlgHrlDAb74
 GonSmth/pi8oXWKtLAw==
X-Proofpoint-GUID: zdWEBowxJGytlkVXe71MRD9FQkx-Pk6F
X-Proofpoint-ORIG-GUID: zdWEBowxJGytlkVXe71MRD9FQkx-Pk6F
X-Authority-Analysis: v=2.4 cv=YcWwJgRf c=1 sm=1 tr=0 ts=69caac62 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=LbxgntRXwOKtNsxLvIEA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

This is the updated series for allowing arbitrary memory alignment,
enabling direct-io without bounce buffers for dm-crypt.

The previous version was posted here:

  https://lore.kernel.org/dm-devel/20260114154954.3282207-2-kbusch@meta.c=
om/

And is based on the current dm-7.1 branch, which has the necessary
dm-integrity updates that make patch 1 a no-op.

Changes from v3:

 * Split off the generic dm-table queue limits update into its own prep
   patch.

 * Squashed the rest into a single patch just so it doesn't introduce a
   temporary commit point where the reported limits can't always be
   executed.

 * Do not report a dma_alignment lower than the backing device's; this
   is necessary as the incoming buffers are used directly for READ
   rather than bounced like WRITE.=20

 * Fallback to a mempool if we can't allocate the scatterlist with
   kmalloc and updated gfp_t flags accordingly.

 * Various cleanups.

Keith Busch (2):
  dm: initialize dma_alignment to 0
  dm-crypt: allow unaligned bio_vecs for direct io

 drivers/md/dm-crypt.c | 147 ++++++++++++++++++++++++++++++++++++------
 drivers/md/dm-table.c |   1 +
 2 files changed, 128 insertions(+), 20 deletions(-)

--=20
2.52.0

