Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25390270EBA
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028103; cv=none; b=XrpXCYVQu3/y0ytyMDHfZjTumq6iiwpRvUDSCdy7OX5JETxoWArVkGv3f+1pUrkOKD0N+42/NgIHgdBymUkAgIyqUNDYrEXmU8dy0JCa62AABxX+gNntDME+9WYa8dmvqqUMRrh85/15cYbvGsutTykhOJdrc/5IkAaKEojk46I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028103; c=relaxed/simple;
	bh=0HZiUPVVqiDv8ZEl67pEJba49nGpbGLpzJLHrHVWkJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DHaWa/35A6msEPs1Lp2SgKn4V9aA0jdJz4bgQY12ZQq56zQvToMO8HsDRJuYBq7Csr9woK8FXIOKpXv4ovvhiISCPxXIcAgxQkQjgFmESdovFoQvU1abviiS3LWh8mrRHa91q2U+y6uQFmjUluYPFE45DBhieqIEl4UFVE71CeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaK7czRE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaK7czRE"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29555415c5fso53850355ad.1
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028101; x=1764632901; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=jaK7czRESMmIFZ5q7I9LftiD0cAgblOKnwtu4kDY3IOAbhLmzWEFVG86K+wcJyKcjD
         p7ZjhWMGnEQ1Co5gO+AhtmnmrBNPkdKHqiunWJmB8incRf1BpLTNC7gpgr2PKI4qhGIu
         Q1HbS6eQJ+sXyHrHoBvInj0k6H78Z8kn+0rJ5/Cv2/0IvXYllJrhudD8E+EIYUmNF3pP
         n0owE2OJ9Z1yhwYFglEt/RkhF2IWb1bNsLzhCFA2E/v2stLrnI1hOc6j1vrAcx+T5zI3
         q5sh8K5aHV6zVGprJb0osdYuzN2rxAdhn/aIfRjGo+FoQvHKuqsCaHk1IC+3XtFnZQ6/
         lFxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028101; x=1764632901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8zwVcuAssRnEQZ8e7ewIMIsPfvOXMAA4RWGmHyZ+Rs=;
        b=LK3Vj5qRj0l2ujPQ0D/tuV4rVwGQkVqPRvUCNIoQFXrA30gr346H+MPhW4iO6KaLAE
         8buhPBT73IDhH1n7QoLT4yYjTpxeCp0DlLlUGNQvc80QdAjO+bC+rAy/9SaiaDfDCBox
         /KddUNsqd/bFLTX6C55hDo6q/8xLoh4V+Ttr1nwyR5WAtWNkdbU+/rpJFBqGH7GBOYne
         Z9aAocc6gIO8Lc3k++gZbuk0wHAlBLKcEWkj4uzTVQPGlBkB3hFAf/biIfVuwH6Zf5r2
         xwvf9RUix5r0z0Sw6ESqiaLlc5KNTQ/lkkHzR1vAwVvCa3DZgOWu67ufVxINYRs2mIw3
         4MFA==
X-Forwarded-Encrypted: i=1; AJvYcCUzl3q+0SH5morNo16YIGmz11q0Hz+nMrmETPYKOqNYC/TqMsBn/pBZdUUZ7F52bBWOXQpPYOT9+A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8mKbACKlJWWK2fNA6FEbpeG7u6Mhd4CuDWJovA8C45DGcGs3e
	5gMDYOx7YwQc5+gadLXS1STxJyW8XElp3mw13efvAsbrkmQunTQrk8k5
