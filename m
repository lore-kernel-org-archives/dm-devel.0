Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503E23A5E82
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626662; cv=none; b=MUcYXQPViR2Hzkp2Al2i3/8gQxTtKAwqSFF0WzhDkljSe4+njlj/eGtFqmCdh69u1HgEmQID4zwARIya3EP4gcr3QkkvunxomQ5qwXLQojKxkNZhlS/PpOQ1Xewn0NanRGOahBgddnbhgKMFhEVJVvNPji76lpU9s8dAlyftMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626662; c=relaxed/simple;
	bh=fTkFRABeWhqpHqR3fBTMOr/wX+GQmnvqFLFQIRi2PB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xcpn1ROH6xZcL4ZZm9hx669EitsqTyrArzc4Pe2gOzqpCJpDtge21ril/lZHwz442GsZsAZ3SQ/srFdTbsltvElSanoqoWQQEtiayKqFMI3IaSGQImVj1ibBpNczlItFb23awB9pUthmeGGRiUwFdkpU/w1E9gshKY34uL0HfLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EgHDJTQG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g02+Zhc8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EgHDJTQG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g02+Zhc8"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6245SP7K1677902
	for <dm-devel@lists.linux.dev>; Wed, 4 Mar 2026 12:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Uhi/pQDgQxc
	huJE4VRIyJvYlAizoY9xEMiE9yI+hg3Y=; b=EgHDJTQG50btnRIpcc8KC9VRvmU
	XTgncO8NzLwx+ak/YN+75UrSgd8fL3olG5w8/YXNWcHIcs6ScZKxUYhIaxKERXY1
	X3uTidXt2R+p0rzyoLP5mXHUsu/NUuYHNMq3OSTwB0UiB5PZxzC9cA8etIgohAUR
	ALECvAHdt3TLByv3jI/juHt4E0ak7bvic42cZra5ld5bISzOt3eZL/yvGNTHLBq4
	LcsAEmKCAXvtzHrANLGP+tvRPRsZE8GUrIkM07g1lBeELOwmlVRuT7M5Jc6AQVGT
	BYL7EAcvCkSJeRLwwePxxrs9nkNSj1vAoeN5wJ8eSWxOtg7kxaME282GxQw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cp73has32-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 12:17:40 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2be21f89332so1866015eec.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 04:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772626660; x=1773231460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uhi/pQDgQxchuJE4VRIyJvYlAizoY9xEMiE9yI+hg3Y=;
        b=g02+Zhc8y90OjC5c571n5GcplPsMVj1blYdfmOe07mEcMx4JxcbbjaYHNrLkn05YLH
         ZaSAdh3fvX8vTCdTc8gPtdLtqZvZDueWCTv5TJ/rzgnWZVNPcPLQuHrsynUGC2CG16U8
         Czoa6XfmSNRdAAWILGZZdeFqqrkawdksmiHlmkDR76j8hK8SHcD3XUnLPBQqiT9QgPhw
         z5bPzGh3mdD02gG+gNRR/n/Xxi0TH1ZJT4nT8iH2MON/VuEFn05hBa/WyHwX9ZumDkR3
         tVrlNzfPi9lmYhi3lwWlpXQt5ykZL/+epnnBAj6pG3YhtrSwmX4bvxcl5NUnpXfRnXIP
         MKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772626660; x=1773231460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uhi/pQDgQxchuJE4VRIyJvYlAizoY9xEMiE9yI+hg3Y=;
        b=ecgHiegZzVlpDA9aQNgeirKA980LonMPbd+BsIbxIojpU5Q/ltPohcLNdxNG9AHQ58
         PGGaC7sfFij22pjQIim1R14MAVhSW9jwPXsWZLwmlkonM9Hn3nU2o93wyDCeTP8m5fEI
         nT4s0zbmwwLBq136c2JdOa9/TR4Usqu+fBJ2uNGPGdd618flcIg51vmWnaR9Jxr2jlBS
         26jiauzGBjJslhqZhsVr2IzF73C+H4jx7pRWr737aoa/5hVr2ix4+KrGuPXbtBRg3T4N
         XvrBDeQpRyfM/ihwp4JqFyorIZsB839b+HKjnzydVOhBlCVGKvz9NVhWZ13HnNr2R0K/
         5Esg==
X-Forwarded-Encrypted: i=1; AJvYcCUO7wCJ4jwrpIw1cT4r1ldVmgQi2D/0Vy73iDBjYcHIhfOqe5E7BChl2mSeu57QrA+P7mG7KdFg1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YyaZWztU46oT+0swvXcwEhNywV4CDtqGvmXaI5FKC/oZP9XVuEz
	8VNFv87bQWTJ7w5YN9maKpoKHwHuyYfHGVNrorEb82Ed6SpCHEC2liTakjXHf5sRBCqYKYm4j+m
	zcJSK3TDUNkeGUHJHSpjUxqOXSSkEb58EQIMAya9bOxSAJV+9VDVxNA94yc1Qna06pZ1/GMz2
