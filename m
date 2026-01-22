Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F0539CED5
	for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769117387; cv=none; b=bw0iycpDzw7cjIotDG56m2Ap0CDJcyrhA8z3NdSpOaI9n3BpkJieEipq8g7BqJtck4I/SQCN1S/VMGZzIm/btbc99GUgVLo3rmv2ngvBSIQvVsda/PjqgVxUKp32RFTBBTip9XJbP/IIvYGyFfOPQZbz3qYvoHKl/mLizXLxYWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769117387; c=relaxed/simple;
	bh=eaN5PrvS2vXtlR0wucaA4Z2ZGk+jaqkKwOa5jkkXmkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KHtrKYgzN1h5/kEI7sKrJnbIElEq3V+yp0vXxqKQGHHdc4AAuVIYKSlPS35ConDdO4TcoVwtnnBrryU1ER+k0+7XgKYkX81MSJuAFAZj7eZ9ICAh8iNL0HDskJkCTI9teu6wfdv7sqalUvQOMGuX0BFfLQKb+jhg3tOsIwjkDOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYtmbl8S; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYtmbl8S"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee787da37so888105e9.2
        for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 13:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769117380; x=1769722180; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g0+BE2nPu0Rdnvf8M0OPuhFnkPXxsPzsDpqpeP3/VmY=;
        b=AYtmbl8Snh6zcWvUrzeOy+SoQh0ebbnUpLT1yvTauHbXBogiXAzEM3lcZ8lG+4TjrT
         vlCmDIxq/yTrUC+PoWB3mHjorUI3R45s161gpcP/MhAkmRNzfBkNEwHtwqZaRASJRdvY
         TqG2TJgAzDL9n04l7C05UXzpDR+tauUpYbE3jKdVa1Fb4LqBhspHlROwKG6hNCd0Vml3
         eSU9Lu94EILVZ239cluJZHkjKz1C44tgNMW+Ogn5n56vHNg3Iuttbmgi+qLgVBV9hqrC
         AJEVtRgyPYtTN3oBdA+RW9Tl7960aRN/fLjFl8cFCTYrXVenqqaIvsLuRGB5L6IweLUh
         48TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769117380; x=1769722180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0+BE2nPu0Rdnvf8M0OPuhFnkPXxsPzsDpqpeP3/VmY=;
        b=BhFBCn/lRaK3buF3KBezGBxaecD55XIGfmSLJtMuKcD/2mr+nEMKPHkv6uySby0BhU
         Q99/hfytwtByw60zcAK3tBR7a3wR8fsYsdB689BpqG7MFxvLm0Hw2LCz3Bi8PqvUqOty
         oBTz31NLL5W7i4G2k6R34F4GH+E12X4rtLTBWWGq6mStKEsLgzGqQUTEnDLy9LeJR460
         RamNpqi4v2ZF5EMex1NzO7a4sQww/xfdXYxbYcDzrqzjK2JL+F4djjtScYLI9LoyurTn
         InWn8m9sYp/Rj+AKVM2RgAWaFweutsIgbF5G6Do9McV0OPi2FJlhDW8PpWNSR2n78Lpq
         78pA==
X-Forwarded-Encrypted: i=1; AJvYcCWso81F3vkzbmW2mxfP0PkGTd+S0m02ehRUhCVdBiSNYbAsdURdkvOQVb1ambGKr/xJhbonf7WiFg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl4SaukkAdT/oEHEIafH4l272pmOdVxpIXiRrTdQQf6tY8Omyr
	MNFNKuNGcvBN3wLejzV8KeyrYZJr8o9d7lqWatfSeL12TLVKzkzhlUM=
X-Gm-Gg: AZuq6aIlP6IBwhfjJGwevn9mKXdASDMKqIMCwc8KQftHAy3ZljTDP73iPK0e8BbgiVe
	+FElxo032ghWbnd8ltdqYX4+xUt8aMwiML8b6ACkDU2Skg11hXEXgH9heAj25CqmA7SfEqtJv47
	mvId9dvegg0eUA0a803UDY3HvDEGrSVTfYCYTnqZa3ohzr7ufX/58PxzUD5mfsjYh04MWJJhdYJ
	bcda2DTb+BRHj5TOCMPi5681ULHMwNeiLfOn/fPCH7iyCeVl8eP6ErXlYsU55P+f+vHLD86mrxX
	t0eizwuALOI9mzFYQIFCjGbhQlOxHesEyZI9qbrnFVEw9/SvtM6Wa25m9eaOLJ90U/x3/xVL0ce
	2vAVwJLEw/RTGJehMnltIbyckOjRojbsIcvMS38sDLEsv1upwOc0EQTPZdE9TV5lBvzeuf6lyR+
	xQvo5yBP1ehD9xYy+yMUYH9WTlmEOWXNh55yw7hBZ5O02GlqPm7yenrQQz8FtjwH8=
X-Received: by 2002:a05:600c:828f:b0:477:9a4d:b92d with SMTP id 5b1f17b1804b1-4804c9b9df3mr9622555e9.5.1769117380079;
        Thu, 22 Jan 2026 13:29:40 -0800 (PST)
Received: from localhost (19.red-80-39-166.dynamicip.rima-tde.net. [80.39.166.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1f74b15sm1524141f8f.35.2026.01.22.13.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 13:29:39 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add NEC iStorage to hwtable
Date: Thu, 22 Jan 2026 22:29:38 +0100
Message-ID: <20260122212939.321161-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Info from https://marc.info/?l=linux-kernel&m=122123037102604 :

"Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
[...]
Some basic function/performance testings are done with NEC iStorage
(active-active multipath)..."

Added to BLIST in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=12427d99489966185dc12a0b6f725d682a3277ca

Cc: Mike Christie <michael.christie@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 23c54933..4fc245a4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -872,6 +872,13 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		 // iStorage series
+		.vendor        = "NEC",
+		.product       = "iStorage",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Oracle
 	 */
-- 
2.52.0

