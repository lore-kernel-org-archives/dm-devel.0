Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47AE38DF9
	for <dm-devel@lists.linux.dev>; Mon,  1 Sep 2025 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756705352; cv=none; b=GEMm7Yg9vltwfo9NM8i/uGkj4JO0NRO0+540Fhnbl2Eq95dmuiNcXMK0kkYPjGJiF4JodMmtbkW4Ic4EAiuqSF4XH1cQNtwcEUnKG7hw0YDJDbBhi/CyDbrQ82mdt9xBLGMoIEOe4N9ZVRAgdwzKaTVFgRYL1ouQQZ+1wcoHkmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756705352; c=relaxed/simple;
	bh=0RmImEI/zsojxTlzdx670jQ/bQXJF+PeYgP68T1Zzl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j3FIf9u+XoJdzf+Q7e5TkQHN29WK07PmltT10qThZ9w1AWf1jZpFYqUldAPEXVL3zTAxsZZU69Rcq/5A7+d5VRHQ6mbG/q9zqdGsFZfy+vT65i/rwTXGfSskrGRYXhcC1osAgqfcR6FAHQqqODp3IfOQsqScezK+Kvp8agcWY3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fobqIGgo; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fobqIGgo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756705345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tF3H+0p98IZaEamYehpxAY7Z2Wh91ZdW1d/TuRcXo3E=;
	b=fobqIGgoD64iAUo2VyMbmcaItHnvsVQskOkgt3kEiWjXCFIfdz0Q4Wx6Y62um0/jMB1mN9
	OmTgkNAPs+V2I5N+9M6OZJy/9LG06sk2oKfa9aKGf9H3YxF7Nn+RmRcbChHH8jlucront+
	JcUfV4gI+dfxbixy+Qrx48dYIlAMmT4=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH] dm-pcache: cleanup: fix coding style report by checkpatch.pl
Date: Mon,  1 Sep 2025 05:42:18 +0000
Message-ID: <20250901054218.2635583-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A patch from a few days ago fixed the division issue on 32-bit machines,
but it introduced a coding style problem.

WARNING: Missing a blank line after declarations
+       u32 rem;
+       div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT,
	cache->n_ksets, &rem);

total: 0 errors, 1 warnings, 634 lines checked

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index b10e721ab1b7..f005c9d9a7aa 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -373,9 +373,11 @@ static inline void *get_key_head_addr(struct pcache_cache *cache)
 
 static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
 {
-	u32 rem;
-	div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets, &rem);
-	return rem;
+	u32 kset_id;
+
+	div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets, &kset_id);
+
+	return kset_id;
 }
 
 static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
-- 
2.43.0

