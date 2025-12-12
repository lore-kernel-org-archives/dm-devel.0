Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CED2FCC17
	for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765545011; cv=none; b=FAzvXKw/T+TUyL5POSy69Qexc87POc5beCSc7Q7piNVYq16jp8tIpW/12wy4LiKw5OKhTpkv0BfxZRpqluOJFpa5th6ZP+fnqc8EoG2RjYq1fDh3vmayxJQPn020qF8QZlYpNOdv2ZqVXd7DHyfca/6t+b45qMtZArOituNl8bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765545011; c=relaxed/simple;
	bh=akJBLzsjo9sqFsY9k0R///6KfF7oIt8Sdfys6s1/GcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Frrit3lZzR/soXpETW42izdj3p3mmSfWTdEF/Pj7ma6fcKB+AzwDB2rgV0l15uW2gyNDTqR0TypRgQ2m7emEMZcrnZzfyWRmVGDuxRd5wth4SfJO7fQF39b4cdgxihA4B1edhW75n1NaSM31WYwjC3227LTwJy18KwEcx8KSZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XP5MG1L3; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XP5MG1L3"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-bfb84c2fe5eso489565a12.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765545009; x=1766149809; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cYguud+i6xWCXjMtuaKPW6jl0otNSsyzkB0eJpHEhmA=;
        b=XP5MG1L3t+NDcLoWFyhCcydvV7VanZr5Fd/6l3DwmJR5bA0CQu6p5SzJvGecyYUF2e
         hXr0KVEGc1CxbfX2VIJnUsTpTqpXL4cK3U+hMcvGs73hpyBWEIITDAegCQg995Dvs1kX
         P25XhYVH1GrcDHSl1GjBk5fZWjYbwmg2CVa69xIr1w4M0atnVe0hl/vlH3YmCpN7wZut
         qA5kFMIVYPNP0PhiIlrUBYJSqXDU3tn4nKQoifxCC3LzZzU2ibrbTf4sIqoGxp/z7hi9
         M4fNcD3G0ZBBdZeGtRxcxiLgVZIZOsrin3C7hVkMLvkwPdXSuFTAk8aqZxuRkLdw+osV
         B4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765545009; x=1766149809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYguud+i6xWCXjMtuaKPW6jl0otNSsyzkB0eJpHEhmA=;
        b=vFgSlc1xtr9+gOA3gStyJWDag26aWF3w1gkKW8ls4Y+1GCqOcF/SSTEDB8GxLeGydr
         kchG/x2nbfsT5OVlWdekVlpvuc9V8ZPmhouBqLiVCfJ16fDGg9RWLuE0nHvKB/tTRkXU
         L5m7vD9re5sYlAGiJD/z3xyxeMxTU0zs86ztVMXVgw8RhEKgrOezSBpDTHefqN/bIuIY
         XhqdDnIdqPR9ZT3NiRaI5fsUkJLiQu7WWVIX2ofg5k6j3/4IMqC+yW5ctJpd9FSgrwnJ
         vZm2ZsqVQ0ziJ6BRZW6/yYYxZFQ6cqndKSuWSY/wNwaChGnDqlk54A0xyqunawJRVYBt
         ngJQ==
X-Gm-Message-State: AOJu0YzZHqZNF1YULk3jRdd6V7gCb9juxL8rLI7yCbuighDM1mTMk3aM
	tAY9Ly9sVSckX5nJD1ynWKR9vplPODcBuVdS0f/WUfNmONf61wO4jgm0
