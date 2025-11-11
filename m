Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978C33587CF
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 12:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863264; cv=pass; b=oQ5Gb7Vtf7YhE3uqVWADx049i3QWj/I9YdNEMnJJAuTEOxnOAC9ZbuyVA2Y95lK9IGm3LdaQjBeoXfZ1lBVClUqnCalqjh73IBtXEmMOu0MZH6JV/indhZXieO9H4OG8Stytzrk4s9ErLSHaIIHSix29Sp7/aBhnC0aBwcPJWHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863264; c=relaxed/simple;
	bh=xYvHnt73+ArXoWf25mlB0olseCbE6Pe3s3so3DB4RP0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8KpC2gIXitrdBuqpDQtK/HHFW/mo2VMKu+FjgzTrYRCNaEY9l4yf+fxHexpFz9WMhxLNgyGwfomLKb5Mrg+ilsESDuyHzSfshc15Eya4VAUxOGj07t8RYbK3/LYJoAN+XIMf8iZkDa0TOZa3SGXYH3Fb0xkIRsOqFfE77LL7lQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=UA1MOXPN; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="UA1MOXPN"
ARC-Seal: i=1; a=rsa-sha256; t=1762863231; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lX1iu0UXwB/Hh3T5RvS3ducclCMeLGYssC1Zv8mAQNa0mBfbpLmLFamKv1tEMkkzOWjsLLcTrHqxytp5i3kEWBPS+PqXa4kGW1lhXqVd8QRWkHoXw1r0vfoFY1j8jvld8zw3cDBbGXs19I7Rc426c26fj+DB5TPHogd3+/Tepws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762863231; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=Qe8C8WW7PdlIqS1nea6IPWW3yId8LkgwE49m8YwS7i8=; 
	b=Tf1LJbxF3k+rBiF+GtoWZgv39vhtdcih/FzwpFqXlJC8eh6uNMTi1gFLiaasrx9YjI2G9FPWlV8W6xcz3NEoaF3wp3Gv+Ir81Png9bmwCMbqC/LKlNBZaTzooIGTeknHACdnKAVUdKJaZ2bl22EAV5fQUpnSvFxX25ckzn87uAU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762863231;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=Qe8C8WW7PdlIqS1nea6IPWW3yId8LkgwE49m8YwS7i8=;
	b=UA1MOXPNejWzEeBRSnkHix83U8pPE3VS5BVnXjzr5YpIQMoYe/Hj+bbxL5pF2E1F
	ed/5xcNofUB7WhCsYrlqoj6bADPC9VvWODn/Et4obf4wmacc2L5Ymrq7LNBieeUFurr
	G08j5BfgUkgRrpOeVLHPDn8DsoebYrhWIUvq3F4g=
Received: by mx.zohomail.com with SMTPS id 1762863228249716.4687552539734;
	Tue, 11 Nov 2025 04:13:48 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH v2 2/3] dm-pcache: reuse meta_addr in pcache_meta_find_latest
Date: Tue, 11 Nov 2025 20:13:35 +0800
Message-ID: <20251111121337.1063443-3-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111121337.1063443-1-me@linux.beauty>
References: <20251111121337.1063443-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

pcache_meta_find_latest() already computes the metadata address as
meta_addr. Reuse that instead of recomputing.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/pcache_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
index d427e534727c..b7a3319d2bd3 100644
--- a/drivers/md/dm-pcache/pcache_internal.h
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -99,7 +99,7 @@ static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_head
 		/* Update latest if a more recent sequence is found */
 		if (!latest || pcache_meta_seq_after(meta->seq, seq_latest)) {
 			seq_latest = meta->seq;
-			latest = (void *)header + (i * meta_max_size);
+			latest = meta_addr;
 		}
 	}
 
-- 
2.51.0

