Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D39D4D2EFC
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832425; cv=none; b=G9cvM04IAPjMRGpLQ+ODOy2kyg7RkqqS0vhzTE72ZmXESSXH9v1/b8YZ9Aituz+OLns7mSesYhDbQdOoaFioebpYZOCrmT+RW2IfxDIUs9kFDhmKVEW1Y/Q6Ic6PmFkNnu2VwcoGggqctoBp8q7pRtxRVYTuNZe/G1rChZIQ5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832425; c=relaxed/simple;
	bh=WVruzY/Eibfw1kvwy8CJSFL+wCY9qOBSRkZxC3F+RJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGax+QfLOiDFaNFSww/OMfeQ83ozgLdGARC0a3wD+OWFSMvir285qh+qx0RCeEA3NbaaSR6V89I6YtP1iWt9sib9cqsheWAcoiXIvr5BpaIepanH3Bka2AGiNL07PdBnIsS5Qa+32afB+QaYaNwE00K93PA+qrSLGISIRg1U2yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjOfO49q; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjOfO49q"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso889836a91.1
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832417; x=1785437217; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AjI3AsRUClNng1k/UijCjBlEPjB/wot6PGQU56kuWcU=;
        b=OjOfO49qiP4UlW6HmiZU40R9oV0218EgIaIOpabZzzkHaUd3mYqxLJmLiJmz7M1e++
         Dx2Mw6iQYgWv4BkOICY+9OBGFOrwY+wh02npYph1j2e8RYbLRu3TkMbzM041jhNgf+pk
         1nEgLyJQAsKiaQ8oFC2TeKrVcBpYQOc1owRpDUU8ROPT7W1XudpLnNsRggiwYaS1DPfl
         DDLZR5f76R0ZsXLHjWkQquvyilWhl4ec+fSyflGDsju3Fs3Cu2b4V7qGlV2FBiTFPonv
         rN+VJUcQ11E5xtqxYI97FszPQJlexj5hYgfsszpezKvl/yNx9q4AZVaRKGZvkcYMIiBU
         ZQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832417; x=1785437217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AjI3AsRUClNng1k/UijCjBlEPjB/wot6PGQU56kuWcU=;
        b=hzQHSVFod5XgBbKKuSQNt+9VW+sKIItcu+gl4/0h1NW7821h31aVbP/Nt79KoJhRyW
         LS5129y9J8IeHgiWCteyBSHJ67AbqHD2Zdy+XqCfbWQT1phhFlZ+Boc6vLGK9WE2WwtS
         IGnoTCs5YUX/fVgBaNMAfdxxIHEsxfS32V4U1e96wVvXQqGoKtSa7A1tFoS+Vz9Sn7mD
         WGXA/xaTv16ejrOQoxdtXmleyx+T7L37u34rX4WoMZ8p98v5WR0NZDDxBdD9jEpMGEqV
         A64maAqR6tNVwG4DCTR+Ser1z49rmkNBEaHzN6671Qed3hee8vJDrOtCeK2Cv/Vci0Py
         8IFg==
X-Forwarded-Encrypted: i=1; AHgh+RqCp8TRcuU9tqnZYOKHzZbzuYU7J0KuXV6HyoVVPSssPNFD+erE7AIT1N8Tdm2/wrhC1E5rNJqgAg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLX0bNFyuMyUNgAUrolK4m2QbJsAJYrA4DAaT5xENwIdAxyT5L
	oNywMWvW4x3gohnKH6k2hytyhDZhqwPsW2O9gwY5lFsOP9nFOo7PUrsj
X-Gm-Gg: AR+sD11agxjCfIKUgRop97KeIzeus018FGa8Nay4p/38VbAx9bb910MafgeVGanZBJ3
	bbWV91vQ0Ov3vzeTNxkT+97EfkQYgJdmT39pBsHJfLuSq07Ev+3TXLbwmL64+DsowlxGSfyHb0H
	SldJnIqiVkZhbly4+9YKsdu1wP7xeYSsH307fw+wFwIe7benCccRIwlukbbKrwfsM+fYr7ynLhG
	lijpw3xxJKndmijELCkNtXEBkeuGrTN2ls1827MfJ4wS0nmtoDztM4Wpb72+bbnYNXWitx673vy
	RE0cPSMQHVQL/B3dWyyfQWtr2FqK8e/dO73apt9RoMgpm9oK27pzf4bFGDBICUDATrsJmco5Q0R
	n79XJZjl2isHpWf3wIbL6NSRgNQh6ocRkdlAVfejATKwvr2F9qU2AfF4Lst4C8/qPXdbXBcZK
X-Received: by 2002:a17:90b:1d4f:b0:381:1f51:1ff0 with SMTP id 98e67ed59e1d1-38ec648e273mr4470428a91.2.1784832417345;
        Thu, 23 Jul 2026 11:46:57 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:46:56 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Matthew Sakai <msakai@redhat.com>
Cc: cocci@inria.fr,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 23/36] dm vdo: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:25 +0900
Message-ID: <20260723184538.3888637-24-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/md/dm-vdo/encodings.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index d75e023df637..b09373b0cfe8 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -1333,12 +1333,8 @@ int vdo_validate_config(const struct vdo_config *config,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = VDO_ASSERT(is_power_of_2(config->recovery_journal_size),
-			    "recovery journal size must be a power of two");
-	if (result != VDO_SUCCESS)
-		return result;
-
-	return result;
+	return VDO_ASSERT(is_power_of_2(config->recovery_journal_size),
+			  "recovery journal size must be a power of two");
 }
 
 /**
-- 
2.43.0