X-Gm-Gg: ATEYQzzO2i5+Kf+PKAr8nQb/jGLZa07SApuPs1KbwRjeTPxTxrU4J0fz0+geYzwpHbf
	y2nQnNTXc596UD4T0ic0zAQM7Yhcqlja1PtX0sFaE0S7MIywe1BTGq7k86FlpM8UTNXGj3lXZoA
	vg7pcLXzHN7D6PCFCBTqmF88/RBGiy4BKEFXWzb7f2ntQedgvcvMqF+334OaKQgauSaaAkz9vUE
	jfVg2vO8CD/Pr2o3isWYL3zjYnQQ1Nfa5lI9GXizHmXcdJDQzUXuu3mMdXoIayjScZqpTJ9lRZ+
	9U9SF7nbQAm1WixmEyzGl8ISRrhEFXyUo9DC9AsszbIJegKen2qxJBmg7LONHvoYEprG9NsPZZ+
	EeW+6tjhi4ghqTrRwZ9oUUerF4hmusptZunZp3YaaSWAZlsdb60H+QMk9v1inocWUGzCcYD3xE/
	gCFcby
X-Received: by 2002:a05:7022:a9c:b0:11a:37a7:3d2f with SMTP id a92af1059eb24-128b70edff0mr571781c88.37.1772626659694;
        Wed, 04 Mar 2026 04:17:39 -0800 (PST)
X-Received: by 2002:a05:7022:a9c:b0:11a:37a7:3d2f with SMTP id a92af1059eb24-128b70edff0mr571774c88.37.1772626659165;
        Wed, 04 Mar 2026 04:17:39 -0800 (PST)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899dfc47sm22171276c88.6.2026.03.04.04.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:17:38 -0800 (PST)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com,
        israelr@nvidia.com, mpatocka@redhat.com
Subject: [PATCH v1 3/3] dm-inlinecrypt: Expose inline crypto caps to the device
Date: Wed,  4 Mar 2026 04:17:28 -0800
Message-Id: <20260304121729.1532469-4-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Dwv9sXW7LL0Q0zQ_uAhGZf4dsWB0yinn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA5NyBTYWx0ZWRfXysg6mdajBCUy
 rar1C9kPU6crki68mIJvqcF5cBUW7Mr+ZNE2+bWh3bjOwyJ1aD7ytGD5bWn97Z4wZAntN9VdoqA
 mpJo7hU1EkJm6YbWSjSODT+3uxlHi1Q7HZyu4BtTHMGeG701LGs8U9vaIGm5glxlVo1j2i1GDZ3
 eBD+rg3IkPZfO8UhTK3bkAclAs+dI/9VNBVHXWB249GY3glUw7J5jwYQb/n8imBq6hqPGKBo9zZ
 vOCWxy2ealgviqCU1HDMoIc01LSlM5Ku+bfOIPp5JhpDx3SY7zXuTdpd5NPvWLQya5KbTn5LG4O
 pSPuqYse7Pv8Z+UlT/n2fNK6ygchNUKrT71Go/01n3QOPzdLLFWrEKgg675RVD2MpUMKS9PHyI+
 WtWGPLZjcaiG31RJYADNqqEuBESxpUu7TSggwby0yjdiZWTHD3Ak2zZw7VqGfZeHMQKKZApSYc7
 AQJN1PAClspY+dlC82g==
X-Proofpoint-ORIG-GUID: Dwv9sXW7LL0Q0zQ_uAhGZf4dsWB0yinn
X-Authority-Analysis: v=2.4 cv=BpWQAIX5 c=1 sm=1 tr=0 ts=69a822e4 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=3zJYx2Ns6XLEkWF3d8kA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603040097

Add a new DM flag, which means the inline crypto capabilities
from underlying devices can be exposed to the DM device, and
the DM device consumes these capabilities, rather pass through
them to the upper layer.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/md/dm-inlinecrypt.c   | 2 +-
 drivers/md/dm-table.c         | 3 ++-
 include/linux/device-mapper.h | 7 +++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index 251760da9f7e..eda56893d430 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -396,7 +396,7 @@ static struct target_type inlinecrypt_target = {
 	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
 	 * crypto capability itself.
 	 */
-	.features		= DM_TARGET_ZONED_HM,
+	.features		= DM_TARGET_CONSUME_CRYPTO | DM_TARGET_ZONED_HM,
 	.module			= THIS_MODULE,
 	.ctr			= inlinecrypt_ctr,
 	.dtr			= inlinecrypt_dtr,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7be1d8dc8bdd..f0580935394a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1407,7 +1407,8 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
-		if (!dm_target_passes_crypto(ti->type)) {
+		if (!dm_target_passes_crypto(ti->type)
+				&& !dm_target_consume_crypto(ti->type)) {
 			blk_crypto_intersect_capabilities(profile, NULL);
 			break;
 		}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 38f625af6ab4..6abd1b4fcb76 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -306,6 +306,13 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif
 
+/*
+ * A target consumes inline crypto capabilities itself and doesn't support
+ * passing through inline crypto support.
+ */
+#define DM_TARGET_CONSUME_CRYPTO		0x00000300
+#define dm_target_consume_crypto(type) ((type)->features & DM_TARGET_CONSUME_CRYPTO)
+
 #define DM_TARGET_ATOMIC_WRITES		0x00000400
 #define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
 
-- 
2.34.1

