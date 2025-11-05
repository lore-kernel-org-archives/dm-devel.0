Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02242DF13E
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762332518; cv=pass; b=q+wokZDtb/NCp63VCW6khyF0doBM5561cGB72tdUYPi+sLrS+AikAaisyfuEguhQ/TP+pt9fjey2SL6nYCs0k7AiwDZkE4sZjLZINcjy07PCKiNFNbciw05XEv5wm8BTBlDcrdepTu1KdJR9AtmyoeGtpG3PIrzlEycZy6Pfcpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762332518; c=relaxed/simple;
	bh=Dy5mN+mUFblKRdym21OGi3qMkGEXzXCYj1i7hdWWqEI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6WaS72DWX6Lglv4vKKpw0ywgNdBRBUV/FoCGS0VX3aroPhoBkEsHfE4FBEBfWm2lvDNK4fqk6JFayC11p79lfH3GX9ls+xv0PVtkIufrMsux7UrPf159lEbCt06zlsVqZkJ0XzDXf6dHNa/5owKAZsXrCSr7CRb+HgOOyjLGN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=VtFxd8an; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="VtFxd8an"
ARC-Seal: i=1; a=rsa-sha256; t=1762332473; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FEm1V0hQecp0D+8qxfrY41QkZS5DIncrP13A/RVZcsalMyNZIg26EeO6gIaLX5iusNMUl6r1TKj7KJo821mXmV6XWRRnSLWh9U+ToanfIkgbNHTY/gTMkyyATdSkJIgYC3UFZdInk2+thhp9u1E4cJpvjPeTMEky8I6iCUcZKmg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762332473; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=PspWpmNa95LwydSNmRMQC/seSofntuwNeQ9ulpO4Bz4=; 
	b=QopEW/ZgTC3AfdHo0KLWQzeT2RLMUd/0GEvnJf3igu9QcfXFkmT9fiIycGA84lf8l5yr7T28V+G8refXtvdHGGt9SH18RQdQUwscEFt/tny1w85Yalo5npJi6QiOGUPqYIo97QjyP+3G6TMmhFt0Ie171PJhAXw4pkFmXZdJews=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762332473;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=PspWpmNa95LwydSNmRMQC/seSofntuwNeQ9ulpO4Bz4=;
	b=VtFxd8anhrmDqRA/YH3gAIEYunHRvnVptMzSUCucLOL1wSki6rdcT1l1n5SksBgE
	tEOfOyVxK+I/CHsoNn8iZGi3JXqwAuFzU9hdSjMbj4VPSIEBk3gnck/2rZwTFhSZay6
	4L4kaNTR6D4xzYhCXqXc7jwYE+yQgMOebHDDrNnw=
Received: by mx.zohomail.com with SMTPS id 1762332472045113.64560980394197;
	Wed, 5 Nov 2025 00:47:52 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm-pcache: avoid leaking invalid metadata in pcache_meta_find_latest()
Date: Wed,  5 Nov 2025 16:46:54 +0800
Message-ID: <20251105084733.3598704-4-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105084733.3598704-1-me@linux.beauty>
References: <20251105084733.3598704-1-me@linux.beauty>
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

