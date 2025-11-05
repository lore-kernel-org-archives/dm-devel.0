Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FB2ED161
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762332506; cv=pass; b=rUMI4hO+6jDOmMjiilErw18JMPIbz6QF7xTzAzWnZ14VhHlSYPDtU15aEN+684dLlxLd0dpeyYSaitZqmPWGweRyTW+LMZUO8jYyZ6HOlxQmitm1T+H8UWygvTVAQS6Rhy2XntfnGvGkG99oHxcbYdE3QU5vF8JnQm42V7pSsq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762332506; c=relaxed/simple;
	bh=Pm4gfPGpEvl7urYYvAAc//M9O+0YLVRYbm6O0V4Wi5E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMKxoNtALatPYVgxFbDb80i+k569EWnCXba37pfh2h36b7B1AhrWAOmosjD9aswDgpDu7t/p5qjasLE3+aAUUebdR5Jx0OuXhtjHH089slUrOhObqSskF23XY61XkFyyfXP01/EEFqvkNAEbc8jhM0u2uWo+D8H7VirHxnqb71k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=YOVJZ3dw; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="YOVJZ3dw"
ARC-Seal: i=1; a=rsa-sha256; t=1762332471; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GB/bfm/hhQEdLL32vdewOf2VFPFDHj8Q35Ir9rAtSa1vFPX+6sW8d7QjXD8I4OTCRA26VXzkffiL3A/6NSoMxy8MUW9t9CPYR6JUyw+70TRFUkHV7sPxIcQb7IUibXk+5xsVpJjFO+3BTkzdxnfUmiTUP7/jZjQrSzHiotdLAKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762332471; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=LWxPD1jqIGf0eGjGt5kSF5OaU2M0+DsfoZfQTI0FPb0=; 
	b=Vtk2qXzOYFR4KtQm2y8RInkcEwlSuDOU4rXuMG+cxrE1n+aGWbzs/FOl1kFx0C4R/0pH+e6xVoa3LZ3yGzkFgYNfbesECq98P1jEMegnOGIlRqlknZA0n9RieSA/ODESbL/PVIOyIFIbrglX83YvZkfou3umgN1jQIyXm8dkuNg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762332471;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=LWxPD1jqIGf0eGjGt5kSF5OaU2M0+DsfoZfQTI0FPb0=;
	b=YOVJZ3dw/wWxX207nFOt/1I8vi/e55aKjBu+NCHKIR6sg42TsI6MgU/whjrAzAE3
	3N9Ko6vxtmJYNHw4UTcrEv50N6Z3hG7VPxrfztPFGeQdmwitt3dI4bioAys4wbmPXUq
	IECYEwjkWRYbbp0AyYVQoDpVmCpK6tOrAAYjfBNk=
Received: by mx.zohomail.com with SMTPS id 1762332468517747.7914752177128;
	Wed, 5 Nov 2025 00:47:48 -0800 (PST)
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
Subject: [PATCH 2/3] dm-pcache: reuse meta_addr in pcache_meta_find_latest
Date: Wed,  5 Nov 2025 16:46:53 +0800
Message-ID: <20251105084733.3598704-3-me@linux.beauty>
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

