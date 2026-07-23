Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB39470122
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808215; cv=none; b=pDgQt6On3jyK1aR9s1knOodXZUY8/QGrob6aAiKFv9JU6YZ7FCMXGMGci9soXN3vl6+Eg6RgcNz/+g7d7gLYA7SukYIr1SQHCA77NeOUPc1EloCkzhgYR7ifMa6ythyCrVu3+BEoiq/08+/6j6YzpRm2zjb35Yq5RJsN12UILh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808215; c=relaxed/simple;
	bh=Mv8kH+k8yOGo3/nMEiAZnX77byomhIFeKhZndCHT2Hk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qxn/SHNPDKU0RJ01icLzZHJHEt7tH8pEu7mfMhxJpAVUn5ZcOMeACAWwhiXtLUz5GKMJvUXDRg3Vv8LU34EW6Pj26UNJiikpT7YjFCDCJ14y4cgoLpii2EZtzKXDhWYcaqfcMLJdZ5CtOnwBnr8zceen+iqrmH0j6nY1p5xrRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CVEX7QzG; arc=none smtp.client-ip=74.125.227.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CVEX7QzG"
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2cc7a345f51so4628505ad.0
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 05:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784808207; x=1785413007; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rw3dWDKw4nsP/eg6mc2GWhay0MPg7XDXliSJs6V44Ug=;
        b=CVEX7QzG+c2ZX4dciBreaLSyxNdLgOIiQKDpbR1kgIB0SHbWok8Uc97ofKnW/2ud25
         dEmud4ufIMh/KgVhtMUJnFx5GrZ6uKFpzuMjesBU0A4OhPHLAplEpM8U7HOaLn3cpjGp
         b80Woe6Yy57atH8b+xqG5xYfZhR8AQR1glW6/tDEecxn2BTv8c1sdRl58bhIHz9hPCr/
         C0m0rCnQ/ll7LVPMmf3F2DX1cA3crFkf6tuvKwXujx0Wz48q5oH7q+g2uNr4Tm06smn5
         rJo+HlJ8e33HhF6McAJiI8EOI2o790BOFhOsjr+/APDu8K3AGdd0XvAPDtjU+rmGNyiC
         wXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808207; x=1785413007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rw3dWDKw4nsP/eg6mc2GWhay0MPg7XDXliSJs6V44Ug=;
        b=AgucG/c5osnyedUEHzAYycOjxXA/a3Dx1JqnS0DUlCh3jN5giDqdviFmnS9rg4xdgs
         btmLL07iBOi0k4FWtj8X9Ns1zJBDlYO+tbSmtkN0zL8tvI+uG0ncQoS63jc/ZojE2ZEW
         EiiYWWnku3+sqpyEppgVw/q2dgucXYlluuTOLekvG0+CTOYy7TUohbyZtH5F9VXy8fT8
         B9QdB00gGKnbeDMGGXXCRjiaYsQa1uEPfdbiWHzdv85DTer2pPMWpZUSKJvdgjH862DY
         tGE7ZBD1udzOBSE2lCx2wCNjOHZYoYMqzBTLIhxvg/ZjL03wKhEQCsDS7Ddatadh2HyT
         x3bw==
X-Gm-Message-State: AOJu0Yz+pYQHlFZ5zPxyI9Sk9ZTlX+uPEx+yPCUxGImf4MA/MGanz1LW
	AATZCjQ0Y9vlWjZxoPzLvjBQYGA4DG/kW5zuBTLySyAm4FsOpFUWYXHWssqlGquerZqPIg==
X-Gm-Gg: AR+sD11IL9c9Z/K7m8llorUz7VEcKjNR6TlLAWmrtteVVx/jPPngLBuwV3paEcYxCTy
	UHugfgmJeBEsJvtu8a2e2TsvfOyyPyIMXKIa1QkyWiVcLvrm+2nNHjkFZlNQKGDReFkB/WAJnvc
	2TiPazS1Md5jyOi3M1LYiENvJH+eKHmt4Pt6cqo2SbNCJfHMfqvZJmBDc/vAU4cX9Ij6+8f/7og
	p60PvItP5PY7ZwBNeHmerZmaaq0RzjZighoKuKlTuQGl4pA2iU6V8rJ8waMi/AM565JUUBU98zT
	ZkpVAtkuXk3Irm55xCjUJWB44NJ4OzugHngSGflYZT88X5kQR8bn6vFEhx+1+qQ0Z5Y9eTS5MgB
	XV95RcNrkkaUkP3+ZTE2ejAxTPxMoo9UfeM4Ke+rcTM6l8SijZiJad4JMESUX9A/KimlX7SfE5a
	FaWEs/v4cSC672/Go2GZBAafj3Cuo=
X-Received: by 2002:a17:903:228b:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2cfa71dc876mr30552045ad.12.1784808205922;
        Thu, 23 Jul 2026 05:03:25 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa38b6sm32900725ad.13.2026.07.23.05.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:03:25 -0700 (PDT)
From: jianyungao89@gmail.com
To: dm-devel@lists.linux.dev
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm-pcache: remove unused 'cache' parameter from cache_key_gc()
Date: Thu, 23 Jul 2026 20:03:18 +0800
Message-Id: <20260723120319.10647-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

The 'cache' parameter is never used in the function body, remove it.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache_gc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index 94f8b276a021..75b60c9c302a 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -6,14 +6,13 @@
 
 /**
  * cache_key_gc - Releases the reference of a cache key segment.
- * @cache: Pointer to the pcache_cache structure.
  * @key: Pointer to the cache key to be garbage collected.
  *
  * This function decrements the reference count of the cache segment
  * associated with the given key. If the reference count drops to zero,
  * the segment may be invalidated and reused.
  */
-static void cache_key_gc(struct pcache_cache *cache, struct pcache_cache_key *key)
+static void cache_key_gc(struct pcache_cache_key *key)
 {
 	cache_seg_put(key->cache_pos.cache_seg);
 }
@@ -152,7 +151,7 @@ void pcache_cache_gc_fn(struct work_struct *work)
 				return;
 			}
 
-			cache_key_gc(cache, key);
+			cache_key_gc(key);
 		}
 
 		pcache_dev_debug(pcache, "gc advance: %u:%u %u\n",
-- 
2.34.1

