Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA547ECDD
	for <dm-devel@lists.linux.dev>; Thu, 17 Sep 2026 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789638116; cv=none; b=fsDRciYT/ZzE3dBUpRQf2HhezaGCJ8n84Gz6aM2Gkiww+xe345x1MhgjV+twloa+kSGY+BUfRZN+/lYPr7F8ibWoFHC/ehxfG6Gxz+Kk+LMwrX8m5l5iuhl7zx6EbXZSoNh1JE9IU5ChWWZ57equlefWP17Xf1+wgHG6brOnKLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789638116; c=relaxed/simple;
	bh=VSjKifo0ugwIi++98rgQVbPk87BELTpT4aewq/eq20A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mWyI1vi/Z8bS+apbPmFfmH/V7FwsJjdl+UZcbVBP6LLhy+BiGsGelf+5DTc6g8TxbeqsHvZ9VIo7TTxFcPj4dCZPSk+fMV+h8HUW7BVKBT3WnhRyGw8y22lQEIGFMddGLfZzsocy8fb65g4x6367EZNEu5uYXdcfh0SpWSh7VAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACnFUDNtatqg9t9CA--.41301S2;
	Thu, 17 Sep 2026 17:41:33 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: cengku@gmail.com
Cc: dm-devel@lists.linux.dev,
	dongsheng.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] dm-pcache: Fix use-after-free in kset_replay()
Date: Thu, 17 Sep 2026 09:41:33 +0000
Message-Id: <20260917094133.2145340-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnFUDNtatqg9t9CA--.41301S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1kCFyxAF1kuFy8uF48JFb_yoW8Wr4kpF
	W3GryYqrW8XrWUCanrJa1jqrySy395AayUW3y7twn3Zw1rury2qFWI9rWjgr1UXFn3GF43
	AF1UtF4DuF4jvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY
	0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_GcCE3sUvcSsGvfC2KfnxnU
	UI43ZEXa7VUbLiSJUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgQNA2qrq3Yt6wAAsW

When the generation of the segment referenced by a replayed key is
stale, kset_replay() releases the key with cache_key_put().  The caller
holds the only reference, so the key is freed, yet the function then
dereferences key->cache_pos to pin the segment.

Pin the segment before the key can be released.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/md/dm-pcache/cache_key.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index e068e878231b..668c16a2e111 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -730,6 +730,12 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
 
 		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
 
+		/*
+		 * Pin the segment while the key is still alive: the stale key
+		 * below is released and freed by cache_key_put().
+		 */
+		cache_seg_get(key->cache_pos.cache_seg);
+
 		/* Check if the segment generation is valid for insertion. */
 		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
 			cache_key_put(key);
@@ -739,8 +745,6 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
 			cache_key_insert(&cache->req_key_tree, key, true);
 			spin_unlock(&cache_subtree->tree_lock);
 		}
-
-		cache_seg_get(key->cache_pos.cache_seg);
 	}
 
 	return 0;
-- 
2.34.1

