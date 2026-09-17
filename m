Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D063140680F
	for <dm-devel@lists.linux.dev>; Thu, 17 Sep 2026 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643873; cv=none; b=WI/UZQQidZAABMp6lEw/SmoQm/clc1jLsokr27daF8IRpg3DjxSwikjowfz0a26GoT3ftTmZPuj4omWsq3RROMlvUQK9mCGTdBcdxu0GtqIcQ+6LACD7tU6qWCw93iFKXznjW5SY9mzh6o8ckIwD8rPWaQuBxjPKRvpPAxH5IDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643873; c=relaxed/simple;
	bh=e+SgX7TDIRhcsTj4pD28guuOTVKaUDrvWw12xj2L1tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up6DxEXCzukScvVnoqJxzj9WUv5oSmSq+vDlS+fvkuyeMM9PpuWUz9Rcwr5pKJ1xDDIX89LIcwsqkmTGUy+I8wBYegUzfvPW5jmB4aSNNchBhZ6OptUA+QTBAjQk+chtuG0rQxw937UCHxbKzhimiG1xgRmhgd35vT0kkXIKzE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLnQhXqV; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLnQhXqV"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b35611so448268b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 17 Sep 2026 04:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789643866; x=1790248666; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mY+8sCF4Fq1xjFXp+/Az8sHnxNFnoZQn1XqKaCwae3A=;
        b=nLnQhXqVHAe+hfL0ycZYFqnAAq0Qb9FnATlt0nlhk0SgXkq0OYHhB5YHXzfiQhUVGw
         DUmZY4Wh0QrAc7Zfd+4KSekSl/iVyNgNxUIgW0765VCc5idJZjw5sRRO3epwSohOY74o
         7hUhZExoDe84trngiY60w37QdPpfE4HRjkgPZY96nC98oxfaMbh5ZYrvkJnYBrpQuBaZ
         J6QbuRWK9JTu1uL4U3yp/bkkloEjEY4SQxJTB30nGyafvqIjamDYhP8cbU0Eh4HDl4kF
         XGQeiJHUFnt8Ss/EpKic5fc71ijBejXVU8jY+le3aZ8k1GFvgsb7ZjoCdDJRGB9YTwWX
         EqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789643866; x=1790248666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mY+8sCF4Fq1xjFXp+/Az8sHnxNFnoZQn1XqKaCwae3A=;
        b=0oQot/pGzsOqgKBK86KXCgC/aN3tLtJI/b+zkBeyWpFKpCiIXpL92X98TQwyPrKaci
         PS5IGTK3CY+HXyaKtKPTkoJoyVyn6zuNrcKnSE2KNEhRyLf35pOUyKw09id9nuZzUc2p
         w0OY25WVUkTonOgRIxYxYfyVk0TOW2SL6siv9HK+SHNabz5S3UrF1aI+Tw2Upxf7Ja9A
         04FI9GOe+Wq1rUx+PJRo0Bv7B4+X7Kxq2hiawgyKskpzYKpqIPhxm+4VMuFXkmCm96WK
         tkpY+CKhjewJHdHv06+921VA6Uo3/z4CP0w+LrTadtdU7rGkkVX+2RcZasGkPkHKI3yl
         Lymw==
X-Gm-Message-State: AFuF++kNGQGY9+NXSjEkrzZ5lGaCiu7WmXfGyQPxIoXmyKwt6tuJRpO7
	EsKqcYZ8C7c+vkyV57YsQcP6XPxKE4sUPSYcQx/5SMxeyYIAHO44zwIPHIGyR/e3
