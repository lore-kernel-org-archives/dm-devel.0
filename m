Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B4237712
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741202; cv=none; b=oTKM/FEEFXeIs19+KanAK2Vpj8Uhn/L9waNWOpLATwwLpXlnQ6SItnEic2cN86qc3As1H1bl/QGrFWea9ZLoGJU5y6AwUCqjH/5PZr6SfsC/3pNoYkE5QKpJ2VfglT1zUWt2qg7/itTkljAIne0zG/2YKpOAGEUkeqd/JnKs3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741202; c=relaxed/simple;
	bh=BsHeep2hbO8/IGYveSJ5DN0n8fIDEHXMfAbYaO4jAWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CikK4T9hjZexIBAQhK/ORW/gy0WOLXUMT2Y6aRS7cwqgNXvVdrwhyslvvmXc98KmTUZSozYAWtDLziPpG7Z9iY9hWlq5VltjaFotH1bx9yMt3HGNk76PLfhDs7tgfjwncHepWtgVt/GtTgdDbs2W7cn5+DPVy2Z908ruE0vCZJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VIniv2ly; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VIniv2ly"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ddcfda697cso200193b3a.2
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 14:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1706741198; x=1707345998; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fuu2FvAUa6aOiw2cmLsoW7+qgXEqKrk1an1C0sJdQYE=;
        b=VIniv2lyeXVNr1kZDgF/mi4Al6sZ46qHqwopt6ub7Qh/yTeBO6rUYjtyuCCFWWFL6L
         sF4h+GHDxb+n0eknuIiWn4H0yX72QsN0fFL3IF3d8J3KaSdHMlR8kQbca8yCk0aC4hDU
         GQ0SH77yBK3dQnMSSEDZzG1RELzxLJuq6LEy7ayyQR1lFA5cFYipc+s2gSDVDkeJjxDF
         +FPB4lSEvrEnm9eUxvHtetrECVy2g1PgQg95IlpSPz510IMccanrvZVp+VgwDHiJUagC
         zV/iqcLbjS+Gqd8xKygUFcHvsOeZzgqJ2Nmc3Ggw1hVPc3nW1kmZvK+vehRtr3FPFUYQ
         z0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706741198; x=1707345998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuu2FvAUa6aOiw2cmLsoW7+qgXEqKrk1an1C0sJdQYE=;
        b=SsXUQ+kPZAf99126pLNGNGLOAvGeYmqtDszg2o6Zfod+g+T3HfD0EUKBnnGf0Uf/WF
         ilmd9brNn9XO/SzgUJu7x/MtpojmVMLnzEzDl9sAeEmpgG/Q9ZDSFFYXmgrvlzIa+sjD
         5ZgQln0CvU7zXzTv+b8pvuG8npjv1O7XGgyEnaDfxFkOMRFm5p3hhPl+sIMgegwc8aYN
         NS6fCvkGrs3xvFP8trcsY6wnGUFVvKYHu7uXHH7ojzxgiq0SWNj6ODHGdhXL4nawqZ0U
         e6kmhMrNFvCP0WxOEpz+QQMZDHXHMXH3qUk4tjDBaCItavmax3DHlBZNRpVFCYS3n436
         o8bw==
X-Gm-Message-State: AOJu0Yx8MV1ce6Fd03R0ADx1nF1t0ow04JXpU/gOTOnf1XnoIBhZpQmV
	aoO07dcQ9P8g5GwDMK03a2O0aK8e17DzWY+YmW9jChwMP10pTvLOIj3H1pqkIfQyOZdeO9qp0R1
	sqHX2ZceX72KeiIIDSXXCGGXUscFyMeMjkwM4H1Ty4mUolIDSUQlyd5BBIC+9uuKUun28kTtQDI
	xZsM6kmJvOpL4tc3mzQI2AC8JlABDFe9W8G652WCEt
X-Google-Smtp-Source: AGHT+IH/izIukTDrmtCMNr/wR2mfEBXxwQUwXIhRVc0A8FMmzW+lIrAgaYMkIJgXGErHZk72VkG53Q==
X-Received: by 2002:a05:6a20:6608:b0:19c:7f7c:25f4 with SMTP id n8-20020a056a20660800b0019c7f7c25f4mr2822644pzh.2.1706741198400;
        Wed, 31 Jan 2024 14:46:38 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU3Sp6hheXHBgz48u/Vz+6eGCLhqPN/6NPHEQ4Yo0N/am86vLYsEZBvMglraucfIbv6JRAKcoiRuOc2z1SXaOZiYLCy2V4=
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id sw5-20020a17090b2c8500b00295c8bc35e1sm2064072pjb.38.2024.01.31.14.46.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 31 Jan 2024 14:46:38 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mwilck@suse.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH] libmultipath: stop PURE FlashArray from detecting priority
Date: Wed, 31 Jan 2024 14:45:56 -0800
Message-ID: <20240131224556.84931-1-brian@purestorage.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If 'detect_prio' is set to 'yes', the 'sysfs' prioritizer will be used
instead of the 'alua' prioritizer. The 'sysfs' prioritizer can leave
paths in the Active/Non-optimized ALUA state after a successful
upgrade of a PURE FlashArray. Explicitly use the 'alua' prioritizer
instead for PURE FlashArray rather than the default of 'detect_prio'
which is 'yes'.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ae6aac79..715f0fd6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1106,6 +1106,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.hwhandler     = "1 alua",
 		.prio_name     = PRIO_ALUA,
+		.detect_prio   = DETECT_PRIO_OFF,
 		.fast_io_fail  = 10,
 		.max_sectors_kb = 4096,
 	},
-- 
2.43.0

