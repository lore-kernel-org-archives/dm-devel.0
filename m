Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281597;
	b=LQqS5Al8ZpXMUQJrEYv1EKCf6wUOwZtKTd/7Qs4TO04qXgiFSSzXN2AP6MDKbxPUG4u1
	 QFKSGdiBN2tJFMdQBoEk2I0C7yC8+/APXQL1pwWlD1ZysBqxACOvPK8SywkzXNipk9eNO
	 qHwkuWbV4nbpVs4NvRNRR2ns+rD+7HkLN2SS94QsePaDnkO+t6SQsfdVH1GuwvVt+6Zuz
	 2noQmBqTCicGn5faAWfk375Wlkjue7Dit5gkkYJDqLSWdwNKj22KzRbDxhqSRnymkHimA
	 pKI58GjDrr4MkcYNiqZNSwQschcNav6g5wba0poRoQJSW76+kMtAaW6RdeM6xSK/m3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ms7mHc/NUhcpkwZ2yqGXncVCv0Whf63AvrYJIlo5jPY=;
	b=NH5yYXV/BdAjWrtQFnvwZz/01edVaR9sjQOVeO713vX1bjhx2ycD13PSNbDlbzYKjDKN
	 CmTvQgxWxXOYkqONRlezN6mXIOV+6TFJPJo/WIuE3gIuj3GV1p3LPCu+GFbKygrqOS6X6
	 HqAI6TW+3LLqtR1FFfgJfGv4Kj1zfnCBYV/71XdvWkHNckehDghRxsKzG4uETmRq9YPH7
	 tRHPBvyPpjmyQqy90QlpSqWZ0PICQga16FhG9NdViLW+5eiLXZzj1UiHCt0TKJcz2DQFE
	 rQBys5w1UwTBUairK5JKYhiqDnC9yq+iXZa1yJPtyGwY58K1XOKJm5RvCjMj+3f6F9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSEPaztJ;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64D606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF64D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSEPaztJ
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8c20d68c83fso1760410b3a.0
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281596; x=1795886396; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ms7mHc/NUhcpkwZ2yqGXncVCv0Whf63AvrYJIlo5jPY=;
        b=qSEPaztJVPzN1hzSs+Bz+XC0Hw3BODjizXEgmfb6lQfnfe61T9/ViVAmM8tGv58BQB
         95BA8dLw5NG89hZDwOlptzUP7hv2DF0YitC/rUx1hkhKFf9rIrJAuDgXMsELYugeSA/t
         BCzB0/p/j1xDGMbU7xrjnDV7WaDyNeI8Rhz6r8sNxCqkWwXnyoFo58s0hszC8xpcOlRA
         qZE6Q/NcqTe0E7b88V2U6WtjyIA6dG21QXA/Gkm6qEUK/UrticOuRO0Awa+5iigZ2Zny
         L+Y8YIGWbBMmsEoAzoFgyTW3afD07IGjkos4Yotm+2P6jUHLub27Jtbh8lE7A4ydJgYc
         1mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281596; x=1795886396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ms7mHc/NUhcpkwZ2yqGXncVCv0Whf63AvrYJIlo5jPY=;
        b=Cj+rbg2d2K3TqPo1mVVYrBAN8ls3RmfropvPre4WtGRo+7HPPJFaZKRp16s0/fRehd
         nPObk7tT/gDhE358gVEEI7x0MtlU54r3V/dbPFV1WdC5FIk6Mj24X9RDrxhfOQ9sIrXi
         qvurPTwgOQSto1ZAPZi6zhnx369YG6SgMAYS5CY/rIg2Ut04tTAuM36J+v8wFjSKm/F3
         4ISLZ6Zz8uxp3eQFwyLFhRg8m8nJY4/4ZT5yVZljD4xEJEGQC9T6BpMRa/kykzfxsNeo
         T5xfSJLdk7FadIoQm3vrHj8i3U/Gmi2zfaW/oCcaU4O+yTL4xyV5+9+pPOlv6ae15f9T
         rC6A==
X-Forwarded-Encrypted: i=1; AL+hErG1pCsItJW1XXdPKEOb0KLuiFdqSyzU1WqOL7mg9zlap/J9FPtKWPkcgDJf4o2N3oeSOyU5NixZnQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9Ii4DOLVfzCMZHnVNsZYgRjm5WXgVxpbRQEpvugumnIWPiHHS0
	mJr8aBF9KPg7x3vcG3R5gXZH5SVo4xr0wk+XfVCQSzBPTbORoF2YgDY5
