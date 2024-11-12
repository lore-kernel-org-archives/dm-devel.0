Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703EB21767C
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434411; cv=none; b=A8YFN7IicfcsRFC42/bknKsnCkFnXQXYXTA3CvgA1NCVW0s4GTAp2Ldb/0WQ8fVAF3CKHNb1SjIXbHqbYgEPrIGkIanX80hd+JjZT4eJ7V9MXxYkqHfK2eWWhv+Frw560qFQrgyaQN2n/0UOcgi3AXxuKdOwlvjpVzVZ9NSh2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434411; c=relaxed/simple;
	bh=XNIbje+vYA/inNW64dUHI3KFTiSNhHjq8byWTNrabQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cfQgRjIaWuidrZcCeMK8vsRB81or3+aIwNhBlpZIc8IYKiUGSNi5IrXPUyXxmPPT+txVHpeDxjuFMrNmpyWZEDRuWBB7LTp62zSt9kBQKaXIvUc4MvUj6Skj+rIV2OLXN4GcB5cirf9OZzQWIVQ9kmiMizUS4jLbBQ/5JL5+I9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=di4D55oN; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="di4D55oN"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2dc61bc41so4370572a91.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 10:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731434407; x=1732039207; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=54q4eYyScDWFGKt3cp1r2MjmiDAz8++iYp48KLTi77k=;
        b=di4D55oNiqqHUvYjogFiSkZb+upXSv/x/frjZBCeUqcfyTeKlkJDm52sa75xPBQT4Z
         H1E28IKYmn6MKQWmfLFoAG1CHt+yQfIAPGVWmlMELAQTkCNVfUZ7WRna6a7fOVz+tZHG
         rkVzBLoT9PodqLV60y3D/0WEdkpvmkDlh1sbbywIRIN2sKHmCgOrdqillAD44jrvc88M
         sckZ73x7EutoYRp/Ab97Vi+C2H9cL2Ov6FwE/E5tfrglXszOl+BkfgwOmDqAB9d1ZT/1
         AD6V384ComgE+fyYrH99GNc/8grMAYS+JNKkJPwMidCEopyc8IY6uZ6BOXcFzX11w6fJ
         HqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434407; x=1732039207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54q4eYyScDWFGKt3cp1r2MjmiDAz8++iYp48KLTi77k=;
        b=vNNXX4GKgPqgkbY3sDyk3KKjHeDLMNsTD8lTs9pVsqNtMAwwopdDluJAFQdCMER3/B
         bbJTAzt9diANKUv+72gHmbejZJLWVRp6W5z3FsLRGzTyugPUGnCJTNevQ1ng3nLhEM5x
         E/B10bgQd7HK6Po9PIfhvDgr79r7wctjqC6NBnjkiUXXFAOoGGaN0gKF2Ve5SsvfWVLj
         NXz+5NwCNy6rgxc3vDKGhVnIoWW/fAonDwEjSuKR797ZSbvGF9h2YiNNx3RIXSRbCFhS
         p7hAo+1L1P+Y+CIrRkMoz3syMsnE7u2RzJCDZ8eQyBpF3avR8ZujmI4JYJZPjfLwhSYY
         59xw==
X-Gm-Message-State: AOJu0Yxrjgyvh0/rcVOK0PbiriAHc5uVCSJqnVGgTAlvj3rpirMDgmZj
	YRCoNmfmJGtfJKSyadnO/L+RhFoTTVbs7MysFflLuJT4sHhZEt3E
X-Google-Smtp-Source: AGHT+IEjmGmPUXgN/Z4en4rN1VSNsF+Q+L/QIi86m1uy8qTTse9NP+UITQiTgLlpUNTK99xDnRxDGw==
X-Received: by 2002:a17:90a:e7cb:b0:2e2:a8dd:9bb5 with SMTP id 98e67ed59e1d1-2e9b170d9f4mr21955617a91.12.1731434406489;
        Tue, 12 Nov 2024 10:00:06 -0800 (PST)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2e99a541da0sm14458797a91.13.2024.11.12.10.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 10:00:06 -0800 (PST)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: [PATCH] dm: Allow the use of escaped characters in str_field_delimit()
Date: Tue, 12 Nov 2024 23:27:58 +0530
Message-ID: <20241112175758.114080-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Escape characters were not handled before, which could lead to
unwanted issues. Some device-mapper names may contain backslashes (`\`)
as valid characters and should not be treated as escape characters. Only
escape characters followed directly by the separator are considered
valid and need to be processed. After handling, the escape characters
are removed to ensure the final string is correctly parsed without
unwanted escape sequences which were used only for escaping.

Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
 drivers/md/dm-init.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b37bbe762500..dad9d523f7fb 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -88,13 +88,33 @@ static void __init dm_setup_cleanup(struct list_head *devices)
 static char __init *str_field_delimit(char **str, char separator)
 {
 	char *s;
+	/* This variable handles removing escape characters, which are
+	 * only used to avoid the separator and aren't needed in the
+	 * final string.
+	 */
+	char *write;
 
-	/* TODO: add support for escaped characters */
 	*str = skip_spaces(*str);
-	s = strchr(*str, separator);
+	s = *str;
+	write = *str;
+
+	/* Find the separator and handle escape character */
+	while (*s) {
+		/* If '\' is followed by the separator, skip '\' by
+		 * incrementing s, write will then overwrite the
+		 * escape character with the separator.
+		 */
+		if (*s == '\\' && *(s + 1) != '\0' && *(s + 1) == separator)
+			s++;
+		else if (*s == separator)
+			break;
+
+		*write++ = *s++;
+	}
+
 	/* Delimit the field and remove trailing spaces */
-	if (s)
-		*s = '\0';
+	if (write)
+		*write = '\0';
 	*str = strim(*str);
 	return s ? ++s : NULL;
 }
-- 
2.47.0

