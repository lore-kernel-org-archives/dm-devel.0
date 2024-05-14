Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1514A96
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676454; cv=none; b=Cx4ORLpzJWCG//NJ+/jNujK30auMCiPOkdbUn+nb79Iga/Gd2ExMK8bcx+BI/zVdnfs/cEiTciugNEYeadlFx5EsWiyno7hc7fsmcYH9NaHkiNSdB0AgFk66oDttcdrvIMgKBgX+RiEwjLRLrq2Osgy4LF8Mxzku+pC3kg9buW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676454; c=relaxed/simple;
	bh=txf3GnyQFLfXu7zMmkhDi/TH0fKi1KIpohTmThZbPuE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=snUuYs9z9uhNph0dTGWC5i5bMfqIQVTBorluWS4wVceCg2bFnWD0j0DxKSbjGwWw/ooIUZtphrp7x2fDs8l1AVUUJ3XtnL9fN6jHb+iL6Ahx3r1oAeZd2p0aSIWm2zGUfPiRJKXmebNNxfyQ1DRd4T2MajOjsoVYSFqyKRI+bD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFUiSai1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFUiSai1"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2b33953a163so1332801a91.2
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676452; x=1716281252; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GgH4hDCrjzNiv2eZBuWZJDEdDc4793wBYCaaGxBbWOA=;
        b=kFUiSai1R0J2piKWFoGVNhHtwChpbnwgPtmhyIyGDyegfxS9otyq1HaoTLDnxbWWj/
         GM8iwpzB/RCXg6IkaUEdzfd78bctihh/4OF2/NxeTeEAPitdAbHmIGCs6gOoBQ0njG0u
         3VGrfaXahBMB15bg96E5L4/xatCsBKFFo+huTH2g6y72UaBo6oyZvsfC9KOwYzrb6k9w
         mZFEYlJQT0MmoIxFa0n+y4uaAR97Rr6Dd5MouHvOKEdaHQZSnxGgEexQzEQAN0eU4Xee
         1ssNXVfEKQdw8MYn9pCqB7jt8DTuUDYHhg1xEbk5k+LpoGRoqIlcjaXwv2JUxscgCkxR
         x3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676452; x=1716281252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GgH4hDCrjzNiv2eZBuWZJDEdDc4793wBYCaaGxBbWOA=;
        b=cTL7Yhan1aTGuuOErDR9Anq0naEVv4ZrDTeaq4vQmNe1+zWTGgyE6ShRScbAazhhg1
         6+Yg4OEpNhc7mjD/2RO4C2Y7UL/xvFthOQue7n+q00WpTH//iUM0rwj3HVS5MHIgxZYN
         ATApwwU+XJX+WAHUt7Tmun5mtJgf7P7eGxKoljiujU4WNMO3zmm2KwbE8w3VRgMpWV4W
         s7Oss/6TFG8ZKCuPTm50pFkgzrmQ94lv6TFtEDvKTbWYSS24iAKn5+r1MkYXYWScDeof
         Pv/LlpQovU/TBQekfzPW3hbnu6ZpfQBPsbdKWNWBC3mssOy0hDRPFi5/z0a7hdr2qncy
         q8Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUNqbxz77CaHyPdhs53yOJYNVRBSvQCwxIYcBOqkqXXc8RF7LwtRxHC2UThJp0O6ryeRgr42/Y/GU9kc0YfAKG98JMctchPZXc=
X-Gm-Message-State: AOJu0YwIcLF4ZAoHL9Rk80JDqSJGf3f0HoQ0PLU2qlMDNqskQu+XG9Ex
	J/+uaoSgwAtMXcQd+8EvUXunekF1FLH/F69T610U7Rbm657KiPTx
X-Google-Smtp-Source: AGHT+IHUKv+JLvDL8auK7rPdX3rN7CfOHjH/bzG9rOw8hKZ9CUUBFDIf3ULxRf72o6QfdJIwlXiLPg==
X-Received: by 2002:a17:90a:f10d:b0:2b2:916d:d89b with SMTP id 98e67ed59e1d1-2b6cb7c7dc7mr11296654a91.0.1715676452068;
        Tue, 14 May 2024 01:47:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:31 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [RESEND PATCH v5 00/16] treewide: Refactor heap related implementation
