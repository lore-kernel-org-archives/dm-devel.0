Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0052F92
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914396; cv=none; b=V0pavAN/Ri+01NDKSzfCvW4EVqybcyHPmTRl4Y8qRKCcX5ehQpeAsODKaU3GNADf5WUDmYiI4P6VqkVAVunZ92WQfd2oTwVBzaGJ+b8eAvfMbNN34Nh/CZhx58cw2d+IGhGaJTLOQaAoqwNdYJFZu4rn9z+0x0ZPWqpKwpG0YDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914396; c=relaxed/simple;
	bh=bt3jbswYkX34aLO5bPUDCaaWao6giXMZI8x0lKNGkW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KU9zqgDRy3qFeXp2YRPZ9Sw8UuKvVvDvj6qWSi1FN+5AUlHZuw9e0WEPm+FiXvfNKez8OI1SoU8PLJI4W6ObBUwAZ07HWA9pA8uiE0gDiIBFYwLsaS1tuMEiuxsysvKfaSrXyLpgqras3/OBtSVIwK4lkhScJzvasV4ZFjNpfzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=afEguYw0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="afEguYw0"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41550858cabso5321835e9.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 02:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712914392; x=1713519192; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5DxPbFI+1Moi/KA2zrqLGywzurkGgyQuZC2iO6QIa0I=;
        b=afEguYw0pEiILQUmGvCNrJROrMGIDdBEdxok7F0x5T4/evUDBO052MCIlpUfH/CQZj
         ZfEpHmAHVnVV3bFTprFcn5LouN47bCQQSg9Rk67keOPwgTiQw+A8lscvmickJynuTBf3
         M3RelL/n+OBRlrTmwDOiz3mwtlToZT4w8ycPjGOANxbj9LxNg2TB+5Lb5gr/k5z0rVva
         Q9defz/Ni1qeieEOD96097XtTZPMgbA5UbhbU8RfPqGis4C8l1FEwwqA2EmecSzht6Or
         Eei5/Sm7Y/5SJ10LGDZpVP6NKxDiNIYPGsFvv9fqhjSRng1S1LDD0pyhbQBluvboL56+
         uLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712914392; x=1713519192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5DxPbFI+1Moi/KA2zrqLGywzurkGgyQuZC2iO6QIa0I=;
        b=f+bPRYTRTz+ktL3wAlV4JmqF5u0MecvKHAeWbFDzptiwh3chTZoSbgDY90VBKp1Ozh
         pZQjK8CmDOuAUzPBimcWgpkp6OFbu2LvOTr8hxcm9rhn+/9u5WBxJvzzW8+PLXx9JzHW
         WnfbICGb4DdxKu8JRWBrCdoilLQf1/6tKsgZKVcUgGheeC3IM7Iz6TgcPjxGC9tWHq8r
         g00KeRX/N5BSEohIBKBxRYrJjiysd6+VWhrY9hCbUCJRAmQxkzH6q54jPzYp4pcgb+aC
         3ZUBcMs3LCjRwRHB3sdJDlKgInmJaAWkvBnke63Wsf8yTTSHkKcvXUBI6pTrNcVixPH9
         UDKQ==
X-Gm-Message-State: AOJu0YxOc8lmAWCRW7NbXLPr6QJyunPppH72gUtAeNBE6hSd6bmbfkIs
	juisnK2eIalcmTX9H2v0XhGoSPiG2Kl/XMWLuhcD8QwpvcP7nq6Ho8ciNQlSxIQ=
X-Google-Smtp-Source: AGHT+IHQjp2IjzoGNOtIcXtOwtqCpFD0vzaxhBqy5ABpkM8c/Gi1AtoUsIKsfppUp4v9sAmsbY3XKw==
X-Received: by 2002:a05:600c:198b:b0:414:8e02:e435 with SMTP id t11-20020a05600c198b00b004148e02e435mr1610685wmq.3.1712914392310;
        Fri, 12 Apr 2024 02:33:12 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id g13-20020a05600c4ecd00b004148d7b889asm8272675wmq.8.2024.04.12.02.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 02:33:12 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/2] multipath-tools: CI fixes for glibc symbol substitutions
Date: Fri, 12 Apr 2024 11:32:56 +0200
Message-ID: <20240412093258.20037-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Or cmocka-based CI relies on the ability to wrap functions calls, both
our own code and from and system libraries, with the --Wl,--wrap linker
flags. This works only if the function name in the function call generated
by the compliler is known. glibc has introduced function substitutions
for multiple system calls that break this assumption and thus break our CI.
For example, a C call to open() may be translated into a "call __open64_2"
assembly instruction.

We have first seen this with 7b217f8 ("multipath-tools: Makefile.inc:
set _FILE_OFFSET_BITS=64"), but also happens independently of the
type size macros. The 2nd patch in this series works around a
compiler-dependent substitution.

This has an unfortunate effect on our CI code, which is becoming
increasingly hard to understand, with lots of #if's with workarounds
combinations of library versions, compilers, and compile time settings.

CI failures have lately been caused much more frequently by this sort
of failure than by actual bugs in our own code, which is causing significant
maintenance effort.

I am not sure how to deal with this in the long term. I don't see a general
solution, although it's unlikely that only multipath-tools is affected by
this problem. For now, here are patches that fix the recent CI regressions.

Martin Wilck (2):
  multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37
  multipath-tools tests: fix CI failures with clang on Fedora Rawhide

 tests/directio.c | 22 +++++++++---------
 tests/dmevents.c |  6 ++---
 tests/sysfs.c    | 58 ++++++++++++++++++++++++------------------------
 tests/test-lib.c |  6 ++---
 tests/vpd.c      | 35 +++++++++++++++--------------
 tests/wrap64.h   | 37 +++++++++++++++++++++++++++++-
 6 files changed, 100 insertions(+), 64 deletions(-)

-- 
2.44.0