X-Gm-Gg: AYBFou1CWOGCF5EkU2O78CkmeOFOmhdEZ87HRm2kTyzxBNCaLeCxCx+BBdtPVVHGo7H
	ky27DJGNUcsd+YX41wKoC6fHhlu/GTtj+9ePUwMM28+7RWaqrb9KZdzFmvfgrGJA6g78st6yO38
	W77MVZ/FGc45WsroS45VgiabMsT9UeLXAPN2kcuSDZVft8vBIwARts/EhjBsl9+syLuOhrFDJeU
	nHfEq2/uHRyj6ZVAdggZy/aBxjX5gMtYa5F4HeJ5kj7mTIyV6u4NcJt+rdRBxw8zKHtUSOVPhWQ
	Bl8+ibGZa7LqOsxIU8Kof9/2zsuVN7Gz8vSXqh20ojZ8Gsr6jKiLxhvwJ3LYAqsZKxRvZjJV3xw
	C/+31J4TIJf9zbqh4xBbwn+8apYtrnQ2ZE4RYiNX/Dag3I79i8gLg79xSvwjEfxUlgpIMdvc1BP
	xqPlfYP1C+C092tRKHkVObP3ee+RsbzuatOwcq6Yd0Ba3msa6vHMmsNdMvQKpkY1+TuDjC9gOHg
	RQA292iI41HaXcp4lVOXOIyBKxCZBnL62ISicmo5FtHuqy8dG6VTSAxxlsTRY4S16Rihryuo/0W
	HiCCeJASauWDF9GbrAAxOW4MstLjPkjLDhKWJDn7ae3a578rdzun5XSTTmAD9SM=
X-Received: by 2002:a05:6a00:6088:b0:857:73e2:9106 with SMTP id d2e1a72fcca58-87239aa08b2mr14343741b3a.22.1789643866442;
        Thu, 17 Sep 2026 04:17:46 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87200c581fcsm2692441b3a.12.2026.09.17.04.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 04:17:46 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	linux-kernel@vger.kernel.org,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH v2] dm-delay: advertise flush support when a flush delay is configured
Date: Thu, 17 Sep 2026 19:17:42 +0800
Message-ID: <20260917111742.1328396-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814045813.3148127-1-matthias.goergens@gmail.com>
References: <20260814045813.3148127-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-delay has a flush delay class: the 9-argument table form takes
<flush_device> <flush_offset> <flush_delay>, delay_map() routes
REQ_PREFLUSH bios to it, num_flush_bios is 1, and
Documentation/admin-guide/device-mapper/delay.rst documents it. But
the target never sets ti->flush_supported, so the dm device only
supports flushes when an underlying device stacks BLK_FEAT_WRITE_CACHE
into its limits. Over a write-through device (write_cache "write
through") it does not: submit_bio_noacct() strips REQ_PREFLUSH and
REQ_FUA before any bio reaches the target, and a configured flush
delay measures nothing.

Set ti->flush_supported when dc->flush.delay is non-zero. A configured
flush delay then always sees its flushes. Without one, dm-delay keeps
stacking flush support from the underlying device like the other
targets, so an undelayed dm-delay behaves like linear for flushes.
As for any table with flush support, the dm queue then also
advertises FUA; delay_map() keeps routing REQ_FUA writes to the
write class, and only REQ_PREFLUSH goes to the flush class.

Verified in a VM with dm-delay over a write-through virtio-scsi disk,
using a 9-argument table with write delay 0 and a flush delay of 200
or 800 ms. Without this change the dm queue reports write_cache "write
through", fua 0, and five 4 KiB dd oflag=dsync writes to the dm device
complete in 0-1 ms. With it the queue reports "write back", fua 1, and
the same writes take 204-210 ms and 812-880 ms. Zero-delay tables over
the write-through disk and over a write-back disk behave the same with
and without the change and keep the underlying queue's settings.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
Changes since v1:
- Set flush_supported only when dc->flush.delay is non-zero, so an
  undelayed dm-delay behaves like linear for flushes (Ben).
- Commit message describes only the write-through case; otherwise dm
  stacks flush support from the underlying device (Ben).
- Dropped the claim that FUA writes reach the wire: tracing the
  underlying disk shows a plain data write and a REQ_PREFLUSH bio.
- Re-measured with write delay 0 so the timing isolates the flush class.

 drivers/md/dm-delay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 4864671c2222f..96bb430215a32 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -301,6 +301,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ti->num_flush_bios = 1;
+	ti->flush_supported = dc->flush.delay != 0;
 	ti->num_discard_bios = 1;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_delay_info);
@@ -451,7 +452,7 @@ static int delay_iterate_devices(struct dm_target *ti,
 
 static struct target_type delay_target = {
 	.name	     = "delay",
-	.version     = {1, 5, 0},
+	.version     = {1, 5, 1},
 	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
 	.module      = THIS_MODULE,
 	.ctr	     = delay_ctr,
-- 
2.55.0

