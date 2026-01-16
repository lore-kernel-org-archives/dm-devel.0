Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9713137930
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563182; cv=none; b=bj1sbgpgIpKvUKhWmFMYh78PnN8JeHf4yvURnTKt7ufl4s79UZGplX8putIwfZ+KA0bcjSRfuJJE0fKBtd0pYMaq+mLPD8u7grYu+t+yUofkzu0zWFAOGTKaHOLt7mkd4KKvL0CQLUQ9y1mjoITYBkpjoJCY2LaLc9aFRQv5WVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563182; c=relaxed/simple;
	bh=4APUlZQV9z2v1CbIB6NeeXuPQmRIKEY/vPwUmGj0bzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=klrc34lw2Fu8n0jwRIgmJ3dMyI0l2stX/wigN9svDMkVADH7DecnvwKyO0qwU+EOze13O0XMU/ioXL7wToIu1UfRxXsuW16EXh3e5aL18jrXCzrvzN0CfigDpTfWOv/pK/JjJla8n9NqRCoAFE1Sm4HkRPo59wcqGXjXihF4IIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bl5HN4q4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bl5HN4q4"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so11962655e9.3
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563179; x=1769167979; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O2qtmezyc0SYCqQPWR2ooPtWXpJRl00apOawbfoKgeU=;
        b=Bl5HN4q4q4ox/wbtCT5e8ljY2yoJDSRWn7ZWsKnM1CWasgqEBh08LmBa4kLy9UCxKk
         JjsSCqNq+hcTY9LN+h2igEVPkcx+ZRfd82vjZG78W3wZ7sID2hFfWNPFKtpyWpUJOS51
         dJj18Y/6IhsCIGAyiTVOiTafnfPh112XBbNuauwS/PLffh5+EATjjCp1hW6ddZ2Ttag4
         ijdAwdrC7JSaA63S4oTZwWM6MVT3rfzYW6GiqKSF4ibxBpx0XT2EncqYfhJh+PpwZkX+
         85PB2UIgDf1KgxCLTfLJ//KpejMlBch6QCjg/exDAoV0BPhOSdPT5I8FZQxqo9R3HTvq
         GFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563179; x=1769167979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2qtmezyc0SYCqQPWR2ooPtWXpJRl00apOawbfoKgeU=;
        b=n/aHMMY72uHlg6SFfuXiw0BTi0zdrHoKLP06PbqI6Rf91SsJcUQ4Vv42kUbVA0ml+u
         SibM9OdCmqS9YnOZmUgPJmdxv4uUejxaxs68UXWQeQRJKxsHuGf0aR99DasAocMgHT34
         LlXjyAtPlPvG2v6dsJSRg2xW7bAL/H2y2ZZt6rRMshKGt85I03O3Pj73w0ipjh5RA0+W
         3KdU+PULFQG770fWXCai6fXyM9QFwG5h5pPubpmGS3JDa0P+EXWFKrNYLwDi5Mz8Ixlt
         pZrZ9TWAC9JbwkTr0VbYdRhwJUOzDZKYkl007sW3yl5Y/vIx3afsRLsR3g7mQpLURd/J
         SiqA==
X-Forwarded-Encrypted: i=1; AJvYcCUJiIjr7w3xP05CrzkOtah7kptN+yefrZyMeZY5PJEQBnzWEL+xMWgF1MG0yoFdHusp1bxtf7hbkw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzr5A5UffrHNJ+Bwr/sGbKcxTkPsA81BZt3VM2Ugin2uuNdd9GX
	9jBd82bPd39lbYly9auHoI1pZJYGtxRFxTpkrfZ6J3mEiI/kiNKNeLVI2E3vfMgpauc=
X-Gm-Gg: AY/fxX638gbrWQhzuI5m91qz1EEPUpQ3XXoIhwyyBicIDavgg8RGfr/hb9abZryIpeI
	5qT4s84ZxXe3aAFILqAgrkX7kMgop1ZyWijc4NHmWrN9sKbZMDFxRly9+DaOu4patH0L+UNqoLf
	nvUxqnpmXugskpviBzX35DoK/kHTgvXQ173A9N1gdTkPuWDZ/Mg7HJlar87zFDJxGOGX4z8Td8Z
	vTzG5P6FCX2YMA+wzWnzc6erYw8JAEbWU/gqmM2DWkx/h5Ph8lLOG5+qnXiGR8F7kU8ABb54IHx
	2J5h131OOF5YYzuCMXIRFK+/dv4QlqsZv6NzI3iYSuYV3M0Aov6mfa1/6vYJD+4EqVQbA4czOln
	z6X7zBOOj3R4mHLmyDXJpM7zpVuFpI3KOf2zPq+pJxPFGzXdNh6a8A+9tRt/ke09y2zvxxVwChs
	/LVviRhHRCesAQVh/3t0uenq+d96PIQ2ycwvZv2PMdjCKvimqcwdUqw113Ge7wCjMcI96fRo2PQ
	A==
X-Received: by 2002:a05:600c:310e:b0:47d:885d:d2ff with SMTP id 5b1f17b1804b1-4801eb11002mr24877815e9.29.1768563179259;
        Fri, 16 Jan 2026 03:32:59 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4356997eb1fsm4818425f8f.35.2026.01.16.03.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:32:58 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 0/5] multipath-tools: minor fixes in preparation of 0.14.0
Date: Fri, 16 Jan 2026 12:30:37 +0100
Message-ID: <20260116113042.140719-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes the double-free in kpartx introduced in 8c39e60 ("kpartx:
fix some memory leaks"), removes the long-obsolete "hotplug" mode of
kpartx, fixing another potential memory leak in the process, fixes a
false positive compiler warning, and adds two developer convenience
options to the Makefiles.

Martin Wilck (5):
  kpartx: avoid double-free of mapname
  kpartx: remove "hotplug" mode
  multipathd: fix an uninitialized variable warning
  Makefiles: add "ASAN=1" make parameter for AddressSanitizer
  Makefiles: add "OPT=" make parameter

 .github/actions/spelling/expect.txt |  3 +
 Makefile.inc                        | 12 +++-
 README.md                           |  9 +++
 kpartx/kpartx.c                     | 94 ++++-------------------------
 multipathd/main.c                   |  2 +-
 5 files changed, 35 insertions(+), 85 deletions(-)

-- 
2.52.0

