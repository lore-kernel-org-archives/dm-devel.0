Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250506;
	b=LQKBUqW0b6KKqY1FTXeNoM9FuCRtHohWTq1q88nvn2PaDhRwXYak2NrQgLBb7B/WTS+g
	 QiHlK2Nco9lvYYlbk38gMoeUFGEucxh5mU4yc+gLhFub/ofIKoCWaIZI4ATQQsSNX/kbk
	 D1viRn7UU+OqgC5cQwOZGzCQppg2bddHKngCZgswXHqMpTkdLgq4f2Dn1bD/j5utzAU9P
	 KRgU05uyj0fSLlBi6tN11+2hdLt46Yle+FviqQ5+caGhhAMpbDgfMqcPT9315UdvgKtJr
	 XvSNlV98I8h4IC9ty4wpYmUSwVrbYpfegNJ63yrzh5Rrc2dr7mHKl3HIW4jmE6I+AWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KszRaX/mkF8oOMT9qunq+fnfK5iZC/jAA2zGPR5+KUg=;
	b=OSuEyt/D1YObEuFjDpSMo6SB2gVTKh8i9basf29K4e3ubBQbnbpa0YaaY+GlD6mOQgw4
	 uZxR+XgK3zmKa+jRP1ermz79iSGw56QugejqLaGQUtpGsumTJ2/Uw5ozNE8ese3aKe2UM
	 E/o3E7XqHlPamAHvCykaua9OkcC2DEHo0TvXayE23ouLYhuPzKEj1cvaqbsejp2ieFo8Q
	 7YWLOnF80DPtI3osr+6fGqSLA5LQ9V4Y4qHYjjANBdADIIKUphWwGf0/x2I3AJghSbxSe
	 H19ckB+GLrjo7McRF4jRuPefvdBzOxBHYJywPAtAtvFerepBX2nThxTIRpPFkopDREw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LjtYdsDD;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE045606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE045606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LjtYdsDD
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so977426b3a.2
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250505; x=1795855305; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KszRaX/mkF8oOMT9qunq+fnfK5iZC/jAA2zGPR5+KUg=;
        b=LjtYdsDD2EPKIUcFeYBpILAlMyW2WY4QMUER9Hgyjn+UVvnirvm28Tp3EW2x+FsJgE
         Us+YIhmuVqjrijwLakWyPVLimX19kLk72EZT7EA0ExcV7Dpy9PW+lAKcwdUm+aBFZ3zW
         p8dMJnx0f2tlRYJPgf4M7WNZWvyVSqrDaw5domgJ2nqcjPicmV+AzQ45G3eNi8fF1T76
         X3+DxPmcM/inSX23RzzuuPoxodpgHteeSZllc+3+8mLdarTYQNGOGt6AU1pcy19Wd2sJ
         wXQFFBir04DGmHIbD1bkbcuOYm8mDgJx9t/E1P38BPyfwXSLj3nqPsgOZAr0u10Hzx/n
         js4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250505; x=1795855305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KszRaX/mkF8oOMT9qunq+fnfK5iZC/jAA2zGPR5+KUg=;
        b=fHuYU3ayWLCAb6tPmq+5lh4uHMUP7F2+c7C9kFTNCekzS/gc8y9tXPiIbBRKM7IObN
         zKaAFkpjc1rK0n+pAPrmWGv7LEVcw4VIfJ3qGmVVAb6XqjGNWifvgUrapzWmYtMvoVn8
         oUYoGRAp31ieMuThEYdIX7RxPKefDKTys7ebZvD7DjDmfa03pAhzoGPX1ErWvnHRAL9Y
         5I1zQW7ZUwWTRFgllwaNz6Zz5ceDQQIsq/CCBkvlNSjTJFucKeRG2ytl/r9z5MLDcPwS
         z3SWYe/FZNU+D9nVDSv01WYZxWgf20RGfEYiYxn0uWIgIJakIqbwWUnCrl5ojHcz3XfW
         5K8w==
X-Forwarded-Encrypted: i=1; AL+hErHwCpRTL1v3zLzGngBjsTyKuOndi0KEbZHgr0g+qtBcI05USRaVT7kCrcNHgnlovh0EAS0MlBGZWA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+OL9b81oXFMiWNHMqPVh4qgc+gxTo8EvFXB2kn+0cYX7OGzAb9
	3V6HXeaONXrk5f1kNaBMY6zd46QlVWI/2DbUSHc2nNOOTC9QdwF2e66T
