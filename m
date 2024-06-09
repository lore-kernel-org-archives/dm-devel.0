Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D814374F6
	for <dm-devel@lists.linux.dev>; Sun,  9 Jun 2024 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717942652; cv=none; b=ewI3dRr9k7kLKVt+FYNl2Xnl9oTbGpm1ibktD33LzsP6tsvygjNZP4Y12UaKoKedVpXYOCbZEAIan363fPIjLmMi0d4dzWMkO8fniML+dJGlXDuKpzCWTiLM+zwfjgGTty1hQwD9e2H9EQWlgo/QmWwp8hE+To//rHqQDWR0Fw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717942652; c=relaxed/simple;
	bh=NJDToOELLavN79YkpNHBhxfCYr8Bzt9pRlexqHPJ7XY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=brWBeePTPl7vTLOaTWdUT8ejJZNd8UdoPl8+HJ4EmL3VkDDJZdPdFpd/sZC8evDyOqZsFfrA9PqnttT3Zsmi23wHpv+oAswlMAi5fHnluC8hWRUVIfz64acUpgalc3wIsSPqUtvcuDl65EHazNUGHWBXUEjdI92QtjzLefIL0xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gt2zY6pT; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gt2zY6pT"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7042ee09f04so698878b3a.0
        for <dm-devel@lists.linux.dev>; Sun, 09 Jun 2024 07:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717942650; x=1718547450; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TutpqlrSfL/EF9pT63bvOTQrpOoXNL5CWPlMZU8S7qU=;
        b=gt2zY6pTtT3ItApQuQ4RufFitDQ2f3NONqpQmAvaB6Ars57C+3b6ZhnMIKX9xIdEmK
         8C2SAMplvi52Wk+lOnznDfalNCZxAC4RrLVm2L7r8Hg9bYHt5hRxCZHNq4YKsidjuXC6
         Q2J2hXGIM5tXvnSemBGP1czL8Hgvbl0+/0sRxV2jl8dGpQvPikalvAy/jZgjAp5q7Jio
         jdXJshnHQkIWIt725ZNgrBJnTvCmRRcoZVy8zip4/kpwhJ4NdhK0abBfSo1yUJSSuevP
         CxTOIihWmqvsNxodue2MU2kY/Mg3x+JWsVcD9p5EkrLlFmbv6DKja7UgnErLQiiDXVcF
         DDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717942650; x=1718547450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TutpqlrSfL/EF9pT63bvOTQrpOoXNL5CWPlMZU8S7qU=;
        b=L62uBzAeWSZPlW3w6PBDsc+imkMHUb80NXMjcCA93eeBTFNmt1Veard3kvFHg5O5Jy
         d9khy7iyzilmT75dvgGC17DQBI4lc2I3BjJr/tbD338zVm0PpQKYqHv9wWrye/pG44/m
         aoSkv95Bn0LrW31Yx4Irc+Xnb9z/dfTBZpj3bJRc0I37OEKP9RvT6r8tN875h5iDMzc1
         4xDuntcHaCX2MRSoTVNtAT//dp+cOtHzYViUyxJjpITsefiL4rE0vp5xMqQ65A5goiPb
         ESQu2Q54DRUnSuLHdPBJ9903rfxQ0DHYRnqAqpk+OUGJpF1KoJ1kqqiYfp5phXbj+9U9
         vIpw==
X-Forwarded-Encrypted: i=1; AJvYcCVLYx/iSzLMBwI2fm+/RQ6qtLPE+81chjz8TLCtaGMKAXroCKlElhDPzShnRwRnAmO3afr45pqHrs4XrNRpv/BmV2V9PCFfkoc=
X-Gm-Message-State: AOJu0YzzvG1q05LirxCHyS3+Qa1PC4WzJkSvrAPyB/TW35kl7kywP4gI
	SSxsWxzuiugavrbBi4GPoG1nEJXIqWc55vqZOYqofkaYBdEBgdjdm21Zg7dn
X-Google-Smtp-Source: AGHT+IFTYQkeJxZrMdLUEDOMYJfJADY46i3otPb5Xg6VepNEXgcNkbZzzwYqyTOBwy5rjnS0JFuV0Q==
X-Received: by 2002:a05:6a20:7490:b0:1b5:97da:dfde with SMTP id adf61e73a8af0-1b597dae2ccmr3868311637.43.1717942649827;
        Sun, 09 Jun 2024 07:17:29 -0700 (PDT)
Received: from dev0.. ([49.43.162.161])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7041ffa7cfasm2767555b3a.112.2024.06.09.07.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jun 2024 07:17:29 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	jain.abhinav177@gmail.com
Subject: [PATCH] dm: Add support for escaped characters in str_field_delimit()
Date: Sun,  9 Jun 2024 14:17:21 +0000
Message-Id: <20240609141721.52344-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new variable for escaped characters.

If an escaped character (\) is found before the separator, and if the 
separator is not found or if the escaped character is located before the
separator, then move the separator ahead and continue searching for the
next separator.

Return the pointer to remainder string after the delimiter. If the
separator was found, return a pointer to the character immediately after
the delimiter (s + 1). If the separator was not found, return NULL.

Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
---
 drivers/md/dm-init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 2a71bcdba92d..bef6a582a4ae 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -87,11 +87,21 @@ static void __init dm_setup_cleanup(struct list_head *devices)
  */
 static char __init *str_field_delimit(char **str, char separator)
 {
-	char *s;
+	char *s, *escaped;
 
-	/* TODO: add support for escaped characters */
 	*str = skip_spaces(*str);
 	s = strchr(*str, separator);
+
+	/* Check for escaped character */
+	escaped = strchr(*str, '\\');
+	if (escaped && (s == NULL || escaped < s)) {
+		/*
+		 * If escaped character comes before the separator, move
+		 * the separator ahead & continue searching for next one.
+		 */
+		s = strchr(escaped + 1, separator);
+	}
+
 	/* Delimit the field and remove trailing spaces */
 	if (s)
 		*s = '\0';
-- 
2.34.1