Date: Tue, 14 May 2024 16:47:08 +0800
Message-Id: <20240514084724.557100-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series focuses on several adjustments related to heap
implementation. Firstly, a type-safe interface has been added to the
min_heap, along with the introduction of several new functions to
enhance its functionality. Additionally, the heap implementation for
bcache and bcachefs has been replaced with the generic min_heap
implementation from include/linux. Furthermore, several typos have been
corrected.

Previous discussion with Kent Overstreet:
https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu

Regards,
Kuan-Wei

---

You can preview this patch series on the 'refactor-heap' branch of
the repository at the following link:

https://github.com/visitorckw/linux

Changes in RESEND v5:
- Resend because the mail service failed to send out all patches.

Changes in v5:
- Rebase on the block tree to resolve the conflict in bcache.
- Fix missing initialization for heap data pointer in bcache's
  bch_btree_node_read_done().

Changes in v4:
- Change struct initializations to use designated initializers.
- Replace memcpy() with func->swp() in heap_del() due to issues with
  set_backpointer in bcachefs when setting idx.
- Fix an error in ec_stripes_heap_swap() where
  ec_stripes_heap_set_backpointer() should be called after swapping.

Changes in v3:
- Avoid heap->heap.nr to eliminate the nested types.
- Add MIN_HEAP_PREALLOCATED macro for preallocating some elements.
- Use min_heap_sift_up() in min_heap_push().
- Fix a bug in heap_del() where we should copy the last element to
  'data + idx * element_size' instead of 'data'.
- Add testcases for heap_del().
- Fix bugs in bcache/bcachefs patches where the parameter types in
  some compare functions should have been 'type **', but were
  mistakenly written as 'type *'.

Changes in v2:
- Add attribute __always_unused to the compare and swap functions
  that do not use the args parameter.
- Rename min_heapify() to min_heap_sift_down().
- Update lib/test_min_heap.c to use min_heap_init().
- Refine the commit message for bcache and bcachefs.
- Adjust the order of patches in the patch series.

Link to v5: https://lore.kernel.org/20240514084209.556112-1-visitorckw@gmail.com
Link to v4: https://lore.kernel.org/20240425141826.840077-1-visitorckw@gmail.com
Link to v3: https://lore.kernel.org/20240406164727.577914-1-visitorckw@gmail.com
Link to v2: https://lore.kernel.org/20240320145417.336208-1-visitorckw@gmail.com
Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com

Kuan-Wei Chiu (16):
  perf/core: Fix several typos
  bcache: Fix typo
  bcachefs: Fix typo
  lib min_heap: Add type safe interface
  lib min_heap: Add min_heap_init()
  lib min_heap: Add min_heap_peek()
  lib min_heap: Add min_heap_full()
  lib min_heap: Add args for min_heap_callbacks
  lib min_heap: Add min_heap_sift_up()
  lib min_heap: Add min_heap_del()
  lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
    values
  lib min_heap: Rename min_heapify() to min_heap_sift_down()
  lib min_heap: Update min_heap_push() to use min_heap_sift_up()
  lib/test_min_heap: Add test for heap_del()
  bcache: Remove heap-related macros and switch to generic min_heap
  bcachefs: Remove heap-related macros and switch to generic min_heap

 drivers/md/bcache/alloc.c      |  64 ++++++++---
 drivers/md/bcache/bcache.h     |   2 +-
 drivers/md/bcache/bset.c       | 124 ++++++++++++++--------
 drivers/md/bcache/bset.h       |  40 +++----
 drivers/md/bcache/btree.c      |  69 +++++++-----
 drivers/md/bcache/extents.c    |  53 ++++++----
 drivers/md/bcache/movinggc.c   |  41 +++++--
 drivers/md/bcache/super.c      |   3 +-
 drivers/md/bcache/sysfs.c      |   4 +-
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  67 +-----------
 drivers/md/bcache/writeback.c  |  13 ++-
 drivers/md/dm-vdo/repair.c     |  19 ++--
 drivers/md/dm-vdo/slab-depot.c |  14 +--
 fs/bcachefs/clock.c            |  43 ++++++--
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               |  76 ++++++++-----
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 118 +--------------------
 include/linux/min_heap.h       | 188 +++++++++++++++++++++++++--------
 kernel/events/core.c           |  29 ++---
 lib/test_min_heap.c            |  75 +++++++++----
 23 files changed, 583 insertions(+), 467 deletions(-)

-- 
2.34.1

