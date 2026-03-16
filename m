Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F89391827
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 15:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773673806; cv=none; b=Tjote54R67AeM3qeEue09k6iMMAL+TQLvuGbI/SpEltl5RqBVh8PMBldF3VCMa85sHkazm7MEBDM+ISa6GdV5pPawB0ZmeYQbGQ/C+2m1JDVe9Ecz84H3ER7+RocKEq0f2wcn20egNFGE2GoVayhmZCSTopQCRLts1AuXJF88ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773673806; c=relaxed/simple;
	bh=zj+GUnHecFvNIPm0U0aGtHOktI/Qo9EggDs0UX0IXk4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMKBFeOmwmvy0zKkmuNWzgXZ81Jz+sX76BzMvDKYGOlwNnj2Rjf2sdeSrh1ihbiQLtO+y/OoEGE4AHmhSCTe4Yq6qyAFvcglAjeqKEwd+5ufC6LHGST9x9eNmArDaktm/XHxhHUy75Jscd1hngPj3ZiT8EpPwuBNq+yoTa75UVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XTBd6xeM; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XTBd6xeM"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 62GElJCb009163
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:10:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=YWnnmKJGVUAKUiPXyW7SGr096KueHVGjY6+6k29jtb0=; b=XTBd6xeMDF0c
	276vqdUCVycVHbeWuIoY3hsc9UB3zz6V7MC4lIHsmPCxzYmWEz3UMaV/GXOzW8fe
	JYo86Qn1hk6WkECex1AUrxRyOXskLLDeScwxlcmT7y1iJSOfPP1OrU4meX8oCvio
	D9MPs7y3QETAemacmDGjhxgUHLTu+/neGpfJiEO/vZ3jeacpkEW9CuVCQj6LXNEp
	vQrMuzeovqr/qQXo7nUpQunyqT7UDXpGI39kFk95kap8laf+whvxjRBqPuUo3Hvy
	xn6Vw6to292iFUBWnxErADcD3S6K2j10ls3y+de99AywkgtfbI4TVKW2+d5lsjfI
	batvt5FWug==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4cxehncej6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 08:10:03 -0700 (PDT)
Received: from twshared111727.16.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 16 Mar 2026 15:10:03 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id C4FCBBA0A80A; Mon, 16 Mar 2026 08:09:51 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RESEND PATCHv3 0/2] dm-crypt: support relaxed memory alignment
Date: Mon, 16 Mar 2026 08:09:51 -0700
Message-ID: <20260316150951.1814817-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260316150229.1771884-1-kbusch@meta.com>
References: <20260316150229.1771884-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: RSh-Y1re1GTioH4XyVTkZz_wCudUCP7i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDExNCBTYWx0ZWRfX57q79W1uxNbF
 irnxKELxUr/3V3MF9T7AO20b5ycS3JEraKXyqSO+0S4P5iVH0wtYg/5Z/FSRkVVaJ7gz3Uh9qgA
 IGL2U6MOt5yPs2Co1gE+lAuDGEbmRUV7qUf27YcxWPjIm3yXlYRxhXqpEWKlwfEqyjW5MKwrgnH
 8AS6m7dOaMOCVQoyBs1Px4xKU2pJ9W+gJii4QvK9J86o0sKrEcxBhIy4ONkzWHVg8hfZQ/6WntY
 A6r6EsJmce8xQWnjEZaDXY+ZWays9pNba5lLgzIPuZgNCGnPMgCD6YLyKr9SsPC6/G3j+8of7av
 SuIA0mtQ8T61C+wXZA3lxk/Ro3/IjHG1G4mrPGEVginMGynyneYWD1VcyL2DZWvleFuUbiP0LMV
 0JChu+SN66SL3iXoruuhdy0+ew7dPBz29jaHgD2YvzYN2z5uYTdC2jDgrVKgxoCOiuXvIjP6irF
 P2EthIzdjuFaHrbUK6g==
X-Authority-Analysis: v=2.4 cv=e8sLiKp/ c=1 sm=1 tr=0 ts=69b81d4b cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VwQbUJbxAAAA:8 a=eAdyUgeKvQIH7_0eDpMA:9
X-Proofpoint-ORIG-GUID: RSh-Y1re1GTioH4XyVTkZz_wCudUCP7i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-16_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Direct-io can support any memory alignment the hardware allows. Device
mappers don't need to impose any software constraints on memory
alignment, so this series removes one of those limitations from the
dm-crypt mapper.

Keith Busch (2):
  dm-crypt: allow unaligned bio_vecs for direct io
  dm-crypt: dynamic scatterlist for many segments

 drivers/md/dm-crypt.c | 114 ++++++++++++++++++++++++++++++++++--------
 drivers/md/dm-table.c |   1 +
 2 files changed, 94 insertions(+), 21 deletions(-)

--=20
2.52.0

