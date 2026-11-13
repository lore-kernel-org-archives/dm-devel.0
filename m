Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574587;
	b=Zo3j9vvN6e7LII6qPOE79zIGDZrBYA1UysTIttCeIbZVN7A+xdyhHV6gvG+32pVqkOZ6
	 VNfzt3/nFqNeuEVARChpQ7G9R70CBhv0v9wemekgjfwHCBcaCeVMnVWc9/5Uio8TnlaT/
	 yuF1cNMUO19l6OG4gjZQ3CLWacAZMnliiOniqUeE6pK8KAoYps6VJwXHLgvfrAxutGdeB
	 U19bw6ne19Oqw2uuGMQW3yczHCm1DYYJnisb1ztOCCIwcW1nVp08WT0px8Cn/31sCNhPO
	 9/htN6gaJXXriO3Ui1yb6eLrE86TLDwgqByhtdHiw7QB8HMioOefziex9cBGA8QbERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574587;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=XPgarAJyDwVqVWxphDSaVPHu5WrcJ5EuEq8vDII79Jk=;
	b=EZXaKEVVtq5RVOYbd2az2jdsYrdVnu3OfkMkYhkeiqYDxvnmEU3F3uCSRpaAhPuE16ga
	 fNflQucIB09pXKtBFREj8SyckPj/XjhwaULkDsADmJoAF7hbBfxUaR4UAe4JCaX9tIo0M
	 ZprngRt3QJqupraGiKBXdGAFkJykYFHtNTRtzJuNPpqQHboAT7PPslKMVZ5mfhQrxegEP
	 9R3Z0Dj1bADsauSlCCyQW67mFW4tNashOanGBe7mdQ6xzM1eDMLmpA5Bn62d+VjyMl1FC
	 C3l+qQqagm5gYidrnSzTn0PkJKzayBhpUlwr99mjYS/0/JwCoVpvECTYHs161KJ7x9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xnSP76uY;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FA0606A32E
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75FA0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xnSP76uY
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a59ffacb51so1693115e9.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574585; x=1795179385; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPgarAJyDwVqVWxphDSaVPHu5WrcJ5EuEq8vDII79Jk=;
        b=xnSP76uYo2B4YrvBLVrcGUncX9KYa0rMWy7axcJy3PkIKQMtd4B1nT+wqR1OoJxH/9
         Yq6OfvMKDwecu2JqMU2H3ee5DjJBXQ1/qwf/Fp6r6BfzdGZ0KykjmU2I09eEBl0sS+Og
         RWMfQewHmZMW+v2CWxjzFQ2PE/IgSP+Ie6OF2It1UyiJ1YlwH5/S4dSESFkbbAps0fNz
         BC4tPvO/c8Zud+gy/d5sHiNKMJW8E1/M8wzECaLFblzp2vnhYcStrLNF+Lg8RqAxLfSZ
         j9L17zEWHNERx+VM1DJdlh7d7sc4VT+bLIZWjbmBVuPx/jikO5QH43LTb6A/XsjvdRFF
         LPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574585; x=1795179385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPgarAJyDwVqVWxphDSaVPHu5WrcJ5EuEq8vDII79Jk=;
        b=2r2+QSJBEAorF7H9tSfa/G9DNBbecgFmwkjEFmUetL+hiZsnw/ERUCn3a+X14U3xGj
         eGA9M4HLf4Qo9f+XC3zhq/6/hj7W5UuzHTZBNbzov88XGh9HsA4wiHS2IX47If320daN
         Mw3SPBINb2jbKWbWdRE8FlEcP8P21kjwgnrl8jX7Wmxj8ZWAhmhSdeJM3sUVPgX3CWPw
         oYnkwV2PzqMR1CBn2mRnHXRVSYUt9cJ3VgzTrtAzR0TuJ8j9KcpvNrUgxS0edH05w6Zh
         8H1N/wLaplLC3XCglZG9RIeUm08IZCcq2T3l35pwkt47vMAffbRAVwfec3XgnDPPMXE4
         xA4A==
X-Forwarded-Encrypted: i=1; AL+hErGdoSH792zFEkkdGVlepdv4USzkYB+yUUwQpgwWLdbzYDfUPxc4QbEW4jnDLxq0a7wEZ7FcxZSTWw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8UW8yCdfH5kmOSj2DiiVsBdXvOa0xwGgO7i9mpCTG4R2OrwCnB
	a3dI0W2XzGwCjNma5D71unYwHdFol1mKcThJYaHyEcWbLT06hQLbMI4=
X-Gm-Gg: AYBFou29QkUBYVyS9vmp5CMY+iC098zyQpDqC95/EOOdNHDKrnuX+BdZwJozDqSmd6M
	PPoQZVL+RRw5gCGqhjjxb/TL+5PNpeEJS3apEb6ztpwqCEDt1I4+3Fy43aLoQopoo15wXP4FOV7
	8LFMfJcSUKDWCxED71IWRMnFktBz8rvBy8b73EDXNdIrmpDXRsuYvW2ZdLBMixcEi1kQnr2eGYk
	DaVg0MSV2FTfSFFBs1VbEWcYQBZyondjX6v1OgJNZqSif6wsIGC2bsX6Th7guy7qqk841OIuoln
	g55h3WXkLYg4ddhWqRX/DddCWTBYprWNXuMhgMkeKw5MeosDrwj3CadzGIPjaiVew0MI7rvCTVy
	/K7woOUHYrXMW+icVx6MVL1J+UrqmFbI1dDQ3bDVdC7vIzJ3Xy10MphTB9JY1OcoFfX8L5VaIE7
	itCqNcPMuW/W6tPFQaEhlLJDJgojPri52x5+y0+A7kKhkWaUt+Z5zZUfxiiVn4FlkbdMFkhVUbk
	NoLre0ddIlxaWsj0wRaaaB8Zi79J6Po0QCeEM2nCnVOt2L5HyGPiuGFuFxdfSlcCef2eFl890xH
	mOw52yjF3QR8T1QCbiDlq4ObClfGevW90FyewfNE/S6QNaZ1nLLh/V75GJpH5VLcnQ==
X-Received: by 2002:a05:600c:a209:b0:4a2:417:7db5 with SMTP id 5b1f17b1804b1-4bb55a55f27mr34282935e9.2.1794574584724;
        Fri, 13 Nov 2026 04:56:24 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae5299sm66936745e9.11.2026.11.13.04.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:20 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 07/13] multipath-tools: hwtable: update template instructions
Date: Fri, 13 Nov 2026 13:55:39 +0100
Message-ID: <20261113125549.504780-8-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Attributes with default values must be "omitted".

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a0befb0a..aab7bbd2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -33,7 +33,7 @@
 	 * Copy this TEMPLATE to add new hardware.
 	 *
 	 * Keep only mandatory(.vendor and .product) and modified attributes.
-	 * Attributes with default values must be removed.
+	 * Attributes with default values must be omitted.
 	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex.
 	 *
 	 * COMPANY_NAME
-- 
2.56.1

