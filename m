Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A898719F49C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jul 2024 11:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722340752; cv=none; b=UpY2C2SCg2DFCBtjD4eleq8vIZFnbTsnkZkJ2mdDXbs0S0sVcK9J/SRggOGZdoJV+IWYcSsKSg6yjwkTb+1CaiZxUZFb34FyGkrEDP3r2DEtP5ojnsNe9CrvUc9OMSALw11shVzEZCHrBRNUSPV9Iku2B0DFj9O9V2SktUCO+F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722340752; c=relaxed/simple;
	bh=noNmRl1olX9AaWSb5nGYShX+ZQL73SyQnJ+OGskIxBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSdS/y8AdwdENUitpsN35StOljFreLmQDLMx+dqHBgrRwCRde+A6P+5ILZ3o86cINyNlW8Rv6j3fMsIYOkWDx9u18TLMLgdE8DW+1yfl0k7mKiejGYcCjpgac4oHLVIwsbAlFeClFx8MONhy2SrUMrKnPehlBp980pKY2gjdp4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Fh7VaWs0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Fh7VaWs0"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UAglui012798;
	Tue, 30 Jul 2024 11:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=fv1XedoYePr
	dULPjSv+2+y30VIZcNnYAFXdLkmuC34g=; b=Fh7VaWs0y/Qg5CQU2om8TFXbD5Z
	gmCINTkH2ProIwhq9cwM2dXql2zuUWgvYitcn1QFjwginwYl6vWUCQEUGCPY75mh
	zIrMEn4ZVfV4Lvjxr5JGTNEAslLjOdjWh481ULYDJhwGETfMKNg2ehv7OIUudxFg
	wU9cyTUocd5p8K3BjqijFGA10RSNqWPYIxMQdP8LmHFhypVjhgr2m6hZtdJokR2A
	Oe3Fasbgi68LnImDub+1eT6Lt0DIH1T65jAt/zoGnWJD4SzTUNoYcFZjsB/TRZbd
	lsUpK7G22xAqtxFdlYcrPGoDL+UognV98VmkxQ+/echAe2KVKFNXDqps5dw==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40msne72s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:46 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTP id 46UBwgv3001403;
	Tue, 30 Jul 2024 11:58:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 40msykdx6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:42 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46UBwfuC001321;
	Tue, 30 Jul 2024 11:58:42 GMT
Received: from hu-devc-blr-u22-a.qualcomm.com (hu-mdalam-blr.qualcomm.com [10.131.36.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 46UBwg42001391
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:42 +0000
Received: by hu-devc-blr-u22-a.qualcomm.com (Postfix, from userid 466583)
	id C53A9412FA; Tue, 30 Jul 2024 17:28:40 +0530 (+0530)
From: Md Sadre Alam <quic_mdalam@quicinc.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        adrian.hunter@intel.com, quic_asutoshd@quicinc.com,
        ritesh.list@gmail.com, ulf.hansson@linaro.org, andersson@kernel.org,
        konrad.dybcio@linaro.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        quic_viswanat@quicinc.com, quic_srichara@quicinc.com,
        quic_varada@quicinc.com
Cc: quic_mdalam@quicinc.com
Subject: [PATCH 5/6] mmc: cqhci: Add additional algo mode for inline encryption
Date: Tue, 30 Jul 2024 17:28:37 +0530
Message-Id: <20240730115838.3507302-6-quic_mdalam@quicinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240730115838.3507302-1-quic_mdalam@quicinc.com>
References: <20240730115838.3507302-1-quic_mdalam@quicinc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: lhw4OAtwyQ-gQmxP64ImHtlgUz1rjCFQ
X-Proofpoint-ORIG-GUID: lhw4OAtwyQ-gQmxP64ImHtlgUz1rjCFQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_11,2024-07-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407300084

Add support for AES-XTS-256, AES-CBC-128 and AES-CBC-256 in
cqhci_crypto_algs for inline encryption.

Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
---
 drivers/mmc/host/cqhci-crypto.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index d5f4b6972f63..85ab7bb87886 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -16,10 +16,22 @@ static const struct cqhci_crypto_alg_entry {
 	enum cqhci_crypto_alg alg;
 	enum cqhci_crypto_key_size key_size;
 } cqhci_crypto_algs[BLK_ENCRYPTION_MODE_MAX] = {
+	[BLK_ENCRYPTION_MODE_AES_128_XTS] = {
+		.alg = CQHCI_CRYPTO_ALG_AES_XTS,
+		.key_size = CQHCI_CRYPTO_KEY_SIZE_128,
+	},
 	[BLK_ENCRYPTION_MODE_AES_256_XTS] = {
 		.alg = CQHCI_CRYPTO_ALG_AES_XTS,
 		.key_size = CQHCI_CRYPTO_KEY_SIZE_256,
 	},
+	[BLK_ENCRYPTION_MODE_AES_128_CBC] = {
+		.alg = CQHCI_CRYPTO_ALG_BITLOCKER_AES_CBC,
+		.key_size = CQHCI_CRYPTO_KEY_SIZE_128,
+	},
+	[BLK_ENCRYPTION_MODE_AES_256_CBC] = {
+		.alg = CQHCI_CRYPTO_ALG_BITLOCKER_AES_CBC,
+		.key_size = CQHCI_CRYPTO_KEY_SIZE_256,
+	},
 };
 
 static inline struct cqhci_host *
-- 
2.34.1

