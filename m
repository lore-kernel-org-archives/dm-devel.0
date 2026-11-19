Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105894;
	b=5SNuGO6OzrI9lwZchykXtt2D459DhUKSjexqMdy8qc6PXRnURP70VVo+nUuD/mPgvkD5
	 4iFfYfpoMfuml30/JaqtCcponxwTiA1iyGtAWMfAN7Pc1g6nngS/pR/IjYvwsIH9AK7hI
	 SRVPnHXJXQN62qkm8vYXT27zIF+aambKV0lV1aA7vrzDcElDxcgR7AQYZU21wwfd4vOHU
	 ILoU5Fin3YAXCjGAWQRbmXOdgQDLnh6zjLdLKaKjk/ExJRR3f9NUYVzUcXmA8+k39VLj2
	 0Apk+nI/9dqFuB/GdzUYe8FMTwq9CbtGjxTvqc2P6cn9EB/p1nYXsuu6pAyrkQbRGgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105894;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CbPsJwKb7mRbmmu0Es2XaMqnRJj+SVptDS1fjBCH3sI=;
	b=usdCIEXcAoyGOgTLrm0+nbrABvpc5Yz9O4XiWqbpxKx5G4jfD4G0XplHB7TV4egYfFqO
	 a9Hqy0ZwBwyis1z6GrlecfwiuVgQlSDmC0eBtGPttI/FWRzhfXwpZ8V7wz/EeYZh6VIja
	 s/X8gzi4EikPpy4ywFVywPUI/9PR4KFAvWXcOTD61cjShGf3hzrhrEVWc/29DwuRJJsBN
	 2fWYy3xGXcTpPdEd55hPOSV/JPZXd8jW4Cailq4iQd93IeVpoOl8K/d8DfnBx3kXFUAB2
	 p+1pKL+SKROkSbCyXty2wRhnxeStoq202E1vzlkgeVWHIJrqdGUpA+uhYwGAJvq4nKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="udKnqS/U";
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEC0606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:31:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BEC0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=udKnqS/U
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso15265b3a.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105893; x=1795710693; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CbPsJwKb7mRbmmu0Es2XaMqnRJj+SVptDS1fjBCH3sI=;
        b=udKnqS/UFBRzKsrTIedvx3yJtdf0+Ec0+CkQfMxcpfgEey9oGGR0TeuIvubj8fqJtv
         chhNZzAZgOZQTbNAbP2ZD/P23A+C2S/icu4uyTa4lMoqNqeF/I4CGjttC+kFD8sZJY3P
         1xOV/6YcGBpcDrWQXoILg9axAh+EGcS3KPIMrEEedWyTZ2DRo7Lgt2E3wds0K4vlR/IK
         O8eGX2MRF8OEl11saEXdTkBaCIBHxxKTU5bIihI3bnwP91mtFpE4ZzdjSINKZCiqQew/
         q8oxqHNXGVEtcSbEbiBTep8SryHmTgrM0QtI68ZbN8nULOCuV9qgNXYnadPoy1g2bTO6
         5pFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105893; x=1795710693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CbPsJwKb7mRbmmu0Es2XaMqnRJj+SVptDS1fjBCH3sI=;
        b=LM1DVctmDVhmSCs6BMl95RA0O2fZ+6NhxY9PgX1kAf3TtLAwd0yeMDDWx3rsruBzHR
         l4ylSmZGhZ02pbEP1TVtdU+k8ALUaiPgikibZDcKM+fB52gCKpS7ukC1fpElu6i33C24
         PdQATPXG0TxiSc1k05XE+SI7FDFnwMVELtewdS9DGv51V6n5ga1GJCNrcF0f5+GXCKs5
         jmHz406ORxBsDTmPg43fX54kH8427EckZ8riVVRtHrY74q4j9JVM+aY5ZGVhUZkXuKHJ
         Rb2ED874zbHq3Eh/jsGrpfEsX7G0xZRwiJfSxeZfBELW8lbUxuFSec+mBSdo9D/jQc6b
         w8Hw==
