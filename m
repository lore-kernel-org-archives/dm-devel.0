Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7BD3AC17
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648978; cv=none; b=lDph2riT8BIsXqwH1keRxj3iF1/ZuvbVlL8uLXwtqbCvXcpliujhQVRp58iQQd2hwE1t5Kac7caxiAMCbSLxKEGIsXS5mD5TWGAFrIrcaUmHRrdeemuyoa8sJCF6n3CJHgVKEJgUFBYOl0Vc0RO7WKYBq2BLb+gpgYLbTlA8WxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648978; c=relaxed/simple;
	bh=16YEyXk/B0TCzFsLgGwxCmx1xaDVwjamLfZgiX5djC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oKsmGTIIZ5WlaFxlYyq3iIOlmkLvQ7T4fIdho1z1aaZozSw3oD9CNwXvJtPjHncAUxbD1jutGy3j1wyXJvhwZCob19CzqnY/p8Cxf0LJhcNid0ZL9rPOtXSKyx9Q/RG2KIlN5PQD5GpM65WE7tE7YJOu0BVrh6Nx+d2xVQxPnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+L4fsBu; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+L4fsBu"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c315729ad50so126595366b.0
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 09:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791648975; x=1792253775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SaD8+619tQtKAuJuh7WJ/qRr66QK9jKC/1Y9XhlPbJs=;
        b=M+L4fsBu7ah4bPFn92WWDCmsRZC0XRnuCJ0V5torf/BOt6rzHsW3xNPSYdTcYBeM3C
         KP51NSLUctRnGtFBzEZQaxfpQLT266ciyZUmW7GOb/scKSq87HwffgufXtuIMqGpsQ+K
         ztWVLM7U3X5aL7NoHyVkBk7pIMjh1bcp8qQ2f3/fDPk4Q44gBywC2HzISeYqtb32I1KV
         5/FYXMIIyfl3j7liXoIDkDDYbPhJjQIgKc/doBiSkB54ejU6tMYGImM7fWi4Zg0k7Cn7
         3WS2w35eaiIadloVtTZ2h0eb2XnHEHhnlQN5YUHHvSTHEgQb3not6ZzuGn0ZI23o1ygd
         Efjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791648975; x=1792253775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SaD8+619tQtKAuJuh7WJ/qRr66QK9jKC/1Y9XhlPbJs=;
        b=q2uykbK2AywfpkcCLKBeF89uGErZkBzccqbKvuSmY4tOiB4nADsRBQg5knTMWBrcVL
         bZi/dNbCiXyPfG1Nj/6TqjIwRdyTPq9aBFUBWf5HD8yHQoUARYAu1sdhRO6wSyAcKsZ2
         ZXQ/7tzAn/fuzpR5btb4cOibKiD+dpj+fJfkeR+KM7622PsiVpv30/qEFa9aR/jflsAa
         nbOsGoPjGThGBL0R7sDSwnRhZ124BD+kyCAsUvyZuKn44oMLy4RrBnNptahlXDrjz9MA
         oPMs5hbKWIYW7s0/qcWjkgSgF62TVCF40DNXmaPS7JIGnO+HRseMY1MAm7uZBH7JYbRR
         J2lw==
X-Gm-Message-State: AFq9FYKB2bhawHDlAt6fDlk/7Pihw/Rp/rPO2RAwP/Vm5K+ElQ4iChS6
	lHm+lS/ANrNwaZrb0X5pnKz7aaM1P9MA1+67+dQ15/iYmwpyjkBPUv4Zm7xazio/OImibw==
X-Gm-Gg: AYBFou2ujtvmnxj0b0kWg2m+vhktYQaiYRg+Q76sPkg/A+9P4L6OnJnF0Vu7ltrLo7H
	0FDyXSKPwxsNOsZNyXeHXP6opqhFwgkMQ9jM2Ds+4/d479vhQaiF61qT/pBqNNM0sZ/7WaDppGo
	Yp2ZTqnEJzF8KozH3MVEkkKSFU6YxACC6IF/YHo/6A/3LH6Urgq0VE9sHEqgt+TZfpE55QBCsZj
	jOUTAfoGhJMvkd62RowgQyQ3Tzy57kAuJE3kcuduBiMhynYMmPSmspxHqdOOzqRwuQYmwrem8VW
	7rbX4bWIMLihixG9Dx7z4gUWSDxzvnInVSVJPyPlS1opWBQeP86f0LYiMTYJC3eU1aXfpsZkMSP
	2ukgdFnGrkOzsqmqlJ3WsFHs9UBxCdCu1JsiWbhQz8IdKn9Fj2kMvsD7keLleQckSAGiGidQD0Z
	LXQBxRmRtMpbtd2FeCCTkzoxwqYSrYMo6ps7EzC4Ukk+jl6yNUJtcECyRaiyvu7lRsfyJsj9Nk6
	0uqpsBqF825D4qxXehcsZ7ylcIhGEZ2LiYdIiGOprKF5dY=
X-Received: by 2002:a17:907:c0b:b0:c29:5215:b2d2 with SMTP id a640c23a62f3a-c31aa016eb5mr575858866b.23.1791648975142;
        Sat, 10 Oct 2026 09:16:15 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a74bd7sm261422066b.37.2026.10.10.09.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:16:14 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] dm zoned: fix two idle reclaim problems
Date: Sat, 10 Oct 2026 18:16:10 +0200
Message-ID: <20261010161613.396-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: no code changes. The only change is my author address: v1 went out on
2026-10-10 from my previous address. Please apply this version instead of v1.

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

