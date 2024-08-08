Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EB419046C
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130825; cv=none; b=OIiPlaWaEA5zlLnU/VtTSoVk8zloTNcguDhXnlP39n+9hVeidJ376m+RoNSAxi2O81RVMj5cYeugo170q7WTQ0en3P0WxfaZ1uEXKvUw5xhbXs8gFgPMdlQH3JyTPMd2a8z4qFbqsQ4q+bjKLYuyfbMLM8wJskXBg3mvlUM3U3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130825; c=relaxed/simple;
	bh=K9HLXtorIyyAcjWhxoh3RZ5qgiFglnwsGwak9HpSm4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXeN4xjQuZMDuiFPQJa0dyZ6bwsOSHTzq+fawkAFdYGq2p93OgxoYfxXx6S0FzEY58F/K4wwS5iX2Foj6dismSL+3mqP1WIipmthP41YwdpH3BlJSCu/OlDvxNSQBR3mWrowFHfHgtxIYohEuST7Yp+kN8xEsfT4wj07szY0uf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DLYMebji; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DLYMebji"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52efba36802so1451799e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130822; x=1723735622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzVNZqXichmiTFd/hQR3amRuWy98kwE/0BUtDYkLWjA=;
        b=DLYMebjiwePJrudgZXcQcFektaKNmFbsLpKNfLXVeagPA6lheKUkKcZ53QW3br0aW2
         RN/2Qu9jiRG1kVVZ8cXM1CSeNLGqS4LKI6N711wzHmbe5ZVmycXRjUgg2qJgi3X0KU2A
         ONqLLHSsZ3O7Qz7Ud+0EOj7CqLZBq5whTpGTBRtstxv78DTvPez6oXELGGOSHS9KvZDA
         57ItCGV2fLw0C8vI9uuTfSRPEYmUxURnphC0ClmxTcnQCwUovsza0M+rawNyHBb1spLG
         ODbQAz/thi9h49Lr92G+MgR+lxj+oXI8HO94bo1hbGFM/HNdiwZtD1Nvw45y+++q9BwW
         Yfgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130822; x=1723735622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PzVNZqXichmiTFd/hQR3amRuWy98kwE/0BUtDYkLWjA=;
        b=vupbA0jqGJUpUYrF4Znp6STHoWtuvC3LW8VhuIsXqm15rx5ly+Ik2hyn8LTPOdfzRq
         bNX9CBAgSPfUE5Urb5Ke7CHPoVQhlIlwvX5CwDv+Njy6U8Jv/foKqUGilmgvqJjbney8
         ypw3/WUTtKUjl4uxBS3FwjdZ9QxK+kQtVMZxTEddjarhYMKJnaAeHpnUWM0nOzRdy8r9
         NiXOszryeidnsmmDiVwNGM/qSXIN3rOaWAaN0n4VmTm1Y1OyX1ou6b6cQcs082Q7+fg/
         RL3DeD2h/2oqTdDqOxECDhrdzSUq4njggJdJMz2knOqvdGVqwMFQZx5J3qmekt/lVnjM
         9hBA==
X-Gm-Message-State: AOJu0YxBi31l21pdBV0xkuNbR8k/iMMVdSqim4gMmg5SzZ1tClBKb0g+
	fF/W9cXErjBHh39LxL5x2Fk/DKc1+j7zTMqloApG3oYveGyn/F+5oD7CSPrKsM0=
X-Google-Smtp-Source: AGHT+IFgyesIdR0e0vV+veQFaYWvaHmjJ7vRP5fRpTaaJGj6FhJmnG5Wbdt2qPCc5mThg9Gtq6hSIA==
X-Received: by 2002:a05:6512:3e1a:b0:52b:9c8a:734f with SMTP id 2adb3069b0e04-530e588b62bmr1674490e87.50.1723130821225;
        Thu, 08 Aug 2024 08:27:01 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2c1fc20sm725708a12.26.2024.08.08.08.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:01 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 27/41] libmultipath: foreign: rename _check() to check__()
Date: Thu,  8 Aug 2024 17:26:06 +0200
Message-ID: <20240808152620.93965-28-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 9b26764..40b88f7 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -891,7 +891,7 @@ int delete(struct context *ctx, struct udev_device *ud)
 	return rc;
 }
 
-void _check(struct context *ctx)
+void check__(struct context *ctx)
 {
 	struct gen_multipath *gm;
 	int i;
@@ -908,7 +908,7 @@ void check(struct context *ctx)
 	condlog(4, "%s called for \"%s\"", __func__, THIS);
 	lock(ctx);
 	pthread_cleanup_push(unlock, ctx);
-	_check(ctx);
+	check__(ctx);
 	pthread_cleanup_pop(1);
 	return;
 }
-- 
2.46.0