X-Gm-Gg: AZFdTZctbFnzQGY1jtLzvor0drbNXs3DJdzk03C+qxIpvUd6iAROmWxI+im3KhKUvjZ
	wtQx7im8uw17iW+nZdpgq/JIMH2NO/bWE8Xj+ZGODkQXf/8qXaKHaMFaDeDYMC4kSdggh8ViyGx
	1PLr9fN7o5pG3a/8lTAD61BHajZY86UO1WpuldAJCpYXonoJ19ArvUApts7on/rLIgbzJKanC/h
	qp9+mbXl/O5ErJn6REx5jJ0Vhvno5RvrwraLy0ps4IiNYIC58q0fskR+mn1KnR8L8zp3G+jUCyz
	CMMuwhCUAaHzFno/CvM+DaElQm4/inRWSPNb9VljEQxdAaFVW3/MEDwg5QNb4wv63y6+GRTt7w9
	dptj5elmYkjk4MdGXUp1Eum4Cc+BR+V848mjd9Q9kHZDreOTTTn/hzk7hvAQ7EFRorNr7v9eGIl
	ar9v4y3TYCeFeXgKPKgiW+aZfLT25xBURjR3L39gW/nla2+huwLHEK36LKIZZIA6KQ8d/ygDsBJ
	9nwpTkvnyvIjGxfaYFd/NIGQpfVdq1j4AG5hD0MpzHuXKrkvi7dvIf39se69GWgNL0qmNNCItru
	ZLx8QrkPxbicktlhU2K3MhpxcHjKgtFOL9rKIrTVO3uZ8J7y5/xkgotiUkCzA1Srjs6HcItIYbk
	gnFGQTgxZGa1OjT3XyhUUdpe9eVGXhA==
X-Received: by 2002:a05:6a00:3391:b0:8a0:4807:457c with SMTP id d2e1a72fcca58-8c87ce329aamr5105087b3a.39.1795250505134;
        Sat, 21 Nov 2026 00:41:45 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm2605350b3a.42.2026.11.21.00.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:41:44 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v4 0/4] dm-bufio per-client retain and dm-verity cache control
Date: Sat, 21 Nov 2026 16:41:16 +0800
Message-ID: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
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

 1. Move the retain target into struct dm_bufio_client, initialized
    from the module parameter at creation, and export set/get plus a
    cached-buffer count.  The parameter keeps its meaning as the
    default for new clients.

 2. dm-verity: size the hash client's retain target as
    hash_retain_percent (default 10) of the hash area, so a small
    device keeps little and a large one keeps enough.

 3. dm-verity: add the retain_bytes message to report or set a
    client's retain target; the reply also reports current_bytes and
    buffers, so memory use can be watched through the message.

 4. dm-verity: add prefetch_hash and drop_hash messages to warm the
    cache ahead of use and release it afterwards.  Both are rejected
    with -EBUSY while the device is suspended.

Nothing changes for existing users: every client starts with the
value the module parameter holds.

The code, commit messages and documentation were drafted with
assistance from an AI coding assistant, from prompts describing the
desired behaviour and review feedback; the result was reviewed,
reworked and tested by hand.

Changes since v2:
 - The sysfs interface (per-client directories, ABI documentation and
   the suspend/reload handling around them) is dropped entirely, per
   Mikulas Patocka: state is better shown through the message
   interface.  The retain_bytes reply now carries current_bytes and
   buffers instead.

Changes since v3:
 - prefetch_hash and drop_hash now fail with -EBUSY while the device
   is suspended, so no new I/O is issued against the quiesced device
   and no message can race the bufio reset in postsuspend.  The check
   needs no further serialization: __dm_suspend() sets the suspended
   flag before the final synchronize_srcu() that precedes
   ->postsuspend, so a message that passed the check is drained by
   that barrier before the reset (sashiko).

Tested on a VM running v7.4-rc1: message write paths and the memory
reporting in the reply, the shrinker retain floor under memory
pressure, prefetch/drop lifecycles, suspend/resume cycles, a
prefetch-spam-during-suspend stress loop, and error-path injection.
No kernel warnings.

[1] v1: https://lore.kernel.org/all/20261117131918.2745193-1-yangyongpeng.storage@gmail.com/
[2] v2: https://lore.kernel.org/all/20261118172133.689163-1-yangyongpeng.storage@gmail.com/
[3] v3: https://lore.kernel.org/all/20261119163110.1630269-1-yangyongpeng.storage@gmail.com/

Comments welcome.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM

Yongpeng Yang (4):
  dm-bufio: make the retain target per client
  dm-verity: size the hash retain target from the hash area
  dm-verity: add retain_bytes message to inspect and tune the cache
    floor
  dm-verity: add messages to prefetch and drop the hash cache

 .../admin-guide/device-mapper/verity.rst      |  40 ++++
 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/md/dm-bufio.c                         |  41 +++-
 drivers/md/dm-verity-target.c                 | 209 +++++++++++++++++-
 include/linux/dm-bufio.h                      |   8 +
 5 files changed, 301 insertions(+), 3 deletions(-)

-- 
2.43.0

