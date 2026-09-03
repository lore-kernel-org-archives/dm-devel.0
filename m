Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B52A4E140E
	for <dm-devel@lists.linux.dev>; Thu,  3 Sep 2026 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449133; cv=none; b=uX/P1cqBaX0fFcDAcyxe7DMgAi1Qt54e+LpIo3TcvMiks7JH0PM0aHz/+QXnR719BfGEefxtr23D2carG3GtoiF8LWorQnNe4pXsi00asgiVJkBGtGouh0RJtTWiTEaRcD16m6zm37SplhdmB8AIpKLYUogpiHjRsG2UvU/xkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449133; c=relaxed/simple;
	bh=7x6k3CoQtycsyrx00Mon8kDDGXAjBXWuI79x9y09/hU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IDUacqbpfgSA/X9PMaD5ca2HZ3lC3e1pyLrF51pvwzwh6MMzz8CDhZ3FM2IF0j8Cwdjt6eyySWQ779wFxDZn9zWbN0VYMlSkSOTfo3fpGVrXoFsNkdztMduL00mMNfTRLqfItvfPUYlSha43Z2l9/eOInkMnCICVj2WaKtliiB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iApfJD/H; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iApfJD/H"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso20849055e9.1
        for <dm-devel@lists.linux.dev>; Thu, 03 Sep 2026 08:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449129; x=1789053929; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RJ0eJNAdxkEACL4i1LkrRsC16NHPzemhDd0NbgM2FuQ=;
        b=iApfJD/HM23mxi3w3mF3HPBFNJCW4wE+p/N5MOFS10ykHMpr/70C/QztJGcOXHJDuM
         UTrY544xu9PIh2uI709cFKqtWSs+VnZJMwjbcAQfh9V4jAyzmJberd98N5rFh4c71qR2
         VpduqHv8y3VSD6VmmQ0v+FoSZoT8RoIUqTkLrqfNkBbVKRg9B0Z7SGH0WOxNF31F02bS
         PR1Pocz4hbh/o74MsgOafMdbfJxZgX7WAPwcX9qPJEDxVIJSLP22+EEGdQlhQ8msEmqt
         4G3PRsSNkB5uu4AcvyJFCDBJhO/631Cv+HsoQKSLTGZvJV1ezMCnXO7AxtULGpmFafmw
         3awQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449129; x=1789053929;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RJ0eJNAdxkEACL4i1LkrRsC16NHPzemhDd0NbgM2FuQ=;
        b=Iwshgy/tCwjTUkktwdG6HWP6XbR4SE9sQYVurcULAVqbcSBgZ7CmvQYzpJ/n4cCx47
         rfTjL9C+IzXxrNPP5zZ+9+CwMBIiRUaEANSlh8STOPi/VAtG+cRRKl/D5MMD+SIhBR4B
         eW70pxvnDAbgH3TofsXZgFlubVd9Gb/ZRyGFaVLoK7pFBT72WT7J3T5tkDcVkFxCslRH
         IHm4WMawaI7MUnSvHASELgQUfC/u0edZgL07IEQlc+tiRAK/xx8UegM06qV1q/ubyvZU
         X/ZPsIrVTft1Li8qzcEgdqWxu2SBWlwMYbQ+eaR9LhYOCrK8Nbg+WWwJ82DTFkzQyp5v
         u3Jw==
X-Forwarded-Encrypted: i=1; AKwUvBwH1lHVhMSVmVGA4rHASZ4lLPUWzN6JW0Ay6gprecLfpsRCBqcc/rfF2+0TOrqj03wg+LPWxmeXNg==@lists.linux.dev
X-Gm-Message-State: AFuF++mXCJNcdc2taJd1xxgjhRMcqfGVhKpss+A5fEr3nXOWG2aaswh3
	5aQr+i10jFEhIbittkM3hgVEuVHaZwISc9aCsEHRV1mBBeVNjbeqMEXN
X-Gm-Gg: AYBFou22Y++79wGvrueTCK6JOM+J3h3vl9Oy4sFZIGiLSTtptgP3RB0kaBciZqtWsr4
	7jgYDLkQb2Wth9J64HwThtl7z5sw7DWLLYNt61cV4+SeNiJnMXe7HrWJvS26iGgiGpzBkyY/Afj
	yH6bO3g1JEGkGHu2GtLl0cCOBRRW7i7brnh+EdHdsvGUfte5o+dO1yFOAyfl8lam9JH1HaNprRJ
	RaDfXqjvSKKoGz2IgoZcQL+7pdgYtVhaFcKJmEzcb3UUuWHx3Oqjv+SzL7m6SkJquhQt8qZ16uT
	ykPJbcDGRfkuAWgwRZZ/Imiavx4jI6RYR8EzmV8wfoT14ZOioaIilNPPsys/3IqGZVtmtmU0c0r
	aZUmHDtja62mlMu0G8d3/F9FaSssM+4Tzi1InASnxtJevxlj2vELobr0YgjqtmogKdO4P+RZ1g+
	c4a5y/VJEMnsIjRaaL80sm1bwVmpehnOCrwV3P7ycrD8BL1zOCzUcC50mhIo4=
X-Received: by 2002:a05:600c:1d11:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-49ce582a54amr228971615e9.14.1788449128877;
        Thu, 03 Sep 2026 08:25:28 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5dec54sm93729425e9.12.2026.09.03.08.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:25:28 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Matthew Sakai <msakai@redhat.com>,
	dm-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] dm vdo: Fix spelling mistake "postive" -> "positive"
Date: Thu,  3 Sep 2026 16:23:25 +0100
Message-ID: <20260903152325.16304-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is another spelling mistake in a vdo_log_error message that
I somehow overlooked last time. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 1d8375cc3c3e..043549b1fc2e 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -443,7 +443,7 @@ static int __must_check parse_slab_size(const char *slab_str, block_count_t *sla
 
 	result = kstrtoull(slab_str, 10, &value);
 	if (result) {
-		vdo_log_error("optional parameter error: invalid slab size, must be a postive integer");
+		vdo_log_error("optional parameter error: invalid slab size, must be a positive integer");
 		return -EINVAL;
 	}
 
-- 
2.55.0

