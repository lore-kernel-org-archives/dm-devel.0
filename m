Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B02185636
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561216; cv=none; b=mpnS0slRNohAqg3MYudoDPuFNnRj4GnaKl42AI+I18FhEVE4rutRQn+/2Z35W9UFoNGnzxCvFM4h7MwXdpPqQyC5ThCpaZOo6tu5dA1O2Ze+QCTz24fPQyOYtn4oNrCdnqC3zGEPWTAS8bqWCVGSEBSFvc8Rr6ppT5e3NpBTaBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561216; c=relaxed/simple;
	bh=C94yUtNXkwZ6klNJBB0/rZalOT3csQUNhdVHCFeg+HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD5aaqkAzTDitYOiY2Oy6W0FYh2Ko7iIKU1YTUvA9smT7SbE+gegRqFXLb0223mjPBsxKBlMK5Ajh9q5eWeGWK4MBf1NyEJUPdFTFeUWF/LMYqNXdTXlJuqJv7+5KPbIfgHwtNPLZ4YwfIP4hCvgwnpYKCZG+P/QEuhhsMpbngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Va5DBj7/; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Va5DBj7/"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a77e7a6cfa7so329157466b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561213; x=1721166013; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siebgP++PqmiW+JZ9+iV+FsXNJ4Dx3GXjI/tAsTjfY0=;
        b=Va5DBj7/dzZjCofFZ4p+rCejsMZqo0KwJxW5Lm4gMRhYLqz0ojV3jbgGz550Q+iJmJ
         Cpelzmdi3nz0jZLj46DNzBc27W0m6iObsxvCDDmoP+WyJGAH9R7q3HCruHjslJciaf1f
         yWL15bhsRHakEGeJiq80sRawtO39Zw9uTejR8oh/N4GqgRwRekxHBcipgXw8V+ZnduAw
         jfzkFt5FbSQ5XcgEkzNTI/bLNwIsxSxmxAqAKgpyK0LG/Id7gkMVS2dPlnnYne258kLD
         U1MH0vlsFEm8ZjSqvClBlGfC9M30MF0x+GsCJ6NvF8ey8OQKDS2vsnkKg2CcweOpECID
         QSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561213; x=1721166013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siebgP++PqmiW+JZ9+iV+FsXNJ4Dx3GXjI/tAsTjfY0=;
        b=ea+dekVS4t7ja6fg2L7OObdqZ1iy72RnbqD4w6I2RwQG/FM/0QcFBoJuJtqllLti5H
         RL7A7AHOAr+ike4lP3nQtzJpox+7cxhmZfu7C4PyWPLo3IxKMEBgNARN9ZWoeu34nibO
         VejPF1SHGGsMxLuyKLOWWnPSyeTE5U3Tq5+IqDw0VjSHzb7Mxgso/ytRXVxoVS5xpJ2Q
         1u228S2F71s4qiy+d7M8puRNSP5WKnuDRxM331K/X0zrBXEO7t/B7Ge9nbbzZY6LwTFc
         lDKN2oYjpIJysrGMq8kU3zW+QIA3WPwASobNVnecVsl+R7KajTw+6svMZrkhE/tmRPN2
         3htQ==
X-Gm-Message-State: AOJu0YxgTQ6FDdeG/34axx0546W/N1bFdssYlzHyKwLwUASA0pNPOwvW
	auQor4eFdnaXgELpPQcynwUO+lG4nhc0gAdE7krj4FaAuiQ0M226S8sLyLCQTqU=
X-Google-Smtp-Source: AGHT+IHIuDZv0gHi5A1wFkEunUbQ/Fnat6ReXtbOcGfKvzscyxhPO/roNOdJtQ444YfjJjYPo7r7PA==
X-Received: by 2002:a17:907:3f8a:b0:a77:da14:840a with SMTP id a640c23a62f3a-a780b89ec89mr318311966b.69.1720561212703;
        Tue, 09 Jul 2024 14:40:12 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a87213dsm107022166b.221.2024.07.09.14.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:12 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 26/44] libmultipath: reimplement dm_get_opencount() with new API
Date: Tue,  9 Jul 2024 23:39:17 +0200
Message-ID: <20240709213935.177028-27-mwilck@suse.com>
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
 libmultipath/devmapper.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8a0578e..859a861 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1038,34 +1038,14 @@ static int dm_dev_t (const char *mapname, char *dev_t, int len)
 	return 0;
 }
 
-int
-dm_get_opencount (const char * mapname)
+int dm_get_opencount (const char *mapname)
 {
-	int r = -1;
-	struct dm_task *dmt;
 	struct dm_info info;
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
-		return 0;
+	if (dm_get_info(mapname, &info) != 0)
+		return -1;
 
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_INFO, dmt);
-		goto out;
-	}
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	if (!info.exists)
-		goto out;
-
-	r = info.open_count;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return info.open_count;
 }
 
 int
-- 
2.45.2

