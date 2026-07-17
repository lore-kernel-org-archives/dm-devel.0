Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114D3E4C6B
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 08:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277598; cv=none; b=jITWkunDmrDKhq5kAmiy+dqwEpEc0SAmGtWsuGRV5HAmOlzUkaw3rJWa6Q2KmyUDkbLgX3Pv3M8qAcOtQOU1/mkJLJQy+PUKx6dMiszL8/AR0X2bZk9vTvHXhTJxt3zmK7+4wLqY5Ztl+Crhai2zfg3mfq0X2IcGs24iQY6CfRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277598; c=relaxed/simple;
	bh=H3GQDQLM3/sMzbexVRKe9kXmIYmX6pHOQJ0+Q9cfII8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UWG0pdTEuRuIiJQkdZRJCd0hNE9rI2gVRAZ96HdMxt44HL8GMFtIWaqUgY6eyH4eiZnaO8QrQvXWfMU/iQyQ7kHlSW7hqlO8LYwWrXZrVIDTlz1YU9dS0tFjpLsq7wFqC2JdNUr76wMxZ+1xIBBvGZ5NusZ5RKIIS03en39/I60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/BWwCGh; arc=none smtp.client-ip=74.125.227.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/BWwCGh"
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2cad83a0aaeso32686435ad.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 01:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784277596; x=1784882396; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os06Hz1EE+6kvFIzrlf+U5cWKP6xlbMTLi7tD84z9LI=;
        b=F/BWwCGhVArSRHwGbuP+mNPLyz2DxHCCVF4RTUNIwpYxZ4NMVXjTbCZwB67bbMO2zb
         rnycVk8J5QUU/Bh8uJb4rC3UrfVVMsjmpOW1A1J6LfDhBHmNf2ZFoM9ea6B9l2qiRUNV
         xnOIxaAPyzz2TkuVaJRn+Ng6rpDjdrBni77s8U4VKQ1qVY2xSAVtj5NGjqjDntE6aLuf
         7cOA/Mf1TVehe1BEcRBKBtc5Mzyxbdr60r4lSxWUGRFre7ER8715tairUoAhAJvm/WwK
         s/DhmwpJRvgq0I74Ua09tqnuHOq5ILhdbsswUMpMQXpcT36kdvtAw2G0xN6LzkVCpJLa
         IIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277596; x=1784882396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=os06Hz1EE+6kvFIzrlf+U5cWKP6xlbMTLi7tD84z9LI=;
        b=sTP9JEwd9HZbu4nF2quYT6SNwZ6SA2RSUt36t0cj0xgk1mv60EV1/GoG5vxHO43lH2
         9rkNwTcAejPpB+YhzYn9ZLdhdzV/D2LG/TEkBrxxLTccMDIAWMZdW1cnHmgFLsXC/9hD
         rDipB8iTM0CjiyjNIYEWo6HQMQjjiQ4lODb/KdPg5oqRSQ9+nuSGrDAbpiNK7DR1eyEm
         4rMtaTRkMQ3DzbjPJI83KoaAeFixsXi4tynMxRtC2J+teJwNdw+HbBnVlEYVNS7qFwF3
         hpCjKAEgRuMEJeJbjd8YWqYD2ovZK2hqB6xeWcj7tbhqOWPMSiSc1TcKNYFKU4oEYIRe
         WZrg==
X-Forwarded-Encrypted: i=1; AHgh+RqXT/aRft+/Tt1Nv1gqRn+UKCHyspe+SMrvBEbEVd+uXwDRe0M6YYDuVZGDEVzd3ubCggBtlaz9gA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNv85bYQ5XJoyGjfDEHbJMyk1Zn1sorhO3R0r17b+f7avn8+oE
	MAPK0H/WBl29EQJOqZluW2vhL+REnJjCePGW9Q8fGwS+KEDMtTr9LAlh5/5dXE/hWYXB+ix7ae0
	=
X-Gm-Gg: AfdE7cll9iBDJ26YoA+WR+3jzrWkheE+afpKEUTdS0TGKhXlz5ByjG/kbLgNqrskcyy
	IIWQYjyHrB2JTU2Lo3E+h93wiSMODq4xEgMTZoT0oSl+3WmV3Ooxa0XLgflnKTBB6CjWrWDYbzN
	ZqFbw3557nZHMv+i5vEvyyQAicxHjpGLQ36iqIqsL2L25xB7QOATkuJA9JfZ8nOVnGprUb9UFXb
	Lg0L+i4OK9uIYXuJTYVd+Qx7UNtleTRrAhJc0xYE1WlLPMQ+iN3cy8YL9Ep6H50r6QZ8bo4w+PG
	g8ewxBKABDNKeLYuK1qE9kSMC8FZLeu+EUQluZ3xVbHlkdWUgs8Ay+rT249Um9gA4tXWK5Fey2Q
	HzSiShdRkQ+IP20su7rnO5G2SfykewDzHN3Zovl7FMaNzwwb0xHG7A3z+jcPxYx2lFIf3BWvwZB
	iS5FKwqOCWoTpBVj98pGGspgeuK1I=
