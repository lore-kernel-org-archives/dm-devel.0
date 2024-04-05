Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F136F
	for <dm-devel@lists.linux.dev>; Fri,  5 Apr 2024 00:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712276128; cv=none; b=qP9sCiSRbf60dVKqPVwbDc6s89HLQQH8gSw5c/+FnMCT/4/hNYoM3Au1lIkQX0gnk3PN9pk2bDIGEWmBRWU06d4oGvoJrgT27mu3/bMXe9339nxi2/ks62FgLzYS9A5yJvcN7jBJkz4+XMbcCizEy7j0qylvwwMdHJZsAS2w57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712276128; c=relaxed/simple;
	bh=oKxUGUr69uDkqC0F+B1wlYaYS+NlTC7KrTuT8fO7kZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RiHV+KbIYUFW/821Yg4GDfr8uj9I8BhnW4hwDeS9h64oB9KmUH76MoKiXXyGCEwuLwGMHp4GEXxW7ZO/ZRCDMPUMkkWgGB5GWY9bwyv/NvtKNi1gHkENY3x9aRM6cLzx7LDKYa4JwCkYMxjGCEdGCBFccqMUzTXuh6mHgbg2gvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com; spf=pass smtp.mailfrom=efficientek.com; dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b=ZUSXR3we; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficientek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b="ZUSXR3we"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-430acf667afso8988741cf.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 17:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=efficientek-com.20230601.gappssmtp.com; s=20230601; t=1712276125; x=1712880925; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=98Q0hr02Lsxhr/dnDkWzZetnWAt0AXgi5ncXpWc+XYE=;
        b=ZUSXR3weLH+uzYbUguUybpfBG9F4LsMMmbV/V282/GPnFCunuk2UE7e45p/C6Bmdhx
         QB6Nqi9a7+C63rqCYLsf+6mMaUhmsJj1Hbm2URRb1qhydlDrlFw5R1e/rld7LBqZMVoG
         kw5ThWwzGv4RCfquyA5Wc8+1XQFozHUXgO8rUFS+wwGn5NKLUyeB1gfIfcDPElm4QcmN
         AdrkfAdnbSu4yfGqxCgzInhPE8538N+RjF1w2MdiRaP0VWApNAJa+tDo+ZD49c6C7hOj
         /iB6lpH2LKxT50HjxRU9LbFUwl7F5ZEnUz6m5Fn85V4bmWMKvFw2aTszRUMdGQVMibVE
         6PTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712276125; x=1712880925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=98Q0hr02Lsxhr/dnDkWzZetnWAt0AXgi5ncXpWc+XYE=;
        b=HGLxBFMufFkBn8SsczBXov/0h1ucz2WFtGAIcc0gGGGa/ByY+J8HMMisYAaucTqTOH
         IC6046KZYk2TGfahvFQ5bprJ5UhX5gi1GTkIb7yGY+6PuBgXh/Qi9+yMSTwVCfwK6y7e
         AnP+rzc3zQhRmTrIdevgZBzsKGOWC09nNXl/qdX6vklr9WH+cdAU3YTXfBOcAI1mTl1h
         kCFNvwkqwNYyf2ANJ6MQqgqizNgzoDexbJauclGHHk94jXhU7+aYO13pjWm9wH/0rAtR
         6pyYkvDER3Xeb8NePG+NATmjLUBBN/FV5uc7z0tltUW9t/nSBraMojOXsVW7lvgXysWo
         Z6Ng==
X-Gm-Message-State: AOJu0Yy6fR0WWnHa7J5bTvn0AxniGN2FbmMpxF8WFepqIo4JE/CBkBdZ
	PximKy61vQJsSeXVbWjUhydDfOY8Ufp+PXdJ5Hr1mqp3e2e3OLaD12rawKRuBVAUHhHZWyLkikk
	=
X-Google-Smtp-Source: AGHT+IGgTKA9lQX8skTzqvCq3XO7UU/sH2PfE363n5yozc0EYMHQYAsQPlVz8iRJ7SDrgMxsivft1w==
X-Received: by 2002:ac8:5dd4:0:b0:434:3e7c:ff29 with SMTP id e20-20020ac85dd4000000b004343e7cff29mr1231651qtx.8.1712276124722;
        Thu, 04 Apr 2024 17:15:24 -0700 (PDT)
Received: from localhost.localdomain ([199.58.83.10])
        by smtp.gmail.com with ESMTPSA id ca19-20020a05622a1f1300b0042f3fa77602sm224263qtb.2.2024.04.04.17.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 17:15:24 -0700 (PDT)
From: Glenn Washburn <development@efficientek.com>
To: DM-DEVEL ML <dm-devel@lists.linux.dev>
Cc: Glenn Washburn <development@efficientek.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH] README.md: Add libmount to list of build prerequisites
Date: Thu,  4 Apr 2024 19:14:46 -0500
Message-Id: <20240405001446.442390-1-development@efficientek.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Debian based systems the libmount development package (ie. libmount-dev)
is required to build. Add it to the list in the README.md.

Signed-off-by: Glenn Washburn <development@efficientek.com>
---
 README.md | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/README.md b/README.md
index d4f35f57c61f..898ea56e9bbd 100644
--- a/README.md
+++ b/README.md
@@ -45,10 +45,10 @@ Select a release-tag and then click on "zip" or "tar.gz".
 Building multipath-tools
 ========================
 
-Prerequisites: development packages of for `libdevmapper`, `libaio`, `libudev`,
-`libjson-c`, `liburcu`, and `libsystemd`. If commandline editing is enabled
-(see below), the development package for either `libedit` or `libreadline` is
-required as well.
+Prerequisites: development packages of for `libdevmapper`, `libmount`, `libaio`,
+`libudev`, `libjson-c`, `liburcu`, and `libsystemd`. If commandline editing is
+enabled (see below), the development package for either `libedit` or
+`libreadline` is required as well.
 
 Then, build and install multipath-tools with:
 
-- 
2.34.1

