Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296575CD1F
	for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5CCI+Pq"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d04c097e34so42873685ad.0
        for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 03:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702379531; x=1702984331; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/h+WfEQxtNqWLD65fthYDEoIBJTS6GEtAIchnOXQlY=;
        b=Z5CCI+PqmL/NKkORQ7lPEbeVM2vGMSShM3awijbScCeLgp4ohJIm0vNWWuROBlZyZ+
         +elbpp48IUBzWTDL58WXs7GFNndnkSaeRVc2pXOeduceZ3JdXnqBKHopWoGIQxKF2nwE
         pkbF51Fgl6H6JR4k00Ivcp8lsmDweJEKAZIKtlcf6Azq66dPK3EBXeQiWO1Jt2XtLWMJ
         hKlKJS1IbEGpZxMhaFnnm2BUMndy0o4CTGSfWUFYvJQb4i6NGbq2Om4c+uA97BCF/+EK
         ukIUzl3XSKBhHgI1+8rNEvCjJS84YN9sYOcBpXiYBTwcfTMzF7T7ZVpjDmxn2z1IJHct
         Cd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702379531; x=1702984331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/h+WfEQxtNqWLD65fthYDEoIBJTS6GEtAIchnOXQlY=;
        b=u+VZL/zADuqtTIhGnAj5ZTqvZVknjtUe6H31mAXFgwLXb96RlvOcul0G867G1ne7iI
         whvD0S1u6v7peraZ49pp9ldUgvYPEyk2cDGsk4DGrgAgZD0fmO5KiFtk1+aQmQnHvvtZ
         TIlIEhd982A6tKkXm/MyGaW0iylKwAGT4tx+qDEV/ihb/NmRxkUP6dxB61c1B3p6PNEz
         Ej4oFmo8Z6w5FI1f06upDd6md+BB4+rGWRe/0Q9klkhYVH1Wl9grvvFVZF16449NSjFv
         RHD6eodVdWReGnkGMY7XZLAxkPMEB6qGk9YCICS5yMzQGufw7++21oL3kqT0hMkUa9z2
         JILQ==
X-Gm-Message-State: AOJu0YzhkVdf1pZA1oB/ZqzAACM4S/kGSNSAWMUdprvNqhtkjeyG6nlS
	XFgKXvk6S1wiFU7IN+JDm1c=
X-Google-Smtp-Source: AGHT+IGBiBDfitZYDKoB131GyaEEkPbtMG+AiK4V16DRcHToH+3lCj+wV3YCBPG1lcsUeZotqWYcAw==
X-Received: by 2002:a17:902:ea0b:b0:1cf:b4bb:9bdc with SMTP id s11-20020a170902ea0b00b001cfb4bb9bdcmr7289304plg.9.1702379531377;
        Tue, 12 Dec 2023 03:12:11 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902ee5500b001d0511c990csm8345453plo.237.2023.12.12.03.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 03:12:10 -0800 (PST)
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
Subject: [PATCH v4 0/5] Fix I/O priority lost in device-mapper
Date: Tue, 12 Dec 2023 19:11:45 +0800
Message-Id: <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZXeJ9jAKEQ31OXLP@redhat.com>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

A high-priority task obtains data from the dm-verity device using the
RT IO priority, during the verification, the IO reading FEC and hash
by kworker loses the RT priority and is blocked by the low-priority IO.
dm-crypt has the same problem in the process of writing data.

This is because io_context and blkcg are missing.

Move bio_set_ioprio() into submit_bio():
1. Only call bio_set_ioprio() once to set the priority of original bio,
   the bio that cloned and splited from original bio will auto inherit
   the priority of original bio in clone process.

2. Make the IO priority of the original bio to be passed to dm,
   and the dm target inherits the IO priority as needed.

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
**

Hongyu Jin (5):
  block: Fix bio IO priority setting
  dm: Support I/O priority for dm_io()
  dm-bufio: Support I/O priority
  dm verity: Fix I/O priority lost when read FEC and hash
  dm-crypt: Fix lost ioprio when queuing write bios

 block/blk-core.c                              | 10 ++++++
 block/blk-mq.c                                | 11 ------
 drivers/md/dm-bufio.c                         | 36 ++++++++++---------
 drivers/md/dm-crypt.c                         |  1 +
 drivers/md/dm-ebs-target.c                    |  8 ++---
 drivers/md/dm-integrity.c                     |  7 +++-
 drivers/md/dm-io.c                            |  1 +
 drivers/md/dm-log.c                           |  1 +
 drivers/md/dm-raid1.c                         |  2 ++
 drivers/md/dm-snap-persistent.c               |  5 +--
 drivers/md/dm-verity-fec.c                    |  5 +--
 drivers/md/dm-verity-target.c                 |  8 +++--
 drivers/md/dm-writecache.c                    |  4 +++
 drivers/md/persistent-data/dm-block-manager.c |  6 ++--
 include/linux/dm-bufio.h                      |  6 ++--
 include/linux/dm-io.h                         |  2 ++
 16 files changed, 69 insertions(+), 44 deletions(-)

-- 
2.34.1

