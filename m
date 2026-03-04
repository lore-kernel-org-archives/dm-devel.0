Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3E735F613
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626659; cv=none; b=VDi5bpCivAJCTm9Ak5IJPPKkfjcCULGkyf5w1Ds0ZoJR97dzJxVltK9OIhXKsqFKbFMmY+XjNIOe2YA1GGlIN2h8Przf1RlL/dlCIyYC2Aek48H+z3yNHZNz8YhnR+CJYFNuT0e8Oa3ZASrhcGeJDKbDeVajJbKN6JAKnO7XsTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626659; c=relaxed/simple;
	bh=BITlx4Kwj5eBbWFc9rslpJa2+01NebOQNTaEdmYUQ24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=msDSYwMeMJhY5eCbi6Rfv+NB1appvdMT4tC5FcPOzVU5lfgqGFdfALKfItzr0HktWBDvYXAu4yIppvlITczLbcr+UhE/jLNU+y9XOv+vxuZLoyb33cBW/aeafQb45B3IfUXNlOuD3mD1gyur7e4MwZjExoI1FScqi4zMP9aUXKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dTUyy5pL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xo60N863; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dTUyy5pL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xo60N863"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624C7WlD3110358
	for <dm-devel@lists.linux.dev>; Wed, 4 Mar 2026 12:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uShH14l/dWy
	0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=; b=dTUyy5pL5dK3eS9CPhL4giyELS5
	cV7sxqB2c+oBOak+3ANLThm4WjU0Hx8IunPjFNxTIevTOIXAGVpBxzUjCafs3HiI
	KFyf+seIdc4WYxXRtT8ecqDcV1B777gDj1WuRLVTO27T0PjmFKTwGMh86aQJ/RU5
	peafPuQqcgSaBaCqiTzWLDxnO2c7iAd7lL0wWx+AfQ40CLukByJ2OEgzj8GHmUOD
	VPZ1JliZnuxPTiN/RpCGG+XsGiE0E/SvNwaiHWPyukJ6oOqTSuXjy0agmGy9MEpc
	CAD4Pb4gHnAiNnTioiY0N3kfMM0IxQibnP8n9HwXkqz1BSiXD7rf7IT+VBQ==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cp5h2b35n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 12:17:38 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-12711ec96fbso107479747c88.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 04:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772626657; x=1773231457; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=Xo60N863eoTT0SkZZbccINgXi+abDFkXmZ1mlqqes5fpX2qc9yxzC2baugbl7gTWhg
         i9FSxhCQC0p8hBWrPpT+nVPgoDW+kGEv0ZPzuonVsf4zSlRtMNcD5KBRSesZM9WbmEfz
         hx8bX/cMKowAruuUqEszh5FEzF9erGqW4SIj4lDoWStQDBF33vB7SQD+NRwb1ARsuiV6
         hnrevxDasfmIolW7SaC8CVesCyRr+702ZE6AQcD5bMZDb69i43G+Gj/iUUNxA1L824ru
         1wIedePiYt/c6wz3D0jNAChlKACuEz8BxQ42om/PauOtIRBqjVamfrmhta4tnt0Ut3qk
         ZlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772626657; x=1773231457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=nXDwfcWhK47r7CM+40aYa5EoQVLtxn7RKcNRAI8VomfRBCjS+CJFED0rcMKr64aVCS
         cUMz85Jh0c/lMu7qLfGssbtGSYjJSJRMylhSBstAKpL6icRSE4pp8WrLiRXAmlaGeHEn
         VyaNQIxWxtAfKH9eRVZaGMSPPTN9jlV2cHA/wvmAHeOpTPOb9ezb7vKSRgovmGh9jNv2
         BcQLQovUlitCUowvWHLSpizGJLaeOIl9qwC9lmVSf1QpRD+uu0yAjGMSiXAcjjyO560P
         ZhJ+ntnToC6NieWAB56XfXGCJzxSJzsIRQqYNHlE1x1Y3Mk/9Zmm82RQyOKCb/gaJSmg
         sftA==
