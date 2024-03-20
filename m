Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F74AEC4
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946480; cv=none; b=p1rS0XIGMqDhCduWtw2HUyzhty7XNZQUDt8dy8yULK/QAyWmV8yny/H0LQUeN36vfTkAfYdhEYJ53YoSEiZ2xHcHArPUwIqRItCXCpzRFcmb63vxM0b8XAqvNlvXB2LTzC9lkaIwxLUmDK0xBq/6b/eh3jJJXglS0sWCK12Zbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946480; c=relaxed/simple;
	bh=06vCmwEx1RrMDZDf+vtsHJ5OiX/iBIhb0hcMuWL3G6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GLrUf4N8+rwS67ASZtsFMak3ugVFPrpFfVViENizl+SHFxrgPjHJYmTZfg5oR8oqE2oJyyvwxCdo6opRrteYCmNZO7c/y1PYxWT4E8rJbVJwuX7yqqRqTF4tCnq+v45635vOKNfkQy0N7AcclKRKBooxXRgMAHhNagaRx1zblbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4ftmIKZ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4ftmIKZ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso1038270a12.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 07:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946479; x=1711551279; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTsQEVNVJaaM77/A8IxlTDaKS3O7Y7L1hXdgoCCnWBw=;
        b=L4ftmIKZ1CKkxF5EIs0PAInu1WlUCxGHJ7VUlwaJNzXnz2ST5lqDKPEGUo2gNf4wHw
         kAHUNpIM6TL/oXdDe3VIAWl9dqOwaMKx2An5jan5H5YRkGB4YaoJHj59MvXYl0o13fNS
         AXnb4EjiC2pJCo5a+w4AKvE8htA7/RhgbM8bgRCAyS8av3jcBQCP06NYkkw/p2iC85Wv
         p/90wIORqCx9A9pz4drukYd8R81o+TOOW80OJAqrSCsTPqHpjjXbZDJcvxgwSvdbl3Kf
         AR1IPPyLyui709AohaqhlX/aSn1ke2qvSKGRv50Z8MRlOpNZ7qDZx0L8zQDEJFOD90nv
         iQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946479; x=1711551279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTsQEVNVJaaM77/A8IxlTDaKS3O7Y7L1hXdgoCCnWBw=;
        b=DZvsuMFs+rw6FJAQVocnYOCQGBuuvkzDdVJHcda75fq0nEA2qEMQXL1JpDbaHOSVDr
         vAN6KMVHEHr5lyOu/mUcKWqrtPq7c+CUCXzuRcQFk6hkPDa92VNHOjbgnZ/v4KxfzqND
         FOUAfVRipIa11UvA3A8kpmiUYhwE1t1QnCWSjtQrXWUfSWyxcvGOlxCuYqy6/8Gw7goT
         NtZBSzzPll1HwLiV6mRb6BR7Re9WtCQ6KmriYO3RywhnJt6E6A/RkoDva1m3vwxE6SC4
         YMfSQO/+NG+NgFuX4wZjnYHxakotbY+nzzx1w/MHLr+JTK4PItJZY+bNlisQGWMhEo0B
         T06Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIW7lqkVf4LmYu8PAoO8rguM0HoLM/ydKX/ggT4LofEd9YJ9fbOvOsKUcYEKe+aqzK6YoVvtC91RTmAy4pMuRxB6yN+zY9D6M=
X-Gm-Message-State: AOJu0YzsC3cCCwDQ34mOoNYvwnbQDos3GFsurnn3bhdPz12A+weEuhnx
	b0IUoqTz6HkCKmALCNeRWimAyocFxBwpmYM65kzPyku62/0jnDnD
X-Google-Smtp-Source: AGHT+IGB07JOeLXyWGxhruoog8ATzipnYUw/ZWM4f99QwxnPadWqwP8bL4PFsFnlu/KaSWs0YM/T5Q==
X-Received: by 2002:a17:903:2290:b0:1dd:7350:29f6 with SMTP id b16-20020a170903229000b001dd735029f6mr1956561plh.3.1710946478818;
        Wed, 20 Mar 2024 07:54:38 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:38 -0700 (PDT)
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
Subject: [PATCH v2 03/15] bcachefs: Fix typo
Date: Wed, 20 Mar 2024 22:54:05 +0800
Message-Id: <20240320145417.336208-4-visitorckw@gmail.com>
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
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 216fadf16928..f5a16ad65424 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
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

