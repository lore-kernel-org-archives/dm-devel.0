Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452BC3A0B1D
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405284; cv=none; b=by3/sKZVgmgRkqTZ+NXMulmeM8uTJZWGe85U5LM/xDgW1Xxvskd99SU/X+kgnQIkk/Li4uJvXwgyV3Fdh/u5GIainojfqlv5w0lHXJAWq7ce/6qekABcpTROqe45ovBnBGSLCevd6Pc12xe+THjIgiSyVX84epE0AeuTxTMObIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405284; c=relaxed/simple;
	bh=6J2h3bOqmj4OmaT+fcLLCYVPX2DRmbbmocASOp/WII4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=khVcG+sKP6L61SQ81mfpNSSErxs2DPvVyoGPGkeo/cjYTBOxkCA8eHFked+OVNGWDVwC7dbBkbclHhq2uVuYJpg2VVLHMuJ6wF2diih90mYme8VQm4OBPLcU19KcKZgs9nC9tESKDU0USAbPfj31atGWmpb51TrSa9Xiaiksfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Xn93h2kL; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Xn93h2kL"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EETKba4028387
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=D596QU76Zwi3x5swVX
	nkDy7gYMxvg/feyxcKGDTW/qA=; b=Xn93h2kLkcm9tV2dPEFROHr1/0jU5mN6rd
	We51n/83SSc/R6HpfWxa8L2+eXw4yS9g2cgxnskM2o4Uw4ilPJp3Y2hJKR4VOIqh
	96MISrcPq0a+gAsndtjnIOVgt/v6cEmF0mAOxs0fDbHSSFN1uGLWOmescy6zV15O
	/HHLZISJF9OFTGA6AXy/tPz6wDjg94j9+TRXzJ55yU6ylFiTO7lxxZWu6lYXlmP+
	dQAyM1nACiJKc+8bsB1fHqHT+B5Uuth6xZlDPzHZPZ8J9PnSWsDLvGqS74RQ1lpu
	ROBDH13a+4EIlDSz9fRwB2Qn8AJXcTC/qxj2ddsQvT7uxG3CsvsQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bp6pwug6r-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:41:22 -0800 (PST)
Received: from twshared25002.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:41:21 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id EF99563A8FF8; Wed, 14 Jan 2026 07:41:13 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <linux-block@vger.kernel.org>,
        <snitzer@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>,
        <ebiggers@kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/2] dm-crypt: support relaxed memory alignment
Date: Wed, 14 Jan 2026 07:41:10 -0800
Message-ID: <20260114154113.3207790-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=GYIaXAXL c=1 sm=1 tr=0 ts=6967b922 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=Y_sEM6iBs9CKCa9LBqwA:9
X-Proofpoint-GUID: OdYdayy7kjDMV4xz8u78DVFzUAqe9TkJ
X-Proofpoint-ORIG-GUID: OdYdayy7kjDMV4xz8u78DVFzUAqe9TkJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMSBTYWx0ZWRfX+EbbBL7WMrXM
 jaIOeolGxMYo+dq28Aav0/Ykba9V905wc2Ns1fDQCm4aHGrlGw10eLH3VthF8hmN66X1oS0x4XW
 mPa73rmlGqvlJFW2SviFcRGDjU5BKTFcbzV/Bxxe43ugDboc8vhh2beVC9mgTpOX3JfvmEeB0wX
 +L9UgPDjHCRh6/wX4vhblLI/33Xv4q7lpt9n3jId/fcBxJOU9q5OubTylKRcBmSdsVkE5jwnWim
 BhThAqBoNug7tfzHow5oEm724DB0CALiMDImirem2HDn7y+OflYlkzbE07HxW440pcKiDZDhx+P
 0Nh5c+YlrarBsgv6re59O91JBNHcnvxSmSTABW3U8ndxIfKdx/ZhUW3ktzk6xw7x+QkA2a82WwH
 lbEW8inpxnBeyOUGBHVZUrvMPmm0G3mOzhcsF2uMkNesUAhDlpaze8e5Eyuco9/enLGUrwAaqvo
 7mmXrWT+mYg3ghSzWnA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct-io can support any memory alignment the hardware allows. Device
mappers don't need to impose any software constraints on memory
alignment, so this series removes one of those limitations.

Changes from the v1, which was an incomplete RFC:

 * A block layer prep patch to allow stacking drivers to define their
   own lower dma alignment limit.

 * Prevent reporting the relaxed alignment for any of the initialization
   vector types that use the scatterlist for other purposes beyond
   encrypt/decrypt.

 * Keep the error handling for data that unaligned data, but instead
   using the block device's queue limits.

 * Use the same scatterlist setup for both the in and out vectors.

 * Use multipage bvecs.

 * Check the alignment as the scatterlist is being built.

 * A follow up patch provides support for dynamic scatterlist allocation
   when the base bio has a lot fragmented segments.=20

Keith Busch (3):
  block: remove stacking default dma_alignment
  dm-crypt: allow unaligned bio_vecs for direct io
  dm-crypt: dynamic scatterlist for many segments

 block/blk-settings.c  |   1 -
 drivers/md/dm-crypt.c | 105 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 20 deletions(-)

--=20
2.47.3

