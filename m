Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B2E33F5A4
	for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977106; cv=none; b=ZbYP1aAQDw50iXX8aIAppz2iZWsZhJ2EG8Gj+tmWrr8nszbqd9rEWcMeXQa9gpdvRIx+0N9jeXl53L8+ZgLP8zYCABWGvoAnQnwwHq4DxGFfHdhMxKwNn1nNF0zHQNvsyYUAvUTCk5DEeRdRHLDsN6DNRdqpcJjoJfh+UuctEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977106; c=relaxed/simple;
	bh=UygkgDLTE5TX6fc2Rjg49PvbhE0aBXWnC8WJ3BiBjDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lsoVHrjT/p6jejZ82QSlyEDM9NQiQt18cM7H4AxBv3dvP3zJgBxloR18qIHI3SinGLcsBSva8bOb9uqBHox5/d2c+sBGjzuytGiZXitbD2S1fIlwTaBazo47Hlr24YDbDNsGh74iRWAbbj1aMHk+Urj9J4R7LE1hZGRs0tJs2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eE8f3wFh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eE8f3wFh"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891f625344so56565925e9.0
        for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 13:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776977103; x=1777581903; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WLnAf6PFtVDmNkJvyZG51EbxNVJegiKct86a/kZpCbw=;
        b=eE8f3wFhW96BH7P1Bcde+Lxc0dmBthGxbC0GF+JETX+IrlHzMYN853/mbzFl1ygsgW
         E69SCXKRKFAMnw9JWvBf/Dqawk18g611lGheCkhBDsloUsXRtpgWZpBLadgVcxhOquh8
         ZlITSUAztZs+yHIQRlY1vR4/TpFmCB1yeh9JQwdMdELcG0rH176cmTrQoJQhhzIeX+2x
         2Ec00BkTI0nmMFLsEhSwTKikRpjKsGupwGN12D58RljFAGVfyOzeRZEsPR+ypTz0FTfh
         zOnqRueuOkrHv1MlycLm4Gye6lhSRRMqS68HX1+x/oLoMB2asxfWC99ZaUyh+AXMrGx8
         3PIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977103; x=1777581903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLnAf6PFtVDmNkJvyZG51EbxNVJegiKct86a/kZpCbw=;
        b=Up6VOe4ePB9I3cEGIUQmHamvcdQ2pWor2Q6THQzJ5ZwQFqrmkvSRTwOknw927IQ62f
         S7+jGAv+f3TyButT6XNtOhEDLzq49qcpj19tJFCWaWYPzhwPbdN1aEF33McpX+7Oj4M4
         L8MxTNF3Qo/pZNUeqWHHQon/LfXoRjBOn4mYVtHiiyvY5iwAE187ZyYBprlXM4GyodCI
         yREAkxbV7VYNQVn+P+G+5N2xYfQnt4QF1/wE0M5/d49wmwAZxQlC5/T6Z7+1Zplo0ZMo
         uu/JUdDzZymEgDgQcHonrAynx4V0LueCQpbqCdYEmuqv90QnGU+yDLie+nqs2NRNViqt
         aHwA==
X-Forwarded-Encrypted: i=1; AFNElJ//pVk3Gh51KE4gXe5+XriaCZrFj7CDz5T4WRVF//Q6gJEPVob1JIjbGQ0Nnodar8aaBsSZKgfb0A==@lists.linux.dev
X-Gm-Message-State: AOJu0YysdvVH8VdJtt5mafOfQZAbnQFAM4Ar+Lef3bvm1tP/Un16gLJQ
	/wHbOJJzdYDgcDGqPhcYXwB7F6XY32Os8gHegQiBG7zhBuAbh4uabsunnwxzwtbXEDZkWTADwhf
	9CJTBfpI=
X-Gm-Gg: AeBDietzLaAruHEFH77f3pyxCaksZ3CLb7Zyc+DPIiyISpuraj3kiKz0/NH5NnW/qfs
	US1UFHoASn5ZkzYGj0Z9IDj4l/xhLauqVZUOekIViHb0LNmUbl52JlKLqx9w7/tb2LdN3pRXxaL
	fg8tEne+sEqCuxVPsg7YlG30pNv2j4JO8Nf5iFHt4GbLcwN2yusVlS+Ho1gSzGb/P3w34GtzPKh
	iS1fyvPf2q5zp04zrQKj4Ky/b8MLsJYF60Ahs3nfS4HEbEHzQDqzlULZHQeg7P6Vhpy3Yz8z4ke
	xh5j/eVZRlqQLWpiNhynf75BatVRENfIaUFKMbizujaZqZjYVfSO08QnD0LBav0a3EN51GSWdjN
	FwQ6Gsx2eAcXKFQ+k9T9rr3T7dM7M6Nv7Kxf3UGJRb1TZDrmZj/fLPPmRdNAEhf334pvAhrHIyF
	oePIBmlnCaKpgXfjml7Njeg5lW4KNZba+TKy34HUmXZ1Ms4UWYxw+vc+3yLMpSrZEQbGv/DTNut
	1rKT1GVDRBB8jSVsZ+vldTD
X-Received: by 2002:a05:600c:33a4:b0:489:1abb:5559 with SMTP id 5b1f17b1804b1-4891abb574amr146556125e9.5.1776977103209;
        Thu, 23 Apr 2026 13:45:03 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb79ecb9sm229405105e9.8.2026.04.23.13.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 13:45:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/5] multipath-tools: generic async threads for TUR checker
Date: Thu, 23 Apr 2026 22:44:41 +0200
Message-ID: <20260423204446.472642-1-mwilck@suse.com>
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
 libmpathutil/runner.c             | 221 ++++++++++++
 libmpathutil/runner.h             | 102 ++++++
 libmultipath/checkers/tur.c       | 369 +++++++-------------
 multipathd/main.c                 |   4 +-
 tests/Makefile                    |  15 +-
 tests/runner-test.sh              |  55 +++
 tests/runner-test.supp            |  15 +
 tests/runner.c                    | 552 ++++++++++++++++++++++++++++++
 10 files changed, 1081 insertions(+), 261 deletions(-)
 create mode 100644 libmpathutil/runner.c
 create mode 100644 libmpathutil/runner.h
 create mode 100755 tests/runner-test.sh
 create mode 100644 tests/runner-test.supp
 create mode 100644 tests/runner.c

-- 
2.53.0

