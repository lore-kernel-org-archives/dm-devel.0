Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532233A7828
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777542773; cv=none; b=OoMT0Np+RGCL7h34ei/NpCx4J2r0HS2X9gpQj+rHXrFW702bp+qZeXty+hiayO1zlK8Bl+fu5l82q3kp150esO8x7483YLUpuqQTpiWQOjl1XN47XGJqMdNKoqjd+Asu9tCsq350tYUYBauqZ4rSoxAxWfkBS+mSG33OgIf2vMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777542773; c=relaxed/simple;
	bh=CoANQFi/ZRSYrDmCfagNQeLYrej3VKmj01BVzyAA9A4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GziZ+pnaaQ4NLbHt2QLbaYHylO/ZEY4tgR8Ks1BlA40LvHLBbXu/n9O/XZ4IYNNit08KzQG5EGMhDWFBVT8OKUu2NUfbFRRHSnoScTq64huMWoMY37OjdhXc9pq7V2EaV+doRkb+OoJAL+zW9BFNOij1G891YLRz3t0KqQfIFP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=or/f1GzC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NbcCMpb/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="or/f1GzC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NbcCMpb/"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U8LK9W3732419
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=x5dTUSOw7H9fc6JjoGNbvk
	QWENZ5Gggg4lfoTXgZBCs=; b=or/f1GzCqdGc/MQqLsCodCvWaTWfV6IuhnDLHD
	4S2Zf7Gd9Mg5Lup+8eWRqXr7SAim+HTnIx+PZLjevs7wVxhEnTyT20ky1WGsZw0F
	2oSb0E2Lqg+XRk8YTGwlNL5yl1DYIIecQr4WzUeKQiIzI54kuM+6N8VUP/ECBaXp
	9MyGjBz2usBz/rV3wx4OUJuou/a3dGbKIIOtFg+ZFAMFrifBb6v56gW9pdaLB4cP
	95g/dJ+xDH+M80Y7RqEsvNwcJM8h9EdJyfynNwbdVoLYuPuO714agRXrerQwyjJ8
	nwtLBVnsoiP2/e34zwwB1so9NrPY7wMAMexrzUTS2j/JPu7w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duv3x9x5j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:51 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2d8a677cdfaso778894eec.1
        for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777542770; x=1778147570; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x5dTUSOw7H9fc6JjoGNbvkQWENZ5Gggg4lfoTXgZBCs=;
        b=NbcCMpb/rm6c7Mp42srfmRMpp2liXl7B5Lv2v2abZbWsYN09MB3UefaRAlq7+70ro/
         Y/mtRBidqDA/9c+7m3WYVsvpP6aqOKr10uH0j+zObkVSooTy75ThmO7YUsHJgBYfgHRJ
         HGgHyaEm4oYlT9GyYf76wfc+RduTauVn4HlMXp2h7BYg9iwfZeFaAVuWwa4sstAFQv7V
         mTjM+yc5b4l346XnIIfMYDoGb9dCf8MWL5StiSk3tcASyFpCKR9bVzOHf7HvXuk+CJAp
         8TeuzShEYd1Bdh0NV2KjefLV7h4H+jDE5gCZVtc7APH3vyVJgTSz4Typa8IcqnjUw+TN
         CW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777542770; x=1778147570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5dTUSOw7H9fc6JjoGNbvkQWENZ5Gggg4lfoTXgZBCs=;
        b=Je0ABdfWKZRwEQeawhyNxUEg1dW1L6Cej5WF3dRn1OJGGiko7K5eTDJDZZPxofOP9L
         PWdD9SufpxxMmfqnJiKjIbAls+iTByrg26oS5CaBDeL/lrBparpd4XQEsb9nhhIhMtL/
         pXtlxZq01iYBno8Abl/v2Re7MTuY/KjjPfner1ecmljJjAUrruXhT877SXAliBugzKIF
         HdpUnJ3RluhyU7XaZuOt8M0lxokaVlkqecagnBknewqNEejLPJzCMdptYx6xG5yBM7tj
         PIFvvdxVt36qWKjkt1EGoxqAk/sXGaT+XE9yiG3Pz8gETUnKUfdTLYIZXeiEOaphWH5e
         Z+/A==
X-Forwarded-Encrypted: i=1; AFNElJ/NBJBxxAvVgW+EpGMIAMJBzY6HefSzOb+cJwEIKp2KKIis5HmEdX8EaJDV8/MVZju2Z9tvqJnhtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5D5u5tPSy54CrJi7yQZyZKDGGl7gEryxA+j8WlBV4vLbAlhsi
	0Xu3TXtzUEzG1ee36+B9R7ohsTXr+bsiz9dvubMntUZ3icEdonE91wV4WnXb2RVDQrHwDVw8NdF
	2yHi3756RVUD9781uECU1Lx9OAnrvXeGzam5nYu16fRBsr6e8J6hG7D60P9mdHw==
