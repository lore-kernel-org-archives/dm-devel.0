Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138F351C52
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946476; cv=none; b=fM+OcthhDNTy8AqIBKrEefJGM9dpQ+hTkxmzjmmItFd+5Bv6ODHb9GH9BTQdblv7jqyiDfVJeccKTmgEzHqzCBUzJP9DRB9BK0QfKz18v9oza6anQGQ+TLJFCA10xJI4qQSiAwp9ILkbDkDamYWU87DsBc5wczYS5FPQZt8nReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946476; c=relaxed/simple;
	bh=ccFsqSUbNmoZfjXj/UyIC9+OiMIUuYR/yY6H+xsWda4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MCl4J82Lw+nuqDaRHdHk5Ys5PfMVL7O8/UrTnhnke5t+WluDFOjHpVPH8LLMEn1y3YZczjlkERjjuqL6hiPRgc8/DUxbLAQU9473Cio8BDn//A54TuMwqHBRNmkiYFb0ZeNoEnQD7ciADoWFQGHULgWtGDQGJngZghgHgiAXZrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPj9hNLa; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPj9hNLa"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dee6672526so6078575ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946474; x=1711551274; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=MPj9hNLawkyXGsOL8N6720Sg7/SG7jsDpDk0Kav47XndVDhVdukRXseKUaA0YAXAfK
         9a5qgA7Zt9ercFcci1cRxWGfDEezoFsodR18i5rmMu2lfY5kPmHZ/Hqjg8yI1H+kYPDp
         Ce6tFWE0/9mKgwcLKrjkTOHPwljO1hjKY84PNEGS8tZYCccKvn47bYur8yShqQSR4m0c
         +s9r9bcFt4GMirnKr2reOb54qUwGHxxxR54kTIzuvIf/yqCxoBjtFx1P+S+sod2TKQTx
         muh0Z/vk3AF+Jry8EHswN9oAgLyRqkoELOiSmSl+QSl7lz5/NPEU4+LOVj9oI90820pn
         /OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946474; x=1711551274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=Z/TILDye5TKICsKzmryFbFgoAf2Yo9xy/1c5cRlGSOBffgcpwydYBM4uMd5L4Qlqal
         jSdvf4s3oGNc2OUNbNxxZJzgYmJkEvJRLFevb7HVnoR1A3jZ4xEt2oz0kpbEVTG9l6xS
         inZDwTUpRmQtLCQeG0x7sgQRe0X6R+Mo/UFrXI2bQPA9bOrHMU0BqUcO2Dsrf+JzgK2O
         5dg4dJ+4g1UTj46NHlOchOBdbmlXIvdd6r4Uu0Q9wwTJgMhizObt8GmYLTpVPPWCYcdw
         WC26fe4JH4cPJzY2YECIGH+DpfUrCt7qvvT9cXrIg1kHekA8i6vxHjyYNq7j1Ku2yNW1
         dMrg==
X-Forwarded-Encrypted: i=1; AJvYcCWU8eAPCER2NhDxIZL2UhZ75U4OxopS7U5dZ1mbNcIiVbUftvMBlEyCQE9QQWtOHWes2T6blkjGqx3tGZrFsl0UsdPzokZbf+k=
X-Gm-Message-State: AOJu0YykzfYiOrlxFdJATyLDTxgG0mcSp6shy1X9AOVFvwzZwS6vVE0O
	+tRjLFZhQUamrW8/QahDio6OnG9dW/hyeG6ODQQSFoAVEELlMTah
X-Google-Smtp-Source: AGHT+IEnN4HYZbE2rHcsFmRm8DkhdOasT2m/ZrfFc02i9m2gwbsINOw3gtS3SpqFPr7j1X9xPow9nw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr20347085plg.2.1710946474388;
        Wed, 20 Mar 2024 07:54:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:33 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 02/15] bcache: Fix typo
Date: Wed, 20 Mar 2024 22:54:04 +0800
Message-Id: <20240320145417.336208-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/bcache/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index ae380bc3992e..410d8cb49e50 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
-- 
2.34.1

