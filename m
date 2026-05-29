Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066993A3E90
	for <dm-devel@lists.linux.dev>; Fri, 29 May 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780070418; cv=none; b=a7wuOiNsTvZv2dJWIr44RRhZ7jI8acYGarFWABwYfXXTVmQFp0r0rbkSWGA0Y+U+LreQhb3tVKhkcnD+iOqKygd6xnfStm+XN5tNbWCqU3OnEXToXkCVsHdZQIhgdRPQVd3Q6o6dQY+W0k8F+bJRDsKzxic+rlygw6cnbLMyPwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780070418; c=relaxed/simple;
	bh=k4lx5eyaIkFZb9LSl33QVXj3R4oz3we3nc7csf+YodI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GSQlf0jLEZcLTT9VnzHo5yB1HGsOBP2MUGolJ7legJbj9zsJsLHwvsVN2Wc3myca3NBBG5SJUnev/B6I66ZAsW7rD5ENLuXpWPvgYH0e5iAIwx+vkCp2gX5SbwGDXkaFZ2NDDXxI88JBTtsgjjCW0OVv1qty1VfXvocSGMcEJ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rxjxR9NX; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxjxR9NX"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-83945063f70so6771315b3a.0
        for <dm-devel@lists.linux.dev>; Fri, 29 May 2026 09:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780070415; x=1780675215; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hKu7L3y2TqCk1Y4XvXgVCljpe0pimisDl4YLc2NUkAA=;
        b=rxjxR9NXkgbz8dIGjbxOLjho5oDr4TNhlJQmH1lEwfOl83rwP4tCXYwy31owFRGpQt
         BaVMhWdybnVmze00lMHsntSGcQ8BlL0GAzu4fvUqWNz9hE2cArk/YkGadh/jIubVY9DA
         C671JFC7wy8foiUYOfR39wXOhMawBmvIRbxXitZnh5POW/aOGUT/w/DaBUZuNjLlQa5S
         WZ7tZrm17S2nzzHnSLa2Ow2sJn71hNpO1BYD2jTqmh4WalCi2XTkxI4M7OtBcgIl2X50
         U3qK/sd4rxLE39MYAThmBb4yx0RI3+s2oiYohD7OtAC2OIqlOL9z6mjuLtbSAq8B6lEp
         e2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780070415; x=1780675215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKu7L3y2TqCk1Y4XvXgVCljpe0pimisDl4YLc2NUkAA=;
        b=KbIHDwS4jjS4f1WJnor5KC8e70zvoAitVk1kR+cf35zKNFOOVtD0sE4AQ2/rKSNK9T
         EIDN25rzkDIT7HtJRPdHkFp1CzeabuhAy9W/ye6qvIHTfi50cHF6d/urQG8YNTLVn2Dv
         rem5WTuqiKo7+qpLl+dYP0lxPwG/5SH7cOUe99qbUUmqzUX/9Kd5kbD/2dpXXOAXT00h
         mqhuRSX0L+MrmelDy2T4wLI9Tj8+5a5jsMqvoTlMLy4cvXF8IpgQeHR1S83Gq0n3Fk3X
         zAWx2/OquCez5VtkQ/CdQ0ApVz8+/Z3fT3TW8bYOhuGoU+eW+aLf7lVWyabGvcPMIKKu
         +rHw==
X-Forwarded-Encrypted: i=1; AFNElJ9KVKDCsRMICOdoP1bCCXT6BTCoVa8WGvsWkrDf23uYjsKH76jnFtg1jugy1uLTsT9kpNBFs31MjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywc/c2+W3+R0w6rWcdd8BKCi+BuJlXzis/Czice1GFzUblUC98j
	ZPWyFISPmXi9lMMANgxahhmlgRSvd5pq5mfkEnp5kTSQ5qJWejJSjZDW
X-Gm-Gg: Acq92OGMC9zw3QbKFbOc5gu2tg7fxjutKB/UyWXNMny3nCN/WZqrqF0yspJ9fGZG8ba
	JpD/wzWSZFNIHRbivY3MWOI/F1VP6MjurDwhJ/D/3OASjgwQmdbc7i7iIEracDkHmpPVeeIyt+y
	USiwzXo+GjJmuwp0JFavnQ1ayKpQ+dg4i1knDNkTUMtdS2PT13jfgRjYsTAG9jLPCiy2R4G5h6h
	OpoMWf8VnAkPb9DLL4NSKL+8C7KqMBGHRVXcPyu/t1i+SEjoD0vRna1rhzyIFVYKT4/ScLXeN16
	18LpaFjunnCSv2aVDOnJz7bhf9VQLDmgaE+bQuSWztbrxA5BVapxN1BerZJc3QZGV6P8ekthMUI
	9xmWg1Rt81vS1e5GAXYph6KwLaBBnUjSISo6yx/lznX9miRerWqlfEu8UgBPoyhMFBHBNUwrBxp
	130LQF8wyluDjKQCto
X-Received: by 2002:a05:6a00:a218:b0:82f:39df:dd54 with SMTP id d2e1a72fcca58-8421095d2d9mr3340613b3a.8.1780070415075;
        Fri, 29 May 2026 09:00:15 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214ce9cebsm2220088b3a.52.2026.05.29.09.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:00:14 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] dm cache policy smq: check allocation under invalidate lock
Date: Fri, 29 May 2026 23:57:45 +0800
Message-ID: <20260529155745.1292113-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 2d1f7b65f5de ("dm cache policy smq: fix missing locks in
invalidating cache blocks") added mq->lock around the destructive part of
smq_invalidate_mapping(), but left the e->allocated check outside the
critical section.

That leaves a check-then-act race. Two concurrent invalidators can both
observe e->allocated as true before either of them takes mq->lock. The
first invalidator that acquires the lock removes the entry from the
queues and hash table and then calls free_entry(), which clears
e->allocated and puts the entry back on the free list. The second
invalidator can then acquire mq->lock and continue with the stale result
of the unlocked check.

This can corrupt the SMQ queues or hash table by deleting an entry that
is no longer on those structures. It can also hit the allocation check in
free_entry() when the same entry is freed again.

Move the allocation check under mq->lock so the predicate and the
destructive operations are serialized by the same lock.

Fixes: 2d1f7b65f5de ("dm cache policy smq: fix missing locks in invalidating cache blocks")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/md/dm-cache-policy-smq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index dd77a93fd68d..1ae304c2f573 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1590,18 +1590,22 @@ static int smq_invalidate_mapping(struct dm_cache_policy *p, dm_cblock_t cblock)
 	struct smq_policy *mq = to_smq_policy(p);
 	struct entry *e = get_entry(&mq->cache_alloc, from_cblock(cblock));
 	unsigned long flags;
-
-	if (!e->allocated)
-		return -ENODATA;
+	int r = 0;
 
 	spin_lock_irqsave(&mq->lock, flags);
+	if (!e->allocated) {
+		r = -ENODATA;
+		goto out;
+	}
 	// FIXME: what if this block has pending background work?
 	del_queue(mq, e);
 	h_remove(&mq->table, e);
 	free_entry(&mq->cache_alloc, e);
+
+out:
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	return 0;
+	return r;
 }
 
 static uint32_t smq_get_hint(struct dm_cache_policy *p, dm_cblock_t cblock)
-- 
2.43.0

