Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623BD65A8F
	for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 10:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nsn00jxb"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6d93d15db24so602739b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 02:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703154710; x=1703759510; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3txwa/c9776nsY8G7pkBt0algA+V8V5O9TtP4wNx04=;
        b=nsn00jxbCbS9+E0h3LgaOj8c1stgX+lcXAg2RLUfw7kXaeHAzJDpPNSaHe0p4zBYFr
         XoBjFgLfjTeTQlxSlT2t37piuAJnNLOUsePR3iEzWihZYm0KeQ7E3e6NMqWeoyNo42wz
         /fJhmUYdHckdvRPGNBGPz72fx4n5DvMrqg3uP+15EtMErw+xb5GSZyuUDqSzsye+fAZI
         ffZS94G8SiNBq5l0sKFi5iQOsGhookK54CCNBrXVn5eEGXtp01fgFN9QaQiO+D2pD5QW
         wPxaEfMmLe+BYqX/DpVDhW7FpAm7L43UmcofSY0AWYF7/kCfx3eKNklsv93GCyNcoBqw
         LYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703154710; x=1703759510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3txwa/c9776nsY8G7pkBt0algA+V8V5O9TtP4wNx04=;
        b=AGxOYDjqigtBttH/UCEGpMlg5dYZfkV7LB8jYkmZlT89tW3jP7W/KEyfKy+t3QSvFM
         db62mqbQDijpcGOZJNhPOesE/5Ga6y8FU9fV8tpopXzA7c5/dsSpWhp5srEFuza9ngo8
         4coTjw/+J3hu26j8E6mmVefQkCCvE2NNSngOgDZzSGC7Uy/1iwEdn4E0Bqy7aZpcOXxx
         9ejOBNYg4TzARaOXjXVHmaZtErXzY091poPq6wAZ9+r2thlzeWqmTVu9jYvkGk73iSoc
         zWzVWqsKvacFEk1BzCXNSdPEt0t/hxF4DDHhie4Oa9vOSDEXlzUyFExkkahm0ca7vhw2
         UcDw==
X-Gm-Message-State: AOJu0YxCqiY2yQPDkQQ65wHiPLB/UqjBNi7GXRcE49PmaM5SJGnLPkLZ
	pw4WKGa2A8v+aE7UIKSHckg=
X-Google-Smtp-Source: AGHT+IHqqsd5dS5VG1PZPadONMtL8cC5ZqjsRAgoLSdOgKER9eZKzkyU//MGHM71lYYtq/LyyRjmCw==
X-Received: by 2002:a05:6a20:5b12:b0:18b:e5f7:25c5 with SMTP id kl18-20020a056a205b1200b0018be5f725c5mr1146242pzb.11.1703154709613;
        Thu, 21 Dec 2023 02:31:49 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id a25-20020a634d19000000b005c6617b52e6sm1274539pgb.5.2023.12.21.02.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:31:49 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v7 0/5] Fix I/O priority lost in device-mapper
Date: Thu, 21 Dec 2023 18:31:34 +0800
Message-Id: <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
References: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

High-priority tasks get data from dm-verity devices via RT IO priority,
I/O will lose RT priority when reading FEC and hash values via kworker
submission IO during verification, and the verification phase may be
blocked by low-priority IO.

Dm-crypt has the same problem in the data writing process.

This is because io_context and blkcg are missing.

Move bio_set_ioprio() into submit_bio():
1. Only call bio_set_ioprio() once to set the priority of original bio,
   the bio that cloned and splited from original bio will auto inherit
   the priority of original bio in clone process.

2. Make the IO priority of the original bio to be passed to dm,
   and the dm target inherits the IO priority as needed.

All changes are based on master branch commit 2cf4f94d8e86 ("Merge tag
'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

Changes in v7:
  - Modify patch 4: change dm-verity-fec.c
Changes in v6:
  - Rebase patch and resolve conflict for patch 1, 3, 4
  - Modify patch 4: fec_read_parity() follow the priority of original
    bio
  - Update commit message
Changes in v5:
  - Rewrite patch 2, add ioprio parameter in dm_io();
  - Modify dm_io() in patch 3 
Changes in v4:
  - Modify commit message by Suggestion
  - Modify patch for dm-crypt
Changes in v3:
  - Split patch for device-mapper
  - Add patch to fix dm-crypy I/O priority question
  - Add block patch to review together
  - Fix some error in v2 patch
Changes in v2:
  - Add ioprio field in struct dm_io_region
  - Initial struct dm_io_region::ioprio to IOPRIO_DEFAULT
  - Add two interface

Hongyu Jin (5):
  block: Fix bio IO priority setting
  dm: Support I/O priority for dm_io()
  dm-bufio: Support I/O priority
  dm verity: Fix I/O priority lost when read FEC and hash
  dm-crypt: Fix lost ioprio when queuing write bios

 block/blk-core.c                              | 10 +++++
 block/blk-mq.c                                | 11 -----
 drivers/md/dm-bufio.c                         | 43 +++++++++++--------
 drivers/md/dm-crypt.c                         |  1 +
 drivers/md/dm-ebs-target.c                    |  8 ++--
 drivers/md/dm-integrity.c                     | 12 +++---
 drivers/md/dm-io.c                            | 23 +++++-----
 drivers/md/dm-kcopyd.c                        |  4 +-
 drivers/md/dm-log.c                           |  4 +-
 drivers/md/dm-raid1.c                         |  6 +--
 drivers/md/dm-snap-persistent.c               |  8 ++--
 drivers/md/dm-verity-fec.c                    | 21 +++++----
 drivers/md/dm-verity-target.c                 | 13 ++++--
 drivers/md/dm-writecache.c                    |  8 ++--
 drivers/md/persistent-data/dm-block-manager.c |  6 +--
 include/linux/dm-bufio.h                      |  5 ++-
 include/linux/dm-io.h                         |  3 +-
 17 files changed, 102 insertions(+), 84 deletions(-)


base-commit: 2cf4f94d8e8646803f8fb0facf134b0cd7fb691a
-- 
2.34.1

