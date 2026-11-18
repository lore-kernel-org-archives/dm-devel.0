Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022514;
	b=1Yu7AS5Bzaok38gEQdGvazWDvJh9VgT+KPSSL/Nc9pgKTfskxKlMrtR/wb/vb0KO22/x
	 WruS08OqBBNGuCVAavNB22MFYg7TuowlAqf3+p7HEhvsCuE/0TXgXBCw9GETc1JTAsvwC
	 vzgCaG8v4rdD4YUil/q26THurPPeif1SPZEuwXHoMna0TJlm3sL+3482RKNO/poIRMkpr
	 4ntXAaIwC638bRvl3gvuZBrMoZh7OqnqXtaHFJrq3Rk/KvYdPSOYMsRMwnH8ijDQmWj/Y
	 Ak2U6vUH+ZVJVnhFsZueEkBqlCyacPB/Rg45iB23GAyR11pVc1HHWb6mwH9v8EHGH4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eQlqtTqVo4i1iQMXfdZwTxvtktVIkuGgoTezX3fYfUw=;
	b=RK4O4FNV80BnhafDv7jWvDK8zkPOmrXwRUGpm/zTQRYq3Wmra93mC5oMuE0H00AUyD/u
	 JCAmEw3Kz1nrl5nHBk9XI2h+2dPFnGVYeqEXn6wnND+JY4W2+tM9rtbbwsHIqCgAFQxt5
	 VmX9CCsx/ZxEf7DqpHaRatjGmfvdbcjwPkZyg7MCQuw8s1csEAR7sdSMTdCb0vgnkyAlc
	 bL1argidGge4hOvqToBTJla/2yyzzQ+n1Q3Xinmy9CnvEsUnG3IVBQ4oFOC8JbQPHJfkF
	 HlBwlGeqyuLSE/7hApOtCJ4OALKpMQmWhjicQRP2yoTh1Y0oWCMKv24todmRrueU1kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wxs4Jn9j;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E6E606A31C
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:21:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8E6E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wxs4Jn9j
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b197cd42b0so850305a91.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022513; x=1795627313; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQlqtTqVo4i1iQMXfdZwTxvtktVIkuGgoTezX3fYfUw=;
        b=wxs4Jn9j5smwVANVSle7n81xWKszLLlljaJtyT27yTCMHSVE4zPeVztq4l5gs0w256
         uBqVsmXVEHHhNVN9jnh488+rNh3LRmQzCTVINWwagPRZvP/fcQrJS7DIR91rBYcq6CrA
         d6trT8kzWMg1wc9/0PcB1aVRZaM+YooaZTCXpCxbzx7sxskypT1UP83HQiiIMM1/L4Lf
         5pkpLhywniWKE3d0MKzYmPSjuFN4/id1pN1ZpKmEXEWWZHiL+itrffzk1qVsvu5w3a9b
         c/3FqFYyJCKA3Xv6p6G0QUJV9lG32Ih4/BAzREklvA0Dcutuj2TcnZ8K3vbzRQcDoF0o
         roqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022513; x=1795627313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eQlqtTqVo4i1iQMXfdZwTxvtktVIkuGgoTezX3fYfUw=;
        b=1QS22F/CgsNjlNjlHb7SVqOVfyOyI2LwcGO2zdgii+yH6kRZqHLmbz+KXNPvcKiHSy
         5NVj7PfwA6M8KKH2g4Ckm9ft/VLyei0188Wyr1abgTgpn3njH2swp/7WePFgvLFPKMYX
         KL2uHOfcXKKoNXqb/GDRWfg9gGRaaPO/hqJLU9CsYKTLle+BAZVGg5HvrNzpZFC0q5iZ
         H+Ei3FeHWcdqOXhPp7KhXODRyBj/iEhbMciyKE2Rz0yDMNe21Ir13qYOhhEKyhhCWrt+
         6CueJrbp8abLDzQWCxY7JhzqaVzw/ndi41KmfRo2wufDjC5esgBadiE/u7moo90TTHUT
         tPGw==
X-Forwarded-Encrypted: i=1; AL+hErHVGQv0eXrbWmdBt3mZ4EjCssdV+8+B/t0IvFhMOdQaozLzTC0x6gUKxTnS4jblhShHtVi3XS4n7A==@lists.linux.dev
X-Gm-Message-State: APuU4Z+UUerrpY+xj6aNpYDUMr+30YOlqDDzra80mdQJqGff8ZjQ5UVF
	v2E9AAa8P8iER9g1ZX5bncMJzxDbmzowjCDJsVoT1aBtT5nCL5l4WSTYzfQJljif
X-Gm-Gg: AZFdTZftoLnBKzRSTajVgdFL4p1Vn2XwtjB+YnJhbU8LPokqB/Io78G4MQZQcruU9p1
	PAyXo3ukIaLaABH4n4N16v+sOD5offUZmSMYyDsqedaVkNs1/VoPnTLHClaKyIDxDQrimHuUTf9
	lT0zvEGewol2vGguq7ARrHV88ZD55AZuHYQPOCSpmcBGEM1ynMGuqiGHGL9G8afjg1EcwyuWEGb
	+RkQHm2CfuK+c7eH7dKcM1sk/rKMxX/zO2ekEuCpgMf9vo0994b/AA1te2lO/CMX2KBfDMWbfe1
	f9v7YJNJSETg03IiEiJ3Dy3NvOOFsbHPLLPdQ8lxuK6SxsqliOI+JYztPKAku5UZ5kgJCGdv2Ck
	5SafIGri3rbH9yAYV2CLfXn39jQXW6hVPMEoBOZyB7+2X+8kqH3LhYtastw77vDgPUXrq/gY2/L
	HLGHgmdXI6tzmj6PzEgbAtlJq6brnqTaIW5LP5f7qY2aRf25tN4mehyhyfD+UeqAmHd6CillA9y
	6MGQHkB565NlmwuRK8Zg44+EDP3BmeSciGB7vwzflOMpeB9w+R5adl58hkl7SKjgK6rH9jM/QHc
	inDwdBDOXyLJ8sWW/EIELfLPI4fLCHUgleTfqIOMFOCdXFeJIzZU1PH8Su370umHzKxJuX4kqFy
	qJr8SdY9f
