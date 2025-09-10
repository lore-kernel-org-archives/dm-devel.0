Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A625D2D8799
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 19:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533345; cv=none; b=MMtXPD9RvEZtR749QkRHYcbdUxrxJFrGFk+W+3sKdE1l8KYQBI8xH4Tj/nVjDGVcmZZUNfRv8y4JkZpam1qLTv6RM9ltPWK5Pbd09YYPFGMbXTgIXMmU2ASjl5uZGZZBis0ZChII0v5OaJda57TAp7oD51Sx08EqsSiPmk3tZpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533345; c=relaxed/simple;
	bh=chs3wGpCRQq0IQCxjRNFmyasyaYmTs8Gt2cPNxuiS0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahyt1boIQib9tuI5Xe2n6y2nKAcfvnlEOM2pEOHHEoBvqG6mfbtl2ew0za1O9ak6umgpy2Ayns2NcTYtECGPuWHiA8hSs+hMMsnmSKyeBKe/sDEY9lA+3xRmpQUIxi5taEvtUUk6964kLtEdhfexKzlMbFUDZ8/0sxbNoHa2z/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NcKnhiyk; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NcKnhiyk"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45dd505ae02so7341785e9.1
        for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 12:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757533341; x=1758138141; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzRRTHS/oHKAxPFP6ES8FgRlsdnfre1UGuZTK3ir+Bo=;
        b=NcKnhiyk0rxnetIVxVkZsDoTtazgg86yEBy41XJ0811hQMUBbhq97bAS6ua0Cu8DUj
         SrBuunY3U/Sw8owZhvmdr/FF0ECoxSQCoHB28cUjjY3wMwK1Lmkq4SxKBiaAKbeZif8v
         VoyaB9VgZIdm0XxAw3kwrjuV9vTJM/iiUOirKvGrj+5X0wf+VseCje2fCbng/uuHq4Q/
         3CGIejcynoyhXdAvjzbHN0qlHQMTc9K6qr46SqIRBqqAhsNpFGr8PcVo6FjOSsBk5TXA
         wv+StyGDQ0T3jrtrFhulQjzLd7g7s7qbM2OWx2ugh3mXoiKo2ptADL6EBxSmF3dCQo/L
         eeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757533341; x=1758138141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzRRTHS/oHKAxPFP6ES8FgRlsdnfre1UGuZTK3ir+Bo=;
        b=Gz/9cUNalPnecqNwiTflm/fIguuq+RTvXwizf74CBpZFjpIzsqQdJFMkXpbOMbFzKn
         kMGko4lFwcIhjndw2E0aLFUU5GmxUAQvaIs1bBhPqcpH6cIios7cPlwPwgA6fm16BmT3
         KxG3iEx3U/qbbV1q+gmKLNx0EoitCcm9qKZ02LlDuB72kCqib5kV6UwyL1DFmrAhljAX
         cR2g6zbKzJBFvfKeG12dbNkz9NLuSPk/sa/crEFYl3LW0KOeP5AH7nDTvCiboCkv7mUu
         UpwCTEHOKN1HgWZhu3dzYDwkCOPhCShmTLtqnFAq3qHsFEGMD/bku8wzXBskAd8Ro4Wj
         VaJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5Nwps4uB4FCwhlYfbMWQ9kzR/T+zVoNzPNLIRPGpvGTO1Ob4sDh2fgeQ4dedk24dN0d5rv/n90w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIHqw0xx4D0tXgcaGGb1BOrd1zJkdMh7+w1CF+MUr4HAe679dr
	bfGCA7wRSqiNwokgj8Bng0iP2IVzj4IbsfYQDubZ/eO/zuqV3/3tEpU=
X-Gm-Gg: ASbGncvwdnP+ert0wBrMjnAdCZy8PRqiwzd+JkuPkW7sQBHhEZO0BlroeEkHtbDzN9S
	UxfyH4QhcOMr4wFzHy7WgUrkUOTsY3UhKoJTTiwDE5Vw4gbgkTtqvBIrtaHReQ2GZYgCiQCPSu7
	f954GVSaF0CFFu0EgMU1W7YYfyIOlVZtp+a8o+vHjc38ITVSghalmUXxbKHwY+X6gTCr8TnZ/T5
	YGRtoBwtF96l/yuVfkuo0HOcgjJ1L/+gBsC6xN+Ao4gbOUZEJnW0bEuKmcdUqebQc3l4L1jjkDO
	z2tQUNAI53/tnLQONe5TrZMmmBsBIfCAEE0PYOJVh0gTITEmVRbu5qMhsrNHvAYbLAiVmqc7SgH
	F7oYPJLrcBikjR8fAXVSciE2G1wCwgcGVhSvtr/40/ry1ViNj1jYUY8B1k/mU
X-Google-Smtp-Source: AGHT+IFab8vA6M7ushF43CJuzT+Dtnev+63bboVu6qTouzCbU6oyLZOxKYIYtT7gUTLOnRIiRtvWpQ==
X-Received: by 2002:a05:600c:1e8c:b0:45d:d62c:f1f3 with SMTP id 5b1f17b1804b1-45ddded0bc8mr77080365e9.4.1757533340688;
        Wed, 10 Sep 2025 12:42:20 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521ca123sm8337966f8f.22.2025.09.10.12.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 12:42:19 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/3] multipath-tools: add EqualLogic PS to hwtable
Date: Wed, 10 Sep 2025 21:41:58 +0200
Message-ID: <20250910194205.145919-3-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910194205.145919-1-xose.vazquez@gmail.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Source: https://dl.dell.com/manuals/all-products/esuprt_software/esuprt_it_ops_datcentr_mgmt/s-solution-resources_white-papers30_en-us.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 12e10577..392131a3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -408,6 +408,13 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
+	{
+		// EqualLogic PS Series
+		.vendor        = "EQLOGIC",
+		.product       = "100E-00",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.51.0

