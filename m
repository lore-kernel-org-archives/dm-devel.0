Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449628E57A
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644780; cv=none; b=jyLFu1dPU05q2ch4c+w6rPdKnveAXZNewDsZwMX+r2tWCctWALra4rbcshUGfOfiscS4AYJx3M+bPGHobpnUwLzjMVT2ZtZP9+zLO4AiUUWYDqJDTvC3ay6ZhS+k6e69aVTTXgSMPKSBZ7xLtM/sxSsZsstXgPuSF6ybwPvTiKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644780; c=relaxed/simple;
	bh=hvbiUtx3t0OrJh0oUjBeNSDoX6VksXzq7UXHcPIIBsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oL6Vr8YpOlrrCox5u2/UNd+lWxhvE/NuBCM1Xo15CJX6syVJ9spKCtfaukgM9KJ9c5GY4gBTkypJT4aS1rDAsnxz+LFdAnP8Jv5S0MC0QksK1iPvXPJ/YLmGmlHOBOB1MMYLt3HQNN2lUJ8KJNdVkIgBDiOTNbxEgyYiIK62/bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FkoqbPJx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FkoqbPJx"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso1091205e9.3
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644775; x=1747249575; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tTXBchVZ2nIe4VAmigq6vgtN7wr1yXMwsd/WhWjwNBQ=;
        b=FkoqbPJxSfhw/lt6YssrWI7VU441Pb2hJ+yrI68lIVeRb2O+3wIn9Cor/cngrZQsb9
         kv5mqn9iZDC4fIpholWMCXy2HHQ9Szh/3jZ+mHzA2hdvu9RgtIuAYuH+RRg3nYAKpBBg
         kGC5QZUsDorYt5HCdkJa5Fe6pG6hQWq1M/qcznpzYoPi0ruRdLN8Thofh6kq/1XKCWte
         n10LiaaYmW8lnscBkvaK/heUH9a0a+94svT0i6PzfkpKkkaqZsypxDbNUSgsfz8JGSZJ
         3g9Dzel0Ef2xxgkslXBAepG3XoJNEsqW3KFmGwTL/6ApXYjgatMdEnjesO2IaBzcE/jH
         Jc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644775; x=1747249575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tTXBchVZ2nIe4VAmigq6vgtN7wr1yXMwsd/WhWjwNBQ=;
        b=BPBpCiC1DsraS2oMWTgqS2/PHraPM62S2FTJH1N9TwbGCW8dXYV8lnrmBt5APOveQs
         QgMwEb9b5LCtWgMEpj2t1pDDqsCfT51lnlEBjwOJVT1HDjWZfC68mMwjArggVpWhtg4Y
         3zVLLtSyvNTfU/v+bKDpRLsSQaFrrpsKIY2SlMub7mSL01qiKQAJ7rpX0xZ64iWkjwH/
         GJXnO1lOdR+b8cG0P24OmYI07evZpotyXb5Kg9ucLz+3s9Q5zzGil/ucGisrC7LtEoar
         LzA4kXT3i/IRj2NVZylkNYO+zx9lWjzzYVLDLQPbwrnY3hIFaRdwL43PLg1280MCzE6/
         OJZg==
X-Forwarded-Encrypted: i=1; AJvYcCX/OVGcDhywwc2J3e11E4Xwdgpi6Ioo51FUedTKa4v0IoGX/6pQ0+e3oVbtQ1BTZxA3kjiFRQSWdg==@lists.linux.dev
X-Gm-Message-State: AOJu0YykLbQLl2Dq67zdwuYXSmtQPx/O7m/QoM4mOZo4KwuFksHDcQ8l
	y5ay3PuMtH4gKzDnJ9OVQ65Ze8XIdxi0d9MznXtIIFgdHGXHAH1w7WoRdJqfaFQ=
X-Gm-Gg: ASbGncuBUNvfykgA3G2yvQxN1gP7d0n28+Dk3AXy1KUqAyH6EcjPUrA5qKIVWEfjNa7
	rVNnSKCx3QjDlGpeTm3wk8R6vXyfMOc8nQcrmQ8OMuTpQpiKzOP57vgIoR05rKgq67QwagBRMOy
	gGvCMd99QyPvHtBzbi/8LTvH5VxfyaTCefxWWgHIrfq8ZhtQB8GtH9bJhdkxu7q7QhMHIYGeS/p
	wzMeW9OcHj7shFDSPpEQy4rEGqlm5DqWbQuv+niT2Z0BFMbGHj1Mu2h42YQ7b4P+76yXsQdKpgw
	eBrjOzy0DDaqHt2mGJw0pRHEasUdR5SoH+e57c8LhovEuf20JtT1yljqgz1+Ch7E1T9XvNY61vX
	buheVlxlGMglaTxNSQJVAiYhVBEI2VlF/K8L9J58=
X-Google-Smtp-Source: AGHT+IGdPTadybJpGHbeXbOcJQWdzszpvQU6yitm1Ib8SZ/HGrz8YzVHNmCUaopnVQePQGNs9EmjRQ==
X-Received: by 2002:a05:600c:5127:b0:43e:afca:808f with SMTP id 5b1f17b1804b1-442d035007dmr6881895e9.31.1746644774528;
        Wed, 07 May 2025 12:06:14 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442cd331281sm10114105e9.15.2025.05.07.12.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:13 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 0/8] multipath-tools: static analyzer fixes
Date: Wed,  7 May 2025 21:05:44 +0200
Message-ID: <20250507190552.209637-1-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Xose has kindly informed me about the warnings from Fedora's static
code analysis tool.

I'm sending a couple of related fixes here.

In the cover letter of v1 of this series [1], I'd included a discussion
of what I considered false positives, but many of those might actually
be real, as subsequent discussion with Ben Marzinski has revealed.

So I'm not repeating this list here.

Regards
Martin

Changes v1 -> v2:

- Added links to specific anchors on the static analysis page in
  commit messages
- 04/08: replaced this one after discussion with Ben
- 07/08, 08/08: new minor cleanups.

[1] https://lore.kernel.org/dm-devel/20250505163007.59352-1-mwilck@suse.com/

Martin Wilck (8):
  kpartx_id: fix shellcheck reported errors
  kpartx: fix file descriptor leak
  libmpathpersist: fix memory leak in mpath_prout_rel()
  libmpathutil: vector_del_slot: modify v->allocated if realloc fails
  libmultipath: fix undefined behavior in 31-bit shift
  libmultipath: prioritizers/iet: fix possible NULL dereference
  libmpathutil: remove vector_repack()
  libmpathutil: remove VECTOR_DEFAULT_SIZE macro

 kpartx/kpartx.c                     | 14 ++++++-------
 kpartx/kpartx_id                    |  8 ++++----
 libmpathpersist/mpath_persist_int.c | 12 +++++------
 libmpathutil/vector.c               | 31 +++++++++++------------------
 libmpathutil/vector.h               |  4 +---
 libmultipath/nvme/nvme-ioctl.c      |  2 +-
 libmultipath/prioritizers/iet.c     |  3 +++
 7 files changed, 34 insertions(+), 40 deletions(-)

-- 
2.49.0

