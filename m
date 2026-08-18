Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DF8415F2D
	for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039793; cv=none; b=SyCS7HgW/nAcGe69yxg7AtBlH7+/s65yIRz31RSHAWVjQF1wx2WCpDl4aZqZLZEn0aOCldEMfE3sHTKcTgUSkUkJyJWEWGg2uYmBzI428M1M93sP+sxhy+SKrCo0a7LGYrkYOsEeS4vMvcm2e0g8TOFFJTtZOd0UEJ4H4/DzeHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039793; c=relaxed/simple;
	bh=wN1G3VLAri2idzxrKhjPTyRvxBaBzkUIdTu06K5bXIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r6se6c2iWazAQm3aTMP95jzYnKoVQLTHAk/QNyGozbE6rKkkYclxSl0vi7UGizD8tT8akWOUyN036ROfEyaEcOUKztZROQqFLwQAOKe23sxpFptwxSlVsG6yKKvybhSNjbvNBVKzlzmpj06/pCibe9GaZWcbV8i8/N/BazcOEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXhwTyau; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXhwTyau"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e4efb18c9so273179b3a.0
        for <dm-devel@lists.linux.dev>; Tue, 18 Aug 2026 00:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787039792; x=1787644592; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PRpAJ7pRHD4AGRp+qfyl7gvWtz4VOamDAw6BNIILlQ8=;
        b=QXhwTyauQSXIii30LHLn/9OQrzsZBo9JNIZc5Dv0CySpTXm8g29XyMrjeu0dCDTkjk
         FY9tT8/n6/ItZlP0pyKQSPQEcduhJqWoJ+D/iL+ITT39245dGm3bZlFQ7BV2mD6fkyaL
         b94XwDe0cGdFgeukEkyjwC4Rn5JQnDqALPu/QS1ia8RQkwv8CABpG+yV2h76sM3Bj8ws
         W8XaOP313s5b3ASuTt22ryBJmDMKRTaBZYi9T58Y8V7F1G7EdPj1rxRWMFuJmYusgkOg
         EVZqdM4irQhAAFx9WyndUf0CdTSSI/5DLzG4d/FNkht5sBvAhBX/v/mXV7vg7Af2Kh5K
         aS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787039792; x=1787644592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PRpAJ7pRHD4AGRp+qfyl7gvWtz4VOamDAw6BNIILlQ8=;
        b=KiSzfITsUw1rEC5AuKJsXPWgJ1r3iwQnO06ImwzxtCXKDuN1Zp1KoAJuhNtQ6awIeF
         MPfHesXzU4v3DIgq3sRNq8R08xgaLwAH+HLz5urJ3dV/ut/EOcWkAqI+nXt1bYwTUmiS
         ewjl7bQWlyKSKOdTrT0tCk03azM+43Gou6iqYW2MRVEiglIIQTyLJmhPkurcx+J+jNsK
         6d221mIW8cWTZIy0uYqeZbJ5VmflX6bQkN3YzbmKUXTSSAV11EHURCyMCEDJpeCy63R9
         y6vQDtQjtA3u3fuz9QjTiRbRv04jzFXKBKm8216mQaF3HF5kq1bw0nNbluV1JcTO5+XE
         URSQ==
X-Gm-Message-State: AOJu0YxYbL7yn+jdKwS5ZOrojeyZNHeA3b6Nk5tIu9Dj98OgXl59u4m2
	xcAEsNg3YkXEwSvvbuipsqw4HNk7eKHEsRpPo32BE91RmwFUpgbYDO2I
