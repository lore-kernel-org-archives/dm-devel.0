Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C487A1F941
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746020736; cv=none; b=hHgg3eXBdZfxEGPj/bYpchvDotGWKWVcS52L7ztCOR1DH6ZVrjFq3vAyfkj3CZWmTDoEQG/VlyXnFUluYBF3S20jhWQZPz6eTiwPsvPMvgf7EilDkZ9aTGAyWQUF4oUXh6E8pwb8298NAvuovT8xbUiwfzv3unnnLyxq03x5G6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746020736; c=relaxed/simple;
	bh=n2L1t5IWRBYa8/8es7Og0tMTkDSpN/6cT0TLSHSwjBo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JA8CxIAxsg41M4eyNMJpN9rbc57lTnsR69ip6W7rMSLXfshmuYGvdw12WS/2LMI0LhGT+0CrIvxaTIjtyv9KD+4icmG8jDANKxTtyw+zoUMRTfBl4uvVy3Voc2wUCWHXlHXfzTXLUlkD63LdoZPU2DqLSTpw/KIthsdP3ZP8zVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQ+7daFh; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQ+7daFh"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39123ad8a9fso499106f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 06:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746020733; x=1746625533; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n1CeDhTyPTUczDOgeao5ROqNhlbc75CGsOx1JmDj87w=;
        b=ZQ+7daFhImXfGmC17t1rf3LvLDKS6XGNXGeYHSSv1vHHFBYiVHCAr64mL9n9gWxhjz
         87aPV+/U9pO8/HiuCGqv+03+y1QIXIJhg7PYTufXNYaalpxQtecKTlx2y5wPKnZQZUXj
         wvT1gHiT2f3zaYUuFGrKdsCVo51Ji+pIKQwGhx8bWsuB5SLWt/WVqZhFigIgx09IxFwv
         0A7uFLr2z0WpzjecubQK/evvJvMjjD8lqhOd8/jh5xjAbiSSxvmMHEQ+fL4c1qFdc7ze
         YMa9WP2Hl0fZawQCcgt3VVmTXxj7Ed33+Hda9RNsBchlAKcklaSq3kmquKVzPmggJtkr
         mEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746020733; x=1746625533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n1CeDhTyPTUczDOgeao5ROqNhlbc75CGsOx1JmDj87w=;
        b=jdGL23JYjIIXFgHMdofu28JNCTWEnCMNPfLPE0ROA27lptAHjgIX3fYNFNBqZKXJHX
         u5ak1gd7IiY87B3MicBVwZmdA+SHcjkpaFCzwrlr6Pr0Ere3FeA7pbJWwVGl2dcsEviw
         GH93xrqt4gATXpCqF2+pmDjw2SwmbeOm8LFqfTV4aiAh1B+RNJLrtHsO8misUFUfr9y8
         ULAHEOlBpdr4mkhI8VCPDkrtoaAjZswOmN4Tp0HzgxC3wt6iMIQc6k0oCUP0whICFZiz
         an8Ze/a+PHlSJEq+QJos8sjwI+Jky8ARnL7cmvYEy4pJ2S9L1IyX1d12WesqJ+f9Q36t
         dB2A==
X-Forwarded-Encrypted: i=1; AJvYcCWAQpJzPQghZCn0b0SRkFGHANZN7xLytdWW5kgALok1EFAfSx6dMkUfka7S/CNqZ2MykUyG8TgV+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzIqHHl9+ajtSvAoR7b9IjxI0BGdNT4qgyAKdhYV9QFb9q/lpXH
	v0n6tZwnRquCb5ILRzRCBhIUgMUpTJxnSh3zUJHHM+m9bys72jA=
X-Gm-Gg: ASbGncs57mbA0h7KJOYoObZlLvry5OPzZ60JL8VDJ+NVM4C9PoNl/d/o3SfShtQorcF
	D4EhXXHdnBFC4LhrnLexFf39RQ00XDDzTFKq9JiQwykBHarcar8aR9St9xAmHsUFQQSd0yHotrm
	4o1fip1UBFdF986nBL3n8kPpefRdCnhpgziSExIGeLZ7HguY+qTGI9jYSXqDUgivrcWB0ESfqgC
	hoxloF+0SZBzyQ0jsSzLVgvIsZKUGLhAsMWTGkjiy3LZx+snvr3iUzM0qcvkVX6T0uadScwbsh+
	VblQThkY9zwI0xvUEfTHPhYhU6d6H1Mb9D0g99kYV8uF4F65jyOxQYLU2+YuCUFfZ7br9O2EXLt
	oJ89UqDzss76xddw=
X-Google-Smtp-Source: AGHT+IGZ2P28Ro/E905cdboBOU68u+OBpQlhn+4UWzvmK9UMjkFzcaFaO4/1xXGixA7Jh1ZtK82gow==
X-Received: by 2002:a05:6000:1846:b0:39c:30d8:a44 with SMTP id ffacd0b85a97d-3a08ff5c739mr862882f8f.5.1746020732637;
        Wed, 30 Apr 2025 06:45:32 -0700 (PDT)
Received: from localhost (202.red-88-7-162.staticip.rima-tde.net. [88.7.162.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5c7d1sm16934423f8f.83.2025.04.30.06.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 06:45:32 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/2] multipath-tools: hwtable: remove .pgfailback from QUANTUM/F1
Date: Wed, 30 Apr 2025 15:45:26 +0200
Message-ID: <20250430134528.82361-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Useless without a prio

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8b43c14d..f76d9180 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1349,7 +1349,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "QUANTUM",
 		.product       = "^F1",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
 	/*
-- 
2.49.0

