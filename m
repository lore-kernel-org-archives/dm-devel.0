Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED62C183
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871216; cv=none; b=ZCPPLvFQnSbCXqUXpGjJ41uxj/0oO09bZ9r0MPO+nSjf3xwpRLKvU/vgmAVh8tlm6+/VPElxymtvoGkwz3VH5Vr8jq2e3deasLy9dvJ5HXv+zfZNvhV2G1ZguPq2LAIqui7TUMudrlDatcdPlL61EjZbLxL+kW0wFGuG7hFzQkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871216; c=relaxed/simple;
	bh=m6qS5617TuTpmfK97/po0jJIyNcw9wN2GHQJwTKGgww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YgNU7whFRFdBmSLXS/O/gJ9dTZNrioF5K5ii8+iwqz0fSqsriPM/BIsD+OZBfUjAerkpliorTpnAvQxEyZrAZW87xoybggZ80ZxXQrviPiNURz4dBU9DU/UTXOLezrvrW1obw9/c6/94G/udLiH3DyiZqjgOED1aYt8PUJLB9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmOdKpM1; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmOdKpM1"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dee5daedf6so7810635ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871215; x=1711476015; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/7BfNykyTLG5a+/FmijDVcSSld3Qh/CcbfWa98bWLIQ=;
        b=KmOdKpM12Wq8a9Y3+yKru/BtVyKQxpvfwvdirw7r7VKJLdNxRQQVlSz5ADHMekN5Tz
         ouHjPU41u6QOou9KVgiDxN6YHD10cK1iqHbfHd0MyRARP7GeZlKDKlCcPCl60rfQ3OjJ
         u5WVeTwCn4LomN414Ztg5AnKEOpy3TqYCf8T/rIophj8PpF3bflpq1JEh99/+TMje7m+
         1pEHh4X7DPhnzJJhYzbtX39YPN2MuqD3rqfQ7pSHfle2lfcRxf/MiWvap38c0LiaCuc1
         hkn5B7ePLgilsEfqNnjqrlrk2ZHTuiv12FW/BQwkN6tBJn4OZJ6Rc3OUcRiXccC82J/j
         zhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871215; x=1711476015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7BfNykyTLG5a+/FmijDVcSSld3Qh/CcbfWa98bWLIQ=;
        b=lM8clzJHN2eX3GJ1zFw43fxHV/SSshtt27MXOFDFiHNbv81iWtjXvaTXJljQojGLnx
         UTzi7Sf+UNAvRH0biCXK0a7PVZZCVysNFTzYjzfBGeVxyg8TssXb44BEsTbxTNu+hE7e
         m1LosxCPx1IsXC7l7InO/Rp6PfmeWAIDkhGBNUxcgSGLxq0p0KNBy+yP39l25VZUF7lG
         SPOUlo9v6UZN1TV5CC5RXaVtYvur++oBSPFxr1xvDlEmXuw/PYEcOKLZJAs0PqcgSVSq
         rQzHyaxew2ha8Srtc5+y3g1oV4gpgDSXcJwm9JU/JeOXYojaO1kDfcXhiuBpHUf5uCus
         7FBg==
X-Forwarded-Encrypted: i=1; AJvYcCUBqZgfDjf1n5Tk9aJ115fVrZZosQvGlg/kz1ntTl45jiHV/sM0Ek2f9zFLGU6pAxVpF7C7sW3pHB7i63IUDO6F3EsEKrBA4Jg=
X-Gm-Message-State: AOJu0Ywqh6U3+wfE07cwIzw3oI7mchDV6PZGenw1twMoQOMjaj0fPLlq
	Qd/D5aSAUFFs10g30o4NYePPsIxjHc6yDqEt8Hg4xSVmoWxWxN6Q
X-Google-Smtp-Source: AGHT+IHe8YREwchsBs/MaMDuaMAMnJOq1i+WfWlbqsJTZbtd+9d60AYKAxpEKoD2MKO4iTbMEMZ5oA==
X-Received: by 2002:a17:903:2448:b0:1dd:85eb:b11 with SMTP id l8-20020a170903244800b001dd85eb0b11mr3178823pls.1.1710871214158;
        Tue, 19 Mar 2024 11:00:14 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:13 -0700 (PDT)
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
Subject: [PATCH 00/13] treewide: Refactor heap related implementation
Date: Wed, 20 Mar 2024 01:59:52 +0800
Message-Id: <20240319180005.246930-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

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

Kuan-Wei Chiu (13):
  perf/core: Fix several typos
  bcache: Fix typo
  bcachefs: Fix typo
  lib min_heap: Add type safe interface
  lib min_heap: Add min_heap_init()
  lib min_heap: Add min_heap_peek()
  lib min_heap: Add min_heap_full()
  lib min_heap: Add args for min_heap_callbacks
  lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
    values
  bcache: Remove heap-related macros and switch to generic min_heap
  lib min_heap: Add min_heap_del()
  lib min_heap: Add min_heap_sift_up()
  bcachefs: Remove heap-related macros and switch to generic min_heap

 drivers/md/bcache/alloc.c      |  66 ++++++++----
 drivers/md/bcache/bcache.h     |   2 +-
 drivers/md/bcache/bset.c       |  73 ++++++++-----
 drivers/md/bcache/bset.h       |  38 ++++---
 drivers/md/bcache/btree.c      |  27 ++++-
 drivers/md/bcache/extents.c    |  44 ++++----
 drivers/md/bcache/movinggc.c   |  40 ++++++--
 drivers/md/bcache/super.c      |  16 +++
 drivers/md/bcache/sysfs.c      |   3 +
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  81 +--------------
 drivers/md/dm-vdo/repair.c     |  29 +++---
 drivers/md/dm-vdo/slab-depot.c |  21 ++--
 fs/bcachefs/clock.c            |  53 +++++++---
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               |  99 +++++++++++-------
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 127 ++---------------------
 include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
 kernel/events/core.c           |  53 +++++-----
 lib/test_min_heap.c            |  75 +++++++-------
 22 files changed, 565 insertions(+), 470 deletions(-)

-- 
2.34.1

