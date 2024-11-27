Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE6204086
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748689; cv=none; b=uaSYyItLxUpl7b6I1Jfx0uW60ICsyB/X/cOlWQP7rlBrZActyRfsyk2zkXiSYxpDqbH0xBQC/OzywQogVYxzHh8+GMq2B/kNyqrarP92bxhKRPwCLj6IHGqbXMio/Zzz5IjWFnzjwAaHEKwLdhnPQmq16eKaP2oSBCu7DGiG7DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748689; c=relaxed/simple;
	bh=B149yvPgIKHW4PFWfx8re2i372ylWp5fR+kEg85PKCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlRBCr78fnYFDx7Xc8cdPvLxuUBeSmA0GcI8HW/wnc8hKVIRwf2Z2mtsjfJEwvLkBINUh9xHf+mR1OPtlJjD+FVqFmPEnkb5QOgyRJkIpSvM1Bo8xMlZ+b3SoT4R3i88vg2XbNgjVipvpiS8SxVLXtcpBfKS52zdvenGITKor/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eSqlJZhA; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eSqlJZhA"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38248b810ffso192989f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748686; x=1733353486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bdjTZ7PbBu/BpdZdueuvo1kxjSc8Hq0/qC9334W4eY=;
        b=eSqlJZhA6o60xJRYDgU1WAgBn2F6N+hh2X0+DxCiT0L/zfkNmU4PIHvuy84hACIYPH
         pR5cZDvPIhmJg8YGQ2OObMvGaWvKh0kIjXmRme7dOShZ26LNqNWspaiGdC2ER54+8NEe
         7JPclvJyLFHjsM9F9B/idgZJKp/n/vZDfnK/hFdnAnEr8d1PCHOUwbaDigrzmQ9nPGVU
         O0Hi6XxnAxVYBLlY+O3VK43dW5GU/1N7V6uo+1m0VxQj7r7s//xKq0kjPU73YCdDRyR2
         gQ5klbm5PUa5dJJestgJdJcuh7MnS3LsuUPEU+hnHo86Fp3eQo/tfYTix81rv5e/PNjt
         8P8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748686; x=1733353486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bdjTZ7PbBu/BpdZdueuvo1kxjSc8Hq0/qC9334W4eY=;
        b=Tmpt87gEWTLrO3ghjDA05zYSZqiRvZRc20eG3ZXyIPvzW+c0s059CCpBOVxr8dp9A7
         Az6QG2kwhSig4AO3nRnIGlxRo+cetDdu2H53iluxYtUufIWQ71xycKic5wm86TThmqHG
         p3giZQbnfcwoYBg2A7qruZGigMOQk8DvUfYdVahRfVHgShv/kKBMLLYI5KOIUb1TdRgc
         4ER4sO5rKFfs2Ua51BJL93v+BDBmXNHI5J4ezB4DcSvRrE5FUKFx2LQeFFWcBOgMcj5p
         yam5epTcUQn3YcGw6Awpt7U2qHeS8M3sSR5OyRBlgiEh5BbfP44Cc11bNj7CmwA4SpKn
         1K6A==
X-Gm-Message-State: AOJu0Yyc4XT7bMn9TjSPmmDpERW0gF0gyt/Dqt5Tbw0Q9Qe/88nDTEah
	cB26m8QT5FPkRU3EnG2E5dsTUdA+duo5ZwvgWduQDXYyu/ADH6LoLkC9J45tl6jWnwHe7V7x7Vk
	X
X-Gm-Gg: ASbGncvNBSGMvLWXRzXq9a3BYKHHaZhgcgi1JTC8H0GnZRD1kFaog1c0pWTPnMUX6RY
	EzUmFYae2Y35D4zwUt2aliuOm3+PIuFGe6bxrq1wynR6WNOQy8SXNHmmyR3cMMh2OYoDHl72q+K
	FDJxN1i/lldVMZzrURavBoe8G+dMxdx55kPQ4wiw+5x27AtV1ib5feN+r74miyLJPFOSWJuKp6U
	5BaNyyjNqN+GVVrRPmT8hcfK1QTytxP10AmWMOToJwHCI+EMTQPxyjG6ULJrsXoUlMMs60cOjx+
	p2T5bwqzpLZXmlm1H58NakrYyz7bqdpJO+C5
X-Google-Smtp-Source: AGHT+IF1xDAOt9NtYvnA9hp7IappnTEl+/HOYuhQN6f3cly81pFqjkJA6oVONQItBKe8vdgu1doWJA==
X-Received: by 2002:a05:6000:2a08:b0:382:499a:dc6d with SMTP id ffacd0b85a97d-385c6ee26bcmr3245526f8f.55.1732748686157;
        Wed, 27 Nov 2024 15:04:46 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434b0f32837sm2758575e9.33.2024.11.27.15.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:45 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 8/8] multipathd: improve a log message in coalesce_maps()
Date: Thu, 28 Nov 2024 00:04:30 +0100
Message-ID: <20241127230430.139639-9-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9ed27da..e9d9848 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -795,7 +795,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				i--;
 			}
 			else {
-				condlog(2, "%s devmap removed", ompp->alias);
+				condlog(2, "%s: multipath map removed", ompp->alias);
 				trigger_paths_udev_change(ompp, false);
 			}
 		} else if (reassign_maps) {
-- 
2.47.0

