Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273143F23C5
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777376996; cv=none; b=rCFTs693dI11ptTJ++XT5aqqLTRLldbxJ1fzDlZCGuRg86nz6apH4TC3AgmAgxU57EqjIwJr8zDSRTrIlEdHqhKhzB7hZowICNswkw2HyomyQZHA6BcqHj3Dz1ohOBQHXE/MAYvoCDq3VKvENd4WfGg26pBOWRUoS6jdK5lus6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777376996; c=relaxed/simple;
	bh=o+jxc9adudpMKF3pwxH4AcaljuIW4rqxkmq02AQ+Yto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9thb6ITSCan5n2nK6UH2zD4UcPhlHvAgGMfY1umxH2aqi31dH3gCLfquPCvVN3Ir9Y4e6VODRb3V6UsEneBxOeDtS1hjXlh0lNBOS/03IC5VWbBgJ+MODy3qro69rj88NJXwqcPCPNhObva6ZQnuyEB33wa++SFAC+Vp4oFunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S0g0gf5j; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S0g0gf5j"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so139225365e9.2
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777376994; x=1777981794; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vQukRNx8RUBd4UhLGXzgv56XDPKPB3Oy0g/q/5rnhNs=;
        b=S0g0gf5j4KdYXO8gufZnXtYmJWnRs1GTzSl3ofUSZVtzRyhZ3D4da/iVN/ln+FkQcv
         GXcgnBt2yeIzBt6LW6fjz/OAJiktlkF48dcg1y3TmPGE8pp57chXvMC2yZ1b2xV8gZd2
         qHDV/qm8m1OTQGhu9YyW/25wKEXLW7IBlTwbiCvUY8ZkwDmg05VVBzKj6Kj9kYVhlAbD
         LJBEqmKD8sGbJ/KWOtQUM74j8Wy/lQXPUmMAZY6pUHS9RgFHU6eCrrkAZFXyzutRHtV2
         PsnM+lt08XbXgG2QIRPWSQy3pmU8PvmpHHgXuIob+9o3NJpOCy2S/6PtzpuJH4AmnSKJ
         7SGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376994; x=1777981794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQukRNx8RUBd4UhLGXzgv56XDPKPB3Oy0g/q/5rnhNs=;
        b=dHelIdDLAZGw4ML56OYhtKQw61Dl92o7uThhAnhr6IzhbZ9PlfTMegGK9AOBbzseFj
         Pg+QqcCjGhGNUrlVKmP/1Od6iPAzW1Wy8QVLtetDqibRgzBbcZkoG4QKISgbQwHxtVHo
         iauh+akiA4p7yFtkJbkSaAca8m9vPVr+2jFPFSfC2ytei7b/242yFV7l31hWbXQ5GEtZ
         OOtHEqP/Y7jpsq+MEZeFzZ+phHe/lp1ygAKI7D2HK3N/VKYirzoghqgXGaH90XuTJedl
         uNoYD2FbSX62itf4To2eOTsm0gCr03pNp8OYBrTHXj407iwAILTsUlO2pktEcvY9Wo51
         ZJtQ==
X-Forwarded-Encrypted: i=1; AFNElJ8eUluZMXn+gaKmg138j8wEwSYbf6pn0MPJbb8Yw+1+mDiB3T7XOF3nh+LuxOFGJ3xfspKveGt9Yg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfdmSjgfjuR0umK4TP5/g1IqNubSoRCvXLwAPwFYTwWRl+VwxO
	bb7eb2nD1Mrg2iDDGmSkl7UcIrm5e96TCtIDipdM2pjN32CNeTltWyi7p6nDWXQUyu6utb1mY9D
	Va93Dx9k=
X-Gm-Gg: AeBDiesSlkrpNTH4tL6ZQqE6cx5oJpExjnlhxqALFm5BZCV2RBz8zW7N2sBHc53vM3E
	P3Ozgs3oFOE4TE+dxqRJJ97Y7WJFlMx58KN4acSMSbedo2Rp6cZmKHsqWIAVa2VG1++up9BFiEC
	DWO8LHiEIDYigx5WpHv5Dxq5fVl0ETLDLb05rqsgM9OifmP5tEFHaVbo7tx+gwSXK1dqCKKy4/Z
	a7aW5ROM7F1S3W8SRTkC5mwpx1O+LVB7nO+SmcoWrtDLWa91VcmfNYmUWvWdL0NdSNukUVBJsL9
	FbPBQxYCS7/9/fqatZ4auAwlWZvzFtnRf71WHCuWUSFmNmG1dwFoQl11HURkWwty3Z4wCqQaP8J
	0RHUPqvW6S4ZfWVuhtNAYrZWkfxfGVYWaczTTtzFYQofZQnlcQSHmQUiB6KvKqoUjShRPq3tdWi
	EIKm/cVvS+GG6mAf/1ktgkH+yI1CYtfMj7k4EFwsKNjR4RwWkNih0YQ2O/7Y4+SKabLfW6qgvfK
	j+GS+eTwKjg2H2goxJIP8/J
