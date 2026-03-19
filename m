Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7528150F
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958441; cv=none; b=lfm59IkThUDL34OsDs/JB64y25ToTw42OMM4zdV8evi80c7jUqQNYDdAaA+x5DDDdroqzcStegJGdRtMLTRci2LC07V9yVxKN6MzuC27+k/EC3k8RpMzxyTofaa1MH07cUJNht+4ZGtUpq+A0s0gPimb9hRABGH9Iur6j0E/FUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958441; c=relaxed/simple;
	bh=3pihx0nX/IJG9uNeEq+1M+M6uiUrDEQgvdLLhbipqzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kf/YYEMWSmzpCd3kN8/2UXz29bYA2yJmPGBPVppmaDKlNK1jB3keHfdoTE1okwwCoI7RyLcDV1kdZ6T2gcno5JN69DWRaAmozO2qZOHyK8XpyxkfIYxa84HK/7CCApGogr6KVQ4DWKBwCqCbfLV72XoNJQzaK/gqLeN+NuCcqQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BgLHF4IU; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BgLHF4IU"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439cd6b09f8so1022580f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 15:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773958438; x=1774563238; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=88VHjmf+w4VmKVk58RRWrXpW9IOz/YBhmFEf7klM5b4=;
        b=BgLHF4IUic8dnaUc1xRXk4eYRTXr5h8G+TIZ2QvZrgwiGOhR/9pT1SJFCHsOxfGhDa
         qffSpc/x9CrLkLa0QRvCCdAWAXuSGY/Q5RRfr3+hQJDYS2gfZr8EXYN5he9kyB3l8oyk
         6w7+Gl5LJ2dcT27CeYJnjpKIBOi4zeqCyLr+a77OIdqaG0alpVey4C0Xp1rEiZYBTxc2
         FIHVoHgurVScD2sKHTMKjvmENA4BECoCZduXJEwQ4f1SJlMQiCibPmVW0B5jKSeubARv
         bNecc1ia0+u3a+vgH5q1pP35B7PDuekqfpF3mBW3MDjP01ms8pYFKdUIbJonSK82V047
         r7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773958438; x=1774563238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88VHjmf+w4VmKVk58RRWrXpW9IOz/YBhmFEf7klM5b4=;
        b=bpS8YHgTWVuiSw1tXUwMlKMwxC/muqRuy8RQuyDpZYrOgH+O5DRQlxz12nnfRApr1u
         gGQTJuL7owAxDrN1YjXk4cJrX9AOgLHRLqx2mKuWI/7uqBmNKOpe636cJT9CLAOzDdjE
         OS74vkk7U8oPVNNTJKRcyDArlKEpiTZueymip7xgfqjGTOvIlUR4kIdhHB9yGI8PWGTq
         U0CEQv9R63PyX1pun1Lbunj9AN+B+cRux5h5sdmSWRkntRkmXC4RcJBm893WO6bq2lRY
         5Oywm7NOax0Xg5wxDvhRGuqfPki4j1UoYGt475jc7GB4aLDq/j8gJ27hlYvR2UsB0D5k
         RURg==
X-Forwarded-Encrypted: i=1; AJvYcCUXDZpff81iqn7Ql1ihD36d+Oxh+HUxrIY0M151hbpJMqsY1KPlJO60DaKXqd0Sse5n9VMq3GgMsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzughO1EyBwkP7OadqgJnbiZcpczJhdAhbn8RfPAeFEAYDWXt85
	LaosIY/XOnUkjLp491oUTVMvnzVKocGFE1fHktuEkGl/syCm0sSCLD/mceNSv0vltlI=
X-Gm-Gg: ATEYQzzzAO5UFOjQReQJAx5AibnaZoatwroUOcgAkM+3zZGUlk1PC39VJ0/+UwHmo59
	4Pr1d5CLO4jiX7IrVRU/kPAaDoNfMGHZElnUj4BcuaFpR5cd4t0iOvEpg0hGlnLVheJR7O0thd4
	9Smu2VL6yCE9W0z76h+gs2kUlazgiYrhAIj65wQbINlZi+9x4HByCkz+RmJD84OIrFCCkV3W4UF
	mN+5jXbZLVtxvlTVQ72CY9j9QtSL8fI/2BPnmSCLBIaBX6ITmJqwRMCSp8Y6PXxixFOo8L9e6Xc
	C9M8Wnn2/VS301IbsMSLBFcbNI9UzmjGZOZAJ7+R0t3nuN0BhUHkxMR7nk6jj1G3JijjEzJZ/dZ
	hCkWg++s8hs8992swo0K6C3IMmBQ0+ppNNahqZ8wcci/rTHc6dvncwRMf4l4tmo2tllSQUmOF0P
	uPpJNhWnorkcmye807nbz4bq6IhXh1ASTmazQcOdTnGrf/5E1WaOjDgzUnVQ/+ZJRNOA/xKUSdN
	CIGeL8mVbjB/g==
X-Received: by 2002:a5d:584c:0:b0:43b:4136:1e6f with SMTP id ffacd0b85a97d-43b642817a6mr1549058f8f.38.1773958438107;
        Thu, 19 Mar 2026 15:13:58 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43b64703c27sm1755438f8f.18.2026.03.19.15.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 15:13:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: generic async threads for TUR checker
Date: Thu, 19 Mar 2026 23:13:40 +0100
Message-ID: <20260319221344.753790-1-mwilck@suse.com>
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
2/4 is the actual implementation, 3/4 test code, and 4/4 modifies the
TUR checker to the new library code. This makes the logic of the TUR
checker easier to understand, and should make it easier for Brian to
implement the ALUA checker based on the same framework.

Further improvements on top of this are possible. The new TUR code,
except for the tur_check() function itself, is pretty generic and
would allow abstracting an "async checker" model with just a few
changes. This would make it possible to switch also the legacy
checkers to an asynchronous mode of operation.

Comments and reviews welcome.
Martin

Martin Wilck (4):
  multipathd: get_new_state: map PATH_TIMEOUT to PATH_DOWN
  libmpathutil: add generic implementation for checker thread runners
  multipath-tools tests: add test program for thread runners
  libmultipath: TUR checker: use runner threads

 libmpathutil/Makefile             |   2 +-
 libmpathutil/libmpathutil.version |   6 +-
 libmpathutil/runner.c             | 205 ++++++++++++
 libmpathutil/runner.h             |  84 +++++
 libmultipath/checkers/tur.c       | 341 ++++++-------------
 multipathd/main.c                 |   4 +-
 tests/Makefile                    |  15 +-
 tests/runner-test.sh              |  37 +++
 tests/runner-test.supp            |  15 +
 tests/runner.c                    | 530 ++++++++++++++++++++++++++++++
 10 files changed, 994 insertions(+), 245 deletions(-)
 create mode 100644 libmpathutil/runner.c
 create mode 100644 libmpathutil/runner.h
 create mode 100755 tests/runner-test.sh
 create mode 100644 tests/runner-test.supp
 create mode 100644 tests/runner.c

-- 
2.53.0

