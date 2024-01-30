Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E051B71B5C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646417; cv=none; b=hdick11X/zq8bj0S7RSTZ7aeiQ/CtM4lmDjSvlIhghmabPy5R7rrlcCXhLwvL/6leY7YSBntsu2VNEaMOZurw+YQ1ks8Tbb809XAWXzCklVhcgsF2n/kErRuVv9s5CJHUPDoirYn3MO+WYzm8N1a45AqJMUIA5GRyqehWuaVND4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646417; c=relaxed/simple;
	bh=kel0RHUbBvs8tO6xKBCk8jeoGiLfvfN2wpXiLo+ZVmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u2XdweuJY4+nrEpOFuE+fX+FjgjhaIwygFRP+HgPC+nXNp5BE6y43C21PMOP7h0Fp4Qmb2R7Mev//vVWWMrhecswBZdWATQo59uz/iZhAzZDaPGLqkqNs6OCFixELpOmjwBm8t0N3sB02/0vrtRhKC4OCegaR831SgxZxgeJzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7810827e54eso392637185a.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646415; x=1707251215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4NzVswFhknsHsE2I73Hxb3OMJY4C5qnGxt15cREUuA=;
        b=R97i5OAjz81pl5VNq13+nPSzkTVOMpeB7GZOCfACe+WYxIzf+eIqbDKmEYhD+LtwGE
         16NG6G6xIle9mmiPwX5L+zHRJqTmN0ejR960rRbF3qGvkigv8QOlHdoqRPNwDv0SlfK2
         GQGW4kFGU77u/6tBukqhBQF659Rpp4kDQT6kodKBAiLYMPx8ZoH+wt9hgqY5xIDsVryj
         LUe25dnOIdr9JGBlMI0DhSywvWNkVHcbuAVx0BE/DQUSSBGQ+sQ2gxCcldz8soceprpi
         D28f9MJRQepyE73L5sd+qFNMO0YEC0+c70uVaa0jRQMgCGDuaI4P2mKlIVZNnF7CwfoT
         SHDg==
X-Gm-Message-State: AOJu0YzhYiCJ88t1eX3ne8i2UjkSmgrBFzRPJa4DX/KQifFzWtIqw2V5
	n2HYEwMftPiPNKUvwfviSB2m8K+oFymXPifz3Z/8bq0U6HD3IQSICb6qmLkthw==
X-Google-Smtp-Source: AGHT+IFpLIxnrcy4wWyylwYAuCg+jEkWdYtTtMTCpwYkHetNXFTF7GEQRtYLL6vY2tOVCAWUdIvacw==
X-Received: by 2002:a05:620a:4141:b0:783:fbc1:9c2a with SMTP id k1-20020a05620a414100b00783fbc19c2amr6701172qko.29.1706646414878;
        Tue, 30 Jan 2024 12:26:54 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id p4-20020a05620a112400b00783f9f6d5b7sm2284443qkk.10.2024.01.30.12.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:26:54 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk,
	hongyu.jin.cn@gmail.com
Cc: ebiggers@kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	Yibin Ding <yibin.ding@unisoc.com>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v9 1/5] block: Fix where bio IO priority gets set
Date: Tue, 30 Jan 2024 15:26:34 -0500
Message-Id: <20240130202638.62600-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240130202638.62600-1-snitzer@kernel.org>
References: <20240130202638.62600-1-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Commit 82b74cac2849 ("blk-ioprio: Convert from rqos policy to direct
call") pushed setting bio I/O priority down into blk_mq_submit_bio()
-- which is too low within block core's submit_bio() because it
skips setting I/O priority for block drivers that implement
fops->submit_bio() (e.g. DM, MD, etc).

Fix this by moving bio_set_ioprio() up from blk-mq.c to blk-core.c and
call it from submit_bio().  This ensures all block drivers call
bio_set_ioprio() during initial bio submission.

Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submit")
Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
[snitzer: revised commit header]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
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
2.40.0

