Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C336918FC6F
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130804; cv=none; b=s+ARcG0NdOn+etFDiWrYvhpyGooQ/A9rnhGfvrMmDNUeh8tM8I2vHaOslERxIu4SmNeh3TMJfj7JTu68AzHKrmo7HMA6x6WMamm8BIwU8kb4e85/JkwkmZZ0zUvVZog06v7e3/NVj6plysbWLt8agF1EdB2CjwGUhC+KrcyuHQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130804; c=relaxed/simple;
	bh=q9kBFjKByCB/mjqRUNNKiJvqSTeohIvVljVkbkFfr0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yjp5yyDi7gp/NvpFgoUvT6L+Esz/YOXl3EhkXSuToyGK70BeQG0wkN8vgOz6Bo7vf/t2imAFgeExD4lVNgBu6xMJm0MeGdvjIl5B/vW/sW3b8coOEJswSI+fYXdgCbqVwgBntfLa4lFJxplrGQjsIyunIABdiRmMKLIQj9TPv1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eoTOjiUc; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eoTOjiUc"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52fc4388a64so1627296e87.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130801; x=1723735601; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Z7h1VfWHYaeBymPCL8tEjZsT9A/O9rHXjoyaoe+hwI=;
        b=eoTOjiUccIAZNunyZ5rnbxCkr6tyvAU2ZDHYAZB5zahzhWXkz7WqgTbTs7g0nbzT9e
         Zsr+gv4yaDvLq0RgqUI1KVyzaK5rO6+A1VOpGqtIg++n3hwsRmYCilGX3weon6jFGnsA
         5737IUgs93uvWps7VXXy7L4BXXCor6vEGyjE1igLwF8teELs4d/m744aZuc31+hrBDJe
         b5kDmIihit+2ns4NRf93AkB9RE1oY5JFUs4yaFdAfnYkDyFpnKvgCo6dhsVDX6G1R4ee
         XhabPtIjPWbPvRYKg8yf1/tGnVRAe96RVLXl+2ayWO5i+oPdLswZu2UI/dun2oQhUPuC
         TGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130801; x=1723735601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Z7h1VfWHYaeBymPCL8tEjZsT9A/O9rHXjoyaoe+hwI=;
        b=CmVA3HK4G79lXqVdImvrdzyUyAjAfv4lLIBsMV1jYaE0ytjiYAdCj45e1I391dOKL7
         cdPd469FTEQbeVxHCI90KjpEK/31C+PD6w1Z0Xo1XR58MwS/2bNaQBSOY5LCKsAOUta/
         X+NrJ14rI8c7vLhFTeEvI5wz98Hf21w37necoqnY7Le3VB3EGVOeTPcbCSMNq9lOh3yd
         Tcry7RmXl7jc4i/O/kHdP51yxNU9+LicbTapOGVuaivoWto+s3EUPJWySNootpnJqkSX
         YCG4WAjq5RqSTWp7G97NQzaUzTiF3M2jmGi8670qbSPe8EH7NAwGraSGbjY+OUgWPIDm
         moKQ==
X-Gm-Message-State: AOJu0Yy0+fC04C17y/1nu5JOrPxfVyLvcKZCypHq4vP8F7OLRh/zc+P3
	NGUoNg8DDMpyQ4NuplNsTzEs65VfHaxbr94yGgCI2X2+R8A6V30luISmNGopgQu1cVHaD/k6l4N
	FfRg=
X-Google-Smtp-Source: AGHT+IGKvjLpqBduUBySmMY2GMfPI2hw00Q+c63uUL/ZUeLbJTZyOiOPeAuKny+nxP9lqLCWyuuMsA==
X-Received: by 2002:a05:6512:b85:b0:52c:d84b:eee6 with SMTP id 2adb3069b0e04-530e58761e8mr1971887e87.38.1723130800647;
        Thu, 08 Aug 2024 08:26:40 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2bf813bsm731706a12.20.2024.08.08.08.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:40 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 07/41] multipathd: fix __attribute typo
Date: Thu,  8 Aug 2024 17:25:46 +0200
Message-ID: <20240808152620.93965-8-mwilck@suse.com>
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
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f43ff54..bb19c97 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1220,7 +1220,7 @@ int
 ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
-	char *params __attribute((cleanup(cleanup_charp))) = NULL;
+	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
-- 
2.46.0

