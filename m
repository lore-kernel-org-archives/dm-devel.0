Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252EB3624C7
	for <dm-devel@lists.linux.dev>; Mon, 12 Jan 2026 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234572; cv=none; b=UA9A497pcUki1zWEwB1jquPXw/Vr2x3AWJG4GqMzKyAtmyu9AoQbRxw+cEkLVaN2mDortLJy+XBDv/1Z9JO7qANSEmh+P/k922MUHJJasdmxnt2J2DJ6KLHUadrYwdwgmmBaWAfmPWOP6EybTAGmn8rdlQkY1JIvi7INGOvrvIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234572; c=relaxed/simple;
	bh=FhmuqyUJ7+MDhvtBfXWHXbSEvmmu1Y/PbSHNDKDWvgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V6fWLyOIixl5Up05acahbLZBzQP//Ru54XIWvez4AqZVLzDCbed8GwRHUFXXnKCMHXcTApAFF6fZfTi6Zg0i3tTjkWZFvYUHgcVybdtIdxbNUz6UtLKxPNOoQItXZDOhu8kWk4qfD1e7mM2RwGbZSda7zgYgvmdz240o1mLxuEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZDVuTBW; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZDVuTBW"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-432ebea8b4cso137676f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Jan 2026 08:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768234569; x=1768839369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=217ZtzlwG5+URQMym2CUOoeHZSU2yzkevLZM/3LggAQ=;
        b=FZDVuTBWuFEVXM3bwpqpQegK3p98hb7hKJeMMGzOZm2Tjo9MPYgjhdjO/22Hlw8ipu
         aY45hErTEgZVVpsl7Hi0f2k61HvOfNNNW91yIvJHIpl6IDAhuLxm1UYsNDM4nHD5C7kg
         G2gTBfEOQsqsAJFt3Vw7xN5BI9Y+AmWsEqHEkGluAK4x9YjWj2vpaKKjVkuI69eB2yYE
         agMVi2vUL5MWjTMQDpfPMU5O/iLHgDG+JFjDNxqApomikCrmxGArlJET9DNbGhuMNU9q
         OsBuhOIDLGIrAr1V8hbpfmgVk8+2bg1WjLbu9TO5PmelC1EhrDLdkbP43uNB5qY1u8EC
         cJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768234569; x=1768839369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=217ZtzlwG5+URQMym2CUOoeHZSU2yzkevLZM/3LggAQ=;
        b=Dzax15IWf4YTShy8TMIAwurcG7UWbvDxPtaS5opWt3zsX3xjsUfeQvti33sY1oX7G8
         gPFOj8YIXY49GWzKxrtTH8hATd6xUVCnPeePpH1mS9pTXK2kXuS5xc72/X8us2Pt6PbO
         +WVwzo33MppydMJiiFUbpEJgeQKFElGSVGpCxZ2uu0Rwxek2aFygftuu5g6qbWeMMwMQ
         s5uUD0wHlUWQj/XrSEz+lTP0eO4RPnAfr4QY0yu/kMqruXSCm3YYDe3TGuliM4P/gdWH
         PzQHXWH7yqi1vncTE1dkIAZVu4b7asCTQeK3AIkWTYXZrsGYBbsxxxGV0qMhlVNTJZhX
         Mqzw==
X-Forwarded-Encrypted: i=1; AJvYcCVepH8QjabjarU5fDi2OTjB1YWbJc6mcXijfUIM53LbEl2c3/PSbg7P1O7kF2PwDgtHJ6CltO1YuA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5qnAb8cbtwZ480WtG8fecz1i9Ke4GEqYwUt/TwbdwM1/qYBGq
	joJViOySLi9WVuSr3jQ+ORBn93ZMqHnqfaA9uK0WlPJplGAZJYdTFXM=
X-Gm-Gg: AY/fxX41Szj4BUYDKHrS1Yn6PA09S6JKQOB/MIbvjnvSVj1QDRhGpo/rZ1KWZv7YLOo
	7aYbVABjeV0Ee2P9zAkSz1n5lSZjef8oO+LTpLgP2IyRMtlc2+lRseyiGNcr0zlcTK4r0OjG/MO
	GDOUgd+aecQ+GZ6t65ovANeNLUmw2iBKXzaYYzKLzuaMsmsdgfF43TTvPpsoGmDIEybcV/3Blv1
	AHFO7JzlVlldqzb7kXuXt96MQHVV9IrFqPxbjhJdZoZurhqOhgd7BCYVUV94AQHnGY9M6a65wlw
	fOZFL/lIGifkkqw6lqYhO2j7cB2OiwJ6XxJXiUQ01oeM+/40fHf5Oijkh/IT95zeRRmT0RSWllZ
	EyPaQXmePO5CbxICbdwwD+gBaYCBC9afvlcN8uXU6aNv8UH0EKdWxupXXRUxuX67X+ZYxoKH0lF
	hkGtfAX1xv29xh79sv7YgRFekijdHxtEj4xYZZsJ3npdNb/wLnNuqNrU8=
