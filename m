Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02E1334692
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403340; cv=none; b=BMdU5eadB0R4+eCvtVmBqS2z1dGcaw6l7lPSZbps0V1g7+SociuSWKtj2e+sMj8i8en58KD3yDrsbmZxoAi1WirVcZZoBtFkJInYdHu8mxfCCFlKkk8gsAq4hD4QhSapnGgtg4o6wHXs5YWMhr/aXxgXTTcMLtuem/yHHeMvnQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403340; c=relaxed/simple;
	bh=YtanMaQ4rm7BjjDfkx0yQ93U9dw8tgWG+G0CeFJjxeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1a53Agam3Qspo9SqepRgmApVsj6lRjaE4y6OvNPVibQETqebp8jzeNhGA1caPZbEtjrTLGTm/DCLw+N5dd6bm648ioLDQmzuKxDuiZQJXooGohfSTS8/xbkXO5gDky/Ks7VB7RkBkbxhfnEy5qDEC7B/+/yAwT1aJ5KyUO4Pdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CQCnqN8o; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CQCnqN8o"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-461edb387ddso2654829f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782403337; x=1783008137; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAAOyA/N1h+MP2441BI5mGMJ5MtndOIYLscb4uee+DY=;
        b=CQCnqN8owtnpsYJjLGpYsE+M6GL3JDoT0kpvH7aPh0At2eHuNtBHTEOiEFCNHddE6d
         IkRP66LZX/tuYBCVZ+v2Lz+Ub15lK87Cpaa1cl4rBJsQ6rkr6sejKT5rnf5njcQVVS+C
         mq8AlYkcfzes2K9KLjEbkkxEcYFKKA1k+xex9uHm7e3wHjLABijB+wPGTluzLS/aciXP
         /30DoZfp/jzjmf/SThzTuHYtQvuvC1N3Y4/QDIEMG83fflWvpCZZckN2FRdcCp119a/i
         0rSk3CsXrtocnmuEYhndx7UNuLfXLQoqtIG3tFuH1UinpU7Z83ZefTVUOk5b7wAZFl/T
         VdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403337; x=1783008137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OAAOyA/N1h+MP2441BI5mGMJ5MtndOIYLscb4uee+DY=;
        b=jhzQwiuBbIAEzGdu6HQ4DlKxZHMtaGoKVECYW8VRoXJRcHxKeSCjD0qe10XmX+MApF
         d/xvggWzUlSTQKIR4YjSfafVEcwdFgpsuOceZgYkOrdSAQ+xA4V9QlLLze74gHsrE2n4
         yLWLHEnKQ3Hq+zhZLBVAvP63stiODsYOaM6u4HjTlG7ayb84uwTpj9cENxMuoXZSCEvj
         dfV1LspgxUPoAF2lkcDWEkU2kWkEVHa8g8Fvl+DWNh5ESqT9Mj6KklgUKQIj1h4aJ8LK
         dmXaGAYQlMfzmzdvXldiqgFZB5JI0axJqN1U72VwMlw+Hgwpdh00n0bazLqrqUxdmier
         AudA==
X-Gm-Message-State: AOJu0YyY3eb74jzbhAb0I6JvFGacx6+cWD9zklk+hCRsy/omEI8jrp/Y
	X0KOMokUWgqEICC6w45AiJK8nmaAZkQ3IKsOGzQevZ2AB3mYgoMS2C/m8W8Io/3F4Y0=
