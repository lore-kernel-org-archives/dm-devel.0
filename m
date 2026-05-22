Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE564611CC
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468283; cv=none; b=A9rHjyZ73815Yv9zfqqxCnXLd/WfvLKdttpbfpI0VWpjy9/XeNdN1+KFNdePCg0vj6pDYRrchnlV5qc1TMABaO7DIWIxe67etw7sKIs9e/HVIOTYeN5Rqub+s/rfJs9miuaA1ySRfoC5DysaZa2+hPI9Hyq+jPrPXJ2X+nDzORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468283; c=relaxed/simple;
	bh=CAuXVu4eOpUVfCncCFsNwZOnp5yQkIj6aDJXMTXpFsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mY0dgaWOhtyDTA50jSRo1N1WTJrcROxCpY+fNsnPu0W5VXx0Sll9WGilWhLqJs3qyGi/rfDITPfKKSLVoI1huwl0dYMMPkHTxqefymRNNbBa6viBa1H1Ir9+YtvLe0D/jBX9zDUivlwtRYxZBfrDrrmBsrBg3u6t3VJVHtY5s+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WB/CQJPP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WB/CQJPP"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso97470595e9.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468279; x=1780073079; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tafbeq82POGkhgkJ5/b8BzoeNviDyGyczeSTTZctWhQ=;
        b=WB/CQJPPSbJC47PFuJY1Ftbm6rl+9yZBmdUUJVdbejz4q0Sc1mm3rKPqtZi8tulz1w
         hOMBzo/6ZmpCcRjuuxL8sTHNv46WgoNDJ2ISLGJUcFnlZ3lbGlfE124XtDRF710v2aP9
         JVyhqXY2I92RgFEGACJ4H5iRs1t2KBbvVe6ClEUz/2rb8EQ7lQ2CDthn0Qo2V4tvBBfu
         5Rj90lpZS/2PaRd2W1npmAfAlEW4AYFYqym+iF5U2oOyEHGhCa7BOXlq9ysl89OgVsVm
         BxXyBdd8E07apqG669dc4PiWTXMI0qskegrYKJ0Piu6l5l0hnuipow7wga7D1lpMR8aw
         BKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468279; x=1780073079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tafbeq82POGkhgkJ5/b8BzoeNviDyGyczeSTTZctWhQ=;
        b=alNo6v85MKKhzQf2WuWwGUP4FkAQurGm57WbJa9OlTimWiHCDn7psdfxLCSPO+Wd6H
         nB394EJbYRSW4sBi0yIlLt85Ofvol6T8xqLTgj60xha5WatlM2V1vuoUUMZMTFWHM2UE
         82IaauxY4t+c246GArgfklMrtmUXAzj3b1ACoBlej1D9up7RV9vGvnfVnQB6HnH6kFe6
         YWeanlTclA9f9nKOuObq85NrsjDRuEYfQheN7w+cQnLDoPeMpt45w2rzVYgfr+Ynf3E3
         2PEfs/8i3HWSJTqM0nnUnn2itXE0NrJTbbth0fZUk5YNM0E/x+mVrhErtpgN59nxc1wI
         yN/A==
X-Forwarded-Encrypted: i=1; AFNElJ80/UZsh8cTkoM3Fl/aVqizwtxypckOJ2oudNiEVpQyrs+nk4rD3sMUQi2yCEJ7tp+LWYurY3Gheg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzdvnNsvi+xKjKyO5q4GPXEcGyCkvzh9ZTDxuRNbRAvVZcowB0+
	DsaaDu2fkRtN9/O+Nh0PZv6F/x+g6iQPWrUSBHmGuwF0bllP23iwWQIuikulYZeiRzo=
X-Gm-Gg: Acq92OE5FvDRW+8nglGSrIdnYM9Mw6UYxJbB1gcJfmCtqRe7I3BusOKtjiW+R8uOJMB
	+YS9AnXv33rFvDPNDjpsIbzvEnPUAUQLXeNmeS4XvLXYQxtNLb7s32sY/wFh6f8D9aQGdWfeRXw
	oMD05RixSm0x4ZcIoEmGXjCNNRiMR9Yz3w/o5RcC3EL3wL0GPZ5mYJ1rE22iWR4K/lya/7vxjlw
	vRE4cLOADHzFIqQnapKuje+XrVh4fQo5o/FFq5lAbqDIv+64OpXwmqwU0TGU28LMWVVq03Cf9VX
	1fWGKXycs7ZMMvIWDzKM1qrjbAAiz168vIcj+TFNwIWtavnr0t4zwT3wZxXuA1K7XDAfAgFk5Mp
	RwchRzYXCiqFeUyvmYIk5E3gN28QLG/9Rkzz4+MAd3KJqEthhyC7IBLbeSiF+/BN4O03AtGxGra
	6vPc3JpbkUo7OK3ciLv39RK5y/2LzsoXwWxbFZo2x0xJLo/UwBWtCuFLMXbQU4ojPUSLXdSFmsH
	2yhUngsU16fOw==
