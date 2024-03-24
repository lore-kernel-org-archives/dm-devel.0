Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497B13218B
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314808; cv=none; b=i9QwZ1K4T8JRhZDQZgqFjxLdThwPnsZNlLBPnEHCMUsoBBmfwE/znO7I7vz0gHZLVpel9Z2/xHh7atwrZUow6f6/ehfS881Aq3JH+kG9PsuQzt3sB6BWZn1dRVD75WhoYSwLmdTuh+rz9ojqLUj2Muywn7+M7flYQZXEuD0vaJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314808; c=relaxed/simple;
	bh=HqfUL5wB0IHnXqzKxaFrP9/OY+hNCydzWlm47YJn5Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiEiKGGELux7eJfxlky5GALUb82jeku5+vCazmhVYq1SwCmzd2mEtIzRxunCTP3l7VvQ1TLdebYYgl68OTMRGLGWShUwkm88IV0fJqt6KwT2hjnklIJfzIs+1DdTsn+juyKWF4d+d4AvzDhN/1nMdSOG3q4zRQGNaQdacCH3JbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VjJqEIYv; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VjJqEIYv"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a470d7f77eeso462233466b.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314805; x=1711919605; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Osibz0bVyjtvV5iZuTG2gdFsYUXDHhBK0lUERPBnxQ=;
        b=VjJqEIYvKXklOJ5hB1HzjhGqJWNcqE83Iuw9CXuPE17GO/Y92813EiUVF5WlE4g9uC
         jOIpwyeEei7TUMZh50vyAJfSyhqbYHLSaVxbC/yjAUdB780av8OrYKqXyujghSth9Whd
         cUblS/rbRQUVPa0QQekkBUcsKwkXfQ1UaUtiHH7mfj7nApvbfqF7x+wvi+iLE3pGTK1d
         iE1Gxip2oHSTQhDR+DJgr5J4WyjMAPG1TN+avRRFL1SzNBsL3oxHbmzIEjhH//4Ef4KI
         E7H3iHwpuy8Adav0oysPBnLICvtbSANzQ9rJ2u/OO36ttpREzuH/RQzR/QIrkqmmIvXg
         qmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314805; x=1711919605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Osibz0bVyjtvV5iZuTG2gdFsYUXDHhBK0lUERPBnxQ=;
        b=Z0uk47+j73+qSP48ZtH2OwPaL4csKwD62/4sNfTsFsHjqSs007xpkmwKYWFprYB/Yr
         4CdvHIK1nANYQnJ6eGz2Jfc6Zg1gjJHOm1mS/CBzGZVTkg1BWzab3d8fsbInIGpZuwTK
         CBiJXktuA0nmpySXuyN4iA1ELKinprp4IJqU95vknKdBZN6QG5v8xguTxTmhAHTO2UPr
         o7BUc0DqtaGVF0W5W4j6ZdWAe8z+JqzPuhGUFQiDuFRZcSSBWeA6KGXiekPUfyALQ/xl
         jGjj/sxBg7J8mMMPzQgzy9QwViHYON4rxgVdH220rBqYRAiHwd05xYO4VQRA92CtcpW0
         5fGg==
X-Gm-Message-State: AOJu0Yx5OnFeIle2ZpqH3VQMLozg4xIdFh0Zv41ES++Ap8t4Mtqb3qY4
	LtWHG8fx5ykVg5tquSyDqug8canygQ+mldB+c+qJUA+pNfpHNOhcrl6djW7ve9k=
X-Google-Smtp-Source: AGHT+IHC0PUHL9NoUkXNL5Ut52pVP1nSasHpjvFCSYBk4HZBo/Fxjps3iMIHsHUTx7ElJay6oxlhRw==
X-Received: by 2002:a17:907:1742:b0:a47:1d03:f37a with SMTP id lf2-20020a170907174200b00a471d03f37amr4014443ejc.47.1711314804793;
        Sun, 24 Mar 2024 14:13:24 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id v21-20020a170906339500b00a465b72a1f3sm2320586eja.85.2024.03.24.14.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/11] kpartx.rules: ignore DM_SUSPENDED
Date: Sun, 24 Mar 2024 22:13:01 +0100
Message-ID: <20240324211301.7200-12-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_SUSPENDED=1 implies DM_UDEV_DISABLE_OTHER_RULES_FLAG=1, no
need to check it again. The DM_NOSCAN check needs to remain in
order to keep compatibility with dm rules v2.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 1969dee..8dd3369 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -27,7 +27,7 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="mpath_kpartx_end"
 ENV{MPATH_UNCHANGED}=="1", GOTO="mpath_kpartx_end"
 
 # Don't run kpartx now if we know it will fail or hang.
-ENV{DM_SUSPENDED}=="1", GOTO="mpath_kpartx_end"
+# This is required for device mapper rules v2 compatibility.
 ENV{DM_NOSCAN}=="1", GOTO="mpath_kpartx_end"
 
 # Run kpartx
-- 
2.43.2