X-Received: by 2002:a17:90b:5643:b0:3b3:a74d:f848 with SMTP id 98e67ed59e1d1-3b3d076335emr2832306a91.15.1795022512854;
        Wed, 18 Nov 2026 09:21:52 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f7067012sm135659a91.12.2026.11.18.09.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:21:52 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v2 0/4] dm-bufio: per-client retain target, sysfs and dm-verity cache control
Date: Thu, 19 Nov 2026 01:21:30 +0800
Message-ID: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

Device-mapper's verity targets read their hash trees, and FEC parity
when FEC is enabled, through dm-bufio.  dm-bufio has a single
module-wide retain_bytes value shared by every client, no way to see
or change one client's memory use, and no way to warm the cache ahead
of the reads that need it.

That fits poorly systems with many verified devices of very different
sizes, such as Android, which mounts a dozen verity partitions plus
per-app verified images: a large partition's hash tree (tens of MB) is
evicted and re-read under memory pressure with the 256 KiB default,
while raising the global value would make every small, idle verity
device hold memory it does not need, and would still be the wrong size
for most of them.  The same system also wants to preload a device's
hash blocks at boot and to release the memory when the device is no
longer in use, which today requires dropping caches globally.

This series adds per-client granularity to dm-bufio and lets dm-verity
size and manage its caches:

 1. Move the retain target into struct dm_bufio_client, initialized
    from the module parameter at creation.  The parameter keeps its
    meaning as the default for new clients.

 2. Add dm_bufio_client_sysfs_add(), publishing a client in sysfs
    under a caller-chosen kobject and name, with a writable
    retain_bytes and the rest of the state read-only.  It is opt-in,
    so targets that do not want it pay nothing.

 3. dm-verity: size the hash client's retain target as
    hash_retain_percent (default 10) of the hash area, and register
    the hash, FEC parity and FEC data clients under
    /sys/block/dm-N/dm-bufio/<hash|fec|fec-data>/.

 4. dm-verity: add messages to report or set a client's retain target
    and to prefetch or drop hash blocks, for warming the cache ahead
    of use and releasing it afterwards.

Nothing changes for existing users: every client starts with the value
the module parameter holds, and only dm-verity opts into sysfs.

Changes since v1 [1]:
 - Publish the sysfs directories from ->resume and detach them in
   ->presuspend, keeping the kobjects until the table is destroyed.
   A table reload then publishes its directories synchronously with
   no collision, and no kernfs drain ever runs while the queue is
   frozen, which would deadlock against userspace (udev) probing the
   suspended device.
 - Round a non-zero retain target up to a block boundary, so the
   target keeps at least as many bytes as requested (Benjamin
   Marzinski).
 - Compute the percentage with mul_u64_u32_div() and clamp the result
   at ULONG_MAX, the same way dm-bufio sizes its own cache, so a
   large area cannot truncate to near-zero on 32-bit.
 - Zero the kobject after a failed dm_bufio_client_sysfs_add() so a
   retried call cannot free the already-freed name again.
 - Destroy the FEC bufio clients before releasing the data and hash
   devices in verity_dtr(), so a concurrent sysfs read cannot
   dereference the block device after it is put.
 - Reject prefetch_hash on try_verify_in_tasklet devices
   (-EOPNOTSUPP): their no-sleep bufio client cannot evict or wait
   for a buffer still being read.
 - Accept prefetch_hash/drop_hash with no hash blocks (levels == 0)
   as a no-op instead of failing.
 - Document dm_verity.hash_retain_percent= in kernel-parameters.txt.

Tested on a VM running v7.4-rc1: message and sysfs write paths, the
shrinker retain floor under memory pressure, suspend/resume cycles,
table reloads, 100 create/destroy cycles watching slab counters for
leaks, and error-path injection.  No kernel warnings.

[1] https://lore.kernel.org/all/20261117131918.2745193-1-yangyongpeng.storage@gmail.com/

Comments welcome.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM

Yongpeng Yang (4):
  dm-bufio: make the retain target per client
  dm-bufio: allow exposing a client in sysfs under a caller-chosen
    kobject
  dm-verity: size the hash retain target from the hash area
  dm-verity: add messages to inspect, prefetch and drop hash blocks

 .../ABI/testing/sysfs-kernel-dm-bufio         |  76 +++++
 .../admin-guide/device-mapper/dm-bufio.rst    |  54 ++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 .../admin-guide/device-mapper/verity.rst      |  43 +++
 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/md/dm-bufio.c                         | 200 +++++++++++-
 drivers/md/dm-verity-target.c                 | 292 +++++++++++++++++-
 drivers/md/dm-verity.h                        |   2 +
 include/linux/dm-bufio.h                      |  16 +
 9 files changed, 688 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-dm-bufio
 create mode 100644 Documentation/admin-guide/device-mapper/dm-bufio.rst

-- 
2.43.0

