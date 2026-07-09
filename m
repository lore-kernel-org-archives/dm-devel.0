Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9394307BA
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613728; cv=none; b=SUqDnHgFAuzG1pU5g+kXJs22ThTTfWUfNwP/QH1m6iry7p6Z/bBblyvqNfPDZSK3nLVYTNfpjgwIM5KReTkBoVWk/X3gnhQFd5mQhiZbQpAiYeKGXvKMOBVCCmC7GCTzONlFT82PzUHdfoi8MkLa+UiDeatV/RsA65qdFUPkJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613728; c=relaxed/simple;
	bh=qT/yGofoL8mftbmbPgy4QXSKzHJEsxTT8EYzG1KqR20=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JA54W2l+P8K4cGuTi6Xb0bOJdnlgjXS057wIIt/5HxRYofRo2stjkt2FeT90ebDjk+ccfe7S3WU9Y9GqkHZVW0QfXDWJrb6ZpgpXe5LwMoM45rzmiaKwbBMAIicEpeFet+2ScUrN5WFyIjgGFkNHekyDIG8VRaNq67JwUduCPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cnO+OgFz; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cnO+OgFz"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 669DwN8r2750950
	for <dm-devel@lists.linux.dev>; Thu, 9 Jul 2026 09:15:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=lggdkpgZnn7iYhkBoA
	CR4tVTqZ+CC7kx1RAZvTebOUU=; b=cnO+OgFzWKQkIyttA0Kp7wpy5FzQfu4Bnr
	FbL5Y7RIOF1f18buum6hQ7m5Q0phi8oYzYSCU5iNzTdvTHke/dlH8krn2oxkcGv0
	L0KtNnjyJnJ1R2jJxyxuOwBNh0VFFhRmKBG0N4yURrHIVgN1jXvBEIQWyfCaiOWe
	0voEc6d1nqysbImUxBV2gyn2m+mFNygTd2xlRm0rrlus6IdioAior6ryrWJ3KgUQ
	6sOUf8Bq/EYYZRPC7lxMjN6cdL6De2viLLRYxTBqNgHXR0FOS+ffVcll3xjEIxEM
	zuigvhpl5Op0rqFm7mmzcci9FvnwhM3aT5uWZfckvIvkccsF2UkQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4f96uxgvpx-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 09 Jul 2026 09:15:25 -0700 (PDT)
Received: from twshared98500.16.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Thu, 9 Jul 2026 16:15:23 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5DF6324D56C56; Thu,  9 Jul 2026 09:15:20 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, <bmarzins@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 0/3] dm-crypt: finer grained memory alignment
Date: Thu, 9 Jul 2026 09:15:16 -0700
Message-ID: <20260709161519.1559723-1-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfX3fkgb4SYmR8D
 UDRJb0SWWuz5/vxBSephPiYi1Q3Uwmw/67XDnPD0IH+M/MqTkjoFWY3YFXgWCZgerss1FC9lGnX
 C113o2Fy07VmgdptMWpx2Zc6BkwK0qk8+fmMGhU8tnWMjip3OSwrHA3g8D6KQQgiDT39bzzSNX3
 wM5zVxu6O6IXxhNt9fR/G40hIrGxGHaggFJXguuH0TkIcFANCGe+4kLKe6uZm2cpO9ZUsuIO29w
 wuEjmoPo7rX0KpXArc3v8y4xv/tZ9eT/ns7JF2u0mdS0uQnLHKreXQC7JhRDbOD+2ljjAZPy38k
 Sg+tNgUCtvSLFgUCS52SfQ+41BRsNztWFlwJsCzQmLu38GSR89n05M/M3dQGPKvMsx2LUKY4jFl
 22CTWPfL8En6uqHV/VPFS9THZShR9PSyUSjUrHk3tWEnwcl0Edx61EBXGGBkh9TPosTF43zRX3C
 LNCb2Wr3+4+LEBGQIsQ==
X-Proofpoint-ORIG-GUID: QGOFiPASp5UsCyjqK-rSxTnVvrBRT2qN
X-Proofpoint-GUID: QGOFiPASp5UsCyjqK-rSxTnVvrBRT2qN
X-Authority-Analysis: v=2.4 cv=RNSD2Yi+ c=1 sm=1 tr=0 ts=6a4fc91d cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=MAEax2q4g0awyzAThfAA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfX+3g/snChO62W
 OmqsvVN1cUM2aULPOB+t6MMnBpkLwMOgUbasWndVtlqp07mk6lOdiZbVNR8nb+t0NZEeTsyUHl4
 c0nxjQdtdnnIJlGHMEMdYMexRGqCiuA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_03,2026-07-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

This is the updated series for allowing arbitrary memory alignment,
enabling direct-io without bounce buffers for dm-crypt.

The previous version was posted here:

  https://lore.kernel.org/dm-devel/20260330170114.764606-1-kbusch@meta.co=
m/

Changes from v4:

  * Updated the mempool count to MIN_IOS, as requested.

  * Fixed the issue observed from cryptsetup testsuite. The problem was
    an early return path accessing unitialized fields. The fix just
    initializes them before.

  * I discovered we may be in softirq context when allocating, so
    had to add handling for ENOMEM. But then also noticed existing
    ENOMEM cases were just being generically handled in the default case
    returning EIO, so I introduced a prep patch to make these transient
    resource issues retryable.

Keith Busch (3):
  dm: initialize dma_alignment to 0
  dm-crypt: handle memory allocation failures
  dm-crypt: allow unaligned bio_vecs for direct io

 drivers/md/dm-crypt.c | 183 ++++++++++++++++++++++++++++++++++++------
 drivers/md/dm-table.c |   1 +
 2 files changed, 159 insertions(+), 25 deletions(-)

--=20
2.52.0

