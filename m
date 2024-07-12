Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5EF168C4
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804537; cv=none; b=VNFxNfHTjRPwJ5kellCwBwCjMcBeyajm9j62rpvtNrUP1B3KtJ3Wlxv+RbWGcMsdMfb0evefQOMStKCM6EJQBwfD8fmKnqmYKI816OqOsu4wQbAaQuTl+sUT6yYRDdTgLGKsU6GYroVRZM1EKBo4NcEGU0L9by1t6uFgN5uWD8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804537; c=relaxed/simple;
	bh=JDFDHoU9d6lh3O6Di3X+L8QStA3NoULhVKibPZLGtAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubes3b2PAiL/pzmLUuXCOeIIDDqigg5c+PdndEi1MjLN05Llm4dGlYaVnIlhiJ5l6WpN850zBa2VJEpsrUEy+oez7O5EK/H1S7JAd+CxUaW2km6YbSszKwBuNguWmiLixpV3grzvUPeRyrs7fN3XogEu1OC1vnmt7KnZt4T9hT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IOIo3SWK; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IOIo3SWK"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77cc73d35fso586712666b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804533; x=1721409333; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky0DDwpVe7VQGfMPQcn0cPxjmfpgfFVqTfAk8RZ/c5w=;
        b=IOIo3SWK+NoNX0a9jFiKd03Ii3XZyxcLWqFEyEPuJruWeyNbIr/uTFipywSWYziL9M
         MuXxOFy0M96g8L424b/XBkJvjldiyhIr7vwGFlau2u7fRmOdCdDIjyqoXA9lhb5WhqAM
         tFBSiqcn3MIdQ8X1cOH/IoYunsKgN6in7uzAHrLhV3BawkPttETHg6UCDzvtlxr4YYDe
         dEkHS/KvG1C4HtEgHErAWsab35K4i02STu1tzY34mvRglQyfx5EjN24up4OqEj7NpxOA
         piAI9X/Z+jdGNkkAllz7p8VZ8yMYsrRcrMc1NegGlHK+ovnfGAE1JnIhLaRvsjMp+FGi
         C71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804533; x=1721409333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ky0DDwpVe7VQGfMPQcn0cPxjmfpgfFVqTfAk8RZ/c5w=;
        b=AZ7S54z+ODVLeSYDqY7Ues9Zwxd1qjFq4QOaN0oAd4V1jBalDb+V2VJqceqZHOkuP9
         wRzaUsBIJPmwIynrDlfM8TLQ+p2tdqSEtSJe/s+iRNtvqC5rQzqD5CM9jilStfS5thJt
         aDuZK+FeycK48YshecMrtMDPLQyvgFfM87fII+DfsiaGTteZqyWYbto+7BrVApckpoyW
         hilA7uoErQGckq2rPUQrWe0gF0kw9Fn8zkEAy5Okw67qAlMBY01VmaSItRkaF5n+PMW5
         u/mVlNWOWBfi2BJlv+fzOK3onOTb7KUo8MEzKVDbePp+eseRoH09UjUKXxTMz7iOPX1t
         xrTg==
X-Gm-Message-State: AOJu0Yy0U3xYFLRaJoSpJ86wGddQbVZtPyR/4vxI6l5Fo4dXabhunUkv
	D1DLAIbi5qvy4+CG3Nb89i++QZfr8Mnt6lkK4oegTM/00+jkNi43O8AUJix40uoKd+du7iTx+3y
	j
X-Google-Smtp-Source: AGHT+IGWvEDtpdTKDycfxgtj6BwQ4oXUl3hP6JE98F7fshkpZMm6nkZqE6Vc9xVPz4v2+2+gzAHfqQ==
X-Received: by 2002:a17:907:86a3:b0:a72:75a5:bb42 with SMTP id a640c23a62f3a-a799d393418mr290974366b.29.1720804533029;
        Fri, 12 Jul 2024 10:15:33 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a856251sm363280666b.185.2024.07.12.10.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:32 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/49] create-config.mk: use printf instead of /bin/echo
Date: Fri, 12 Jul 2024 19:14:11 +0200
Message-ID: <20240712171458.77611-4-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

