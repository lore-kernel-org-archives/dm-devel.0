Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6573C43CE7F
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809110; cv=none; b=UvKfrA0VBL2SRFSeIsKw4A3Uy51E8+CN7kwIzNqC3Kxoi2iInXvWWEXu/mhPzZvTJ25mvdZMXDx/b+fpCtLXA4kW+S5txpQ5NRZaTTpYSz3efHP9F0mv0EVFwh/RS4Ob5xhIAJM4xN7mO20E0GL+u8Fmq6gaTV6PGf5ApP34G6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809110; c=relaxed/simple;
	bh=Mv8kH+k8yOGo3/nMEiAZnX77byomhIFeKhZndCHT2Hk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZJAh8QHv8wZSrKZWA1W7ftDKCQisc6OBysP18n/slHfS8bfFAtwQpiOwdSKdVyc28TAfXjoVpafQWfqn4DGEDwppMOk76st2ixMxLl/9ec2CHqAGhJNW6C34E9EOjNeMqWVG2w1mPET13+KPFZm9l8fJUhhDQAhYU0993hr43eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5aaMjYU; arc=none smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5aaMjYU"
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38dbe53179bso181679a91.0
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 05:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784809105; x=1785413905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rw3dWDKw4nsP/eg6mc2GWhay0MPg7XDXliSJs6V44Ug=;
        b=V5aaMjYUwEJR+jCW/IY6f0LDHh6uo9blyGixFuz3IEISAXlzR3rwhgVzVaiTG+oTS7
         rfIr51NnFGAleHD/NRdzv89ydx2N8ml59dpZMKNCWaGDcWLq6ubfGOCRRlzJrNBfPKFg
         UZFmoWMlSL2iM3X7kik/tBZvXyp3hNvW16FWk0BroYF/z50HJhYcGNHhqqFQpmp07HDR
         TYD8HEV6p/F3HIe304mySJAVzO7JUXRCPzF8kWyY10nRaixxM1l3gv36UDUiO/ktFXaC
         Ebs3LW84eksEufRdP0nkck6a/zxTh+iJLMDekQ3Zc2KznHWBCBcwUZ163/yKF+SfujoV
         es+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784809105; x=1785413905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rw3dWDKw4nsP/eg6mc2GWhay0MPg7XDXliSJs6V44Ug=;
        b=jGT6bPC9kahRUsgDQQHpPLISARDdU2URFfcnoWT2Mql+VGAv3Sb1EedHYpYqIvm0ON
         PTVGYIJoaJPyxuGKXkJ4/LE3tLGJ+qjoXRu6ohVWykzkL9ijQEH8kp5uXNBPde5QOSnf
         q4Cwe2mvcYd7XFp6ryHLJ339ZmKIo3bhrfW5KXMWUT7KzU/jcEZYrgOcyw0N7pPzr8OY
         FktUYYhn3OF95FSEWGrdwIyQi4mxl5jv11jNLwt1rdh+SVoDi9aeeWcG6gtSfAJxMbPe
         BI04hE2DAs/bywOOPJMs6+EurKfqvufPMioW0/4/x7RXrGK3en4j5cLPF2hbDKzslhdn
         A+Sw==
X-Gm-Message-State: AOJu0YzSMalcz0Ko1PE3og0SYCKn3TFnmRjh0/+LaT0qBvdqObE76/E2
	SEoGiLnrRx20UbZRJcndj4ipxChj+Lvk0g+dnpL3hR45p5lda9opZcd+TJxncPQEhoqPXrwG
X-Gm-Gg: AR+sD11kn5wSPYzCcZpV4Bn7vTQnod6c8wwIxqtfSAJ18TXFlMmDITeHjDpdNYqY9+v
	emAvQ91mv7sWyFFbGGPPcQZhT6i3YiqdADAsM55Sz/XJks9JQcwDz39ZwHGkn1v48y1a80dvv0t
	em1GBui9CBxk/jVb2xxWlfQjXRwZam8Xl+LH/r7ZNjaiwyyc5zDfh/3ZKsdQnYgDUqUO6ZM0ihN
	bZI1OZi2GgQN2Pffx1cyzCXI5/esPZ0T5KWIuFIk7K5NRN+Ad8av2Is/kCipz65VpEFIbLYEpWc
	urRRz1OEfEAmNSODt77k7CcwL/AaAAqbDb8KK0SVavsTqH1rphIiCPd9Uoelk1yQEtQ9f8L2KG3
	SJP1SI6/ocAiurfF75CUWbN/HroPcb2hQxSQqyo/Ud7FhLWRf/VKoo2PxFJjcSLFRryQqBa+Ag3
	owFh0PfqRVbARDH8KcqW8PfP9waUM=
X-Received: by 2002:a05:6a20:c90b:b0:3c3:875d:c531 with SMTP id adf61e73a8af0-3c44af6e6afmr2913617637.6.1784809105252;
        Thu, 23 Jul 2026 05:18:25 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1a9967sm2646923a12.25.2026.07.23.05.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:18:24 -0700 (PDT)
From: jianyungao89@gmail.com
To: dm-devel@lists.linux.dev
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm-pcache: remove unused 'cache' parameter from cache_key_gc()
Date: Thu, 23 Jul 2026 20:18:16 +0800
Message-Id: <20260723121816.17356-1-jianyungao89@gmail.com>
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

