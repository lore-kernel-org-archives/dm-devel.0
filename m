Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A748AE1A
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995828; cv=none; b=MEZYnO6YCD7o4kZx41G/EiJu2DleQsQASxBpt97Xv2VFYoKEi3+Xyr4c5oYt4FAC9Kio/rnrOTdAML/Up7fdv0xpX7x/gA7QGFnQi2MnZy2rNafHBsiRcT7SYgq2HSJfk8Zcdg9eMhHmmoeKIzJYMWBNQKnlT8TbrD88ytjAB8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995828; c=relaxed/simple;
	bh=Qbu7/nRPeYd5B3EDjG4IPB+QH0rX6dvIDsAQ9FghLwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gD2AAQVgq5GsCaPQgE7vsx6ne21vjLFnS0yIO/0+F+K0kVHnKdEzm455+8cdXXjB7eXxQHp9Hs8mVmtLNt8yWmFqcubkZ+VR2lWBMcMturPkND7d4scUjxrfRAu7BFNJJgiWi373XNkz3In+j6rtx84TwWSRRrTYOmF5s8tPwrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TedIoZMA; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TedIoZMA"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso38692505e9.1
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995824; x=1778600624; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DJebi/bBFK9DJhU/w+g6SqAiS4duuWwNCUePPG+nHaY=;
        b=TedIoZMA/CSK2sri5srYhrCtguTqSMynfSn8xLCHzdIFysw78lWSIIf/HOwN3uR5bE
         k04p208WA1KOqT+QE8rrIa5gtn1mEUEsQZjvpfcJtCD6WGtzR7RKf09wuNGenAFjKaxH
         zpBXY8oeA0syqGiHrSgSjeSBM03DMrqFmRvSq0ux51Cc7lDNu87doC5oU2FlZqfGJ9DM
         IBy/AxxYeBELtgqklFaizwMU4tLt1M+vnqfRIq0yJB+82kslfSfow+YNmSiC7XkjOgZw
         gkv7OxLJDC+OY8anJymgsUnYH0BY/37OSR/2cQQYn2rZjpylMvHtgl09HPLn612HwmNR
         yTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995824; x=1778600624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJebi/bBFK9DJhU/w+g6SqAiS4duuWwNCUePPG+nHaY=;
        b=RgmoOKuJkJyXzNnSxf/xLUrMgsUni+Hi0ZZ3cn5uq1oxcq0WmMtS9AI7KvBpcAVbrW
         kRJqlfkN15mUAgHQb4s0hzejljOj6RMgRwZuJZoN5VH2tSKLG8Un2CoFv9aCT02LDuKI
         pbDJ4el6Qrd1a/gZfSWJH8Q5uZ8WG6UywhPxlmZ9Z1j7ILZczPJpG7/xrwE6r4e2nQnO
         9lPxknHOSsn0J5M/ZtOdbMM8Q+X8NWfIK0658bdACZHoaVzfiW1sv8HUWYZBf2NEIZX+
         eDE79i9UUx+FF5N+OQgSvMSt+vmu1Mr8z0POBQJSV3tOHfM7q/5lOL4aGA72q9mXUwH6
         g8ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+oBPR9+uq/MDH9USkS17iJTfrcwJETqC1yNvJY1DWyBM8/q0ceXu+clF6PjPLZndtV3w/9BxpLdg==@lists.linux.dev
X-Gm-Message-State: AOJu0YziOExR4MIw3Lq5hRBFtd2iLlSgsMBsM3CcKUHOgQBGzyRkEabT
	bpLv/S2cedB5MI4dBplvB/x2LedC95cTMj3jGljYNoYkp+a9upIxrwISGziCA/RdhEo=
X-Gm-Gg: AeBDietUIRYUoG4225DN0In23SMR1dWZgi2A4fnT27PesJt12/po7lSwM3Y4fXBAXMX
	Dg4vOAOBA13LtXcyD38zpc3wIOYQz9lw1NkirlP94kZ+9r9r17o4V38p91FZ4QP39QT5C8y+ueD
	FtvO5h7AG/Etnv0ZELfh2g7x8w1xmmT2hy0YNeAUNQUkd6mUIUVRkmMtUGMsiYvYqoZirtzW92v
	4zKaMXmFq8fBOoqvehlCpLiXa4f6kERtCAqWD1ckay/rYCVs90YAqX864kj+MOBCMkhy/YRhqs7
	ttRhGhrgN1AdcjzU0ygEe77FFAAGY4GdfaJ07yrr1/VvON58Bx15yINCo4VE+/ZhHMKri698tzG
	V4T43K9ArDoiWBpFhiJddT9892IS5bIG7aBPzYNXcuwIkJ5v7DoVhWZ0tvqw2JECI2dcGVpsKYP
	CkVRtlSm+QMSOz6arqHiJ8LS20fSIGOaZBCI2nHm9ne87NMmm1OHC8ATt8IZZ9mTupRe/uMStZK
	+WrRPxSmqWZb37Nb0KyZR7r
