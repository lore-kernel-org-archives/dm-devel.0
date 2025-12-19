Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94FC21C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155302; cv=none; b=c5U1kQeEK8RcrGesL3/k6KBYbSNcW+lUA83+mYAdX2PdC9nQZ7uRR4+jLpkafoFUwhNR3BYHtc5oXxWk/dfbQUvkyzhxYBngumlDO8pwnOyW+uas07NUR+WGIZ+E9gM5ewreoG7YfnxCG5u51CCTQPgVsuBvDNPUa9jYGHMByiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155302; c=relaxed/simple;
	bh=qsX3lDwwxdkwojdAreZpOAUvJ2bh6L4zEH3X55aBnag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVEBPwDAXrEJjWlb/6xphM9f+wpkey0tTi5soCBhe3Oc25p96cUcCTkmo3hat8x0xUSlv7/cH+kLL0xVXSbUA1X0aemSn07EaHBTnjIptb56pHc0SwjW5Jr15g5v7GumrCGnZIjOPnTOHt22ukbwltYTKNSYRMkLDIbBQgIZGbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=evnsPici; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="evnsPici"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64baaa754c6so623657a12.3
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155299; x=1766760099; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OCXNmIuU/rXQScWnk+KRkZAXzGxXs65iGCpsakMS0M=;
        b=evnsPiciAdEHxmLFQ/vog9SkSMlA4XVdY/py6jGwlII7jkZ23ZI1bwdJ8K3Tc9gRuX
         WFngoA6eyb1uLIKIhoiIuxZD5wGXcBFyA65btCkq++Y8UqpLjEufKB0e9H5lv/XtIzpx
         9Q1OzOmphqrwFf73zyLDrvXa/FkHMwG2JxxCnZ9Sq4eHY9jBm/j6g6+A3tH9G+iG+in+
         B+DFsoSY6P3g3RIpJ8XoUJo/6ecZPq6Tp96DsQyd5fPL4hocKg6RG4qBqpx+LarVI3Gv
         BfEIbYRgMy7nrsyI1KX2rpcIRMZ7UhgylRnnnZhPss1LjLKfKdQQLj8qLahs8jEb4uiq
         ctHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155299; x=1766760099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2OCXNmIuU/rXQScWnk+KRkZAXzGxXs65iGCpsakMS0M=;
        b=TWoOEEW0gTIsscKObdq2061//pXtQ4XvBa9uWvLWcv4H0lgx018Q84CywEkff7Qb7/
         UAv70LYjzDmwDNJGGnKc77ZomM7E2LiffjmYNub07mVlfkajc9RlzyC+SayzdHnMDXRz
         TG7PVVF74UPkpeYggTG5ETp3vmy3z03PD/tDaLTeJepsYvjIAt4cGTb67fHH4wZQGv9T
         bs/yyh4Ism0YjF/hlVzCNp0H0m+hWeovn+zd33/zNGWkVFAr8GHYCRM3zxamnLwE+DW6
         cCLqJVWBaRgUkP3bWpA790IY4I91/cpueZGRgaYGXcgidPQqexIRy4EgyQy3UDUMXjyM
         fBEA==
X-Gm-Message-State: AOJu0YwQM1OC5AcI2vvFUb7D8cxTttYoyaH+KUa0MG9ubzMgy1tj+MBB
	mbr1Wdin3ANpg4VpWbAQz2g041whOOk1mjhfRBjAjOYm9k3gIhd23XmpT0niV78fKKuReno8tyf
	e8t58
X-Gm-Gg: AY/fxX42UID5HSmUrVSbf9xqKLQx4AMt6tX6a/GptHoo41JX+gI9SfjOUsZEGHmeV+F
	1UB0fK4Oayd8LVC2mG+uIv4Oa/oo+bdd5pOr1G42iTEEmcMkq02iEzI/8pBTV2yy/BOesbLnG4b
	EDtAjxYWSrOMjLUAUSBaxUyVsgnA5GQ6UVEOpGSv7nSaMqozcqlaHn9Hww3+n/H27QcNsbfiYCu
	NfTD1ADn4au3jyw/UQ1wAC5LcX0RuHDf2Cx9A5Gg9EgNzmev8/sNhDdAU/ABKAdIps4u1dcw48i
	xBBML6wljgKd+neye3hPZU8iPROUxbIxPdUEktootwky6JyUFf16PP408z8uRKQ6z/5B4GkVl8+
	CRE67kUkzcwXd+NWvY5Wtjp0D7U4cP2uiL6h+fJJHURFISHxOUFm3ow0mDbAYFIyX1eeKPvU1AR
	kvl1uGXccwcYOJ0L+BVJc3ajF0G1h5Rsly3L+t9lQ6Vd++9QvZvjnUfKd196lKY76nd7ym9KppR
	g==
X-Google-Smtp-Source: AGHT+IGqFXIMRvWv5wy6Xs1PXImrIGdfytN9reLIAliA1wihllDDBBiT6IuM4fKuDA85CF/Tz4ygFg==
X-Received: by 2002:a05:6402:40c2:b0:64b:585d:6bcf with SMTP id 4fb4d7f45d1cf-64b8eeea20cmr3225051a12.33.1766155298902;
        Fri, 19 Dec 2025 06:41:38 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b910601c7sm2401285a12.14.2025.12.19.06.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:38 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/26] multipathd: join the init_unwinder dummy thread
Date: Fri, 19 Dec 2025 15:41:02 +0100
Message-ID: <20251219144108.237928-21-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This closes a minor memory leak (thread-local storage of the
dummy thread is never freed).

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/init_unwinder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/init_unwinder.c b/multipathd/init_unwinder.c
index b1cd283..d39e428 100644
--- a/multipathd/init_unwinder.c
+++ b/multipathd/init_unwinder.c
@@ -34,5 +34,7 @@ int init_unwinder(void)
 
 	pthread_mutex_unlock(&dummy_mtx);
 
-	return pthread_cancel(dummy);
+	rc = pthread_cancel(dummy);
+	pthread_join(dummy, NULL);
+	return rc;
 }
-- 
2.52.0

