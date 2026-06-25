Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E59369D64
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403342; cv=none; b=Lrx7Zb18DNQ9NQ0C9oelXqJjgyihSQFAWm1u5czrVcZ2pkGWMoMAORm5LCfW+0igdONp6o3THwEyl9rKjtsc+vw9el2ZCs2fb1jTh3nd1gEQL/cqNXAC1ZbPK68eOqLBBsNxoCfEnHmIRmd13mvN17CWNhZyhSwOo0LHvm5S+Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403342; c=relaxed/simple;
	bh=dVMOoz8iAH8yRcnqqzIeV5LTL4618SA9tW4ukARqJpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0fzES7afve6t5C+A9HiA2AgPW6EM1hqpMk5g/rVPPRiBzRBe49t82e3/UrKbJq5sILYMVEucCfzhGsSHjeGZtjEXGvfg/2n86lEqgIVbhBFnMTC7MRc9+jECLZ6B4sbFghjlReBvAX75Zqpz2V7mvl51pILQjJQZRAq077o7W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GN5Fbaaz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GN5Fbaaz"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so303095e9.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782403339; x=1783008139; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qD+wB/7Ay1RQ+l0ncro5E7fTttdjTWyshOVCMa+oQQ0=;
        b=GN5Fbaazg3tN25jB3W8IEl7ZqhMCH32thJOF5o/PFWS2XiWS86qfRYYSC/hNvW9Eus
         /MD08jsEhNAaQZp9uAG0yjXOyWDT7NoTqpqxW76WuhUqGwCz0IhWCeeaTrWsYHKZbkM8
         tusBzrfGiiQDJnMLfnXoylqRQL/PvBJeZfxhlViWFELI62J8h6krjyxhlThP2aPH9USc
         d7c5s3EirCOVJovfo6J3f5MIOJ1KCu0WAkJ+aEX7vr4xQ7cEQd5z9wISZ3TSd9zA5GhO
         UtMPCsTZsWaSB/28nMVxsbmxKsDEyDB8cbbQPTY5ElrrQCJzLWPUeOe03xN0C1a5SSfU
         cPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403339; x=1783008139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qD+wB/7Ay1RQ+l0ncro5E7fTttdjTWyshOVCMa+oQQ0=;
        b=JNAa5N+vaLRtRZ0fpLfSE1IGDWzcMTe9n102Jm6yvD5f0FcTKk4SWaMGYMmc0PYdtA
         y7TmGpwhQbEP/+GU9r0LIfIeibwD3qCHZCai/yrKpMmcgwITYwy7pVulieNXlS/kRelK
         fXRna27zeYS+G3/sMtJF0874glyguW+hncf/plu5oh0jPoXg0FKgQHBNe0Buusie/6YM
         zoWLRpGMt4Lys94OQshgedhTrHkpJh17k2k9If4Mbbtxx7xmQTCOINd9jF15GbCF7Z8J
         oe4rjOCYxvkKzTKYIMx8N2hs1a4Z00wgHLG3E1JjcacPwAZ886apHZaUJGVawvoAypcS
         LSQw==
X-Gm-Message-State: AOJu0YzI8JQZEASrqIAFVsHiyQ9KoyM4Lnkm2h6/Ippc2D13G45Gy2si
	mMWjqtZIjsmUFTwZzBBgIDZHRGuEZBH7Z5PCNoZ+76mgvPKjotSjBRN/A3AojD6IbEQ=
X-Gm-Gg: AfdE7ck0zflo3Eudvm7SMH7Sb+88AoR27ldMBekQCCEggTtu7J4Th0wZXI+Hw6LSBpT
	qVsRKtPij6snOhy3Idqulp8x33OPekHzPeLbSmhlRSB72QH6SM9Ml98n8XJONI+PCDNVumIDSgh
	BrF1fmZ6LGITWWv8qdrLbpcjEAuulPrJZmS1LIF/39gAAaqKh32sxnYEfkDake3gGyjeOL2uLZr
	vcNRnn2ntO2VM063aU4sgX5koldY44nj3Z/wScsbD/7hmRpuEuUHo5Hi8DuXNRp3X0HZYMDhcDe
	SJPYpcLuIGuPeNIq+Dug4MCGAIYHLC52oDWKcSHMyHC0h0zIr6FNZPtj1cItiFU8zjxF92BAJps
	xykx5E8elsdFt3AzzhAToEEyfiJtZJD1FQ44iyXEJEi9DPk1GqYS2BIeSgRMUBMqlFneBCkHoI6
	/Br3bc1JXfWmHvODVLtTBV2i2bRGeMCy1DpQJUlUaJ/hloFntN0YhLjaL36L5U7PwtdaYU69KGB
	ZE=
X-Received: by 2002:a05:600c:1595:b0:492:4ed1:77cf with SMTP id 5b1f17b1804b1-4926686a475mr26138905e9.11.1782403338808;
        Thu, 25 Jun 2026 09:02:18 -0700 (PDT)
Received: from localhost (p200300de374611012220024a9e5877d9.dip0.t-ipconnect.de. [2003:de:3746:1101:2220:24a:9e58:77d9])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49269086ab7sm8610005e9.13.2026.06.25.09.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 09:02:18 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/4] libmpathutil: runner: pause in cleanup handler if rctx is NULL
Date: Thu, 25 Jun 2026 18:01:59 +0200
Message-ID: <20260625160200.3318088-4-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625160200.3318088-1-mwilck@suse.com>
References: <20260625160200.3318088-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In this (more or less impossible) case, make sure that pthread_cancel()
can't access invalid memory because the thread has exited unexpectedly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/runner.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index 459af13..c7adc20 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -4,6 +4,7 @@
 #include <sched.h>
 #include <time.h>
 #include <pthread.h>
+#include <unistd.h>
 #include <urcu/uatomic.h>
 #include "util.h"
 #include "debug.h"
@@ -44,8 +45,10 @@ static void cleanup_context(struct runner_context **prctx)
 	struct runner_context *rctx = *prctx;
 	int st;
 
-	if (!rctx)
-		return;
+	if (!rctx) {
+		condlog(0, "ERROR: %s: rctx is NULL", __func__);
+		pause();
+	}
 
 	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_DONE);
 	/*
-- 
2.54.0