X-Gm-Gg: AZFdTZdmP6HvmyUAdANsqG7XPjpuRCAwr+ZSh1dwj+UtVU4hlhI0tzpRFU8vhbjn69+
	cyWrlnrFhgKABznp6okdgBCuDuEdvOeCrIuOacFtTAri2qBKo9MpmVyzNeno56IJ08ddo6qDjf2
	MAeQsXDSMt4+ypZ12qdZuxHkGHntos9STF+lT+6KFvHZD+UBscQWwfViq1U5yaUh8qIy5i/3Q/h
	r5TNb2FgT5sNml0TpMCpRmS0J1x5FmclSGd6zsst4oToZhT3xB3KuzpduplpQ7VqBmLCpiF9dD9
	VC9ZaYW2y+mi+k3vjaV/wAXmyg4D0IEz0YRvlYNjGshZQ/x6GSHprpNFASEKuDFG2mFnYTr47mX
	n5SDNNMEppHGfMTwg0+uYC1M2teQpyXDo1OFEI9K6VnN254t4/FtPJyNoWlsbINl4lNB7lNBu6v
	Sdg9v7NmpMvRSnWJm8+k0AMMVgVa2xoqiVg4Nej+GNjyQ92w4qyZHDm8oC2+13DkMqVuUEI8Oxp
	yH5qFKR1PhPdGgJuq5ZkKVM4l4PG4VPTolISj0idGSTPvpLINtE9PTmEFBPXcfUqJ/w1k0cXpWU
	LSVC1Kb0QjQgkFl4ROJK9AOB+KlclXzd5YCG+coQKihyc5jdJx7CGTbZ/UdLZt19zb3QJWl8TcJ
	/ZqD9wFwf
X-Received: by 2002:a05:6a20:7d9b:b0:3e2:b995:fcb with SMTP id adf61e73a8af0-400aae3d038mr5779966637.1.1795281595728;
        Sat, 21 Nov 2026 09:19:55 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:19:55 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 0/5] dm-bufio per-client retain and dm-verity cache control
Date: Sun, 22 Nov 2026 01:19:30 +0800
Message-ID: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
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
per-app verified images.  The hash areas we see range from a few MB to
tens of MB: with the 256 KiB default, a large partition's hash blocks
are evicted under memory pressure and re-read later, while a uniform
large value makes every cold, idle device hold memory it does not
need -- and most verity devices are cold most of the time.  What is
wanted is a lifecycle: prefetch when the device is about to be used,
drop when it goes cold again.

This series adds per-client granularity to dm-bufio and gives
dm-verity message-based control over its caches:

 1. Fix an asymmetry in dm core: __dm_destroy() runs ->postsuspend
    without waiting for in-flight target messages, unlike
    __dm_suspend() which drains them with a final synchronize_srcu().
    A message that passed dm_suspended() could still race the target's
    reset while the device is being removed.  Every target with
    messages currently masks this with a private lock (multipath's
    work_mutex); verity's new messages have none, which is why the
    drain is needed.

 2. Move the retain target into struct dm_bufio_client, initialized
    from the module parameter at creation, and export set/get plus a
    cached-buffer count.  The parameter keeps its meaning as the
    default for new clients.

 3. dm-verity: size the hash client's retain target as
    hash_retain_percent (default 10) of the hash area, so a small
    device keeps little and a large one keeps enough.

 4. dm-verity: add the retain_bytes message to report or set a
    client's retain target; the reply also reports current_bytes and
    buffers, so memory use can be watched through the message.

 5. dm-verity: add prefetch_hash and drop_hash messages to warm the
    cache ahead of use and release it afterwards.  Both are rejected
    with -EBUSY while the device is suspended.

Nothing changes for existing users: every client starts with the
value the module parameter holds.

Changes since v4:
 - New patch 1 fixes the dm core hole that the message check leans
   on: __dm_destroy() ran ->postsuspend without draining in-flight
   target messages, so a message that had passed dm_suspended() could
   race the target's reset during device removal (sashiko).  The
   destroy path now mirrors __dm_suspend()'s final synchronize_srcu().
   Reproduced with a debug-delayed prefetch racing dmsetup remove
   (WARN_ON in warn_leak); clean with the fix.

Tested on a VM running v7.4-rc1: message write paths and the memory
reporting in the reply, the shrinker retain floor under memory
pressure, prefetch/drop lifecycles, suspend/resume cycles, a
prefetch-vs-remove race with a widened window, and error-path
injection.  No kernel warnings.

[1] v1: https://lore.kernel.org/all/20261117131918.2745193-1-yangyongpeng.storage@gmail.com/
[2] v2: https://lore.kernel.org/all/20261118172133.689163-1-yangyongpeng.storage@gmail.com/
[3] v3: https://lore.kernel.org/all/20261119163110.1630269-1-yangyongpeng.storage@gmail.com/
[4] v4: https://lore.kernel.org/all/20261121084119.3418879-2-yangyongpeng.storage@gmail.com/

Comments welcome.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM

Yongpeng Yang (5):
  dm: wait for in-flight messages before postsuspend on destroy
  dm-bufio: make the retain target per client
  dm-verity: size the hash retain target from the hash area
  dm-verity: add retain_bytes message to inspect and tune the cache
    floor
  dm-verity: add messages to prefetch and drop the hash cache

 .../admin-guide/device-mapper/verity.rst      |  40 ++++
 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/md/dm-bufio.c                         |  41 +++-
 drivers/md/dm-verity-target.c                 | 209 +++++++++++++++++-
 drivers/md/dm.c                               |  26 ++-
 include/linux/dm-bufio.h                      |   8 +
 6 files changed, 324 insertions(+), 6 deletions(-)

-- 
2.43.0

