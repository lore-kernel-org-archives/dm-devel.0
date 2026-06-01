Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363023EAA0
	for <dm-devel@lists.linux.dev>; Mon,  1 Jun 2026 05:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780292988; cv=none; b=nWPpGM+OwJh+GHCoa2if4V/WAu+s8LJayGH9G05Tb/2cf9Y8FkZFWAUJixitVg8PKfkrGxolzge/j+uDPteWlwa9QjSdPzve4Tj0NxXK7gM2Y853xj0KRb2xDMHdnXM2Fm0l22YxX6cu2WKl/SG6vHthanf07SR7BB+hQ4Nrv1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780292988; c=relaxed/simple;
	bh=2K+iMnPOC7o4r+K53x7+nvA7veVuiBlc05XFEWdQm14=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VexOYFCK9+WIg+Gf/MHMojz/+FiDbkPZxbYbs9d+VnFLhnZrVmloxPhfbIU3O9OGRfvOmRS4FsVfJFoip08PcuJsVEHCkNGIcAKCRg5PB3B0e1+3ZNfrWtNh6rYqaYypHZE5Udd6fWdJH58rFGaZUgfR22EEmjJGylrYpE4OEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pOv53I6T; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pOv53I6T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=3k
	+8kse7HhPHe6w47ru9IC1GN9pZ2LBF8w6Wqpfd1js=; b=pOv53I6TYOkOVRJd0E
	ZjwJVAunE9XCA0zqtbd7i8Ntdl3agGTEb32lmNYMxlHCcDcYYi6stltRWMl6b9kX
	0BtQRberm+SAgpzBiB6DVc7me982E1VR8uNIYRYIvLd2KT/UBdnD16vh4Q+maF8k
	/Erb2EryBhU3U3srI/xBJqPVs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAncVRWHR1qZxnMAg--.236S2;
	Mon, 01 Jun 2026 13:49:14 +0800 (CST)
From: ghuicao@163.com
To: agk@redhat.com,
	snitzer@kernel.org
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] dm cache: make smq background work limit configurable
Date: Mon,  1 Jun 2026 13:49:07 +0800
Message-Id: <20260601054907.75261-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAncVRWHR1qZxnMAg--.236S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4fZr45ZFy8CrWfAFy7Wrg_yoW8Kw4fpr
	Z3Wry3CrZ5Zw42yw1xG3yrXFyFkayrJFWUJFy3Jw1xAw1Yyr1qgFy8tFyFgryDGry5Jry7
	uayjvF95CF1jyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwVyxUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-Bo-0WodHVrKKAAA3a

From: Cao Guanghui <caoguanghui@kylinos.cn>

The maximum number of concurrent background work items (promotions,
demotions, writebacks) in the SMQ policy was hardcoded to 4096, with
a FIXME comment noting it should be made configurable.

This value was originally tuned down from 10240 to balance memory
overhead (~128 bytes per entry, ~512KB at 4096 entries) against I/O
parallelism. However, different workloads and cache sizes may benefit
from different limits:

- Write-heavy workloads may need more writeback concurrency
- Very large caches (10+ TB) may need more promotion slots
- Memory-constrained systems may want a lower limit

Make this configurable via the module parameter "smq_max_background_work"
(defaulting to 4096 to preserve existing behaviour). Clamp the value to
at least 1 to prevent setting 0, which would block all background work.
The parameter only affects newly created cache devices; existing caches
retain their value from creation time.

Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/dm-cache-policy-smq.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index dd77a93fd68d..646f7c8936ad 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -21,6 +21,16 @@
 
 /*----------------------------------------------------------------*/
 
+/*
+ * Maximum number of concurrent background work items (promotions,
+ * demotions, writebacks) that can be queued in the background tracker.
+ * Tuneable via the module parameter smq_max_background_work.
+ * Only affects newly created cache devices.
+ */
+static unsigned int smq_max_background_work = 4096;
+module_param(smq_max_background_work, uint, 0644);
+MODULE_PARM_DESC(smq_max_background_work, "Max concurrent background work items");
+
 /*
  * Safe division functions that return zero on divide by zero.
  */
@@ -1816,7 +1826,7 @@ __smq_create(dm_cblock_t cache_size, sector_t origin_size, sector_t cache_block_
 	mq->next_hotspot_period = jiffies;
 	mq->next_cache_period = jiffies;
 
-	mq->bg_work = btracker_create(4096); /* FIXME: hard coded value */
+	mq->bg_work = btracker_create(max(1u, smq_max_background_work));
 	if (!mq->bg_work)
 		goto bad_btracker;
 
-- 
2.25.1

