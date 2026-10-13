Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1234D487A
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895187; cv=none; b=n9kveVNUVEue7W/kBVLMYu9GeQhd4m2j+8XyZEvUTrbGPByggUQloQIaUKD3FmRWiWpLT4lSrYyYc4GZJcy2SE95YGNrAWO7zkYHksjLdX3Jy96cgU6yFB01pyEDRbTeFnzsxp6stImmYwEDo8x56Q/fSJCQBHmxUSMLop9nCyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895187; c=relaxed/simple;
	bh=aTmjXjJ6hKV1sW2eiPQlZVKg6oxo9CXTmfCOnYeU0CY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kr4h+Jm5akU8MS8KwD3Ya9y4dff7RSNHnyIafPWOLbHMJc/h6/iub81qd4UN3WN9mBHB15nawmtiRaZI7pLltgPxOv8R4y8eIoyfjtCIqz3Z8VP5YKaNUlaWzdEensMQinheSopkV0t3dPO+2VO72E0NKycSWric8TPjGpWoyDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RsVP6fNo; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RsVP6fNo"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48b02a2359aso2739814f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 05:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895185; x=1792499985; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ks3p5RPBRw4A8G+7k+gqUrfe8aHMaRZX4Sxb6Rgzl4I=;
        b=RsVP6fNoyUutQbkhM/0lFhzZy90r17c/ee+cnpFa47Sj6eJSYk6R1ni7XbomFEzMWb
         NWsKV7PyNyQyVA4PJ+eYaoaXdVv7PgBq+sXsT1cCibDjUkgItQ5+Ms1Qd0io9p+rRzD1
         YHOwofo7dzuXC1nz+EqWjpN20C3oi75nbgMSRRrW2zv/5Zq2AP2JBACK0006WWN5PZvx
         0SkTMSoQuJ6bd0mQSYqJYFl3uapYq6e8vkLy9iH5FOPxfbzBKmjgsBl5JXTf5rJ1cVVd
         wCh5WP/CFj9dzLbypkfsGiAWEg1lIxaLBNDAmMFFv05RAlqPDZvtULmXXAoBbPYaar60
         wL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895185; x=1792499985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ks3p5RPBRw4A8G+7k+gqUrfe8aHMaRZX4Sxb6Rgzl4I=;
        b=Czrrxw5ysXmGJHdhfcR+uptXhwVgDU1YnnISjMnAgGKmEth0JZ2CHRL/95vgHegf7o
         fv1Rlp/4dLSkHxSwwJNhiLvKPm6JcDDwSsPBDp86S1aiU1Mspbhwqqpd1cvLCuyxVoa9
         09tHXwwi/Ucn8vEvrf+vImgow6G6iKHpveJLJHDEy62VHmQ6XcaC5+CopnQlW2ejRWjg
         lHsvV8FfnBDrQOqOfN91L5kMuyEdTgPWMGo0Ns7Mim+gTuRxv+2L/GhOKXTI5X8NJxnw
         qU2PwK9ojyPvkdGqf4jqXQHP6aGhe22e7gs2iaAvEsbnAeFDUrVCjk0sYTLCJpVAQvjX
         tDmQ==
X-Gm-Message-State: AFq9FYIoZPBLoSLb7QC8BuhUkyg1rjME9SUQTGLgDOPQJb7rZ68EqYHY
	sZXkuAmtnPocFVcSfYPj+fO2DwdSI71yf8tPDZvcW64V0taX21zcXnA9/PkNTuyh
X-Gm-Gg: AYBFou1un5fmoBucNlA863vGO04UzE0XUsfPy55RorUXZySG8Mr/4zV+vwpB2/6IvIk
	NTNY3fd0KXgOzXFj5YQpGgQIJYbNU2JE+nk3uUCW56AUrRyh+IzoyNKIiRnF4I0XxpfJOC7m3rN
	+aoUlsziD0LGuL3Q50ND7vBgVe8hlpahJjMwyZXn4GAlvzBqqGJcU+nfrVZigYJ7hVQhJniPNps
	MR+Ryr+24Jj8fkj20kQBOyhpWtPlDTL8pccu4HHOgQQltSujMjWcQg4CFMQGXhF0kqiuoyEDaKm
	6mjrsjy+Q3eBWsKZVWUS8nu3fXiMRceBTUXp7pPXTilL5GpMGn0cCrqZGBxdrVa0Ti6S2M7ybNo
	JNL82FqOIuakDJcifnzdRf6FUkucyH/IuFxbB+keZ7s9FoD9mlz6SDaAHFFfsSRYRuSIfoH3ool
	PPs11BV0h3zPsba5fpSPv91fOV3AxjojCpzlpW8VPDRbYD69B+uvE9hfHLVmi1h5mSYmvADyxMG
	Uqfqb2HaYCLRHDRKsykXphIrHYpPhA2T3WyGOX5CSo9Tc9qKOe7Oi38Xw==
