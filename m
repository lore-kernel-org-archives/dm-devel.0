Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4804431
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396943; cv=none; b=D0Li3yjhOy4f87917Yeco0EnmYdHMG75B88iRlwGF2A3QWFO3t4sFyXnso6x2nJcI2jnMurbHsB+3uDCUlOeFXXlKrkmRhecwuDmOdNV6LyGxur8ehh7mE/DTebzxDSh/greWXBgQC3n1KfjUQejXAWY474a7s3wOCM5cic5q68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396943; c=relaxed/simple;
	bh=PPZcedfeN2xci0bMtr41qkobsQvnGAlUSAMTUIbyAS4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j5J1r9F1yAoc0JOXKFhPeBVzCysYj6CkGBNBgnImAkSDocXq1IxOxyTaoiKkw81I9/IAfl1zxXV99iN3JaY3km1OAp1qrz6vcI1YNB02p0KJHL6o3kcE+yJLfWz5maYfrmluCxzMKUw9bh5j/gqtZo66/nPshjBjuAv7VpPhKQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8/7rOgu; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8/7rOgu"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso2850365a91.0
        for <dm-devel@lists.linux.dev>; Sat, 19 Oct 2024 21:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396941; x=1730001741; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PT29tbH0TQkyRmcXcOhR5RBzyV0h0z0uVsdQMLDTPYc=;
        b=B8/7rOguXhcXtDdPoD1ydw6pZQak3wqtC3HPrPdb3E+tWFMSPwWtHwZbX4QTLAbqbt
         TiDdOh2VD1sdT2lyAl/wo/njxPxHBpq1udD6b2TqB+8HsRAmQy50ZXjoAlOO/czr4sBO
         F1L6eJcYiijYtiIGHWk6UKX1jCF3Y018gGB/e4VfUThFE/ya16vZ7uSPwctF75MhQEem
         N8OGiXtjxV8PHQPWtxvHzFoCCuhkfonICWh6xPFrcrHchwozymMwc02Mf2VM9AeKx34J
         4li9DBxLNPBTnrlHCZEZNrch9UZS/sjcXiwOEv4nYyX66roSSJhqosBIZzISNHeBQsTq
         uSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396941; x=1730001741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PT29tbH0TQkyRmcXcOhR5RBzyV0h0z0uVsdQMLDTPYc=;
        b=Q5qimMOkuuNNBpF0S8wxxDXzoTwwoT56XB//6f0a+NUJlCeqpROczc1K7q7wBV8aDQ
         AdXZl+KyC9VvB7NruF1p+6J3slqgdWpsFCFb7ADQvuFdODr8nOuPMCfIteLW/CJSwHha
         NAzPghVx4Q7fn6LNNV0yuvJhc5+CjLYLeMA04u87JUjqrWhSROkm4Ki2gvDs6Yw8jesL
         t/HTpDwPpUL8RV3M3bhG3OSYAMjntS3DlL3w45TayK/K9YBzBlYIjJ6y79FHJTEIc0QO
         7APopjo3u6SBwIhW9KzI5xn2ufZ6VtcHh4AGmF0ADgdv22kS9SyGuAXYi3uwqBZ59Rp3
         Rv/w==
X-Forwarded-Encrypted: i=1; AJvYcCWXyebLkWqxda6h+8dazdpXZfd+ql7C0hGwn0g70ryBZEzdU0AJs14UcuUnyg8U++elnnFz5Enzjg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxdcng2kUYwJZvpO5THNcOAXZiwfcTC3KnJ67o5QQot7pqfg/6V
	QF5zUoNJn3cGspqCL9lUYJE6qmcrBHJAbbK4jhuyyT+ImUiR7umk
X-Google-Smtp-Source: AGHT+IGmbAyhBDIy64nkkXVLYjxt6z953fnbtTFvv+n4vjmyvQ+UsqLXOPoUEJ4jHZKyS4u8EuhTMQ==
X-Received: by 2002:a17:90a:8a91:b0:2e2:cc47:f1b0 with SMTP id 98e67ed59e1d1-2e5616e667bmr8376177a91.3.1729396940670;
        Sat, 19 Oct 2024 21:02:20 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:20 -0700 (PDT)
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
Subject: [PATCH v2 00/10] Enhance min heap API with non-inline functions and optimizations
Date: Sun, 20 Oct 2024 12:01:50 +0800
Message-Id: <20241020040200.939973-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add non-inline versions of the min heap API functions in lib/min_heap.c
and updates all users outside of kernel/events/core.c to use these
non-inline versions. To mitigate the performance impact of indirect
function calls caused by the non-inline versions of the swap and
compare functions, a builtin swap has been introduced that swaps
elements based on their size. Additionally, it micro-optimizes the
efficiency of the min heap by pre-scaling the counter, following the
same approach as in lib/sort.c. Documentation for the min heap API has
also been added to the core-api section.

Regards,
Kuan-Wei

---

Changes in v2:
- Added a builtin swap to reduce the performance impact of indirect
  function calls.
- Cleaned up duplicate min_heap_callbacks in bcachefs.
- Wrapped documentation at 80 columns.
- Updated Example Usage.
- Included documentation explaining that NULL can be passed to the
  swp in min_heap_callbacks to use the builtin swap.

v1: https://lore.kernel.org/lkml/20241013184703.659652-1-visitorckw@gmail.com

Kuan-Wei Chiu (10):
  lib/min_heap: Introduce non-inline versions of min heap API functions
  lib min_heap: Optimize min heap by prescaling counters for better
    performance
  lib min_heap: Avoid indirect function call by providing default swap
  lib/test_min_heap: Update min_heap_callbacks to use default builtin
    swap
  perf/core: Update min_heap_callbacks to use default builtin swap
  dm vdo: Update min_heap_callbacks to use default builtin swap
  bcache: Update min_heap_callbacks to use default builtin swap
  bcachefs: Clean up duplicate min_heap_callbacks declarations
  bcachefs: Update min_heap_callbacks to use default builtin swap
  Documentation/core-api: Add min heap API introduction

 Documentation/core-api/index.rst    |   1 +
 Documentation/core-api/min_heap.rst | 300 +++++++++++++++++++++++
 drivers/md/bcache/Kconfig           |   1 +
 drivers/md/bcache/alloc.c           |  11 +-
 drivers/md/bcache/bset.c            |  14 +-
 drivers/md/bcache/extents.c         |  10 +-
 drivers/md/bcache/movinggc.c        |  10 +-
 drivers/md/dm-vdo/Kconfig           |   1 +
 drivers/md/dm-vdo/repair.c          |   2 +-
 drivers/md/dm-vdo/slab-depot.c      |  10 +-
 fs/bcachefs/Kconfig                 |   1 +
 fs/bcachefs/clock.c                 |  25 +-
 fs/bcachefs/ec.c                    |  19 +-
 include/linux/min_heap.h            | 357 ++++++++++++++++++++++------
 kernel/events/core.c                |  15 +-
 lib/Kconfig                         |   3 +
 lib/Kconfig.debug                   |   1 +
 lib/Makefile                        |   1 +
 lib/min_heap.c                      |  70 ++++++
 lib/test_min_heap.c                 |  16 +-
 20 files changed, 694 insertions(+), 174 deletions(-)
 create mode 100644 Documentation/core-api/min_heap.rst
 create mode 100644 lib/min_heap.c

-- 
2.34.1