X-Gm-Gg: AR+sD12CFrEt/3YPk/3M9m6unXVEMGmuLGCmIOim9yRiUykaFWQ8tYkShigvqxz7Z7S
	gSW5XpukWAnByKfm4maXeSMmnZ60t03B787H4VYf01vd9L4q+l2D1mojXmI9VvGwEE+ITGHGj7C
	rw7DjZPEP8Tc0F2a99IynXSYkI1glczJnj1Vnuq6QXXdvpm8Da9276ICOwlkZNfXjfHkrRpsY0o
	JC53mWO/bDlWDbVH8nLSZ3B1TWk6ejL767/yMnZms2qP/8P4v7k1FZb6ttlE6aM/zlkXZIculmM
	nKBb1nYu2/Tcug7qf8mQ3MTDQ5TM4bU/e1b3df5qjbw9R9j5H3UBMS7w1lbgybtqWAhYtJBAj5q
	n6oEAZbPEybXIuxglwzOjoJowWQpVGxYTuNO4sdqjFnEwshofPnCApTDWfKyArciA4XgDMgC1gq
	ZRa4FD1FToAKpQZS1E4kdzCfOg8cvy9n8tpVhtlfLR+MGZaKS5DcXgI89kE32D0vKja4cOhtUUK
	c/sEGX3JY10
X-Received: by 2002:a05:6a00:4a08:b0:848:5451:cfa8 with SMTP id d2e1a72fcca58-84fdde1e2a1mr16658748b3a.0.1787039791703;
        Tue, 18 Aug 2026 00:56:31 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6ff0e3csm1213879b3a.60.2026.08.18.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:56:31 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [BUG] dm: unbounded recursion in dm_blk_ioctl via cyclic DM stacking
Date: Tue, 18 Aug 2026 07:56:27 +0000
Message-ID: <20260818075627.322-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hello,

I am reporting unbounded recursion in dm_blk_ioctl(): it forwards a block
ioctl to the underlying device with no depth or cycle guard. A two-device
DM-on-DM cycle then re-enters dm_blk_ioctl until the kernel stack is
exhausted.

Summary
=======

dm_prepare_ioctl() lets the single target substitute bdev via
prepare_ioctl. dm_blk_ioctl() then calls that disk's fops->ioctl with
the original cmd/arg:

  r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
  ...
  r = bdev->bd_disk->fops->ioctl(bdev, mode, cmd, arg);

linear_prepare_ioctl / flakey_prepare_ioctl just set *bdev to the
underlying device when sizes match. When that device is another DM
disk, fops->ioctl is dm_blk_ioctl again.

Table load rejects only a device mapped onto itself
(dm_get_device: dev == disk_devt(t->md->disk)). A->B->A is accepted.
bd_link_disk_holder rejects only a disk holding itself.

Ordinary BLKGETSIZE* ioctls on the same cycle return cleanly (handled
in the block layer). A DM-style ioctl (DM_VERSION) on the mapped
block fd is not handled there and is forwarded unbounded.

The shipped PoC uses linear + flakey. linear<->linear is expected to
recurse the same way via linear_prepare_ioctl.

Affected
========

- Confirmed on Linux 6.6.144 (da47cbc254661aa66d61ef061485a7080305c4be),
  stack-protector guest
- Still present on torvalds/linux master as of 2026-08-18: dm_blk_ioctl
  still forwards with no depth/cycle check; dm_get_device still only
  rejects self-map. The later prepare_ioctl forward flag is for
  target-local handling, not cycle detection (linear still always
  forwards)
- Files: drivers/md/dm.c, drivers/md/dm-linear.c, drivers/md/dm-table.c
- Config: CONFIG_DM=y (CONFIG_DM_FLAKEY=y for the shipped PoC topology)

Crash excerpt (from minimized PoC)
==================================

BUG: TASK stack guard page was hit at ...
CPU: 0 PID: 219 Comm: repro Not tainted 6.6.144 #1
RIP: 0010:dm_prepare_ioctl+0x10/0x100
Call Trace:
 <TASK>
  dm_blk_ioctl+0x4d/0xe0
  dm_blk_ioctl+0x78/0xe0
  dm_blk_ioctl+0x78/0xe0
  ... (dozens more recursive dm_blk_ioctl frames)
 </TASK>
Kernel panic - not syncing: Fatal exception

Full oops and a self-contained Docker/QEMU reproducer (poc.c) are
available on request.

I am happy to test patches or send the reproducer package.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
