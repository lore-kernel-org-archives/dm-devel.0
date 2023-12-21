Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2699B66ADA
	for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enk6M30+"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5942259ca62so288824eaf.3
        for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 02:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703154714; x=1703759514; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZD8z1FUk2T6KpKO8Jv7plBSlXMXIfnWviiaK22s/Yk=;
        b=enk6M30+PSwtBnK7z17QRenW7pW8cUhiVbgHcwyj5skBzV+xEDujs2goJM61W9/m7c
         DGt0Nc4Ma4aazdhAsNyEdBmlrIBKWZFt5oZAeCfz+VzwTwaiIq3TUQyGDoDDvqu7Ubvw
         F8yR6eNEO+LRnf4z2wkYQm8QVAIJcw7GFdiS1ZayA/Wkn9JzuzYSsrxIXDNFVcwlmoi8
         rdfP7BFEBzKUSYOCb9ViaDWx040zmJVD5rO1cL8JLr2KJ+6Pm2XyfFDIaYqkxuCO5anu
         Mw60+YncqJJsJ5sKOoQ9Iu4ZFF7Wp7GN9oROP9fMmdx71M77sPzJRO/fuKwcNKcbdoa+
         ma0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703154714; x=1703759514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZD8z1FUk2T6KpKO8Jv7plBSlXMXIfnWviiaK22s/Yk=;
        b=oy57uXdUhCqjIitrbTS4J0L69U82oOl97FjLV7swcOcz2sA2pcU0pBsZ31zp98CAH5
         3kZck9ouFP1ovZ8XLvPVCX51BiImruUioJh5fFj+OAfui4jkaismpaw6zOBo4GUPg0LI
         5I1sGL2iGDIvfcZcL/96OmpD2r8cHV5QfGXwUO1U2IxV+q4NCDno3XEemRHL3uDgGZ7E
         Bw7O8zsyBB4LvS4PR4/63Dq3TXLOuvd9xIA139ojZotxWgUiLqUOJTvq01f/MjNGuIYP
         xSG5EQPJwQ+k2aDdc8k8vdg6cSy6y3OCW9q4pSpGEz1AKyv6SFzTz31tGqsCmV+bwicj
         BI6A==
X-Gm-Message-State: AOJu0Yypj7erPo6nJOHmrY4Bbq8vwKKmp2pAQ6SdbkkLbYB8cgZnzMa8
	8PKFem6GUjOXKSvt3FIJNCM=
X-Google-Smtp-Source: AGHT+IG5a94rfK3uT3XPdn2OxFh4sx+GVG7NBoYw/A1PULj7Ma78X3JQMJYzi2oaM2ItLwKm6PCCdA==
X-Received: by 2002:a05:6358:91d:b0:170:8017:d357 with SMTP id r29-20020a056358091d00b001708017d357mr941327rwi.25.1703154714098;
        Thu, 21 Dec 2023 02:31:54 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id a25-20020a634d19000000b005c6617b52e6sm1274539pgb.5.2023.12.21.02.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:31:53 -0800 (PST)
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
Subject: [PATCH v7 1/5] block: Fix bio IO priority setting
Date: Thu, 21 Dec 2023 18:31:35 +0800
Message-Id: <20231221103139.15699-2-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
References: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
 <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
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
index 2eca76ccf4ee..d707ec056f34 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-ioprio.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -817,6 +818,14 @@ void submit_bio_noacct(struct bio *bio)
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
@@ -839,6 +848,7 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ac18f802c027..351e8283eda1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -40,7 +40,6 @@
 #include "blk-stat.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
-#include "blk-ioprio.h"
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
@@ -2919,14 +2918,6 @@ static bool blk_mq_can_use_cached_rq(struct request *rq, struct blk_plug *plug,
 	return true;
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
@@ -2957,8 +2948,6 @@ void blk_mq_submit_bio(struct bio *bio)
 			return;
 	}
 
-	bio_set_ioprio(bio);
-
 	if (plug) {
 		rq = rq_list_peek(&plug->cached_rq);
 		if (rq && rq->q != q)
-- 
2.34.1

