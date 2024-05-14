Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20587B64B
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676153; cv=none; b=RNPiQdE6oNCmn3pgBTBhlTsMsrc3k1t/DIppBZaczjQ5kA0bmPypDC0T3imfoleewkrGHEAqmf3v3J+ONXoB5M3xnX46fn2mzUCGZjMsyJ22mrzIL3H7wy/LoL+IbE0cWMbrIJ3atAZSHbeIFeb2fOFCyuwATKg9dVDUeRlqGhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676153; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D+sh/RisXHnPxGG2NDGqAdlsFOCIrNgO8j6Bqyks5qLkKo0jVZv9Qpju2MOvAlUsbMJL0W3WQIZvZwpTAT5Fa0R9Hz7Puxr6iTYEEaH1gkZl20Mxy0pD1YzF1RCDZKoHs0+knhy+DFnkcFBs2rfihlxrMRDs8jSoKVc1YZ5IjzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSzBemaK; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSzBemaK"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2b432ae7dabso1396919a91.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676151; x=1716280951; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=DSzBemaKNoWSQ3vf/32Jax4zyppafyQTJ8RHfW/I7Xlx/QwptnJ17+vOF40mCZi8Fa
         1Pgdv5MqCBhN9PNcXZmd/x+3kcJcDXMjPO4t8xb0CF/H+h5K8dAr3sbEG+7y0Yfut3q2
         a+AkU/spsGB67gNaDWBjcJXQB70V8CKaPwYcrqAfs9oRKFKX7NCjNGCMnx6trxHnoQUg
         K6qLJ3IjFoxptqSW/jKOIfdmsjOZRUwNEEVuhG2XqPclIxiYGRSq5ip1bdYvY3H5AWtT
         bmX3H5aFZn1HpPrHZ0cTDq7a87VTtYgQQk4Ve5qeNyDMQ91ymtW9RUk0HNOgcf12969f
         Q9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676151; x=1716280951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=BY4V08bB7F53W/IE+l6y9VPKgAXI4TKk7UhJCmy4qemqcUI78wlvHYt2E+PcfUWbwb
         vmIwNFmT2p0yaqmPo1TUuUKixt6ii4eSqCvCdKRwUiabCy8DW5zs/hz8wyayiO+KIVqZ
         Uy09258CsKfkDk1sShyDOk+qUcUoFJ2Fuiq9KEla+t3xGsv8xT9d2JWwych9ZPS+DhTF
         lSFnvx682RdpKT5zB58PtkNzaCZ8REyHuQiESftAl7SP0UNg9TeLkJKXlEITSCH1qpe6
         VvtQfGKwXUhZG7nttrIO1T3Nqr302kJPLulw5qJcOQIgzrXGjh5d9fYu5sdOzr7fMRry
         P7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaRTIaEK2RnjjBiWkowfitM1s3k6ezGp8pChwDH4bYIRPPwnFgYt37JJZng7sCPn6DGhLx3Jkh2BiAtUvG5TxFYCyrUBeJ3WA=
X-Gm-Message-State: AOJu0YzPIZKd1e4X9AJd2bULaHFHNB3HHYWBBzBALuTHTMuDAP+TC51Q
	1BujFGaFfoTFbwQtQqgBPt5+t6wVeyeD2P2+xDCCzTf+IDY3HKdo
X-Google-Smtp-Source: AGHT+IHMszeOY4aAAdI/i4ffwzMWNliSsPw3Q+23+WsNGHJxJXzXpy97GENiceXTiX672LAowbBt0w==
X-Received: by 2002:a17:902:d507:b0:1dd:b883:3398 with SMTP id d9443c01a7336-1ef44059da0mr141304555ad.4.1715676149503;
        Tue, 14 May 2024 01:42:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30f96sm92411045ad.179.2024.05.14.01.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:42:29 -0700 (PDT)
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
Subject: [PATCH v5 02/16] bcache: Fix typo
Date: Tue, 14 May 2024 16:41:55 +0800
Message-Id: <20240514084209.556112-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084209.556112-1-visitorckw@gmail.com>
References: <20240514084209.556112-1-visitorckw@gmail.com>
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

