Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2222638E5CF
	for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769116768; cv=none; b=urC6hTtp7vNg/RVLr81kuHfNEp/aYxjwPKVEmUQcjZaNT0lRw/MuWAuUGIe5/2Z/qTNbg68zZx2Xbk6CUFqEK1r/x7lOY8cgrXSurXXq29xyeBfCTuQebsnbDV3DE6U0URygql5InEbIOXp6PAXB5MBQ2pgflB246RFfVD9yJo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769116768; c=relaxed/simple;
	bh=gHW//XaTp0EzQcOWyZ4eSqd7VV/8yHa8g6h2sYkP1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ryGohiX5Hm3q0EGdwzUSrw+JwLGmpo+LEg/EOpueExvCjYLDkFnGVb0LyHWJMcuT7M7PwoQ81Uoq4OIrlOCnLhEVCt12xts3e8I717xFFZ4E0w+4DtltevB6jIqOT+wBhQR+PuBpdInZ4b6cCPnDEbRlKUEbCUnrsxQqNFih5oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRGthoY0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRGthoY0"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-435960cf63bso179534f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 13:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769116760; x=1769721560; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cHttPS/6RPgSBTKFypl7xG8SnwrgcWVSJqsNpqvCOVw=;
        b=BRGthoY0fLYe/4YM6jvYpmUQyd5rNc4ok5FLZs4gf9fuhyxxIqTav0la9CKDgwA4bc
         BsFYKMo2P9ArpjeVuMPJFydEctCtJ0/sVq2JRZ5lniA9HgfIM+ydfZvnHrEDPKlTezjS
         fKy9zKxH9x+cp22tZJus+SEqpeb7ybX/GF+5/91Aek8xYu2+wNBBfYN/CUM2pkNhHaFK
         AzBFUc3/3ftaGMOzTBIrgKA6NIWC1lWe7kSF1xb8/mwlRmgy6RgHYMDjsKPkoAl8ZnDb
         Dp92rg9k7+pIFW7pELPlYzaATcdIiI50EItyrWEufN1T+WVRLwlALYGHOX9gifZp/bjl
         VwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769116760; x=1769721560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHttPS/6RPgSBTKFypl7xG8SnwrgcWVSJqsNpqvCOVw=;
        b=NcQI+iV0jDXbfdmbWDEnzPNr3Rfo0KCLsSxLNs+ZIWyQjDZHtWpMzLMWqaV2rgRhIb
         5+ZdZoeaG/u/9c/bZYAAVHhu2qSyPKWLBcZMEHmW4cXJq9jl78PAwW01UWITeEKKn6N7
         qFqIXUXjewypeY8B/R0vI8kQNc2ETAelNKATHEMU2DbPzMe1ytY1i2EJmWFfZPwmlSPB
         yfOTmBk50AlnKN6NLuNnNPv/bhJfN2PSUUnFSvD/Qcvm+Z1DuBdC3r4YXDGhP0icE/5Y
         lWV4fhxjBhhH6Wxh7KzQRXJGPu+u20+jI5S+5dT/cHMmrdv8+Z6Ty3dzKK+Re4C+w/tz
         KfBw==
X-Forwarded-Encrypted: i=1; AJvYcCW5RVOHe/Vl9civ7DU15h4OwBfbAlNQJu5UgH8w5iSf7m2l3quldUICcb585Pgr4NwBwcc6l/szkw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywdbma9HZo54rfnYFZ93RRrteTrpuNscgjoAbIJoGn2xH/Iles7
	5Rrk1D0laXjVUh/wTsVaNjbEehjY6DQ2GynjRPxUNGUThspAFl65HYg=
X-Gm-Gg: AZuq6aK0PXF8xk2Ag4dkGdSFD2zH4UIlVBFPU1sOcJ5L0EoO1t5UvPqGlYfYdnZXFJd
	V0C1joNC1i+z9xDHjkQbJY+b1KyGMZX/5cpAxXocWPVoAvRy/wFAuewfkP8targayqJQletpST5
	e8tl78Xomkz5KOt9Jjv7TIKcLBAy6fYewuq52QluZpV+/FMkZpZahL91+Qx0obVfI9FlN4JAyaH
	0g6jHm3CuHzMrGz2d0YeSx2s3pGqq3D32igIYivAUSYFllmY/P0AS5tn2QLrkxzHwrqpnA8iOj1
	arCNO5gSyHUShLK3rVT31s6moVEi0F1/I87eV8k6NZuborOrWJerPFLqL8c0RGlSyKVDrFHSh4q
	NdotoqqZWA0GWbG5pTfaE7IwqBZehv8U5lL6nOOGmrpUbn99mRIp2s2k6gDNd1y6y1A5fg7BDco
	5JdbEXrVnYzpULUOeh6i33tji/bwxc+I11W4itiCmkknYGoZ0RXTTf
X-Received: by 2002:a5d:5f84:0:b0:435:9b3d:d955 with SMTP id ffacd0b85a97d-435b173e9c3mr840052f8f.4.1769116759933;
        Thu, 22 Jan 2026 13:19:19 -0800 (PST)
Received: from localhost (19.red-80-39-166.dynamicip.rima-tde.net. [80.39.166.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c02f71sm1651641f8f.6.2026.01.22.13.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 13:19:19 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add FUJITSU ETERNUS VX710/VX740 to hwtable
Date: Thu, 22 Jan 2026 22:19:17 +0100
Message-ID: <20260122211918.317844-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Config on pag. #8: https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/p3am-3912.pdf
PR: https://pr.fujitsu.com/jp/news/2012/05/9-2.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 23c54933..c2192524 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -471,6 +471,13 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		// ETERNUS VX700 series
+		.vendor        = "FUJITSU",
+		.product       = "ETERNUS_VX700",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 120,
+	},
 	/*
 	 * Hitachi Vantara
 	 *
-- 
2.52.0

