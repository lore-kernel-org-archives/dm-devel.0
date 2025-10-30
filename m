Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2612631B13D
	for <dm-devel@lists.linux.dev>; Thu, 30 Oct 2025 12:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827758; cv=pass; b=RZdVmsiiRNaE3lBXANwL7ENtLTdeDrUIHWbVfS/KXpVAv0ddfQ8TM6WCtjXuxyXOafksXwOzPKertbYqcGR4kMrFuKpKtNPpeJzNVA8EQyyj1pjZmlkls/jX1jTbGt730rqdDNlqt+ifbcscRIkb0S9MxTwPK1FTATTeAGdLAms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827758; c=relaxed/simple;
	bh=Pm4gfPGpEvl7urYYvAAc//M9O+0YLVRYbm6O0V4Wi5E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdgJUFF1ZbpUwKsU0bm0wBIspLujYX3dduCUgizR0rVQVOAXIsRT34Z4VqdrYDrAhkRWhMX8Pn9MRJLpSHLy6Q89BDePZfp6Hl/Fr+IA/OSVnjxC+8LzN1PjIPb52J+tfv/crdaQXglCiBUq8G5syzuzCEXMZdhWGq+Yr+sKQgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=aC2x86qX; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="aC2x86qX"
ARC-Seal: i=1; a=rsa-sha256; t=1761827621; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WD6MzwZLw+f1i4E6IGchnSdOtk+am2Sii0xKDNsIARExAr3ZvCG3sDvpqZpfCXHqDMYHasEr0yjexWFCT3YIa7TczkU7WYz0Ko/vUR8KE94dS3BSFRz6iCS2Y0NqEsgsatfm9Z7hRaR1xdRVTa2QDSO5bEsnEmrNF8d9SQxaRtc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761827621; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=LWxPD1jqIGf0eGjGt5kSF5OaU2M0+DsfoZfQTI0FPb0=; 
	b=OqYNl8i4mQXWmzp8BsYYSXofV1VrEK9hRj7ss/Eht2nVfa6Jb4YIi9MowjxzAXl/Ecxcle5ZzYumLmgGGHesepPjrOag0QsR9y6dlYm6bRT5mqqZ+d/3kIwydrDt8dhI2j+etJHYBWC5qZBhRRrUACrvNrubVKwISg4jFIFQJNw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761827621;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=LWxPD1jqIGf0eGjGt5kSF5OaU2M0+DsfoZfQTI0FPb0=;
	b=aC2x86qXNi1GODrvOiiJ5+MPt731zhANJjxBf2b1FV6BxD2fIMvkBLgeWNS3Szsb
	sh77LwFbJpm8ePijkd+owC5a+Yef9Gtq1X/EdFvLHdogTqse45OaR6fxOUNhjqhvyhr
	O/ZeG32tT2pN4SRtf97VqcLki4hj5PG2LT7tqZnE=
Received: by mx.zohomail.com with SMTPS id 1761827618663161.67818038594123;
	Thu, 30 Oct 2025 05:33:38 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 2/3] dm-pcache: reuse meta_addr in pcache_meta_find_latest
Date: Thu, 30 Oct 2025 20:33:20 +0800
Message-ID: <20251030123323.967081-3-me@linux.beauty>
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

pcache_meta_find_latest() already computes the metadata address as
meta_addr. Reuse that instead of recomputing.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/pcache_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
index d427e534727ce..b7a3319d2bd3e 100644
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

