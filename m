Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD2722D78F;
	Mon,  7 Apr 2025 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744010494; cv=none; b=IeE6HBg3yUre83iQXDqOrPgvPPCaI+GQp579WtwUMM+/6wXpvC9RKiMcgTS9ljhZrHCVfhK6JoSmtfYs4F4yIGsagve9TXBBr+k2I8egzbEN78zC91A9f82khWbM5NFjL5FVwRUeMLqOjO3jbeKAKKJ6w1Qdtar+X3/aLPPmgn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744010494; c=relaxed/simple;
	bh=4qx9srvVw5/073OAlAi2thUlYG31LR/V0K21OZO/4rI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nvqMukQTDGhk1D0MC0DmiUJoxZQMaO96o9yif0WXcWXVBDMear14QECzBgDE5OJLGOu/VcvbjjTsZlfwmmhvOCoogQiG1KWUo694kVQpuXkXSyJL+ftUbARK5wuzmRkVVAWMWP6Wre4Bt/WcJ2T0VTalAG+xRcKM3Cu/8NgQXDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPCSjXZ6; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPCSjXZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744010493; x=1775546493;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4qx9srvVw5/073OAlAi2thUlYG31LR/V0K21OZO/4rI=;
  b=XPCSjXZ6FyFd5WkmLwBI3gls9ttYBikGsXT7J6CW2yur9b5AAcMVH0Bf
   eh4S7qjgJzVdwH8/+JS3eFHmiU9DZkta75+mWxDaTlBY5vx0HwX53PUi4
   tpCbZwXBaLOgz9/8C4Chu4pC0laA4VzEH7hOTiPKHTtYn8zpGEHrVmau9
   uThgevH3G2oXd3tQUfMuo9O2X1f8Ova2KBJjsN4JwCUnoNL12uAyWMr/K
   gHVhnLh4Ia51uZHRVw66qUMUJCxVgZESTqXdYk2uCHISEKw808JfD9Xkx
   +FRCZtriFkEzFhU5xbCB8hWY4M+otgoo7iMMgIJ01f4Be+q1dfgrclAm/
   g==;
X-CSE-ConnectionGUID: iVHBWgV1RGud27aKBgOQBQ==
X-CSE-MsgGUID: U6xBOKQ7Q9mSfqsOwSu8bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="62776511"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="62776511"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:21:32 -0700
X-CSE-ConnectionGUID: FalYELIfTy28RPnuAw+9nA==
X-CSE-MsgGUID: 0V7vV61KQVaaXUii0bRFFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="127862657"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 07 Apr 2025 00:21:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 596EC340; Mon, 07 Apr 2025 10:21:28 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] dm table: Fix W=1 build warning when mempool_needs_integrity is unused
Date: Mon,  7 Apr 2025 10:21:26 +0300
Message-ID: <20250407072126.3879086-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mempool_needs_integrity is unused. This, in particular, prevents
kernel builds with Clang, `make W=1` and CONFIG_WERROR=y:

drivers/md/dm-table.c:1052:7: error: variable 'mempool_needs_integrity' set but not used [-Werror,-Wunused-but-set-variable]
 1052 |         bool mempool_needs_integrity = t->integrity_supported;
      |              ^

Fix this by removing the leftover.

Fixes: 105ca2a2c2ff ("block: split struct bio_integrity_payload")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/md/dm-table.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 35100a435c88..53759dbbe9d6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1049,7 +1049,6 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 	unsigned int min_pool_size = 0, pool_size;
 	struct dm_md_mempools *pools;
 	unsigned int bioset_flags = 0;
-	bool mempool_needs_integrity = t->integrity_supported;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
 		DMERR("no table type is set, can't allocate mempools");
@@ -1074,8 +1073,6 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 
 		per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
 		min_pool_size = max(min_pool_size, ti->num_flush_bios);
-
-		mempool_needs_integrity |= ti->mempool_needs_integrity;
 	}
 	pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 	front_pad = roundup(per_io_data_size,
-- 
2.47.2

