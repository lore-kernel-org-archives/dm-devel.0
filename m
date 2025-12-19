Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340A3284B29
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155284; cv=none; b=Jv/lqoIPGq53f1IYCLJ+lZmguggjsdVm5XD9wLUjV+sg95EikutARfeqi8Dof/UvmySnYTnEOq29hLkJ04LyTKV6PabNixwW6Zuj4mn5vvO81Tno/Qr46lRw5XZTpZJLv125O8GMVFoB5GxykMMRzH6/mYQ47R+Ypjj7vqhDwCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155284; c=relaxed/simple;
	bh=2mw4R9xUgpEID1+yzw64LclaqB547lu8GnaiMHY3LDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV0zDt7+G2ZyLVGxBjnCAWxb767KX6xn/4fHuMWTFABXgfyTFDPvV9VMnRvfMTp+m+q7NTDqAP/uQM8XeScZFq7o0mDi/KevhUZhDDF34xzTCVJ5eZPjW+lF9c5O4sB8OePw9qhhvxULg4cs0/UilEcITwXO1urTt6Zvwg2R/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IFWFxijc; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IFWFxijc"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b728a43e410so307131966b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155280; x=1766760080; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUDWfvQX+zbixVMyxEvAWD28Fqm+izRQyft2Ld9BCc8=;
        b=IFWFxijcwppT7P+sSrzU01ovf0PJ+RkGSumMqPrmIq+1XrteGs3Z6dt+noPZQOrSwk
         1Z0DFEcrRxM8xg4ezaUrsoMTYY9kaFO0ZIqzmPFSKvHTpcuHTKZSNIsOXG3r2l1MtPA9
         M2SobBi7qRJ8rpD78QpfgX/9VhHLzJYKH7YXRR6NMxVpJpCQ2Jn3xnLZxH28iZryq31H
         7meN9+UGkZX6vmPD+Tcz83pNYb3dtpilmTAGjJS/EISF858eToWMsaFYJCdJtRg6wP7v
         0QemMHaFjDOUAniPNM6vkGlq2h7rVFK7WhPQdKn615IBWcHcfp88v3iSTurs3aiCjrXj
         tiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155280; x=1766760080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kUDWfvQX+zbixVMyxEvAWD28Fqm+izRQyft2Ld9BCc8=;
        b=WN8qZdazcKgzswKawDAFqC6WF0cJMwll+dhhvtZI2p/O+4oGo76JwrUnVe0+iZjHRc
         2bTlgdyJWkEPiknb/B7slftr1rGRjKEE+EViQR+FeOljiv1ELBcsCn9dZOEEunguYkoP
         s9MMblKZn0qWT26MLI7AxVYbwUJJjHA7PDm8di4/NumAsW9sHOLi10HLxY0fwmfDuS7I
         sxGYqJNfE0fQbI/bgHwM8iZUS6f/wADkB1I60Yh5mZOTHZ0qwrNa7MS3EDbIyFhJMoEH
         6Sb+onm8cvr3rkWX9DgZTWZ/QLZAPUC4m4y1upkOwU11ZnxDGY9DvH1mkWitsvdSU0+J
         v0vA==
X-Gm-Message-State: AOJu0YxqyWV4AMiJLd4lTHvPlQxeOzUjTW6B7z0n4qtxQoUOzLaA/sJs
	UZA9l6PlPJpNAeqMisYOkgvR7yjZb0f+bFwY2VT0ABIbQdaCRTobJtAHG+MvwhjH/Zg=
X-Gm-Gg: AY/fxX564owaoAlhWzfbtT2bcl+ngd4lHintnr+ZUpUYfpHT2XIS/UjUBoY5UVV3w31
	2k355oFkbbCoq8OYrHR+b5KlfTV6MayNr4b3bNB4pVRiOlCjGKAYWtTqnGFU8Om/7T0QYg4nrc8
	MYn2Z5jVreUQWDu31z8YK7hAU+G6eBkJrxp+PhjgJVScsSQ3ctKY1Y8mCddYly7QQXkmC2gBWes
	abawAuRBCn6ock3ciX9TcFueoEo5hM58+QmaXAeQq2mryu/r8NRGYz5xGhsl9hiqmDuFXqZKWCZ
	s0cHTyVDb9JhzS6pqT7rMu4GPfMy5XE6RG2mwBu3bTzaWGpW7TI3aJ7pNIpN68Ly233Ns+LkyMk
	1CvotrMqqHWZxmlNitiUq7fs+FY39nY7eU/ge49MQ8XUbYIKWZFM5juSM8ln1O3JJzs48yLIVKf
	1WMU/aI7fci0nDiSE+HCXIEEQWRMU9I4h8AW+xvLXeAqJAZtBdj45+8PBPN7dSFjUzGV4TNxP08
	Rh57sI9oCpC
X-Google-Smtp-Source: AGHT+IFBR/JN9UtyRQz132FqCVnyL0MznkZBVaSCQCVbtpmKf5G0szPr/m4JAhd3eUSfOjFWtuc0rQ==
X-Received: by 2002:a17:907:3e8c:b0:b73:7fc8:a9c9 with SMTP id a640c23a62f3a-b8036f5a99emr287417866b.29.1766155279993;
        Fri, 19 Dec 2025 06:41:19 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b91599844sm2344871a12.25.2025.12.19.06.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:19 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/26] libmpathutil: constify find_slot()
Date: Fri, 19 Dec 2025 15:40:45 +0100
Message-ID: <20251219144108.237928-4-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/vector.c | 3 +--
 libmpathutil/vector.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 3d54ed9..3e9f941 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -81,8 +81,7 @@ vector_insert_slot(vector v, int slot, void *value)
 	return v->slot[slot];
 }
 
-int
-find_slot(vector v, void * addr)
+int find_slot(vector v, const void *addr)
 {
 	int i;
 
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 0701277..7b2c559 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -74,7 +74,7 @@ extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
 extern void vector_del_slot(vector v, int slot);
 extern void *vector_insert_slot(vector v, int slot, void *value);
-int find_slot(vector v, void * addr);
+int find_slot(vector v, const void *addr);
 int vector_find_or_add_slot(vector v, void *value);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
-- 
2.52.0

