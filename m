Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602378;
	b=IgHiJp1oifLHGdRC0ag2jUopm/4u/B7ZoyRwnfc9o9NOyHirpQKIUpzY1xxsCR7N2jop
	 92asqICrGOco/zV4EwhU26q2fKygiJhlcgAAc1UMexqhSDAgZh/6K8z/1Y2dflVjnRJTD
	 d4loTIVkc6ZbfefjqpFOk6fAJzYwZn904KMyqcWt3CnVOIcEq/Yin0S28Tp+im80Su9Nk
	 2hZvRC02knF5+sYpbmgSbnh0T2rpTHos2WF2mm4HusVhrpehOWzXkR6B8Ex+vlAYKTTt9
	 yXsfgQM/mxA7hmmLIuTDQTl1qfS43IWVKWj44mtmkl0Mnd2iVIttuYeH8Pt8Kjvzafg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=lQsRVyeDC4H12vXsLWxftZjNBuvi1p0Vj4PhHDJXbSo=;
	b=TWGe5PV0IpL20WxjLzNCvIcKrrOb/KnuDrLC7STP83BnOGnmJ/jDkLd8Mg/LmbwD4jhI
	 0DYYw7mGk3xcI6HpmXQwTN68GLLjpUtKLEVmCS/ATyBOMB16Q2Nfhld3y0/aS73c/wqJ1
	 wxjIf17lEBX/Z0zKXIjWIZCMj6wq8R19Lo9lnvACiYVDs85tJreGl5wRa5Yv2+Gx+v8wF
	 n40dVOJphRu2Eert6wlfTJtAFbmaGk6tLjGJl6oofSrH1RehkfcHlySzZlHjzOGFW7YFh
	 4gjr+wJvT59SM4g+el9O8TV2L+oc3WoOtDI6dYUVKMWdLYr4eP5Dmx9yrn8LNORjMsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uvXsVOId;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E480A606A335
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E480A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uvXsVOId
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a511d8a394so583381f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602372; x=1796207172; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQsRVyeDC4H12vXsLWxftZjNBuvi1p0Vj4PhHDJXbSo=;
        b=uvXsVOIdLJGMT6Yhb2gt0r1olruASQuCoMJVih2iaSCj2KfCP0n31q1I16eXWGjoHp
         xRDbEMsmrxekSTMOGWyOc3e21o4p0KOWKnCY6AH924DtCHc3tJY8tz8LsA4Xhszsaqgg
         DemxagGuUkYeDo/Po45EUh977O4Ulu/1Y7pgMatfeWDCLXQF6i2ZgjrnEO8F0GVn9T5e
         HGAJ3H4BrNogZ6tzNuoAelVGGo6esYDlFH5bdJ7jN1EmTYg6g6uZeb4b229tgtLF9h5k
         PECyY5zUpjGp1Y0jBlsu+Q+EUpEg5C13iWpfEfG2pmE5o2hLoFCT6aUZlqKc7j25UyCn
         yLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602372; x=1796207172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQsRVyeDC4H12vXsLWxftZjNBuvi1p0Vj4PhHDJXbSo=;
        b=ghVJolIpiHB4ozjLXRw+/yzcMMREEAN1PQrNx8f4/L8+Lzlo1ytQ3lQ72Lsduis+Iu
         WuUrEiwnsM+qH/Uq1qp2FZPHun7OvlSWJEh8Q0b4suf9WvbLEc8Xuuf23C6kR850PIFx
         s/TO874Lp0gqXiiS/8HqTBnvulhF+ltN41t5rYHNDfnBD3asZvUYlUV0h3TG8jfzB6eW
         avIo+25xgx20n57di2yhQqFUEdulwNLgskv0vSn0S9k445Vi2w37CfAoGFyjAKQRkpN3
         CR2hebUygoPqkTcdvZUFxv1VFx4BDrpC6XE/97qLsOy8UNxUBEYb/CxDltVjzIEWvnlO
         fyAg==
X-Forwarded-Encrypted: i=1; AL+hErHAHT1T98LuOe0oKi1Iimz7pyuXtB6ZKlHUOsk1v3AHwsLf27hFejyaPBJxrYgXEGl1FW71bpcTAA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+NtE2fnRARGVJnGr4sw6NA0TwRpbVSGgFdkUS6fkq+bkH3Szpo
	mJwAOHrGiTfSPpMkwl1uTUhHmBPtCP0U8zWR4FeYVpz5CmbMcy2gIW3LCRaE83o=
X-Gm-Gg: AZFdTZca7CUPln0qSn4GOoi7tMqUhhfVv93XDa8EyCcSMk+a5z8WXvLwTsl29uBs5yP
	TrJyv1wk6F931rC/ayAwI3qet2g5UKEi3FnuRbvYykG+o+dLY/l2NUfcTEtJ2T8PxnF2VBA15cj
	KAkcTNJEQHc6/zy2Ps2g4RtbrLOEIEHHZq6Cacuz/KAduIYH+B+vWPUplElvbB3ChVsuOViQZ1/
	AZoTjRFfcPiZSpSzt1O0rETKH53PoLscuk8LVl/6/HNIWDgf8wpjnfoomn3qHrmbBFYGIh2PD9M
	fWTEIhg9F7b08e/0+yxPOjV1gE31R39bPl6mW3Rlx3XJzD7PwU4v7PooUlQjs5tiQm/v36G2xZw
	iacX7yED6iBKJIUq5mPcn3a11/5kZ71FowkFo+/mWEBgj7LXjCDGWhbdwFwL4BsnEgYs2XKacyk
	H8/+RHTUQDEjw6TSeAg1EV5LuCVsGVTgKS4jKxaHmVhkMDQ5IAURajn6dGS+U9s3Fz5wr0D6vtE
	L95Irf2zI5d78ETdObxo59B7Bb6bpcDjc0KBkB3VwghN49725IVal4Qsc72doyHhGiVuHdGLnnX
	m2O3W60lKAAs9F5Q/fewwEHheRdXNzrvBMVg9Bxm3+2QhWQQaz8HVPHN6Ih1bWxwqA==
X-Received: by 2002:a05:600c:34c8:b0:4bb:a792:80f7 with SMTP id 5b1f17b1804b1-4bba792818amr18063625e9.0.1795602372165;
        Wed, 25 Nov 2026 02:26:12 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85399e2esm568464425e9.7.2026.11.25.02.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:11 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/7] multipath-tools: hwtable: clarify FlashSystem(RamSan) NVMe comment
Date: Wed, 25 Nov 2026 11:25:59 +0100
Message-ID: <20261125102605.82009-3-xose.vazquez@gmail.com>
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

Expand the comment for the FlashSystem NVMe entry to specify that NVMe
is supported only in FlashSystem 900 models 9840-AE3, 9843-AE3, and
9843-UF3.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c6bf2d90..2fe80367 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -768,7 +768,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* FlashSystem(RamSan) NVMe */
+		// FlashSystem 900 NVMe (RamSan): 9840-AE3, 9843-AE3 and 9843-UF3
 		.vendor        = "NVME",
 		.product       = "FlashSystem",
 		.no_path_retry = NO_PATH_RETRY_FAIL,
-- 
2.56.1

