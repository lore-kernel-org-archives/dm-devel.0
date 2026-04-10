Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383843C3BE3
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828441; cv=none; b=eqZL/9sqMU+wo9NKFfkMYWvvXe6Z13wqJ+S2lIGI5ICFpSDF32Q83PofTgD3UiIlzIHvSfmwiItiGC65z1ltmKpvNZFzi0H/tsV2snLAi6Dm00sPW7zRvSRId26/tvGcXcMU8j2t4HbYehI1LxRyavXLOsI9c4F+8hvPOcFqx+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828441; c=relaxed/simple;
	bh=ygr8IdCVYJdg1rFWduE3xozN3cdoki6W2GZtEW+3QJM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=tLjusu9u8HciFfh3N/UeqCO1sdAfgIWzXhJ/sEEGwz0CZUIn3+++//9YOixv1NycT183T38Th6LDjXBDslvjpFLmNirlhDz/BE8xfBqXlU9razuLBPv9Z5EYCvtxbnlIM95+E3CacKkmULHXkrVbpdhhLGSjG3NO/EEjbLIPveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EV2FNKFs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jGV+l4sF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EV2FNKFs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jGV+l4sF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AA5cAA1498620
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=m16vhmgnCSFatiAvDtIxey
	tz/B5QbIP/Rrl5WhPxvz4=; b=EV2FNKFs4kuXtZPb3Mi59rmsWSH3OQB6gmtEmX
	7Wc/E908AQipsAwSwdwpamibO6LsQJKHwtqYwo68jC0+V2YPPaVvpdnh2xvY1R6T
	tUdUvwX/EDBiV8gaNFALq+VRX74DV0Lm3+2P9qPvVGLGmPc4aHTN4nRWY9ifwM61
	I/oMWjgZW6i43vUUSTQ63fUgWrSW6KK8c/OMg1Cpgay3pdIKMu9OjdeFnzat9uee
	TPhcXyI7ZQEpiTSq/jklk9hsMLdFBxq2MZgikD1z2xGWSWdnTFr/pl3/VDgv5x7W
	wc/Mu1LAp90zW2EZy84TeOl//1eX2GR3e9ZykzjluzhK/L1Q==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dey5b0m5x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:38 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2bdf6fe90a9so2816849eec.1
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 06:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775828438; x=1776433238; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m16vhmgnCSFatiAvDtIxeytz/B5QbIP/Rrl5WhPxvz4=;
        b=jGV+l4sFOjqQUYQW9Bw6vPbhf3UMx750nldHGz1V05D1E+MdYp4fMxTCIAQW7NkCEw
         CZZ67hGvHtynAXSB7oReJCFyuaUiRjsVd+jmOztnYqfyeKSmwMUIjU3SA4jvuIjAczMR
         xrEKvwa1rHa87z6XTviciwwMlr5en2Ixo4Uh86e10c6K+mWFXzr/xFDQzEgSMq4f8GzE
         i0f3F+0IClQyjugFnYejboef3vu1JAB8yG3BYRPsZ//oF/AEA4JRos8ZT+ZJHSAMtUqq
         uuSzSNRAGhY/YO3Nd/f8z0sIJMjWTB05fqE9KaTyGQmmwpNuA8fKSGUOKNhFLUn7PQ5X
         sVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828438; x=1776433238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m16vhmgnCSFatiAvDtIxeytz/B5QbIP/Rrl5WhPxvz4=;
        b=AbZTg1a6K9H/aLr/1zIP0F9Uj9XV78nck91+JoNB4o48jHkfv1ZbpnZJnIxCG9ZFlY
         vugeBlKyXTOh2lf0nCRSBDJJq8rc/JCpzu12S+xomnqzLMnqU1o5+pN/KweSffrXo6gD
         cr56simr3JdREHXrAG7LqtSlgn2aMy+hqY190Y9sGxacJNKJWGfSEDPia4jrdYXLyF1I
         5QPZSs0FtF9K+aFKkNUOhdVnGIfJsAM8kfMBJhOQGngW1URFR61fdkdLDcu29kSrRZa1
         q71fm/I8F0Mt278uhQ7hZHMQGAeseeUVSoxaPFIUuq3Bz3mYN21HOf2wY2u4hU2z2hRI
         lPHg==
