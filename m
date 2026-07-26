Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B93BE62B
	for <dm-devel@lists.linux.dev>; Sun, 26 Jul 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785078070; cv=none; b=u23jUl36LOYT34SGdwztQgpPjm8+9PJeWIeEEjqjkJOolwUnQ4Dm5zek+pMtIw9KJBEPGXq5d2BAyckK4ZkSRnNrQsG+2EyNDmc9LottR/DYHu6GdbXuar0luPHS2uBlRpoJVEGS2r4IE7JN89/g7eC7rrqwhI7RFozXU+5RHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785078070; c=relaxed/simple;
	bh=yCy+uZwLy7fiRVpHjcI3xVXDpsz7L9vIOv2lnrIF8ks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bDmUa+Re/ecQwNX3wapy1AeakquaJqCC8/r8ML6meB9uWHogL/PbFPTgqlf76E09MHNIw5IzbTmCspXHneJDTGwjRENYMqIKRKb1467FbNyn+2VMBeOQPE4J1RM3dsb9LiCq59i4sSmP0nasSYOAnnYD8arCvnSZ/V8rw24dVlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ld6oIyWe; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ld6oIyWe"
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cb3f5bb19aso7192525ad.1
        for <dm-devel@lists.linux.dev>; Sun, 26 Jul 2026 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785078068; x=1785682868; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HrCx7rrv5K6ZNHZRkFUnHMJBLKrPBtFvypp6dmG2pIk=;
        b=Ld6oIyWeabNHJjN0Acq+zSIrqCABT9XTlAfVS5tZ1sQrLUhSWgPYPuk83MfS6/Dcte
         0sLRFscGP4TLtzXA2WtXx5+z3bje6/9q4Q8B2+Gkrt3So5ab3J6AcLSUcXqTJRzze5wH
         CFE6ZN0w9kC+D42Fs3hFZsjtqthBU6NC1D+vWCgxmij56mO5WILgDfVXINdiK+9UmYxg
         QbKX/H5sf5jHkMxq/XcUTjToDhLr7DuS36yVge6TiP0WHdcLgt5U/dOttTjorKl5uaQZ
         kXAJ4keC8FDmRJFEuCDF3y21cCae2rnm17SPbRYKS5BjC8So7NiXPxJAKBeNti4nvqcM
         UQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785078068; x=1785682868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HrCx7rrv5K6ZNHZRkFUnHMJBLKrPBtFvypp6dmG2pIk=;
        b=A4IZf/K91zq2gQcWbyjCxQto8yASYUvoIB6BPissnEzUEp0LjQU2DA3wtgMoAdJwgU
         BtpfBHmLTC386jyAcFVWvkXq6Q1t4Xw4jPXdmWUApI+vfKRreDkXbCUWBmxio+7+I2FN
         pHCBA3x/yLwO1lMdrlGg4PpkD+BMxmUzB7P902KORRici6JrCj6FlQTTtmKTkKsDABKU
         wQOmKFk+KVBppxhIM9W0yV0Lm3xG1yrnXL6iST8IxTZLy3AusINm4RDKKdL/dO07M46e
         hA4UxjAC7HZaRcXLomVyqvNDgt+ph46WlpgSJc9GNvjNu427N3UD3CcabwcTxLO53nPY
         rSiw==
X-Gm-Message-State: AOJu0YwO58JBmLMDPVvJcJp8axWFh8JjLlEw/liJDHpSPmivvcxxA6mR
	hKbb/EW6EDEgH1tLEjHNFfS1UCmoJr3NbyJOHZr8g1xzIUDq8m5uo4DMFDQyfVA46XKWy8zV+bE
	=
X-Gm-Gg: AR+sD13/WSja57GgRpHAmi20C6liDMDNJ4jx4BZAYa6NyZKn/WbSxvoG99P6QtjUcPl
	mSA3qpGFfgVKRgUkb+A9yCZ0TDQP0Dkvq1XSBcWAA9gGTJ11D0DvClceclvMk0m8rTAE0RumNQW
	vF5FL+tbKWvETnl13meHAfd64qsCoiCFrtU6KOPkFlwg1KiqFgycXxjoc0wiy3KjHV/qSVjHsJT
	WyGU0UlozVMeHkHX6zrWOOXKW0ziU75TJwMmdoZBP/6kxRsZyDukP34MfkYFn+jyf4eNjWUhB7S
	ub/d4k3rJuLEuo2B8pYAUgycemp+tdbDlU6uXwahgS3ieypLw3spboWkZGFbzDzxtJOwxsQ/zA/
	3+H0OMFeSybVBWdyGIMkgcOyccdKSFxS1RgeKLJsAvE19gAEPDfkDtkUXrToS2OGetdBKIYk+2Y
	EZer+8UXOlxGY9zXyYwLOScckklw==
X-Received: by 2002:a17:902:cecc:b0:2c9:97a7:f544 with SMTP id d9443c01a7336-2cfde888049mr47702055ad.42.1785078068292;
        Sun, 26 Jul 2026 08:01:08 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([112.45.110.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bb40sm20722055ad.9.2026.07.26.08.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 08:01:07 -0700 (PDT)
From: jianyungao89@gmail.com
To: dm-devel@lists.linux.dev
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm-pcache: remove unused miss_read_end_work_fn declaration
Date: Sun, 26 Jul 2026 23:00:36 +0800
Message-Id: <20260726150036.11524-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

This function is declared but never defined or called anywhere.
The miss read completion is handled via miss_read_end_req callback
instead. Remove the orphan declaration.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index 27613b56be54..317bc8b11a81 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -340,7 +340,6 @@ void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
 
 /* cache request*/
 int pcache_cache_flush(struct pcache_cache *cache);
-void miss_read_end_work_fn(struct work_struct *work);
 int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
 
 /* gc */
-- 
2.34.1