X-Gm-Gg: AeBDietjfR68cJ7w/m5zdivbY1R0Fw6kNomlZbTyZQIVNDBLFEdprLClBakUAZnGbjr
	+GBZgPS/ntYHyP++kSrFXFTJ6AEYPQp3o89wmY03jfKQO5mlCN8Gtvx+h2d9g+LoN/hsu0wqEx3
	83DpTZGp6nbqSQQ0UugzsN3l+rJ4kHvfyioNdvRSKQwwTwRbAWoeUc/wTew/zze5tais2ZQUBFb
	i811vNgEIEuqHjV97Nj61/dcjA+sl7dXb2GC7pfeMwA2r9x8GhqO35/tBeRGSt3jn8kS14e9lok
	sXnM8E0hwydz8Fjjv5FgxYpoDSFYD09kvRVsXVmra58p/8ormv3EqWgPjjk5Nswqu7rdQB2/pTW
	/2wlYLh7hlnkiK3Dfa/CnEhRZmS8bUe4iMC+LyFEfb5pGzawV0iLDcUpiJ1/FBuZuWDPlUuNDE/
	mNkp1Aked3VV2mISw=
X-Received: by 2002:a05:7301:5809:b0:2d9:6373:ad24 with SMTP id 5a478bee46e88-2ed3deabf15mr775207eec.26.1777542770264;
        Thu, 30 Apr 2026 02:52:50 -0700 (PDT)
X-Received: by 2002:a05:7301:5809:b0:2d9:6373:ad24 with SMTP id 5a478bee46e88-2ed3deabf15mr775189eec.26.1777542769667;
        Thu, 30 Apr 2026 02:52:49 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c0d218dsm5885804eec.27.2026.04.30.02.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 02:52:49 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, bmarzins@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v3 0/3] dm-inlinecrypt: add target for inline block device encryption
Date: Thu, 30 Apr 2026 02:52:41 -0700
Message-Id: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OSBTYWx0ZWRfXykUwNTsOu+HI
 ZMAQMZPDvwTe8dIlD6b7GTftXBazuD+vDHWZd1jKswTbalpGOS/H92eIJmikl/Eq8ZJj0xAD65m
 qtWcBUUBCvDsivsD0mx94CkQ/bRzwF2I7P2nDwgP/OtIdT641Ib0BPFfsimPFDRxgPqlLS7f8WQ
 sru/QiwgQbYgKp5j/lbCvsWeNUaWt5cujijf0FEvP0mUnrgoiALmdxWR2u7lb27wtyI76czliY7
 VKefwv6lqdz/aQZ/avlVfyPYBxHihxNaqsVi99O7RC0AZmFRwnBB9gLBBy86zGChD8Fb7oRuqep
 aBkkNlVdKIIEWpSiicUXb7iy7AfsBxYlnB6uBfNxxRivAmfzeavVWthlkBoGjtj+M5hpzPqfoRs
 XAOHYb9tqHQfHs5AvdXfxRtcCjpfFFg7tTuGJQRsmRa7knILFLilp1Z8lr0OdcX7Y/8Pe3STUsk
 aeAJA+isoZAiJsgDK7w==
X-Authority-Analysis: v=2.4 cv=Oc2oyBTY c=1 sm=1 tr=0 ts=69f32673 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=smb5OZ6KEkrD95H7haoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: Uh3P_3KFpntFgqGszFTxFvm6moDqqIIJ
X-Proofpoint-ORIG-GUID: Uh3P_3KFpntFgqGszFTxFvm6moDqqIIJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300099

This patch series is based on Eric’s work posted at:
https://lore.kernel.org/all/ecbb7ea8-11f6-30c1-ad77-bd984c52ca33@quicinc.com/

Eric’s patches introduce a new dm target, dm-inlinecrypt, to support inline
block-device encryption. The implementation builds on the work previously done
in Android’s dm-default-key, but intentionally drops passthrough support,
as that functionality does not appear likely to be accepted upstream in the
near future. With this limitation, dm-inlinecrypt is positioned as a
practical replacement for dm-crypt, rather than a general passthrough
mechanism.

On top of Eric’s series, keyring key support is added in dm-inlinecrypt. Thus,
both keyring key and hex key are feasible for dm-inlinecrypt. In addition,
dm-inlinecrypt.rst is added as the user-guide of dm-inlinecrypt.

V2:
https://lore.kernel.org/all/20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com/

V1:
https://lore.kernel.org/all/20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com/

Eric Biggers (2):
  block: export blk-crypto symbols required by dm-inlinecrypt
  dm-inlinecrypt: add target for inline block device encryption

Linlin Zhang (1):
  dm: add documentation for dm-inlinecrypt target

 .../device-mapper/dm-inlinecrypt.rst          | 123 ++++
 block/blk-crypto.c                            |   3 +
 drivers/md/Kconfig                            |  11 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-inlinecrypt.c                   | 596 ++++++++++++++++++
 5 files changed, 734 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
 create mode 100644 drivers/md/dm-inlinecrypt.c

-- 
2.34.1

