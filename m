Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E5C127E3F
	for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 23:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714261550; cv=none; b=YyD4junjQEQed+u7zD/ic++mtWq68H7Mp5OCbWqB9sSqlWbBTSXT8d5Xreqq5bv5UuQrX3nYrynr5jWXopc40G2t5Z3w2pS/hzwJm1zjZXaQsNi2CufvBZaOLXdLom6zDAuiPqZnenxriT7EjQDQHI1l6O/e3wpn2lUo8Zl5uMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714261550; c=relaxed/simple;
	bh=JGX0JUJ788SdxImge+N0NtsPKj9D5DgMtJtpWWJ/X3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okHYrFcIntfsBMq5m/aRilEurv47uB/b3jUr8BW2j01FnbmUr9iFIFTW9HQd5wDSj8pZN+LM1CML3gFoQFmWlRi1tDkHfUbS7YAN3pGeW3ZwcTUlwv9P3ytDjEQluzYJxKHZRGStdH0tK8xU38K0kWJPe1Bd7ofjL8yWBxN+t4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jB3c/xpN; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jB3c/xpN"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41b79451128so15849035e9.0
        for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 16:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714261545; x=1714866345; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BozNyK2hSiibq04ZUxkIodmWbioyurd2EjUZIwOMVWY=;
        b=jB3c/xpNzAJRql7ttUhVfeYMmlwnofGwEzUPANfBwSSsE7T8tuLir2M61GRfdBBVCr
         97fvzjZbw1z4GrD5XZWmwY3wAhKXh7zPjpNe7Gvy4e5BuTQdn6GTBqy1PPJ+G/EptZMs
         vtN3TbTWJYANU0Z58zsOAkycDT2TNGnOTKnIiRAyeoftWMV/0jmd2Kfny7F6934GDPib
         3UPykIvh3NC4NZggXTIs6JKWlQ1s0IHvqKjKtUnLun4DUm+2LV2bFCA4yIomV3U79+ce
         aM0DGJFLU2dmNZvZXNKBUkwbY4q5RKqDEAnjjbyI7dX+UCcVprvc+o5Q6W5rpR40Pg6t
         RP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714261545; x=1714866345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BozNyK2hSiibq04ZUxkIodmWbioyurd2EjUZIwOMVWY=;
        b=QaPnhzpPxwEG1Uu7+w73Mcrol52uuEnchttoYymY4j9ZN8tcyfVO0q3KJ60jpiAokm
         aoTYnaydynlSSEHfCo685LiiqKAfBMu0mq1Sq/kch7aF98ZSpih+Z1a7ujBne/kH3t1I
         wdZ2YRhPKS2TBWl7ObXBCoq3KnO7Kerko9aNVnoqsFGJx2FmMRmvYs7Y6u1CQyOqHD2Q
         fZ+KZCX5xXh7w4fwxGq1jAt3KfCqC/Ca2MmZdWJiwAW5LJ9AoGwuvZD9VetNo7tKxlEG
         8HKMiSrSM6oOmP+Y9m6AP64lRlQnUwrv2nBttLe+QzK1D0lV/SO4+IkO8Gl31ZOrnhQr
         J2rg==
X-Forwarded-Encrypted: i=1; AJvYcCW8X+lh/Q1XgQsffvjMUTKteV5g0xZpT385XoX9AQkAAtE31HQl+lO9zPOT8WlXjj53cKZ2/5ZbkOhLhFuTCplHw2toN038P9c=
X-Gm-Message-State: AOJu0Yzgd3IqbqwuwA/wou5hgf3TjY6Zb8nRJ2b0udwz+t2D2fVarhXE
	cRzhmJUAC58ikng6qaj1ztTeDSfy4gGojZOOw5fORvdhBNeZFK1Tgxz8iP8=
X-Google-Smtp-Source: AGHT+IHVpgMWbal5wxFRPWz5uRvBGsSbJZlpGqfaZT89McpNiaGUus9ItH9ted7H7IknWSKCJWUVbw==
X-Received: by 2002:a05:600c:5114:b0:41a:34c3:2297 with SMTP id o20-20020a05600c511400b0041a34c32297mr5206906wms.5.1714261545444;
        Sat, 27 Apr 2024 16:45:45 -0700 (PDT)
Received: from localhost (11.red-81-44-148.dynamicip.rima-tde.net. [81.44.148.11])
        by smtp.gmail.com with ESMTPSA id v17-20020a05600c445100b0041c130520fbsm573654wmn.46.2024.04.27.16.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 16:45:45 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/3] multipath-tools: simplify comment in hwtable
Date: Sun, 28 Apr 2024 01:45:35 +0200
Message-ID: <20240427234538.8025-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240427234538.8025-1-xose.vazquez@gmail.com>
References: <20240427234538.8025-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Instead of adding the new 5300 model, replace them with wildcards.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 640bf347..7aac3f37 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -683,8 +683,8 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
-		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC) / Flex System V7000
-		// FlashSystem V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
+		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC)
+		// Flex System V7000 / FlashSystem V840/V9000 and 5x00/7x00/9x00
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.44.0

