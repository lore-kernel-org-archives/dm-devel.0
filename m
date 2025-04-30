Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8270A2580FB
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746020741; cv=none; b=Z+bP8sCiBjsk0f3ryY8Vk1swTbz7vUAflkjRa3JXP7edBJqLLkTr3ovjHKmtEvvD8vpxiOkyH3hLcTtV9+Eqlyu56Gp1OLRj9U0K/asdeu6Ui+5NknAT5jhMioqH9KG4v/qtmj2RGoKybeAGHcxuVU74HGHoqwxIu7E7ja05o6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746020741; c=relaxed/simple;
	bh=IV53D4XmMPAdID7dzxqp7h2b3V/JJuW9BpS+fUfGHnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdmY5fnBZNcvavsW/RDMdchIp7LgD2M8C+oUJqCBweqWjf4t6Ubt84oqNk3cDDpDshe2QMzyGaTJ5huRsqOGCiodfECBFaM9VGvfXGW0U7ZOXRgqIY/3EknZCNljZmlzm8p6WeMRQcXrbLvI0SI5LoYfIzQlUwQcmgiX+UlVKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXuMFP4N; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXuMFP4N"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d4ff56136so8409525e9.3
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 06:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746020738; x=1746625538; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEL05W6Vb421MTUfhi9KImm9RRJpjDVjcdCrFhXrUXo=;
        b=UXuMFP4NTx7F1P1JxQ+R9CkRMpOKBeAdR7TLyTnGrx1I7aFlAKmN10nSpa5TC5zJz3
         hH9Tc76eY0Rg5byO5WSTt9OCKhUx7qloF5GOwOMUF4A1pYYwHCQuILchBfrE9Zcjjb5+
         foRcApFvxASUY41JC59ZFpZFD1ewMA0UBb9XCrk8ijtCRkGH6xAopXZXO+ZKT8LRF1Zo
         moacj4VZ9Wnw+bnmcE2fcFuZoNDNGBLL5wxxiswlSaP8oJVof2SKgYqfHljmYEGvSav8
         iIletFZKwUbSjzdXPhdJVA6rstJw2/d7KDnySkOYUsbpyMH9Z8YQ5YRe4NbMKPHkkO8o
         /UPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746020738; x=1746625538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEL05W6Vb421MTUfhi9KImm9RRJpjDVjcdCrFhXrUXo=;
        b=mlyLnAr+YDTNJMz25ue0owNYBNqkplG0QZf757Jap2SyqeEQ8qCGijHXGwBDsFyo9z
         oM5O/hIF1AEMZ5y5cpc5wbe60jCf8IC0bmMJ5uDs4N1Cj7DrDO9rNGn1Z4claXuNp+WA
         RAQhj5JCfYQalI6BrxxxjVYJXXsNFOl7XOEh62tLLF/IHmprUlTId3sEDtNEI9tqaY/C
         3E4aFg7s8NRZrznFupJBv79DMGndcfx6o0r5JGqItXKqXWAKi1hFx9+Oo0tcJFIFuYBa
         EQP7yMWayYpFwkHaw5GDnnCxVqTH53OgASJo/LFIJ1jDStcUI9nlyOungnIwZesQmTlR
         UFog==
X-Forwarded-Encrypted: i=1; AJvYcCXgYvcXA3HVfH/Y2hjZOnm8dnzsb4NkDhyM4kxWjAru1at9wlr+nGg7ShRh1Q8MOxQaNM6haXI0Fg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwP5+xBPhJc6pExwMImgw+qefDJyhvo0y1G2TAalwGrNMP32rDG
	8eEGhmjWHr5IG8hgZzTYkgsIABmyd0lcQ4LzYDSlBybnl91B7cE=
X-Gm-Gg: ASbGncvnIWyVgw7tf7ZJLv5GyOPDnsF5A+rh858jMIkBRYYtQDUvVdRJJOXtB/fwLij
	4IcROAPqR1O22vmeNyRMKd3Ie6pXyv7JtCGZHZGp0YAYYBECkPI0AleRs/az0OcC5c4mCVs9N74
	0UIOUddKd/8X05uuhl9/gt4H3AYVxf13Ewmud6A0BWAnj8sQrn1MgAX0VUHmk2vCb0tBMxO/w0x
	4GOlopBt6QfzDubnzPtFxqrc9PGi9enySbtbmeqE0Ds9tWrgSjr7tea0Sjcsqcb/xaDLJcUKZuX
	hEYqcgzR2qrs716QcfEAXWiuXCiVCwjiclt9d77f/5JEzlYs+jA9WaAmICBBOuJOr5znqEHA6Lk
	zrNId
X-Google-Smtp-Source: AGHT+IF1Z7X/sseRTbDHAR1egbGEteDKsXxDqzkIBat3w8PQhvadDjgqMl2rPa+abQqAhIaVW7vPDw==
X-Received: by 2002:a05:600c:8508:b0:439:a30f:2e49 with SMTP id 5b1f17b1804b1-441b501c798mr3001705e9.5.1746020737447;
        Wed, 30 Apr 2025 06:45:37 -0700 (PDT)
Received: from localhost (202.red-88-7-162.staticip.rima-tde.net. [88.7.162.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2bb3d41sm25275045e9.18.2025.04.30.06.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 06:45:37 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/2] multipath-tools: hwtable: change AStor/NeoSapphire to work also with ALUA
Date: Wed, 30 Apr 2025 15:45:27 +0200
Message-ID: <20250430134528.82361-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250430134528.82361-1-xose.vazquez@gmail.com>
References: <20250430134528.82361-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Some devices supoorts also ALUA

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f76d9180..081d119c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1296,7 +1296,8 @@ static struct hwentry default_hw[] = {
 		/* NeoSapphire */
 		.vendor        = "AStor",
 		.product       = "NeoSapphire",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
 	/*
-- 
2.49.0

