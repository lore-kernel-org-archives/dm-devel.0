Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34560320A06
	for <dm-devel@lists.linux.dev>; Thu, 30 Oct 2025 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827775; cv=pass; b=uO8EqXgdqBxeeJOpiVawx0dWCTfhvuJzt071AlivgkTrnF+rqtXwCcIwNR8xyqtrrD0jwiVxmSny9QiNFuCGlvt/xetc43gY4PP8ZUQexhTA5CocZdqB/tWKldOPTXMMJOQX/BQXNXdESslYc4ublMYLNhFqcIcg5bJZ+kRq2Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827775; c=relaxed/simple;
	bh=Dy5mN+mUFblKRdym21OGi3qMkGEXzXCYj1i7hdWWqEI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3lv0ZY/1MNvKGamS9HRHZH8/xzl/jFTfQxK/S9o/upKR0XiJc3b2enxXbPe1rRH11p2Dw3LADq2CFx1S4yOvraZtP1RBEfPm4Azz0jfSmLCYzo8kyo6KiHALtdRcph6U48/kWqguXFihdydADHUNJTnRZ9fbeI3agtYw5aFjQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=C3/tzCxp; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="C3/tzCxp"
ARC-Seal: i=1; a=rsa-sha256; t=1761827623; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TbSb1YlBAqvuJNzw2m0h1L6cC0avHo92zOyyebPOKmUkkDslt7WLgkboeADd8WoHIuonxgnwlSI3FnXnzXtUv/dN1HKKeRh4ToUIn4ZlARCzcYOX7cXBXqnJmePc+bG6kNWjh9M6tYEKtDOoMvQOJwZY42fvmQMGOUXG8I7AHxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761827623; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=PspWpmNa95LwydSNmRMQC/seSofntuwNeQ9ulpO4Bz4=; 
	b=A93ySmNYN8R0g+nKDK3ZuGNqct6/BwSBVECUA5EhaaD4/dpn8vEZq2R2xF4kgJB+wi7TIjVcswzSCqlUckkMitNvbWZniFsH167BoFPOnDPE/tXgXQcnqVV/8JlmJMT1EVUkLJZkyfqP+fziyDbVgGsE8r31D2ad2cRdvnSWcmo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761827623;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=PspWpmNa95LwydSNmRMQC/seSofntuwNeQ9ulpO4Bz4=;
	b=C3/tzCxpyTv97TuZ2tjFYYjwtvSw5Ih4f21z5LYyrJ2NVTlH4OKV8OZzBcet+PVo
	J4ZRhblVLeMMIrNQ4MtvEjtYFbJIvhqA5iXyb+xZjr7Jj4e7x3xDnZua3CGIBMHt9SR
	NkLSPojxBDhVrtB1phA0jZxirlEnjfBD1ldpn2+0=
Received: by mx.zohomail.com with SMTPS id 1761827620954398.4862490820956;
	Thu, 30 Oct 2025 05:33:40 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 3/3] dm-pcache: avoid leaking invalid metadata in pcache_meta_find_latest()
Date: Thu, 30 Oct 2025 20:33:21 +0800
Message-ID: <20251030123323.967081-4-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251030123323.967081-1-me@linux.beauty>
References: <20251030123323.967081-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

Before this change pcache_meta_find_latest() was copying each
slot directly into meta_ret while scanning. If no valid slot
was found and the function returned NULL, meta_ret still held
whatever was last copied (possibly CRC-bad). Later users
(e.g. cache_segs_init) could mistakenly trust that data.

Allocate a temporary buffer instead and only populate meta_ret after a
valid/latest header is found. If no valid header exists we return NULL
without touching meta_ret.

Also add __free(kvfree) so the temporary buffer is always freed, and
include the needed headers.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/pcache_internal.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
index b7a3319d2bd3e..ac28f9dd2986f 100644
--- a/drivers/md/dm-pcache/pcache_internal.h
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -4,6 +4,8 @@
 
 #include <linux/delay.h>
 #include <linux/crc32c.h>
+#include <linux/slab.h>
+#include <linux/cleanup.h>
 
 #define pcache_err(fmt, ...)							\
 	pr_err("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
@@ -79,14 +81,17 @@ static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_head
 					u32 meta_size, u32 meta_max_size,
 					void *meta_ret)
 {
-	struct pcache_meta_header *meta, *latest = NULL;
+	struct pcache_meta_header *latest = NULL;
+	struct pcache_meta_header *meta __free(kvfree);
 	u32 i, seq_latest = 0;
-	void *meta_addr;
 
-	meta = meta_ret;
+	meta = kvzalloc(meta_size, GFP_KERNEL);
+	if (!meta)
+		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
-		meta_addr = (void *)header + (i * meta_max_size);
+		void *meta_addr = (void *)header + (i * meta_max_size);
+
 		if (copy_mc_to_kernel(meta, meta_addr, meta_size)) {
 			pcache_err("hardware memory error when copy meta");
 			return ERR_PTR(-EIO);
-- 
2.51.0

