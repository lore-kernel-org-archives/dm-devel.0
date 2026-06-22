Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511C8340A76
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150174; cv=none; b=ZGnBjs6f8a3tUjaLRinucGwpQw0PEhArqHKy/ZqEMo2K1cLhZM4YQjnhtD5YLftSOl0OtetzYXe6IgG0S32k0GC7u+728JAE4VI9RdbJMuAa17QEuD1TzthG+1+IGcBr9hn1QvQSzYaVhD1apIwqsQPzqUk6vm8iXiBEXEdD4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150174; c=relaxed/simple;
	bh=Kgy4azx5D0tPEjA26zmibqdKZ1g0OpG1BZXuYdlBzek=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ffSGi7veMfjM+SFehcpedr8ZsjdLo6hkY/5zrxgLBnhxXUltGCMIIOG+jYLc8rvlTIUnoSJXsqEf0k91CEDd9aWevwZiT2iKbcBOs/Z+vJSBuLXCwcvZdqWWgA4uARsfNfiKag6m+xibqCSWwSeox2SwxRVr4aGK8ZyEv6lVZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=vulBCqp6; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="vulBCqp6"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MHVXQe2317193
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:42:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=mJQ1Lgdwhyc1A2MI9t
	ftbKE4RCResY9ZI3zxjxvHywc=; b=vulBCqp6sgJBesuDMNVWcaKgKyzhLsibC3
	LNjpK+ILiMA3JHQzNBB11/V8vcLl4ngVM0nRvYF668z16Cn11k/BIn9s+DGp/egX
	Q6hQi/lnQ/eT234umd2qji7jHvyZV4GQI9vUdvLyArzxo7C4CTQx+pBZI1Kqowl4
	GttsEWguCryVct1nbDkbKHSN1tYE3ZJU0eUS4TD8MF1fszQQIFIiOlbUQ2R9pZ3A
	MGYb+vVbyjLHN+naoDHafyN+rHzG4UyRHhJ+OXpx4i93hA6/lM1pX4AOlRrOPsjI
	I4h6wiP1wAj3dJyr604Br+XPNtWcZg4L3l/wfVNWpDe1ecnX4tcA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ewrkdcwr7-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:42:52 -0700 (PDT)
Received: from twshared17215.34.frc3.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 22 Jun 2026 17:42:49 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0B66823A15DD9; Mon, 22 Jun 2026 10:42:45 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/6] direct-io: validate user space vectors during extraction
Date: Mon, 22 Jun 2026 10:42:35 -0700
Message-ID: <20260622174241.2299563-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 0Qzo3wDlzIOhRb9HjuJsMKug8fmBcsY0
X-Authority-Analysis: v=2.4 cv=c4Kbhx9l c=1 sm=1 tr=0 ts=6a39741c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=xtH7KyWI9dI7BmFOsl-x:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8
 a=mbjKAHUlPDM-YR_J5nsA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: 0Qzo3wDlzIOhRb9HjuJsMKug8fmBcsY0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX0EJlo/JtmHIL
 WCzbNR9dBk9Tya9vDChCmzjr2HGfsifTYa4+nHLxg2/iM0AiGFV1RrdHLQg4rN5GOnvYnqksKl6
 IettREGHA07vMRotiOFIhJW239NuHr8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX+R+2lEEckw3J
 VAuID7rUL/NbPmj14A8h/nUDhBcWrxkmvDUvo1wX0Gh7ytCWIwNUea+ElKUFA36+m/uzAVQjkjZ
 +VSNpunnik7v1RVpWULw55IIeQoP2YK+aIviWJBMIKhQ3fz+OcrTv9m+ggLLOGZq9BUKb/Oe65x
 Ndc7jlrH+BNUA3RzVxfIaKI2izquwqspc18lSwe2Ec5VbkRJ8tNSdTutmuglUNNw5eppy1p7kBR
 azREUdP/F/Bh2qBbIsZ0yILxAEbcrKsI/x2Y46Sk28Kn3P9ey+KZUBctWytg6TE504vOzyB7zG7
 n+pVbnitEDWbV833ofahff+pA7stCdlLYsRqq42bzX7M46eyuMCSRbJcmWUqBQjhHJhmj6u43rL
 T3LABTfXiSALRBzVxCcdqoROLalR+rgwUWxbOfYg9R/CnTKD5FsCcNzS850bimT52CADnD6RxPA
 z6YTbzVwOV8FUH59pAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_03,2026-06-22_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

This addresses the misaligned direct-io problem behind various threads:

 https://lore.kernel.org/linux-xfs/20260610145218.141369-1-cem@kernel.org=
/
 https://lore.kernel.org/all/CAC_j7i1R7oy+nRhxEjCTba=3DDUgn02w9X+p94DCu0a=
Hv5+5tKnQ@mail.gmail.com/
 https://lore.kernel.org/linux-block/ai7rnH20IYeSmY8s@gallifrey/
 https://lore.kernel.org/linux-block/20260616154009.2123183-1-kbusch@meta=
.com/

The previously tested fixes are correct as far as they go, but they
treat the symptom: they only matter because an invalid bio reaches those
drivers in the first place.

The reason it reaches them is an assumption I made when I removed
direct-io alignment checks in 5ff3f74e145a ("block: simplify direct io
validity check") and 7eac331869575 ("iomap: simplify direct io validity
check"): every bio is eventually split to the device limits, and the
upper layers cope with resulting errors once the bio has formed. Both
were optimistic assumptions. Drivers with their own ->submit_bio may
never pass through blk_mq_submit_bio()'s split, so the check never runs
for them, and as numerous threads showed, the consumers don't uniformly
handle this condition.

This patch stops the invalid bio at the source instead. It validates the
buffer's alignment against the alignment limits when the bio is built
from the iov_iter. The check is folded into the bvec extraction that
already walks the vectors, so it adds only a comparison on a path that
is pinning direct-io pages anyway. Misalignment is now uniformly
rejected with EINVAL before submission for every direct-io path.

With this in place, the dm side changes under discussion are no longer
required to fix the bugs: the affected targets simply never see the
invalid bio. The tested patches remain reasonable as defense-in-depth if
desired, but they are not strictly necessary after this.

v1->v2:

 I've included some prep patches that fix other issues in this path.

 Renamed the alignment to "mem_align_mask", re-ordered the function
 parameters so it appears before the length alignment, and added the
 appropriate kerneldoc.

 Added additional comments to explain the rationale behind the checks.

 For DEBUG kernels, a bio_vec iterator is checked in its entirety. The
 existing use cases appear to only need the first vector to be checked,
 so the more expensive exhaustive check is only happening for the debug
 kernels.

Keith Busch (6):
  block: introduce bio_endio_errno helper
  block: report the actual status
  block: fix dio leak on metadata mapping error
  loop: set dma_alignment from the backing file for direct I/O
  zloop: set dma_alignment from the backing files for direct I/O
  block: validate user space vectors during extraction

 block/bio.c            | 50 +++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c        |  2 +-
 block/blk-merge.c      |  4 ++--
 block/fops.c           |  9 +++++---
 drivers/block/loop.c   | 50 +++++++++++++++++++++++++++++++++++-------
 drivers/block/zloop.c  | 22 +++++++++++++++++--
 fs/iomap/direct-io.c   |  1 +
 include/linux/bio.h    |  2 +-
 include/linux/blkdev.h |  5 +++++
 include/linux/uio.h    |  3 ++-
 lib/iov_iter.c         |  9 +++++++-
 11 files changed, 135 insertions(+), 22 deletions(-)

--=20
2.52.0

