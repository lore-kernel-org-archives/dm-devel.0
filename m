Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39913CEBA7
	for <dm-devel@lists.linux.dev>; Wed,  5 Aug 2026 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785950217; cv=none; b=tt4MMOeDryRbnkkY13GAQqr8TH32uAxUvtNUvxZlPDuL6pknh9DzfrbVsIKp8ZwskyfIrRQWcJPGgmT13CIAIWYtRhGEpp2Zw1Zq2HjmkG2Rrw5HanD1g8hNjT0p5IQYB6rQqadH8buKnXcRtELffhd0a6xy7u9rUbmCQagPeuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785950217; c=relaxed/simple;
	bh=61hOSHdRcSQvef+MVyz7VMXKTF4406B2mDU6fZCOjlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nY7Hg2MEsLLQti96TgGztstUUVUe5sMdDqnZugHwokjt7GgO+kEDMth6WCYdfB1BlypsBq2Kgij31gZVdiXvJAA4NHKrxAT9o6ES7luFnlAwM+rbuwyc66XYEFrX7WUp1fpu7uhLXpJGFOBZJlyBnXq1qa+loG37dQYZL6cZ3ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPIZOmcC; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPIZOmcC"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e50979c71so127169885a.3
        for <dm-devel@lists.linux.dev>; Wed, 05 Aug 2026 10:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785950209; x=1786555009; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8+MjtruiJEICdVzo94Bi/JZM6/fj4g6t2JFO8BqK4D0=;
        b=YPIZOmcCoSu11PqmNgLTZrsZzMZYmJYdIzJ0B0r7ZUWQUNTMP4sTypCO0wabCAx1Gh
         k9G8uKrsxridpxqrgYlnKpl7qDKRaLmiVLM2xc6ZzWkZCmlL0j9odMP81hZO9pekf5io
         qxHPfRzWfKJ9PrQCA2Zr1QjqGsJIhRl4jY+4ABCCJm/4GBrGLZseJIKb4baUmwiJHVI6
         pWvBeI1IWyrxiN7yLiaYXHpkdcwqhRuEUuevw8KF5QjfuBuzhOdiKkXYysoEOJCKbafP
         rA3Fyf4bYA460MLUc4LSmRAHz0TR5lmqZok5NUwoa+Uiohe68dXkkSTSYXrJHYkqK3pw
         1KcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785950209; x=1786555009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8+MjtruiJEICdVzo94Bi/JZM6/fj4g6t2JFO8BqK4D0=;
        b=fT94MaLaFA5CzcyqYdlKMGhT98Kq1gaVOXuDAWqxn0fWelOuJ4LvE6PBfwjcmCfTRa
         a4b0WdZ4Vzezd6m6QPMTE0e4vbFlDmxgkaJSz5chvXgxJCFvgPIImMK2IQ1d34y+UVps
         GmdsOrYHq4spCQAIjz7o1idNZq11tOzHc2WxbJAWbf9pQJEJy54VEcNGIF+uwmABPcn/
         TbVyBXJmMXtOjiI9UsHSHqA/zPSI2PEEWigPjJG/Sa6Rb7P83fof3YZojTpmGL4fLYO4
         aBJE89A0m5Ow3mc/i7Zr28AuDaRMZJuX++I8/MnT6EIwAaDBuscdcUh9llx4PLTELtKp
         nQKg==
X-Forwarded-Encrypted: i=1; AHgh+RqLscdYQ1pH5a17NCqxJbYaWPctaT7RcP86cWO9ryk3sBG/mljKAkGchD7O2GIlFAtqTYaqA69GHA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyFKxIysb4d2Bfhv8msMkRodJqcXZfEpdcHI23OpUdRC0JLVKmS
	RyKx634qmeMTDheRwbBFU3V1nNNvB7YJKiSY9rwwQGjjRy06PwjnjVSx
X-Gm-Gg: AR+sD12EGQLAAvi7AWnOLsbWtlMDs28+oOupAd0mHSQ53KlI7iaTtjQMXdvZhW0vllZ
	l21o9EaIk/U9ZHkFxPzEVENXB8fYBqNka7tmuuCKVD6lgaB/s2umnaGI9LRmTA67phX8Y8+pgmZ
	k3XBd03zBtzKNcC8bG+GpJLXZjG0D2bFXXH8g8wqi+Zi1ZCxDzQPYA36pIPoOQkj+J4cdghFjz+
	alti0M0Gm1cNBzwF4E14SRGzuCmIYoRMjvKkL73yD2ApT28s08Ks8k8C59OW9ME4HT3Pv9p67XA
	8jhs9mZT4PUJSh3XGCnE5Of13ic1VRSYi88IpeGUZRX7LMDgHV16PlIDUiEW42dfS5+LkcpSOtt
	rSXBw94JGl2Tn/UBZ7lrsChZ5500CMRTRaf2D+KJlG5S2bDTPzKIYxxRb9qmckDYtzEP/QHp8a3
	WnaSOU0yFhYFXvbL8bz9Kv2Hqzsm6RblC5zy3ea/nFPAvbVFc5+nuNlmi0d4fncKLj5RkNk/Up/
	ZHFkW/zWXahgg8i1w==
X-Received: by 2002:a05:620a:a18a:10b0:92e:6637:da8 with SMTP id af79cd13be357-93649190171mr629657185a.28.1785950208674;
        Wed, 05 Aug 2026 10:16:48 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a5654d4sm191207485a.36.2026.08.05.10.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 10:16:48 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] dm-pcache: fix use-after-free during cache replay
Date: Wed,  5 Aug 2026 13:16:37 -0400
Message-ID: <20260805171637.3557122-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kset_replay() drops the last reference to a stale cache key before
using key->cache_pos to acquire a reference to its cache segment. This
can dereference the freed key.

Segment references account for key records that have not yet been
consumed by key-log garbage collection. A reference is acquired for
every successfully recorded key, and the GC path drops one for every
record, including records whose segment generation has become stale.
Replay therefore has to restore the segment reference before deciding
whether the decoded key should be inserted into the request-key tree.

Move cache_seg_get() before the generation check. This preserves the
get/put accounting for stale records while ensuring that the key is not
accessed after cache_key_put().

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")

Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 drivers/md/dm-pcache/cache_key.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index e068e878231b..b37d899f2d3c 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -729,6 +729,7 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
 		}
 
 		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+		cache_seg_get(key->cache_pos.cache_seg);
 
 		/* Check if the segment generation is valid for insertion. */
 		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
@@ -739,8 +740,6 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
 			cache_key_insert(&cache->req_key_tree, key, true);
 			spin_unlock(&cache_subtree->tree_lock);
 		}
-
-		cache_seg_get(key->cache_pos.cache_seg);
 	}
 
 	return 0;
-- 
2.43.0