X-Received: by 2002:a05:6000:200f:b0:48c:5669:747b with SMTP id ffacd0b85a97d-48db9465ffdmr28384885f8f.8.1791895184376;
        Tue, 13 Oct 2026 05:39:44 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc7299sm4179440f8f.53.2026.10.13.05.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:39:43 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] dm zoned: fix two idle reclaim problems
Date: Tue, 13 Oct 2026 14:39:37 +0200
Message-ID: <20261013123940.952-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v4:
- Patch 1: added the Fixes tag (Damien Le Moal), and the Reviewed-by tags
  from Hannes Reinecke (given on v1; the code is unchanged since) and
  Damien Le Moal.
- Patch 2: added Damien Le Moal's Reviewed-by.
- Patch 3: re-arm the idle poll in dmz_schedule_reclaim() instead of
  open-coding it at the end of dmz_reclaim_work(), as Damien suggested.
  The new branch uses queue_delayed_work(), so zone allocations and
  "reclaim" messages leave an already pending poll or immediate reclaim
  alone.
- Rebased on v7.3-rc7 and tested there (see below).

Mikulas: patchwork shows v3 as accepted. If v3 is already in your tree, I
can send the patch 3 change and the Fixes tag as follow-up patches
instead; please tell me which you prefer.

Changes in v3:
- Patch 2: reworded the comment and dropped the redundant
  dmz_nr_cache_zones() test (Damien Le Moal).

Changes in v2:
- No code changes; only my author address changed.

These patches fix two problems in dm-zoned's reclaim worker, found while
running md RAID5 on three dm-zoned targets on 27 TB host-managed SMR drives
(WD Ultrastar DC HC680), each target with a regular cache device.

1. On a target with cache zones and no free sequential zone, an idle
   target keeps copying random zones into other random zones, forever
   (patch 2; patch 1 makes the resulting -ENOSPC back off instead of
   spinning). After a full md rebuild every chunk is mapped, so this
   happens right after a rebuild: the idle member read and wrote about
   72 MB/s nonstop for hours.

2. After a reclaim pass that ends while the target is busy, the idle poll
   is never re-armed, so zones filled under load are not reclaimed when the
   target goes idle (patch 3). Users notice it as "the buffer never drains";
   the workaround has been a timer sending "dmsetup message <dev> 0 reclaim".

Testing on v7.3-rc7 (kernel built from the tag, in a VM):
- reproducer with no special hardware (scsi_debug zbc=managed, 64 MiB
  zones, plus a 1 GiB loop cache device), idle target with no free
  sequential zone, 120 s: stock module 500-660 MB/s of read and the same
  of write in two runs, zone counters unchanged; with this series 0 MB/s:
  https://github.com/illofspeed/synology-host-managed-smr/tree/main/repro
- a small md RAID5 of three dm-zoned targets on emulated host-managed
  drives (tcmu-runner ZBC handler), LUKS and XFS on top: module swapped in
  and out with the files' checksums verified each time; after a 2 GiB
  write burst the filled random zones of all three targets were reclaimed
  within two minutes of going idle, with no "reclaim" message.
Earlier versions of the series have run on 7.2.6 on the three real drives
since 2026-10-05; the v4 form of patch 3 has not run there yet.

Related, not addressed here: the double-free in dmz_load_sb() reported on
dm-devel on 2026-05-30. Also not addressed: a "reclaim" message sent to a
suspended target can already queue reclaim today when reclaim is needed;
with patch 3 it can also queue the idle poll. If you would rather avoid
that, I can keep the re-arm at the end of dmz_reclaim_work() instead (as
in v3, with queue_delayed_work()), or send a separate patch that makes the
message do nothing on a suspended target.

The problems were found and the patches written with the help of an AI
coding assistant (hence Assisted-by); the analysis, the tests and this
description were reviewed by me.

Kyrylo Biryuk (3):
  dm zoned: back off when reclaim finds no destination zone
  dm zoned: do not reclaim a random zone into another random zone
  dm zoned: keep polling for idle reclaim after a reclaim pass

 drivers/md/dm-zoned-reclaim.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.47.3

