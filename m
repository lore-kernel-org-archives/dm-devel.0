Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4011799B
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676139; cv=none; b=jneB/S9bMXSat77TaFvZ/CQ+Jz0n+bkI1fj/2lZE9hhOv+lMWfu+FANdvvxcZDkyWQTSYAuGd8vLxBdrnQgGZlnPisoRgni1S+K/+p8g+3IgbBwhRCNqWZGc/+k4k2j3ZIdLwDtgPJoSzS/aSViOkt+N5yFCWYrAxKAld8WRsK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676139; c=relaxed/simple;
	bh=1Q8a5Z18ALAPhprhT5LIOTCIVJQtLeVbMK0iySVFvAs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FX13ZtvDXhBfWN016avB2v1pW/OGkhBXSAGPiG7NIyIrVajcnh0jWn2oojlc3pqybKvZz9NyD8L8qP6oyhoyRhtTJKi1jZHBsIb058UmhQ0B50+OeRffJnUGehcEXiBTEX8A+qApHfzUNaquci8fnVaNHouDlatiCK5qiaka9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQcxVays; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQcxVays"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2b8fb581e77so512063a91.1
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676138; x=1716280938; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Js4BUNSWfE5GqATWlKw/AIzixsydTldCYIC+ryzPwtQ=;
        b=VQcxVaysbPwRlY0MMmF93Ig7SYbU7aJW8kRKNNmUmIWy8vZJs4k3jduRhm/1AOzVkz
         w1CHeHHgNZhiezMuODMMRbgQoujieOIcKtc62QK2kbAtkwnVFGgyxII7ntK5I1eX6WPv
         y2hT9NN+GDQgWyf8h6ZQvzaMK6Rij0bRQHSQbgzz4EgHIYn7BFxFwiRRgTmg5V+q5Emc
         kQ4RYdbEBxYJBGHz6nZAmdECfunVkF9s5sC21dP6QDac5SD/0DxxP0duwBVmroP+AtIi
         UPrwPBDq7NiSVKqKqaADxqhZnLTFsvxjZo9JFg6u5aWfhPICXln5iX7bjDQH7IUoHacF
         dRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676138; x=1716280938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Js4BUNSWfE5GqATWlKw/AIzixsydTldCYIC+ryzPwtQ=;
        b=Y/47gs0l95ZTqZFhG28UL0BMGO+B7YRd1SuSr36Ry3h355irWbbvtEgo01Vit675sm
         zC+ZY2/0cXf2H9BVDPhy9QCwhjfu2Eb9I8tgiWS/LDyK7xm2uuwtpshskWCstb4HTlYi
         nsd3D6pkEQDhlVPdMlY0N61GM/EI8RZkYaSn1luM6uWbWNOh9WUgQJ8aDxXchd5GvjRA
         WCe+1uB8g7sLjI5kiX9gtXRLSdNd19hY1o1i+HSsn8PeWPR8AbZoDZzcfpWf44xKqQgs
         7TfFltJNt2Q4bPmjy3n/t2Li2Ijo22BEb6mk8Rvr1mZF3InJUD4Qgw1d4Q/W20e2hoQp
         GGlg==
X-Forwarded-Encrypted: i=1; AJvYcCULevXUiAyM7S9FaD8k84OA9zizdH9bixCCg6h4wrGrD+tGtxhKggmYssyW3x9M78Ib1/kkdeS2Cdz/CPRkLpQQNCVgmH6N+yc=
X-Gm-Message-State: AOJu0YyFQqObwOuWGO16od7FjNwuqkfPNfL2NCv4dAztp2xn7rPwxcga
	kxr20UG2rpC5i4LWCia7Y+oHut+FxCnG33Fd6bzo+x2LXxgRdULn
X-Google-Smtp-Source: AGHT+IH4kRyXrCykJ3Dzb4hLqTyjLiHwbobj+9ip7Io2bJaePb+G2VRr/GHX1RuW09L7x7aUOrtPYQ==
X-Received: by 2002:a17:903:2444:b0:1e2:c544:9bb0 with SMTP id d9443c01a7336-1ef433d37a2mr142421475ad.0.1715676137502;
        Tue, 14 May 2024 01:42:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30f96sm92411045ad.179.2024.05.14.01.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:42:16 -0700 (PDT)
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
Subject: [PATCH v5 00/16] treewide: Refactor heap related implementation
Date: Tue, 14 May 2024 16:41:53 +0800
Message-Id: <20240514084209.556112-1-visitorckw@gmail.com>
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

