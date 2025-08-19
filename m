Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F9D2517AF
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 03:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575051; cv=none; b=YFc9M8qKRV3tLcm2V7hVlH+zX1UxutVgQpWo65WDyia+Bui/RZN3PNYGSC/BGmIp+fkjpKAtfY4vNFzost0/bYJXWWU6k5LO1WraZuYRfjo+tIB//MtBEi6THSrkWHgBCTDNH1spoc1AyEOK5Sstap/IpuUa9/YmxnaX8PzXvyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575051; c=relaxed/simple;
	bh=01J/naTgTY4xMeQNO47c3QYV+MlmAGi5A/neq/oVWyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXAMVQWnCmhz9mj/rsN0peM3t/CHg91p5I6n3PLlU2d1UH26ybUkLFJsLXuCQAQgRcPN7IvGSxdq5gil/byZ250NBdBDQVp9fOpdP/owJm/KbxccOT2QSdlgs+/+OrHpSsKfh8kFgLdb+ea7PRR+uaFxFODHoNJ8dS7M/yyj54U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BCIgeSxg; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BCIgeSxg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755575047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWaYeECxHZryKDl0fx961QDsrGBIGGo29UU6FU5j7ds=;
	b=BCIgeSxg2LsTSypIW10PGkYa4lMIunbkXuh8DjLDUgVvxiGzNi6OIiXPCBCWSOu3EQiRmH
	lqrcVHc30xbbryEq2UmwE3dbH1kljWhfw1wSGMnPmrjBUk8KdKX/q4iQg7Qeei541iYeaX
	b6TXQyjcDtYBVcT+xHfxKBZ6//uHfRI=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	dan.carpenter@linaro.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 1/2] dm-pcache: fix uninitialized variable issue found by smatch
Date: Tue, 19 Aug 2025 03:43:19 +0000
Message-ID: <20250819034322.4109073-2-dongsheng.yang@linux.dev>
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
index 992a1ad98909..e0b90bfea4fe 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -45,6 +45,7 @@ static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key
 	preempt_disable();
 	data_head = get_data_head(cache);
 again:
+	to_alloc = key->len - allocated;
 	if (!data_head->head_pos.cache_seg) {
 		seg_remain = 0;
 	} else {
@@ -54,7 +55,6 @@ static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key
 		head_pos = &data_head->head_pos;
 		cache_seg = head_pos->cache_seg;
 		seg_remain = cache_seg_remain(head_pos);
-		to_alloc = key->len - allocated;
 	}
 
 	if (seg_remain > to_alloc) {
-- 
2.43.0

