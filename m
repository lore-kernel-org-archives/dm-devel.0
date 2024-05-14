Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616F320319
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676464; cv=none; b=sQOQo1v35baGMgcr2P4g3Z7PLjlHbm64bYN/htwoAzfj390Icnf/7I6/neFRfPEGdubNEfVZVvmuOI/HjDJQWZUsQLPosZUiA0wwT7XIs1OydOoLgYujYxeUcwOvCDAqw1hCwxufdbQnWLCR6mO6gsh98Vov/BvbyaahlDSzT1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676464; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AHd2AMCFrfBKI/kEqT4oOpW2XWhTotj7yaAVt7Ni0UwjCahSSEGMuf5Z68ywwBpqAMUOGcVUky8YJso+59Q+lU02lQjNWOTTUQyYyZKhG4R6FsqLuquy6XLblZ7JrrCm+XILgVWxYn95BHz5aXlAn0Eyp+tjex1KKBp96erRY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jXiEJlGf; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXiEJlGf"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2b345894600so1226939a91.2
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676463; x=1716281263; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=jXiEJlGfOkZj9QxuPedOUXVK9olFC3D6NUwlEKwuohv0H7os+5fyfBiSSMKqpaLv4L
         mo2JpUF6/mEBIOlz9GEbSPkkm2EJDLpWnnXBBdPaPB1v9zl8hg0esymUsjnbUQRnLhri
         rkyRyU0tX2fdj7RhB0DF6nheSPljKg5IX/+gzlCdiKf95xVb0rFZM8fiIcRjbIOp3Ww4
         Uif1bMBLXkUDjbxOe3IpjuUgViQ5XxdU7EGCusdgaJWxguwrd/PZqOhk885D+F/j5yl3
         NPhKTzzQ3AJzvKiIAXiHJHcDXnWoyBsPphqWw5/yAY9Sju1em/yRK6HUcNNo6Ji3Q/t7
         kB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676463; x=1716281263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=cufIBfwf+fz0UI5QO1xQRkxnZJLbU17WQDL+X6aHyaRsY3AyIMyK9FpmgWdKNWv1Ui
         XXuH0OU8A6BeXHH60FHzOzmxujnueTyoFEmYXycBGDQ8WPSjYwobZGE7bnEk4SmsJ/RS
         EVSvAzUm258swMS7G+ZE7DuSb1a/vgCnnfoIFBFvFrS6O74WaycXyncSXTLtBzM1uQj4
         v2xx2HvELVuGPNEImZ1vEfk3OSX06fzpT66nLOjiBQZ6uI0QCI291U9NZhm8g2k7zynZ
         +U7u3Kr/1H47ONllSKY442uvQH92H5hfV1NDQvnEdVNi7E+6K3Nh4JVPcbhp7dkfr61k
         VaoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGCasL0HH8+NaidsUVlHxxb38V7mtRYLZhKlnPN1vm8IXw5bBEMecprlkZi8v2tuQmFdXUUIPMaSHwmZrx+eT+jysWVDuVfzw=
X-Gm-Message-State: AOJu0Yxd/eIPMCQzeYcfGQAzR+seniAED55wI+cKoWr7W/rMEqSQPn//
	f+G/+V4MJaaDn20+egJZarxsKLkvbQB1Gku9ycI8o4Nr6aSxuM7Ayo595g==
X-Google-Smtp-Source: AGHT+IEMUmx+37VSqc6GRGyY4pOmP+xoAi9mzpeZ5gYRml7jxeXeFDC0FyBMpm/Kb0QmMkl9TuNysw==
X-Received: by 2002:a17:90a:3d83:b0:2b6:5b13:b3b0 with SMTP id 98e67ed59e1d1-2b6cd30d2c3mr11588329a91.4.1715676462694;
        Tue, 14 May 2024 01:47:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:42 -0700 (PDT)
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
Subject: [RESEND PATCH v5 02/16] bcache: Fix typo
Date: Tue, 14 May 2024 16:47:10 +0800
Message-Id: <20240514084724.557100-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
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

