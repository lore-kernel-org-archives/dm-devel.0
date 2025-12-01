Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822427C842
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 21:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625284; cv=none; b=tej2LserwGv6gN69alC2ZVww44jJ9z/YpNl14WHb2LicnyKsu6v5iNIQVvwL5WeS8oPFgKitwdeFLP2CXp7pbZ3z49mRN9RHECEBjF70mJBdVXiz1O7zifnTpXGZFDbn7BXx8+W4SiDRi0ks2odcEakuXgd/6IbUC6x7vZjeJlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625284; c=relaxed/simple;
	bh=j1NU4+NGiQ7RutjyajLr9mG7Ukgl0BNXMrZuBj/dANI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O9CBA/9NxaSFkTnKDpIQoy3CtWX/0EAbFdrOE3L/eAU/HFPSxWPkqCjgszWEwK6RPjE45p+XRnhXLsMJ5iVFlz3HrF8a79mqWb/Oy7TFpYG9jKEJl0kj5DsClruhHqAp62xq3z0eED9pAO1jttljEEG9Qckl+05SujsU37AsXbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=m/c+rAnX; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="m/c+rAnX"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1Led5D1400315
	for <dm-devel@lists.linux.dev>; Mon, 1 Dec 2025 13:41:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=NkTsw9i8Jm1BHcUsDq
	jFFna8TOhgouYji46exI5azp8=; b=m/c+rAnXt9SEu4uIVi+Qu2JaGL8ZHEpsfM
	CzzuVwcy8GBKlLsnM5hd23BPx/KkZfVQsAXJ/be9CYigYO6wMQO5BJRWGx6DKLhc
	IxrU+lMqcjarUGtFRNS5WCWIc2VvvvPqFQASCu08kJwTVL5rO1lIzl6APB0VSa6y
	wYVGy2SrbXvHEIIJ/r9ZiNQkH4IHqkwiK3ebOKMatIWJ0fk3jQ8GMUOKGax8jRkx
	F6UPz3A3g1ry+a4Mct2WMFg1swvfKOGPr9CV325ZzqrtTNYCdBUlPi/uV4mKhRiC
	cY1UIGQ1O4DV58HQN2mvbDdSDc/hOCBK5GgfeLR4e8V8L5Vwsscw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4asehyb15s-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 01 Dec 2025 13:41:21 -0800 (PST)
Received: from twshared31947.34.frc3.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 1 Dec 2025 21:41:11 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id A947E45AA89F; Mon,  1 Dec 2025 13:40:56 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <snitzer@kernel.org>, <hch@lst.de>,
        <ebiggers@kernel.org>
CC: <linux-block@vger.kernel.org>, <axboe@kernel.dk>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv3 0/2] dm-crypt: support relaxed memory alignment
Date: Mon, 1 Dec 2025 13:40:50 -0800
Message-ID: <20251201214052.1531952-1-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDE3MyBTYWx0ZWRfX3LhwEAVcubdD
 0FW3wM50NDsYssZOIfolMPs+9TtCBL0q/32Yny+/iDnlnkJLFoJXnnT9mkHk1in16CxyvpLVWOL
 7zUjdnuhBPXOoR4Fa5afZw3gkqfO1rq/6eOXLYRUOfy8Uh4loOn4IIr1fneNJKcredDzAkcKqW/
 ZChmKDBxMPsJc7RGm51Y2b4zYQRoVQFQDuiZEHtBQsM31EZWxQ8sK40/ivhy9HWxXpU03iJZ7lM
 MQPM2s3j4kTJgJ+lPvS5QgFkvOlQVpBLI8prmr5dTTbNrUX0xVzdjRBhlyCy7lcWbDsu/JGX607
 XfWJ/oZLPj4ACER3Gswz2k1xut3FQTwmrWbRr6XYpNej+4THlkyhBGqJDGYya8o6QTzbdm/E9rm
 fywvD0e/aPB9pAF+cIZ87UqY7VJ5bw==
X-Authority-Analysis: v=2.4 cv=CecFJbrl c=1 sm=1 tr=0 ts=692e0b81 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=vQmTTPZ8llsbAUrI6W4A:9
X-Proofpoint-GUID: 526tCVp-2tOVuzB80WXFIGvVyoqBhY0-
X-Proofpoint-ORIG-GUID: 526tCVp-2tOVuzB80WXFIGvVyoqBhY0-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

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

