Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B531280C
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 12:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764677553; cv=pass; b=M5ssS6cXvFWuk1l8SYtG2Jwppr7g6Q9NBM4pmF5AcXuQ8zS7s2YWEau0Fz6RqtsmXjB9r4H674S4hcbkZdFQIWiAX0eQxJvSOhoYbySeK8lD2wFbBMwGo2rmyl9KvBL1PGc1Du6unGD8yQuG1st1ModV1u4N+9YENmBkfbxFV2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764677553; c=relaxed/simple;
	bh=tcTO13kKW/JdRxqJLkFgCIopsa50aOCNy/R5ovgeuYw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltp9SzCX+N4Y2GTGjpfQMt6MNiwGfVDg33oOuZ6SI9JtV8Z9vT7o3vl+HUxwup9c6CBLvjNUhO8Owvk+krcNUiO7FKW26voPtXU9erx7TdPrcbJ4fVK2ylxOY9EoDKGvJJji0tin4O7ZyEU9ZMp63AQQldcG+n24INMadWSehi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=hQDVJoP3; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="hQDVJoP3"
ARC-Seal: i=1; a=rsa-sha256; t=1764677528; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=czjPwDvM0SWNOoWbfl0wY3VkWEh+4AZ1U1tDDEC6sQtr1lX8VQufJrvQ1FzxtXBlznGc7W8eo1R/hgC34jUggWGd6rulY9BHdJImq8/uyDQhXZ+FJBI3soETICrK7IVffFlSwI0HYDPcb/e7B9YmkuGEbODcMcdUn8FUHpPPfEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764677528; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=/THr4U3rxJNaFh3h9M6B25ZG2LY68Uc4k3xBNPI30Ts=; 
	b=ZBplEIfRE3cpDDJJLklTXOrDPu4vpOTZZhKWK2OqFQBVVnjRB5e+n5Uf1K1NbzcfMSDVRLrlrU5jm9yEHoOrL5VM8y9gqRig74Hwi1RD4SaUTAZu89QIygfuMCKS/gGnpGAqnZr4AqUPDT9x5F7hVV4y0U2L6F0dApwnFRXUg24=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764677528;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=/THr4U3rxJNaFh3h9M6B25ZG2LY68Uc4k3xBNPI30Ts=;
	b=hQDVJoP3/ChXPHlGuz8WwMxddzC9+YSwY44nuprBid35UBi7TwzLKixHQFT5u1uT
	3geZ/xCPeoopmGOs3Kpt3ZHw3kptkt1/RLHj/oJU3ZWA4HzHpu2HMIzqIiy9qHZLpHR
	gGtTRoCFF3UHBQ1pmSRpD5WqpVUfHix+qtpHC/w4=
Received: by mx.zohomail.com with SMTPS id 1764677526770286.1221850599361;
	Tue, 2 Dec 2025 04:12:06 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 2/2] dm pcache: fix segment info indexing
Date: Tue,  2 Dec 2025 20:11:58 +0800
Message-ID: <20251202121158.111092-3-me@linux.beauty>
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

Segment info indexing also used sizeof(struct) instead of the
4K metadata stride, so info_index could point between slots and
subsequent writes would advance incorrectly. Derive info_index
from the pointer returned by the segment meta search using
PCACHE_SEG_INFO_SIZE and advance to the next slot for future
updates.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/cache_segment.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index f0b58980806e..0b4bb08011ce 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -56,7 +56,11 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
 		ret = -EIO;
 		goto out;
 	}
-	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+
+	cache_seg->info_index =
+		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
+		PCACHE_SEG_INFO_SIZE;
+	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
 out:
 	mutex_unlock(&cache_seg->info_lock);
 
-- 
2.51.0

