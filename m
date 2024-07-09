Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C903185602
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561198; cv=none; b=uR1tOfZy6QqV32zHv69e23pXabuCooFJi1j8EmZn2pJY6Tl3/OiuXifXLQtnNoLdoevbsTGuM4YBMGS8somyJec3XzAn1lq0Gojq6IfykPXpdPwQuDFod+18W7/26FqkXKGZ82wvmaek0QojVNfMYNCu5IJQ8QDvxNMJSCfKEPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561198; c=relaxed/simple;
	bh=JAc0biAF9LTjSAlXott8GK13sue8V6PGDVu4iYlP8vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSKx/aiH/Dwz+qTUDB0ibb55vzKvvhu+U6cNMOyLw9k23wEhHKlp/MiKo6+Mg1vBPfpRCkjymYRmBuCg/RW+znfQEH9CdoxRSJI6kHdnj9HrZKnmvLF+pVivty1HaMpguLUzft0by/1CrkwOpyQhb8F2nDLSu6mfcGdeqrFuMKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJrLX3Ix; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJrLX3Ix"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-58ba3e37feeso7702839a12.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561195; x=1721165995; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0gf8uygD3ffsEF/m2JAHHct7i+UMVrRQsMGkq7PUao=;
        b=UJrLX3IxMcm6bckMrp6W9RNYDEFQA8PlFlJ/J5VtVni/+Yzu29eshfSm3Yg+wy5591
         r9OOaMq+Hx5YfVkl6pV8/2md4H/NaUj0L6kOWP/Ts6l5UYNmvdQ5XeGkW0KTd3UshVmS
         +LRPZKqHydhcGNa5BH7c37PFc7XC810e+6tjpPW1RXpuapiHYB/ZXoZLiqPrxU9XpeU9
         8Fiu5Yrw1IHlINa/H56n4xkywqhhKnXG0bmKqD0Pa78ZI2zjNsf1R2pfmJytdejJBD4N
         Rg8664NdJ49XliItoablhXBbWhfPe+rdL9YlTfZUTZ6qNunOmQ9JYegwd8F6PVps4muG
         qYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561195; x=1721165995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0gf8uygD3ffsEF/m2JAHHct7i+UMVrRQsMGkq7PUao=;
        b=lnB/vSrPcoQ0W/9/qFhEcQX0wwTjkHuYUJ5KUeaIsI57Ii1bu6bZSOb6MK+RnVnD3N
         RInZINlkO4I/sQPL/g5zT0LsKMoMBTLuBtOCoXxQhyib76JTnwirpIqBH0Cwo/5ErK/x
         b1a4n7AYwzfvx9JzAr+3QK8bjkPFtoLbAcY2kAzSEMyCtcCh6VkYHveVXPM9LJZfnvq1
         PXFH4/feUTTjbFQVZWUxu/r3LV3eR4aVeqiny6rEGMAGQcNv7V5eAUkhdSHHDuVizjyq
         rtXwvlIA7FCCq94itA6IuUlav2/HIOuQ4BKAa0aDeO0r0mX08Fl2npns7H741FJx3Pfo
         2W8w==
X-Gm-Message-State: AOJu0Yw7njluDC+ilOfgr6CpnPOpL2mrOp9YUNxEPjrtjwcng70SzaJs
	HQzsmtvR86WuKNJteP3ZIs9huItOywT1GWeTznLimtytEK9JW7vK1WgSJoUjNXk=
X-Google-Smtp-Source: AGHT+IHYqH9nMh1BaXJEXdixHUmmWI0n9OuQGKMVq3/VckVawRWxyOkkfqjOLDvTKVk+Oh///YT9Gg==
X-Received: by 2002:a17:907:1c1a:b0:a72:6375:5fa7 with SMTP id a640c23a62f3a-a780b89a039mr308911866b.64.1720561194740;
        Tue, 09 Jul 2024 14:39:54 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd459abbsm1477846a12.71.2024.07.09.14.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 10/44] libmultipath: remove unused includes in devmapper.h
Date: Tue,  9 Jul 2024 23:39:01 +0200
Message-ID: <20240709213935.177028-11-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 08bb3c5..3ee8555 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -17,13 +17,11 @@
 #include <linux/dm-ioctl.h>
 
 #include "util.h"
-#include "checkers.h"
 #include "vector.h"
 #include "structs.h"
 #include "debug.h"
 #include "devmapper.h"
 #include "sysfs.h"
-#include "config.h"
 #include "wwids.h"
 #include "version.h"
 #include "time-util.h"
-- 
2.45.2

