Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602378;
	b=U36LvxXVpljsO09K2LAvqaIyAbxioiDMnGdyB9hAlmCfW3wXMmXbfQ8IEezPdZUZEb4E
	 uy1fgu29Ifm8AEW7cfM6xigZk4K9xXuOUrkHCcAEyEF3On/jd174f0GUhahiPMLTvndv4
	 zEcnu3KgezXRiCwOQbN1QAWj2TT0cCPzwWorije0KRnxY53ExfGT/3KYdjqqZQGKICpqf
	 1y7owfjnWkr60J1Eev+LBxsnmfu3r+XIfVU9fgQpfmqHBDAJ0K5mQhjsz4N7R49I+tS0L
	 jT0Qxoi8yXCKJbRCwmc14V5PBv6otgk8rP9BwpYIQ1EHR1HgxIzRHfXbpSzij2Ew87g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=aWmJOi51NsIH+6WWjYqsnrAVZ04vi8BA4jdu0ApYcKM=;
	b=AuvUraOrqU63ZRhf8ZCGUNCt/fhIOsvf/AEDZCvj1HxCtkgiG03rd4ULjIT3T1OZqB6j
	 sba4qkufwMVbMghs/hS/KTIsFXX+4NRFGroWaLKIzO49x6IJSK3NirBBjiII5pGMiZQ3A
	 Z+ftJHAei6khcubpMu9E3oD1kk83WCwRpjewxPieKG3jZ9LcyIfZDsaLXbwob3KXKezv3
	 acFIa5en9MKbEbcMmOGC6YdzSphRw2jG2siz7OZ2t8najJLpf2pVEXG++gS5NghriGEKU
	 /Y0tw3lSjCHxIX3nDToJLjxVlYNC/M3CmodAdMkeURLsKsbH1Nip7AKxUpCuWCEeBdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FUYRvSY7;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E0606A326
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E16E0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FUYRvSY7
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a68f888a41so5118325e9.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602373; x=1796207173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aWmJOi51NsIH+6WWjYqsnrAVZ04vi8BA4jdu0ApYcKM=;
        b=FUYRvSY7lB30/cJZAE1c8dQUVU1Ix1Z++r5atVGSWIsQlgpKnuLQj0L6YoRnttFsiz
         c5e3p/H5AMPjF7yhctYMepnoYOsii2weRZ9b9Qfsjo5oGgFStCgrlIzQpujDZJaKyRlG
         0D61gP588Pdx6fBqEzr46Cy+at53KYLdMLGpkct3sYBSTKu9RgyH1q7Zhp/19VCBhQE/
         a7I1hsWc0H9QZL33WDe5otS92OtCv7ysmlu4JYX9TvKmLC1Y+2s7ko46nJu2J+Xb/Blj
         vnGXDT5gEjSetpIXI+GHfqKLr+0pKw7M9eKeKbYhrk/WSEVwVL5pRTyFIKuBbjEu3+FB
         nsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602373; x=1796207173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aWmJOi51NsIH+6WWjYqsnrAVZ04vi8BA4jdu0ApYcKM=;
        b=FUE2AXU30FXX1/Yn3TDlMxZ5C9MJongAmz3kID5ls7y4tCGZ4ErJYyQESyN74SMZ1I
         klQ/Npd7gSH7t5Jcho4VhOPr8GT3x1Br9JPbIOnfpfnC2kd5TA2oxez7ajTz29TcHlEc
         ZVvQ00NIhItWu2kuctJ/6jNDL1VtiHEnd4XdGA6CbFqNXr/V/V9DHXliQ987qUuh2MSm
         jtS0Yg1y1yDplEO7X7SBBN1tdt3x9CFcKuR8lVs0bMlW49/kplVZ4b09ScO1uWUlllHc
         MclZJZT2LxLnq/5+c2Vie8cmLYd9doccUBQ7skVA71n8gU0CZw6Rz9GFYL2y4Fr95m5t
         ZOKg==
X-Forwarded-Encrypted: i=1; AL+hErHjFQlInFpr/i1cfQvKBo2PIrI1MZ3HrONKyaRbqyBB1rSnP8o7zg1yf5f0BI6CrAtOFvQTSkJ4oA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/K6JrHEy1I/3hTXq6sZUvxE6uoGSIt6ueIkkvvq9YVmReZZYvQ
	jRFBtkx6e1LXaWGnVRc73O/eK2LDUO6UiZLMW3Lq02zr59gQeQMBJgG+vV4bzKg=
X-Gm-Gg: AZFdTZcFo/bW7NwQESsLB4lV5jy0Iiwl4Euw0bNm7Kegzc9gyxG3S1g0cHfjfemw9Zl
	GLxzfsqBi6/mgds/T8sAMqwK0428IDwBVYgHbN8fsCHJewSS+zrBF2S5YrRPzXc82MAMbC36qp4
	2D7/f6pnA55MfUQsKvF+pX0pnTDOULkJyIyujLNPngqnumticRXVnVpK+iFXB4pr0CXYTZEItjt
	hxnlJLNe94/5oNpEw1hsHEe1680d4/gr1ZefIQsU3UUK7PK/o3GsAnuH2Vcc3gJ0Eb3LkQnH2Sf
	tMkG0pSkA6zVCUH999eRxJn83B/zo6h2yUGVxLfeYZJuMGZ29D622JCP7PMTgK3N69y5pPuV8ic
	Z+PciM1fHGvnp2qkChVwyyRjLSpDFHXDmDp+EsxbqZSl5tJLOIq3f8BK+NRR2qhcJgqgrL1zwt+
	uoGNli3D9kSnyqhTCOx2wUIeNneibjq3vyc15FfcNT2R9nc8xtuKdpbZzkbfj8pkEVeDzcQuzM6
	EGJ66qcQAmEBWkIB4N+klGWJ5FLuSBTnssIqqWNPw6jrkk5clsXczasomOL54lvZYtUQP4jTgvc
	xiK+RrH3AmM+GL0RY7jzB3Q3kO0O+BgLwskIbdsgi8JW2lhVaSgYyqLBHPJvK7jDUw==
X-Received: by 2002:a05:600c:8210:b0:4bb:7ad8:99f2 with SMTP id 5b1f17b1804b1-4bb88785da4mr326752475e9.0.1795602373271;
        Wed, 25 Nov 2026 02:26:13 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm503528155e9.5.2026.11.25.02.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:12 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/7] multipath-tools: hwtable: use exact FlashSystem (RamSan) NVMe product ID
Date: Wed, 25 Nov 2026 11:26:00 +0100
Message-ID: <20261125102605.82009-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Change the product pattern to "FlashSystem-9840", which is the identifier
reported by the NVMe-compatible models (9840-AE3, 9843-AE3, and 9843-UF3).

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2fe80367..64bd9c9f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -770,7 +770,7 @@ static struct hwentry default_hw[] = {
 	{
 		// FlashSystem 900 NVMe (RamSan): 9840-AE3, 9843-AE3 and 9843-UF3
 		.vendor        = "NVME",
-		.product       = "FlashSystem",
+		.product       = "FlashSystem-9840",
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 	},
 	{
-- 
2.56.1

