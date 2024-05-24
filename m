Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD912EBE4
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564619; cv=none; b=GZCjhw7Eew5JnC4lAdsPZh0YbMBs8o2kkd1mvRkKv0OYg1CbWEBSQFS5t9Zm+un+iJxGYKTOXdhggTXv/VZGGSkJAvLlMdjFtkmSaGvONCmmr5MLe/0VJqfaA/rgolFEZ9XuIlcyZ1XzWEr4skERtMQkez40XAWXi6DVVT+AyM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564619; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CQbHdIGkn94GZSVq74akq/pdl5ECb8JUSd5Fzmxh9bTyqggARuJN3QvjolRB0uSDiX5NAY0IBlM7IEVxd3746SUq49DhGsOo0UeppQAmjm3JbZI5Mpl6uwdb3gdorTYEXhrC9nyAX92mJN07PM1vhIty8W4Q7IwA/XY1yRIIyek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLWS6woj; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLWS6woj"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103224a91.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564617; x=1717169417; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=jLWS6woj+oBgqOb4+StxysnxlEWQaOXWvSW2PcV8q4TNxmNTaHsx23lL5TDOUhYTub
         4GtvKj9vIxCPhO+BZeupG/MVeI7zAH3G5EzxRDJOidrzaT8M9ryabcvyPpOQ2JdA2vLq
         BSo6a1B9I5mCbdC97grPWur+Hx6jZMccwBprqz1SftJq63vjLPn+vIyrxz7i1FUzFf9d
         kBhjvsbQNVQF6Oc56A1c5kTkxpl9mhyq1IIN7gzCiH/WXNyY2Lm6jHBDFMqrgr4gHJfu
         cmBeuQ1c3yNNAlt35WzAsVpxykG3nQnDyLHW7bnod/6tZhJeYyMebnvAa1YrHxutOkPh
         Ul5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564617; x=1717169417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=q/rSksTBqTQjsWi1cW5EZkfK5/zYEVFDLJU7ZUi496qFMy0UwmcCDrwDBT9wUAysvJ
         jTqKyOLIo6UjLQFgurRzyk6Sw/e7mlEfXWCuyRianMMWlah0Ypc6t2g5dT/Y9+GjZZAT
         rHIJYMoFu7r/lKE5wCGqvI5ssvivdu2lKWqokXHw3eRnU7e9fb4LltyMsF/TckNJwYHo
         Sx26qN3odSiJfhhXOYobhhD+xbRlUoOfX/28RBx+dV5kvik63rFeAeRr4aYTzcg/c27Q
         Dqysi+5/NaNKQROHxPrKtlAnIc55OB5Df8LC4Fh7wkmywRGaBhxr4n1Vj22+dfcSNEoA
         GVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU4MZwDOMBNWnCQD/ESepoYFhOeYwaMM6EcDVKBB9sNqv9rR2Ii7QAGTHkG8rAesSiz1v5C9RRgEpXAMqjy9mnn+n3T9/ZQPI=
X-Gm-Message-State: AOJu0Yw+F/lI+IPPPzKVrAdBZ+/GYeAHvL1ZSjm6483jAtGnBOcIBaN7
	VSHQRU3whQRtrSpcWg9LW3OIPPGZ8z2lX/d7h98ta3jj/W9ak9cJ
X-Google-Smtp-Source: AGHT+IHJimdIMmMybcJm9rH5sITCKczMXcjO3LFGPLj00xSs2zLYla0SwJEjxRlWlGP0XYpBUqSPBA==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2504048a91.2.1716564617341;
        Fri, 24 May 2024 08:30:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:16 -0700 (PDT)
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
Subject: [PATCH v6 02/16] bcache: Fix typo
Date: Fri, 24 May 2024 23:29:44 +0800
Message-Id: <20240524152958.919343-3-visitorckw@gmail.com>
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