X-Received: by 2002:a05:600c:8585:b0:48a:6315:da26 with SMTP id 5b1f17b1804b1-48a77b1f0a3mr33052085e9.26.1777376993520;
        Tue, 28 Apr 2026 04:49:53 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4463d02f2a2sm6007264f8f.10.2026.04.28.04.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:49:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/5] multipath-tools: generic async threads for TUR checker
Date: Tue, 28 Apr 2026 13:49:37 +0200
Message-ID: <20260428114942.292307-1-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Motivated by the recent submission of an ALUA checker for multipath-tools by
Brian Bunker, I am proposing a generic framework for asynchronous checker
threads in multipath-tools.

The first patch is a small fix I came up with while testing this.
2/5 is the actual implementation, 3/5 test code, and 4/4 modifies the
TUR checker to the new library code. 5/5 is new, it simplifies testing
the timeout handling code.

This makes the logic of the TUR checker easier to understand, and should make
it easier for Brian to implement the ALUA checker based on the same framework.

Further improvements on top of this are possible. The new TUR code, except for
the tur_check() function itself, is pretty generic and would allow abstracting
an "async checker" model with just a few changes. This would make it possible
to switch also the legacy checkers to an asynchronous mode of operation.

Comments and reviews welcome.
Martin

Changes v2 -> v3 (based on the review by Ben Marzinski):

- 02/05: fix handling of cancellation in idle state: don't attempt
  to increase refcount or free context in runner_thread(). Set refcount to 2
  to begin with.
- 03/05: treat "-t 0" option as minimal, not infinite, timeout, to enable testing
  early cancellation.
- add compile time option RUNNER_START_DELAY_US=<N> for testing races between
  thread cancellation and startup

Changes v1 -> v2 (based on the review by Ben Marzinski):

- The design of the runner code has been changed such that no caller-side
  references are dropped automatically any more. The caller needs
  to call release_runner() explicitly to drop its reference, independent
  of the runner status. This simplifies the code and allows implementing
  the MAX_TIMEOUTS logic in tur.c as it used to be. The overall API is
  not more complex, as release_runner() replaces cancel_runner().
- An additional state RUNNER_DEAD is introduced, denoting a state in which
  the callback result is unavailable, but the thread has finished.
- The naming of variables and struct members has been cleaned up.
- 02/05: specified alignment for struct runner_context.data
- 02/05: removed most assert() statements
- 02/05: removed superfluous cmm_smp_wmb()
- 02/05: perform all state modifications in the runner's cleanup function
- 03/05: fixed signal handler name
- 03/05: reduced the run time of the runner test script
- 04/05: revert back to the original MAX_TIMEOUTS logic, keeping a ref the "last"
  runner context until the thread eventually terminates
- 04/05: consistent handling of state and checker message
- 05/05: new

Martin Wilck (5):
  multipathd: get_new_state: map PATH_TIMEOUT to PATH_DOWN
  libmpathutil: add generic implementation for checker thread runners
  multipath-tools tests: add test program for thread runners
  libmultipath: TUR checker: use runner threads
  libmultipath: tur checker: improve tur_deep_sleep() test

 libmpathutil/Makefile             |   2 +-
 libmpathutil/libmpathutil.version |   7 +-
 libmpathutil/runner.c             | 229 ++++++++++++
 libmpathutil/runner.h             | 102 ++++++
 libmultipath/checkers/tur.c       | 369 ++++++-------------
 multipathd/main.c                 |   4 +-
 tests/Makefile                    |  15 +-
 tests/runner-test.sh              |  57 +++
 tests/runner-test.supp            |  15 +
 tests/runner.c                    | 564 ++++++++++++++++++++++++++++++
 10 files changed, 1103 insertions(+), 261 deletions(-)
 create mode 100644 libmpathutil/runner.c
 create mode 100644 libmpathutil/runner.h
 create mode 100755 tests/runner-test.sh
 create mode 100644 tests/runner-test.supp
 create mode 100644 tests/runner.c

-- 
2.53.0

