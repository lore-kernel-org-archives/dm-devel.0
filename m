Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF29ABA2D
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 04:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396968; cv=none; b=lv/0P9EbRPLawEKZrmj6HofBOzfKytE7Y/7hXg7TAWlDZ5SPu6f6eshbL4hPXdE+XAXXz3l14inwoBR46z52b94I9DMf1MOk+fFxf2q7HUG5N+Fiwzs18JSZ4nB+jV+s2ivm+O4LLTapPT0Q6USz/jnLuaWJGwKEA8k1/kXitO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396968; c=relaxed/simple;
	bh=gyiMjnOkGCmWLW5uchvMDnKTgZ6y7fEOmN1SFiFPiH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qXJ+E1P7KgAYq26apSoLC34bqXyHmcSoJHjI6pSAsK25+INyUv/kv/oB2b8TJPK5xipn+9qszAXYLu9g6RCqQj3LHTqhqku7JCykqNGLew9xHq9/XXczS5ZF3Hx9U2RzXnzqu+hU6BLMMI4sHXAjHHZkmKQ+xZgTlcDh3Asg2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1mIQZg6; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1mIQZg6"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e2ed2230d8so2532724a91.0
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 21:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396966; x=1730001766; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iUBoTJj+mB6KW0shlxuElBqdCTCqkeGFMIEQuiMOBQ=;
        b=h1mIQZg6h5hDSKjDKQWfa0ya5zx2bQ9SpkyomQaqID94U5vPLgRLqvLTA6bnJ0jAJK
         lpIkvDJ6X779NQptblJc9XuS9bnIkzZCuez8BptikRrYLJyo+E71QPouepT9+LcMDhe1
         la5oUGEknmuv0kQilhPtUW0py7I4ZgbnWWYGt40zRIOfA7R65HmizQtdgV6XPicHr13E
         6Zf9afSj38cAmX8T1ZEMd6lI3tL61d5II+UY/M4KxuysQiXY80TnyulM3dT2kta4+1b0
         vTm68Hb+uYEuI1ibLsYpRV0Ep6hlW4dFFpHR0CXsbjAeN4H9Z4rtL8cuO9Otl3+gBZLH
         hgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396966; x=1730001766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6iUBoTJj+mB6KW0shlxuElBqdCTCqkeGFMIEQuiMOBQ=;
        b=oekFtanO3b5wAKCPWSXi7KiSH0aRTIfypCXdp+JCJAJ8VkvRbn7HIcVqGXGxO/GxXT
         1nyhC5dZXdmkQTnkmHARy/N8+R3h/xqreUNPcTiTCBNwyr3icHx5Wcv6E6o/mfwMb1xB
         36cka8ERoRQHeLWfM79xUe+3U61BDXmhtJfETeK7KbzXvhPiPCShP7YFuPLUC8bCYzYt
         3C6b4Z1psyOCXxQdoehXP57Z2jHLMTpT2eOLCRqvsFhayx7g7M6WjwQMKnPbvQ39SUAO
         HTKxLLnJkWVyQ6+QV6+ApFcn2JX30oX/YMJqr/BTT8wmuhemhLTRh4ogPIWRYSa4gNrq
         wTQw==
X-Forwarded-Encrypted: i=1; AJvYcCWBT8E9l6TsC66cDYOn3SFLb2qf/AWIvbCeoI9oPFPXZxmrx6Ppdg5RdLpi+za+i0VHvEIczwEnHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAPdxOQPBaY3HiwJDu+woBsTp5UvAo/zwSLbU2eV5zSpOh5y3O
	eI2BTXKNRqNyVg06lbtCR2LAeY8SrxjNSOLYlmm1GFb2ZqFPGEDh
X-Google-Smtp-Source: AGHT+IFe5P6BuiYtbffd1mimYFoXtDFoEUK324MarnzRvMXI0QJHbhnkpia1+tu9/eVZZvKy7OgAww==
X-Received: by 2002:a17:90b:4b4a:b0:2e2:b211:a4da with SMTP id 98e67ed59e1d1-2e5616ec45bmr9060331a91.14.1729396966000;
        Sat, 19 Oct 2024 21:02:46 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:45 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 05/10] perf/core: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:55 +0800
Message-Id: <20241020040200.939973-6-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After introducing the default builtin swap implementation, update the
min_heap_callbacks to replace the swp function pointer with NULL. This
change allows the min heap to directly utilize the builtin swap,
simplifying the code.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 kernel/events/core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cbf365e67f6e..0e9be5b323e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3778,18 +3778,11 @@ static bool perf_less_group_idx(const void *l, const void *r, void __always_unus
 	return le->group_index < re->group_index;
 }
 
-static void swap_ptr(void *l, void *r, void __always_unused *args)
-{
-	void **lp = l, **rp = r;
-
-	swap(*lp, *rp);
-}
-
 DEFINE_MIN_HEAP(struct perf_event *, perf_event_min_heap);
 
 static const struct min_heap_callbacks perf_min_heap = {
 	.less = perf_less_group_idx,
-	.swp = swap_ptr,
+	.swp = NULL,
 };
 
 static void __heap_add(struct perf_event_min_heap *heap, struct perf_event *event)
-- 
2.34.1