X-Received: by 2002:a17:903:41d0:b0:2ce:6d4a:5b8a with SMTP id d9443c01a7336-2cf34a4c2b5mr17058975ad.38.1784277595966;
        Fri, 17 Jul 2026 01:39:55 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344be458sm6842445ad.25.2026.07.17.01.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:39:55 -0700 (PDT)
From: jianyungao89@gmail.com
To: dongsheng.yang@linux.dev,
	cengku@gmail.com
Cc: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: [PATCH 1/3] dm-pcache: replace tabs with spaces in comments to fix ASCII diagram alignment
Date: Fri, 17 Jul 2026 16:38:54 +0800
Message-Id: <20260717083856.12820-2-jianyungao89@gmail.com>
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

Some editors interpret tabs as 4 spaces while others use 2, causing
ASCII art diagrams in comments to misalign and hurt readability.
Replace tabs with spaces to ensure consistent display across all editors.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache.h     |  4 ++--
 drivers/md/dm-pcache/cache_key.c |  2 +-
 drivers/md/dm-pcache/cache_req.c | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index 27613b56be54..b1f44f62e336 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -273,7 +273,7 @@ struct pcache_cache_subtree_walk_ctx {
 	struct list_head *submit_req_list;
 
 	/*
-	 *	  |--------|		key_tmp
+	 *        |--------|		key_tmp
 	 * |====|			key
 	 */
 	int (*before)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
@@ -281,7 +281,7 @@ struct pcache_cache_subtree_walk_ctx {
 
 	/*
 	 * |----------|			key_tmp
-	 *		|=====|		key
+	 *              |=====|		key
 	 */
 	int (*after)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
 			struct pcache_cache_subtree_walk_ctx *ctx);
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index e068e878231b..c83fcb303e88 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -265,7 +265,7 @@ int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx)
 
 		/*
 		 * If key_tmp starts after the end of key, stop traversing.
-		 *	  |--------|
+		 *        |--------|
 		 * |====|
 		 */
 		if (cache_key_lstart(key_tmp) >= cache_key_lend(key)) {
diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
index 7854a30e07b7..cc5747d472e9 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -317,7 +317,7 @@ static struct pcache_backing_dev_req *get_pre_alloc_req(struct pcache_cache_subt
  *
  * The scenario handled here:
  *
- *	  |--------|			  key_tmp (existing cached range)
+ *        |--------|			  key_tmp (existing cached range)
  * |====|					   key (requested range, preceding key_tmp)
  *
  * Since `key` is before `key_tmp`, it signifies that the requested data
@@ -352,7 +352,7 @@ static int read_before(struct pcache_cache_key *key, struct pcache_cache_key *ke
  * During cache_subtree_walk, this function manages a scenario where part of the
  * requested data range overlaps with an existing cache node (`key_tmp`).
  *
- *	 |----------------|  key_tmp (existing cached range)
+ *     |----------------|  key_tmp (existing cached range)
  * |===========|		   key (requested range, overlapping the tail of key_tmp)
  */
 static int read_overlap_tail(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
@@ -474,8 +474,8 @@ static int read_overlap_contain(struct pcache_cache_key *key, struct pcache_cach
 }
 
 /*
- *	 |-----------|		key_tmp (existing cached range)
- *	   |====|			key (requested range, fully within key_tmp)
+ * |-----------|		key_tmp (existing cached range)
+ *   |====|			key (requested range, fully within key_tmp)
  *
  * If `key_tmp` contains valid cached data, this function copies the relevant
  * portion to the request's bio. Otherwise, it sends a backing request to
@@ -524,8 +524,8 @@ static int read_overlap_contained(struct pcache_cache_key *key, struct pcache_ca
 }
 
 /*
- *	 |--------|		  key_tmp (existing cached range)
- *	   |==========|	  key (requested range, overlapping the head of key_tmp)
+ * |--------|		  key_tmp (existing cached range)
+ *   |==========|	  key (requested range, overlapping the head of key_tmp)
  */
 static int read_overlap_head(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
 		struct pcache_cache_subtree_walk_ctx *ctx)
-- 
2.34.1

