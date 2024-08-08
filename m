Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BBD190675
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130837; cv=none; b=rltonU1mqPVECdWfY8HBnj9xJqxi0oeLJD9sipZ9m2MupRx7WTje+t2aAvSBv8b4IyI7M2OTK9Tf2qGZc44o6Wn+OP4Dv3zzyET752A1tglhJ9pflePceAU/bqs/2FtwhlpAWgmIR+wOuDmb8FW9d92PoGrfQxMtR0qGM6vixPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130837; c=relaxed/simple;
	bh=7Kdn/KFHYX3RbBFmoCe2CvtktFgtMBo9Jtrg+4NFSDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIPpOlTE3kdTYvKoSKYCRlAOVZRVviZ1OGxpShJICkc8FCdPD6JSaVadOXTHeOoONVzANWSJnC7Ye5MlqbbOhZWfvKcixZKU41piR3eagbSQ4bFd9gnNB3VYWfrIAKOxNZb1cZUrD9hleV5ms7x6Dedvq/dziHcl8Rga9/MKB1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RKXN9Bun; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RKXN9Bun"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5a10bb7bcd0so1386126a12.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130834; x=1723735634; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/XdsqOqCHFaMfps4R4R6XrVW5FOI3Ba4w6ccUccRlY=;
        b=RKXN9BunLT5sr83lsWImP9t0Dr/BmbAALXrxsj0kCFlkU2nmH5jMPXCakyf1dKBinJ
         AF6/ivtASGQ8mufspZO8gE5ndiX8FggSLGjllMf80FXCn7lr3DXzMK7clWgH0LUrRoO1
         iJFLjbVtXLuLtMZh/d78zi3oyMjR4i3KeTpjH41kVPE0+NuFiJmWFHSnzYO14nlCVcAm
         BDYmgxSeYNvXCaZZgQ7VuAhSTjofjSmd2qmHNX+jxNq+iA/+LwYnU6gUmwbWbCZNQjHX
         NLVh/AQ/NMmrSc341dD7fznxUdqkLpHxEXV9RzSv7xEz7SHkeAO+HG6RcDcTgyMimKIa
         KK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130834; x=1723735634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/XdsqOqCHFaMfps4R4R6XrVW5FOI3Ba4w6ccUccRlY=;
        b=eLv0FgpOVtwuchTdgnS9jDI5gUsaRbCusilfTdeYUpyVJ8n6vJcsCFl4Dkva0fzWAU
         xE4KWI13T7vRTuWSrdcj/tgL0QsoSIHmxoikRGFdldkGHC5u3bLE9ty0Uj3JrMI00Ryz
         QaYa5yRD6lkWEggGxqdaOMCC6YQ0gVWCalJdSIE0Sm3woMgpMKj9aYQKFV53xGZMdmtI
         vvR7uUfrDjEULvloSrpwDZ5GYWHsLbrwFJ7Vi0f1bM1WUKeDGxQBWDQRPJSvGs5ueB2S
         e+49ULfoYghAYLCFha56P/Rzp7z8WXh+1VbsHY21TU8UsVIAeAQuXVCgGC0FRiGVw0Qe
         70OA==
X-Gm-Message-State: AOJu0Yy8BGtaNLWmSX2EK6f+CGMG8r76Fm32DpyyzmgHM/hynuOp61n8
	oUGqwNhaS6NPODt/9kS4GGugSbEpiWkTXRmY6Ur3XYx1o6yWGlYldHV5MgFXn8I=
X-Google-Smtp-Source: AGHT+IE2JEoLZ++Jq42+Qyg7IpjQcKnSnDw0gsdgrkRMANlIZPf6fckeqySNHcU3SAmE8QLcrWlSJw==
X-Received: by 2002:a17:907:5c3:b0:a7a:c106:3659 with SMTP id a640c23a62f3a-a8090ef56e8mr162972766b.60.1723130834089;
        Thu, 08 Aug 2024 08:27:14 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0ca0bsm750999966b.74.2024.08.08.08.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:13 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 39/41] kpartx: rename macros with leading underscores
Date: Thu,  8 Aug 2024 17:26:18 +0200
Message-ID: <20240808152620.93965-40-mwilck@suse.com>
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
 kpartx/devmapper.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index bf07838..d49c680 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -13,16 +13,16 @@
 #include "devmapper.h"
 #include "kpartx.h"
 
-#define _UUID_PREFIX "part"
-#define UUID_PREFIX _UUID_PREFIX "%d-"
-#define _UUID_PREFIX_LEN (sizeof(_UUID_PREFIX) - 1)
-#define MAX_PREFIX_LEN (_UUID_PREFIX_LEN + 4)
+#define UUID_PREFIX_ "part"
+#define UUID_PREFIX UUID_PREFIX_ "%d-"
+#define UUID_PREFIX_LEN (sizeof(UUID_PREFIX_) - 1)
+#define MAX_PREFIX_LEN (UUID_PREFIX_LEN + 4)
 #define PARAMS_SIZE 1024
 
 #ifdef LIBDM_API_COOKIE
-#    define __DM_API_COOKIE_UNUSED__ /* empty */
+#    define DM_API_COOKIE_UNUSED__ /* empty */
 #else
-#    define __DM_API_COOKIE_UNUSED__ __attribute__((unused))
+#    define DM_API_COOKIE_UNUSED__ __attribute__((unused))
 #endif
 
 int dm_prereq(char * str, uint32_t x, uint32_t y, uint32_t z)
@@ -60,7 +60,7 @@ out:
 	return r;
 }
 
-int dm_simplecmd(int task, const char *name, int no_flush, __DM_API_COOKIE_UNUSED__ uint16_t udev_flags)
+int dm_simplecmd(int task, const char *name, int no_flush, DM_API_COOKIE_UNUSED__ uint16_t udev_flags)
 {
 	int r = 0;
 #ifdef LIBDM_API_COOKIE
@@ -496,12 +496,12 @@ dm_compare_uuid(const char *mapuuid, const char *partname)
 	if (!partuuid)
 		return 1;
 
-	if (!strncmp(partuuid, _UUID_PREFIX, _UUID_PREFIX_LEN)) {
-		char *p = partuuid + _UUID_PREFIX_LEN;
+	if (!strncmp(partuuid, UUID_PREFIX_, UUID_PREFIX_LEN)) {
+		char *p = partuuid + UUID_PREFIX_LEN;
 		/* skip partition number */
 		while (isdigit(*p))
 			p++;
-		if (p != partuuid + _UUID_PREFIX_LEN && *p == '-' &&
+		if (p != partuuid + UUID_PREFIX_LEN && *p == '-' &&
 		    !strcmp(mapuuid, p + 1))
 			r = 0;
 	}
-- 
2.46.0