X-Gm-Gg: ASbGncsH8cwZWFl0N29Jr0Iwo9suOjjMGM94YIk7xvGGvbQau1mUpYJSFUoMmkgVNmb
	Za3yz2dylBiV0d6OxzKsfoI4W35/27ey8gVTV7gPPtHsL0Xvi5yYNwPRBDuxlnwPebDRPhfeBzT
	HldVEqeoynTuocWqBooV+2HJhJTGcoD0HSX3znvxuynJgj4/jyOqamn4rCn+2jiXtWm+0Lnfq1M
	CD4ijg2OXGeaLZ1xmn2UkivDdoi/gv/p24AECokSCsDw4qE2c8Gm2x1zam38w6Bd0JR7MkY4MXs
	u9MaaDd1FnDg/4ZFMhdsSTwIM8ywJdPQyH5hJFe0UPQ20ZNYl53FLkLcsl3EF6uWt4/4tgI4X+P
	OGwDTxfHDJaymgTGELmOpGUhk0xKUiBbUvkTbh8hZ128mXB/7QGiFm7TkxtHSD0CIuzFQbmi1b5
	6e3bnQ0eNEfxOYJL5jM39q2+tsWX/4eMAsUu24VLDKV8Mo//s=
X-Google-Smtp-Source: AGHT+IEWVgvs7HfQh1Jftv0/sg1EMetPp1p1pbe1p7lp0IBRgw/xws/S7S4QHSHoK5/x2kKFyy9WJQ==
X-Received: by 2002:a05:7022:1093:b0:11a:2ec0:dd02 with SMTP id a92af1059eb24-11c9d85fed4mr7996088c88.33.1764028101157;
        Mon, 24 Nov 2025 15:48:21 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93db556csm74670928c88.1.2025.11.24.15.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:20 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
Date: Mon, 24 Nov 2025 15:48:00 -0800
Message-Id: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

__blkdev_issue_discard() only returns value 0, that makes post call
error checking code dead. This patch series revmoes this dead code at
all the call sites and adjust the callers.

Please note that it doesn't change the return type of the function from
int to void in this series, it will be done once this series gets merged
smoothly.

For f2fs and xfs I've ran following test which includes discard
they produce same PASS and FAIL output with and without this patch
series.

  for-next (lblk-fnext)    discard-ret (lblk-discard)
  ---------------------    --------------------------
  FAIL f2fs/008            FAIL f2fs/008
  FAIL f2fs/014            FAIL f2fs/014
  FAIL f2fs/015            FAIL f2fs/015
  PASS f2fs/017            PASS f2fs/017
  PASS xfs/016             PASS xfs/016
  PASS xfs/288             PASS xfs/288
  PASS xfs/432             PASS xfs/432
  PASS xfs/449             PASS xfs/449
  PASS xfs/513             PASS xfs/513
  PASS generic/033         PASS generic/033
  PASS generic/038         PASS generic/038
  PASS generic/098         PASS generic/098
  PASS generic/224         PASS generic/224
  PASS generic/251         PASS generic/251
  PASS generic/260         PASS generic/260
  PASS generic/288         PASS generic/288
  PASS generic/351         PASS generic/351
  PASS generic/455         PASS generic/455
  PASS generic/457         PASS generic/457
  PASS generic/470         PASS generic/470
  PASS generic/482         PASS generic/482
  PASS generic/500         PASS generic/500
  PASS generic/537         PASS generic/537
  PASS generic/608         PASS generic/608
  PASS generic/619         PASS generic/619
  PASS generic/746         PASS generic/746
  PASS generic/757         PASS generic/757
 
For NVMeOF taret I've testing blktest with nvme_trtype=nvme_loop
and all the testcases are passing.

 -ck

Changes from V2:-

1. Add Reviewed-by: tags.
2. Split patch 2 into two separate patches dm and md.
3. Condense __blkdev_issue_discard() parameters for in nvmet patch.
4. Condense __blkdev_issue_discard() parameters for in f2fs patch.

Chaitanya Kulkarni (6):
  block: ignore discard return value
  md: ignore discard return value
  dm: ignore discard return value
  nvmet: ignore discard return value
  f2fs: ignore discard return value
  xfs: ignore discard return value

 block/blk-lib.c                   |  6 +++---
 drivers/md/dm-thin.c              | 12 +++++-------
 drivers/md/md.c                   |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 fs/f2fs/segment.c                 | 10 +++-------
 fs/xfs/xfs_discard.c              | 27 +++++----------------------
 fs/xfs/xfs_discard.h              |  2 +-
 7 files changed, 26 insertions(+), 63 deletions(-)

-- 
2.40.0

