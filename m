Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962F3195F6
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405814; cv=none; b=NOAoh4LTKaN90BqJnwwtdwLG8d11WT6lKOtghwo2s058CKCovjsTgj4mzCw/xuqT8MRy/+X9zK3dnNd3C0Gi/6vWwwPsdeNg3VoU6VB81Mb5FP4ex2FuUE0M63DbZKlrKRxWL3aHmDNf4qI7BO/T6G8C9ol7Xk+VCqrzzfGrFYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405814; c=relaxed/simple;
	bh=byKDfj6MCdpyXcj4HHf5n+mXU1PgMHXT1im0hS+v5bQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ti+ARthf9ai+tnilUb6pSDjfLG5fPmPGbWXIW357Yhzk1xmvlXjXIyVxl6r6dqvuZ+VmPUvphUyAuaY4trT/gB1aiE4wot4sLmfVHCP2bnxnOxDUwqoedrfDRhisydDz3M8SoU98iBheHtidfnIJ0biHKApZSJBOvt2SBRZLSHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LAa14FUG; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LAa14FUG"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EETCIh3185095
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=nnZp9YpASQ1OUGLyup
	A62bMs4vLdr0jc5gOwcDPoE4A=; b=LAa14FUGkehRub3u+28jpMPogFZrr1I+k1
	NTq7TFAdOvQV5MgVkRwUy1UzXsxirLXnS8Zc1g7Vv9VdwzcX60peR0Nw44zMFPAm
	6u37RYF8H2pDRzJC8OvJOLeAeoezxsa+KedysETMeu5byjZP5D55jKd51Xmn+G8j
	LukrgT1pAyHvpZpyCNsLVlyeuNQw2U/fnuL4RxChOBS6Pe3L1nTEJyRdhGUi0ccT
	YX7pdCZ8yUHidd4TYNR+NWDpfTbDRaOm+uOEDDjLchlIoW2Br/TOmAta9F4ECDaJ
	qCaPVf8QavgFGoRv3MpRuDimCmQxOFvkL7Im3P7h4d6ZmgpUP/pQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bp0fy5s5r-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 14 Jan 2026 07:50:12 -0800 (PST)
Received: from twshared26871.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:50:11 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1408963A9E12; Wed, 14 Jan 2026 07:50:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <snitzer@kernel.org>, <hch@lst.de>,
        <ebiggers@kernel.org>
CC: <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 0/2] dm-crypt: support relaxed memory alignment
Date: Wed, 14 Jan 2026 07:49:52 -0800
Message-ID: <20260114154954.3282207-1-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=R/kO2NRX c=1 sm=1 tr=0 ts=6967bb34 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=vQmTTPZ8llsbAUrI6W4A:9
X-Proofpoint-GUID: YWsiDbGTVQjfGtHb2adXjSJ9zI8D6fvG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMiBTYWx0ZWRfX5eztzUIJyl7f
 psokhqM43+Pyg9V+WHKBIdzsCWRdY1qH6drh2oG7/tsBuM2iV5gKvzVIMR6dxaBwOdgxjNXrFSW
 2T6p1qDvdy7RbA5dBqisvrD/kHrlh4cHG6ifr2jM34tP9UepIHblNXxh1Kl6if8fAvydddACx9H
 tvoAQvrqVQahrnzJLXzIGrUTIuuXfrJC96F4uTsmwbwl1NO4nRJddnJ5d6PzEolTbo5HvoXfdB/
 rUBrxk7kq2Tv4yo6TZ91OTlqnVsIZH8w+eVyBziR+WEXcozAtOE14XK7gX/Rk6nJdrAbE6PwKB1
 CT3LQ9Gqb81E5qbUXUysOZeiEplk7YDGwHigcqka6xM2mE8XOpH7cHOvxJLOb61gD6cYPAtj1Fr
 5spVhSg9zrsfb3vGz9m9qBNzuSoiGx+Q6OuEZ1oIjkLw0CZRiZ8QEVDG6xeH0wkF2rleZVMPZM5
 jpp8mMVlBOW0ZtUMKyw==
X-Proofpoint-ORIG-GUID: YWsiDbGTVQjfGtHb2adXjSJ9zI8D6fvG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Resending as the previous send was bad timing with the merge window.

Direct-io can support any memory alignment the hardware allows. Device
mappers don't need to impose any software constraints on memory
alignment, so this series removes one of those limitations the dm-crypt
mapper.

Changes from v2:

 * Don't change the default stacking limit to allow the relaxed memory
   alignment requirements; have the caller do it instead.

 * Fixed scatterlist memory leaks when handling the case that can't
   use the inline scatterlist.

 * Fixed segment boundary check to use the crypt_config rather than the
   lower level block device's dma_alignment, which may not be the same
   size as the cc->sector_size which was used before, or the newly
   enabled 4-byte alignment this patch set allows in certain
   circumstances.=20

Keith Busch (2):
  dm-crypt: allow unaligned bio_vecs for direct io
  dm-crypt: dynamic scatterlist for many segments

 drivers/md/dm-crypt.c | 114 ++++++++++++++++++++++++++++++++++--------
 drivers/md/dm-table.c |   1 +
 2 files changed, 94 insertions(+), 21 deletions(-)

--=20
2.47.3

