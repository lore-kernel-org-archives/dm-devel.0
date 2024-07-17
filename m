Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6FE1442F1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 09:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721209873; cv=none; b=c3mOqMmSU4vjRrvsQE1VZdgne082MIL3gH8LNfI+n4jX0P77zCTUS7sUVNxtVllOTvS6RMeXeM6m/eCPLkSsp5Q22PQxNHglKnJgWJB8KFlHtKNfa6JnNuLWBo/+ce1/pfdX9RYRyFi1DXkQDAW9lIq8LmMOudWUHX93Tm4KTwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721209873; c=relaxed/simple;
	bh=wDmBWWHWpRtCoqfyGl5mnnnCIBW2Khe5/d3tCAAshbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dj7Ih+tfqK3Su9hQds3VwM3NStUmYXhGQFZ5goOsJAvtPH7tl+fz3g+wEl/SU8kenw5DfzfKB6GjCJaaKUQR/rtZuobnQfRj73+Roz2jAD8NUX7MAWGa2oxz/YBZC8ZOdtmpcVO0hh4QB1TqEScQOk0p7I9XcXbU5e+9j2Phrgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGGs54FI; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGGs54FI"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3683f56b9bdso89640f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 02:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721209870; x=1721814670; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XaLnT5piuppHRF9Zzn3tfo5Av5SYefwaVjIbf446x/g=;
        b=jGGs54FIK8goxzNUztqFX1ciPhFwrYWY1/0AtY/XgwCNmUh9s6xRCzDvuiomFhU+To
         p8kmbrFfqLx6wDbuCt3/KJhk1ar1rFhlKSUip88Fz4Vs/9RQQttZgIEsJzOjWT999AW3
         JbK7ncSAwRCjKOdvwzmvWXImiOqENEyZAtjpURjHiBUqYi3OEY5yVJ4n5QGMsqm8QjTn
         sinhV26gpA6G4KIBs3q5f01Ntv3jxtnQfxlHCTBc1XjyiL5nR53YdWIKNZWOVV8EvGBR
         1kk+xLn4bglxzKy9KblPmKaa9pM3Xkagp2MVJnXQX/zU5qucLM6BrbFSvT4DyRakNNBj
         qx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721209870; x=1721814670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XaLnT5piuppHRF9Zzn3tfo5Av5SYefwaVjIbf446x/g=;
        b=e1GMAo7R1OP1m167bmmSyxJn7UlRTlTRcaDYkPhEHplVLidGJupX6PJR7CAQ8SuFLO
         DnEXRsse8HzWlc2R+5RUfGAlC6fOqE0VfyOYr5+x9aivnlhOBjNuXwjFDS5k1fsOYnSn
         Fglh9M3gJWbCUwpOl0bQHdvYjEPwMUdfNESs7sw9nT75z4B9gR2eE874Z5KzhmLaQN4H
         Deapy2+2mFzboTWPxJG9flqhlEXSzMzQ9cEClYC2kX3t/LUbr9oiNyLNk3GUmaeoQh8U
         QGjlhjPxUmL2F2eVGs64akhp2GcXYAL8P0wz/L7ZbIviZf49DDZUS3LsFrzInJXhoy7I
         OGwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0+oeeuJqaqWE8L6uFAPxy+njAoL5A7TC2FLpF6FPyy2DX2UMw2LXibeW/2HgqxlmkhPpp06vZJ3iURhxRirM1bcItGhgCavU=
X-Gm-Message-State: AOJu0Yz7gAMbxwexJCEdyoC7zopcrTGoZEdpu9OXGECtzVA1xxE/Ie70
	tEakvD0B99ff/c+OchFRi2D1k0x40kUL8pELISV02LeBrkxSOMU=
X-Google-Smtp-Source: AGHT+IHLzbQasidIzoAQc8WLYUhS++Oviu+moxKYNjGRwJeGeEV6i9k5s+4IGysDhuRu0NfqWiFozg==
X-Received: by 2002:adf:f70e:0:b0:368:3b1f:fe40 with SMTP id ffacd0b85a97d-3683b1ffedfmr418346f8f.20.1721209869858;
        Wed, 17 Jul 2024 02:51:09 -0700 (PDT)
Received: from localhost (14.red-81-44-167.dynamicip.rima-tde.net. [81.44.167.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5e983e7sm162774415e9.23.2024.07.17.02.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 02:51:09 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: remove duplicate headers
Date: Wed, 17 Jul 2024 11:51:07 +0200
Message-ID: <20240717095108.120782-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Minimal cleaning done with scripts/checkincludes.pl

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
A deeper cleanup should be done with iwyu:
https://include-what-you-use.org
---
 libmpathutil/msort.c      | 1 -
 multipathd/cli_handlers.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libmpathutil/msort.c b/libmpathutil/msort.c
index 2963486e..50f799d9 100644
--- a/libmpathutil/msort.c
+++ b/libmpathutil/msort.c
@@ -21,7 +21,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <string.h>
 #include <errno.h>
 #include "msort.h"
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0106213e..7eb76337 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -31,7 +31,6 @@
 #include "foreign.h"
 #include "strbuf.h"
 #include "cli_handlers.h"
-#include "devmapper.h"
 
 static struct path *
 find_path_by_str(const struct _vector *pathvec, const char *str,
-- 
2.45.2

