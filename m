Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574571;
	b=0GXaRIl3lXCiZdakFotfl450bxZCAs6jY3hTpPvMBb7os30z0YIX3M6b5kIVzDT4vkCa
	 YBwGGAe29FWzZtax+iOF5qSS4Yi+oYcZ5yXGhSikMtOxSRxNvipPsupVKo0jdf6Uho7MU
	 WxgnASCvHp9iVnlmLIdzTKX51r95OZ2a+K+oVtMzdyih6diYtVuqcwWBaxo7eP/yScg3+
	 anZhqvmjr0/2IY2nsHLx7IQ9IroTsMZ9ZNxpABXsK6gM20AS3Kvs0y5ZLSxUFcxYAaSuy
	 PMSnjtTiT02oUiOIshiMYU99pEFKn1G4moVQxdBXfXlZIGoakV7AXTLUN7/w2yu+Fhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=DElUE9N4LnC+IGlL9JpktDYvToIG+m5Podi9WH1VWto=;
	b=3PvORD3D1uYR2bL06FdESr7sx8aNFXSrhE0iV2FQ38KJwiReOPST5FV1QpuZwxJOrxqx
	 5c3D/cTfV7qbd4atjMuhdvwLLtkKhmxmrGVAwVSeTKFgClglBJnzFIKGPAIJbQQ9ZbTOW
	 twzkNGY+Xcspob0Izcdy1ifa5Qzqx2k3f7dFOZAfc92OUZXfNwXIwJKY/MUHmzr+qa1P1
	 +sZeo3avpEzYWjMv9hgqx2mE4eb3UWvz71S8EJaEM0ToauiRgD9/gYr8RgiOduYu9jtWv
	 0WHfOgvRaS8/m0gYiuuMb3cs3s0f9xYTD63loKgfzJcWleDDaJMMW4RruCVkpFi9zsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rfv8wyYi;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4C1606A327
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE4C1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rfv8wyYi
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5348aaba5so1498095e9.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574569; x=1795179369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DElUE9N4LnC+IGlL9JpktDYvToIG+m5Podi9WH1VWto=;
        b=Rfv8wyYirB6ah+pnWFSHsHdny1LRzvriSCJ+cMRDvIqMgcGKEtYh0+v5IarB3GaSwo
         IQOUm1Ex4WuN4LRtXs6JJchzaoeik+gtgzp2LHEbOxMWHM9wQAUZXJqn+6uD9+YU70x4
         B303g0+CS1A64PG265mPGMU3crUWZYNUpKKm7bD4ZPVaDtyo5uwct/MWJAPrKVNEXL5i
         w89CclpvHqzUAvZYYQA+YqXd641gkr02pWTiRkl/9IteH4Ag5YwSjAZr65mW47Q+W7yB
         3+c0wRt+0mLCh6/wVn2NHvljNEap/qpIuwYcgbKWmIkFzYzvXhrzdtWr2V1IS+01IQCp
         Hj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574569; x=1795179369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DElUE9N4LnC+IGlL9JpktDYvToIG+m5Podi9WH1VWto=;
        b=bSJ1ir3BTldZ9ArDN7+CN/HdvZqQ1DtCDBCfDrdnvBdlDCj+GZSJE+hut5NywM0iyT
         LtnzN/YbjO0FewMoY0WSnueX3Gp/dYHlOZWfgCLYilv4UHVB25hqgeTqWiIriTjexzAl
         atd7JTnUur2aoTZ6A7vRyEmQHK2tH2t2oKQi+BaN+2bs4c0E3XSHk5DLEOvnClIO5VJX
         JRZtVjXwyyLDi0rlZqd4eCYfBFjzOFatAlcq8XyXrgI6FLXDQpFOfmQNW/cSoNn+Vp7G
         hYqFPcEv1Fvk0suVEFQa7Rr6C0oIDc9lDZ8PJw7Za5RPMdK066M88Qwk5zx0Ep7EFV5g
         82JA==
X-Forwarded-Encrypted: i=1; AL+hErEli7LVEWzHZUypb52/SOHmHY3RcONO5TrC6CN0V9NwO2VK1G8VzjW93qeulrVFShXbDvxwTC+Fdw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9q7afupWtA3kRP/geC8urkyFjoDNvXWzr0jASI8f/7tzsImwG5
	JEDLfdlHPowRV59lvncQIvKHDT9P2U1FX1jQjwTS44k9ONeAgQpOFwE=
X-Gm-Gg: AYBFou35CdJZ1q3vDBdG9rHr5dDTdyBowe1FOz/qmpXiohcyw4V79heFkjuUJt+SrGn
	c3j8ABUEWJ9Qrz0zmoBYzs7Y6UDBSziagWkKnyrDm6rqKO538/sZAhykmuHnIPWY1oMPW4s7XZU
	1pqdl6jB2aZ2JG5uzh/XPkbmwVGDr2CZH5LLB7mdg/ekaT29P6SwZxm1XMvRKpgiEhqkmsfZilt
	/RH6eSHLN++Lb8np8PNZSmaStyKB3I5svoSL2QypK0x1eTqTA7Y0iLTwL93VGAjfxJJ2AdpEHEy
	lSmxU5Srf5DlvTnfHotVZAHum/U74o1S6CNuLkERVaHsqxXw6qntRYtoiqmiGa8Jd3gkBmERcwo
	ocgEWrfK1FIPOF7nfiMGCHZzKeeCcnGX8LT5gBEa/ba/MOlAvjl11x1oYZ/+3RyPU919ldwdcX/
	820vrjZZLCcIOmqqvV2fKemXVbTDRLDMBcFcAGx/p0FWAj4C2fr82gE+MgyIWiwYPMYM3Zguxr7
	J67Mh+se8EbGxTPRBZACoDEZdb06gNjMByS/PUzDIU1mFSSvLrcL2ZpQFsqNjY5CVoIbcuFKzYm
	lwIebReHyjzdrXjbXv/cKYgVEjiSBMYWzqQmS9EnKD5ZIWN/dBszU5YowmL7jk6bmA==
X-Received: by 2002:a05:6000:2212:b0:48c:698b:502c with SMTP id ffacd0b85a97d-49c6d54973amr5512997f8f.1.1794574569260;
        Fri, 13 Nov 2026 04:56:09 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm5319211f8f.28.2026.11.13.04.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:08 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH RESEND 03/13] multipath-tools: hwtable: add FUJITSU ETERNUS VX710/VX740
Date: Fri, 13 Nov 2026 13:55:35 +0100
Message-ID: <20261113125549.504780-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
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

Config on page 8: https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/p3am-3912.pdf
PR: https://pr.fujitsu.com/jp/news/2012/05/9-2.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8ad3539e..6371a626 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -468,6 +468,13 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		// ETERNUS VX700 series
+		.vendor        = "FUJITSU",
+		.product       = "ETERNUS_VX700",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 120,
+	},
 	/*
 	 * Hitachi Vantara
 	 *
-- 
2.56.1

