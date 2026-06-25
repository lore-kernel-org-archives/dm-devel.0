Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0D8334692
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403338; cv=none; b=KWhIAcDEp6Z31QH/JqkFZN7rNhSPeA+Z9fj8DfmcBQdR0jv+PhzS4iJsH8hT8l/tqQmVphmm4NKhJX/WZgZpgM9sxVtbj2v0oLIvdoZKb3Sj5iNZqIOZmuHIYTGQ3g/rENfbVB/kPozsZJVDIEV1kW7sEu1yLxKS1D2yw00pCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403338; c=relaxed/simple;
	bh=M7Ezf5o8BVL6KLyirasY1sMEEL2diFcOS9VRYfH/uVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PT8Ot5lsbdZBcPEpBL9KnvHOGn93bFk2fZ4PTDet1fRXqBJHNUqVx10UDNe/Cz8J7VRkFnjLEYwnO/Bvqwzf//hQsuLDjIhBjU9QzOWoIHncv0yDACPIpK02EoPOPBQbRT2c4nyIEDeXmpQapBW/zgPxQuF2VWlmpbWAbiWhHOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YrkIM7mD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YrkIM7mD"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-491609cdd8fso89645e9.2
        for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782403335; x=1783008135; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=weykOk8NaqTHh7np0O52d7ROMdIgYqDJ2SotYJGhKrg=;
        b=YrkIM7mD6WK5pFfnxZU2HgL+O62JVbZFdeNh/EXYR5cJEDuqSuWl7T9XA+LQmo63R4
         QEiOr/rr7tmBKaLfTaUwaO2Dg35Fjk5nlMEWCJx/amWoT7MULMoK/4qtnVBtd4VAVSU8
         //gaES0Sx6oNM5HhSStDHsSmLN8/v/udADIqaMvvoID+I7+4hGFZsSK+9GGghu7KsYpR
         vhHD7ewsA16480qpot5RD7SHwTwnLgqeeG+cBFak5DC6oceRhKdC54nqQb2LkaGVhrJE
         YZnU4BExkFQwa2397lGUUiq3+S8r3N46rDvMHE69g45TZJubReRoort4RBp7/kFEW6QM
         DUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403335; x=1783008135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weykOk8NaqTHh7np0O52d7ROMdIgYqDJ2SotYJGhKrg=;
        b=kPD9vZCTbT8z6OQvvOhhcHeVzXWSFJsdoKvZYvtTSkOB7DzUrYF3sYrrYYGWdDrrxb
         2xZ4cecbhwZwE6mUeOdkW8hYN3c2PanwZD9+ZxOAicdr8nGcX8f8FEM8aV3YjMdF7zAJ
         fbHrrHzNXpCcDHY4qsF0qlegREcvQdRjyT0cnbN+k2HalZl7aWrZct7STfw6DwZJrM1q
         Ie3fjGyff94Av9BifpK7S6IQmmaXdscV0x4frIY6XPBVfklF6ULG/QS+k5xh+z+fJzWk
         Az9SaeNfk+ccHVeJpgDFK+acoQoFe4YdicsYb4jA1XDEHGzWmRdWzqmvgFWOSRPmBQpG
         TlkQ==
X-Gm-Message-State: AOJu0YxDszsiqOwWPHOwjO7wGKO1ECf92I8IoU0o3rKvx+i3bWKznfW2
	6wrYydMlk4L6O3QoTDWpKahdj25U+MO4f63NZFw1/pRfyVl+uqzjHj2EeSbNjWePcIc=
X-Gm-Gg: AfdE7cnsayJZRRE4jdfadIlPCnbOHIU5t/U8edrxs1jHWitUXe/xqJ5e5H8lpPmcPRt
	UcIYEmNz83J0sfiXTuYQzkwP7MCGmMiZKp2pwUJN1UKWxz+TGxhZjanlYbYQBqSvl/S/CBMDkwE
	KDVrL9W39b59HT8Ee2VcmBLqPRgu+JIxJNgIbkJykMAik+iicT91ap37sZhCO2o+lvA/nif1TRE
	zGiPF95HU9/EsOrO3Z5MqQkn+wNBsdLcOh3Nhjk8NyO/3s0p30vqkxhyJzPmsjpSoB6SLSZx4sH
	vG68SCiPpyIp/MEedvmQHuaPDrGHmd4hMgwkiUAjw5UZM9dx8rTx4P1S2nOIWswfi7cwtNY1N+N
	TbXOGtFB1xwDz1VO0MC2I0Yvvx0f3aas7LloxMEroDr5xiXv9mlR9Bn/pT9yfr94ZjZeaxjVpjv
	zBLZ2bF1EJL6RMgs0Z8BOFJNJgwwlo9/ocxVDwG/HVKeDVvrbvEoNSnGoE5+EgIkMzvm1O8NSgh
	uE=
X-Received: by 2002:a05:600c:c059:20b0:490:adb6:793d with SMTP id 5b1f17b1804b1-4926689fb12mr37610825e9.26.1782403334648;
        Thu, 25 Jun 2026 09:02:14 -0700 (PDT)
Received: from localhost (p200300de374611012220024a9e5877d9.dip0.t-ipconnect.de. [2003:de:3746:1101:2220:24a:9e58:77d9])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926541e03asm65052275e9.2.2026.06.25.09.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 09:02:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: unit test fixes
Date: Thu, 25 Jun 2026 18:01:56 +0200
Message-ID: <20260625160200.3318088-1-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a few fixes for issues recently encountered
in the multipath-tools GitHub CI.

A couple of additional patches, related only to the CI itself and the
GitHub workflows, has been pushed to my "tip" branch [1].

[1] https://github.com/openSUSE/multipath-tools/commits/refs/heads/tip/

Martin Wilck (4):
  multipath-tools tests: add wrapper for fstat() and fstat64()
  libmpathutil: runner: avoid segmentation violation in pthread_cancel()
  libmpathutil: runner: pause in cleanup handler if rctx is NULL
  libmpathutil: runner: use pthread_cleanup_push()

 libmpathutil/runner.c | 43 ++++++++++++++++++++++++++++++++++---------
 tests/wrap64.h        | 26 ++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 9 deletions(-)

-- 
2.54.0

