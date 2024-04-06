Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FF0405FC
	for <dm-devel@lists.linux.dev>; Sat,  6 Apr 2024 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422074; cv=none; b=udC0w55Se/EeoYXIetlcFA7XYWqhmnWTgVsWi0cH3qLQd3nNvdTP04C/nkohq6AdMXLjwKwZB2CLi1FnfOBXNTNsm2i7jwc9meMyMTABO+vQuhwmX+6CVZdH/G+6IkVRqHxVZ0QONBaSpITWQUFG3cnAVzqo2nvIT5kWhWg9PBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422074; c=relaxed/simple;
	bh=ccFsqSUbNmoZfjXj/UyIC9+OiMIUuYR/yY6H+xsWda4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rx0wPDHzAU2rRmwNbvqtNEgvfdx/ttyt31UY0FJQfIcgoUCrtdt5XehzTPhTDdV8lVdqBoaFi/GgmM+NbzcfRAkwjbHEjF3uaUyzy4CTpzxweJF+zGDbs3MITC2jx0bEDYsVR1Q03OVGidOldJs4mku1hQfZ5g4CS3vsTJze+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMe264jE; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMe264jE"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e2be2361efso5185035ad.0
        for <dm-devel@lists.linux.dev>; Sat, 06 Apr 2024 09:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422072; x=1713026872; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=VMe264jErWrCT6D2gkkpDrw9oELcM6wKIfXk7Zi+Rtf1iek0V/BBUd+40+C/8hvp4T
         oHImMhIy5dJYgtgmu4UpM5SoEYwy6lzUxiEDYg7mZuONa36tbm5u9z6/PCdLbUYajz1u
         OlqVUuuYs0b2ZaF4JsVvoqoehjhEyirTEL8YnGXVAM1E9FjL23c6NcRIC8qdsJolRn/g
         rPN3sw3KI/4Hw5JVGGfz4Xo1bJJiM2okj4uhovvxUyLYyD0vrLGvIpKjIM68XNvgRhAG
         1dp3WyA8LsoMCxfQfomX/RmzNd0IhUwvabzT2bvvJO/zI6VjMGsK6SfayBtfRdQZUXvA
         x0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422072; x=1713026872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=r147slC8h0ROVX3beLM7pJqnLjiTrHd57eQDjHcydwGYW3qfLMErixMkcPy75Lz29f
         al8l+4TqVGgKoRPHBGmGs+CxhmahXUYYeEv2h0pdfqnYt8ANa9uHEQs+Dq74ciQ5eHbJ
         M0kkInX/4K7OlnqTh2jbNPY9lgWXvx0di3b1h7XjskgUSX2YZvDvNise3FmlEK4Q9gHh
         29I1mwU4Jb+Lo58MjIsblfsJ3Yt+EKav/s+XFN70ff18RNdNY6SHI7zcjIl6OYF43gNu
         7flPRjK+F0PvuDDoSwGNFSMehFYDUW9TQFi8cDXlyGvpdLSv1uK/FOXTZf2+IZulCmF2
         O41Q==
X-Forwarded-Encrypted: i=1; AJvYcCWNpY0IDCtxDLxeHJBdKpqg2YiKWFS+hlbpJKTSv/GHVZ2y8A1cUL9qaRhe87aomZgqhYgKbxnrmqWJJsoeSHjRyliNFvuSgfg=
X-Gm-Message-State: AOJu0YxyV1L9ZCYLlcSTgKDeYLLVXuwVZIl89VRVbCAc/r+/gZWGPu8z
	AKpdK/DpcBwYIzBZJzAcbnf0O0HNUb69VT5QxlRKkr+JgEc8MWcS
X-Google-Smtp-Source: AGHT+IESrQr1BMS174R7mCr2kWozgHGWkRclCRX2j+JKeepJa2bhuAUkxjh7AUA1DUqBQHFdW+tuww==
X-Received: by 2002:a17:902:e84f:b0:1de:ddc6:27a6 with SMTP id t15-20020a170902e84f00b001deddc627a6mr5190843plg.2.1712422072419;
        Sat, 06 Apr 2024 09:47:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:47:51 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v3 02/17] bcache: Fix typo
Date: Sun,  7 Apr 2024 00:47:12 +0800
Message-Id: <20240406164727.577914-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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

