Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E0A3FB074
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777542774; cv=none; b=dWdGz49c/KKSE3PSPT7Jj5Tw+Xy/uiqS2Tq7r5fwQ3lcG+77s8X2GMHu/U0zCdqmYpOALkL40ulj4Cv+zh4pIqu5HADKlt8hV9NSxskc0/D8fG2QCS+gjjDp8ebw5bO+jR6RmkaDLqJb5zHikur/ZMGkw5oN1qcu62iokFuJiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777542774; c=relaxed/simple;
	bh=BITlx4Kwj5eBbWFc9rslpJa2+01NebOQNTaEdmYUQ24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FG40yJ1unVw1mmIRNrAUwQd3i+ehJutoI+WUCHOv56K7rKbM94uwAydOshTQHSV1ZHyVzpNkHKx0mLQ7dfeXp20b+S6R6MpLg/yTfIHIgcaLzO6G8gqrF/11lETiXbFIt1MsTc0QmC36HE9rD5B91t2pg8P+XGNfA5StpicVX5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oSbuh1pA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dhoFZFQU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oSbuh1pA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dhoFZFQU"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U62bdI2534299
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uShH14l/dWy
	0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=; b=oSbuh1pAGJ91dHqjDfdkld745fk
	rJ4pwOX/oiny1ZzD4IXWlYfluSgA1pF4Q5mFM3L9Tt0HSeokdiHs2e/2SbAcXoJe
	+fCh6ZZxdFzMx4RpQ0XkG4nPMDV08lTngW4b9nOg8sEcwaNI2dKYaPMV2e+ctWOt
	aVn52BulA0gMpQa8A3F9/P4f5YNA4LZKloEY8IKjN9do5IAiOFMdT1wBsnevATy6
	zudetqWzgAaNi91otASJJvpg1OvxzONFfwWE4IbHFQaLaBo3Iq08aJR+AriRcjqv
	4vozA2t8vM504AGBHfgJunANPyWpPVHiTdOGkjb7rcl6C5o28JwGOXaIb6w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dupe932g9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:52 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2bdd327d970so480536eec.1
        for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777542771; x=1778147571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=dhoFZFQUTysH95ddbFQbZkros1D03F9OI1FGbt7OpDAToFlElRvSRZUNjBJ0ByKW+c
         YRHJICfH08pmyYPdQuYc4vCiIZpvcfMJ02Sg1xW9RqPE/ZPJSRTAUtLdi6rYpFVUy50W
         P7mT982GqEqJ/uA7Mxbaj0Zu+vXsQ8HdbjvfErEFlnYiX9xkE95ht4zj4TYAU+ilite2
         qg1+G6jLwAqRM5lKfsSCUpJs/jx6YurmZA7Y91vLCwkg0FFQoLiOQHRwrXcERePFOMEJ
         JSTMVoYo7QMiaBZN++m/pIzzelzpe/m2FOPVill0ArATfmy4jrzzDoNCwxbYdd+q8Ve/
         2Adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777542771; x=1778147571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=m++JATJwJ76i+3Vbay8Nd/wAPkOn487Hx9e9QyMnH+/AxyujZwq1phkpICOMYVTUzW
         cxIDHMbA6abe3HKesr6ywn/c9LmDn9Gc5p7blntzve7FQuXVwb9mbDuOn66bjYkx6Nbk
         bKlsdMOfUrvilRPq0LxakpzOG9U0DxffOX9DCgNqOuE6fNEZOe43uXR9HcK39YoyCjLx
         5o5QYHQ8Trv26HakOjDwpaMr6rWwlvCIOp02ZUqlHWf/tPEcp9w3CShFcJSJgvRltM2W
         Fgsney7edgvvVkPBNbyAxYfyigz+h4nsFxKBbkFCS+x7N5KWPjIM2gibDCVF6VHpgeBL
         p3iw==
X-Forwarded-Encrypted: i=1; AFNElJ+IaMbuLtpuglBeWF8QzC9VyWPeGTf9qcYjLJGzgpQDQDVlHOmD0Xeyftj2tk0HGIb38kWdTNEOaA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTxBs/VHoZ45Xc7F8gVac6E/A7DaRA9SuTaIzQYw4+cAXitpaU
	FDakkn0fa2wAhAJOkXqPwIhcKE1m0htw9lxCEsPzXeJUtSKKnzcl2sXZ/zJQQWWEF2zoPUOwBPV
	bnUu5VxFpL+wTZ69emt5in3HoSD+NbV94oj8GPr5gSGhxG6mcqYLqKDdT5VglAg==