X-Forwarded-Encrypted: i=1; AL+hErHJeDiTJQ2clj8G5xPfpVK0L37lIPxsTB878HAteOAa7+U/2C+KG4ZSe6VjQapkn5pW2cCDVImjwg==@lists.linux.dev
X-Gm-Message-State: APuU4Z89q6gE5683PsT0kfLcUWCTasQDVuhwTnSPAioofVnf+YxXvrnn
	fJkde9tIyFGp4iyGn6MsSNTRvXzU0NOj29e6EbL5qmgHgKvxPqu6Tux0
X-Gm-Gg: AYBFou0kUoPawxEpljcU6HjVUb5zmAebKTj+h3JiDAiCfWVoAdkXSesje0ZH2vMPPTb
	kAIQ/QClwUCap+TDtilaCBoPNrNdqcc3Zrg23M80Gjsfx0cB+fWdAAnuNPhczfcBT5LRlm6l2TS
	hmbWKtnI0B/zQ3T4F8RIi/RTyEBpgJxljc1HI7Sm0QuOsCrZgweY641C3+ULY98utm4csc2Insi
	KYso0yf/rF6ibofDyxjVEJhRAl8KmvkeYl7Jcg+RmPi4Nqm3iX9oveIO1Jf8yaSwaogeM3Nz0Sz
	J2WxnUD4bb5Sy79IxCyDTJbcRuu+D97wVb90CdZFiuAs2YRajaAgkZxcn5mU8FSwm1mhkE7qVgK
	auqyy49cnMxynU0yIa1u1Ep5jSx8aD9WNe3OqTUkscaRaMNpQ5NUN6n5IGqW5e+cevQLKJaHVb7
	0kdSlPmQtF+cl5QMB3oyoTXx5YKxMfXUFnOLlHyXVcngq7F+p+r1ochVdGlOf5C7WlPFJBxswQ6
	O2oGHkde8LdecuClun19yflLG7qGmLoEi2eJPznVdy0Ahrjs51/V3wTaWSOQ5rp3yBdHcp+rY1J
	bW/BqP1AqrrC9NMjwsN7w/dtN5LlAfRhFwUjsyny4yE37E+g0cj0CZ8DNq9hiiH+O2vmJSWTiA8
	eE2o9vV9g
X-Received: by 2002:a05:6a00:a04:b0:8a0:7ba9:939c with SMTP id d2e1a72fcca58-8c87b4efb7dmr168874b3a.11.1795105892714;
        Thu, 19 Nov 2026 08:31:32 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87420be40sm132589b3a.57.2026.11.19.08.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:31:31 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v3 0/4] dm-bufio per-client retain and dm-verity cache control
Date: Fri, 20 Nov 2026 00:31:07 +0800
Message-ID: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
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
    cache ahead of use and release it afterwards.

Nothing changes for existing users: every client starts with the
value the module parameter holds.

Changes since v2:
 - The sysfs interface (per-client directories, ABI documentation and
   the suspend/reload handling around them) is dropped entirely.
 - The retain_bytes reply now carries current_bytes and buffers instead.

Tested on a VM running v7.4-rc1: message write paths and the memory
reporting in the reply, the shrinker retain floor under memory
pressure, prefetch/drop lifecycles, suspend/resume cycles, and
error-path injection.  No kernel warnings.

[1] v1: https://lore.kernel.org/all/20261117131918.2745193-1-yangyongpeng.storage@gmail.com/
[2] v2: https://lore.kernel.org/all/20261118172133.689163-1-yangyongpeng.storage@gmail.com/

Comments welcome.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM

Yongpeng Yang (4):
  dm-bufio: make the retain target per client
  dm-verity: size the hash retain target from the hash area
  dm-verity: add retain_bytes message to inspect and tune the cache
    floor
  dm-verity: add messages to prefetch and drop the hash cache

 .../admin-guide/device-mapper/verity.rst      |  41 ++++
 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/md/dm-bufio.c                         |  41 +++-
 drivers/md/dm-verity-target.c                 | 200 +++++++++++++++++-
 include/linux/dm-bufio.h                      |   8 +
 5 files changed, 293 insertions(+), 3 deletions(-)

-- 
2.43.0

