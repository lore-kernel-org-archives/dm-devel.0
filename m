Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35DE8475
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 05:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706074569; cv=none; b=N5FT067pPjHgj0Do9MuvvXL6SwUY/f4sAr7fNc3FZAUFXeOmA9lwGR2CJJnSBPTdLxBSxiMCNd/gAjfLKfPs7XtG+OzQjBoT91tI48AL0w2qpOqcELPjsN2pHwfnUlgvWtp+FxwMKU7f88rSYy4DoFor7mwFPbhYskN2Z9eCTJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706074569; c=relaxed/simple;
	bh=v/ix+cVRZOEdhWEOGitbvf7VzG2VcCJT99ME+jnSzMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGy+HhXmYa5A5K/vglOgj3neJfkaKRI8KYLNXBbL3BIPtKqvGyFdYXjOs+gQMNw8Zr4yTSqAapskgjYxAgWNOUjDUlX0ykrum24arNLg2WrnTUnej8d2eFQ9SDawg0hX/xagszsISLzeDZyf8CUwe9/k/rnVDfy2kg/P9vCObGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PkRD4Nf2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PkRD4Nf2"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d71e1d7c78so29027495ad.3
        for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 21:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706074566; x=1706679366; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZ0sCmGXLP/qfV9K0ib2ZteYu2JlA9j0Rku1SRZce/Y=;
        b=PkRD4Nf2+Ontvrd7un+1NEA1Wcx4hfLUW1/lgJb4dyZ9xt3nz27T+ZdhN9dufwGjbn
         xopvgd2NPV2DjUhZyEDM6p35gcKRgHA17nE/QXiXiJNroSBd9nPS5QbKwJihWTh8KoFO
         uL5hOFws8WZXzk6yic8MpefyxbpDq2h0+68THHG22YYvUkm6aGV8YSvMnsCXy0IWDxz1
         7Z91xSiG27rUJUvYssooomLYV2gwpagBC+YRQEZE7P205Yx0m91pZTcwA+y2Q3PSxm37
         XubLViGGjabG6YvN0A/wo3Uz/QE/OKKQiNDlJ/q2QiLKWTn9amQvC1M5ZW1pbNp853Th
         PoJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706074566; x=1706679366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZ0sCmGXLP/qfV9K0ib2ZteYu2JlA9j0Rku1SRZce/Y=;
        b=Iaf1KMMHNi8p0Ea7ZJhc5/j/wX3P+MAF+fvOcHiINiN44HICDiE/LiwjfOjfYJr4Yu
         An7kpufkQ5p2tmGlmYkHnNWD8StXa38avvb1G//tYuarlx8XzqKpIF08lC8VnlkG1yb4
         /F2EA6tldj2vPI5EQkFjdxtXbqPZ9YOibth4jQmZrHIyBf1y0/OZr9lnCYIK8ikfUJ+P
         gpKgVZLRDHtVnRSGwVNB7QtQ/lEsIDXVU1ODyIKZ/zE8R2Gpj1S8hCacdj5y0skvV4X4
         1b95eMfwEYGzqyrvbqnwSb1KPuXNMJZide0TfN3sBgFKVwZvfxFxxE8lmhW1n5KJcADv
         HPQQ==
X-Gm-Message-State: AOJu0YwTZ98SPXFidOUg12MIbBHnyNMhrQtWWTF2psCmYdnMFuJ+GrNl
	GH2th4ga2WxJKBAyPODYl5RV/cywNrEJe0x/viFZtcKXTNg2QASD
X-Google-Smtp-Source: AGHT+IF9xntCNFkSUHl3PujvHK/HRxkb9K/5UgfQmqV1GYtatOjVmSeH4Ik442zFBBKwdkB2ywPk4w==
X-Received: by 2002:a17:902:d50e:b0:1d7:396a:2188 with SMTP id b14-20020a170902d50e00b001d7396a2188mr200652plg.12.1706074566033;
        Tue, 23 Jan 2024 21:36:06 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id kt6-20020a170903088600b001d755acec64sm4015663plb.189.2024.01.23.21.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 21:36:05 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v8 0/5] Fix I/O priority lost in device-mapper
Date: Wed, 24 Jan 2024 13:35:51 +0800
Message-Id: <20240124053556.126468-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221103139.15699-6-hongyu.jin.cn@gmail.com>
References: <20231221103139.15699-6-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

High-priority tasks get data from dm-verity devices via RT IO priority,
I/O will lose RT priority when reading FEC and hash values via kworker
submission IO during verification, and the verification phase may be
blocked by low-priority IO.

Dm-crypt has the same problem in the data writing process.

This is because io_context and blkcg are missing.

Move bio_set_ioprio() into submit_bio():
1. Only call bio_set_ioprio() once to set the priority of original bio,
   the bio that cloned and splited from original bio will auto inherit
   the priority of original bio in clone process.

2. Make the IO priority of the original bio to be passed to dm,
   and the dm target inherits the IO priority as needed.

Changes in v8:
  - Rebase patch 1 on commit 7ed2632ec7d7
Changes in v7:
  - Modify patch 4: change dm-verity-fec.c
Changes in v6:
  - Rebase patch and resolve conflict for patch 1, 3, 4
  - Modify patch 4: fec_read_parity() follow the priority of original
    bio
  - Update commit message
Changes in v5:
  - Rewrite patch 2, add ioprio parameter in dm_io();
  - Modify dm_io() in patch 3
Changes in v4:
  - Modify commit message by Suggestion
  - Modify patch for dm-crypt
Changes in v3:
  - Split patch for device-mapper
  - Add patch to fix dm-crypy I/O priority question
  - Add block patch to review together
  - Fix some error in v2 patch
Changes in v2:
  - Add ioprio field in struct dm_io_region
  - Initial struct dm_io_region::ioprio to IOPRIO_DEFAULT
  - Add two interface


Hongyu Jin (5):
  block: Fix bio IO priority setting
  dm: Support I/O priority for dm_io()
  dm-bufio: Support I/O priority
  dm verity: Fix I/O priority lost when read FEC and hash
  dm-crypt: Fix lost ioprio when queuing write bios

 block/blk-core.c                              | 10 +++++
 block/blk-mq.c                                | 10 -----
 drivers/md/dm-bufio.c                         | 43 +++++++++++--------
 drivers/md/dm-crypt.c                         |  1 +
 drivers/md/dm-ebs-target.c                    |  8 ++--
 drivers/md/dm-integrity.c                     | 12 +++---
 drivers/md/dm-io.c                            | 23 +++++-----
 drivers/md/dm-kcopyd.c                        |  4 +-
 drivers/md/dm-log.c                           |  4 +-
 drivers/md/dm-raid1.c                         |  6 +--
 drivers/md/dm-snap-persistent.c               |  8 ++--
 drivers/md/dm-verity-fec.c                    | 21 +++++----
 drivers/md/dm-verity-target.c                 | 13 ++++--
 drivers/md/dm-writecache.c                    |  8 ++--
 drivers/md/persistent-data/dm-block-manager.c |  6 +--
 include/linux/dm-bufio.h                      |  5 ++-
 include/linux/dm-io.h                         |  3 +-
 17 files changed, 102 insertions(+), 83 deletions(-)


base-commit: 7ed2632ec7d72e926b9e8bcc9ad1bb0cd37274bf
-- 
2.34.1

