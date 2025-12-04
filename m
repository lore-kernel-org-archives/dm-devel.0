Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E4A331A7A
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 02:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817053; cv=none; b=MAa1qp7s+vzfmUb4oxM0790+wPGyCsEprsqKK+v2o1lykNteLlmB8af5ttv0kAM+FPAoSTJ4U3M9VkjvV6rPO07xtUakQz/POE10nnF/ILPpOehtFmxgTbw5LtFCJgNTBv5qXwkKc2ntUSAy6+Yhkt16306moWonEbbOjqCnNas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817053; c=relaxed/simple;
	bh=0xsiB8wkSXOuO2DDZVMcQ1gLqowuKhexEQpQsVpnLEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fobtW/ZOv4CnuFhY4On8sKGJzVG5aGNKJBuxG0JQgfidvnDUC5NdgDfqzSXCJXSwR0K4VSSkGBaDkhpAqsY4xH6BxSYkifm+0j7f8NwObactBlr1ZCPPke+ObEf97U5vFf/rThI7p7xezlusKiX65FecK4yXQpk9fSuKsiQk0f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QvNYyirs; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QvNYyirs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764817048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O4xOthlU60OhmrpTn5Xkug79K7hF7jst3bIqPLzPxI=;
	b=QvNYyirsimqrXp4UP8hMdgdodnhwXWEN1zXluP4ea21EO7ubfL5fld7pXQvjmihbhMmyEO
	KCUA/AlRLaHo2Y7ITLpmrVLy0BG/P4lU/iLEpdnWP6vOtvQnfbAMogE4r41WR6BMH6X97U
	BgaNe2v1hrpC3mLGhsZXordRHoZ1kow=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: cengku@gmail.com,
	dm-devel@lists.linux.dev,
	chenl311@chinatelecom.cn,
	mpatocka@redhat.com
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 3/3] dm pcache: fix segment info indexing
Date: Thu,  4 Dec 2025 02:53:06 +0000
Message-ID: <20251204025323.2901775-3-dongsheng.yang@linux.dev>
In-Reply-To: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Li Chen <chenl311@chinatelecom.cn>

Segment info indexing also used sizeof(struct) instead of the
4K metadata stride, so info_index could point between slots and
subsequent writes would advance incorrectly. Derive info_index
from the pointer returned by the segment meta search using
PCACHE_SEG_INFO_SIZE and advance to the next slot for future
updates.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_segment.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index ae57cc261422..9d92e2b067ed 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -56,7 +56,10 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
 		ret = -EIO;
 		goto out;
 	}
-	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+
+	cache_seg->info_index =
+		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
+		PCACHE_SEG_INFO_SIZE;
 out:
 	mutex_unlock(&cache_seg->info_lock);
 
-- 
2.43.0