X-Gm-Gg: AY/fxX7GJ+GyOp9G7qPFnPLU0ILgxardBBpReZ07cpbV26CQN8NfiT5rwnQ2MXFtz65
	CDSNq0kDwXOxLo+Cb5uHMriZynaPe7tNjwcXFkep1Ig2LYM10e2BmsJul8t8ruGQCMFBrB/PzJ5
	jwI3zgjsUYhBnNQSeVwNGX9nbhcxARz6SZA4LXBEC8jSFijmRNQaKLXCfX/TbGVZ0rjlDHzyozb
	ZKels+Fo5GiogoR3Wg2N9qu8bE+XBsqZgfzEZD2wT9mvHth92+nJbW3wM7g80trwHn+Vi4soxCE
	/L2ylC1KSx3UHWYd8wQIHefg3ohTH0acGttU1TTyS1u+9HsNuRxn9dKfl7zKs1tZtJ5p5MzwUtk
	EzbdUlKVm0KtF1VW/b/n2iZmeK8A3vxwtlqvq5T2uTQFx/sDVpKkajQE3gA47CUzHz+xXxX/RW+
	cMmDMUvEkOfJuaaFxpTaUEGFUetYVj7NvVLpYn8DrJkM2O4pmkgZWkY2+TCg==
X-Google-Smtp-Source: AGHT+IHTArRW5xSyZnImfdnlDo+LmjEiM3z0Zt2EehnkGdqf+lWiVP8jsSySeGLQZ5Fkw/O/rPVpWw==
X-Received: by 2002:a05:6a20:728e:b0:366:14b0:4b16 with SMTP id adf61e73a8af0-369aa740ecamr2276279637.33.1765545008562;
        Fri, 12 Dec 2025 05:10:08 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d81d2sm5132432a12.26.2025.12.12.05.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 05:10:08 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Yongpeng Yang <yangyongpeng.storage@outlook.com>
Subject: [PATCH v3 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid unnecessary discard bio splitting
Date: Fri, 12 Dec 2025 21:09:55 +0800
Message-ID: <20251212130955.466384-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

Currently, the max_hw_discard_sectors of a stripe target is set to the
minimum max_hw_discard_sectors among all sub devices. When the discard
bio is larger than max_hw_discard_sectors, this may cause the stripe
device to split discard bios unnecessarily, because the value of
max_hw_discard_sectors affects max_discard_sectors, which equal to
min(max_hw_discard_sectors, max_user_discard_sectors).

For example:
root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
536870912
root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
536870912
root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev

dm-1 is the stripe device, and its discard_max_bytes is equal to
each sub device’s discard_max_bytes. Since the requested discard
length exceeds discard_max_bytes, the block layer splits the discard bio:

block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
block_split: 252,1 DS 0 / 1048576 [blkdiscard]
block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]

However, both vdd and vde can actually handle a discard bio of 536870912
bytes, so this split is not necessary.

This patch updates the stripe target’s q->limits.max_hw_discard_sectors
to be the minimum max_hw_discard_sectors of the sub devices multiplied
by the # of stripe devices, and max_hw_discard_sectors must round down to
chunk size multiply # of stripe devices to avoid issue discard bio to sub
devices which is larger than max_hw_discard_sectors.

This patch enables the stripe device to handle larger discard bios
without incurring unnecessary splitting.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
v3:
- Rounding stipe device's max_hw_discard_sectors down to a multiple of
chunk_size.
- Drop sc->max_discard_sectors code.
v2:
- When an overflow occurs, assign (UINT_MAX >> SECTOR_SHIFT) to
limits->max_hw_discard_sectors.
---
 drivers/md/dm-stripe.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 1461dc740dae..8a872f5d633e 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -456,7 +456,7 @@ static void stripe_io_hints(struct dm_target *ti,
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int io_min, io_opt;
+	unsigned int io_min, io_opt, max_hw_discard_sectors = limits->max_hw_discard_sectors;
 
 	limits->chunk_sectors = sc->chunk_size;
 
@@ -465,6 +465,14 @@ static void stripe_io_hints(struct dm_target *ti,
 		limits->io_min = io_min;
 		limits->io_opt = io_opt;
 	}
+	if (max_hw_discard_sectors >= sc->chunk_size) {
+		if (!check_mul_overflow(max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors)) {
+			max_hw_discard_sectors = rounddown(max_hw_discard_sectors,
+					sc->chunk_size * sc->stripes);
+			limits->max_hw_discard_sectors = max_hw_discard_sectors;
+		} else
+			limits->max_hw_discard_sectors = UINT_MAX >> SECTOR_SHIFT;
+	}
 }
 
 static struct target_type stripe_target = {
-- 
2.43.0

