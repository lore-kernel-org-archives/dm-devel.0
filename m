Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669CAF9C2
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706074573; cv=none; b=G3CsRkT8YY3UJ9qIAoPiKfQbuejI+jIfhK6ZeYHw+E8hyfr1IPV1gT2QHNW28q4+8laH5v1/SeN0+i0DV3NrnYBO0r5LmGcAdTci20j1ZXQcsPYzjdX6SAT8719N+TFRKr+tLTjPzj2Ift+A7X2f/HHLXvBrJNwz/WvItVIi5I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706074573; c=relaxed/simple;
	bh=vzhS6Yw0l/Z58XSVDLaOu78FXLMhzplmG4xTTfPt9C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s41ZTpgcIjqYckfraVW3krSeUHVfXuVGPM3o/8gs9+Tuz5Sh6YJTw9C2C5T0UfvpudYgsN2MQ0yezFM+yUHD5x77YG/bzey4hk9Kp8yjFvSFTLClfRfY5zO+FbojAA4VpMju8bi+hKTiJeejb+M5ROKN7Uzt4aLxbQ20+u2Op78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DakdbBVa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DakdbBVa"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d74678df08so17446005ad.1
        for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 21:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706074569; x=1706679369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKyOiEcqJPFq+lUKHVHdFYPT0CvR+VKFddHQFhQnJeY=;
        b=DakdbBVaStHWpChgqg/yOcjAr1fYs6hwEmPr9QJdDJNM+z3xLZ4QGncNYb8cFb855w
         VqH12tAPpe8FjNU1ycXmuS4RGIzLXnwru4rdvQJ/XDCSDOriS2hiWpPVVR0m7Jox7Ntf
         DScl1rEdvNSjH+Tpl59NNv8eD1xiLHjqr2x4CiUXUnZBXqZvPV3akUOlzNe4+c9pbps/
         W0UD2m5NqnSMbvRG7fvrxSiV6ikywgRVvfnK317ONa6Koq9b6RlUX5+DnRQ65pIu4gde
         1Q3mFQkIjjggKojrL1yKQqfWouIXhQ48jwvZcMqvrJruqk0ZoWUpUUmw5efBfdnm1TCq
         iPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706074569; x=1706679369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKyOiEcqJPFq+lUKHVHdFYPT0CvR+VKFddHQFhQnJeY=;
        b=YQ1H4pgBLcFZKsgZZqi2ovwN0h8IeWbEOBMDRADVChEhbS1MW7JvtvjBIKUhcMwkwG
         WLmxFIXn5IHjmVa69rXBrLLP58nGklRLfGWOGfUfPdu7fe1AZx+N38MLt6vZel2xgJBd
         0dnRpXiKRboKRMzXuh/eEDoJytBvMB1YARoHYMKuTXK0G11ogBbvIBvUWDyrp+lvy3XP
         jmhjrdWkWE1qt5jLQxWmbo1MikVU1I0hsQIa8RKnpSgpTPNWi0pP7IDpXg+ejyXlQwhB
         LjQs658l4ZByzWoK3OwF/+Hu0tkZXE5ACFFAWn2XPqwLadoPju+hEFpr4QNTQKj2gAwZ
         LxAw==
X-Gm-Message-State: AOJu0YzWnn1O9Ejqlap9B0t+BuAvicYkDYDVHe++S8t9lT4k/CoG4y45
	27LLxHYfS9Wg4+OjGRzptNA3GI5j9FGjP/Eh6TnZZp765xjq+gxU
X-Google-Smtp-Source: AGHT+IFvPUKiLFPOToglddyZowKK8F5ajBLiJeYrmszzYx2ohL1cCnYFiS65XZxb9RVhy1DlScJb4A==
X-Received: by 2002:a17:902:a982:b0:1d7:5bde:7c2f with SMTP id bh2-20020a170902a98200b001d75bde7c2fmr197526plb.21.1706074569565;
        Tue, 23 Jan 2024 21:36:09 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id kt6-20020a170903088600b001d755acec64sm4015663plb.189.2024.01.23.21.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 21:36:09 -0800 (PST)
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
Subject: [PATCH v8 1/5] block: Fix bio IO priority setting
Date: Wed, 24 Jan 2024 13:35:52 +0800
Message-Id: <20240124053556.126468-2-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240124053556.126468-1-hongyu.jin.cn@gmail.com>
References: <20231221103139.15699-6-hongyu.jin.cn@gmail.com>
 <20240124053556.126468-1-hongyu.jin.cn@gmail.com>
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
 block/blk-mq.c   | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 11342af420d0..de771093b526 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-ioprio.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -833,6 +834,14 @@ void submit_bio_noacct(struct bio *bio)
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
@@ -855,6 +864,7 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index aa87fcfda1ec..2dc01551e27c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -40,7 +40,6 @@
 #include "blk-stat.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
-#include "blk-ioprio.h"
 
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
 static DEFINE_PER_CPU(call_single_data_t, blk_cpu_csd);
@@ -2944,14 +2943,6 @@ static bool blk_mq_use_cached_rq(struct request *rq, struct blk_plug *plug,
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
@@ -2976,7 +2967,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	blk_status_t ret;
 
 	bio = blk_queue_bounce(bio, q);
-	bio_set_ioprio(bio);
 
 	if (plug) {
 		rq = rq_list_peek(&plug->cached_rq);
-- 
2.34.1