X-Gm-Gg: AeBDieuV5141aagb35bxEIaO9D6ouB9U8OZR6Kh4j9BcWmPBqdbGwlCycbiGbfWWqWA
	lEIkzp2Sj/wl4f8Qzdm5pELjEoqMtcxivvFkA2YLZi1kTFpoX2nD1DD+/MSwfoGb++SMq3uSeER
	PJaLBIVPDIcTkwFjnBLYSzL0Ry+ebCPuk3ZSssrX4B3IFjz6kZ1B/gIHjg7juX1NWPriMIct0mE
	2OBYc49QzosRsssXmhRNNGaVuIr+l6N58F/5KYCu9bjntxXLnGbggRqZAEN6IMvSQdSaKxjzq2t
	z/Dl+dvubmIxrphJ0P/vLGOYbbUWLbsfDpR+BsPC0SAQP9ygmRsKsKAhkOYukIaJqhxCXc3+46s
	IaYelljA7b3PX78Arw6PhLIbECsnrNhznnMb+cuCSqExhlveCuMHWeRyOIYkjIfkCZLmP9sLQaA
	TX+KrOhpQ66n46Dqs=
X-Received: by 2002:a05:7301:3c0c:b0:2ed:e16:6b38 with SMTP id 5a478bee46e88-2ed4f2e650cmr704633eec.16.1777542771171;
        Thu, 30 Apr 2026 02:52:51 -0700 (PDT)
X-Received: by 2002:a05:7301:3c0c:b0:2ed:e16:6b38 with SMTP id 5a478bee46e88-2ed4f2e650cmr704612eec.16.1777542770669;
        Thu, 30 Apr 2026 02:52:50 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c0d218dsm5885804eec.27.2026.04.30.02.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 02:52:50 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, bmarzins@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v3 1/3] block: export blk-crypto symbols required by dm-inlinecrypt
Date: Thu, 30 Apr 2026 02:52:42 -0700
Message-Id: <20260430095244.3352446-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
References: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ChjsHNi2K8tNkbLx7HRIANaYbLtbabsC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OSBTYWx0ZWRfX22uPiMiwjzaT
 2RzIjq41G3a3ztNdaow4wnwMSFemq4u+aYFBJnFwy7liVIMk58vnFg2FB1URQtHPc0DMJPmUTS7
 f2yWhPSAiQtV3WX+85mcas14NQ3IPgKhsThjIqdGR49WhDKU0iuR5TScSgTV8T2Ip8Dqxq/hSzR
 5DL+MumLmA1dhMSoTbavGgeoOtfMI5m+RNuy5onUngcNQaPYPBvhOUJR2o93h/TZmGA5me9wDbi
 Ys1atVL4FiuV9T8L+KnvxOrSIICB43dqDdNOv2VLP4l963/WlI6ZNbHUS7fZ+yh5LzgYkui/oJb
 cutegD+IEOsAylcEVUg8RBBIMAwLcoSJf4OR/1rDICnOp8npPsZ6CkQ2VZmLxDonJ/PJTxtNwd3
 +QcvrX9lEmpep1/u3u8ExaRDRHMmPr+FVmfts3TtM+BOtrTF+OZxxtSBkEE2xjha9YymjP9FgEc
 KGvDyaGHl/I26V5euqw==
X-Proofpoint-ORIG-GUID: ChjsHNi2K8tNkbLx7HRIANaYbLtbabsC
X-Authority-Analysis: v=2.4 cv=PvmjqQM3 c=1 sm=1 tr=0 ts=69f32674 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=1XWaLZrsAAAA:8
 a=pkKqxYWgxMMasECMkqIA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300099

From: Eric Biggers <ebiggers@google.com>

bio_crypt_set_ctx(), blk_crypto_init_key(), and
blk_crypto_start_using_key() are needed to use inline encryption; see
Documentation/block/inline-encryption.rst.  Export them so that
dm-inlinecrypt can use them.  The only reason these weren't exported
before was that inline encryption was previously used only by fs/crypto/
which is built-in code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 856d3c5b1fa0..40a99a859748 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -116,6 +116,7 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 
 	bio->bi_crypt_context = bc;
 }
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
 void __bio_crypt_free_ctx(struct bio *bio)
 {
@@ -349,6 +350,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
@@ -399,6 +401,7 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 	}
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
+EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
-- 
2.34.1

