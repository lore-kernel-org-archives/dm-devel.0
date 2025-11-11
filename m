Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080953587A9
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863279; cv=pass; b=cdzW2yRm2zUeZqhFAuVOvDJq59m+NByCiBRGrynQqn5ktYVOVRri9rvd5t+3q2BCITYoW6gXOF3UNUyLbbxx8KEm5fUFPzsy5dLirf5ouQkTEdo7wDpw9o3KY8HMJdr0NDoGCt35dnqvTlQ/xd4aSr6NGMFJbTPVBsTBmOxh1Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863279; c=relaxed/simple;
	bh=HO/xgZwNfw3SHaM5XQjXQaEpPq4xSdasLKY87kqLdRY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LL1xbfFp/FDNaf2uaKW+kwHXDWiD9vOATjAQLr3qhXG34n1v5IGqqD3j19uDWUD3RReOc7s1FxLimTWbtHKBCwCZHDRD7FObd2j/AQzJzSPWtQYK0Ldo4L32uCpxKlYcKk261rAc/lIIHTA818PaHUpCzxyzipIaKQKVgx+m1Hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Y29i8Sp/; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Y29i8Sp/"
ARC-Seal: i=1; a=rsa-sha256; t=1762863232; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VxDJXeAklUcPstyg1cbbbem34q1qZNgFbFwd90VGDEEX5NO8ooZVEYCSWm24t5rW7tfZq6jkF0XLa2cW3bMLTEcTM7Nbt6OZFIuoF8MkRcgh+OyRRUS9ZQUdh3UZUzlB7/o3vjk8G9xz41Ro9X9xCp1NQFhR2MsycmtFK1ZpwbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762863232; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=9Kk+Bv9tIcvBVIBGem7wGRwTENm4Q38PWqcUNwLSQXk=; 
	b=JMj/+ILO+0pj5SRmBkVeFtYTdum4ogarozUeW3jhAIR0o1djzcRFT7L5iBXMV9HAtQYnWqoImSApmuxWB/ZNnhirin9Nj8sSZang5j6OcvgDxbxqk1riyAsCVYZpdx8L8tWC12oQxEqKf/Ma9rsfAuAhUHiqtBMaQCTSM7Pl/8o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762863232;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=9Kk+Bv9tIcvBVIBGem7wGRwTENm4Q38PWqcUNwLSQXk=;
	b=Y29i8Sp/THToixrSBbZz3gc38wSyJSWK/cLpufYh09zKPYyKaU/XjmjRmRdLjqBm
	TlZRDa93ejtivnqLN5RenyUn7vgCcuc+9fVVVlKOb/9pZbvdX37j9b0wP/8MuxVV74p
	19rGiSCTY5Nf8x8op4VmiX3dLTjlc3nKdvylPQ9c=
Received: by mx.zohomail.com with SMTPS id 176286323041672.15557441965711;
	Tue, 11 Nov 2025 04:13:50 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH v2 3/3] dm-pcache: zero cache_info before default init
Date: Tue, 11 Nov 2025 20:13:36 +0800
Message-ID: <20251111121337.1063443-4-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111121337.1063443-1-me@linux.beauty>
References: <20251111121337.1063443-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

pcache_meta_find_latest() leaves whatever it last copied into the
caller’s buffer even when it returns NULL. For cache_info_init(),
that meant cache->cache_info could still contain CRC-bad garbage when
no valid metadata exists, leading later initialization paths to read
bogus flags.

Explicitly memset cache->cache_info in cache_info_init_default()
so new-cache paths start from a clean slate. The default sequence
number assignment becomes redundant with this reset, so it drops out.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index d516d4904227..698697a7a73c 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -181,7 +181,7 @@ static void cache_info_init_default(struct pcache_cache *cache)
 {
 	struct pcache_cache_info *cache_info = &cache->cache_info;
 
-	cache_info->header.seq = 0;
+	memset(cache_info, 0, sizeof(*cache_info));
 	cache_info->n_segs = cache->cache_dev->seg_num;
 	cache_info_set_gc_percent(cache_info, PCACHE_CACHE_GC_PERCENT_DEFAULT);
 }
-- 
2.51.0