X-Received: by 2002:a05:600c:6215:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-48a988a9c49mr220499945e9.5.1777995823785;
        Tue, 05 May 2026 08:43:43 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48d149f1a77sm22577155e9.4.2026.05.05.08.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:42 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/18] multipath-tools: asynchronous checker framework
Date: Tue,  5 May 2026 17:43:14 +0200
Message-ID: <20260505154332.448054-1-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on my previous patch set [1], which introduced the "runner" thread
handling code as an abstract implementation of the asynchronous checker
logic in the TUR checker, this set introduces a generic "async_checker"
type and converts all existing checkers except directio to this framework.
With this set applied, all checkers run asyncrhonously unless explicitly
forbidden to do so with the "force_sync" option.

Patch 1-3 are minor preparations. Patch 4-8 introduce a general concept of a
refcounted "shared" pointer and use it to replace multiple instances
of hard-coded refcounts on objects. Patch 9 converts the current TUR code
into a generic asynchronous checker type by separating the actual TUR
code from the handling of the async runners. Patch 10 adds support for
this async checker type in the checkers code by searching for
"libcheck_async_func" with dlsym() in checker DSOs. Patch 11-15 convert
all checkers except emc_clariion to the async_checker framework.
emc_clariion is special because it needs extra context both for the checker
itself and for multipath-related information. Patch 16 and 17 add the
respective additional fields to the async_checker framework. The mpcontext
handling is rewritten, because the current apporach of handling void **
pointers would be disastrous in scenarious with truly asynchronous checker
threads that may hang forever. Patch 18 finally converts emc_clariion,
using the concepts from patch 16 and 17.

Comments and reviews welcome.

Regards,
Martin

[1] https://lore.kernel.org/dm-devel/20260428114942.292307-1-mwilck@suse.com/T/#m9369993a81c82b10ef42896505d4a354b6be3f79

Martin Wilck (18):
  libmpathutil: runner: reduce a message loglevel
  libmultipath: checkers: add two generic checker messages
  libmultipath: checkers: move checker_class definition to checkers.h
  libmpathutil: add implementation of generic shared pointer
  multipath-tools tests: add tests for shared pointer code
  libmultipath: use shared_ptr for checker classes
  libmultipath: use shared_ptr for prioritizers
  libmpathutil: runner: use shared_ptr
  libmultipath: add generic async path checker code
  libmultipath: checkers: add support for async checker
  libmultipath: convert TUR checker to an async checker instance
  libmultipath: convert RDAC checker to async checker
  libmultipath: convert cciss_tur checker to async checker
  libmultipath: convert readsector0 checker to async checker
  libmultipath: convert hp_sw checker to async checker
  libmultipath: async_checker: add context_size and init symbols
  libmultipath: checkers: rework mpcontext passing
  libmultipath: convert emc_clariion to async_checker

 libmpathutil/libmpathutil.version    |   7 +
 libmpathutil/runner.c                |  32 ++--
 libmpathutil/util.c                  |  45 ++++-
 libmpathutil/util.h                  |   5 +
 libmultipath/Makefile                |   2 +-
 libmultipath/async_checker.c         | 251 +++++++++++++++++++++++++++
 libmultipath/async_checker.h         |  36 ++++
 libmultipath/checkers.c              | 236 ++++++++++---------------
 libmultipath/checkers.h              |  54 ++++--
 libmultipath/checkers/cciss_tur.c    |  41 ++---
 libmultipath/checkers/directio.c     |   6 +-
 libmultipath/checkers/emc_clariion.c | 104 +++++------
 libmultipath/checkers/hp_sw.c        |  32 +---
 libmultipath/checkers/rdac.c         |  30 ++--
 libmultipath/checkers/readsector0.c  |  28 +--
 libmultipath/checkers/tur.c          | 251 ++-------------------------
 libmultipath/discovery.c             |   8 +-
 libmultipath/libmultipath.version    |   2 +-
 libmultipath/prio.c                  |  47 +++--
 libmultipath/prio.h                  |   1 -
 libmultipath/structs.c               |   3 +-
 libmultipath/structs.h               |   3 +-
 tests/Makefile                       |   4 +-
 tests/directio.c                     |   2 +-
 tests/shared_ptr.c                   | 111 ++++++++++++
 25 files changed, 716 insertions(+), 625 deletions(-)
 create mode 100644 libmultipath/async_checker.c
 create mode 100644 libmultipath/async_checker.h
 create mode 100644 tests/shared_ptr.c

-- 
2.54.0

