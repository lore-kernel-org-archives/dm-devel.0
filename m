Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB3A3771E
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871230; cv=none; b=COli4rgmihsIUKFQ3Bt336a+VcGJ6j7t8lhUsWIn663aNcbSZE4lwsrOixu9BwXYA43KCYNtPzwmw+5nEqODYItcse2+TuGP4m5vWERYOLiM8Egrcj2GDjLqByT2B78Wx9KHVQh2S6bcHANIKdvoQSu3UdoIrw0vOx6X6Iqn86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871230; c=relaxed/simple;
	bh=LuMWxrm74Ksk4iutH9RtN0QFCEVnpht0zuIdBSGgoFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZnWKYFcwvFEmGBica0iJAMhAhBYOjhAr8YC7GdwZn20iy4AbknRbZBQSq3vfNtKyY9QltlgyoIM+TqqUfvja2mIMnypQHje/UTD37bgfCZrRe+ldycC8sB9Dyb5tKRXNL+A37rOJNkPH4jRDUrnmnBqUjqDQuY6kwQh6B/HrqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLQxddPb; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLQxddPb"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-58962bf3f89so598973a12.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871229; x=1711476029; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP9XXgpmCWqpAAlyRPQQqYMsXW7o57+TdtdVf+VR+ZM=;
        b=XLQxddPb1s2Hz7bRH3oEr9m4y8na45zoZp/TIEtymbmCLrLjGtp4NktMxDfg+P09gM
         cGwetN3M8x8jPdwkLXM8PfC1mi6hOPXuBnMwE27SUIeCO64pgb08NkD8mUBPUr04dUjG
         gGI/0CTFEvXBS8Wq7eiH1XM3at0c7vKizRGzl23qlQlKk0BqM7axefTtDJlbpXsFUuSD
         Da0+2osqDSlXb5LYqlilBmov1jDqV24+nY2o2GXMFX3hpNn0WVu6kPFCr4dSGqWoLxR6
         AS/c/5S6HW+sVylUK+49EE5xhSlYZt4NSUwfU4Lqozg4YQnHw0amfLF5miBSpU/JEcCs
         zPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871229; x=1711476029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rP9XXgpmCWqpAAlyRPQQqYMsXW7o57+TdtdVf+VR+ZM=;
        b=H90nSeGb4cWRuq9qRB4sZ0DBU7Gb6M6/hqFPe28FKuI5J9JXaAEMqty2OOulrmo0gK
         lHiEluZoJfJA98W+v+CnVHahP+Yfc3ILjh+5Yfq6o7COWjHLI7qc11lkYbPs3XnJZNp3
         qy5dOXSrN8aYkw8dc7AVc8XR1w8OsZsaWfTZE9fEZ5OHa7AkASDczWe5jhYTfiYISmJA
         R6cu7Njg2NbN50FTuHq3xUNLe2C48KCEl6UYDgCFw2Tm1GI1EVb9oRGsScvcefSS+oHl
         azHTZGeyKgrVZ/7HNZU5ChPiL6fw0sCqqQUb+efM4lFs8M/8FRAiXva4YIbK8C5DNmI1
         G3hw==
X-Forwarded-Encrypted: i=1; AJvYcCU26tQP8RXwhkoS5ZpTbJUTSvx7qfPizx1/B4nnADDJP/eDmwLo9sSljd8rcs7pBYw6UvA1gGcGXqasONAjrhIS8pbuZCyFzqQ=
X-Gm-Message-State: AOJu0YyuHER7OTNbmTesc7btMRyla2BMq8Jwxu5jTe1AqwoV8IgaJnGA
	4h2ODcJHKlF24zk/trINsJPV6NlvOj2plgZ66P+3ym8vAXg+bKNm
X-Google-Smtp-Source: AGHT+IF2whbQ9aCeS6gfzji2YFu/DVbEgj2n4mByZSc6EsUXDmYi9IvKNiXNRkgK5ItMhYIsEOJuCg==
X-Received: by 2002:a05:6a21:a584:b0:1a3:673b:627d with SMTP id gd4-20020a056a21a58400b001a3673b627dmr3461387pzc.1.1710871228645;
        Tue, 19 Mar 2024 11:00:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:28 -0700 (PDT)
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
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 03/13] bcachefs: Fix typo
Date: Wed, 20 Mar 2024 01:59:55 +0800
Message-Id: <20240319180005.246930-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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

