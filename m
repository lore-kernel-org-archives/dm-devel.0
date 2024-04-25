Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4391A149E0E
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 14:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054717; cv=none; b=MGr4TBBI0XLAn1FRBs42hPOkSkikl6CLHhSOKM8zw+QUL99IXEl5Ky8HoJ2idDm3omlCdmZscXsrCRIHxQ0NlBjwWAcvkMI6eTfvIeAT+8LthGOqGM21BSLthvR1rBJizKGFB6gVGJaBYk/3pfXb1laMEOVNapZZtM1wEGzG0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054717; c=relaxed/simple;
	bh=nxOjcL0P74qvHOhUa3G1KBblKkFTMO6kAC1ncKWnWeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OaPvtYpES4UeOE6S8E9sjDdoLmtWpvyCPu3RtA6OfpzpRZK3mrcX7R1Izl+LH4DmyedZsnQmBuSW8GFpchjgaV5sYIRX5at1rq4TQMtYtFwAkaB119tigkd2g1YJ8fp9F7AWzs05upH7RCazIwLkr58e5zZtZe9cmf7YsB7wUiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZD00Aqr; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZD00Aqr"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ead2c5f3f0so107875ad.0
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 07:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054714; x=1714659514; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SpcFxjVoRf/8zZFpl0pURM6bbS9rd+3CtG1qRJbE4oM=;
        b=EZD00Aqr78LGF3uDRbqp7hpgXaBNHFovf+ptypyJLV08zinIG5yWIhpgRox3AVIONy
         /n23Wc8+hFzUn/JfKEcBIcPXXYNuqhX+vUPcpmBWbrE11RqE/5G7dEcvdnl1yS1ysSJg
         k5fKNaRxpNEVEYPEnVYCO0qYHkgd4BwL3vx9RUZc+sl2Rr8CTONOkY6NHdoUzT+gmd+w
         5smFK21GNDbvsn6bu0fWZZkE7IV01+75tmDwBRo1aQf9Mwa8xNP9Zngs6kSzstjbSrvo
         UL+jKGqkwvhvnduWdZVt38OFXUmRj/W2odL0mOIbuKunCH+ov90z4zdzPFATy7rqn0RX
         fIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054714; x=1714659514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpcFxjVoRf/8zZFpl0pURM6bbS9rd+3CtG1qRJbE4oM=;
        b=exli1wIZbWu2oAis8N0HIrs5uvuLZYAeMFPOjsganCscvfGvj5FvF90TGF1qjLCnV5
         Fy6CR7DKj6tpoq+nHeXlWntdPoS1bgj20OC1PkaY5+txaG5Aozktea+fEZRzQ71hRUfx
         CfAcRzhz3oKciHJASIlM6u6dOuffLjLvl+2DxaTF5hW+D/ENK4ccwEWI+OPzt1Rhdaej
         00RTh+uRMJ244Nz6PtQKI22eYyPTS+jV1vciz+hmaQ8BySBIyfoZJaMdBFT6Tur3WQLb
         0VyoCbveA9tKRgOcQ3YE0j+9eodMGqX8uncuPM1QyflPVq0ADDyAXbl1rTSBmRM5HERK
         S4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1HeM0pgBTR6ksanZN2rT1ambNh6JErN28YlsxLcCSdXV+UzFiRJ48tjK13eWGyBqfpe+cgUhiiiQrRbMXWH3idNzXn2YGPKQ=
X-Gm-Message-State: AOJu0Yzj8CQKcCehgIweVtVWHfO5Ob3TYRQthgKLPx0Rvgdgs5y0wjx2
	Ufo+nvVncx1n6SKGltsHA2pF/sTHgp971TK4UoJdjAXo/rla1CET
X-Google-Smtp-Source: AGHT+IFFwWUen0aR7eKwdpRgMzVD+6uL8RAt9TmXJdXVYBDk+NjjHhRAaa/zcyng5BqcXFQvtoTOsA==
X-Received: by 2002:aa7:8a50:0:b0:6ec:ceb5:e5de with SMTP id n16-20020aa78a50000000b006ecceb5e5demr7018753pfa.0.1714054714442;
        Thu, 25 Apr 2024 07:18:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:33 -0700 (PDT)
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
Subject: [PATCH v4 00/16] treewide: Refactor heap related implementation
Date: Thu, 25 Apr 2024 22:18:10 +0800
Message-Id: <20240425141826.840077-1-visitorckw@gmail.com>
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

You can preview this patch series on the 'refactor-heap-v4' branch of
the repository at the following link:

https://github.com/visitorckw/linux.git

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
 drivers/md/bcache/bset.c       |  84 ++++++++++-----
 drivers/md/bcache/bset.h       |  14 +--
 drivers/md/bcache/btree.c      |  17 ++-
 drivers/md/bcache/extents.c    |  53 ++++++----
 drivers/md/bcache/movinggc.c   |  41 +++++--
 drivers/md/bcache/sysfs.c      |   2 +
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  67 +-----------
 drivers/md/bcache/writeback.c  |   3 +
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
 22 files changed, 522 insertions(+), 395 deletions(-)

-- 
2.34.1

