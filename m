Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60245433AD
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755264668; cv=none; b=mddpSKec7Dx3g18HNRkfhRM2Cu29Z8OpgyEJYYwIpnePxVcSkJa4+qYrj0wp4pHyYA+YUlff/W9OYdFyqYDNHPplCaQlKcp1NLUn2KwvElGPjWci2BWGkSN08TCbEIcapxjYhjTwEmhNFMyDmE58o4C/g+cDz3Rz39uQ7tmK1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755264668; c=relaxed/simple;
	bh=zDUlxLfRgXwX1HNxXQydw+BpOCqBqE4BqxVu27gNToQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fBuEssNpJXiBXb8pJkforOLWvpmfeHJNI+drS43azaLxLuxOTnV33eOLX3fxrWcKivNPGIZb564qko7irymb+PDubV30K2hC6QIUkwylPvqRl+rVRtSlxWjyoakHSE8EG1T3Yi+R+ICuTghAbiH0zAfcx3MIFXOSUzcfKobImsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wht6ZfIq; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wht6ZfIq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755264663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4BlU6gTgc5L5mr/SmK3G0ku7hOIcuIjjj+irY8fHpMU=;
	b=wht6ZfIqjIR545QstdJi6ckhe8a8IqBTP2UvCODbZXosIcWcwLTp9RSjQ+CEVy9DziW6kq
	8ltSuc4VVzFiqPFoLAAlI3BegU7cCZR6MovxDCJ0RsX4STwLwRZYsmZxqrTCliWIW6v31r
	CQiy6DKRXN+Z5Viqeti7tR17YFmB47s=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	cengku@gmail.com,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] dm-pcache: fix uninitialized variable issue
Date: Fri, 15 Aug 2025 13:30:52 +0000
Message-ID: <20250815133052.8138-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'ret' varialbe may be returned without initialized in some branch,
this patch make sure it is initialized correctly with 0.

Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508151712.qMqD87iI-lkp@intel.com/
Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
index 722d7e952262..a7dafe8d35f7 100644
--- a/drivers/md/dm-pcache/cache_dev.c
+++ b/drivers/md/dm-pcache/cache_dev.c
@@ -21,7 +21,7 @@ static int build_vmap(struct dax_device *dax_dev, long total_pages, void **vaddr
 	struct page **pages;
 	long i = 0, chunk;
 	unsigned long pfn;
-	int ret;
+	int ret = 0;
 
 	pages = vmalloc_array(total_pages, sizeof(struct page *));
 	if (!pages)
-- 
2.43.0

