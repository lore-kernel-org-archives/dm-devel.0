Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D91FD9
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e97U/dMm"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5cd84c5442cso747146a12.1
        for <dm-devel@lists.linux.dev>; Sun, 17 Dec 2023 17:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702862911; x=1703467711; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk71sp729csxdUViLno20l6lcdfkMyL/Wdv2yhvpzTA=;
        b=e97U/dMmaBfdxxF5e+Wzmdd2mUVekkxFHBYdLzTN/fPWqt7896PoGx2JMdIUUX8HSv
         5mVcKqmo/viZu52PcPlnFaG17ac76n3LQu65GINqsK36lQLTVh3nI9OjJP287TFkEQoK
         iyvG0KivJR6UXHdn7i618EIey+FfVFLh2d8adubh2ffJEMFcxyAkcj7TX53XO0JTJy51
         1yfJhQVqYIBi176WwWQxowPTdLU7nn+Gf4hrWl/LM+ZAoghfwH3BZ6RQ5KfoU6LYVSi4
         BPCCwRBRxRUE4pk2eOjC3R9bnyFcU9rMQsIsK+SqN3qtLuiYWDKvUJTwLdxaADlouGqe
         qJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702862911; x=1703467711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kk71sp729csxdUViLno20l6lcdfkMyL/Wdv2yhvpzTA=;
        b=lT5TIO6b72xnNsXa37QS/m0gevbKwiiZfA8ns8UUjULaD6JN09WDk6XAKOGrR6vmkc
         Mw9jbQc2ZDVJF7rLYJczl3diQx7tgw/k9jO2MOBq72BbeMPfFAFRp40D1QNMQF4e4OfD
         AAxnOvjINR4lOdKM45GTIVsEf3R/6GX+bna3jsVNUOBJZo+XvrNB9Dxtoo3Ua1h2sjS6
         io1iX6kjgCsa0aFI2lSP5hMCW3D+qiVEiBh+eRv/nF4fUdY+hUwUtW2oNRQ8x/9uVD/F
         3R0Gr34d/zzH2FEBgeoHJc7kUjdHWCzL/kseDVgkl0Csf9Vvejyu2UB4k0juiWw2SNP4
         857g==
X-Gm-Message-State: AOJu0YzHMECiIBtjZBeFcIgg97uOse54pnsKLNUCaJ2vy3cG3l1Hr/Bo
	Q86eMXeoy2SewkHrq1hUqak=
X-Google-Smtp-Source: AGHT+IGIW8V+FXQE4QZVdghGOek1twkpYnBAF4/L86R85oU2yDUkfD2Mvu4T3PVI8IobBVO/NvrNFw==
X-Received: by 2002:a05:6a21:3e05:b0:194:38c1:51f2 with SMTP id bk5-20020a056a213e0500b0019438c151f2mr1810279pzc.59.1702862911236;
        Sun, 17 Dec 2023 17:28:31 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id s6-20020a625e06000000b006d64c4cb661sm1414014pfb.200.2023.12.17.17.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 17:28:30 -0800 (PST)
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
Subject: [PATCH v5 RESEND 1/5] block: Fix bio IO priority setting
Date: Mon, 18 Dec 2023 09:27:42 +0800
Message-Id: <20231218012746.24442-2-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
References: <CAMQnb4O15c=JC-zkCJD0U9GWwWko+Hez1iU7+cc3vhNSG86p9w@mail.gmail.com>
 <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Move bio_set_ioprio() into submit_bio():
1. Only call bio_set_ioprio() once to set the priority of original bio,
   the bio that cloned and splited from original bio will auto inherit
   the priority of original bio in clone process.

2. The IO priority can be passed to module that implement
   struct gendisk::fops::submit_bio, help resolve some
   of the IO priority loss issues.

This patch depends on commit 82b74cac2849 ("blk-ioprio: Convert from
rqos policy to direct call")

Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submit")

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 block/blk-core.c | 10 ++++++++++
 block/blk-mq.c   | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fdf25b8d6e78..68158c327aea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-ioprio.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -809,6 +810,14 @@ void submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
+static void bio_set_ioprio(struct bio *bio)
+{
+	/* Nobody set ioprio so far? Initialize it based on task's nice value */
+	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
+		bio->bi_ioprio = get_current_ioprio();
+	blkcg_set_ioprio(bio);
+}
+
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
@@ -831,6 +840,7 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2d11183f62e..a6e2609df9c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -40,7 +40,6 @@
 #include "blk-stat.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
-#include "blk-ioprio.h"
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
@@ -2922,14 +2921,6 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 	return rq;
 }
 
-static void bio_set_ioprio(struct bio *bio)
-{
-	/* Nobody set ioprio so far? Initialize it based on task's nice value */
-	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
-		bio->bi_ioprio = get_current_ioprio();
-	blkcg_set_ioprio(bio);
-}
-
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2963,8 +2954,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		return;
 
-	bio_set_ioprio(bio);
-
 	rq = blk_mq_get_cached_request(q, plug, &bio, nr_segs);
 	if (!rq) {
 		if (!bio)
-- 
2.34.1

