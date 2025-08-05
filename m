Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4881A2E36FE
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 10:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754390161; cv=none; b=RojmBh09gkXzBT84QRCZtksvrIMR53NNTkh/p4ChTbbbzZtTCYIYptZXf+3UEwnA/QsQS/141TmYg/R/udl+pna0O9Gy7vD5QZJhME2nH0csMKWE2FA7nX0AE6rZf/Bu2RNKAqSmQDDwPKTP08v+FaUnIxgAaBYqrxnBqTR9Y10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754390161; c=relaxed/simple;
	bh=BWu84x0cWP79aNFOb8kqbVQPodLfd6OzEw0sPUI9np4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i6l5SeaJNuyPW03duoxJZ0tTq8x2jVJUCUIXFcUAhvP2foamC0Uf3/vcjtVPzbXTGY/0Gm5DWgKs/EPfuKcRti493idozio2phf5qVfI/s62sGNiGogsk4+wViF9yyuQTloBcvKMrurR/lpxOoccnYn4B4HyVxFefcYvbo8tHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=afG5UcDX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afG5UcDX"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-459d55ba939so833345e9.3
        for <dm-devel@lists.linux.dev>; Tue, 05 Aug 2025 03:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754390157; x=1754994957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxiiPKDVyJwytpTjofFAz5PbAuNOLZ+nABWUYDRrVZ0=;
        b=afG5UcDX3BBwGlaYkS6LXQKXrQNsxlLUNEc9d24vFNhJuc+u7K+V/ey8IC5itcdNuC
         ZFc8NDonmcQmdt690540eSsU0919UrQwQAB86QcD4NR5QMA6jDjprwWMYCCXPr6tlI/b
         EHgpUVdDtNAAAU/AFluX/WJ6a48Wupto/5uUe5tuTR6/2w39THXAxQD3k8cEdiU3iugA
         FMpMVXC3BT8Sd7K5hWvQUYDNJukv7AHJal/GyyeXcykTGZCbdQOtAyVO4QZNCB59QXKc
         T0kLc/ziBodILLymtLXyoApqcyBKz8GoqxltEyUawPhtF3AyKM6mSAlWBMMOYhozumvy
         gXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390157; x=1754994957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZxiiPKDVyJwytpTjofFAz5PbAuNOLZ+nABWUYDRrVZ0=;
        b=iM6jbt+ZmkuF7c5iDVi4lLB57l1TfhJCV6DGfAW6fWgoSuuE4iRWxYIYPHA+zoFxb/
         hPiEUTFYNLO+U3rqUB5SvPVz4jawDH9MJuP+F90uB70amjoys17QizLt8cnXaub7Olpj
         fkxqSDAlA00vsKWg7XUmNGOvr5aqyOTA+O7rLT+F4bX+wygwAUj3J+/cLN5thiPOsPvh
         2L7TOX58JqIWL5y2XpHYzQZMEqf8LwX50aepTcGXNhveHgCvmtZsyJNOynTIN9p9Lk4p
         cvCOIRP281OKKPtk1JTRZA8jao9SS0e6f6BK/nuZLXFkDX00Ah5vBnrjj+eioYtizts2
         pGiw==
X-Forwarded-Encrypted: i=1; AJvYcCU+yG6y8UctoxRBITRH+dNF1H+A7zdv6sTkFDNl8WjXri++b7pzzqVHGsj+7Do3su17xJY6ltSWDA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6nIRtZ8k5Xc42R5bp5tT9MgpLV0wG+BvaxqMPjSmdI2+w7eOc
	GrkAqvAe+EPPkJLlrmjF2FKMl4e5MT69v8HMeeUW6KLva9/30jl4wzU=
X-Gm-Gg: ASbGncsjAwqRmrG3at5PYPdcFdaDdVqw1CeRSGG6lM1jQfnPwFa7JNoiksAH+J4Wqzr
	S12/8Aj5JEUJJg3ITtl7Wx/slMN1G7PMythpbzW71via19UFoKmNrX0Ld0J4JG403QxQfqi2A1G
	77rfv4BXKCmHqMmBUlHFe5fZ+bjm/8Mspy6peWfp/EyOofaz6DPmbr07WKBabFq5bxnt5CtS4Fg
	vkZvGexQHHJokKsTyCekWtMLBXCGjdmnvtbfEYbBQFx/v2hOQ+Qq4Dmm0SjnulEM+l4Dpy1CX/n
	N3h7ST1yI3bVvsUEe0ef1TuCYrocnZtOdfjpD2sK9vB4oVYmpfU90XqAPW280KyGw49tTpQgHI+
	EmMJ/l4lruvByRsVzVA3aguwgj4FqCCoLnDPeCrm4AOU0fMaljZiNorYDTSU=
X-Google-Smtp-Source: AGHT+IH5qXfKPlteimSpz+Uds6aMoxjTeYHNQQ8UvYhdQidX3ZNGrUbydm2iEPISeL/qUThz+JNJqQ==
X-Received: by 2002:a05:600c:8716:b0:458:bc3f:6a93 with SMTP id 5b1f17b1804b1-458bc3f6cbbmr45178115e9.2.1754390157323;
        Tue, 05 Aug 2025 03:35:57 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edf5638sm201770605e9.4.2025.08.05.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 03:35:56 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add Seagate Lyve to hwtable
Date: Tue,  5 Aug 2025 12:35:55 +0200
Message-ID: <20250805103555.197783-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Config on page #30:
https://www.seagate.com/content/dam/seagate/pdfs/content/seagate/us/en/manuals/software/lyve-mobile-array-cli/lyve-mobile-array-cli-en_US.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 48ec449e..3f2d3895 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1300,6 +1300,15 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
+	{
+		// Lyve Rackmount Receiver
+		.vendor        = "SEAGATE",
+		.product       = "STJX",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * AccelStor
 	 */
-- 
2.50.1

