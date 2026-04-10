Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC0B3C5DA5
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828442; cv=none; b=FY7nlaPEg18gHmllVkGeWD/0h9fUMh4fE4szPEKsyrpTlB5dl9FnZNF7JeWZjym+TQCtgTOyup1MjKIjJv+8nYvahk8kVPA7xsUdoMxNy6Re6VjB1G2cBPlkMYWIRkAMDAwBfKdggTxmV9j+/Yt1ZBP0yUmZyVZ7xPpKiQvKkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828442; c=relaxed/simple;
	bh=BITlx4Kwj5eBbWFc9rslpJa2+01NebOQNTaEdmYUQ24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oefoLe6AwVYVgdGGZ03H994V4zNVs7+WNStoxonY6+vBbhwS/hu2KqF8BXVup1ZLfeYCuFqPDxac3taestMvLTwkxmKX6thXHzEEagG9FQ6LtmezsLo+sDaiOnsregRJSu/V7LWz1NPoHAvqC5INi33e1hrQ0wGn2ib6ggy+8yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MI9z31Du; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fFBhuXsM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MI9z31Du";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fFBhuXsM"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A86N9r115019
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uShH14l/dWy
	0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=; b=MI9z31Du8GgqqxsCNQuO1t9PaAe
	/fgKqdjai0WTBUGZu/eJCet2S7i7AUL4Si6JgL/sAJqJGLYui+NRYkaQIX4+pIoG
	HSa/xt1sO6UtvNmy4GbC27EAgydOBCBANQXYzy3TzOEsCcs4dO2NNLhAha+CupgC
	EWUriLOIMjqw2pIg70Y3kCaZ3mUhx00d/znj+WRKqszUoTYUwsZYneLd8w5nhilS
	7IgHdO/SNz3x+ZnoHjDGCg2tLl6EoGcWR3rh436LcytXLIOnnhGcr/B+WczuzlGR
	iF86DuHJ3Py/RwcJyEQwj7tPf3HSfpqX09Aj3MIsY/YoFm7lucfooXcjvKw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dee8xc1pv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:39 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2d3a617ad90so5760765eec.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 06:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775828439; x=1776433239; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=fFBhuXsMFyElGfI+EDj/iadt5sVJguUCcH3y8z9VQqRtnEQozedfwoe1b/QBoEJXhX
         lwp3qF93UrpeMZRZCiqlULoOH5PXTzbxKOS17pj+IEiLa8NW10TPR/UUt6eLT941AEhH
         tSpfqLNUKtq1w9vp2agNqybu0QagF8hzVQ65Ju4mdX386vQM3XzFe1JvexhdMunKhozM
         G3H5SVTwUXMTeSfG6YDM++/fjN1GEhVRZGIv5h1ivvtm8P/cIJD+gMRlo0Vv05KTLKlK
         gY5ro6oL5gtq3C01xVAzPPO1D+QC4zy77ALKse+pJEHIYJWwhlHYm9g/g361HAzDAgsF
         kHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828439; x=1776433239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uShH14l/dWy0o1Tl9pcZPJ74mlezSCjEKQRN2uJbI/U=;
        b=IGvcVAPex1uGX3jqlDKorMuyccNdj8NJdaXwQpWzBNsma/tMCYpSZTtZWi4LpYx0ue
         DgfIgG7CUr+OHTahk2z0duTzRccFwi/Aeooc+jPC6KNWnfX2yt4ilaP5LIsRPTTPIOWH
         C2l/JKZLEgm6lSwh6HF5RA+/BG5ornVNXiC5uDXMfdTkuuuP9QJcxz1qF5Do2EQt3whq
         yWCVe/ni50/A6bjGztmZZ5zcerjUD5UcAdDOHe94jsWXj4rQE8mLMKiID3H2ajpMwl78
         vRbtXvtK+wron/3bl1QdvY8pDUYZbusn+Mo1Scf3lWvPIPHX2eQzKHZH1zz+2fJlHYKI
         cL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2CLnOGD8Fxt0msrXlB1KMKBnKMIcRi23GmtqnOwiJLv2JuMKh6J0Pk4vkrL0bPqOaWCpiQnxpRQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzvRgTqXOZJVI/K/glXD5bAJDJvJ6/oixS4syNogJj0Ve1v9F5V
	1MpQG5IKoqVaqcPdRYL+ApTZyoIzSQqjc0aJXsl4dCI4x6lF5VgkgUCN/L3oommHaxC7CVz6Dmg
	L+FCmNGSO0Lm2t5ZF7P0u6v1Bn2op/k5RA3YsZBSp0zP5gO7Br/loqjk8/x2H/Q==
