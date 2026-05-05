Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CE6313550
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995830; cv=none; b=boSotg1cJHzAQiDeVQTyFYeKMShApO/MOZMHfu4EUEsAZbozZpWsY/7CaMy4qdXHzX89Sqj4s9nSjGb7RtRF8kkikyfoU6O5yhAlNtAa4kzQg9+pZvUKuqO3TzJzTKJcMi+yJqPb/eKfLQV3Cy0lPLKf/q6Dhu8FIWrpr54kry0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995830; c=relaxed/simple;
	bh=rjV1JRP8kMRdAtyAv3s8AWXKKpmtcoiM4c5O88hVKko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t36dFbkdtN5KHNq33Fr8lw5h1WWvybGUGuOKKSgaErPpBHkfEkJKK4n8gmkPS0jVG1sZ+lQf2Myk6Cog3jWaV26TBj4O3SB8JQtxMDzS4qqNxatU3+tAJje3PZ1uTfx2GyjSkksd5Dr1bUG2K+XPqbee/XGpRALQsmMvpdGPBiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rn717pVO; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rn717pVO"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-449de065cb3so3070536f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995827; x=1778600627; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw4F7SotrRRC8qjr+OqpB8hosnCrli0GaAGXBca87eg=;
        b=Rn717pVOOTqdKy3WHJZ5gEZkOs3JYCjq+Sn0xYHJYpei4I4n/k5NkQ+ks24GJe0P6J
         3h7TXqqFsex6ms9hyX0XOvt0kaJEz8l01x0pRo1RfcnZ7v8vF7SLbbzbU8bnPy//j2p/
         cCoyfNThBJPA+19EuP8RNcJZrhvEmODZRQQMSCJuNThymvncDSpcgyxurvevNYboYUqM
         xJVnQMwhkgFdRknhAhKC5kINUS9kM+ZgO7hKkicjJuWes8ey+EfRP52TCg1EtutOUyKQ
         RjMLqPTwqXnKY8bFyWOBehib8sjO+1VNmyKkA1l56HGBTkn77dYkwQkI9duMWYAgATn7
         JWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995827; x=1778600627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dw4F7SotrRRC8qjr+OqpB8hosnCrli0GaAGXBca87eg=;
        b=g9/K1bIXthAA9uwEmHbWdsv5ToKWkH8gN+aEXNx+W7r/8PieROnUqdPRx+9Nhl5Ts6
         hJp+tjhsTJRrc6o20jB97TsFSU2egqCPU05+1ZPmjm0nCQysavsmf7ptcOPfRSXPjZKK
         eveSQRvLRAjbKtlGxO86M/Gatmn0afROF8uxeWm79xHRaFXM0jpaHN6fr4VVkJPYqkhT
         2xiHLviK+J7O8yCBe+MWR73un4YKNvZmBQR6a71mCO4GrGidwafauEwKmSiAv4S7epWy
         Lhx3E0kB4UncSyxdCV9yWF45VTS9Slghy3rilxPTQ4Evh3tzpt52TVqA8FHk0maGOL2K
         EmBA==
X-Forwarded-Encrypted: i=1; AFNElJ/0sFT5jXMACmix1I+9hbJHUvGab8IjtIMP/e775VU+2mCtEDgjwrW+nZDxk5MHN7meEQM5qlUFfw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMCuoIdAEd08d1sBRbQw5ltlmUbJQoHZIxcEsxglkJ1WUjpYag
	aXDEq+/7IwsP8hLkzcLOnl4qZlA78cgUjP8ZZP63dyD+fje9B4poayUNx2b8DqWqWQQ=
X-Gm-Gg: AeBDiesuS/BfzHUeetfirjMt1flHQ+VUvooL1xKEor22fUoFxBo5K25Px2to7HDwmuN
	+hZUlpoiw97Ist3CWvNnNmzEV+nZ90Bsf0zlCV3MeCNRCCTs0ALZQoOdumz10R28SVEPc+TWS4l
	zExIFFJke34eNh9MI8yE0NoWdGFPRt1BV8/A7Dn4cLfUfZHnfWy/7g+/rHWbV63aguPNjXPC7z8
	j8OGQXvW0Ia1M8xEoksZWfIQSxOzGMaLSlMiAgspepBl1pk+eI2AxmAFZiXheVSQwzwXaUWsPMP
	lxo+/2GlGJJsZpwVxoK4u/azuxXnIsHLFHChq5KQ7dHW5wzH1ZjrbErpXLI0CfBH6XTcYxz6g87
	kysbZWMXz2ybFDwSQ82JJBf4KPpK4jqhBy5xKPtOwQjzMOt0DOTwhJ8aRZffned3BMjbgvBeL4l
	rpp8La49JeG8dGrXWnc+6m9qTgnWPOUNWz0vccnDj4/2DI2Ef47VvMZWcvjY3dj+bwJUHNMh/ch
	YppFnRxzY71t7175BZKlzxY
X-Received: by 2002:a05:6000:2512:b0:43d:77e1:6a66 with SMTP id ffacd0b85a97d-44bb33f1d66mr24921781f8f.8.1777995826661;
        Tue, 05 May 2026 08:43:46 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45052483166sm5549850f8f.7.2026.05.05.08.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:46 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/18] libmultipath: checkers: add two generic checker messages
Date: Tue,  5 May 2026 17:43:16 +0200
Message-ID: <20260505154332.448054-3-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add generic messages for "timed out" and "still running".
They will be needed by follow-up patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c | 2 ++
 libmultipath/checkers.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index bb6ad1e..8a90ade 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -365,6 +365,8 @@ static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
 	[CHECKER_MSGID_GHOST] = " reports path is ghost",
 	[CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
 	[CHECKER_MSGID_DISCONNECTED] = " no access to this device",
+	[CHECKER_MSGID_TIMEOUT] = " timed out",
+	[CHECKER_MSGID_RUNNING] = " still running",
 };
 
 const char *checker_message(const struct checker *c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a969e7d..2317cd1 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -124,6 +124,8 @@ enum {
 	CHECKER_MSGID_GHOST,
 	CHECKER_MSGID_UNSUPPORTED,
 	CHECKER_MSGID_DISCONNECTED,
+	CHECKER_MSGID_TIMEOUT,
+	CHECKER_MSGID_RUNNING,
 	CHECKER_GENERIC_MSGTABLE_SIZE,
 	CHECKER_FIRST_MSGID = 100,   /* lowest msgid for checkers */
 	CHECKER_MSGTABLE_SIZE = 100, /* max msg table size for checkers */
-- 
2.54.0

