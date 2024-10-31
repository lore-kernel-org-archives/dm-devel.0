Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23671991CF
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 10:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730370440; cv=none; b=QQ8RUDdJRlSmWDWPs9/608dLICkLvz1Vc9cG6rirG5v4AIpY0Yf+2q9Pp84vgDgDZrq+FVojssZdkvlzijtC6xGMF5i8FabUnd+CPwSoA+cZHyr6S7VjWdNKnhXknTW/BxCGJ/VzEW7ndrGUvxGrHvrCStYKYZ+HyEUYzsxKWyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730370440; c=relaxed/simple;
	bh=cYqRl7ujIimBpwSgJx1V1AB6P61Md5CRNLPpxb1PPj4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d0pckLF4eTmkoawRFObQMuUr27z2Qonffk2XxiYt9t/X1grenRVSNy5j/vaAGE1sGphMKQ9EL6jNWvLF6FklpxnY06hvXXTU3zyWlh5bnA/TkhnQ5ri7vyAMYoX5vFmSryGqqjQWRiuO496YNj669nyFhhg/cmy7CQUwZP14G7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kBGPVBIk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kBGPVBIk"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso6984595ad.2
        for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 03:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730370436; x=1730975236; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z3ZugE99LtSXQE5Vb/qD42v3zeWQYKRSifIMEBMyrqw=;
        b=kBGPVBIk3ib0NDfa7NBCxra0QQzE9hUzj8nqq1lOM1lzGglgYz+Xha0MweC9DhOEeR
         gJRILCJkoHNwHNG4siOp3qwqQyP5wZKVO/lTECSivhxfdHuqgkHICCYk1e8os28VLa5q
         1yoa7efp7pw6uIH9i9KlNBWB5OfBxKhG6T0N3ns4V12tlYaanX0zYSXorqnf+JYxm4kc
         BjdOktjUJIymDkinAsdnVtdA+yiJDhehD8MVD4p8cqPlvQy75kRytYafyK0/CjghTNh5
         xWjfwgU+ViqY1cFhvo8onRV1+rFpmjndFDFhB704a+LL+Ozky618nGtg5gP7MZHlzovA
         Lwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730370436; x=1730975236;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3ZugE99LtSXQE5Vb/qD42v3zeWQYKRSifIMEBMyrqw=;
        b=p2EZ6jWpdoH4Q4bHifikCfZ1JtDd6dqvblMoGszyMG3nGWGlJEO1RsR9/2vynhvsBh
         XM/7WgHLIw9T+V6hZeefY3jfIvpc9i2+V0RMmCkshaUTsEAJJprmCvE6cBcTuMFvPzd5
         bK+jSU73jGuGW0d0yIhxR+p025vWbaiXEZ8Lq9uWr3TWyS1y8CMdo5MltURmQUHsLUQN
         4tN8C1ABMaOx/FyM9Ije0dexUja8k6EomYDamkXrEHMhcjZl+nlt2I7wLTUQg7YO6i2i
         lGjg1Ho/XDnyRWioFY82AjLfyepnzS6dR+5WD6Mn2qSzi83dKvt43vSMADwIzR41oOqk
         x4Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUp6Tm94N6t+trLiYiku74y5f44yt190XN+/LEPUX0EOXGqH6In5AybLAk7u7L5K/wCt6GBAVeWBw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyjkx9K4ij4DTVemoOOf9V67g8L4vBFsOzZQ+iokr6hXiDA7aKM
	VcVJEv1Qkwbh/Ybp1iE0CV6WZMKuUBdqcy4mFH+rYaM//XdfWkU=
X-Google-Smtp-Source: AGHT+IEBcE8vj39grKtLpz9CgfafRH/GRYskQDZM1Eebvb/oBlT4YNE+QgxON3pgrEz10Q1ePPPlEQ==
X-Received: by 2002:a17:903:187:b0:20d:345a:9641 with SMTP id d9443c01a7336-210c69ea999mr202558035ad.27.1730370435818;
        Thu, 31 Oct 2024 03:27:15 -0700 (PDT)
Received: from localhost.localdomain (114-45-152-127.dynamic-ip.hinet.net. [114.45.152.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057a2f08sm7082385ad.154.2024.10.31.03.27.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 31 Oct 2024 03:27:15 -0700 (PDT)
From: Ssuhung Yeh <ssuhung@gmail.com>
To: snitzer@kernel.org
Cc: agk@redhat.com,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ssuhung Yeh <ssuhung@gmail.com>
Subject: [PATCH] dm: Fix typo in error message
Date: Thu, 31 Oct 2024 18:25:59 +0800
Message-Id: <20241031102559.33162-1-ssuhung@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the redundant "i" at the beginning of the error message. This "i"
came from commit 1c1318866928 ("dm: prefer
'"%s...", __func__'"), the "i" is accidentally left.

Signed-off-by: Ssuhung Yeh <ssuhung@gmail.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 3a19124ee279..22a551c407da 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -51,7 +51,7 @@ static int index_check(const struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       INDEX_CSUM_XOR));
 	if (csum_disk != mi_le->csum) {
-		DMERR_LIMIT("i%s failed: csum %u != wanted %u", __func__,
+		DMERR_LIMIT("%s failed: csum %u != wanted %u", __func__,
 			    le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
 		return -EILSEQ;
 	}
-- 
2.39.5 (Apple Git-154)

