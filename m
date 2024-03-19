Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F512E635
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871227; cv=none; b=TqloK8ozuQXVAjrsBhvG25XZ9KadNsh4bDj2UhvST5KnvLxaS+D2l447o8ldVR1fuic8v4rqNCORrcYYSmgiRugZ59swG96i0rnLNj7RkTioPfuTaFP6pvhD4jiKjPJMYlsAm+nuVRcI4KM3IfNJ+fQGmMnHXocLpiOaib4+SPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871227; c=relaxed/simple;
	bh=fgS7YoHkqd6Gk9OHy+FkIeSgxsebxOkghiQdONm8t5g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G/eA3y/Wxnj8B9ooAr4Zo6MCyqDUg1mm3slkfMmnQpWdmxNL4+G4bzekwOhNrQaf8Xiv5H3+XME46jaVjQCknkXwaN0kgfxhkPSil/3pn/okGhKj+ySrN14E21Tpq69oeR8MuoW0KEK90O5IXJIZKsBG6jXeep6EsmNanO1C/Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXLoRiii; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXLoRiii"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dee6672526so5305015ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871224; x=1711476024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhM32UpnGJPnLVyVQuYFJmPAIet94tyo1EZagEt6PY4=;
        b=OXLoRiiivRJCoOJ9/CKguNi64lJzDNk6PB/VYxKsRIe8NW5xUjtcBAESUdchrleJi2
         iVHdFguaHzLd3d/t64wT32mjRxaiDz9QwTJaJTW58yYMja37DD0lSNANJGRYfM06fFP6
         FZP+dPO5HqgxFH2GssZ5Xd5KoOEJvxa4YR+hVunObp+1Z857dgHrzXYkMcQ82OHRDMVr
         1eb2xoGZiMzZGC930UbZloHNZpRw2CW+fyw3MLt8XuFHw256YMhTylYoJvmyGEeurW8N
         EkP01Dc1WuB14xDlNCiSizX1ftlFXUnjHw7huEuCidbq5z3xaLVDzZzOu/9oOfuQG0E0
         f0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871224; x=1711476024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhM32UpnGJPnLVyVQuYFJmPAIet94tyo1EZagEt6PY4=;
        b=vSHwjWbwmEo3HGtaL1hYVI2qOUE7QxDsGq5q44BqpiJeprr6WKIXJ/Jp2mJTKPGegz
         AYR75U7G2Js/53X18TKhdN1AT6yXIAkCjRGGb5xtZAGx9J3zCic2892nVYAPjQwI9E3D
         ABB4U/+sikr0DPuCu8b+KGEHynIQi8SoiCooBnANXzwfZfJfYr0mYT0X+ewfeaVxIZMb
         w1vHLFPVmphNefFnxV4y0WFov9sZDDCo+UfGJios79aHCMhndd4dBCPAEX5p4scNNixE
         2fNwRRdgshi/coPmc5MwwpRt7EAIrN+xY1Hoa3yRfrjTfL1nzwjaBm17onGmmUfagy6h
         9R1g==
X-Forwarded-Encrypted: i=1; AJvYcCVsM9RqJf9jk7q7IdCtg5foVGJY/d4gSfhxMwkJPsyWueZOLTm9np0CnbYyJMTRV6E9oUSV92QOnCOjeSyM6hGzbcZxhpfNZPg=
X-Gm-Message-State: AOJu0YzgSEuQLT5L4kLvICZaHi4e4MpF4EgP63vP4RzwuSDXcfC82vAg
	jvAr4Mym1OTPmMDQDPGPXKJHwvOOj/HYZnt/v+yErT2XCpEksnGb
X-Google-Smtp-Source: AGHT+IH2KN8j2I6RFIqMV16DYXyC+c50lnC7pdEn/IN/+1SE4kATVcjPSy+d91Y1ECfUYLZTXBbVKQ==
X-Received: by 2002:a17:903:24f:b0:1dd:7d66:bfc0 with SMTP id j15-20020a170903024f00b001dd7d66bfc0mr16665032plh.4.1710871223988;
        Tue, 19 Mar 2024 11:00:23 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:23 -0700 (PDT)
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
Subject: [PATCH 02/13] bcache: Fix typo
Date: Wed, 20 Mar 2024 01:59:54 +0800
Message-Id: <20240319180005.246930-3-visitorckw@gmail.com>
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

