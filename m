Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA6F16848F
	for <dm-devel@lists.linux.dev>; Tue, 30 Jul 2024 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722340736; cv=none; b=ma6c8bRj5GAXrN7pWGMsGf7AbXq6+v1SWsplcjkwmNwOGxOQvCxzJ6ZAmY6P/kyeSPMpLjaKJhAE7R0KsYQfTdGQfpYOIK1DTLkn24ikIy+4/5PsoSgHBiXHlAcciLJ9FybSeP9bjsPfDzjDg8QA4QKE1qNsYjzGscwJUT4i5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722340736; c=relaxed/simple;
	bh=yKBdz5Zmx9XTlT53m7cV/ZjnWsBQOD52PsQOduj5Wh0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MoXYwP2Tv4HWaBCsA2fkOUNzSxUzAfSZq/+hGOKBNqE/WT8zqvGqoK7XiBGVwY6ld7Jhw6qaQqNC8UHRk3ND8siXDQs+jtBMptIfJP0Hj46fM4Yo23lki3FWl9kpUV9BaCG898uwBQUJzs4xxIrCOQpptOKLMItWK2YrWe+KiY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=b9At4KSZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="b9At4KSZ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46U9wGva013120;
	Tue, 30 Jul 2024 11:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=h+Rc/PWn+N3
	/sHkvf/5fqeZX8DStJQW4ihDR2Wtrys0=; b=b9At4KSZMscZvlfbXGuBFgjaUhU
	kh0dC1H+2SODaWCPqXfzTJgRfCUXMu+4N/QMd7mJWqRoNp+FBRRyKF1XmLPThKbo
	1DQJMuMQT6QjbtfCe1Suwm/TDlLVTHHclcGIg8k+GWV9TQvpUz0F+0WyKuF3U8J6
	MYncFb8M1QoLoNPKSrVDQAE10RXDZALsttB5WAIYGInfPjcc3vs4AEeKmI8UoYas
	rzlWWcksC5sxq/ah4wxVIMBMWeJoe1MG9c/wloNzaiKohOQb8z08o7IzgypOU2w4
	HlRlRHzjQJVJxJeNqS3G3/opfWLhiZp6VNbIhBt2lK5JGAk8uIsRMqtD3Sg==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40mpkeybf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:45 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTP id 46UBwfww001361;
	Tue, 30 Jul 2024 11:58:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 40msykdx65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:41 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46UBwfdt001324;
	Tue, 30 Jul 2024 11:58:41 GMT
Received: from hu-devc-blr-u22-a.qualcomm.com (hu-mdalam-blr.qualcomm.com [10.131.36.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 46UBwfBa001317
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 11:58:41 +0000
Received: by hu-devc-blr-u22-a.qualcomm.com (Postfix, from userid 466583)
	id C173741258; Tue, 30 Jul 2024 17:28:40 +0530 (+0530)
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
Subject: [PATCH 4/6] md: dm-crypt: Add additional algo modes for inline encryption
Date: Tue, 30 Jul 2024 17:28:36 +0530
Message-Id: <20240730115838.3507302-5-quic_mdalam@quicinc.com>
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
X-Proofpoint-ORIG-GUID: 2qGbf_Y2RMaP2ShcVZy_UPIpyMIgd7xT
X-Proofpoint-GUID: 2qGbf_Y2RMaP2ShcVZy_UPIpyMIgd7xT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_11,2024-07-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407300084

Add support for AES-XTS-128, AES-CBC-128 and AES-CBC-256 algo
modes for inline encryption.

Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
---
 drivers/md/dm-crypt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c0257d961968..884cf76fc4c6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2482,8 +2482,14 @@ static int crypt_select_inline_crypt_mode(struct dm_target *ti, char *cipher,
 {
 	struct crypt_config *cc = ti->private;
 
-	if (strcmp(cipher, "xts(aes)") == 0) {
+	if (strcmp(cipher, "xts(aes128)") == 0) {
+		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_128_XTS;
+	} else if (strcmp(cipher, "xts(aes256)") == 0) {
 		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
+	} else if (strcmp(cipher, "cbc(aes128)") == 0) {
+		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_128_CBC;
+	} else if (strcmp(cipher, "cbc(aes256)") == 0) {
+		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_CBC;
 	} else {
 		ti->error = "Invalid cipher for inline_crypt";
 		return -EINVAL;
-- 
2.34.1

