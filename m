Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891463E5A34
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 08:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277611; cv=none; b=AxIEg7mcyHz2rg9+vz0Vjh/SHNkiR4T0ooY2h/AHAdwSmHtBSA7T5znDDCM2GZaKn2MlWVbxK8O9cO+2sw+U6Gsg1NkEs3z0vmzc23hRY6Kgm9MEs4lovf1MBcAAGqM0G7nlCwpTF+xsyDKgpBw/2t9E2GrfTODNCE7EywvZ5J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277611; c=relaxed/simple;
	bh=OOvCDIL8Iuc/C198tt6pY1A+niCBqQsk3dFca1OLUkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t89LrPjJt30K+Au1Tadg61WXLcYojG7QXICufQdCZ6klhI4o3qXl9tgudVvAaIJhnn81ia1LDMS2pzafY5aHyv6lKf7zqVMMWwAg2IlvHUoknkUzsCyXV4pil5sWAz9iSIM+2SnL0iGHEiqd6m42cHcbv55ilpaVTHER1lmvspc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oMBloozw; arc=none smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oMBloozw"
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2cf02ecb572so22530115ad.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 01:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784277610; x=1784882410; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VDRmiQHSYLDQK92BzglLD+34hwddU0qX2gfWudxWF18=;
        b=oMBloozwA0oxGFHrdGK4BB7hm/IB1zmP2QuCK8bYn7Q/LQ4/4jvdIyTFZ84Z/taExE
         TvcwWHLP8G3714+78AtgzYdOgmQdDyPcN/21CkRbQbecS+pqO0xqRSKU/dHdq7HTcdcq
         +4lu8ZxpYClFifi/mGgiPdRkSJev+yL3ykrSEJExZGKVbQhGzQtWT+NlcAkuIQnH3KdX
         3oJ4KgbVboDFqvBpweCSN4TJXwsBWQz9GUGOfmXPKcjDqWzHqyXJjlW9CgvI8joMEjKN
         5NOwvXJO8RNZnOJtujFzZ5/jSM0kMk11IzYhoFao/N8C4UjpSAF3UVEVMzC0GMCT9oub
         lM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277610; x=1784882410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VDRmiQHSYLDQK92BzglLD+34hwddU0qX2gfWudxWF18=;
        b=URf/QOae0EXRk8jqZU2j+/YSDo6WhBqhiGNOceVmU2gGQ9Dkm0zbSvZfF9c+WQe2KW
         WX1lRB974BSss9C0LYZv8/sv3iMi1vrI+d2KBk9lJUHvV71n10Px9GjgjzBv0DbZbK7f
         wOETS6viPUiPN1rbr3I/JMAsCoxQ7yzMaGq0N8jshRXgMUe6Rr8pVKgTZT3pIQP3C73H
         zRe/CFxdzcnwVeTc1iX/QYnV7X1ZUfOkqhuLrFuZDkvATOXY14AFxqyyatXncP/xUtr5
         ChjhU5DMAIfYldDfuvf82Sdar+FkI6m4PNGTOhn69rLdhTlHuyvoaZpx9r+oxjTWKZ7X
         zNDg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0/mxSHPwyE0rAaS0EuV8zXQPc5iFdTd4vdxjupnsUY8etLDgCaqMTsaMBRFZGieXliGrMI7qtDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzaIwJVSfQ7qc5Y8qRMQUXYltPj5D9kigt4dv44pcL3HFJ/2amT
	sCJ6BxbfTnlTv/kxMqLPYovrTcJZJEZnFbdbQGO+vvUNF1j6unfcTd6n
X-Gm-Gg: AfdE7cnpgkRi+JMtO+M3ftIPdC7oIK8bVuEJD6oGH+scLklysiIiekTZhdLEXfDQXsH
	ASLTAu7bVRjLmwMm2XwIKeqj508Uhpzngyb3zbz/5X1eBTrpL5eA9tiQjoQkL16qyokM9A1KNq0
	Oc17WZwlU/eoULWLVyYlwMezW+yHF3rBPWIfx0dW+Ibd5Eru1Gut9AST/+sQmEuHa7laTB4P6Z6
	u704W4grYCmmJs+H9C27h6GgXCSMXdaUgMGgNlaHbdZ67RKYrerHVwksqhpLL8ocom/ZbeHho0D
	6GtLj+MZUjaSJkPCzJwp3KvV10Zd/RVHq7ychyQwI5NFBu442oLBLAzticWlIXI7p+s5dgHNA9L
	iesW4aei+y36lJNvx5nrXaVRuTttWVh/ZEPIIrpzNEk4WpbLdHP3xZfblN63LkIFdjx+vSylcHq
	L7c4JDtG4Lq5E7jAQdGcYNtOLnRu4=
X-Received: by 2002:a17:903:8c8:b0:2cc:5f48:5764 with SMTP id d9443c01a7336-2cf349ebc1dmr16982495ad.44.1784277609770;
        Fri, 17 Jul 2026 01:40:09 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344be458sm6842445ad.25.2026.07.17.01.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:40:09 -0700 (PDT)
From: jianyungao89@gmail.com
To: dongsheng.yang@linux.dev,
	cengku@gmail.com
Cc: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: [PATCH 3/3] dm-pcache: remove unused 'allocated' variable in cache_data_alloc()
Date: Fri, 17 Jul 2026 16:38:56 +0800
Message-Id: <20260717083856.12820-4-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717083856.12820-1-jianyungao89@gmail.com>
References: <20260717083856.12820-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

The 'allocated' variable is never non-zero when its value is consumed.
'to_alloc' was always equal to key->len, so replace them with key->len
directly.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache_req.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
index cc5747d472e9..b2cb3c7615d4 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -39,13 +39,11 @@ static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key
 	struct pcache_cache_pos *head_pos;
 	struct pcache_cache_segment *cache_seg;
 	u32 seg_remain;
-	u32 allocated = 0, to_alloc;
 	int ret = 0;
 
 	preempt_disable();
 	data_head = get_data_head(cache);
 again:
-	to_alloc = key->len - allocated;
 	if (!data_head->head_pos.cache_seg) {
 		seg_remain = 0;
 	} else {
@@ -57,10 +55,9 @@ static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key
 		seg_remain = cache_seg_remain(head_pos);
 	}
 
-	if (seg_remain > to_alloc) {
+	if (seg_remain > key->len) {
 		/* If remaining space in segment is sufficient for the cache key, allocate it. */
-		cache_pos_advance(head_pos, to_alloc);
-		allocated += to_alloc;
+		cache_pos_advance(head_pos, key->len);
 		cache_seg_get(cache_seg);
 	} else if (seg_remain) {
 		/* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
-- 
2.34.1

