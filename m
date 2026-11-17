Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921593;
	b=iaLK3OHkXeKkbnryM7mBLpCMDXOXIjM5D7RskhHuAO32B4zUfuTDUOXX5fLFl9YWyzo5
	 PMbojZ+sNTPt498vezp+8834wje82pKY2Iu9zSPIsgf0lwhqJ1PLaP1fmkGD7zmo3d0Km
	 sPEvfdJlWiYdwVhvPkw9wpvSPHXiZqzP5AusXSnwVX11Eh5BNM6ZQmB4W7+w/oc2ZVLnJ
	 dqQH+NUwy8+mvqnlZSIQQyu6HYd8mXfS6A240e/TqVsbvk3XlNvQ2x771/2uxxFnm9DKc
	 w0ZYSDrhPzNVi3AmEPzpGCIOOl6mTP1N0BT43RZVGhJisKhiUHDSgymPA6aHAUVBStA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921593;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=B+GCwP4zo8R29zZKrSQAvAg5KSYOaq4Cj74P2gw1H1c=;
	b=EkFVb3fcfr4lFi0ApRH6VQmsxMkZt5CO7X/2JyhB8ivgHOnxaM7rzXlt4tciatOx9xSr
	 5hFyeh7e+cu65idn77fKG7kgYPaD72NGxscWQ4QqucSTYzxKB49056uuxUofg5eTUROwl
	 9R3hrZXNRja7R3TCH4LZxkhsCWpvssDtQ7QaO9NeSs5CsEwnXUQs6tQ29Wxz9Zm5xmwOZ
	 mKsMHqfT8SeCvIDKNRNQPP8XiSEPhogJoylyxWaKsgcM79sjRQ5NxVy27k0/gh3aM0/qk
	 bCkO2wrbRMwvMyDfF0KDra8/PR8qSYMxWsj0WOpCK3tuJEmF7nIrubGXoMF0EIYEkHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q+Rz4Eqc;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29E606A323
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC29E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q+Rz4Eqc
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2efe022c04bso2487515ad.1
        for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 05:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794921592; x=1795526392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B+GCwP4zo8R29zZKrSQAvAg5KSYOaq4Cj74P2gw1H1c=;
        b=Q+Rz4EqcO8lnMpyOMODvuY4chYLBk9dlvIEYLx4hWBof2052NHHCU5S6njGK/80nHd
         kY0iGMd/NAyddtKRv4KFk7VzlO1TMe1dTDFUdjqpo2ul4jCu6j0G+tYOi9aoNLNJQaeX
         HANFtlJ+f0Vo/g/d/gTV74k2CpSuwr+bQtewj1kd+0u4StCZHNDhihQ9JdHoFkOfXwid
         aAZgbj60dTJrhCIib0cmsyXKKLa0HFVbrc8Q5w43urqm1kq57k6497fb5sByUzRpElxA
         e3W3vnBWv5Fvah5XREQomkOPi6MqfafSVR50z18O4q2091ZaylnWj8yUM99BK+3Nh/gC
         k9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794921592; x=1795526392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B+GCwP4zo8R29zZKrSQAvAg5KSYOaq4Cj74P2gw1H1c=;
        b=cZe1CU+CAjA+Ax////vkdfdIlYKlLTWEmL6tzTHOgBfLEPGLUZl+fS3E1/cleFeOYO
         NIsQau49LDuyhrmlNH72F3rFfqVhuGWq8hMfHZCDKpz+yUosXUM5SMuXDU0erIzkR5kL
         j1edE3+oGbq+oxFY8ZMc+nsDkU/NwqVE8D5NcXcYdM6Xd03BDxZzqPkeXoKZnpeog3mk
         yEpkr55VMF8PTUfqEfSqYJG/mS2NGXtlDkd7BtAMOlxlnr4XfSMB9LhCuNn8boP3MaL7
         mogcXA5smGkXIzlD5sPeP8U5sdCDYEgfifCcXlx0OqC5/YmnDIOibxlFsiiJiP8qzmZ7
         pMqg==
X-Gm-Message-State: APuU4Z+VfjqCwBmQny6IOOFVyhFXntCZ1hVXUtU8WnxDWoNTDdb+66rp
	3y+kWheF6yDAVXs61uMjcBMskLNa9Rc2LeilqSnVlE4qt81z4+oRhL+f
X-Gm-Gg: AZFdTZcy8Ezqhh+oADOnniEFGt/zThtBJMMb3mYqJHWfNFXkOaNJmgxsYf+Z8HJ2yCc
	WDevx8ccnFyeSQqFwpbApR45naApRNUxwQiEKfbuubXCLXJFjjlHL0xXeslwLqTEd126v4ZkILH
	ypdzqqoubWS9B95fbApe/Pz8/bWsbTc+954tlL3oJPbCnkbGMduMS5OghuZctZAfCwCKivqbWWU
	CM/405EGaWBFZbIfa6HcB+Mf1Gc354W34KbqkQpQMeEi/7S1R482mutnUqD2hibZPeVE2THYoMz
	m0jMqHuxCeg70btJqmz2HfL0dgpzCNdte/eZy0aVM/RXAl82wNnUl6oAi6AyGe7cOTEQK8vQ60j
	AKmhXSEAM+l5M8eeGA5rNrvxvOpNRaKHBE545mNjP3Zk6/Zkgz34fwiU8FNWVeoIMYvxcmPcnkc
	XJTUUCwt60aJsV4SC+lt10tkXQT42CLxsugANOhzNenK4DVXDZJsweI2BAfuXCd66m/HRcUcknc
	77bZPmszBxom404FxH5jSAJMm1Vf7Ra2V5eXhwD+k85+MEz8UwuOFm9iO62BcqhWpfKtPZTQF8z
	9VkULYviR4XyCFcdAwT0PJmu5Z69IHBIFsi1qK3AMlCVFUomA3WEzjBRXoySd9ci4CVEB4j/Xn6
	xBsOv+4BP
X-Received: by 2002:a17:902:ea06:b0:2e9:6b5b:3db6 with SMTP id d9443c01a7336-2ee0de4fa12mr132046625ad.30.1794921591893;
        Tue, 17 Nov 2026 05:19:51 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm16064915ad.52.2026.11.17.05.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:19:50 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 0/4] dm-bufio: per-client retain target, sysfs and dm-verity cache control
Date: Tue, 17 Nov 2026 21:19:15 +0800
Message-ID: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
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

Tested on a VM running v7.4-rc1: message and sysfs write paths, the
shrinker retain floor under memory pressure, 500 suspend/resume
cycles, 100 create/destroy cycles watching slab counters for leaks,
and error-path injection.  No kernel warnings.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM

Yongpeng Yang (4):
  dm-bufio: make the retain target per client
  dm-bufio: allow exposing a client in sysfs under a caller-chosen
    kobject
  dm-verity: size the hash retain target from the hash area
  dm-verity: add messages to inspect, prefetch and drop hash blocks

 .../ABI/testing/sysfs-kernel-dm-bufio         |  76 +++++++
 .../admin-guide/device-mapper/dm-bufio.rst    |  54 +++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 .../admin-guide/device-mapper/verity.rst      |  42 ++++
 drivers/md/dm-bufio.c                         | 178 ++++++++++++++-
 drivers/md/dm-verity-target.c                 | 209 ++++++++++++++++++
 drivers/md/dm-verity.h                        |   2 +
 include/linux/dm-bufio.h                      |  15 ++
 8 files changed, 576 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-dm-bufio
 create mode 100644 Documentation/admin-guide/device-mapper/dm-bufio.rst

-- 
2.43.0

