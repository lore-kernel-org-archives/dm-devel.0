Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679211CA0
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379618; cv=none; b=upO1h+Ehd1hJDg8V3rkwLoRyECJvY5SoaHFgjaIapjnM+RDko+WWQhX8N2vin7zTVTCa8yhAjywNOUDMxH+iLIbOCespYTbBbp2PzPONpBQZUI6jmlVPP5ZKGdFLOoX87TfKV1dlaL9UZnZ4MzOc5jBH+M6Y8QAUtxVMFgYw1vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379618; c=relaxed/simple;
	bh=1uGxy8X4638nStif0WEt4ugGL+ryA2406c7/XLywv2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wfiy9ySs6wxjkUDfTUV0JIDmq1IaFOf5LE3gfBJnNOEUYA3/HS6fIXo0Q3FpkAFcuCsHBeIThXEQ19eQ0umHlY/FeYptqtyoOipu31SHXKeSmpPUSFtfzzsPSUwukm1aI2AKqnNn7X5ZulEJMMATPTtFjJ675Eq7wJ3LE59S/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RF7eQ+/X; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RF7eQ+/X"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56e477db7fbso15354a12.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379614; x=1713984414; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yWGcPJ10j7EA019asAidHtlcht7Nu3R4xGB+Ok0Rcho=;
        b=RF7eQ+/XJXM99pJ5TjB6A+ywLkpfjpZPc/b0F8BvYvt2hryUYEScTRnGCplvT1wvMK
         U3vohw6iNJKrqBveLK9z4tfz42rFPLLDhMZDFATSZkQA/8esZg618Epp7glbja4P3Wqz
         xgz859sgLAlLLTKPCsDkOys76wjozP9OyV1l3Q7nAylG26dZrpdVPj8vxZYNGU4okMMZ
         ljdFBbUmgZVezPQnwIDjZOTMtHAWrQJz3RdNKfQnLXTa3kdAGo011IBoWeirXK3Wk8fk
         O4tslkub3LlDsAS+EYdom/3htOksy0tra6nAkUq48Sbaxo3ihFdahbos7Qr7wSFe9imy
         vQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379614; x=1713984414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWGcPJ10j7EA019asAidHtlcht7Nu3R4xGB+Ok0Rcho=;
        b=ph7YlhQRmu91Usqsxp+EVMQrxmq8bq1wPRHKuLqnwapvaHtYnmggIqCbBHagbdgpMX
         ZvkjQDJ1p9yipxcnN1gKzyzOXzuuzTYtOalHJ4tmd5L5C/zZazibfrCrfsQ5A6o5vrhS
         1JHNHNOD7vAAg3WEJgrQXrvR4hq0UlYM6yp3uwF9cZGWRdbsD3/Q/754xU4YH7/eE7my
         GDCaPM3mz+NT6QM6myd2U9PCNjqpNcpkNqOVkfbiDqyyMluBytwSikMMy27pTf5IHYkH
         HvdkeUSrovM0hUSswI1/ERljuYFmxQn0/blTJaQXoYF/b19R4HudnVDBPyaYkruFsZG/
         ySqQ==
X-Gm-Message-State: AOJu0YyNZz8aG95uzOfpgd6jIi49AhjzmJgJje6i55b9tKgL6GdqlUVf
	CROIlFd/AmTW7wItwEMScBBgP+vt9MNj2cT8omHftZ1zxvx2vExF/jRF8CtIz6c=
X-Google-Smtp-Source: AGHT+IFr8uvu50etY7CMzMsOMNgJiwqQNGQ/NjtYcfjlr+8EvyVrW6AynJUZnUOI92escZYhpMOBuA==
X-Received: by 2002:a50:cdd8:0:b0:56e:2332:c282 with SMTP id h24-20020a50cdd8000000b0056e2332c282mr298591edj.14.1713379613760;
        Wed, 17 Apr 2024 11:46:53 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id es20-20020a056402381400b0056fe4dff5e3sm7495864edb.60.2024.04.17.11.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 0/8] multipath-tools: max_sectors_kb rework
Date: Wed, 17 Apr 2024 20:46:36 +0200
Message-ID: <20240417184644.6193-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series addresses the issue described in [1].

Changing max_sectors_kb on a live multipath map is dangerous. In particular,
no path device may have a lower value than the map at any time, unless the
device is suspended and all I/O has been flushed. It is also dangerous to
read a max_sectors_kb value from sysfs and write it back, because this may
actually cause the max_sectors value in the kernel (which is in 512 byte block
units, not in kiB) to be rounded down to the next even number.

This patch set avoids both these problematic techniques. max_sectors_kb is
only changed for maps that have the respective configuration parameter set,
and only during map creation or during path addition. In the latter case,
the limit is set on the new path before actually adding it to the map, thus
avoiding a change on a live path. While it is generally recommended to set
max_sectors_kb once and for all before creating a map, the latter technique
can be used to change the value on a live map, by removing and re-adding
a path device.

A side effect of this patch set is that not necessarily all path devices of
a map that has max_sectors_kb set will have this limit configured. In
particular, if max_sectors_kb is enforced by adding a path device, only the
added path and the map itself will have the new max_sectors_kb value, because
multipathd will not attempt to change the value of the other paths, which
can therefore be higher than the configured limit. This is not a problem.
Errors arise only if the limit of the map device is higher than that of
any path device.

This patch set does not attempt to address issues between a multipath device
and block layers stacked on to of it (e.g. LVM or MD raid), as discussed in
the commit message of 8fd4868 ("libmultipath: don't set max_sectors_kb on
reloads"). I think, and my experiments have confirmed it, that for bio-based
stacked devices on top of multipath, max_sectors_kb is not a problem. bios
with a large amount of I/O are split in the kernel to fit into the lower-level
device's limits. Only request-based dm aka multipath is susceptible to errors
caused by max_sectors_kb mismatch. If I am overlooking something here, please
provide an example to prove me wrong.

https://lore.kernel.org/dm-devel/7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com/

Martin Wilck (8):
  multipath-tools: add TGTDIR option
  libmultipath: move get_udev_for_mpp to sysfs.c
  libmultipath: add mp_find_path_by_devt()
  Revert "libmultipath: fix max_sectors_kb on adding path"
  libmultipath: Only set max_sectors_kb on map creation
  libmultipath: set max_sectors_kb in adopt_paths()
  libmultipath: add wildcard %k for printing max_sectors_kb
  multipath.conf(5): update documentation for max_sectors_kb

 .github/actions/spelling/expect.txt |  2 +
 Makefile.inc                        |  8 ++--
 README.md                           | 33 +++++++++++++++
 libmultipath/configure.c            | 63 +++--------------------------
 libmultipath/print.c                | 38 +++++++++++++++++
 libmultipath/structs.c              | 19 +++++++++
 libmultipath/structs.h              |  3 ++
 libmultipath/structs_vec.c          | 62 +++++++++++++++++++++++++---
 libmultipath/structs_vec.h          |  6 ++-
 libmultipath/sysfs.c                | 19 +++++++++
 libmultipath/sysfs.h                |  4 ++
 multipath/multipath.conf.5.in       | 33 +++++++++++++--
 multipathd/main.c                   |  6 +--
 tests/Makefile                      |  2 +-
 tests/test-lib.c                    |  9 ++++-
 15 files changed, 229 insertions(+), 78 deletions(-)

-- 
2.44.0

