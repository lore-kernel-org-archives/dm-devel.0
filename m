Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2D03FB2F
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706701730; cv=none; b=dmyL2Rgk3hDWotEUd7LueqCiszHbCH9EDwbHKY//qe0k/WPSqqPRdBgM1xA5t2nb3/yI5xS9APvY67LCQ4UYkpIH0UlO8JfJJMIHAj/wR1e+purllpOeXeZG8qu1fPflI/ONssfl3/0bEUGZepd7hpQBtiQ0+uTph1C+d5St+8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706701730; c=relaxed/simple;
	bh=3nq02/OBnk2zvuDQtVO0yktuZSQ0cvGbGgEeygU8nUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uFWC3vmGi4apoI7xX/Nw/5tV+rhwZ3pxAjRT6xmjm5nUFFaYyzCrzeDDC+zUDuM1X4h1Q0pDBfwvfbtdQUYuTUjgh+QNfx3RWLkyjKCK2OuNDq+Ta7cLuV5klMXVbmNoIM5JwKpsHEtyJfZWXzhgUNasMzCT1vyYkGDkPb2cyOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d3goKryN; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d3goKryN"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-558f523c072so6302416a12.2
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 03:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706701726; x=1707306526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ee4hFTAB1vqmeEEdD7N1TlliPwBwfYX459Z3zfUqQ4I=;
        b=d3goKryNekJGsnfZSPTZMd1bjl4i5Os7BC8OolQc2Rnm0u1yFt6gIugsIQfOddH3Vw
         nH2Al4msnhhuaGw5sUpZ4QIGqf58jj0pzLktCEIc0p+M9blvBdnyX5StQ/tK/CyFglFa
         pmtL4mrB+sDJw2H8+yvIQ828SpYw3WFeU4/FSsXiZpK9G8koqJYcrvRg8xyiJvpKG7lt
         dhy6UvxlLvBOy8rjUpGX7LXUfur4HvGWGKRuoRMftRT/fMvvu4IFqvEwdnbY07qhfIBH
         l1rCccTI4g6wk4pZ8wdh1ZzMTuXSeZsuwW3JLGUSOEO+UrSnJI/+0SaJG+Q4hzEwcDXT
         6KxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706701726; x=1707306526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ee4hFTAB1vqmeEEdD7N1TlliPwBwfYX459Z3zfUqQ4I=;
        b=LPvOnW/lDpHts/GfvcXN0fglVYTBNHDDprHYS7Kcu7n3TPvp+Hciv0KOYyy3sxJRYo
         UMsy85J/A9ETxv5ZYui9J/IY2AXpW3ekvGWu9eCzmesSi3rlgBpt+aeSzdVEmePLYqxw
         mzbPD947z3NJusc1XOspqgD0rd5EeUlkLGQoFFSYBlQKIYLkn6HPwY7O/IvssbrZtBG5
         k3mzs7Dn5bO82RgqE6XacTyO0tPKr9Pjc//bY/IlWTUiDS22AS64ldaA7CSevf688pZf
         bE2yzon809Nu3aietZ7WaiwWuPD171B/oawmA5eQJNK5Qb3xo6IUzPaKljFCuZnU2ymZ
         qLpg==
X-Gm-Message-State: AOJu0YyhhVh7MtePcU4gDPUMlHA+fecEjstxGUo7OKfVhEUw2Sw0sXgY
	VRehHj/NcWrIYptO/phwaApxOPQcLpvDNsP7acVduODcFtSo6EettBUij7WEWUY=
X-Google-Smtp-Source: AGHT+IGmNgl/1br8YVLLzqjDDn+0dZC3L3GicV74tZ0kczf2FQsZ6nakpgjYDYSssEJHoN5HAPXIgQ==
X-Received: by 2002:a05:6402:234b:b0:55f:6a35:b541 with SMTP id r11-20020a056402234b00b0055f6a35b541mr1201231eda.14.1706701725823;
        Wed, 31 Jan 2024 03:48:45 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXofa7wou1H064mFwDVZw0j/410TbiJJWG83l6FtFTgK6vstf+VUctR6f4ZWrJBYdO/0oSQJJDFxbSthCTSjKyh4lwya55x5pH3S/dWD5wg9p43PhCw+Z0c7R8QKIM2/aQUxjFu3ZDcfWlm5W/Hkmh09wgnhCFx6Td4BDTXFfguAfJ65t5FFBGieSWj3O4pny5SNbqtoiw4X+M=
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id r3-20020aa7c143000000b0055f98c703easm46804edp.6.2024.01.31.03.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 03:48:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Arnon Yaari <arnony@infinidat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Tom Abraham <tabraham@suse.com>,
	Jiri Belka <jiri.belka@suse.com>
Subject: [PATCH] libmultipath: hwtable: fix fast_io_fail for Infinibox
Date: Wed, 31 Jan 2024 12:48:35 +0100
Message-ID: <20240131114835.20982-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Infinibox hwtable entry had fast_io_fail and dev_loss both set to 15,
which has the effect that fast_io_fail is switched off (dev_loss timeout
must be higher than fast_io_fail timeout).

Remove the dev_loss value, which will cause the default of 600 to be used.
Experience shows that dev_loss_tmo values below a few minutes are seldom
helpful.

Fixes: 55da608 ("libmultipath: update INFINIDAT builtin config")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Arnon Yaari <arnony@infinidat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Tom Abraham <tabraham@suse.com>
Cc: Jiri Belka <jiri.belka@suse.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 808af54..9ef3e45 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1161,7 +1161,6 @@ static struct hwentry default_hw[] = {
 		.minio_rq      = 1,
 		.flush_on_last_del = FLUSH_ENABLED,
 		.fast_io_fail  = 15,
-		.dev_loss      = 15,
 	},
 	/*
 	 * Kaminario
-- 
2.43.0