X-Gm-Gg: AfdE7cnXNyqGzNRlunLSm9gd8IZK3Tvs1cgF+FA955AWI/r9YF1QDS5ka7QWwwJZGSw
	onzX0GK77tc0r4g3eKzKEwn4rVWl//xxVAcUWGTiSaX3QTGxQvKfAh3dwYZSBqFSvf44TFt9mbO
	m+1B53fUeoSPgjooZh192qMNGQMCL0S+uyqBFKF10pjDLak7B0AA68Tbl1PDmeoJriAPHWdMFZE
	QeXujKUTlP42yTdSGUhmu0wc0pIGFe3E+HM3jwYisjVKnfvUNvADpkHpUl+TV9n37p5iSicBL7d
	Gpl8oztA48RgsjXtA1PVHErGR6otvRJbV6tCaoRDU9j2QBh5qVIKVPuyJI+ztw5+ip5paCRFxDT
	nAmURAtscxpWA64uNtG9Au1SjNkaT7xQqpRzhaWR34VFaiMRbZC6XrYHqnoB3JJfG+pmI4WI+Ic
	ocE6ZKa8QNF4JAMTNmTWXiXGrbqKm28iPECFf6Ke33LA2F1dqWCOxiBy5fbIgDi7p4xN6P/EZQ5
	ZI=
X-Received: by 2002:a5d:64e4:0:b0:468:b71a:6efe with SMTP id ffacd0b85a97d-46dbf117b6fmr4956402f8f.6.1782403336008;
        Thu, 25 Jun 2026 09:02:16 -0700 (PDT)
Received: from localhost (p200300de374611012220024a9e5877d9.dip0.t-ipconnect.de. [2003:de:3746:1101:2220:24a:9e58:77d9])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46dcbac0c9dsm6349524f8f.19.2026.06.25.09.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 09:02:15 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] multipath-tools tests: add wrapper for fstat() and fstat64()
Date: Thu, 25 Jun 2026 18:01:57 +0200
Message-ID: <20260625160200.3318088-2-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625160200.3318088-1-mwilck@suse.com>
References: <20260625160200.3318088-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some Debian distributions, fstat() and fstat64() are wrappers around
__fxstat() and __fxstat64(), respectively. These functions take an extra
argument. Create macros to make sure we substitute the correct functions
with wrappers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/wrap64.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tests/wrap64.h b/tests/wrap64.h
index fe985a7..3ea4b0a 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 /* The following include is required for LIBAIO_REDIRECT */
 #include <libaio.h>
+#include <sys/stat.h>
 #include "util.h"
 
 /*
@@ -87,4 +88,29 @@
  * (see https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html).
  */
 #define wrap_will_return(x, y) will_return(x, y)
+
+/*
+ * On some glibc versions on older Debian distros (up to bullseye), fstat()
+ * is a wrapper around __fxstat(), which takes an additional argument.
+ * Also, MUSL libc redirects fstat to __fstat_time64 on some architectures.
+ */
+#if defined(__GLIBC__) && defined(_STAT_VER)
+#define WRAP_FSTAT_NAME WRAP_NAME(__fxstat)
+#define WRAP_FSTAT_FUNC(v, fd, buf) WRAP_FSTAT(v, fd, buf)
+#define REAL_FSTAT_FUNC(v, fd, buf) REAL_FSTAT(v, fd, buf)
+#else
+#if !defined(__GLIBC__) && defined(_REDIR_TIME64) && _REDIR_TIME64
+#define WRAP_FSTAT_NAME WRAP_NAME(__fstat_time64)
+#elif defined(__GLIBC__) && __GLIBC_PREREQ(2, 34) && __BITS_PER_LONG == 32 && \
+	defined(_TIME_BITS) && _TIME_BITS == 64
+#define WRAP_FSTAT_NAME WRAP_NAME(__fstat64_time)
+#else
+#define WRAP_FSTAT_NAME WRAP_NAME(fstat)
+#endif
+#define WRAP_FSTAT_FUNC(v, fd, buf) WRAP_FSTAT(fd, buf)
+#define REAL_FSTAT_FUNC(v, fd, buf) REAL_FSTAT(fd, buf)
+#endif
+#define WRAP_FSTAT CONCAT2(__wrap_, WRAP_FSTAT_NAME)
+#define REAL_FSTAT CONCAT2(__real_, WRAP_FSTAT_NAME)
+
 #endif
-- 
2.54.0

