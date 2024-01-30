Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72571B47
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646417; cv=none; b=ZnXuwyAbVQQI2iVn1a+n8GLSRUGaUw5ernS4GGQkv6N+g6jkrtkLnQiSoz7DU7wEN5fPbKAoXsgx7ZxY4IUdZ80dgYMlQ1r5Ewob0+e5dsLgeBaG4aYlX+HL98v+PxvwWqxw925FdJmgBzyWhZMtZm5I5xNr6aQls3lwY0jeCp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646417; c=relaxed/simple;
	bh=DAHKXkgGX6dVy7GhunRGD1wJ+VIJeHNTtVOtYIcDKzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Uc4ZxeN6akKVwH+l/6+9xYN6CtVkmCqoYVf4JpsNxSrjpJAeImeJEWg1wtHHputg/utuwgOdaAtAYLffDShV8c3JThQ9AxO7L2j4gBvuXDcm8x/SM2thJ/XLhA8avB8NarsJj4ap17xq1DZAJwBg61Vbbw9hcbHnGXqGPkAp86M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-42a9c21f9ecso14546951cf.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646413; x=1707251213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfLVgoK5UewERlDGZW4uzJ+r/QTnm1HhBcO9MjZ8mO0=;
        b=SrnTxhT1QXPRAUBsFbCS5qAgYELvVhT9ZfXSJs3iesi4QcnQRxh/oqT8ON70c7Kn3N
         97VokjTmthpd87Ozw4As3pL14DVFFcUXte2GTSMNXp3fYeyvNW5E+EP7S+FmUWPFi4pP
         28rXI6vhrWgYeeSFGUwTyedvZSQSQW0+CBTXEvOECLxNxmEbZRoFXf93bZtu6l3v2T33
         Bg8w8Ns0ciqEukQkZXPZMG/EHIbmz4JakdLaIRobqD5lVR0HRU9WZyJGHms2W5MTL8IT
         xaDiQQ91d3nmU5gxwoAgDawe2JwhDoMcphbTVoGT0RDB9Bt0HKwlHOsRdpOkxaeYNHhl
         kGag==
X-Gm-Message-State: AOJu0YztfoQ8gpylA9z0A9Si16GUuma4aNa4l1wei0jX0GqKi9G2kdcP
	ktjaMGj8VBStRgW2CN52phKzzGUVP89LGphN+n1vtfQBAnmWPM2mkRlNbSf5OQ==
X-Google-Smtp-Source: AGHT+IH6mATX/KHzFYyK7VQNDRL07dVKXIjYJyfwoY/OnHBQNtdI5eHSqQjVJuWoJe7ytWzZhKgSag==
X-Received: by 2002:ac8:5f10:0:b0:42a:6333:e85a with SMTP id x16-20020ac85f10000000b0042a6333e85amr11417468qta.114.1706646413121;
        Tue, 30 Jan 2024 12:26:53 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id s14-20020a05620a16ae00b0078199077d0asm2389194qkj.125.2024.01.30.12.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:26:52 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk,
	hongyu.jin.cn@gmail.com
Cc: ebiggers@kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v9 0/5] Fix I/O priority lost in device-mapper
Date: Tue, 30 Jan 2024 15:26:33 -0500
Message-Id: <20240130202638.62600-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've revised the patch headers a bit (patch 1 more so than others).

Jens, please let me know how you'd like to see patch 1 land
upstream. I feel like it should probably go as a fix for 6.8-rcX; I
have some DM fixes I will be sending Linus this week and can include
it (with your Ack of course). But you're welcome to pick it up just
like any other block fix.

Thanks,
Mike

Hongyu Jin (5):
  block: Fix where bio IO priority gets set
  dm io: Support IO priority
  dm bufio: Support IO priority
  dm verity: Fix IO priority lost when reading FEC and hash
  dm crypt: Fix IO priority lost when queuing write bios

 block/blk-core.c                              | 10 +++++
 block/blk-mq.c                                | 10 -----
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
 17 files changed, 102 insertions(+), 83 deletions(-)

-- 
2.40.0

