Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE99512D77C
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564624; cv=none; b=XQs5KktkYlAVmzLpYhCWO6D/tWg11e98tC5DS/h0voW07OQ4n0AY4oFq0KJKNDbV4QoHyKyMKxWKTfM+gdMVPdTivN67jn+TCfigXHmv4BB1aIhU/+oDxfveet8a5bOn4xnde4llZs7Qml8L8rhNiHLlJJAuwpVOrQL+Mk9AQDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564624; c=relaxed/simple;
	bh=QITT4KyTCrPxTa74Hi4WwUV4Z/BKsxAIzezFgyBB9RY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ivlf+s6XAg3bsq9MCnGxzdLwxQeJdxREykqlJ2ErR4R4uECJbZQI2speXUZ1c2JTKZw5J4TWST/qvsL7vZc0u4Tp4v2WXYWUJrB9L5VG00oEl87cywOlw3UspcqBcdgsVAjZDZWQ0qFG9VZBE6LvooldBp4FV3qVXUHUq/G987s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ecUgcZtq; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecUgcZtq"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2bde32de7c6so339671a91.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564622; x=1717169422; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KHs5Ddv3q6AjsWj+2TI+65ShPcrkPx2MBMg1+BRFwU=;
        b=ecUgcZtq04kfcHBuoZccR+VOUXGGxZo3LOy1cKAV5lNpUwZ4G7qyWuTDYjQF98hj+J
         8N2fMGhuJJ7RpsHPTp5YfGn1jds81NQQ5eKBxVVMM0viBZmdE/R0b8FMFcmiJJhBo3ch
         0Vzljn06P/j9BbIF2xaorlIIB2hBbeAx1ZqnG8lloFI2kBKwJi3phupOzMwYLThVDHLx
         mA/hQNeem/A9Oehb1R4ExlJs9+vhLgmynKDmElgUtq3D0llHOmoDCWoyLwV+UrGgZ0W/
         Zih7fftdb/LjJ8XhEEtbKLT30a1Zo/IKxD7YHlM5EKTX/UzvE1mi+M+2oxAQfXwsOpCK
         vqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564622; x=1717169422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KHs5Ddv3q6AjsWj+2TI+65ShPcrkPx2MBMg1+BRFwU=;
        b=BAQOedZkBMZn9feWPrRika4EZ9SzzLmmVcra9a8eXwJJwY0HmOajb8Mdt8R7JpdGKR
         U/AutR4Q3ed3jOEH0oiogWaf5SiLHNr4bpT+Lmp0LV2/NgX90b8AI4oh3S6AtQP0h6cn
         GhrLYHjpQp8KcOMrnv15NaOvHl6LP2s+363YpTNGxtLsuXtedsRlGZTeNIhVjSRnwi94
         nkycs+nOkeU9C79M7FTV5UUIAr6zmNjlW3+XVvoC6A73ybNJE9gT6p8IeREQl1VWA70K
         6J9sMCHjgUCwQSWpah6X4eLsUnnOcBuIcRJuUXYtfp9sD81yAjfQ19qoKDDkLpd476UE
         +xfA==
X-Forwarded-Encrypted: i=1; AJvYcCVkLvBP6VJgHsclWod0eQiA43zkfxxPGsZNbtIghmx2teiaZshoy7CepktK3KqbUmhgkEOoVmdLRkifTJrE/py83Q9Djbclmx4=
X-Gm-Message-State: AOJu0Yzn9kusQ4S/Q9rTlJ/UmpG9spKKDi9YWhUvn49sBL08DqTfT0HB
	IugsmiiIXmMIn55DrI828RNJ+N1BrHG+REeGj9pyfDqI1E7+Yl9f
X-Google-Smtp-Source: AGHT+IFVINOfwr0HWjlNIswXxzjjUbfsZzMCUUBzLvajmMapEMWFdTSr6TxSvcR9NlquE4fAbl3ZAw==
X-Received: by 2002:a17:90a:ac05:b0:2bd:f770:f95e with SMTP id 98e67ed59e1d1-2bf5e068cd9mr2464878a91.0.1716564622110;
        Fri, 24 May 2024 08:30:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:21 -0700 (PDT)
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
	bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v6 03/16] bcachefs: Fix typo
Date: Fri, 24 May 2024 23:29:45 +0800
Message-Id: <20240524152958.919343-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524152958.919343-1-visitorckw@gmail.com>
References: <20240524152958.919343-1-visitorckw@gmail.com>
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
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index de331dec2a99..65d42206703c 100644
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

