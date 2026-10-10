Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B894384CE9
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 10:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629490; cv=none; b=jAPSI8c1uQuqaPbukOux8MYNCg/n165SdUMeYr6bjEAq/7tdoMdOoe+bCG/euJHzx2Q9OiZBmMNPeIKqRgftxWlzJtNX1AkxKWIKgtRmFz8BIDL6F/Jx1ULkae3CQy3SXkLBbsLwY5Xaxrn6ZLWbUQJNipU+le0XthFjM+nYmVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629490; c=relaxed/simple;
	bh=s0Fi+kfi7oO0PooCzIeRIQTCwIpI83GsMSHEMfr/TQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8NSJYxC6p36URZuN81xtyyUt95EZZg8K2RWbWMx54DhAq6aEYo1cPsP5wVqKmk51q0gmF3NkBCa1gRMl9PluB7z+wvFuMA5ZCb7HQX9JR+LZHsrg9fGTTy0bCHYvnAwd8MuuXVZn2QZ8S3lsqZKCrjXWfKmg827fb8qny0DPBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPZkeJ3S; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPZkeJ3S"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c31988fc977so97984166b.2
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629485; x=1792234285; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+WpPEfSUTmyAAHA+QHOcjQyi/MkcTZ3Ii+yrAHad9iY=;
        b=VPZkeJ3SxibXZRbKvVuf+inmixkBELgcPNxD+oulKeFfMsQuPLUqCPL0cPAZCzL1BZ
         F+viQLs1KfWIF8RBJzDbp7l6QZ8Nj1VdXzCAAAek62IEIU2wqFCqk/dFSqsv48cAvWAf
         0Szdos7E6tw63KLrew/HlBJF3bbqSUbdyrhT7FOZXzRcrmPb2ZJSLdPYOo6ajvZ4UNgi
         vm9ubH7IBFrTpdXQPDRSlbvE0gWBAAFNLLnrM6uZxxQyMBbc3HBlDH3GzJJDR3wg3GKO
         rp7wcDEMtrIAlNS+QiRWP/WkZLfHjZQkzczjZSQySKEwGqU3e0x4zwJJ3F1iAyJ15W7W
         uJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629485; x=1792234285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WpPEfSUTmyAAHA+QHOcjQyi/MkcTZ3Ii+yrAHad9iY=;
        b=oiLczrnz8P/XeyBYst5bxFg9HxQNueTVld4rqapjQmx57q/zNNR2Ch0rf/+mqKtXWm
         tatX8sW8JqqoIa3kUOL5mgtu1o71ve/QJwvwEXGm2oZft9qQkkhINAqI3QW663459luB
         ge9vBHZmborZqchaYDv15PyxZZJAGwB0MSVIFDM/tFfiLLLG62EHjz8j6vUnB6BedJsw
         EaQTEVxGDcViR8a++AZm9LmZ8LeeRPbFXCXVQD5nkBB65paf+i2K4G6jMlXM7U8tHZIN
         vG3AvUdkG556o0s88chDrxTcomeaf28+6fwBFGnLW3LvobfNq5Ps1UE4w1NcwhwLFRDx
         O+jQ==
X-Gm-Message-State: AFq9FYJVw64I70IX1+Zzm3WocGIE/uMcFc+obwqhwjFGK+gnBFMcbOta
	p+p4a0iT0izazWTQ/1VoN9w5RHjnX41vMTEaWl5z0DdA5qETjaL7fnfdBI8JVPkDaFQIThFOnZY
	=
X-Gm-Gg: AYBFou2TnO1JYoUjZlrRhHpTGdMvpmZ9WPHQdecUp1X5WIUhhO0YlMYhUdGaIGbZ6zW
	ajNv802L4H/+/HshCgiUP65UrwFzM+zvJZGBx1leZVnFMmlkClHOtsSMsuXuIjtYvQkywU68Dkq
	/yBnbUd/+ZgHd6hrajKnoRIt7i0UkP5puTjvIx+SrKVjx40L6iIWHUitYnw4RBtAC/eVj4Xs/9m
	4mIja4YchH3aisKvm1DQVZAM36nEBGvgQJyR/R46oNAi2SoeHXq/AYeuitHamUJpUnNoHECGWJq
	Ngw+p0pNUuQ+zolxqwTmMkxm5kkq74ArMRUQ30Kg+Tast/3CLHzguovosY1yYqGDP6VP792OhaT
	WwkvIeOMS6tF4QLPxTEw0O9bBgra0HLEfGAitKqJ8xoDmttnZL0QVvLvk1rGSlKbT+6+ail0ZB4
	NyVkkYRUac/xQhk6SZQYr4dzj4M69/VEaDefE8JoQOTohVEqSDhixR//UK+YajcR+GFCjItAqtq
	67wdmHf31/7EpadJk9NsaaiR0WODSAxoS9ABWWm5c8Dl71Tr67ftn7nuXFs263jSMNUcEoXa8PT
	y70=
X-Received: by 2002:a17:907:3f10:b0:c2d:c6e7:9e9f with SMTP id a640c23a62f3a-c31aa081161mr481202666b.27.1791629485459;
        Sat, 10 Oct 2026 03:51:25 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9766743sm229984566b.4.2026.10.10.03.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:51:24 -0700 (PDT)
From: illofspeed <volvo.mail@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dm zoned: fix two idle reclaim problems
Date: Sat, 10 Oct 2026 12:51:19 +0200
Message-ID: <20261010105122.398-1-volvo.mail@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Testing: the three patches were built as an out-of-tree dm-zoned module for
7.2.6 (the changed code is identical in current master) and tested
- on emulated host-managed drives (tcmu-runner ZBC handler) in a VM: the
  idle copy loop reproduced with the stock module (340 MB/s on an idle
  target, zone counters unchanged), 0 MB/s with the patches;
- on the three real drives since 2026-10-05: crash test, three 1.5 TiB
  write benchmarks, and eight conversions between single-device and
  cache-device layouts; emptied zones were reclaimed within minutes of the
  targets going idle without the reclaim timer.
- with a reproducer that needs no special hardware (scsi_debug zbc=managed,
  64 MiB zones, plus a 1 GiB loop cache device): stock module ~600 MB/s of
  read+write on the idle target with unchanged zone counters, patched
  module 0 MB/s:
  https://github.com/illofspeed/synology-host-managed-smr/tree/main/repro
Not done: a test on current master itself (only 7.2.6), and a rebuild onto a
cached member with the patches (the first problem was seen after a rebuild
with the stock module).

Related, not addressed here: the double-free in dmz_load_sb() reported on
dm-devel on 2026-05-30.

The problems were found and the patches written with the help of an AI
coding assistant (hence Assisted-by); the analysis, the tests on real
hardware and this description were reviewed by me.

illofspeed (3):
  dm zoned: back off when reclaim finds no destination zone
  dm zoned: do not reclaim a random zone into another random zone
  dm zoned: keep polling for idle reclaim after a reclaim pass

 drivers/md/dm-zoned-reclaim.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

-- 
2.47.3