X-Google-Smtp-Source: AGHT+IF0WkM7ol8TvCZQeCXFiK6Z2+8SWQ7ztrJApvGRdCNnlG91bx7I0fcUKg7+JEWPpVYWKTJZyg==
X-Received: by 2002:a05:6000:2c0c:b0:431:66a:cbcb with SMTP id ffacd0b85a97d-432c37c1eddmr12627111f8f.7.1768234569219;
        Mon, 12 Jan 2026 08:16:09 -0800 (PST)
Received: from localhost (194.red-95-127-93.dynamicip.rima-tde.net. [95.127.93.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dade5sm39727073f8f.9.2026.01.12.08.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 08:16:08 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: move SPDX-License-Identifier to the top of the file
Date: Mon, 12 Jan 2026 17:16:06 +0100
Message-ID: <20260112161607.55522-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathcmd/libmpathcmd.version         | 2 +-
 libmpathpersist/libmpathpersist.version | 2 +-
 libmpathutil/libmpathutil.version       | 2 +-
 libmpathutil/strbuf.c                   | 2 +-
 libmpathutil/strbuf.h                   | 2 +-
 libmultipath/libmultipath.version       | 2 +-
 multipathd/multipathc.c                 | 2 +-
 tests/cli.c                             | 3 +--
 tests/devt.c                            | 3 +--
 tests/mapinfo.c                         | 2 +-
 tests/mpathvalid.c                      | 3 +--
 tests/strbuf.c                          | 2 +-
 tests/sysfs.c                           | 2 +-
 tests/vpd.c                             | 2 +-
 14 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
index 81bdb2b7..e672755a 100644
--- a/libmpathcmd/libmpathcmd.version
+++ b/libmpathcmd/libmpathcmd.version
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * libmpathcmd ABI
  *
diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index e486c5cd..28350417 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * libmpathpersist ABI
  *
diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index e0e9ffd7..fe88ca31 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * libmultipath ABI (libmpathutil part)
  *
diff --git a/libmpathutil/strbuf.c b/libmpathutil/strbuf.c
index 491a343a..3ff1413b 100644
--- a/libmpathutil/strbuf.c
+++ b/libmpathutil/strbuf.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2021 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include <inttypes.h>
 #include <stdint.h>
diff --git a/libmpathutil/strbuf.h b/libmpathutil/strbuf.h
index 790dc233..44818431 100644
--- a/libmpathutil/strbuf.h
+++ b/libmpathutil/strbuf.h
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2021 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #ifndef STRBUF_H_INCLUDED
 #define STRBUF_H_INCLUDED
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 3eee67a8..158e7c50 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * libmultipath ABI
  *
diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
index 38f2d6a3..cb3d6f87 100644
--- a/multipathd/multipathc.c
+++ b/multipathd/multipathc.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (c) 2022 SUSE LLC
- * SPDX-License-Identifier: GPL-3.0-or-later
  */
 #include <string.h>
 #include <stdio.h>
diff --git a/tests/cli.c b/tests/cli.c
index f008d26b..fbcca095 100644
--- a/tests/cli.c
+++ b/tests/cli.c
@@ -1,7 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 Martin Wilck, SUSE
- *
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include <stdbool.h>
 #include <stdarg.h>
diff --git a/tests/devt.c b/tests/devt.c
index 3b322df9..711947cb 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -1,7 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 Martin Wilck, SUSE
- *
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include <stdbool.h>
 #include <stdarg.h>
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index d8461b48..12540f9f 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2024 Martin Wilck, SUSE
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 /*
diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
index 1b060fe4..0a70c614 100644
--- a/tests/mpathvalid.c
+++ b/tests/mpathvalid.c
@@ -1,7 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 Benjamin Marzinski, Red Hat
- *
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include <stdbool.h>
 #include <stdarg.h>
diff --git a/tests/strbuf.c b/tests/strbuf.c
index 06fa71c4..8d0beb80 100644
--- a/tests/strbuf.c
+++ b/tests/strbuf.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2021 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-only
  */
 
 #define _GNU_SOURCE
diff --git a/tests/sysfs.c b/tests/sysfs.c
index 5f029427..a3c0a7f7 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2021 SUSE LLC
- * SPDX-License-Identifier: GPL-2.0-only
  */
 
 #define _GNU_SOURCE
diff --git a/tests/vpd.c b/tests/vpd.c
index 043b6aa7..c0da3769 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+// SPDX-License-Identifier: GPL-2.0-or-later
 /* Copyright (c) 2019 Martin Wilck, SUSE Linux GmbH, Nuremberg */
 
 #define _GNU_SOURCE
-- 
2.52.0

