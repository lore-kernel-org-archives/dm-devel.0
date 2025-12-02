Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3EE31280D
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 12:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764677545; cv=pass; b=Bq7QHn3lVYT9QY7cT1mP/s/1teKVfBKutv2ouseLTHPOcYKEFN1FB6ARb8FD79iPsNb+0/eSB/ZoX+gMzR8Qy2T2O1NFrlU4ksyiajVRTm7njkYds2BQ//1Tl2W4kEDDy8jrWR6OUSBa8pi4FhB/ox3q/0f+eaybdz1DJ57Fx2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764677545; c=relaxed/simple;
	bh=TS6mDIsZor5eFsA8Qomc44SHWTWyqbcVSNNej0FQRFQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB2RbIiS3P9ehmtZfbQh9A8kgbxnA8Zkn51DvcjSVZDirETnBMAOfDdJQ0XgLRUAjfSYinuIdg66EItg+gWR6JCQvXWOaSALnJpXvXkjDwRs21ys7wokugj9B5f8/2ckD8ez4CPcu1+Y1BbfdDKaVZF1iFwEbuJRzcMDpSAwlsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=loP/if0E; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="loP/if0E"
ARC-Seal: i=1; a=rsa-sha256; t=1764677526; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Aa3a8Xjitv/DiomLV1hHZ6Co0GSZKjfnxKkHGmreHLwlw2+hJxhquIsOOA3bn9NMRTeMcTf+XmQYxeJArPRvqOA+AGmgk6sF0ArNZlA8wG1lOuqCt15JnBqGg4UfCYo5IPxTUkjzcMk86S+731WHaFewQW3viFidZdP1Hxs7WOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764677526; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=vAsEvzdYup53HdslfNVkhOI9I6zIwVzd9GgWg/CjMWU=; 
	b=O8Au0+oWzNfsyra5UsX8+rIUcYHuaOQi+NL9k5lj59HdTnpWSVjeiSjY9lyKVRFJc0nadZ8h0SfHAq7ZWnDsgcRUj4HhOA5KCLcJUZMnysLB39BTtokI7YXkafGd6/ZWVGCC40G5P5F3A94udGxKLtXeA8TPaeBXQtkB3zIc9cU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764677526;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=vAsEvzdYup53HdslfNVkhOI9I6zIwVzd9GgWg/CjMWU=;
	b=loP/if0EwNtk5y7nYZ+RX4Q2sXafbK8TwjnrKChkdceuXmAMgwkADnzvQtFubMXB
	v8sT/Stn+G7iLdHbGZQ8731jdwKZXD6aUvRbZZMw/6E416AtRkj6ftcLNJIJjFaTAYB
	X/ZakgieJv8STxAs1Ekc2kqUEs9aRaUuUZkaLhHM=
Received: by mx.zohomail.com with SMTPS id 1764677525155931.6215095890258;
	Tue, 2 Dec 2025 04:12:05 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 1/2] dm pcache: fix cache info indexing
Date: Tue,  2 Dec 2025 20:11:57 +0800
Message-ID: <20251202121158.111092-2-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251202121158.111092-1-me@linux.beauty>
References: <20251202121158.111092-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

The on-media cache_info index used sizeof(struct) instead of the
4K metadata stride, so gc_percent updates from dmsetup message
were written between slots and lost after reboot. Use
PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
info_index with the slot returned by pcache_meta_find_latest().

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/cache.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 698697a7a73c..6d5001548628 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -8,9 +8,11 @@
 
 struct kmem_cache *key_cache;
 
-static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
+static inline struct pcache_cache_info *
+get_cache_info_addr(struct pcache_cache *cache)
 {
-	return cache->cache_info_addr + cache->info_index;
+	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
+						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
 }
 
 static void cache_info_write(struct pcache_cache *cache)
@@ -40,7 +42,12 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
 	if (IS_ERR(cache_info_addr))
 		return PTR_ERR(cache_info_addr);
 
-	if (cache_info_addr) {
+    if (cache_info_addr) {
+		int index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) /
+				PCACHE_CACHE_INFO_SIZE;
+
+		cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
+
 		if (opts->data_crc !=
 				(cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
 			pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",
-- 
2.51.0