X-Gm-Gg: AeBDievQ4PkHxbZ/Bk0g5ICyQDxSAo2isSvKUlIhtS7HyRccyFncsKI2hUnQnTQ/s+6
	aumXMBmLCqtY8oa8VOir/0s3UPu4s+RhUw+dQynCMIQEwLEqD6CbVkLLjMWurcAVOwP/GJuTitL
	hh78O3S+KA/W1v/Fa6zOTqhz2YJJGFTwCNP3ESKHYG66+aQrLAB/QMeFLrXFGx2mA9tHr1WPtlC
	31DQjpqj+VoK4tt7oBEoKrJj9fDnlqSC31WCwqECU0VlWUPs1oX5aXeeOLfEf5ovJPNSa6Ies3l
	xtt0iWybS9o17FY2jdbxmdRdt49kJAY6HiewbhMPdHKFbglvD1y7Gg/IUCB7H+32Qz02EKLkJ9i
	N+xEevkR0o0lPr7idtjmspLinj7Fm6IHUXjiintVxIkVCv5XT9EUa3jg5zbGCToqoApe19BfzuI
	ioUZhs
X-Received: by 2002:a05:7301:1f10:b0:2d1:d434:d005 with SMTP id 5a478bee46e88-2d5899a3b93mr2129266eec.20.1775828438761;
        Fri, 10 Apr 2026 06:40:38 -0700 (PDT)
X-Received: by 2002:a05:7301:1f10:b0:2d1:d434:d005 with SMTP id 5a478bee46e88-2d5899a3b93mr2129237eec.20.1775828438212;
        Fri, 10 Apr 2026 06:40:38 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm5172631eec.15.2026.04.10.06.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:40:37 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v2 1/3] block: export blk-crypto symbols required by dm-inlinecrypt
Date: Fri, 10 Apr 2026 06:40:29 -0700
Message-Id: <20260410134031.2880675-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEyOCBTYWx0ZWRfX7Yvxs1T01yPs
 Xm397ys+z96NZpIpIjX1kOxn6GqX7YoLVAe19dJDT+8BQfzF/G/ZNZeXGhyOIXEt+0i3nfM9VC9
 L2orVKoOLDfT59PJGb+0c+o+lir641fZpvqbQ3oKQ3kiqe+mT79MB/m+v7VSAY5ZX3aCP/bvM0S
 bcJcufT7NwV69kt0ERgaZLYkeT7kTlTSjPG8qo2BHM14+5xObr2M0jaGyAOq5//5kXpb42k+y1U
 rTyaUMbKAldp2iKsLEZivKWioQpsoWxrvoPl/LvtcUtO/f16/0088FmrMaO4eMoC8Hve9aMe3q6
 YAx1EgQv38T3Www59hopaH0K8ytUvNvjXCDHGcq0ZX1/ctWFL5dgMwbxigG5/MOLw7DJHAM0PWU
 72yij4QgptuRXSI6lriLulykbkAyyU2pE42UFqVgW+Iz2gehDyM/guQDnLePD/I/DyZBY6/VbQ2
 zu0wPjBW0CrEpSSSnyg==
X-Proofpoint-GUID: 7RcdbdTzSrz3wWg7X4I1IUnkNBJp1bL0
X-Proofpoint-ORIG-GUID: 7RcdbdTzSrz3wWg7X4I1IUnkNBJp1bL0
X-Authority-Analysis: v=2.4 cv=O7YJeh9W c=1 sm=1 tr=0 ts=69d8fdd7 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=1XWaLZrsAAAA:8
 a=pkKqxYWgxMMasECMkqIA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604100128

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

