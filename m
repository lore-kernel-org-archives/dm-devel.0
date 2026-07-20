Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F2C3955C9
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784518635; cv=none; b=oiYa5KTRuFHCB0ER19tuBXlqWGGbAz9DsxuMaUugP1HI2GmUL9vduWrs8+nOLddaMDgGmxZQ9NZxlolKPWyDMcTatH2vqlr8aYxjUqibh+BGgwDIkOZnzHRMiexUDJnD1ISz+Lq2y4lyy+pfe2ugUtuNao2pYv+OEfc3z0vpuqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784518635; c=relaxed/simple;
	bh=Ni9LVVOb8ioOCHwIJrRiUxc2nb1LDV4yWGK8w4zlFS4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oOKxWpr1ot/to0qjJhPz7BY+MjnjTM3XYojSJxusYBH79SSyoZhpvWtZhnlloK3Qtcojp6AT9HY9hUGdN8nT11XXdjBzRGV+SaDQwCjCLaGmgOXDUy3SnROUUz703/IL3z6+X5MJNEhEWbyuNdGLlFpjzxVuNDeVWF/727iFY84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=beLY2HEe; arc=none smtp.client-ip=74.125.228.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="beLY2HEe"
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-caf5fee4196so2344503a12.0
        for <dm-devel@lists.linux.dev>; Sun, 19 Jul 2026 20:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784518633; x=1785123433; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=igVSDobxE8AuEHnuAAbopLMDGh11lnG9Mn6rU0MWnLA=;
        b=beLY2HEeiDo+wyrmdA2B/5wohhPDJTZ57LT0uakVciJVEejvPIg1pZkUQ+koYwVfDT
         Q9ZhuNNQVmrmMafjjhHv9EOoC9OOqtb3tIkpiCwGqckXW8OPA2IlvKojjTj4v/MkbDnG
         ldBWfOEVnTYuKHX1nQx9WxvqRo1oFDPQYtEAdfuvSROXRNlJhQEOF+VGIzV9h76yR1LJ
         6KOUQvtR916LKJo35jqGwOsig9RWFtiWCRgrlWn4YrdYt1si+x4hyKGxdQbmv0Wd7C3Y
         3rFOl24av60nCE83X6Fg8tia1LXiV81xJQt9UK8haEKSjTL0EtXXwN402vUdbLUyYkIX
         PclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784518633; x=1785123433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=igVSDobxE8AuEHnuAAbopLMDGh11lnG9Mn6rU0MWnLA=;
        b=j7pUYy1KtH5FNpyPWDJAOKBvtvPPewwjJG8eJafpa4bnX78eplD+MjX0qpulPZcZVm
         6uwooH4CV31SA5NO0yzbY4HPWiKI2ySG2eSkqyDgKk/rYZkfyo+UdNFwTsyrPWUhuyou
         DfgrrsH0L22HQFwZf2+UaxbKLZYMwh4gpp5bOrYof6rVkSw45vwDoZL588M3DtXR6o+E
         GTTDLCr79VPTQ555oNPnxRbNtX+x1i0vQeONhu0bfhNA2qZFqkClIH2xRPZQ8WDoeEsx
         eMzOIEvpvHgtW4501sh9cQHHSpbgPGGcxZXjxyTUqeHIfqgtAPAXBqUOSuhCVqLBlY8V
         rvTw==
X-Gm-Message-State: AOJu0YwPC+W9u+l055Fw3cFhZ9GaoWqCS3X17smXZYpk1Hkep91bUc2x
	4hXGiva0hsxbvFwjxU14kRHoNIe6+hWFyOPPEAq83eUaU47nRS6TQgDWKT1cv6pB7yU=
X-Gm-Gg: AfdE7cmJ94y4poW8+3Tq94haZD2IrwUb4Tzg8DwcfRdTxza81Ti+U/uZ8YJDpKJ0VgT
	fD792FWg8BuCSM+JanGm9RcOT0y+yMk40uCTd4fri4mrhPZf5ztg6+x7MHml9xyitKpxKDNJr9c
	/wv8tCNSEM9afwpu6O0r1Z6cqxXUksMHECsVTRn8AcsLHZmNhW4AyO2vriBQ1TpZvZRpy31qi8V
	Afa682E/vefvVhYvk8R4Wk8e54jyxbbAG2g6EhG+QyLQkv+hY5RDumS0qIFAQ3fjmBJ7cKRaNVp
	Vnlr2y7kc2FbAoC77fBS8ldonzlPE5pkfJYTa1qpfTDeg9hNcFaRIKEzJPEvu4kpmLsR8Yk1UO2
	owtUp2J/32fBg6sqHpyUT4FI6DGASJGsseRhOKS4om1NHdM46bRtIDeSVaL2h3481/qtI4E3by+
	EuGHscZkyZf/mApcPpZu58toRNvPo=
X-Received: by 2002:a05:6a00:1391:b0:848:3e69:4ba6 with SMTP id d2e1a72fcca58-84c29532728mr12201765b3a.54.1784518633267;
        Sun, 19 Jul 2026 20:37:13 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([110.191.179.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af6e3ebsm4811588b3a.46.2026.07.19.20.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 20:37:12 -0700 (PDT)
From: jianyungao89@gmail.com
To: dm-devel@lists.linux.dev
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] dm-pcache: fix use-after-free and invalid seg operations in kset_replay()
Date: Mon, 20 Jul 2026 11:36:32 +0800
Message-Id: <20260720033633.374-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

In kset_replay, when key->seg_gen is stale (key->seg_gen <
key->cache_pos.cache_seg->gen), cache_key_put(key) is called but then
key->cache_pos.cache_seg is accessed as the argument to cache_seg_get().
This is a use-after-free on the freed key memory. Although mempool
recycled memory is not immediately reclaimed or overwritten in practice,
this is still a potential UAF bug.

Additionally, for expired invalid keys, setting the cache->seg_map bit
and calling cache_seg_get() is unreasonable since the corresponding
segment data is no longer valid.

Fix both issues by moving cache_seg_get() and __set_bit() after the
gen check, so they only execute for valid keys, and using continue to
skip invalid keys.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache_key.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index e068e878231b..84bad99d3fcd 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -728,18 +728,17 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
 			goto err;
 		}
 
-		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
-
 		/* Check if the segment generation is valid for insertion. */
 		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
 			cache_key_put(key);
-		} else {
-			cache_subtree = get_subtree(&cache->req_key_tree, key->off);
-			spin_lock(&cache_subtree->tree_lock);
-			cache_key_insert(&cache->req_key_tree, key, true);
-			spin_unlock(&cache_subtree->tree_lock);
+			continue;
 		}
 
+		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+		cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		cache_key_insert(&cache->req_key_tree, key, true);
+		spin_unlock(&cache_subtree->tree_lock);
 		cache_seg_get(key->cache_pos.cache_seg);
 	}
 
-- 
2.34.1

