Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5511EB46
	for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTy9FfAB"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7b459364167so155710039f.2
        for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 01:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702285229; x=1702890029; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wju9poNbHmK4kTzadequgCrVsBMHqrILz+bPct1uH60=;
        b=aTy9FfABkeMreYSQukMeN08UvDMrwBQ7oWXoe+L3QYytq79oVCb7jkJv685TpR+QwA
         QiIGFVZi55WLrQipLIpwg+zZaARCZ1xxqL2DfzByHHCNKKkYYskbMpTcLNYaZBtHx24m
         2fv0jw9dIuDmI2pR27WLEp7uSFa9+7xuPyHq9kOhX9VcH3skzU5cPiqf+Ij5xoxqtO1n
         WmNW2wVIjy/b+jHugcyW6whhsFuCD8aDwIGtlea2MXWWIi9UQ54HdlOHLKnrBmjFODqI
         +HgS4lWruaGnTtUKTYK5pZRSAGXrVO/Xk45Is5/HXLxnD08/kWnMWcdWzKoTnXikL/V3
         CLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702285229; x=1702890029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wju9poNbHmK4kTzadequgCrVsBMHqrILz+bPct1uH60=;
        b=BHdmQV+uNO5TrIbcXxmgo4NyZjldXhHwmdNZnSEOlxFyb1RoafFOg/cQfDOEWCvIr/
         H0R04+QVUZFI+tDialXMIsG4+Tz1rEHqz3oY+o5JFcawDa5P+7uvdn8ZtfY2MW5+aVzW
         /tVaujMLkrDTPFzfrS6myPfM/IAcXnn+susJRGaBFIp4pp7uw+aFPVFprZD0I6JQVn/a
         GljYSwu2jncFEZnyQda9iRPsuH2uMIL9TUOa68AwgzXN6LGuZH8N0R/cmTpHUdly8RAR
         cEbbw10ViXQevBtsjkRWxbu3lBiwcktga6Okweoo05f2bST8JzN9nEdh5u2fWg2r54Qv
         l9dQ==
X-Gm-Message-State: AOJu0Yz5tdxJ9/2uVLugj227YOqxEnx7YZR+ef4f/V0dk5UiYuhus3ne
	tn9bFeWljmnvMDxqQ5X9Zvw=
X-Google-Smtp-Source: AGHT+IHIe+3rcfUvNTZxne5xKhXuPdaWNBjzuNkIH8cHvulBBZYJkOFjOqXZffDOmywwrKNKMPAmHA==
X-Received: by 2002:a05:6e02:1e04:b0:35d:6d3a:7818 with SMTP id g4-20020a056e021e0400b0035d6d3a7818mr4353004ila.9.1702285229286;
        Mon, 11 Dec 2023 01:00:29 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id f14-20020a056e020b4e00b0035b0b05189bsm2211216ilu.38.2023.12.11.01.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 01:00:28 -0800 (PST)
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
Subject: [PATCH v3 0/5] Fix I/O priority lost in device-mapper
Date: Mon, 11 Dec 2023 16:59:55 +0800
Message-Id: <20231211090000.9578-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <df68c38e-3e38-eaf1-5c32-66e43d68cae3@ewheeler.net>
References: <df68c38e-3e38-eaf1-5c32-66e43d68cae3@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

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
  block: Optimize bio io priority setting
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

