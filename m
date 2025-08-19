Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B802BE64A
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 03:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575054; cv=none; b=d/ybmkhGuZdx8IRsdVS3NALhcY3jyz1L+r/EwnKPJeMJYr1ysPvoPEhOwhxRczDEWwSILXOA6jHY66XJ4UoTL4MczOvTOXi2rUNnwEHUxWmGB+5Rz1vUBkYhyjB70ZokmuT3/2fCGGUfdW7bOtIAz0Jd2wt5Hf/DXGIMNjvV/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575054; c=relaxed/simple;
	bh=UVPYWbxBrRWBzU+6An/sXzN09ZaeZFWdsJ6tQy83aKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX3+Q76HiJqbInD5+yO2aKTm3ekoDQCSrIDZ2CAuPEGvi15Fx1feekCKwwcQAbG06MJ4pv4eIMsXUXPHw++M9pYONryImviVcApW4GdAitfgqfdT2iUURO7FLyl4JreQiw+FFYsrELS1Xrslky2YKKqynR5Kyq5TqkA5+Is43fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ViWHfVc7; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ViWHfVc7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755575049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qzyD6ti4KX3G/UYDHTM5xn8PhNa+S9Ukffp3SQqz0w=;
	b=ViWHfVc7EaL9QxTyNsCnuqifVJCnyoT27erEflMMELq7WmW1l557fWmrSdb2z7+iWld1i1
	MhvehmQOc6QU5P9VjrgQllIX3pGECjZ804T2Eu86RI7BcnNMSU9V38wy+5IFhaTnX7WYH0
	+0x/z9OC1eUlr6nJKUdB4Rib1PqLcSQ=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	dan.carpenter@linaro.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 2/2] dm-pcache: fix an indenting issue found by smatch
Date: Tue, 19 Aug 2025 03:43:20 +0000
Message-ID: <20250819034322.4109073-3-dongsheng.yang@linux.dev>
In-Reply-To: <20250819034322.4109073-1-dongsheng.yang@linux.dev>
References: <20250819034322.4109073-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache_req.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
index e0b90bfea4fe..bd5cace7de71 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -298,7 +298,7 @@ static struct pcache_backing_dev_req *get_pre_alloc_req(struct pcache_cache_subt
 		return backing_req;
 	}
 
-       return cache_miss_req_alloc(cache, pcache_req, GFP_NOWAIT);
+	return cache_miss_req_alloc(cache, pcache_req, GFP_NOWAIT);
 }
 
 /*
-- 
2.43.0

