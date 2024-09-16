Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705B1A28C
	for <dm-devel@lists.linux.dev>; Mon, 16 Sep 2024 09:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477414; cv=none; b=h9Erako0/mU2lt5/Ztt4PuN684beLu2fZ70+S/gn4ZY28c1c3ab2F2FC9pIBO7l4pXPQ0cPRGJ9ZRNc/W1+p6zc6IklnM+6J9tkagSlnFF4IyIFh5OzDWqMS7GSPSE4RH8HsbxU+VgOLbrgv5/9H+T53iqjIAPB1m/UEL7AZ4i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477414; c=relaxed/simple;
	bh=yJDaWyE+xctHez5TzRUkNngyP/Cv5T8JPeZ4t0s/EYE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lV9c+GRMpQIgw6pkUeizhJmwNZsLEIZrkfjpBaJu9w0QtiiAu6WKkqX8IyBr3YPFoIdd+wLIekGMzSEaSWHRYM+IMc7s/PDI86QBWw2Zp6TVmMacDd25kRnSv7owc1guVXV2gTZVXwIbcaJC/Zw9f4z9hy/7gXr0RLe2ZVO90N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=iCNePA7U; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="iCNePA7U"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48G0Qr2N022323;
	Mon, 16 Sep 2024 08:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ucdUq9BZoE+qA79oygzpCCBfuQCsCjujEnF8FPE5/lE=; b=iCNePA7U5HBVUseO
	wkNLCvKZXI67FN8f87SNBFe3ahZC30u5xLCoVuZhyF8d2NHDNRadOprjpJRWW+jc
	nscl532E5xtuENTC1MnhyrZmdjVxFjoh18oHUOuPMZzWAKHoh5TzbSBX2Db6VXvx
	p7fB++7Mm6fE2faBM1C9+YP/m37yrt5rM6urJqNGmwYv5WZ3gbGtzBwyrR6PKAsD
	zeElla9acS6ReUi5BanifXmLpZPwnLrtS0Bsy+5WOLrAV1ztOt4b00aH00B3Y8Hc
	diWHupRHEwpG3WizpSIGnSTeXbZZdg+8j08q1vA24pGOjGspjsipOq12H5B3uhRY
	ymWOMg==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41n4gcudr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 08:58:18 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48G8wHET005029
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 08:58:17 GMT
Received: from hu-mdalam-blr.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 16 Sep 2024 01:58:10 -0700
From: Md Sadre Alam <quic_mdalam@quicinc.com>
To: <axboe@kernel.dk>, <song@kernel.org>, <yukuai3@huawei.com>,
        <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
        <adrian.hunter@intel.com>, <quic_asutoshd@quicinc.com>,
        <ritesh.list@gmail.com>, <ulf.hansson@linaro.org>,
        <andersson@kernel.org>, <konradybcio@kernel.org>, <kees@kernel.org>,
        <gustavoars@kernel.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <dm-devel@lists.linux.dev>, <linux-mmc@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-hardening@vger.kernel.org>
CC: <quic_srichara@quicinc.com>, <quic_varada@quicinc.com>,
        <quic_mdalam@quicinc.com>
Subject: [PATCH v2 2/3] mmc: cqhci: Add additional algo mode for inline encryption
Date: Mon, 16 Sep 2024 14:27:40 +0530
Message-ID: <20240916085741.1636554-3-quic_mdalam@quicinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240916085741.1636554-1-quic_mdalam@quicinc.com>
References: <20240916085741.1636554-1-quic_mdalam@quicinc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: FNt9voizb3GxUjTkHeCzJhGcvKywj3kB
X-Proofpoint-GUID: FNt9voizb3GxUjTkHeCzJhGcvKywj3kB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409160056

Add support for AES-XTS-256, AES-CBC-128 and AES-CBC-256 in
cqhci_crypto_algs for inline encryption.

Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
---

Change in [v2]

* No change

Change in [v1]

* Added alog mode AES-XTS-256, AES-CBC-128, AES-CBC-256 in 
  cqhci

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

