Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55BFBED
	for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3QAenMr"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b3a8366e13so283531239f.1
        for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 02:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702464159; x=1703068959; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZRgNeWGWtTYGNKv71Mh1jMa9BIytCfGLi7OUevxvzQ=;
        b=G3QAenMr+wNSF4D+SScIepW++onax/+uvca6BTqQzJnVIq/FNQpVJq09EkBhYZMU41
         iri9KkhCiWat6uCMa61fWJ0RuDbaZoO+rijw1iqYOCmA32vuZjspDk/V5J9OBES+PXHH
         XNxKq+jBEIJL2+M2etk0r0EbGisqNlnSbpLXY+Y7a+0XBAJGL8wtDImhlHDUZ+Ke17vg
         AwRRYJR7PXR8zufgO1bWctaVt1483FeClbIUuOb0VYWxgWpox2wli9ks/t00K988DOjm
         WAvfLM/SDHjAqtpXaDfTO1ruTago0CbSoxSRydmF8NMtPM42aBZv+S2eLMThT7tITpiT
         zx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702464159; x=1703068959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZRgNeWGWtTYGNKv71Mh1jMa9BIytCfGLi7OUevxvzQ=;
        b=rI6jyl1kIe2rtmTokBWcew+P4ya+KbnVP/SyZCxsaqtXAIiqnR/Y7p4aeNyOsq9UjN
         pXZtoWRNCVcjlVA8syFseW5GPLc5hSbVE+lCpqFRYOmtOl5cFr3mafk5v8OUggPhEb6n
         fPxGLVs6uI3gIa56M5esYTHnobovNT4OE88+Vy25z4ZX/dvqccVyCDHHvrwVcYJPORI2
         6vwt/PUWGqdtiwyXEG8uFF59DuenPYWyCsxo7HEU/BKypUmdq90qpY4n18Ca0Ab/S+oX
         YObmXkYBcGxSpk3ADvAaq0q+Hhn+0gxxm8xRtASXCZ/W3qe54Hb4ZCZVicHMqyRRCPZa
         kfUg==
X-Gm-Message-State: AOJu0Yw7c4RSBTxZg4ROaERehsCRyEn8j1gbe1iePU7qY01AseGKlB+X
	kRwEXNsTswUDS7l2WmRhQdU=
X-Google-Smtp-Source: AGHT+IEWH+PnJ3icKszS+pZricy2BL/GswKpdR64jbTG7pNMSixmN2MzYyNxiFV8F2elcLQA5NAs5A==
X-Received: by 2002:a5e:8e06:0:b0:7b7:51d1:ab82 with SMTP id a6-20020a5e8e06000000b007b751d1ab82mr4380003ion.30.1702464158900;
        Wed, 13 Dec 2023 02:42:38 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id c11-20020a6b4e0b000000b0078647b08ab0sm3058186iob.6.2023.12.13.02.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 02:42:38 -0800 (PST)
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
Date: Wed, 13 Dec 2023 18:42:11 +0800
Message-Id: <20231213104216.27845-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
References: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
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


All changes are based on commit 9bacdd8996c7 ("Merge tag 'for-6.7-rc1-tag'
of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux")
on the master branch.


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
 block/blk-mq.c                                | 11 ------
 drivers/md/dm-bufio.c                         | 39 ++++++++++---------
 drivers/md/dm-crypt.c                         |  1 +
 drivers/md/dm-ebs-target.c                    |  8 ++--
 drivers/md/dm-integrity.c                     | 12 +++---
 drivers/md/dm-io.c                            | 23 ++++++-----
 drivers/md/dm-kcopyd.c                        |  4 +-
 drivers/md/dm-log.c                           |  4 +-
 drivers/md/dm-raid1.c                         |  6 +--
 drivers/md/dm-snap-persistent.c               |  8 ++--
 drivers/md/dm-verity-fec.c                    |  5 ++-
 drivers/md/dm-verity-target.c                 |  8 +++-
 drivers/md/dm-writecache.c                    |  8 ++--
 drivers/md/persistent-data/dm-block-manager.c |  6 +--
 include/linux/dm-bufio.h                      |  5 +--
 include/linux/dm-io.h                         |  3 +-
 17 files changed, 85 insertions(+), 76 deletions(-)

-- 
2.34.1

