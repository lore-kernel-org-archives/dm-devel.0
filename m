Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF057464
	for <dm-devel@lists.linux.dev>; Wed, 17 Sep 2025 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758106208; cv=none; b=BA6iLmWMmK3biLsnyICClymMCCcy6gYWuQSl8C5XM2hlCNfTAkaXispZsDHpXTEVUPTQBlIi3UM5RewbhDiJCUja+wZYDoM7f8rIDa1jFgYSRmLSlLR8hf8l1JAtgSpOqAafd2sinLO8smbwQCTnb8+CDyC6hQT/gt2Pj6xFIHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758106208; c=relaxed/simple;
	bh=N3tT9NpePkD4zr7R+QRnvyOpDfISIqNIJolWVkhqRnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qa/P9nMKErKkBuSNd+fwvTX/B+fiOIOBvt98kyZR3Ct7Ax4XH4sU4UQDx0jVkotmfFKKvadRZTU0NcjaOAq9TmtRBMdr7jRhsARjCu7pHnjh43sWbcz9HHpdwJNgW1rLyGHzKrdXMCsaMHxUgzf/ha7neV5CQqJe7M1RAXsGdjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPpLhKiz; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPpLhKiz"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77c6516af79so150808b3a.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Sep 2025 03:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758106206; x=1758711006; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ueefBrr+sTuByoRS39jm3VB4zySnvhGcqJEGp6aNTF4=;
        b=BPpLhKizzGU2hrRu6ad979jKFGrfnMXTdrCG+H/a+pNhN47j6iWG+DRdTUIUsgsrwt
         aj6plXo3FLVK6i3DWb9npIPVMSWEgbm6AwByPFEqsXIajrMdEMH64UeZFIhBqi2ruXcW
         4EUaMPdS/Ia0OkMiut10Vd6RsMh4ThyXre6QZCEUPqznbA24vVXDy+LruGPIILbKv3SR
         H7wUPbDVD/4OhizcZWW84GIsxjKaCCLHdZ/d29GOXZ2pXvLC4oz3hCMQu3KBcLxmI2zd
         A3ZvRMx/LDxJE6qVmkD/oUHLtPwialGyKJUqcod/A5224Vukt5Z8kl4DKpdr4UCsdBIQ
         HsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758106206; x=1758711006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ueefBrr+sTuByoRS39jm3VB4zySnvhGcqJEGp6aNTF4=;
        b=QRhAeN7fnwb5gGJVmhv8Mfofj485543bZkxvHbBFCo3HnPIBT9twBg03Kf+UQzehzk
         5AVyhu9EnRzzTsbMN9Nwrof7gwZ4aQOo5zQEGrtPf1BSrHmBNZdNmEmUe2Ihxk9FPunm
         hmmOXRzyPlhYyRXHCzF1cAHjBlb4I4nRh97ZvaJqYcz8N9f/qrRC1og6sMhJAoeqD060
         ZeBoShTqfD/qwuYiDUdWYfUsUBOjlk0u+KRC6DTkZXgolPReUtHGqsZCStNUWyzqSQSe
         II0pwcPYGXq2t2erJswTEqn5o2euovkWaUeficyllMej9Fi9UWkrIOPtOwt9vTuvkE6Y
         QNow==
X-Gm-Message-State: AOJu0YygniV3xeUE1zZu6n+uYBGCApAvd4SS7w2v613Yfv8JuAIODeNt
	JjJ6OZFlPBv4NJKiSVn73mnzZSZkuMVT7jHBS0BaaB+eDldlAgfOvP7S
X-Gm-Gg: ASbGncu0svUGlnPgdO1TR4TRefVzQXvCZ1JaYKBChWHNQKfEHljbzV33XJdQwRNXu31
	ijTLv5qu3snpkiiiWG9N9DkMLe4maqWHsdX+Gnsmw14Bpm8EO01mFOJaiu/jbge+N1R0rrWUpWn
	SiqxHHOsy+/Bfy9hwnwadklg4kOlaaWzHd5aZk/JLlPIUWczYIxh09B0QGFOqY+VAHL2JFSQoJ3
	dirx2nTbXiLiUgEIOzGdR1SADhEWPog7Gg5BIXrXd5jRyIeQKcGKxgfqHw2SRrYNuiS0JP2Pw3O
	KAX3mYwJ2he68TjTRrVKjMf2PG0VVnaLnEYYPCbdPBVOGhFvLkcWIJCSGiOiVu9zLN0q1SZd/2F
	V7sLYUhia/S+rrAkUrqAoC7QWNCR0kd1Ke+xovI8=
X-Google-Smtp-Source: AGHT+IFEGfvM7UhvbfyR7QQp4ascdHKw38SUTDk0av+z9OiLVuyrjXllj9hQMNKsF2abaShozcgJPQ==
X-Received: by 2002:a05:6a00:6d49:20b0:77c:46f5:aee with SMTP id d2e1a72fcca58-77c46f50d47mr953477b3a.31.1758106206381;
        Wed, 17 Sep 2025 03:50:06 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7761a2424c1sm14991583b3a.61.2025.09.17.03.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 03:50:05 -0700 (PDT)
From: wangsong <wangsinggg@gmail.com>
X-Google-Original-From: wangsong <wangsong01@kylinos.cn>
To: snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	Song Wang <wangsinggg@gmail.com>
Subject: [dm-devel] [ISSUE] dm: cgv2 blkio writeback throttle not work on the underlying device
Date: Wed, 17 Sep 2025 18:49:54 +0800
Message-Id: <20250917104954.225391-1-wangsong01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Wang <wangsinggg@gmail.com>

Hi Mike,

Sorry for interruption.
For cgroup v2 blkio writeback throttle, bio uses its blkcg->css and bi_bdev to calc out blkg. after the commit ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone"), when DM targets call bio_set_dev()->bio_associate_blkg(), the bio->bi_blkg is NULL, so css is another new blkcg_css(), and associated blkg is root_blkg. this makes cgv2 blkio writeback throttle not work on the underlying device.
It's very easy to reproduce this issue, firstly create and mount the lvm:
sda       8:0    0    20G  0 disk
└─vg-lv 252:0    0    16G  0 lvm  /mnt
vg-lv: 0 33554432 linear 8:0 2048

Secondly, setup the cgv2 blkio writeback throttle:
mkdir /sys/fs/cgroup/cg
cd /sys/fs/cgroup/cg
echo 8:0 wbps=$((10*1024*1024)) >> io.max
echo $$ > cgroup.procs

Lastly, use dd and iostat to test and monitor:
dd if=/dev/urandom of=/mnt/test bs=1M
iostat -xmd 3 sda

Now you can see that the throttle is not working, and the throttle can work before this commit (you need to backport the commit 320fb0f9, which fixes a former throttle-not-working bug).
However, cgv2 blkio writeback throttle can still work well if you limit vg-lv and test vg-lv, or if you limit sda and test sda without lvm.
So, I was wondering if this is a bug or a feature-correction？

Thanks
Song