X-Forwarded-Encrypted: i=1; AJvYcCUNITO/Bx8sxg20I+PXYfJ0Qy939WtmcDJeIza5EWLpgnXqDIA6LOg4mX3LMdGkdtK9YhAn1xjGOg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwY6Iz/Jy9ue/ng91+KgWkVqpm2IPkLrJKp58TCg2+5/D13PUFx
	XU78ysECKkpQbxDeKhFXn/GWgyZ8fJDGrYZLVJV9AmBlbQRkhI8yHJjMhPWknrpoHB8PdEF4bDU
	sfeLq6T6cWcPaC33cmdL5m1DR00V0a9rI9xhnXVJn8GlL1rA2K4GKYi5Uu0hZnA==
X-Gm-Gg: AeBDiev8hVHdS0NIs1xRyEzDETBtZDAARx7F1KslYuGppc1RwSP0xAsc6k3uCkYDs3o
	iKHhLnj8vw/rpex026XU5R9JiRYSSyC4/sr7Aea/Nr3LoWnl+NVcRXV7lNpG3cFEq3+V8siRiMJ
	NWVaths0M9NqAON6tFtshLz/W8IMovWwDrMvKm0aN18xvWPj30hr6VtMcLxva2B4vFRiy8TEDOm
	BAGBkK6M7cqAcBp7J1tyVSeViPJcKoAosHWZAAfVEtMRqZ/NTaicbIsiEdFdUQyMKbERpj4MbJA
	rqgfm7On2rxrjEKNBMmgZLn4M5Z9y1Sqh5lzqZ+qDNxogLnwsY4KBB261YYARRRtdyD2THIIWe2
	VvtUeT7KJeaRC0Y+OMSUu+BtA4q+5vDMk8rsgFYgOOTmn/90bsK/kcQq/pSahrQrlruSyWAcF5O
	xkZnRS
X-Received: by 2002:a05:7300:80c2:b0:2d4:7656:4ec1 with SMTP id 5a478bee46e88-2d588e84919mr1689001eec.17.1775828437747;
        Fri, 10 Apr 2026 06:40:37 -0700 (PDT)
X-Received: by 2002:a05:7300:80c2:b0:2d4:7656:4ec1 with SMTP id 5a478bee46e88-2d588e84919mr1688976eec.17.1775828437148;
        Fri, 10 Apr 2026 06:40:37 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm5172631eec.15.2026.04.10.06.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:40:36 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v2 0/3] dm-inlinecrypt: add target for inline block device encryption
Date: Fri, 10 Apr 2026 06:40:28 -0700
Message-Id: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: NKMk8sCFNglDl-4zgTbyFUVPbX-aqcXd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEyOCBTYWx0ZWRfX+/M11W1eunyv
 OCxr0QcALGc34oXyhUt48+0lbLoi2MSMOKVm/S8sT6TgLAmnmJIUFHEEBO5F9zF77NXWefcb2Do
 nMRcfyUzjvBZwniPpUO+jyfp10E/ARk8M8ZHeJ3XwIfLrgFB+iRwdOtwWrmAhwZBb1MJT7g2Zd1
 9gnYKew8efQg+dzON4kavWgtbABDDt+D3HIlz45oDRmoWVYapC+7vLv/WhrSM35Vn5H+IJYBKKg
 7vMUoAXfEabjUJ0vEYZV5axUV5gJ3k7ynQETVfNoAk7uAAcPc87AxuDu52ObdvnPDXVqrw0egk0
 JXKRz8Y9c3K/70eUGozjphDUSUBpUB29oC2UhYi3asYmBh7QXyTh7f8NwKuNYhSf7irhuQcCDKU
 IfDH0tg8dliNdWEUdEbpHvZNeqPyYZpNH54ZZL/eMJkEud2i4VN2sprjRrpm7QwH0uPfYefOvdf
 wxlRBR0QZa5Clzp+JWg==
X-Proofpoint-GUID: NKMk8sCFNglDl-4zgTbyFUVPbX-aqcXd
X-Authority-Analysis: v=2.4 cv=VsgTxe2n c=1 sm=1 tr=0 ts=69d8fdd6 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=smb5OZ6KEkrD95H7haoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604100128

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

V1:
https://lore.kernel.org/all/20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com/

Eric Biggers (2):
  block: export blk-crypto symbols required by dm-inlinecrypt
  dm-inlinecrypt: add target for inline block device encryption

Linlin Zhang (1):
  dm: add documentation for dm-inlinecrypt target

 .../device-mapper/dm-inlinecrypt.rst          | 122 ++++
 block/blk-crypto.c                            |   3 +
 drivers/md/Kconfig                            |  10 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-inlinecrypt.c                   | 559 ++++++++++++++++++
 5 files changed, 695 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
 create mode 100644 drivers/md/dm-inlinecrypt.c

-- 
2.34.1