X-Received: by 2002:a05:600c:444b:b0:490:388f:1c0d with SMTP id 5b1f17b1804b1-490424a9c9bmr64726675e9.5.1779468278964;
        Fri, 22 May 2026 09:44:38 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490454c60b5sm58040115e9.1.2026.05.22.09.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:38 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/19] multipath-tools: asynchronous checker framework
Date: Fri, 22 May 2026 18:43:56 +0200
Message-ID: <20260522164415.846589-1-mwilck@suse.com>
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

Changes v1 -> v2 (suggestions by Ben Marzinski)

- Patch 05: rework the shared_ptr test
- Patch 06: new, separate patch for removing libcheck_tread code;
  remove libcheck_thread and start_checker_thread() from checkers.h
  Following patches are renumbered
- Patch 10 (was 09): add alignment for checker_ctx field in struct runner_data
  remove the unused chkr field from struct async_checker_context 
- Patch 12: remove struct checker_context from checkers.h,
  remove unused MSG_TUR_FAILED,
- patch 16: rename checker symbols to
  "libcheck_async_context_size" and "libcheck_async_init"
- Patch 17 (was 12): Try to set TAS bit in rdac checker
  (libcheck_async_init()); this requires moving it after patch 16

Martin Wilck (19):
  libmpathutil: runner: reduce a message loglevel
  libmultipath: checkers: add two generic checker messages
  libmultipath: checkers: move checker_class definition to checkers.h
  libmpathutil: add implementation of generic shared pointer
  multipath-tools tests: add tests for shared pointer code
  libmultipath: remove libcheck_thread related code
  libmultipath: use shared_ptr for checker classes
  libmultipath: use shared_ptr for prioritizers
  libmpathutil: runner: use shared_ptr
  libmultipath: add generic async path checker code
  libmultipath: checkers: add support for async checker
  libmultipath: convert TUR checker to an async checker instance
  libmultipath: convert cciss_tur checker to async checker
  libmultipath: convert readsector0 checker to async checker
  libmultipath: convert hp_sw checker to async checker
  libmultipath: async_checker: add context_size and init symbols
  libmultipath: convert RDAC checker to async checker
  libmultipath: checkers: rework mpcontext passing
  libmultipath: convert emc_clariion to async_checker

 libmpathutil/libmpathutil.version    |   7 +
 libmpathutil/runner.c                |  32 ++--
 libmpathutil/util.c                  |  45 ++++-
 libmpathutil/util.h                  |   5 +
 libmultipath/Makefile                |   2 +-
 libmultipath/async_checker.c         | 249 ++++++++++++++++++++++++++
 libmultipath/async_checker.h         |  36 ++++
 libmultipath/checkers.c              | 236 +++++++++----------------
 libmultipath/checkers.h              |  79 +++++----
 libmultipath/checkers/cciss_tur.c    |  41 ++---
 libmultipath/checkers/directio.c     |   6 +-
 libmultipath/checkers/emc_clariion.c | 104 +++++------
 libmultipath/checkers/hp_sw.c        |  32 +---
 libmultipath/checkers/rdac.c         |  38 ++--
 libmultipath/checkers/readsector0.c  |  28 +--
 libmultipath/checkers/tur.c          | 253 ++-------------------------
 libmultipath/discovery.c             |   8 +-
 libmultipath/libmultipath.version    |   3 +-
 libmultipath/prio.c                  |  47 +++--
 libmultipath/prio.h                  |   1 -
 libmultipath/structs.c               |   3 +-
 libmultipath/structs.h               |   3 +-
 tests/Makefile                       |   4 +-
 tests/directio.c                     |   2 +-
 tests/shared_ptr.c                   | 120 +++++++++++++
 25 files changed, 728 insertions(+), 656 deletions(-)
 create mode 100644 libmultipath/async_checker.c
 create mode 100644 libmultipath/async_checker.h
 create mode 100644 tests/shared_ptr.c

-- 
2.54.0

