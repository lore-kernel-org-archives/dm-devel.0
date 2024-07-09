Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ACB182A6D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561193; cv=none; b=a01r78jWb2dqRc8+S3Xsg9fPI0dySyc6dKYDClae5AzObfJicDaejEzNzYD8NKxxR4Cf2LpYwppZ9sMksuYKv2XDzml1ak1YaryOaSVrCBEpcJBWVoD6eeWtTazoOVIsDmFH7WX1z45VrTjFiOvNnq+tjBRS0qqfAgLvxZixbTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561193; c=relaxed/simple;
	bh=AdVGCKgqJTLvdGKIAR/DAsycf4+aiQXifD2mSgKNkBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz8wA8ymlUOzkomn+lJ+2dVP06ikvbO1YT7x4Ho4hJggQIV4NCzCiMa+cBjYuq1qPy7v99XkARodqq5fEYWhvPsoN+ZLWetG/Qe+Jk049t5DSL4cByyOFTQACJOu6BTXvZqzRF1zJTklpIHwwTvzfYmaIStcgzu6f1QYzVVWXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VwhKeRMz; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VwhKeRMz"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77d876273dso288110566b.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561189; x=1721165989; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=622zwGNxqYN2mmw46fNW/mrONf95+0t+kRIGzrM4Ay4=;
        b=VwhKeRMzKXXl9uyefrvZZ8nObXOo6BiF80ycHIr6u1GxswyIcsK+rNbWGBcNOFVh4v
         eTSnWfRQGOiGMePp3kEjnHrGIpNy7A7PPXObnIVEVigMmPSs8WJkGRhd/De85QTWC91U
         Nm1SIsS2jEMNItcfTl0k06YfwCB6VQfLT3OCYZfUL2gQ3R5E2OCGgXNLuYZDvxqtN9iE
         lpfjBgRGhUULFR/8X4n0Imkvp67/bWAeFPp1lKioFv7Dudy8ynh8XvDaF323tsZ2PYvk
         +i8iq6uOiIhddaWpaHgwTySr4AJwA4yBC5w/TLfbUIfrSsWaUHSmINiBnqUH5Abw0V3Y
         tvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561189; x=1721165989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=622zwGNxqYN2mmw46fNW/mrONf95+0t+kRIGzrM4Ay4=;
        b=D2E1t1ZNjZcd1HQsigPRuwVohT70JMWeNtHOY/VTESzi30tao+M5G6+c21/wjoCvIr
         Nt2ZP4HfT2Ml42wGXg52UB3BuGv0hd6ce/306qDwxO8TSQfYZ9rZZzKwQqvOCNvzcPZh
         2Vp+8qFkMoaYtETX2DGzKIEjOhxy1pwNte4yUkYVIdFh30Rid6jgbHNvkUdrLnerI/Cr
         a9+khh93s1DEDwlNLrzv0V7Uw7z43ccXwmZhWE98FblOvl84QW4DgClsF74akKQbBiWo
         yqGaElB0xkDld0xMzXTfX4vp1ZnB3EoCORortKOyhIFu6um9TerHv175xa4Yp69XgvIM
         6inw==
X-Gm-Message-State: AOJu0YxFnWEVmSzKdOzcJWwUwfAzO14MdY+uJ4EBJ70CpY5lzLsf/yAI
	3bscCijP0VDRZhD8QrjIEKk0X0IRuqBsgTrQg+Y++++Co7InmcgKPbJq9XzkgJekjfe2DsnoXAX
	Q
X-Google-Smtp-Source: AGHT+IGTYiY8LT4b9TVRrLvFYq2cFA1wdujo+U6GRWH0/wpEvbEZISgoDzGQloB6ozsdCWmyRoeLXQ==
X-Received: by 2002:a05:6402:2790:b0:57d:496:209a with SMTP id 4fb4d7f45d1cf-594bab80aaamr3721840a12.6.1720561188668;
        Tue, 09 Jul 2024 14:39:48 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bda30823sm1487926a12.83.2024.07.09.14.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:48 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 03/44] create-config.mk: use printf instead of /bin/echo
Date: Tue,  9 Jul 2024 23:38:54 +0200
Message-ID: <20240709213935.177028-4-mwilck@suse.com>
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

The behavior of "echo -e" is not part of the POSIY standard and
different shells handle it differently. OTOH, /bin/echo isn't necessarily
available, either. Use printf instead, which is part of POSIX.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 create-config.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/create-config.mk b/create-config.mk
index 4d318b9..0abbb3a 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -147,11 +147,11 @@ TEST_CC_OPTION = $(shell \
 # On some distros (e.g. Debian Buster) it will be falsely reported as supported
 # but it doesn't seem to make a difference wrt the compilation result.
 FORTIFY_OPT := $(shell \
-	if /bin/echo -e '$(__HASH__)include <string.h>\nint main(void) { return 0; }' | \
+	if printf '$(__HASH__)include <string.h>\nint main(void) { return 0; }\n' | \
 		$(CC) -o /dev/null $(OPTFLAGS) -c -Werror -D_FORTIFY_SOURCE=3 -xc - 2>/dev/null; \
 	then \
 		echo "-D_FORTIFY_SOURCE=3"; \
-	elif /bin/echo -e '$(__HASH__)include <string.h>\nint main(void) { return 0; }' | \
+	elif printf '$(__HASH__)include <string.h>\nint main(void) { return 0; }\n' | \
 		$(CC) -o /dev/null $(OPTFLAGS) -c -Werror -D_FORTIFY_SOURCE=2 -xc - 2>/dev/null; \
 	then \
 		echo "-D_FORTIFY_SOURCE=2"; \
-- 
2.45.2

