Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7EA14A4F7
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054726; cv=none; b=Bmxamc4gQ6Py6a3Dwnu/MfPbXs4shaGnHx4JCiEr4IQTZ/5gVI87kFiKV0D58cJHdWgqGwH99uRPHIdkWrKiYTPjYDB7AqnYMXGbeoa7nbFaEY24w+0Uh2RK8GZzcNS4ebbJnfAzoAuXwmKIbm+1cUiGVp2AszMlXkpx0q93opM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054726; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uDQrt2KTB0+QVLbTdS3q+9yKSbLjv+kx7k0LuSz6elOysfevEkcJuKnUseUEL9gcB4WAJuiH7PTCFptYu3AePcAIDhsMPi70Cu10EjMzmyp7k2zHztW5qn16gRhpb2wi8++4IAKcIHWGmY/Cf/M+qDCT7bZnLIfPzvIBR9SNl0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLK3yO/8; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLK3yO/8"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ab936993abso275260a91.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054724; x=1714659524; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=FLK3yO/8l5TEZCcJCOmMohCK8Hq5nBPNVy2spSe8jUlpxPh5xSGk1CI0W3RHlr2Sf4
         gyHQ2KLdxAw4O92XDQzfxtYeIo+RUoIs1nwXRJ25+1AlhYJxdeObR4k+XDDQ+AbzMYyE
         qzWXkZ8FoEVaw7SffVO1kpoegNmRGJee9quRjcvgZuniVdJIDpBpQmjyq5JsrCslVUHM
         pvrCVpq/W7UebgZ1VQCARPEw0KW20oSxHZQ5kRpPiohzcQNYF3fvWhBxXAXWQzppyXR0
         rRGYVy652SujxCwtjisEqvahKZWLEUqlTBVvYeZqArOmWh0vHKLs1g92xKNr1H2k/das
         o/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054724; x=1714659524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=eAA6no64o5wbcTW3lIsCP0MK30ctfETk2ubcasbCGD0amioIqN6iM1Y+J2+2pu6Oxq
         dyD7rNMef3IJpNIUwYzv0gh0muIRrwf3IXk9tmu8ziKIg4pY6vOxYdO1vhy1Isl1LE6M
         bMwFjlobJQXr4/+CTqqr7XGI1NWkE7VDjgQqXcQ1QHi3B6nfKYlDDLjKNd/BQBAbcaNO
         V4IFs+OlDEPzHjiNWs3HfiFbgn2hcFsc/i9k5FRZXO/bVQ4Z+VNfZiLjx7p8Rk4ee6WV
         vDwdY8xVTIushTAhKz4uBvaMmam41IBJWaWqeoCCIuNebxQzlTKQCDlEixBBw5lqsWNt
         dzRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD1s2QYn42PzkYoCGPBmfKMx+vDunCsvZF8CrnT78co44/Naxw01W5nctU7F5FL7+sXo4LBe65Us5JBh3YjDFwIHl9Q6CKSmk=
X-Gm-Message-State: AOJu0YwzfCl+QFHk1Wf4UdWg8feIhXP3Gkau5kLIzQjqJke3JIxvRHoH
	tO9sDL4UDxBNyZ0mDGJRU0PbNuCw64cO//cXJ8CspSVigAqHPwde
X-Google-Smtp-Source: AGHT+IEQD11OltUE11ifdg6XbUXWB+Wv3EwPvaLgQGSfd4UJ7AD3kkEQJxgz0+FjABEIMkzUpKhT0w==
X-Received: by 2002:aa7:8d15:0:b0:6ec:f5d2:f641 with SMTP id j21-20020aa78d15000000b006ecf5d2f641mr6842102pfe.1.1714054724050;
        Thu, 25 Apr 2024 07:18:44 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:43 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v4 02/16] bcache: Fix typo
Date: Thu, 25 Apr 2024 22:18:12 +0800
Message-Id: <20240425141826.840077-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
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

