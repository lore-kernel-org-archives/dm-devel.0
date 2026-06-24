Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045A3C5856
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320968; cv=none; b=IpbkiPMBeL9rwYlAvNuLlCTPlaM3Tw85gHGrq2h4ko43+6BoxIpzJ/xk+c5LQXT/CL06yDsy7prnCW/BNXs4JwfOoeuMlppqv+JkmKnxzbf+6UvuoesyCnFTjBzsy4IwuPyX+kOsc50DDBuctaQLlmAmqu0OaFwcKEhDPp8qgFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320968; c=relaxed/simple;
	bh=YsUC64mgY+X0BIazTC9H5Uv03vlzG7pn10IYPSPd6ew=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ihtrmP1fOIYxlZrxrAoPIhZ67rlgzm3eq1Kk6vTKZssDcQSvxHOkFkRbT4MniJrqfp4b+T3ZoNSbwCxId1RH1UHwfyhZn+lvvDq8pnadk1GxIPjtE/iL36Bge/YEcGqqlNAKAK3VgNgtRI8hMTlBuCknICvBWf15twKOwgSl5qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=U5TtPs1f; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="U5TtPs1f"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 65OEm6JB4025440
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:09:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=cci0X1A16/hpB/b2Gp
	G7XR6eiq29XFDPMVfzNFYBXN8=; b=U5TtPs1fx+fvz1Q9ey7xgiAvCJA0V+mVVy
	dyD3nSxINY1UQVp29sU3F4V5KAFaMatndeLp9BU6DRQOpeG5qIAD7BVpP6jqtwzb
	w7ILrdg78CpriaUQySVNaRNy4Uvks8uwWcpVqkGQjLZAVLJzktrBaZBcZUqcexu3
	sWfi/ix8RF3F8DAd5rls02MHJSIP3i4Ip5fk+TEmx+xCGgkt+MgYc9vIbpWCdtKa
	P0jkksSrqg2JUMWOJtm+luFH6+HIh2Vnq/hk+AIcGE6nlyq24AjcCqnMwduccI6U
	B1dWMIc2L0a+oxu7xOp1j4HHCfHw5Xii5st8RyHrhUn9fHuEcu/A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4eyudja2fk-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:09:23 -0700 (PDT)
Received: from twshared6916.34.frc3.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 24 Jun 2026 17:09:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0769723C452B7; Wed, 24 Jun 2026 10:09:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCH v3 0/5] block: validate direct I/O memory alignment
Date: Wed, 24 Jun 2026 10:09:00 -0700
Message-ID: <20260624170905.3972095-1-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDE0MyBTYWx0ZWRfX2o4NcSwQmU0X
 6VX32y3ldW9PuT/dP18+llC0oNPOx9ZGOEbN0EGUcw6LAgj+SiJCXtVhIvnSvTMLLbY9HiX3k+e
 qxMJMFI8Anh5ymj9nJkcR6HcMVbKW6Q=
X-Authority-Analysis: v=2.4 cv=K/8S2SWI c=1 sm=1 tr=0 ts=6a3c0f43 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8
 a=8TWUW5CQ5KP6iBCUMyMA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDE0MyBTYWx0ZWRfX7FqEJ4kcFM4d
 qT6SHPrAJPP3mIURGYQ16jlpX7ZrMldlMCo/bkxYhVbASqugQaT64xt6g26ZwFxcEPZu1AMQxLu
 sub9K7pQFP3jk5pB9BiWemMoxqWAT6F57nDqi1AGXjhdS65wLxKJpV8Uo5yQAW76Y60bnQQquPj
 APoRzHqW9FO5gDPd+h6qodsgZ0N/SgjpZBq2m7UkJjijsuVSbVPb61OYd/9XPbMTiUsUruogTLh
 GXUGohxhLG3dmKH0LJtdbwdtC7hA0so0Etr5mFEoAo/OXWrpI805k8l4PtSKhjxyoDbP//+8oTv
 rKcdzdv11QjyJ8uyqfn5TvFTBS/DqNXIKiUNuNOcXHg2oRlib4w2/Jj0qaffye7yIkQjzBNW6vN
 E76KdQ6nPBoWQLuWU/tUsoznwN5jg8kJzndU+nwpH1o3UMMyt9NEUQdA+1/lLyApuKp1Tr+Q/9g
 R6R6Rc02+2IidTiramQ==
X-Proofpoint-ORIG-GUID: 8liMFVXip5HWDXKiZ_wFntvUfcTH382m
X-Proofpoint-GUID: 8liMFVXip5HWDXKiZ_wFntvUfcTH382m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_03,2026-06-24_01,2025-10-01_01

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

This series stops the invalid bio at the source instead. It validates
the buffer's alignment against the alignment limits when the bio is
built from the iov_iter. The check is folded into the bvec extraction
that already walks the vectors, so it adds only a comparison on a path
that is pinning direct-io pages anyway. Misalignment is now uniformly
rejected with EINVAL before submission for every direct-io path.

v2->v3:

- Dropped the bio_endio_errno helper and open-coded its two users.
- Documented the ITER_BVEC alignment expectation in uio.h and reworded
  the bvec check comment; the exhaustive per-segment validation stays
  behind CONFIG_DEBUG_KERNEL as a contract assertion.
- Reworked zloop_get_block_size() to mirror loop's structure.
- loop/zloop only ever tighten dma_alignment beyond the default.  I
  think these could use more relaxed alignments, but I'm just being
  extra conservative against introducing new changes here.

Previous version:

  https://lore.kernel.org/linux-block/20260622174241.2299563-1-kbusch@met=
a.com/

Keith Busch (5):
  block: use blkdev_iov_iter_get_pages status for errors
  block: fix dio leak on metadata mapping error
  loop: set dma_alignment from the backing file for direct I/O
  zloop: set dma_alignment from the backing files for direct I/O
  block: validate user space vectors during extraction

 block/bio.c           | 56 ++++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c       |  2 +-
 block/fops.c          | 10 ++++----
 drivers/block/loop.c  | 46 ++++++++++++++++++++++++++++-------
 drivers/block/zloop.c | 35 +++++++++++++++++++--------
 fs/iomap/direct-io.c  |  1 +
 include/linux/bio.h   |  2 +-
 include/linux/uio.h   | 10 +++++++-
 lib/iov_iter.c        |  9 ++++++-
 9 files changed, 142 insertions(+), 29 deletions(-)


base-commit: 5c7804e3279c9bdc36e5eac743b4000633b25f65
--=20
2.53.0-Meta

