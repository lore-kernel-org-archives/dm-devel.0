Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB9D748F
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 04:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396974; cv=none; b=evUk/R80W17BC9iudEac5vBg8u6DZJ/oUXAFjYzW0Pt2EpT2RvXNfhRpvrzmIjYcQCngFR7pxI5/94ElHzZiIc4TY9jKAcvrEtUF5dXYzmcdsf4xPBgVakV1OwkaTVIvAvKgoe37vQV5xN9W2lC7iyyxtROkDRTjMlnUE18f3Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396974; c=relaxed/simple;
	bh=/9mUaFvmlKksdPlONLh36cpvswwCLSGpPrI0BGH0Huo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ghsx+P7nb+0Llhqb3emXJTQJos73+/MYq46FcJK7r+CwyFwljVvBndzflcbpM0QFfqQLJX0X4756jtYhuGBazzqfRsep4jpGurVjxE41uzvh7f/4PRSvwDWwr+XhlBIIpteoR553HqOa1cVUIo0Guvuo+4wo6Rmtr70fDqZMvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aNqyangk; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNqyangk"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e2e23f2931so2799925a91.0
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 21:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396972; x=1730001772; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rziSmC5tfzn2cnt/wqwyaZwuuHhuMcA3Csb1Fp91fpY=;
        b=aNqyangkWV5MOusHaczzhOxFAiXRsPs4I7fPU24+InuDfyG6rUJM8mv6FSquI4I24F
         Z9wbzEGlUXDTcJAYGDAzgeuqZWyXH6o6u7QJ5SVy2s+Gn2mMON1BjWuupcrHHCrGXBje
         +7GTnhdoCbnEJul5+/QILpLPuo5M4YwL1zHPLv3pBetsVJx14TArHZPmVWceRh+j8tTw
         4R8fKk0vkKyGTMEWZSisAiqbh8uy5tzieTnYLaAxbi3SvdEJONtmoFJ40MfbFaqaz5VW
         df71Oba7e+h87ihT8dW05ch3Tw0mHlHA0LhoE5mzSgn19B0DFcfCobmTJHDdDzK/bPgu
         zh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396972; x=1730001772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rziSmC5tfzn2cnt/wqwyaZwuuHhuMcA3Csb1Fp91fpY=;
        b=t9eebm2uTt8VacdrhQ4NImHwliXRddJNN5JlxMq9VyZwjq2ge071SiMUfdqgQ9UuYX
         T7PUBua795GP+72EY0JzCEldLJVrSJp7B3Jeay/Dl6vT9a441m3yv/dup1gYYmxGmyEo
         W0ZVwhdQ3PiWLs5VpG9juK7VB1eXwqN/EJ2XwKLSq7UPakAnTY7yPJoZTeW2HcDBNuUi
         imAU5r/6FBDdpGhM1tZPscYQk7T53pasydkKutcscY01SunJUPgCrGLwCcnA5389Wu2Y
         AmCOJsUKew2Y9+XS8CzbXCtUN944JV/J6NlErNMhA8RI1fqlYFW09k9aWlsyvv1OLXu3
         WJ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmXVRAC/lbt7OntxD5YKtHL9+W5S5PGP+aSomAZU1cZGfAGybOO8IvwQqimoBf0Or5lbf/CSkH3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YylpNffjGubtdbVcXqwpzFiJJai3L49x6S+/c6u5MZ2TW5xJgKP
	V3oKkqO2LNbfrFA0IuAEVIgY6Z1DN7hnt5+eWD3LKEJwhnRz953d
X-Google-Smtp-Source: AGHT+IHMW+qjGNk25MwSR4+vnQ0D8s1Tp6FfxwQfHJa9nSOWn+djBGN5YnBTiCdS6y5VPlsk0p2NZQ==
X-Received: by 2002:a17:90b:3658:b0:2e2:cd6b:c6ca with SMTP id 98e67ed59e1d1-2e5618f0839mr8748941a91.25.1729396971559;
        Sat, 19 Oct 2024 21:02:51 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:51 -0700 (PDT)
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
Subject: [PATCH v2 06/10] dm vdo: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:56 +0800
Message-Id: <20241020040200.939973-7-visitorckw@gmail.com>
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

Replace the swp function pointer in the min_heap_callbacks of dm-vdo
with NULL, allowing direct usage of the default builtin swap
implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/dm-vdo/repair.c     |  2 +-
 drivers/md/dm-vdo/slab-depot.c | 10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index ffff2c999518..8c006fb3afcf 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -166,7 +166,7 @@ static void swap_mappings(void *item1, void *item2, void __always_unused *args)
 
 static const struct min_heap_callbacks repair_min_heap = {
 	.less = mapping_is_less_than,
-	.swp = swap_mappings,
+	.swp = NULL,
 };
 
 static struct numbered_block_mapping *sort_next_heap_element(struct repair_completion *repair)
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 274f9ccd072f..ccf7b2eac131 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3301,17 +3301,9 @@ static bool slab_status_is_less_than(const void *item1, const void *item2,
 	return info1->slab_number < info2->slab_number;
 }
 
-static void swap_slab_statuses(void *item1, void *item2, void __always_unused *args)
-{
-	struct slab_status *info1 = item1;
-	struct slab_status *info2 = item2;
-
-	swap(*info1, *info2);
-}
-
 static const struct min_heap_callbacks slab_status_min_heap = {
 	.less = slab_status_is_less_than,
-	.swp = swap_slab_statuses,
+	.swp = NULL,
 };
 
 /* Inform the slab actor that a action has finished on some slab; used by apply_to_slabs(). */
-- 
2.34.1