X-Forwarded-Encrypted: i=1; AJvYcCUWWX5NRyJvydYmCk0E+A5CuR0+mRB4kQCLxiaSdrvS8wfos5N95ae6YeKlOCkKtXVZEIHsc/igsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzKO8MaMTBq2jDMiXRrQHyboKzY1sG7bRGDQNe8TpnfSCB9rwB/
	xfpYUqjMvTQUvEPoQxewNPYcEkXHeuogTB+5Ouu8DXyE/UVLmyK8EWzA0xMcnju4ymGkKhWUwjJ
	D8NkgGODgp2DaAHuRGNYjeVPJFEV9TaRQf0JLFpkeZF7J8n+p88idArQeDUGbuA==
X-Gm-Gg: ATEYQzzgk2ZhgAgqS7m+YjJqX3C+7TT4QynwwZg6qeW/qSlHCYrAeMnUPR9tYyJcv8H
	pYK52AsBWPjOo0nvNk8FHkJP/xH9aDvjYaSeAYWEWtBxbsah0K7O2sICkCkqmJCUG+omyAK7kCR
	LJcHRfKu6STGtMQvtI4Kdf5cCUXk3ehrP0EvvLVc6yomyA8DtjltoQiAesBupK/YQIoGL+8KrWq
	kfgNrPcTgJwd0/pZhMClEui3oIDh7kkQYl4ah6yaenJeZfFhGwfwO0TVCTvfonepxTWQL/R+dRX
	e9LiIKSwjjronRzjnCPOMBFa1ZkFzhafQNJs8A8/a7lInftvjbIt+roExLgLZm6wSP/T01N6VH3
	FF16PJcer6RMPHIiUBnsC0dg4WsYAwyzfaEkbORrOD/MF9LHg/XTfTHd4y2NI20npCqOKTp+JMJ
	sp0oyu
X-Received: by 2002:a05:7022:789:b0:127:3480:7c9f with SMTP id a92af1059eb24-128b70824a3mr855155c88.10.1772626657175;
        Wed, 04 Mar 2026 04:17:37 -0800 (PST)
X-Received: by 2002:a05:7022:789:b0:127:3480:7c9f with SMTP id a92af1059eb24-128b70824a3mr855137c88.10.1772626656661;
        Wed, 04 Mar 2026 04:17:36 -0800 (PST)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899dfc47sm22171276c88.6.2026.03.04.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:17:36 -0800 (PST)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com,
        israelr@nvidia.com, mpatocka@redhat.com
Subject: [PATCH v1 1/3] block: export blk-crypto symbols required by dm-inlinecrypt
Date: Wed,  4 Mar 2026 04:17:26 -0800
Message-Id: <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=JqL8bc4C c=1 sm=1 tr=0 ts=69a822e2 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=1XWaLZrsAAAA:8
 a=pkKqxYWgxMMasECMkqIA:9 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: _bQuS8mUBWLjStvfbzCtwYPYqQKlHdS4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA5NyBTYWx0ZWRfX75vIZjAdiET/
 diBIY6+Gw8DcNMqKYmnsgRdpru1sWF1rk8PE01td66p85u6CqyjELZicPABQjy4zxcpUU2NwC+z
 3md6m/ADafMA1vA6xsj6ru2JkJUXsfRxfFhqbaSPdIoL8G8VOBCXie6od76qsOeX4uycTnVXcDS
 i4k7Tvcmq0Qk3F4u0zcCJS0CVAffcCEq+N2ekRm9M9dkY6wxPRZ/MGv0NiXuCCkYP6fWV86zoAN
 XizaEW+meFUYrsGCo/9n5Lw6XttnVlEXG/UqByrFZ8Z4teXzB2vrDPbBuMP1Tmm3vT61PrU0MN2
 1zJhxsZIs11gUJoGrDtGucfMNZewG7dAnbL8doGRgJtBYsTq5a4AXedcktcLXw9nQwK9O1R/t06
 7qeDUXGQ4UOXI1P9umnhxHl5Z2TlS/rofuCYpy4xDV/trSkk67EJER+w+uZNqb4B2qU4cvflRvq
 8qfToS9xFiep2TPGvcA==
X-Proofpoint-GUID: _bQuS8mUBWLjStvfbzCtwYPYqQKlHdS4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603040097

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

